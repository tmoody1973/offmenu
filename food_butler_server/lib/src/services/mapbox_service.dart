import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// A geographic coordinate.
class LatLng {
  final double latitude;
  final double longitude;

  LatLng({required this.latitude, required this.longitude});

  @override
  String toString() => '$longitude,$latitude';
}

/// Result of a route calculation.
class RouteResult {
  final String polyline;
  final int totalDistanceMeters;
  final int totalDurationSeconds;
  final List<RouteLeg> legs;
  final bool isFromCache;
  final String? warning;

  RouteResult({
    required this.polyline,
    required this.totalDistanceMeters,
    required this.totalDurationSeconds,
    required this.legs,
    this.isFromCache = false,
    this.warning,
  });

  /// Create a fallback result with straight-line distance estimation.
  factory RouteResult.fallback({
    required List<LatLng> waypoints,
    required TransportMode transportMode,
    required String warning,
  }) {
    final legs = <RouteLeg>[];
    var totalDistance = 0;
    var totalDuration = 0;

    for (var i = 0; i < waypoints.length - 1; i++) {
      final distance = _haversineDistance(waypoints[i], waypoints[i + 1]);
      final duration = _estimateDuration(distance.toInt(), transportMode);

      legs.add(RouteLeg(
        distanceMeters: distance.toInt(),
        durationSeconds: duration,
        transportMode: transportMode,
      ));

      totalDistance += distance.toInt();
      totalDuration += duration;
    }

    return RouteResult(
      polyline: '', // No polyline for fallback
      totalDistanceMeters: totalDistance,
      totalDurationSeconds: totalDuration,
      legs: legs,
      isFromCache: false,
      warning: warning,
    );
  }

  /// Calculate haversine distance between two points in meters.
  static double _haversineDistance(LatLng a, LatLng b) {
    const earthRadius = 6371000.0; // meters

    final lat1 = a.latitude * pi / 180;
    final lat2 = b.latitude * pi / 180;
    final dLat = (b.latitude - a.latitude) * pi / 180;
    final dLon = (b.longitude - a.longitude) * pi / 180;

    final h = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(h), sqrt(1 - h));

    return earthRadius * c;
  }

  /// Estimate duration based on distance and transport mode.
  static int _estimateDuration(int distanceMeters, TransportMode mode) {
    // Walking: ~5 km/h = 1.39 m/s
    // Driving: ~30 km/h average urban = 8.33 m/s
    final speedMps = mode == TransportMode.walking ? 1.39 : 8.33;
    return (distanceMeters / speedMps).round();
  }
}

/// Service for interacting with Mapbox Directions API.
class MapboxService {
  static const String _baseUrl = 'https://api.mapbox.com/directions/v5';
  static const Duration _cacheTtl = Duration(days: 7);
  static const Duration _timeout = Duration(seconds: 30);
  static const int _maxRetries = 3;

  final String _accessToken;
  final http.Client _httpClient;
  final Session _session;

  MapboxService({
    required String accessToken,
    required Session session,
    http.Client? httpClient,
  })  : _accessToken = accessToken,
        _session = session,
        _httpClient = httpClient ?? http.Client();

  /// Calculate a route between waypoints.
  Future<RouteResult> calculateRoute({
    required List<LatLng> waypoints,
    required TransportMode transportMode,
  }) async {
    if (waypoints.length < 2) {
      return RouteResult(
        polyline: '',
        totalDistanceMeters: 0,
        totalDurationSeconds: 0,
        legs: [],
        warning: 'At least 2 waypoints required',
      );
    }

    // Generate cache key
    final cacheKey = _generateCacheKey(waypoints, transportMode);

    // Check cache first
    final cachedRoute = await _getCachedRoute(cacheKey, transportMode);
    if (cachedRoute != null) {
      return RouteResult(
        polyline: cachedRoute.polyline,
        totalDistanceMeters: cachedRoute.distanceMeters,
        totalDurationSeconds: cachedRoute.durationSeconds,
        legs: _parseLegsJson(cachedRoute.legsJson),
        isFromCache: true,
      );
    }

    // Build Mapbox profile
    final profile = transportMode == TransportMode.walking
        ? 'mapbox/walking'
        : 'mapbox/driving';

    // Build coordinates string
    final coordinates = waypoints.map((w) => w.toString()).join(';');

    try {
      final response = await _makeRequestWithRetry(
        profile: profile,
        coordinates: coordinates,
      );

      if (response == null) {
        return RouteResult.fallback(
          waypoints: waypoints,
          transportMode: transportMode,
          warning: 'Unable to calculate route. Using estimated distances.',
        );
      }

      final result = _parseRouteResponse(response, transportMode);

      // Cache successful result
      await _cacheRoute(cacheKey, result, transportMode);

      return result;
    } catch (e) {
      _session.log(
        'Mapbox route calculation error: $e',
        level: LogLevel.error,
      );
      return RouteResult.fallback(
        waypoints: waypoints,
        transportMode: transportMode,
        warning: 'Error calculating route: ${e.toString()}',
      );
    }
  }

