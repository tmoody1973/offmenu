import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Endpoint for Google Places API proxy.
/// Handles city autocomplete and place details to avoid CORS issues in web.
class PlacesEndpoint extends Endpoint {
  /// Search for cities using Google Places Autocomplete.
  /// Returns a list of city predictions.
  Future<List<CityPrediction>> searchCities(
    Session session,
    String query,
  ) async {
    if (query.length < 2) {
      return [];
    }

    final apiKey = session.passwords['GOOGLE_PLACES_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      session.log('Google API key not configured', level: LogLevel.warning);
      return [];
    }

    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json'
        '?input=${Uri.encodeComponent(query)}'
        '&types=(cities)'
        '&key=$apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final predictions = data['predictions'] as List<dynamic>? ?? [];

        return predictions.map((prediction) {
          final terms = prediction['terms'] as List<dynamic>? ?? [];
          String? city;
          String? state;
          String? country;

          if (terms.isNotEmpty) {
            city = terms[0]['value'] as String?;
          }
          if (terms.length > 1) {
            state = terms[1]['value'] as String?;
          }
          if (terms.length > 2) {
            country = terms[2]['value'] as String?;
          }

          return CityPrediction(
            city: city ?? prediction['description'].toString().split(',').first,
            state: state,
            country: country,
            placeId: prediction['place_id'] as String,
            displayName: prediction['description'] as String,
          );
        }).toList();
      } else {
        session.log(
          'Places API error: ${response.statusCode} - ${response.body}',
          level: LogLevel.error,
        );
        return [];
      }
    } catch (e) {
      session.log('City search error: $e', level: LogLevel.error);
      return [];
    }
  }

  /// Get place details including coordinates.
  Future<PlaceDetails?> getPlaceDetails(
    Session session,
    String placeId,
  ) async {
    final apiKey = session.passwords['GOOGLE_PLACES_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      return null;
    }

    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json'
        '?place_id=$placeId'
        '&fields=geometry,address_components'
        '&key=$apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final result = data['result'] as Map<String, dynamic>?;

        if (result != null) {
          final location = result['geometry']?['location'];
          if (location != null) {
            return PlaceDetails(
              latitude: (location['lat'] as num).toDouble(),
              longitude: (location['lng'] as num).toDouble(),
            );
          }
        }
      }
      return null;
    } catch (e) {
      session.log('Place details error: $e', level: LogLevel.error);
      return null;
    }
  }
}
