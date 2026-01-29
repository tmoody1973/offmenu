import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Result of a Foursquare restaurant search.
class FoursquareSearchResult {
  final List<Restaurant> restaurants;
  final bool isFromCache;
  final String? warning;

  FoursquareSearchResult({
    required this.restaurants,
    this.isFromCache = false,
    this.warning,
  });
}

/// Service for interacting with Foursquare Places API.
class FoursquareService {
  // New Foursquare Places API host (migrated from api.foursquare.com/v3)
  static const String _baseUrl = 'https://places-api.foursquare.com';
  static const String _apiVersion = '2025-06-17';
  static const Duration _cacheTtl = Duration(hours: 24);
  static const int _maxRetries = 4;
  static const Duration _initialBackoff = Duration(seconds: 1);
  static const Duration _maxBackoff = Duration(seconds: 16);
  static const Duration _timeout = Duration(seconds: 30);

  final String _apiKey;
  final http.Client _httpClient;
  final Session _session;

  FoursquareService({
    required String apiKey,
    required Session session,
    http.Client? httpClient,
  })  : _apiKey = apiKey,
        _session = session,
        _httpClient = httpClient ?? http.Client();

  /// Search for restaurants near a location.
  Future<FoursquareSearchResult> searchRestaurants({
    required double latitude,
    required double longitude,
    required int radiusMeters,
    List<String>? cuisineTypes,
    int limit = 50,
  }) async {
    final cacheKey = _generateCacheKey(
      latitude: latitude,
      longitude: longitude,
      radiusMeters: radiusMeters,
      cuisineTypes: cuisineTypes,
      limit: limit,
    );

    // Check cache first
    final cachedResponse = await _getCachedResponse(cacheKey);
    if (cachedResponse != null) {
      final restaurants = _parseRestaurantsFromJson(cachedResponse);
      return FoursquareSearchResult(
        restaurants: restaurants,
        isFromCache: true,
      );
    }

    // Build query parameters
    final queryParams = <String, String>{
      'll': '$latitude,$longitude',
      'radius': radiusMeters.toString(),
      'categories': '13065', // Restaurants category in Foursquare
      'limit': limit.toString(),
      'fields':
          'fsq_place_id,name,location,price,rating,categories,hours,menu,tastes',
    };

    // Add cuisine filter if provided
    if (cuisineTypes != null && cuisineTypes.isNotEmpty) {
      final categoryIds = _mapCuisinesToCategories(cuisineTypes);
      if (categoryIds.isNotEmpty) {
        queryParams['categories'] = categoryIds.join(',');
      }
    }

    try {
      final response = await _makeRequestWithRetry(
        endpoint: '/places/search',
        queryParams: queryParams,
      );

      if (response == null) {
        // API failure - try to return cached data if available
        return FoursquareSearchResult(
          restaurants: [],
          warning: 'Unable to fetch restaurants. Please try again later.',
        );
      }

      // Cache the successful response
      await _cacheResponse(cacheKey, response);

      final restaurants = _parseRestaurantsFromJson(response);
      return FoursquareSearchResult(restaurants: restaurants);
    } catch (e) {
      _session.log(
        'Foursquare search error: $e',
        level: LogLevel.error,
      );
      return FoursquareSearchResult(
        restaurants: [],
        warning: 'Error searching restaurants: ${e.toString()}',
      );
    }
  }

  /// Get detailed information for a restaurant including dish-level data.
  Future<Restaurant?> getRestaurantDetails(String fsqId) async {
    final cacheKey = 'details:$fsqId';

    // Check cache first
    final cachedResponse = await _getCachedResponse(cacheKey);
    if (cachedResponse != null) {
      return _parseRestaurantDetails(cachedResponse);
    }

    final queryParams = <String, String>{
      'fsq_place_id': fsqId,
      'fields':
          'fsq_place_id,name,location,price,rating,categories,hours,menu,tastes,description',
    };

    try {
      final response = await _makeRequestWithRetry(
        endpoint: '/places/details',
        queryParams: queryParams,
      );

      if (response == null) {
        return null;
      }

      await _cacheResponse(cacheKey, response);
      return _parseRestaurantDetails(response);
    } catch (e) {
      _session.log(
        'Foursquare details error for $fsqId: $e',
        level: LogLevel.error,
      );
      return null;
    }
  }

