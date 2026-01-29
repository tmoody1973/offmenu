import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Result of a Google Places restaurant search.
class GooglePlacesSearchResult {
  final List<Restaurant> restaurants;
  final bool isFromCache;
  final String? warning;

  GooglePlacesSearchResult({
    required this.restaurants,
    this.isFromCache = false,
    this.warning,
  });
}

/// Service for interacting with Google Places API (New).
/// Uses field masking and caching to minimize API costs.
class GooglePlacesService {
  // Google Places API (New) base URL
  static const String _baseUrl =
      'https://places.googleapis.com/v1/places:searchNearby';
  static const Duration _cacheTtl = Duration(hours: 48); // Longer cache = less API calls
  static const int _maxRetries = 3;
  static const Duration _timeout = Duration(seconds: 30);

  final String _apiKey;
  final http.Client _httpClient;
  final Session _session;

  GooglePlacesService({
    required String apiKey,
    required Session session,
    http.Client? httpClient,
  })  : _apiKey = apiKey,
        _session = session,
        _httpClient = httpClient ?? http.Client();

  /// Convenience constructor using session passwords.
  factory GooglePlacesService.fromSession(Session session) {
    final apiKey = session.serverpod.getPassword('GOOGLE_PLACES_API_KEY') ?? '';
    return GooglePlacesService(apiKey: apiKey, session: session);
  }

  /// Get the API key (for constructing photo URLs).
  String? get apiKey => _apiKey.isNotEmpty ? _apiKey : null;

  /// Search for restaurants near a location.
  /// Uses Google Places Nearby Search (New) API with field masking for cost optimization.
  Future<GooglePlacesSearchResult> searchRestaurants({
    required double latitude,
    required double longitude,
    required int radiusMeters,
    List<String>? cuisineTypes,
    int limit = 12,
  }) async {
    final cacheKey = _generateCacheKey(
      latitude: latitude,
      longitude: longitude,
      radiusMeters: radiusMeters,
      cuisineTypes: cuisineTypes,
      limit: limit,
    );

    // Check cache first - saves API costs
    final cachedResponse = await _getCachedResponse(cacheKey);
    if (cachedResponse != null) {
      _session.log(
        'Google Places cache hit for $cacheKey',
        level: LogLevel.info,
      );
      final restaurants = _parseRestaurantsFromJson(cachedResponse);
      return GooglePlacesSearchResult(
        restaurants: restaurants,
        isFromCache: true,
      );
    }

    // Build request body for Places API (New)
    final requestBody = _buildSearchRequest(
      latitude: latitude,
      longitude: longitude,
      radiusMeters: radiusMeters,
      cuisineTypes: cuisineTypes,
      limit: limit,
    );

    try {
      final response = await _makeRequestWithRetry(requestBody);

      if (response == null) {
        return GooglePlacesSearchResult(
          restaurants: [],
          warning: 'Unable to fetch restaurants. Please try again later.',
        );
      }

      // Cache the successful response
      await _cacheResponse(cacheKey, response);

      final restaurants = _parseRestaurantsFromJson(response);
      _session.log(
        'Google Places found ${restaurants.length} restaurants',
        level: LogLevel.info,
      );
      return GooglePlacesSearchResult(restaurants: restaurants);
    } catch (e) {
      _session.log(
        'Google Places search error: $e',
        level: LogLevel.error,
      );
      return GooglePlacesSearchResult(
        restaurants: [],
        warning: 'Error searching restaurants: ${e.toString()}',
      );
    }
  }

  /// Build the request body for Nearby Search.
  Map<String, dynamic> _buildSearchRequest({
    required double latitude,
    required double longitude,
    required int radiusMeters,
    List<String>? cuisineTypes,
    required int limit,
  }) {
    // Map cuisine types to Google Places types
    final includedTypes = <String>['restaurant'];
    if (cuisineTypes != null && cuisineTypes.isNotEmpty) {
      final mappedTypes = _mapCuisinesToGoogleTypes(cuisineTypes);
      if (mappedTypes.isNotEmpty) {
        includedTypes.clear();
        includedTypes.addAll(mappedTypes);
      }
    }

    return {
      'includedTypes': includedTypes,
      'maxResultCount': limit.clamp(1, 20), // Google max is 20
      'locationRestriction': {
        'circle': {
          'center': {
            'latitude': latitude,
            'longitude': longitude,
          },
          'radius': radiusMeters.toDouble().clamp(1, 50000), // Max 50km
        },
      },
    };
  }

