import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:food_butler_client/food_butler_client.dart';

/// A geocoding result/address suggestion.
class AddressResult {
  /// Unique identifier for this result.
  final String id;

  /// Display text for the address.
  final String displayText;

  /// Full formatted address.
  final String formattedAddress;

  /// Latitude coordinate.
  final double latitude;

  /// Longitude coordinate.
  final double longitude;

  /// City/locality name.
  final String? city;

  /// State/region name.
  final String? state;

  /// Country name.
  final String? country;

  const AddressResult({
    required this.id,
    required this.displayText,
    required this.formattedAddress,
    required this.latitude,
    required this.longitude,
    this.city,
    this.state,
    this.country,
  });
}

/// Service for geocoding addresses via Mapbox Geocoding API.
abstract class GeocodingService {
  /// Searches for addresses matching the query.
  Future<List<AddressResult>> searchAddresses(String query);

  /// Reverse geocodes coordinates to an address.
  Future<AddressResult?> reverseGeocode({
    required double latitude,
    required double longitude,
  });
}

/// Mock implementation for testing.
class MockGeocodingService implements GeocodingService {
  List<AddressResult>? _mockResults;
  AddressResult? _mockReverseResult;

  /// Set mock search results.
  set mockResults(List<AddressResult>? results) => _mockResults = results;

  /// Set mock reverse geocode result.
  set mockReverseResult(AddressResult? result) => _mockReverseResult = result;

  @override
  Future<List<AddressResult>> searchAddresses(String query) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));

    if (_mockResults != null) {
      return _mockResults!;
    }

    // Return default mock results if query is not empty
    if (query.isEmpty) {
      return [];
    }

    return [
      AddressResult(
        id: '1',
        displayText: '123 Main St, San Francisco, CA',
        formattedAddress: '123 Main Street, San Francisco, CA 94102, USA',
        latitude: 37.7749,
        longitude: -122.4194,
        city: 'San Francisco',
        state: 'California',
        country: 'United States',
      ),
      AddressResult(
        id: '2',
        displayText: '456 Oak Ave, San Francisco, CA',
        formattedAddress: '456 Oak Avenue, San Francisco, CA 94103, USA',
        latitude: 37.7750,
        longitude: -122.4195,
        city: 'San Francisco',
        state: 'California',
        country: 'United States',
      ),
    ];
  }

  @override
  Future<AddressResult?> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));

    if (_mockReverseResult != null) {
      return _mockReverseResult;
    }

    // Return a default mock result
    return AddressResult(
      id: 'reverse_1',
      displayText: 'Current Location',
      formattedAddress: '123 Main St, San Francisco, CA 94102',
      latitude: latitude,
      longitude: longitude,
      city: 'San Francisco',
      state: 'California',
      country: 'United States',
    );
  }

  /// Creates default mock results for testing.
  static List<AddressResult> createMockResults({int count = 3}) {
    return List.generate(count, (i) {
      return AddressResult(
        id: '${i + 1}',
        displayText: '${100 + i * 100} Test St, San Francisco, CA',
        formattedAddress:
            '${100 + i * 100} Test Street, San Francisco, CA 941${i}0, USA',
        latitude: 37.7749 + (i * 0.001),
        longitude: -122.4194 - (i * 0.001),
        city: 'San Francisco',
        state: 'California',
        country: 'United States',
      );
    });
  }
}

/// Callback type for the Serverpod client.
typedef ServerpodClientProvider = Client Function();

/// Implementation using Serverpod server-side proxy to avoid CORS issues.
class ServerpodGeocodingService implements GeocodingService {
  final ServerpodClientProvider _clientProvider;

  ServerpodGeocodingService({
    required ServerpodClientProvider clientProvider,
  }) : _clientProvider = clientProvider;

  /// Get the Serverpod client.
  Client get _client => _clientProvider();

  /// Search for place predictions (autocomplete).
  /// Returns predictions without coordinates - use getPlaceDetails to get full address.
  Future<List<PlacePrediction>> searchPlaces(String query) async {
    if (query.isEmpty) return [];

    try {
      final results = await _client.geocoding.searchPlaces(query);
      return results;
    } catch (e) {
      debugPrint('ServerpodGeocodingService searchPlaces error: $e');
      return [];
    }
  }

  /// Get full details for a place including coordinates.
  Future<AddressResult?> getPlaceDetails(String placeId) async {
    try {
      final result = await _client.geocoding.getPlaceDetails(placeId);
      if (result == null) return null;

      return AddressResult(
        id: placeId,
        displayText: result.formattedAddress ?? '',
        formattedAddress: result.formattedAddress ?? '',
        latitude: result.latitude,
        longitude: result.longitude,
        city: result.city,
        state: result.state,
        country: result.country,
      );
    } catch (e) {
      debugPrint('ServerpodGeocodingService getPlaceDetails error: $e');
      return null;
    }
  }

  @override
  Future<List<AddressResult>> searchAddresses(String query) async {
    if (query.isEmpty) return [];

    try {
      // Get predictions first
      final predictions = await searchPlaces(query);

      // Then get details for each (with coordinates)
      final results = <AddressResult>[];
      for (final prediction in predictions.take(5)) {
        final details = await getPlaceDetails(prediction.placeId);
        if (details != null) {
          results.add(AddressResult(
            id: prediction.placeId,
            displayText: prediction.mainText ?? prediction.description,
            formattedAddress: prediction.description,
            latitude: details.latitude,
            longitude: details.longitude,
            city: details.city,
            state: details.state,
            country: details.country,
          ));
        }
      }
      return results;
    } catch (e) {
      debugPrint('ServerpodGeocodingService searchAddresses error: $e');
      return [];
    }
  }

  @override
  Future<AddressResult?> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    // Server-side reverse geocoding not implemented yet
    // Return a basic result with coordinates
    return AddressResult(
      id: 'reverse_${latitude}_$longitude',
      displayText: 'Selected Location',
      formattedAddress: '$latitude, $longitude',
      latitude: latitude,
      longitude: longitude,
    );
  }
}