  /// Make an API request with exponential backoff retry.
  Future<String?> _makeRequestWithRetry({
    required String endpoint,
    required Map<String, String> queryParams,
  }) async {
    var backoff = _initialBackoff;

    for (var attempt = 0; attempt < _maxRetries; attempt++) {
      try {
        final uri = Uri.parse('$_baseUrl$endpoint').replace(
          queryParameters: queryParams,
        );

        _session.log(
          'Foursquare request: $uri',
          level: LogLevel.info,
        );

        final response = await _httpClient
            .get(
              uri,
              headers: {
                'Authorization': 'Bearer $_apiKey',
                'Accept': 'application/json',
                'X-Places-Api-Version': _apiVersion,
              },
            )
            .timeout(_timeout);

        _session.log(
          'Foursquare response: ${response.statusCode}',
          level: LogLevel.info,
        );

        if (response.statusCode == 200) {
          return response.body;
        }

        if (response.statusCode == 401) {
          _session.log(
            'Foursquare API authentication error',
            level: LogLevel.error,
          );
          return null;
        }

        if (response.statusCode == 429) {
          _session.log(
            'Foursquare rate limit hit, backing off for ${backoff.inSeconds}s',
            level: LogLevel.warning,
          );
          await Future.delayed(backoff);
          backoff = backoff * 2;
          if (backoff > _maxBackoff) backoff = _maxBackoff;
          continue;
        }

        if (response.statusCode >= 500) {
          _session.log(
            'Foursquare server error: ${response.statusCode}',
            level: LogLevel.warning,
          );
          await Future.delayed(backoff);
          backoff = backoff * 2;
          if (backoff > _maxBackoff) backoff = _maxBackoff;
          continue;
        }

        _session.log(
          'Foursquare API error: ${response.statusCode} - ${response.body}',
          level: LogLevel.error,
        );
        return null;
      } on TimeoutException {
        _session.log(
          'Foursquare request timeout, attempt ${attempt + 1}',
          level: LogLevel.warning,
        );
        await Future.delayed(backoff);
        backoff = backoff * 2;
        if (backoff > _maxBackoff) backoff = _maxBackoff;
      } catch (e) {
        _session.log(
          'Foursquare request error: $e',
          level: LogLevel.error,
        );
        if (attempt == _maxRetries - 1) return null;
        await Future.delayed(backoff);
        backoff = backoff * 2;
        if (backoff > _maxBackoff) backoff = _maxBackoff;
      }
    }

    return null;
  }

  /// Generate a cache key from query parameters.
  String _generateCacheKey({
    required double latitude,
    required double longitude,
    required int radiusMeters,
    List<String>? cuisineTypes,
    required int limit,
  }) {
    final cuisineStr = cuisineTypes?.join(',') ?? '';
    return 'search:${latitude.toStringAsFixed(4)}:${longitude.toStringAsFixed(4)}:$radiusMeters:$cuisineStr:$limit';
  }

  /// Get cached response from database.
  Future<String?> _getCachedResponse(String cacheKey) async {
    try {
      final cached = await CachedFoursquareResponse.db.findFirstRow(
        _session,
        where: (t) =>
            t.cacheKey.equals(cacheKey) & (t.expiresAt > DateTime.now()),
      );
      return cached?.responseData;
    } catch (e) {
      _session.log(
        'Cache read error: $e',
        level: LogLevel.warning,
      );
      return null;
    }
  }

  /// Cache a response in the database.
  Future<void> _cacheResponse(String cacheKey, String responseData) async {
    try {
      // Delete existing cache entry if present
      await CachedFoursquareResponse.db.deleteWhere(
        _session,
        where: (t) => t.cacheKey.equals(cacheKey),
      );

      // Insert new cache entry
      await CachedFoursquareResponse.db.insertRow(
        _session,
        CachedFoursquareResponse(
          cacheKey: cacheKey,
          responseData: responseData,
          expiresAt: DateTime.now().add(_cacheTtl),
          createdAt: DateTime.now(),
        ),
      );
    } catch (e) {
      _session.log(
        'Cache write error: $e',
        level: LogLevel.warning,
      );
    }
  }

