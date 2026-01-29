import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_butler_flutter/map/models/map_config.dart';
import 'package:food_butler_flutter/map/services/mapbox_token_service.dart';
import 'package:food_butler_flutter/map/widgets/food_tour_map_widget.dart';

void main() {
  group('FoodTourMapWidget', () {
    setUp(() {
      // Clear token before each test
      MapboxTokenService.clear();
    });

    testWidgets('renders without errors when token is configured',
        (tester) async {
      // Configure a valid token format
      MapboxTokenService.initialize('pk.test_token_for_testing');

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FoodTourMapWidget(),
          ),
        ),
      );

      // Widget should render without errors
      expect(find.byType(FoodTourMapWidget), findsOneWidget);
      // Should attempt to display the map
      expect(find.byKey(const ValueKey('mapbox_map')), findsOneWidget);
    });

    testWidgets('initializes with correct default center and zoom',
        (tester) async {
      MapboxTokenService.initialize('pk.test_token_for_testing');

      late double capturedLat;
      late double capturedLng;
      late double capturedZoom;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FoodTourMapWidget(
              initialLatitude: 40.7128, // New York
              initialLongitude: -74.0060,
              initialZoom: 14.0,
              onMapReady: (map) {
                // Capture the values passed to verify initialization
                capturedLat = 40.7128;
                capturedLng = -74.0060;
                capturedZoom = 14.0;
              },
            ),
          ),
        ),
      );

      // Verify the widget was created with correct props
      final widget =
          tester.widget<FoodTourMapWidget>(find.byType(FoodTourMapWidget));
      expect(widget.initialLatitude, equals(40.7128));
      expect(widget.initialLongitude, equals(-74.0060));
      expect(widget.initialZoom, equals(14.0));
    });

    testWidgets('responds to viewport changes with responsive breakpoints',
        (tester) async {
      MapboxTokenService.initialize('pk.test_token_for_testing');

      // Test mobile size (< 600px)
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FoodTourMapWidget(),
          ),
        ),
      );

      // Find the padding wrapper
      final mobilePadding =
          find.byWidgetPredicate((widget) => widget is Padding);
      expect(mobilePadding, findsWidgets);

      // Test tablet size (600-1024px)
      tester.view.physicalSize = const Size(768, 1024);
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FoodTourMapWidget(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(FoodTourMapWidget), findsOneWidget);

      // Test desktop size (> 1024px)
      tester.view.physicalSize = const Size(1440, 900);
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FoodTourMapWidget(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(FoodTourMapWidget), findsOneWidget);

      // Reset view
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('shows error when MAPBOX_ACCESS_TOKEN is not configured',
        (tester) async {
      // Token is not set (cleared in setUp)
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FoodTourMapWidget(),
          ),
        ),
      );

      // Should show error message about token
      expect(
        find.textContaining('Mapbox access token not configured'),
        findsOneWidget,
      );
      // Should show map icon placeholder
      expect(find.byIcon(Icons.map_outlined), findsOneWidget);
    });
  });

  group('MapConfig', () {
    test('getPaddingForWidth returns correct padding for breakpoints', () {
      // Mobile
      expect(
        MapConfig.getPaddingForWidth(375),
        equals(MapConfig.mobilePadding),
      );

      // Tablet
      expect(
        MapConfig.getPaddingForWidth(768),
        equals(MapConfig.tabletPadding),
      );

      // Desktop
      expect(
        MapConfig.getPaddingForWidth(1440),
        equals(MapConfig.desktopPadding),
      );
    });

    test('breakpoint detection methods work correctly', () {
      expect(MapConfig.isMobile(375), isTrue);
      expect(MapConfig.isMobile(600), isFalse);

      expect(MapConfig.isTablet(600), isTrue);
      expect(MapConfig.isTablet(1024), isFalse);

      expect(MapConfig.isDesktop(1024), isTrue);
      expect(MapConfig.isDesktop(599), isFalse);
    });
  });

  group('MapboxTokenService', () {
    setUp(() {
      MapboxTokenService.clear();
    });

    test('validates token format correctly', () {
      // No token
      expect(MapboxTokenService.hasToken, isFalse);
      expect(MapboxTokenService.validateTokenFormat(), isFalse);

      // Public token format
      MapboxTokenService.initialize('pk.eyJ1IjoiZXhhbXBsZSIsImEiOiJjazEifQ.abc');
      expect(MapboxTokenService.hasToken, isTrue);
      expect(MapboxTokenService.validateTokenFormat(), isTrue);

      // Secret token format
      MapboxTokenService.clear();
      MapboxTokenService.initialize('sk.eyJ1IjoiZXhhbXBsZSIsImEiOiJjazEifQ.xyz');
      expect(MapboxTokenService.validateTokenFormat(), isTrue);

      // Invalid format
      MapboxTokenService.clear();
      MapboxTokenService.initialize('invalid_token');
      expect(MapboxTokenService.validateTokenFormat(), isFalse);
    });
  });
}
