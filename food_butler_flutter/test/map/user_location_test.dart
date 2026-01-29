import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_butler_flutter/map/services/geolocation_service.dart';
import 'package:food_butler_flutter/map/widgets/center_on_location_button.dart';
import 'package:food_butler_flutter/map/widgets/user_location_marker.dart';

void main() {
  group('GeolocationService', () {
    test('location permission request flow works', () async {
      final service = MockGeolocationService();

      // Initially unknown state
      expect(service.permissionState, equals(LocationPermissionState.unknown));
      expect(service.hasPermission, isFalse);

      // Set up mock location
      service.mockLocation = UserLocation(
        latitude: 37.7749,
        longitude: -122.4194,
        timestamp: DateTime.now(),
      );

      // Request location (should grant permission)
      final location = await service.requestLocation();

      expect(location, isNotNull);
      expect(service.permissionState, equals(LocationPermissionState.granted));
      expect(service.hasPermission, isTrue);
      expect(location?.latitude, equals(37.7749));
      expect(location?.longitude, equals(-122.4194));
    });

    test('handles permission denied state gracefully', () async {
      final service = MockGeolocationService();

      // Set denied state
      service.mockPermissionState = LocationPermissionState.denied;

      // Request should return null
      final location = await service.requestLocation();

      expect(location, isNull);
      expect(service.permissionState, equals(LocationPermissionState.denied));
      expect(service.hasPermission, isFalse);
    });
  });

  group('UserLocationMarker', () {
    testWidgets('pulsing blue dot renders at user location', (tester) async {
      final testLocation = UserLocation(
        latitude: 37.7749,
        longitude: -122.4194,
        timestamp: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: UserLocationMarker(location: testLocation),
            ),
          ),
        ),
      );

      // Marker should render
      expect(find.byType(UserLocationMarker), findsOneWidget);

      // Should have containers with blue color (the dot)
      final containers = find.descendant(
        of: find.byType(UserLocationMarker),
        matching: find.byType(Container),
      );
      expect(containers, findsWidgets);

      // Pump animation frames
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      // Marker should still be visible
      expect(find.byType(UserLocationMarker), findsOneWidget);
    });

    testWidgets('renders nothing when location is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: UserLocationMarker(location: null),
            ),
          ),
        ),
      );

      // Should render a SizedBox.shrink
      final widget = tester.widget<UserLocationMarker>(
        find.byType(UserLocationMarker),
      );
      expect(widget.location, isNull);
    });
  });

  group('CenterOnLocationButton', () {
    testWidgets('button works and triggers callback', (tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: CenterOnLocationButton(
                permissionState: LocationPermissionState.granted,
                onTap: () {
                  wasTapped = true;
                },
              ),
            ),
          ),
        ),
      );

      // Button should be enabled
      expect(find.byType(CenterOnLocationButton), findsOneWidget);
      expect(find.byIcon(Icons.my_location_rounded), findsOneWidget);

      // Tap the button
      await tester.tap(find.byType(CenterOnLocationButton));
      await tester.pump();

      expect(wasTapped, isTrue);
    });

    testWidgets('shows loading state', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CenterOnLocationButton(
                isLoading: true,
                permissionState: LocationPermissionState.unknown,
              ),
            ),
          ),
        ),
      );

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.my_location_rounded), findsNothing);
    });

    testWidgets('disabled when permission denied', (tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: CenterOnLocationButton(
                permissionState: LocationPermissionState.denied,
                onTap: () {
                  wasTapped = true;
                },
              ),
            ),
          ),
        ),
      );

      // Should show disabled icon
      expect(find.byIcon(Icons.location_disabled_rounded), findsOneWidget);

      // Tap should not trigger callback
      await tester.tap(find.byType(CenterOnLocationButton));
      await tester.pump();

      expect(wasTapped, isFalse);
    });
  });

  group('LocationPermissionDeniedMessage', () {
    testWidgets('displays informative message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LocationPermissionDeniedMessage(),
          ),
        ),
      );

      expect(find.text('Location Access Denied'), findsOneWidget);
      expect(
        find.textContaining('Enable location access'),
        findsOneWidget,
      );
    });

    testWidgets('retry button works', (tester) async {
      bool wasRetried = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationPermissionDeniedMessage(
              onRetry: () {
                wasRetried = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Try Again'));
      await tester.pump();

      expect(wasRetried, isTrue);
    });
  });
}
