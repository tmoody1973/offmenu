import 'package:flutter_test/flutter_test.dart';
import 'package:food_butler_flutter/map/models/tour_stop_marker.dart';
import 'package:food_butler_flutter/map/services/geolocation_service.dart';
import 'package:food_butler_flutter/map/utils/bounds_calculator.dart';

void main() {
  final testStops = [
    const TourStopMarker(
      id: 'stop_1',
      stopNumber: 1,
      latitude: 37.7749, // San Francisco
      longitude: -122.4194,
      name: 'Restaurant A',
      address: '123 Main St',
    ),
    const TourStopMarker(
      id: 'stop_2',
      stopNumber: 2,
      latitude: 37.7850, // North of SF
      longitude: -122.4094,
      name: 'Restaurant B',
      address: '456 Oak Ave',
    ),
    const TourStopMarker(
      id: 'stop_3',
      stopNumber: 3,
      latitude: 37.7650, // South of SF
      longitude: -122.4294,
      name: 'Restaurant C',
      address: '789 Pine Blvd',
    ),
  ];

  group('BoundsCalculator', () {
    test('calculateTourBounds includes all tour stops', () {
      final bounds = BoundsCalculator.calculateTourBounds(testStops);

      expect(bounds, isNotNull);

      // Bounds should encompass all stops (with padding)
      // North should be >= northernmost stop
      expect(bounds!.north, greaterThanOrEqualTo(37.7850));
      // South should be <= southernmost stop
      expect(bounds.south, lessThanOrEqualTo(37.7650));
      // East should be >= easternmost stop
      expect(bounds.east, greaterThanOrEqualTo(-122.4094));
      // West should be <= westernmost stop
      expect(bounds.west, lessThanOrEqualTo(-122.4294));
    });

    test('calculateTourBounds includes user location when available', () {
      final userLocation = UserLocation(
        latitude: 37.8000, // North of all stops
        longitude: -122.3900, // East of all stops
        timestamp: DateTime.now(),
      );

      final boundsWithoutUser = BoundsCalculator.calculateTourBounds(testStops);
      final boundsWithUser = BoundsCalculator.calculateTourBounds(
        testStops,
        userLocation: userLocation,
      );

      expect(boundsWithoutUser, isNotNull);
      expect(boundsWithUser, isNotNull);

      // Bounds with user should extend further north
      expect(boundsWithUser!.north, greaterThan(boundsWithoutUser!.north - 0.1));

      // Bounds with user should extend further east
      expect(boundsWithUser.east, greaterThan(boundsWithoutUser.east - 0.1));
    });

    test('calculateTourBounds applies padding correctly', () {
      final noPadding = BoundsCalculator.calculateTourBounds(
        testStops,
        paddingFactor: 0.0,
      );
      final withPadding = BoundsCalculator.calculateTourBounds(
        testStops,
        paddingFactor: 0.2, // 20% padding
      );

      expect(noPadding, isNotNull);
      expect(withPadding, isNotNull);

      // With padding should have larger bounds
      expect(withPadding!.north, greaterThan(noPadding!.north));
      expect(withPadding.south, lessThan(noPadding.south));
      expect(withPadding.east, greaterThan(noPadding.east));
      expect(withPadding.west, lessThan(noPadding.west));
    });

    test('calculateTourBounds returns null for empty stops', () {
      final bounds = BoundsCalculator.calculateTourBounds([]);
      expect(bounds, isNull);
    });

    test('calculateTourBounds handles single stop', () {
      final singleStop = [testStops.first];
      final bounds = BoundsCalculator.calculateTourBounds(singleStop);

      expect(bounds, isNotNull);
      // Center should be at the stop location (approximately)
      expect(
        bounds!.centerLatitude,
        closeTo(testStops.first.latitude, 0.1),
      );
      expect(
        bounds.centerLongitude,
        closeTo(testStops.first.longitude, 0.1),
      );
    });
  });

  group('MapBounds', () {
    test('calculates center correctly', () {
      const bounds = MapBounds(
        north: 38.0,
        south: 37.0,
        east: -122.0,
        west: -123.0,
      );

      expect(bounds.centerLatitude, equals(37.5));
      expect(bounds.centerLongitude, equals(-122.5));
    });

    test('calculates span correctly', () {
      const bounds = MapBounds(
        north: 38.0,
        south: 37.0,
        east: -122.0,
        west: -123.0,
      );

      expect(bounds.latitudeSpan, equals(1.0));
      expect(bounds.longitudeSpan, equals(1.0));
    });

    test('withPadding expands bounds correctly', () {
      const bounds = MapBounds(
        north: 38.0,
        south: 37.0,
        east: -122.0,
        west: -123.0,
      );

      final padded = bounds.withPadding(0.1); // 10% padding

      expect(padded.north, greaterThan(bounds.north));
      expect(padded.south, lessThan(bounds.south));
      expect(padded.east, greaterThan(bounds.east));
      expect(padded.west, lessThan(bounds.west));

      // Verify padding is approximately 10%
      expect(padded.north - bounds.north, closeTo(0.1, 0.01));
      expect(bounds.south - padded.south, closeTo(0.1, 0.01));
    });
  });
}