  /// Make an API request with retry logic.
  Future<String?> _makeRequestWithRetry({
    required String profile,
    required String coordinates,
  }) async {
    for (var attempt = 0; attempt < _maxRetries; attempt++) {
      try {
        final uri = Uri.parse('$_baseUrl/$profile/$coordinates').replace(
          queryParameters: {
            'access_token': _accessToken,
            'geometries': 'polyline6',
            'overview': 'full',
            'steps': 'false',
          },
        );

        final response = await _httpClient.get(uri).timeout(_timeout);

        if (response.statusCode == 200) {
          return response.body;
        }

        if (response.statusCode == 401) {
          _session.log(
            'Mapbox API authentication error',
            level: LogLevel.error,
          );
          return null;
        }

        if (response.statusCode == 429) {
          _session.log(
            'Mapbox rate limit hit',
            level: LogLevel.warning,
          );
          await Future.delayed(Duration(seconds: pow(2, attempt).toInt()));
          continue;
        }

        if (response.statusCode >= 500) {
          _session.log(
            'Mapbox server error: ${response.statusCode}',
            level: LogLevel.warning,
          );
          await Future.delayed(Duration(seconds: pow(2, attempt).toInt()));
          continue;
        }

        _session.log(
          'Mapbox API error: ${response.statusCode} - ${response.body}',
          level: LogLevel.error,
        );
        return null;
      } on TimeoutException {
        _session.log(
          'Mapbox request timeout',
          level: LogLevel.warning,
        );
        if (attempt == _maxRetries - 1) return null;
      } catch (e) {
        _session.log(
          'Mapbox request error: $e',
          level: LogLevel.error,
        );
        if (attempt == _maxRetries - 1) return null;
      }
    }

    return null;
  }

  /// Parse Mapbox response into RouteResult.
  RouteResult _parseRouteResponse(String jsonStr, TransportMode transportMode) {
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;
    final routes = json['routes'] as List<dynamic>? ?? [];

    if (routes.isEmpty) {
      return RouteResult(
        polyline: '',
        totalDistanceMeters: 0,
        totalDurationSeconds: 0,
        legs: [],
        warning: 'No route found',
      );
    }

    final route = routes[0] as Map<String, dynamic>;
    final geometry = route['geometry'] as String? ?? '';
    final duration = (route['duration'] as num?)?.toInt() ?? 0;
    final distance = (route['distance'] as num?)?.toInt() ?? 0;

    final routeLegs = <RouteLeg>[];
    final legsData = route['legs'] as List<dynamic>? ?? [];

    for (final leg in legsData) {
      final legMap = leg as Map<String, dynamic>;
      routeLegs.add(RouteLeg(
        distanceMeters: (legMap['distance'] as num?)?.toInt() ?? 0,
        durationSeconds: (legMap['duration'] as num?)?.toInt() ?? 0,
        transportMode: transportMode,
      ));
    }

    return RouteResult(
      polyline: geometry,
      totalDistanceMeters: distance,
      totalDurationSeconds: duration,
      legs: routeLegs,
    );
  }

