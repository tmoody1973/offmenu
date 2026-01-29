import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'package:food_butler_server/src/services/tour_generation_service.dart';
import 'package:food_butler_server/src/services/foursquare_service.dart';
import 'package:food_butler_server/src/services/award_matching_service.dart';
import 'package:food_butler_server/src/services/mapbox_service.dart';
import 'package:food_butler_server/src/errors/tour_generation_exceptions.dart';
import 'package:food_butler_server/src/generated/protocol.dart';

class MockFoursquareService extends Mock implements FoursquareService {}

class MockAwardMatchingService extends Mock implements AwardMatchingService {}

class MockMapboxService extends Mock implements MapboxService {}

class MockSession extends Mock implements Session {}

/// Fake Restaurant for mocktail fallback registration.
class FakeRestaurant extends Fake implements Restaurant {}

void main() {
  late MockFoursquareService mockFoursquareService;
  late MockAwardMatchingService mockAwardMatchingService;
  late MockMapboxService mockMapboxService;
  late MockSession mockSession;
  late TourGenerationService service;

  setUpAll(() {
    registerFallbackValue(FakeRestaurant());
    registerFallbackValue(TransportMode.walking);
    registerFallbackValue(<LatLng>[]);
    registerFallbackValue(<Award>[]);
  });

  setUp(() {
    mockFoursquareService = MockFoursquareService();
    mockAwardMatchingService = MockAwardMatchingService();
    mockMapboxService = MockMapboxService();
    mockSession = MockSession();

    when(() => mockSession.log(any(), level: any(named: 'level')))
        .thenReturn(null);

    service = TourGenerationService(
      foursquareService: mockFoursquareService,
      awardMatchingService: mockAwardMatchingService,
      mapboxService: mockMapboxService,
      session: mockSession,
    );
  });

  group('Error Handling', () {
    test('Foursquare API failure returns partial results with warning', () async {
      // Arrange - Foursquare returns empty results with warning
      when(() => mockFoursquareService.searchRestaurants(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            radiusMeters: any(named: 'radiusMeters'),
            cuisineTypes: any(named: 'cuisineTypes'),
            limit: any(named: 'limit'),
          )).thenAnswer((_) async => FoursquareSearchResult(
            restaurants: [],
            warning: 'Unable to fetch restaurants. Please try again later.',
          ));

      final request = TourRequest(
        startLatitude: 41.8781,
        startLongitude: -87.6298,
        numStops: 4,
        transportMode: TransportMode.walking,
        awardOnly: false,
        startTime: DateTime.now().add(const Duration(hours: 1)),
        budgetTier: BudgetTier.moderate,
        createdAt: DateTime.now(),
      );

      // Act
      final result = await service.generateTour(request);

      // Assert - should return graceful error, not throw
      expect(result, isNotNull);
      expect(result.warningMessage, isNotNull);
      expect(result.isPartialTour, isTrue);
      // Should not contain stack traces
      expect(result.warningMessage, isNot(contains('Exception')));
      expect(result.warningMessage, isNot(contains('Stack')));
    });

    test('Mapbox API failure returns estimated distances', () async {
      // Arrange - Foursquare works, Mapbox fails with fallback
      final restaurants = _createRestaurants(12);
      when(() => mockFoursquareService.searchRestaurants(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            radiusMeters: any(named: 'radiusMeters'),
            cuisineTypes: any(named: 'cuisineTypes'),
            limit: any(named: 'limit'),
          )).thenAnswer((_) async => FoursquareSearchResult(
            restaurants: restaurants,
          ));

      when(() => mockAwardMatchingService.matchRestaurantToAwards(any()))
          .thenAnswer((_) async => AwardMatchResult(
                awards: [],
                confidence: 0.0,
              ));

      when(() => mockAwardMatchingService.getAwardBadges(any()))
          .thenReturn([]);

      // Mapbox returns fallback with warning (simulating API failure with graceful degradation)
      when(() => mockMapboxService.calculateRoute(
            waypoints: any(named: 'waypoints'),
            transportMode: any(named: 'transportMode'),
          )).thenAnswer((invocation) async {
        final waypoints = invocation.namedArguments[#waypoints] as List<LatLng>;
        final transportMode =
            invocation.namedArguments[#transportMode] as TransportMode;
        return RouteResult.fallback(
          waypoints: waypoints,
          transportMode: transportMode,
          warning: 'Unable to calculate route. Using estimated distances.',
        );
      });

      final request = TourRequest(
        startLatitude: 41.8781,
        startLongitude: -87.6298,
        numStops: 4,
        transportMode: TransportMode.walking,
        awardOnly: false,
        startTime: DateTime.now().add(const Duration(hours: 1)),
        budgetTier: BudgetTier.moderate,
        createdAt: DateTime.now(),
      );

      // Act
      final result = await service.generateTour(request);

      // Assert - should return tour with estimated distances
      expect(result, isNotNull);
      expect(result.stopsJson, isNotNull);
      final stopsCount = (jsonDecode(result.stopsJson) as List).length;
      expect(stopsCount, greaterThan(0));

      // Should have distance estimates even if Mapbox failed
      expect(result.totalDistanceMeters, greaterThanOrEqualTo(0));
      expect(result.totalDurationSeconds, greaterThanOrEqualTo(0));
    });

    test('Combined API failures return graceful error response', () async {
      // Arrange - Both Foursquare and any subsequent service fails
      when(() => mockFoursquareService.searchRestaurants(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            radiusMeters: any(named: 'radiusMeters'),
            cuisineTypes: any(named: 'cuisineTypes'),
            limit: any(named: 'limit'),
          )).thenThrow(Exception('Network error'));

      final request = TourRequest(
        startLatitude: 41.8781,
        startLongitude: -87.6298,
        numStops: 4,
        transportMode: TransportMode.walking,
        awardOnly: false,
        startTime: DateTime.now().add(const Duration(hours: 1)),
        budgetTier: BudgetTier.moderate,
        createdAt: DateTime.now(),
      );

      // Act
      final result = await service.generateTour(request);

      // Assert - should return error result, not throw exception
      expect(result, isNotNull);
      expect(result.isPartialTour, isTrue);
      expect(result.warningMessage, isNotNull);
      // Error message should be user-friendly
      expect(result.warningMessage!.toLowerCase(), contains('error'));
      expect(result.warningMessage!.toLowerCase(), isNot(contains('network error')));
    });

    test('Error messages are user-friendly without stack traces', () async {
      // Arrange - Service throws an internal exception
      when(() => mockFoursquareService.searchRestaurants(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            radiusMeters: any(named: 'radiusMeters'),
            cuisineTypes: any(named: 'cuisineTypes'),
            limit: any(named: 'limit'),
          )).thenThrow(StateError('Internal state error with details'));

      final request = TourRequest(
        startLatitude: 41.8781,
        startLongitude: -87.6298,
        numStops: 4,
        transportMode: TransportMode.walking,
        awardOnly: false,
        startTime: DateTime.now().add(const Duration(hours: 1)),
        budgetTier: BudgetTier.moderate,
        createdAt: DateTime.now(),
      );

      // Act
      final result = await service.generateTour(request);

      // Assert
      expect(result, isNotNull);
      expect(result.warningMessage, isNotNull);

      // Verify no internal details exposed
      expect(result.warningMessage, isNot(contains('StateError')));
      expect(result.warningMessage, isNot(contains('Internal state')));
      expect(result.warningMessage, isNot(contains('dart:')));
      expect(result.warningMessage, isNot(contains('.dart')));
      expect(result.warningMessage, isNot(contains('line ')));
      expect(result.warningMessage, isNot(contains('#0')));

      // Should have a generic user-friendly message
      expect(
        result.warningMessage!.toLowerCase().contains('error') ||
            result.warningMessage!.toLowerCase().contains('try again'),
        isTrue,
      );
    });
  });
}

/// Create a list of test restaurants.
List<Restaurant> _createRestaurants(int count) {
  return List.generate(
    count,
    (i) => Restaurant(
      fsqId: 'test-$i',
      name: 'Test Restaurant $i',
      address: '${100 + i} Main St, Chicago, IL',
      latitude: 41.8781 + (i * 0.005),
      longitude: -87.6298 + (i * 0.005),
      priceTier: (i % 4) + 1,
      cuisineTypes: ['Restaurant', _getCuisineForIndex(i)],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  );
}

/// Get a cuisine type based on index for variety.
String _getCuisineForIndex(int i) {
  const cuisines = [
    'Coffee Shop',
    'Bakery',
    'Cafe',
    'Italian',
    'Mexican',
    'Steakhouse',
  ];
  return cuisines[i % cuisines.length];
}
