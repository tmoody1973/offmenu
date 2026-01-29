import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_butler_flutter/map/services/geocoding_service.dart';
import 'package:food_butler_flutter/map/services/geolocation_service.dart';
import 'package:food_butler_flutter/map/widgets/address_search_input.dart';

void main() {
  group('GeocodingService', () {
    testWidgets('autocomplete suggestions appear as user types',
        (tester) async {
      final geocodingService = MockGeocodingService();

      AddressResult? selectedAddress;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: AddressSearchInput(
                geocodingService: geocodingService,
                onAddressSelect: (address) {
                  selectedAddress = address;
                },
              ),
            ),
          ),
        ),
      );

      // Type in the search field
      await tester.enterText(find.byType(TextField), 'San Francisco');
      await tester.pump();

      // Wait for debounce
      await tester.pump(const Duration(milliseconds: 350));

      // Suggestions should appear
      await tester.pumpAndSettle();

      expect(find.byType(AddressSuggestionList), findsOneWidget);
      expect(find.text('123 Main St, San Francisco, CA'), findsOneWidget);
    });

    testWidgets('address selection returns coordinates', (tester) async {
      final geocodingService = MockGeocodingService();

      AddressResult? selectedAddress;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: AddressSearchInput(
                geocodingService: geocodingService,
                onAddressSelect: (address) {
                  selectedAddress = address;
                },
              ),
            ),
          ),
        ),
      );

      // Type and wait for suggestions
      await tester.enterText(find.byType(TextField), 'San');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      // Tap on a suggestion
      await tester.tap(find.text('123 Main St, San Francisco, CA'));
      await tester.pumpAndSettle();

      // Address should be selected with coordinates
      expect(selectedAddress, isNotNull);
      expect(selectedAddress!.latitude, equals(37.7749));
      expect(selectedAddress!.longitude, equals(-122.4194));
    });

    testWidgets('"Use my current location" option works', (tester) async {
      final geocodingService = MockGeocodingService();
      final geolocationService = MockGeolocationService();

      // Set up mock location
      geolocationService.mockLocation = UserLocation(
        latitude: 37.7849,
        longitude: -122.4094,
        timestamp: DateTime.now(),
      );

      AddressResult? selectedAddress;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: AddressSearchInput(
                geocodingService: geocodingService,
                geolocationService: geolocationService,
                onAddressSelect: (address) {
                  selectedAddress = address;
                },
              ),
            ),
          ),
        ),
      );

      // Find and tap "Use my current location"
      await tester.tap(find.text('Use my current location'));
      await tester.pump();
      await tester.pumpAndSettle();

      // Address should be set from reverse geocoding
      expect(selectedAddress, isNotNull);
    });

    testWidgets('handles no results gracefully', (tester) async {
      final geocodingService = MockGeocodingService();
      geocodingService.mockResults = []; // No results

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: AddressSearchInput(
                geocodingService: geocodingService,
              ),
            ),
          ),
        ),
      );

      // Type in the search field
      await tester.enterText(find.byType(TextField), 'xyz123nonexistent');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      // Should show "No results found" or similar
      // The suggestion list will not be shown because it's empty
      expect(find.byType(ListTile), findsNothing);
    });
  });

  group('AddressSuggestionList', () {
    testWidgets('renders suggestions correctly', (tester) async {
      final suggestions = MockGeocodingService.createMockResults(count: 3);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddressSuggestionList(
              suggestions: suggestions,
            ),
          ),
        ),
      );

      expect(find.byType(ListTile), findsNWidgets(3));
    });

    testWidgets('shows loading state', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AddressSuggestionList(
              suggestions: [],
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows no results message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AddressSuggestionList(
              suggestions: [],
              isLoading: false,
            ),
          ),
        ),
      );

      expect(find.text('No results found'), findsOneWidget);
    });
  });

  group('AddressResult', () {
    test('contains required coordinate data', () {
      const result = AddressResult(
        id: '1',
        displayText: 'Test Address',
        formattedAddress: '123 Test St, City, State 12345',
        latitude: 37.7749,
        longitude: -122.4194,
      );

      expect(result.id, equals('1'));
      expect(result.latitude, equals(37.7749));
      expect(result.longitude, equals(-122.4194));
    });
  });
}