  /// Generate cache key from waypoints.
  String _generateCacheKey(List<LatLng> waypoints, TransportMode mode) {
    // Sort waypoints to handle different orderings of same stops
    final coordStrings = waypoints.map((w) =>
        '${w.latitude.toStringAsFixed(5)},${w.longitude.toStringAsFixed(5)}');
    final sorted = coordStrings.toList()..sort();
    final combined = '${sorted.join('|')}|${mode.name}';

    // Hash for a compact cache key
    final bytes = utf8.encode(combined);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  /// Get cached route from database.
  Future<CachedRoute?> _getCachedRoute(
    String waypointsHash,
    TransportMode transportMode,
  ) async {
    try {
      return await CachedRoute.db.findFirstRow(
        _session,
        where: (t) =>
            t.waypointsHash.equals(waypointsHash) &
            t.transportMode.equals(transportMode) &
            (t.expiresAt > DateTime.now()),
      );
    } catch (e) {
      _session.log(
        'Route cache read error: $e',
        level: LogLevel.warning,
      );
      return null;
    }
  }

  /// Cache a route in the database.
  Future<void> _cacheRoute(
    String waypointsHash,
    RouteResult result,
    TransportMode transportMode,
  ) async {
    try {
      // Delete existing cache entry if present
      await CachedRoute.db.deleteWhere(
        _session,
        where: (t) =>
            t.waypointsHash.equals(waypointsHash) &
            t.transportMode.equals(transportMode),
      );

      // Insert new cache entry
      await CachedRoute.db.insertRow(
        _session,
        CachedRoute(
          waypointsHash: waypointsHash,
          transportMode: transportMode,
          polyline: result.polyline,
          distanceMeters: result.totalDistanceMeters,
          durationSeconds: result.totalDurationSeconds,
          legsJson: _serializeLegs(result.legs),
          expiresAt: DateTime.now().add(_cacheTtl),
          createdAt: DateTime.now(),
        ),
      );
    } catch (e) {
      _session.log(
        'Route cache write error: $e',
        level: LogLevel.warning,
      );
    }
  }

  /// Serialize route legs to JSON.
  String _serializeLegs(List<RouteLeg> legs) {
    final data = legs
        .map((l) => {
              'distanceMeters': l.distanceMeters,
              'durationSeconds': l.durationSeconds,
              'transportMode': l.transportMode.name,
            })
        .toList();
    return jsonEncode(data);
  }

  /// Parse route legs from JSON.
  List<RouteLeg> _parseLegsJson(String jsonStr) {
    try {
      final data = jsonDecode(jsonStr) as List<dynamic>;
      return data.map((l) {
        final map = l as Map<String, dynamic>;
        return RouteLeg(
          distanceMeters: map['distanceMeters'] as int,
          durationSeconds: map['durationSeconds'] as int,
          transportMode: TransportMode.values.firstWhere(
            (m) => m.name == map['transportMode'],
            orElse: () => TransportMode.walking,
          ),
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// Clean up expired cache entries.
  Future<void> cleanupExpiredCache() async {
    try {
      await CachedRoute.db.deleteWhere(
        _session,
        where: (t) => t.expiresAt < DateTime.now(),
      );
    } catch (e) {
      _session.log(
        'Route cache cleanup error: $e',
        level: LogLevel.warning,
      );
    }
  }

  /// Close the HTTP client.
  void dispose() {
    _httpClient.close();
  }
}

/// Utility class for polyline encoding/decoding.
class PolylineCodec {
  /// Decode an encoded polyline string to coordinates.
  /// Uses precision 6 (Mapbox default).
  static List<LatLng> decode(String encoded, {int precision = 6}) {
    final coordinates = <LatLng>[];
    var index = 0;
    var lat = 0;
    var lng = 0;
    final factor = pow(10, precision).toInt();

    while (index < encoded.length) {
      // Decode latitude
      var shift = 0;
      var result = 0;
      int byte;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);
      lat += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      // Decode longitude
      shift = 0;
      result = 0;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);
      lng += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      coordinates.add(LatLng(
        latitude: lat / factor,
        longitude: lng / factor,
      ));
    }

    return coordinates;
  }

  /// Encode coordinates to a polyline string.
  /// Uses precision 6 (Mapbox default).
  static String encode(List<LatLng> coordinates, {int precision = 6}) {
    final buffer = StringBuffer();
    var prevLat = 0;
    var prevLng = 0;
    final factor = pow(10, precision).toInt();

    for (final coord in coordinates) {
      final lat = (coord.latitude * factor).round();
      final lng = (coord.longitude * factor).round();

      _encodeValue(lat - prevLat, buffer);
      _encodeValue(lng - prevLng, buffer);

      prevLat = lat;
      prevLng = lng;
    }

    return buffer.toString();
  }

  static void _encodeValue(int value, StringBuffer buffer) {
    var v = value < 0 ? ~(value << 1) : (value << 1);
    while (v >= 0x20) {
      buffer.writeCharCode((0x20 | (v & 0x1F)) + 63);
      v >>= 5;
    }
    buffer.writeCharCode(v + 63);
  }
}