  /// Make an API request with retry logic.
  Future<String?> _makeRequestWithRetry(Map<String, dynamic> requestBody) async {
    // Field mask - only request fields we need (reduces cost!)
    // Basic fields are free, Contact/Atmosphere cost extra
    const fieldMask = 'places.id,'
        'places.displayName,'
        'places.formattedAddress,'
        'places.location,'
        'places.types,'
        'places.priceLevel,'
        'places.rating,'
        'places.regularOpeningHours';

    for (var attempt = 0; attempt < _maxRetries; attempt++) {
      try {
        _session.log(
          'Google Places request attempt ${attempt + 1}',
          level: LogLevel.info,
        );

        final response = await _httpClient
            .post(
              Uri.parse(_baseUrl),
              headers: {
                'Content-Type': 'application/json',
                'X-Goog-Api-Key': _apiKey,
                'X-Goog-FieldMask': fieldMask,
              },
              body: jsonEncode(requestBody),
            )
            .timeout(_timeout);

        _session.log(
          'Google Places response: ${response.statusCode}',
          level: LogLevel.info,
        );

        if (response.statusCode == 200) {
          return response.body;
        }

        if (response.statusCode == 400) {
          _session.log(
            'Google Places bad request: ${response.body}',
            level: LogLevel.error,
          );
          return null;
        }

        if (response.statusCode == 403) {
          _session.log(
            'Google Places API key error or quota exceeded: ${response.body}',
            level: LogLevel.error,
          );
          return null;
        }

        if (response.statusCode == 429) {
          _session.log(
            'Google Places rate limit, waiting before retry',
            level: LogLevel.warning,
          );
          await Future.delayed(Duration(seconds: 2 * (attempt + 1)));
          continue;
        }

        if (response.statusCode >= 500) {
          _session.log(
            'Google Places server error: ${response.statusCode}',
            level: LogLevel.warning,
          );
          await Future.delayed(Duration(seconds: 1 * (attempt + 1)));
          continue;
        }

        _session.log(
          'Google Places API error: ${response.statusCode} - ${response.body}',
          level: LogLevel.error,
        );
        return null;
      } on TimeoutException {
        _session.log(
          'Google Places request timeout, attempt ${attempt + 1}',
          level: LogLevel.warning,
        );
        if (attempt < _maxRetries - 1) {
          await Future.delayed(Duration(seconds: 1));
        }
      } catch (e) {
        _session.log(
          'Google Places request error: $e',
          level: LogLevel.error,
        );
        if (attempt == _maxRetries - 1) return null;
        await Future.delayed(Duration(seconds: 1));
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
    // Round coordinates to reduce cache fragmentation
    final latRounded = (latitude * 100).round() / 100;
    final lngRounded = (longitude * 100).round() / 100;
    return 'google:$latRounded:$lngRounded:$radiusMeters:$cuisineStr:$limit';
  }

  /// Get cached response from database.
  Future<String?> _getCachedResponse(String cacheKey) async {
    try {
      // Reuse the existing cache table
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

  /// Parse restaurants from Google Places JSON response.
  List<Restaurant> _parseRestaurantsFromJson(String jsonStr) {
    try {
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      final places = json['places'] as List<dynamic>? ?? [];

      return places
          .map((p) => _mapToRestaurant(p as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _session.log(
        'Error parsing restaurants: $e',
        level: LogLevel.error,
      );
      return [];
    }
  }

  /// Map Google Places JSON to Restaurant model.
  Restaurant _mapToRestaurant(Map<String, dynamic> json) {
    final location = json['location'] as Map<String, dynamic>? ?? {};
    final displayName = json['displayName'] as Map<String, dynamic>? ?? {};
    final types = json['types'] as List<dynamic>? ?? [];

    // Extract cuisine types from place types
    final cuisineTypes = types
        .map((t) => _formatTypeName(t as String))
        .where((name) => name.isNotEmpty && name != 'Restaurant')
        .take(3)
        .toList();

    // Parse price level (Google uses PRICE_LEVEL_FREE to PRICE_LEVEL_VERY_EXPENSIVE)
    final priceLevel = json['priceLevel'] as String?;
    final priceTier = _parsePriceLevel(priceLevel);

    // Parse rating (Google uses 1-5 scale)
    final rating = (json['rating'] as num?)?.toDouble();

    // Parse hours
    String? hours;
    if (json['regularOpeningHours'] != null) {
      hours = jsonEncode(json['regularOpeningHours']);
    }

    return Restaurant(
      fsqId: json['id'] as String? ?? '', // Using fsqId field for Google place ID
      name: displayName['text'] as String? ?? 'Unknown',
      address: json['formattedAddress'] as String? ?? '',
      latitude: (location['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (location['longitude'] as num?)?.toDouble() ?? 0.0,
      priceTier: priceTier,
      rating: rating,
      cuisineTypes: cuisineTypes,
      hours: hours,
      dishData: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Format Google place type to readable name.
  String _formatTypeName(String type) {
    // Convert snake_case to Title Case
    return type
        .split('_')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');
  }

  /// Parse Google price level to 1-4 tier.
  int _parsePriceLevel(String? priceLevel) {
    switch (priceLevel) {
      case 'PRICE_LEVEL_FREE':
      case 'PRICE_LEVEL_INEXPENSIVE':
        return 1;
      case 'PRICE_LEVEL_MODERATE':
        return 2;
      case 'PRICE_LEVEL_EXPENSIVE':
        return 3;
      case 'PRICE_LEVEL_VERY_EXPENSIVE':
        return 4;
      default:
        return 2; // Default to moderate
    }
  }

  /// Map cuisine type names to Google Places types.
  List<String> _mapCuisinesToGoogleTypes(List<String> cuisineTypes) {
    const cuisineMapping = <String, String>{
      'italian': 'italian_restaurant',
      'mexican': 'mexican_restaurant',
      'chinese': 'chinese_restaurant',
      'japanese': 'japanese_restaurant',
      'indian': 'indian_restaurant',
      'thai': 'thai_restaurant',
      'french': 'french_restaurant',
      'american': 'american_restaurant',
      'mediterranean': 'mediterranean_restaurant',
      'korean': 'korean_restaurant',
      'vietnamese': 'vietnamese_restaurant',
      'pizza': 'pizza_restaurant',
      'sushi': 'sushi_restaurant',
      'seafood': 'seafood_restaurant',
      'steakhouse': 'steak_house',
      'vegetarian': 'vegetarian_restaurant',
      'vegan': 'vegan_restaurant',
      'breakfast': 'breakfast_restaurant',
      'brunch': 'brunch_restaurant',
      'cafe': 'cafe',
      'coffee': 'coffee_shop',
      'bakery': 'bakery',
      'dessert': 'dessert_restaurant',
      'barbecue': 'barbecue_restaurant',
      'greek': 'greek_restaurant',
      'spanish': 'spanish_restaurant',
      'turkish': 'turkish_restaurant',
      'ramen': 'ramen_restaurant',
    };

    return cuisineTypes
        .map((c) => cuisineMapping[c.toLowerCase()])
        .where((type) => type != null)
        .cast<String>()
        .toList();
  }

  /// Search for a specific restaurant by name using Text Search.
  /// Returns the best match within the given radius, or null if not found.
  Future<Restaurant?> searchByName({
    required String query,
    required double latitude,
    required double longitude,
    required int radiusMeters,
  }) async {
    const textSearchUrl = 'https://places.googleapis.com/v1/places:searchText';

    const fieldMask = 'places.id,'
        'places.displayName,'
        'places.formattedAddress,'
        'places.location,'
        'places.types,'
        'places.priceLevel,'
        'places.rating,'
        'places.regularOpeningHours';

    final requestBody = {
      'textQuery': query,
      'locationBias': {
        'circle': {
          'center': {
            'latitude': latitude,
            'longitude': longitude,
          },
          'radius': radiusMeters.toDouble(),
        },
      },
      'includedType': 'restaurant',
      'maxResultCount': 3, // Get top 3 to find best match
    };

    try {
      final response = await _httpClient
          .post(
            Uri.parse(textSearchUrl),
            headers: {
              'Content-Type': 'application/json',
              'X-Goog-Api-Key': _apiKey,
              'X-Goog-FieldMask': fieldMask,
            },
            body: jsonEncode(requestBody),
          )
          .timeout(_timeout);

      if (response.statusCode != 200) {
        _session.log(
          'Google Places Text Search error: ${response.statusCode} - ${response.body}',
          level: LogLevel.warning,
        );
        return null;
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final places = json['places'] as List<dynamic>?;

      if (places == null || places.isEmpty) {
        return null;
      }

      // Return the first (best) match
      return _mapToRestaurant(places.first as Map<String, dynamic>);
    } catch (e) {
      _session.log(
        'Google Places Text Search error: $e',
        level: LogLevel.error,
      );
      return null;
    }
  }

  /// Search for a place by name and get full details including photos.
  /// Returns raw JSON data for flexible use.
  Future<Map<String, dynamic>?> searchAndGetDetails(String query) async {
    const textSearchUrl = 'https://places.googleapis.com/v1/places:searchText';

    // Include photos in field mask
    const fieldMask = 'places.id,'
        'places.displayName,'
        'places.formattedAddress,'
        'places.location,'
        'places.types,'
        'places.priceLevel,'
        'places.rating,'
        'places.userRatingCount,'
        'places.regularOpeningHours,'
        'places.photos';

    final requestBody = {
      'textQuery': query,
      'includedType': 'restaurant',
      'maxResultCount': 1,
    };

    try {
      final response = await _httpClient
          .post(
            Uri.parse(textSearchUrl),
            headers: {
              'Content-Type': 'application/json',
              'X-Goog-Api-Key': _apiKey,
              'X-Goog-FieldMask': fieldMask,
            },
            body: jsonEncode(requestBody),
          )
          .timeout(_timeout);

      if (response.statusCode != 200) {
        _session.log(
          'Google Places searchAndGetDetails error: ${response.statusCode} - ${response.body}',
          level: LogLevel.warning,
        );
        return null;
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final places = json['places'] as List<dynamic>?;

      if (places == null || places.isEmpty) {
        return null;
      }

      final place = places.first as Map<String, dynamic>;

      // Convert from new API format to legacy format for easier use
      final location = place['location'] as Map<String, dynamic>? ?? {};
      final displayName = place['displayName'] as Map<String, dynamic>? ?? {};
      final photos = place['photos'] as List<dynamic>? ?? [];
      final openingHours = place['regularOpeningHours'] as Map<String, dynamic>?;

      return {
        'place_id': place['id'],
        'name': displayName['text'],
        'formatted_address': place['formattedAddress'],
        'geometry': {
          'location': {
            'lat': location['latitude'],
            'lng': location['longitude'],
          },
        },
        'rating': place['rating'],
        'user_ratings_total': place['userRatingCount'],
        'price_level': _parsePriceLevelToInt(place['priceLevel'] as String?),
        'photos': photos.map((p) {
          final photoName = p['name'] as String?;
          // Extract photo reference from resource name
          // Format: places/{place_id}/photos/{photo_reference}
          final photoRef = photoName?.split('/').last;
          return {
            'photo_reference': photoRef,
            'height': p['heightPx'],
            'width': p['widthPx'],
          };
        }).toList(),
        'opening_hours': openingHours != null
            ? {'open_now': openingHours['openNow']}
            : null,
      };
    } catch (e) {
      _session.log(
        'Google Places searchAndGetDetails error: $e',
        level: LogLevel.error,
      );
      return null;
    }
  }

  /// Parse price level string to int.
  int? _parsePriceLevelToInt(String? priceLevel) {
    switch (priceLevel) {
      case 'PRICE_LEVEL_FREE':
        return 0;
      case 'PRICE_LEVEL_INEXPENSIVE':
        return 1;
      case 'PRICE_LEVEL_MODERATE':
        return 2;
      case 'PRICE_LEVEL_EXPENSIVE':
        return 3;
      case 'PRICE_LEVEL_VERY_EXPENSIVE':
        return 4;
      default:
        return null;
    }
  }

  /// Get multiple photos for a place.
  /// Returns photo data with proxied URLs (no API key exposed).
  Future<List<Map<String, dynamic>>> getPlacePhotos(
    String placeId, {
    int maxPhotos = 5,
    String? serverBaseUrl,
  }) async {
    try {
      final url = Uri.parse(
        'https://places.googleapis.com/v1/places/$placeId',
      );

      final response = await _httpClient
          .get(
            url,
            headers: {
              'X-Goog-Api-Key': _apiKey,
              'X-Goog-FieldMask': 'photos',
            },
          )
          .timeout(_timeout);

      if (response.statusCode != 200) {
        _session.log(
          'Failed to get place photos: ${response.statusCode}',
          level: LogLevel.warning,
        );
        return [];
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final photos = data['photos'] as List<dynamic>? ?? [];

      // Use the provided serverBaseUrl or default to web server port
      // Photos are served via the web server (port 8082 by default)
      final baseUrl = serverBaseUrl ?? 'http://localhost:8082';

      return photos
          .take(maxPhotos)
          .map((p) {
            final name = p['name'] as String?;
            final photoRef = name?.split('/').last ?? '';
            final width = p['widthPx'] as int? ?? 800;
            final height = p['heightPx'] as int? ?? 600;
            final attributions = p['authorAttributions'] as List<dynamic>? ?? [];
            final attribution = attributions.isNotEmpty
                ? attributions.first['displayName'] as String?
                : null;

            return {
              'photoReference': photoRef,
              'width': width,
              'height': height,
              'url': '$baseUrl/api/photos/$photoRef',
              'thumbnailUrl': '$baseUrl/api/photos/$photoRef?thumbnail=true',
              'attribution': attribution,
            };
          })
          .where((p) => (p['photoReference'] as String).isNotEmpty)
          .toList();
    } catch (e) {
      _session.log('Error getting place photos: $e', level: LogLevel.error);
      return [];
    }
  }

  /// Build a direct Google Places photo URL.
  /// Note: This exposes the API key - prefer using proxied URLs.
  String buildPhotoUrl(String photoReference, {int maxWidth = 800}) {
    return 'https://maps.googleapis.com/maps/api/place/photo'
        '?maxwidth=$maxWidth'
        '&photo_reference=$photoReference'
        '&key=$_apiKey';
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
