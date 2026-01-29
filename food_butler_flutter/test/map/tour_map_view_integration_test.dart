import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_butler_client/food_butler_client.dart';
import 'package:food_butler_flutter/map/models/tour_stop_marker.dart';
import 'package:food_butler_flutter/map/services/directions_service.dart';
import 'package:food_butler_flutter/map/services/geolocation_service.dart';
import 'package:food_butler_flutter/map/services/mapbox_token_service.dart';
import 'package:food_butler_flutter/map/widgets/center_on_location_button.dart';
import 'package:food_butler_flutter/map/widgets/directions_panel.dart';
import 'package:food_butler_flutter/map/widgets/numbered_marker_widget.dart';
import 'package:food_butler_flutter/map/widgets/restaurant_info_bottom_sheet.dart';
import 'package:food_butler_flutter/map/widgets/tour_map_view.dart';
import 'package:food_butler_flutter/map/widgets/tour_markers_layer.dart';

void main() {
  setUp(() {
    // Configure mock token for tests
    MapboxTokenService.initialize('pk.test_token');
  });

  TourResult createMockTourResult() {
    final stops = [
      {
        'name': 'Restaurant A',
        'address': '123 Main St',
        'latitude': 37.7749,
        'longitude': -122.4194,
        'awardBadges': ['michelin_one_star'],
      },
      {
        'name': 'Restaurant B',
        'address': '456 Oak Ave',
        'latitude': 37.7850,
        'longitude': -122.4094,
        'awardBadges': ['james_beard_winner'],
      },
      {
        'name': 'Restaurant C',
        'address': '789 Pine Blvd',
        'latitude': 37.7650,
        'longitude': -122.4294,
        'awardBadges': [],
      },
    ];

    return TourResult(
      id: 1,
      requestId: 1,
      stopsJson: jsonEncode(stops),
      confidenceScore: 85,
      routePolyline: '', // Empty for test simplicity
      routeLegsJson: '[]',
      totalDistanceMeters: 2000,
      totalDurationSeconds: 1800,
      isPartialTour: false,
      createdAt: DateTime.now(),
    );
  }

  group('TourMapView Integration', () {
    testWidgets('complete tour renders with markers, polyline, and bounds',
        (tester) async {
      final tourData = createMockTourResult();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TourMapView(
              tourData: tourData,
              transportMode: TransportMode.walking,
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Map view should render
      expect(find.byType(TourMapView), findsOneWidget);

      // Markers layer should render
      expect(find.byType(TourMarkersLayer), findsOneWidget);

      // Should have 3 markers
      expect(find.byType(NumberedMarkerWidget), findsNWidgets(3));

      // Should have control buttons
      expect(find.byType(CenterOnLocationButton), findsOneWidget);
    });

    testWidgets('marker tap opens bottom sheet with correct data',
        (tester) async {
      final tourData = createMockTourResult();
      TourStopMarker? selectedStop;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TourMapView(
              tourData: tourData,
              onRestaurantSelect: (stop) {
                selectedStop = stop;
              },
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Tap on marker 1
      await tester.tap(find.text('1'));
      await tester.pumpAndSettle();

      // Bottom sheet should appear
      expect(find.byType(RestaurantInfoBottomSheet), findsOneWidget);

      // Should display restaurant info
      expect(find.text('Restaurant A'), findsOneWidget);
      expect(find.text('Stop 1'), findsOneWidget);
    });

    testWidgets('directions request and display flow works end-to-end',
        (tester) async {
      final tourData = createMockTourResult();
      final mockDirectionsService = MockDirectionsService();
      mockDirectionsService.mockResult =
          MockDirectionsService.createMockResult();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TourMapView(
              tourData: tourData,
              directionsService: mockDirectionsService,
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Find and tap the directions button
      final directionsButton = find.byIcon(Icons.directions_rounded);
      expect(directionsButton, findsOneWidget);

      await tester.tap(directionsButton);
      await tester.pump();

      // Wait for async directions fetch
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 500));

      // Directions panel should appear
      expect(find.byType(DirectionsPanel), findsOneWidget);
    });
  });

  group('State Management', () {
    testWidgets('selected marker state updates correctly', (tester) async {
      final tourData = createMockTourResult();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TourMapView(tourData: tourData),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Tap marker 1
      await tester.tap(find.text('1'));
      await tester.pumpAndSettle();

      // Dismiss bottom sheet by tapping outside
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      // Tap marker 2
      await tester.tap(find.text('2'));
      await tester.pumpAndSettle();

      // New bottom sheet should show Restaurant B
      expect(find.text('Restaurant B'), findsOneWidget);
    });

    testWidgets('user location button is present and tappable', (tester) async {
      final tourData = createMockTourResult();
      final mockGeolocationService = MockGeolocationService();
      mockGeolocationService.mockLocation = UserLocation(
        latitude: 37.7800,
        longitude: -122.4100,
        timestamp: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TourMapView(
              tourData: tourData,
              geolocationService: mockGeolocationService,
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Center on location button should exist
      expect(find.byType(CenterOnLocationButton), findsOneWidget);

      // Tap center on location button
      await tester.tap(find.byType(CenterOnLocationButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Should have made the request (state updated)
      expect(mockGeolocationService.lastLocation, isNotNull);
    });
  });

  group('Tour Data Flow', () {
    testWidgets('handles loading state for tour data', (tester) async {
      // No tour data initially
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TourMapView(tourData: null),
          ),
        ),
      );

      await tester.pump();

      // Should render without markers
      expect(find.byType(NumberedMarkerWidget), findsNothing);
    });

    testWidgets('handles error state for tour data', (tester) async {
      // Create tour result with invalid JSON
      final invalidTour = TourResult(
        id: 1,
        requestId: 1,
        stopsJson: 'invalid json',
        confidenceScore: 0,
        routePolyline: '',
        routeLegsJson: '[]',
        totalDistanceMeters: 0,
        totalDurationSeconds: 0,
        isPartialTour: true,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TourMapView(tourData: invalidTour),
          ),
        ),
      );

      await tester.pump();

      // Should render without crashing, no markers
      expect(find.byType(TourMapView), findsOneWidget);
      expect(find.byType(NumberedMarkerWidget), findsNothing);
    });
  });
}