  /// Parse restaurants from JSON response.
  List<Restaurant> _parseRestaurantsFromJson(String jsonStr) {
    try {
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      final results = json['results'] as List<dynamic>? ?? [];

      return results.map((r) => _mapToRestaurant(r as Map<String, dynamic>)).toList();
    } catch (e) {
      _session.log(
        'Error parsing restaurants: $e',
        level: LogLevel.error,
      );
      return [];
    }
  }

  /// Parse a single restaurant from details response.
  Restaurant? _parseRestaurantDetails(String jsonStr) {
    try {
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      return _mapToRestaurant(json);
    } catch (e) {
      _session.log(
        'Error parsing restaurant details: $e',
        level: LogLevel.error,
      );
      return null;
    }
  }

  /// Map Foursquare JSON to Restaurant model.
  Restaurant _mapToRestaurant(Map<String, dynamic> json) {
    final location = json['location'] as Map<String, dynamic>? ?? {};
    final categories = json['categories'] as List<dynamic>? ?? [];

    // Extract cuisine types from categories
    final cuisineTypes = categories
        .map((c) => (c as Map<String, dynamic>)['name'] as String? ?? '')
        .where((name) => name.isNotEmpty)
        .toList();

    // Parse price tier (Foursquare uses 1-4 scale)
    final priceTier = json['price'] as int? ?? 2;

    // Parse rating (Foursquare uses 0-10 scale)
    final rating = (json['rating'] as num?)?.toDouble();

    // Parse hours
    final hours = json['hours'] != null ? jsonEncode(json['hours']) : null;

    // Parse dish data from menu and tastes
    String? dishData;
    if (json['menu'] != null || json['tastes'] != null) {
      dishData = jsonEncode({
        'menu': json['menu'],
        'tastes': json['tastes'],
      });
    }

    // In the new API, lat/lng are at the top level, not in location
    final lat = (json['latitude'] as num?)?.toDouble() ??
        (location['latitude'] as num?)?.toDouble() ??
        0.0;
    final lng = (json['longitude'] as num?)?.toDouble() ??
        (location['longitude'] as num?)?.toDouble() ??
        0.0;

    return Restaurant(
      fsqId: (json['fsq_place_id'] ?? json['fsq_id']) as String? ?? '',
      name: json['name'] as String? ?? 'Unknown',
      address: _formatAddress(location),
      latitude: lat,
      longitude: lng,
      priceTier: priceTier.clamp(1, 4),
      rating: rating,
      cuisineTypes: cuisineTypes,
      hours: hours,
      dishData: dishData,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Format address from location object.
  String _formatAddress(Map<String, dynamic> location) {
    final parts = <String>[];
    if (location['address'] != null) parts.add(location['address'] as String);
    if (location['locality'] != null) parts.add(location['locality'] as String);
    if (location['region'] != null) parts.add(location['region'] as String);
    if (location['postcode'] != null) parts.add(location['postcode'] as String);
    return parts.join(', ');
  }

  /// Map cuisine type names to Foursquare category IDs.
  List<String> _mapCuisinesToCategories(List<String> cuisineTypes) {
    // Foursquare category ID mappings for common cuisines
    const cuisineCategories = <String, String>{
      'italian': '13064',
      'mexican': '13303',
      'chinese': '13099',
      'japanese': '13263',
      'indian': '13199',
      'thai': '13352',
      'french': '13148',
      'american': '13068',
      'mediterranean': '13302',
      'korean': '13272',
      'vietnamese': '13359',
      'pizza': '13064',
      'sushi': '13263',
      'seafood': '13338',
      'steakhouse': '13345',
      'vegetarian': '13377',
      'vegan': '13377',
      'breakfast': '13028',
      'brunch': '13028',
      'cafe': '13032',
      'coffee': '13032',
      'bakery': '13002',
      'dessert': '13040',
    };

    return cuisineTypes
        .map((c) => cuisineCategories[c.toLowerCase()])
        .where((id) => id != null)
        .cast<String>()
        .toList();
  }

  /// Clean up expired cache entries.
  Future<void> cleanupExpiredCache() async {
    try {
      await CachedFoursquareResponse.db.deleteWhere(
        _session,
        where: (t) => t.expiresAt < DateTime.now(),
      );
    } catch (e) {
      _session.log(
        'Cache cleanup error: $e',
        level: LogLevel.warning,
      );
    }
  }

  /// Close the HTTP client.
  void dispose() {
    _httpClient.close();
  }
}
