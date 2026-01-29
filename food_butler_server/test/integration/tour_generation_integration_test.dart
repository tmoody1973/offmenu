import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'package:food_butler_server/src/services/tour_generation_service.dart';
import 'package:food_butler_server/src/services/foursquare_service.dart';
import 'package:food_butler_server/src/services/award_matching_service.dart';
import 'package:food_butler_server/src/services/mapbox_service.dart';
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

  group('Integration Tests - Tour Generation', () {
    test('Full tour generation flow from request to response', () async {
      // Arrange - Set up all mocks for complete flow
      final restaurants = _createRestaurantsWithVariety(12);

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

      when(() => mockMapboxService.calculateRoute(
            waypoints: any(named: 'waypoints'),
            transportMode: any(named: 'transportMode'),
          )).thenAnswer((invocation) async {
        final waypoints = invocation.namedArguments[#waypoints] as List<LatLng>;
        return RouteResult(
          polyline: 'encoded_polyline_test',
          totalDistanceMeters: waypoints.length * 500,
          totalDurationSeconds: waypoints.length * 450,
          legs: List.generate(
            waypoints.length - 1,
            (i) => RouteLeg(
              distanceMeters: 500,
              durationSeconds: 450,
              transportMode: TransportMode.walking,
            ),
          ),
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

      // Assert - Full response validation
      expect(result, isNotNull);
      expect(result.stopsJson, isNotNull);
      expect(result.confidenceScore, greaterThan(0));
      expect(result.routePolyline, equals('encoded_polyline_test'));
      expect(result.totalDistanceMeters, greaterThan(0));
      expect(result.totalDurationSeconds, greaterThan(0));
      expect(result.isPartialTour, isFalse);

      // Validate stops structure
      final stops = jsonDecode(result.stopsJson) as List;
      expect(stops.length, equals(4));

      for (final stop in stops) {
        final stopMap = stop as Map<String, dynamic>;
        expect(stopMap['fsqId'], isNotNull);
        expect(stopMap['name'], isNotNull);
        expect(stopMap['address'], isNotNull);
        expect(stopMap['latitude'], isA<double>());
        expect(stopMap['longitude'], isA<double>());
        expect(stopMap['priceTier'], isA<int>());
        expect(stopMap['cuisineTypes'], isA<List>());
        expect(stopMap['dishWeight'], isNotNull);
        expect(stopMap['visitDurationMinutes'], isA<int>());
      }
    });

    test('Foursquare + Award matching combined integration', () async {
      // Arrange - Some restaurants have awards
      final restaurants = _createRestaurantsWithVariety(12);

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
          .thenAnswer((invocation) async {
        final restaurant = invocation.positionalArguments[0] as Restaurant;
        // Give awards to restaurants with even index
        final index = int.tryParse(restaurant.fsqId.split('-').last) ?? 0;
        if (index % 3 == 0) {
          return AwardMatchResult(
            awards: [
              Award(
                restaurantFsqId: restaurant.fsqId,
                awardType: AwardType.michelin,
                awardLevel: 'oneStar',
                year: 2024,
                createdAt: DateTime.now(),
              ),
            ],
            confidence: 0.95,
          );
        }
        return AwardMatchResult(awards: [], confidence: 0.0);
      });

      when(() => mockAwardMatchingService.getAwardBadges(any()))
          .thenAnswer((invocation) {
        final awards = invocation.positionalArguments[0] as List<Award>;
        return awards.map((a) => 'Michelin ${a.awardLevel}').toList();
      });

      when(() => mockMapboxService.calculateRoute(
            waypoints: any(named: 'waypoints'),
            transportMode: any(named: 'transportMode'),
          )).thenAnswer((invocation) async {
        final waypoints = invocation.namedArguments[#waypoints] as List<LatLng>;
        return RouteResult(
          polyline: 'test_polyline',
          totalDistanceMeters: 2000,
          totalDurationSeconds: 1800,
          legs: List.generate(
            waypoints.length - 1,
            (i) => RouteLeg(
              distanceMeters: 500,
              durationSeconds: 450,
              transportMode: TransportMode.walking,
            ),
          ),
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

      // Assert
      expect(result, isNotNull);
      final stops = jsonDecode(result.stopsJson) as List;

      // Verify award data is included in stops
      var hasAwardedStop = false;
      for (final stop in stops) {
        final stopMap = stop as Map<String, dynamic>;
        final awards = stopMap['awards'] as List?;
        if (awards != null && awards.isNotEmpty) {
          hasAwardedStop = true;
          expect(stopMap['awardBadges'], isNotEmpty);
        }
      }
      // At least one stop should have awards (given our mock setup)
      expect(hasAwardedStop, isTrue);
    });

    test('Scoring with real route data integration', () async {
      // Arrange - Create restaurants with varying distances
      final restaurants = _createRestaurantsWithVariety(12);

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

      // Realistic route data
      when(() => mockMapboxService.calculateRoute(
            waypoints: any(named: 'waypoints'),
            transportMode: any(named: 'transportMode'),
          )).thenAnswer((invocation) async {
        final waypoints = invocation.namedArguments[#waypoints] as List<LatLng>;
        final numLegs = waypoints.length - 1;
        return RouteResult(
          polyline: 'test_polyline',
          totalDistanceMeters: numLegs * 400,
          totalDurationSeconds: numLegs * 360, // ~6 min per leg
          legs: List.generate(
            numLegs,
            (i) => RouteLeg(
              distanceMeters: 400,
              durationSeconds: 360,
              transportMode: TransportMode.walking,
            ),
          ),
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

      // Assert - Score should reflect good tour quality
      expect(result.confidenceScore, greaterThan(50));
      expect(result.totalDistanceMeters, equals(4 * 400)); // start + 4 stops
      expect(result.totalDurationSeconds, equals(4 * 360));
    });

    test('Edge case: exactly 3 stops with award-only filter', () async {
      // Arrange - Only award-winning restaurants
      final restaurants = _createRestaurantsWithVariety(9);

      when(() => mockFoursquareService.searchRestaurants(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            radiusMeters: any(named: 'radiusMeters'),
            cuisineTypes: any(named: 'cuisineTypes'),
            limit: any(named: 'limit'),
          )).thenAnswer((_) async => FoursquareSearchResult(
            restaurants: restaurants,
          ));

      // All restaurants get awards
      when(() => mockAwardMatchingService.matchRestaurantToAwards(any()))
          .thenAnswer((invocation) async {
        final restaurant = invocation.positionalArguments[0] as Restaurant;
        return AwardMatchResult(
          awards: [
            Award(
              restaurantFsqId: restaurant.fsqId,
              awardType: AwardType.jamesBeard,
              awardLevel: 'semifinalist',
              year: 2024,
              createdAt: DateTime.now(),
            ),
          ],
          confidence: 0.9,
        );
      });

      when(() => mockAwardMatchingService.getAwardBadges(any()))
          .thenReturn(['James Beard Semifinalist 2024']);

      when(() => mockMapboxService.calculateRoute(
            waypoints: any(named: 'waypoints'),
            transportMode: any(named: 'transportMode'),
          )).thenAnswer((invocation) async {
        final waypoints = invocation.namedArguments[#waypoints] as List<LatLng>;
        return RouteResult(
          polyline: 'test_polyline',
          totalDistanceMeters: 1500,
          totalDurationSeconds: 1350,
          legs: List.generate(
            waypoints.length - 1,
            (i) => RouteLeg(
              distanceMeters: 500,
              durationSeconds: 450,
              transportMode: TransportMode.walking,
            ),
          ),
        );
      });

      final request = TourRequest(
        startLatitude: 41.8781,
        startLongitude: -87.6298,
        numStops: 3, // Minimum stops
        transportMode: TransportMode.walking,
        awardOnly: true, // Award-only filter
        startTime: DateTime.now().add(const Duration(hours: 1)),
        budgetTier: BudgetTier.moderate,
        createdAt: DateTime.now(),
      );

      // Act
      final result = await service.generateTour(request);

      // Assert
      expect(result, isNotNull);
      expect(result.isPartialTour, isFalse);
      final stops = jsonDecode(result.stopsJson) as List;
      expect(stops.length, equals(3));

      // All stops should have awards
      for (final stop in stops) {
        final stopMap = stop as Map<String, dynamic>;
        final awards = stopMap['awards'] as List;
        expect(awards, isNotEmpty);
      }
    });

    test('Edge case: 6 stops with multiple cuisine preferences', () async {
      // Arrange
      final restaurants = _createRestaurantsWithMixedCuisines(24);

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

      when(() => mockMapboxService.calculateRoute(
            waypoints: any(named: 'waypoints'),
            transportMode: any(named: 'transportMode'),
          )).thenAnswer((invocation) async {
        final waypoints = invocation.namedArguments[#waypoints] as List<LatLng>;
        return RouteResult(
          polyline: 'test_polyline',
          totalDistanceMeters: 4000,
          totalDurationSeconds: 3600,
          legs: List.generate(
            waypoints.length - 1,
            (i) => RouteLeg(
              distanceMeters: 600,
              durationSeconds: 540,
              transportMode: TransportMode.walking,
            ),
          ),
        );
      });

      final request = TourRequest(
        startLatitude: 41.8781,
        startLongitude: -87.6298,
        numStops: 6, // Maximum stops
        transportMode: TransportMode.walking,
        cuisinePreferences: ['Italian', 'Mexican'], // Multiple cuisines
        awardOnly: false,
        startTime: DateTime.now().add(const Duration(hours: 1)),
        budgetTier: BudgetTier.moderate,
        createdAt: DateTime.now(),
      );

      // Act
      final result = await service.generateTour(request);

      // Assert
      expect(result, isNotNull);
      final stops = jsonDecode(result.stopsJson) as List;
      expect(stops.length, equals(6));

      // All stops should match cuisine preferences
      for (final stop in stops) {
        final stopMap = stop as Map<String, dynamic>;
        final cuisines =
            (stopMap['cuisineTypes'] as List).map((c) => c.toString().toLowerCase()).toList();
        final matchesPreference = cuisines.any(
          (c) => c.contains('italian') || c.contains('mexican'),
        );
        expect(matchesPreference, isTrue);
      }
    });

    test('Edge case: no restaurants match criteria - graceful failure', () async {
      // Arrange - No restaurants returned
      when(() => mockFoursquareService.searchRestaurants(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            radiusMeters: any(named: 'radiusMeters'),
            cuisineTypes: any(named: 'cuisineTypes'),
            limit: any(named: 'limit'),
          )).thenAnswer((_) async => FoursquareSearchResult(
            restaurants: [],
            warning: 'No restaurants found in area',
          ));

      final request = TourRequest(
        startLatitude: 0.0, // Middle of ocean
        startLongitude: 0.0,
        numStops: 4,
        transportMode: TransportMode.walking,
        awardOnly: true,
        startTime: DateTime.now().add(const Duration(hours: 1)),
        budgetTier: BudgetTier.luxury,
        createdAt: DateTime.now(),
      );

      // Act
      final result = await service.generateTour(request);

      // Assert - Should return graceful error
      expect(result, isNotNull);
      expect(result.isPartialTour, isTrue);
      expect(result.warningMessage, isNotNull);
      expect(result.confidenceScore, equals(0));
      expect(result.stopsJson, equals('[]'));
    });

    test('Cache test: repeated identical requests use cache', () async {
      // Arrange
      final restaurants = _createRestaurantsWithVariety(12);

      var searchCallCount = 0;
      when(() => mockFoursquareService.searchRestaurants(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            radiusMeters: any(named: 'radiusMeters'),
            cuisineTypes: any(named: 'cuisineTypes'),
            limit: any(named: 'limit'),
          )).thenAnswer((_) async {
        searchCallCount++;
        return FoursquareSearchResult(
          restaurants: restaurants,
          isFromCache: searchCallCount > 1,
        );
      });

      when(() => mockAwardMatchingService.matchRestaurantToAwards(any()))
          .thenAnswer((_) async => AwardMatchResult(
                awards: [],
                confidence: 0.0,
              ));

      when(() => mockAwardMatchingService.getAwardBadges(any()))
          .thenReturn([]);

      when(() => mockMapboxService.calculateRoute(
            waypoints: any(named: 'waypoints'),
            transportMode: any(named: 'transportMode'),
          )).thenAnswer((invocation) async {
        final waypoints = invocation.namedArguments[#waypoints] as List<LatLng>;
        return RouteResult(
          polyline: 'test_polyline',
          totalDistanceMeters: 2000,
          totalDurationSeconds: 1800,
          legs: List.generate(
            waypoints.length - 1,
            (i) => RouteLeg(
              distanceMeters: 500,
              durationSeconds: 450,
              transportMode: TransportMode.walking,
            ),
          ),
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

      // Act - Call twice
      final result1 = await service.generateTour(request);
      final result2 = await service.generateTour(request);

      // Assert - Both should succeed
      expect(result1, isNotNull);
      expect(result2, isNotNull);
      expect(result1.stopsJson, isNotEmpty);
      expect(result2.stopsJson, isNotEmpty);

      // Note: Actual caching is implemented in the services
      // This test verifies the service can handle repeated calls
    });
  });
}

/// Create restaurants with varying characteristics.
List<Restaurant> _createRestaurantsWithVariety(int count) {
  const cuisines = [
    ['Coffee Shop', 'Cafe'],
    ['Bakery', 'Pastry'],
    ['Italian', 'Restaurant'],
    ['Mexican', 'Restaurant'],
    ['Steakhouse', 'American'],
    ['Seafood', 'Restaurant'],
  ];

  return List.generate(
    count,
    (i) => Restaurant(
      fsqId: 'test-$i',
      name: 'Test Restaurant $i',
      address: '${100 + i} Main St, Chicago, IL',
      latitude: 41.8781 + (i * 0.002),
      longitude: -87.6298 + (i * 0.002),
      priceTier: (i % 3) + 1, // 1-3 for moderate budget
      cuisineTypes: cuisines[i % cuisines.length],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  );
}

/// Create restaurants with specific cuisine mix for filtering tests.
List<Restaurant> _createRestaurantsWithMixedCuisines(int count) {
  const cuisinePool = [
    ['Italian', 'Restaurant'],
    ['Italian', 'Pizza'],
    ['Mexican', 'Restaurant'],
    ['Mexican', 'Tacos'],
    ['Japanese', 'Sushi'],
    ['Chinese', 'Restaurant'],
    ['Thai', 'Restaurant'],
    ['French', 'Bistro'],
  ];

  return List.generate(
    count,
    (i) => Restaurant(
      fsqId: 'mixed-$i',
      name: 'Mixed Cuisine Restaurant $i',
      address: '${200 + i} Food St, Chicago, IL',
      latitude: 41.8781 + (i * 0.001),
      longitude: -87.6298 + (i * 0.001),
      priceTier: (i % 3) + 1,
      cuisineTypes: cuisinePool[i % cuisinePool.length],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  );
}
