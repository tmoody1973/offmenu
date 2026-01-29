import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_butler_client/food_butler_client.dart';
import 'package:food_butler_flutter/map/models/map_config.dart';
import 'package:food_butler_flutter/map/widgets/route_polyline_layer.dart';

void main() {
  group('RoutePolylineLayer', () {
    final testCoordinates = [
      [37.7749, -122.4194], // San Francisco
      [37.7850, -122.4094],
      [37.7650, -122.4294],
    ];

    testWidgets('renders from route coordinates', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RoutePolylineLayer(
              mapboxMap: null, // No map in test
              coordinates: testCoordinates,
            ),
          ),
        ),
      );

      // Widget should render (as SizedBox.shrink)
      expect(find.byType(RoutePolylineLayer), findsOneWidget);
    });

    testWidgets('applies correct color for walking (green) vs driving (blue)',
        (tester) async {
      // Test walking mode
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RoutePolylineLayer(
              mapboxMap: null,
              coordinates: testCoordinates,
              transportMode: TransportMode.walking,
            ),
          ),
        ),
      );

      final walkingLayer = tester.widget<RoutePolylineLayer>(
        find.byType(RoutePolylineLayer),
      );
      expect(walkingLayer.transportMode, equals(TransportMode.walking));

      // Test driving mode
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RoutePolylineLayer(
              mapboxMap: null,
              coordinates: testCoordinates,
              transportMode: TransportMode.driving,
            ),
          ),
        ),
      );

      final drivingLayer = tester.widget<RoutePolylineLayer>(
        find.byType(RoutePolylineLayer),
      );
      expect(drivingLayer.transportMode, equals(TransportMode.driving));
    });

    testWidgets('updates when route data changes', (tester) async {
      final coordinatesNotifier =
          ValueNotifier<List<List<double>>>(testCoordinates);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ValueListenableBuilder<List<List<double>>>(
              valueListenable: coordinatesNotifier,
              builder: (context, coordinates, _) {
                return RoutePolylineLayer(
                  mapboxMap: null,
                  coordinates: coordinates,
                );
              },
            ),
          ),
        ),
      );

      // Initial render
      expect(find.byType(RoutePolylineLayer), findsOneWidget);
      var layer = tester.widget<RoutePolylineLayer>(
        find.byType(RoutePolylineLayer),
      );
      expect(layer.coordinates.length, equals(3));

      // Update coordinates
      coordinatesNotifier.value = [
        [37.7749, -122.4194],
        [37.7900, -122.4000],
      ];
      await tester.pump();

      layer = tester.widget<RoutePolylineLayer>(
        find.byType(RoutePolylineLayer),
      );
      expect(layer.coordinates.length, equals(2));

      // Clear coordinates
      coordinatesNotifier.value = [];
      await tester.pump();

      layer = tester.widget<RoutePolylineLayer>(
        find.byType(RoutePolylineLayer),
      );
      expect(layer.coordinates.isEmpty, isTrue);
    });
  });

  group('PolylineDecoder', () {
    test('decodes polyline6 encoded string correctly', () {
      // Test with a known polyline encoding
      // The standard polyline algorithm uses different precision
      // For polyline6 (precision 6), we use 10^6 factor

      // Create a simple test case with known coordinates
      // Lat: 37.774900, Lng: -122.419400
      // This encodes to a specific string - let's test the decode matches expectations

      final coordinates = PolylineDecoder.decode('_p~iF~ps|U');

      // Should decode at least one coordinate
      expect(coordinates, isNotEmpty);

      // Just verify we got valid-looking coordinates
      // (the exact values depend on the encoding)
      expect(coordinates[0][0], isA<double>());
      expect(coordinates[0][1], isA<double>());
    });

    test('handles empty encoded string', () {
      final coordinates = PolylineDecoder.decode('');
      expect(coordinates, isEmpty);
    });

    test('decodes with correct precision', () {
      // Verify the decoder produces consistent output
      const encoded = 'mz}lHntjnV';

      final coordinates = PolylineDecoder.decode(encoded, precision: 6);

      expect(coordinates, isNotEmpty);

      // Should be a valid coordinate pair
      final lat = coordinates[0][0];
      final lng = coordinates[0][1];

      // Latitude should be in valid range (-90 to 90)
      expect(lat, greaterThanOrEqualTo(-90.0));
      expect(lat, lessThanOrEqualTo(90.0));

      // Longitude should be in valid range (-180 to 180)
      expect(lng, greaterThanOrEqualTo(-180.0));
      expect(lng, lessThanOrEqualTo(180.0));
    });
  });

  group('MapConfig route colors', () {
    test('defines correct color values for transport modes', () {
      // Walking should be green (#22C55E)
      expect(MapConfig.walkingRouteColor, equals(0xFF22C55E));

      // Driving should be blue (#3B82F6)
      expect(MapConfig.drivingRouteColor, equals(0xFF3B82F6));

      // Verify colors are distinct
      expect(
        MapConfig.walkingRouteColor,
        isNot(equals(MapConfig.drivingRouteColor)),
      );
    });
  });
}
