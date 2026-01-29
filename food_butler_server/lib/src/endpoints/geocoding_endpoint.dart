import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Geocoding API endpoint.
///
/// Proxies Google Places API requests to avoid CORS issues on web.
class GeocodingEndpoint extends Endpoint {
  static const String _placesBaseUrl =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  static const String _placeDetailsUrl =
      'https://maps.googleapis.com/maps/api/place/details/json';

  /// Search for places matching the query.
  ///
  /// Returns a list of place predictions with their IDs and descriptions.
  Future<List<PlacePrediction>> searchPlaces(
    Session session,
    String query,
  ) async {
    if (query.isEmpty) return [];

    final apiKey = session.serverpod.getPassword('GOOGLE_PLACES_API_KEY');
    if (apiKey == null || apiKey.isEmpty) {
      session.log('Google Places API key not configured', level: LogLevel.error);
      return [];
    }

    try {
      final uri = Uri.parse(
        '$_placesBaseUrl'
        '?input=${Uri.encodeComponent(query)}'
        '&types=geocode|establishment'
        '&key=$apiKey',
      );

      final response = await http.get(uri);

      if (response.statusCode != 200) {
        session.log(
          'Google Places API error: ${response.statusCode}',
          level: LogLevel.error,
        );
        return [];
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final status = data['status'] as String?;

      if (status != 'OK' && status != 'ZERO_RESULTS') {
        session.log('Google Places API status: $status', level: LogLevel.warning);
        return [];
      }

      final predictions = data['predictions'] as List<dynamic>? ?? [];

      return predictions.map((p) {
        final pred = p as Map<String, dynamic>;
        return PlacePrediction(
          placeId: pred['place_id'] as String? ?? '',
          description: pred['description'] as String? ?? '',
          mainText: pred['structured_formatting']?['main_text'] as String?,
          secondaryText: pred['structured_formatting']?['secondary_text'] as String?,
        );
      }).toList();
    } catch (e) {
      session.log('Places search error: $e', level: LogLevel.error);
      return [];
    }
  }

  /// Get details for a place by its ID.
  ///
  /// Returns the place's coordinates and address components.
  Future<PlaceDetails?> getPlaceDetails(
    Session session,
    String placeId,
  ) async {
    final apiKey = session.serverpod.getPassword('GOOGLE_PLACES_API_KEY');
    if (apiKey == null || apiKey.isEmpty) {
      session.log('Google Places API key not configured', level: LogLevel.error);
      return null;
    }

    try {
      final uri = Uri.parse(
        '$_placeDetailsUrl'
        '?place_id=$placeId'
        '&fields=geometry,address_components,formatted_address'
        '&key=$apiKey',
      );

      final response = await http.get(uri);

      if (response.statusCode != 200) {
        session.log(
          'Google Place Details API error: ${response.statusCode}',
          level: LogLevel.error,
        );
        return null;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final result = data['result'] as Map<String, dynamic>?;

      if (result == null) return null;

      final geometry = result['geometry'] as Map<String, dynamic>?;
      final location = geometry?['location'] as Map<String, dynamic>?;
      final components = result['address_components'] as List<dynamic>? ?? [];

      String? city;
      String? state;
      String? country;

      for (final component in components) {
        final compMap = component as Map<String, dynamic>;
        final types = compMap['types'] as List<dynamic>? ?? [];
        final longName = compMap['long_name'] as String?;

        if (types.contains('locality')) {
          city = longName;
        } else if (types.contains('administrative_area_level_1')) {
          state = longName;
        } else if (types.contains('country')) {
          country = longName;
        }
      }

      return PlaceDetails(
        latitude: (location?['lat'] as num?)?.toDouble() ?? 0.0,
        longitude: (location?['lng'] as num?)?.toDouble() ?? 0.0,
        formattedAddress: result['formatted_address'] as String?,
        city: city,
        state: state,
        country: country,
      );
    } catch (e) {
      session.log('Place details error: $e', level: LogLevel.error);
      return null;
    }
  }
}
