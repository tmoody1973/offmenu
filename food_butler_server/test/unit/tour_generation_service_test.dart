import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'package:food_butler_server/src/services/tour_generation_service.dart';
import 'package:food_butler_server/src/services/foursquare_service.dart';
import 'package:food_butler_server/src/services/award_matching_service.dart';
import 'package:food_butler_server/src/services/mapbox_service.dart';
import 'package:food_butler_server/src/services/tour_scoring_service.dart';
import 'package:food_butler_server/src/generated/protocol.dart';

class MockFoursquareService extends Mock implements FoursquareService {}

class MockAwardMatchingService extends Mock implements AwardMatchingService {}

class MockMapboxService extends Mock implements MapboxService {}

class MockSession extends Mock implements Session {}

/// Fake Restaurant for mocktail fallback registration.
class FakeRestaurant extends Fake implements Restaurant {}

/// Fake LatLng for mocktail fallback registration.
class FakeLatLng extends Fake implements LatLng {}

void main() {
  late MockFoursquareService mockFoursquareService;
  late MockAwardMatchingService mockAwardMatchingService;
  late MockMapboxService mockMapboxService;
  late MockSession mockSession;
  late TourGenerationService service;

  setUpAll(() {
    // Register fallback values for mocktail
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

  /// Helper to count stops from stopsJson.
  int countStops(String stopsJson) {
    final stops = jsonDecode(stopsJson) as List<dynamic>;
    return stops.length;
  }

  group('generateTour', () {
    test('generates successful 4-stop tour', () async {
      // Arrange
      final restaurants = _createRestaurants(12); // 3x the 4 stops
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
          )).thenAnswer((_) async => RouteResult(
            polyline: 'test_polyline',
            totalDistanceMeters: 2000,
            totalDurationSeconds: 1800,
            legs: [
              RouteLeg(
                distanceMeters: 500,
                durationSeconds: 450,
                transportMode: TransportMode.walking,
              ),
              RouteLeg(
                distanceMeters: 500,
                durationSeconds: 450,
                transportMode: TransportMode.walking,
              ),
              RouteLeg(
                distanceMeters: 500,
                durationSeconds: 450,
                transportMode: TransportMode.walking,
              ),
            ],
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

      // Assert
      expect(result.stopsJson, isNotNull);
      expect(countStops(result.stopsJson), equals(4));
      expect(result.confidenceScore, greaterThan(0));
      expect(result.routePolyline, isNotEmpty);
      expect(result.isPartialTour, isFalse);
    });

    test('generates 3-stop minimum tour', () async {
      // Arrange
      final restaurants = _createRestaurants(9); // 3x the 3 stops
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
          )).thenAnswer((_) async => RouteResult(
            polyline: 'test_polyline',
            totalDistanceMeters: 1500,
            totalDurationSeconds: 1350,
            legs: [
              RouteLeg(
                distanceMeters: 500,
                durationSeconds: 450,
                transportMode: TransportMode.walking,
              ),
              RouteLeg(
                distanceMeters: 500,
                durationSeconds: 450,
                transportMode: TransportMode.walking,
              ),
            ],
          ));

      final request = TourRequest(
        startLatitude: 41.8781,
        startLongitude: -87.6298,
        numStops: 3,
        transportMode: TransportMode.walking,
        awardOnly: false,
        startTime: DateTime.now().add(const Duration(hours: 1)),
        budgetTier: BudgetTier.moderate,
        createdAt: DateTime.now(),
      );

      // Act
      final result = await service.generateTour(request);

      // Assert
      expect(countStops(result.stopsJson), equals(3));
      expect(result.isPartialTour, isFalse);
    });

    test('generates 6-stop maximum tour', () async {
      // Arrange
      final restaurants = _createRestaurants(18); // 3x the 6 stops
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
          )).thenAnswer((_) async => RouteResult(
            polyline: 'test_polyline',
            totalDistanceMeters: 4000,
            totalDurationSeconds: 3600,
            legs: List.generate(
              5,
              (i) => RouteLeg(
                distanceMeters: 800,
                durationSeconds: 720,
                transportMode: TransportMode.walking,
              ),
            ),
          ));

      final request = TourRequest(
        startLatitude: 41.8781,
        startLongitude: -87.6298,
        numStops: 6,
        transportMode: TransportMode.walking,
        awardOnly: false,
        startTime: DateTime.now().add(const Duration(hours: 1)),
        budgetTier: BudgetTier.moderate,
        createdAt: DateTime.now(),
      );

      // Act
      final result = await service.generateTour(request);

      // Assert
      expect(countStops(result.stopsJson), equals(6));
      expect(result.isPartialTour, isFalse);
    });

    test('applies award-only filter', () async {
      // Arrange - mix of awarded and non-awarded restaurants
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

      // Only some restaurants have awards
      when(() => mockAwardMatchingService.matchRestaurantToAwards(any()))
          .thenAnswer((invocation) async {
        final restaurant = invocation.positionalArguments[0] as Restaurant;
        // Give awards to restaurants with even index
        final index = int.tryParse(restaurant.fsqId.split('-').last) ?? 0;
        if (index % 2 == 0) {
          return AwardMatchResult(
            awards: [
              Award(
                restaurantFsqId: restaurant.fsqId,
                awardType: AwardType.jamesBeard,
                awardLevel: 'nominee',
                year: 2024,
                createdAt: DateTime.now(),
              ),
            ],
            confidence: 0.9,
          );
        }
        return AwardMatchResult(awards: [], confidence: 0.0);
      });

      when(() => mockAwardMatchingService.getAwardBadges(any()))
          .thenAnswer((invocation) {
        final awards = invocation.positionalArguments[0] as List<Award>;
        return awards.map((a) => 'James Beard ${a.awardLevel} ${a.year}').toList();
      });

      when(() => mockMapboxService.calculateRoute(
            waypoints: any(named: 'waypoints'),
            transportMode: any(named: 'transportMode'),
          )).thenAnswer((_) async => RouteResult(
            polyline: 'test_polyline',
            totalDistanceMeters: 2000,
            totalDurationSeconds: 1800,
            legs: [
              RouteLeg(
                distanceMeters: 500,
                durationSeconds: 450,
                transportMode: TransportMode.walking,
              ),
              RouteLeg(
                distanceMeters: 500,
                durationSeconds: 450,
                transportMode: TransportMode.walking,
              ),
              RouteLeg(
                distanceMeters: 500,
                durationSeconds: 450,
                transportMode: TransportMode.walking,
              ),
            ],
          ));

      final request = TourRequest(
        startLatitude: 41.8781,
        startLongitude: -87.6298,
        numStops: 4,
        transportMode: TransportMode.walking,
        awardOnly: true, // Award-only filter
        startTime: DateTime.now().add(const Duration(hours: 1)),
        budgetTier: BudgetTier.moderate,
        createdAt: DateTime.now(),
      );

      // Act
      final result = await service.generateTour(request);

      // Assert - all stops should have awards
      expect(countStops(result.stopsJson), greaterThan(0));
      // Verify we got award-winning restaurants
      final stopsData = jsonDecode(result.stopsJson) as List<dynamic>;
      for (final stop in stopsData) {
        final stopMap = stop as Map<String, dynamic>;
        final awards = stopMap['awards'] as List<dynamic>?;
        expect(awards, isNotNull);
        expect(awards, isNotEmpty);
      }
    });

    test('generates partial tour with warning when insufficient candidates', () async {
      // Arrange - only 2 restaurants available
      final restaurants = _createRestaurants(2);
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
          )).thenAnswer((_) async => RouteResult(
            polyline: 'test_polyline',
            totalDistanceMeters: 500,
            totalDurationSeconds: 450,
            legs: [
              RouteLeg(
                distanceMeters: 500,
                durationSeconds: 450,
                transportMode: TransportMode.walking,
              ),
            ],
          ));

      final request = TourRequest(
        startLatitude: 41.8781,
        startLongitude: -87.6298,
        numStops: 4, // Request 4 but only 2 available
        transportMode: TransportMode.walking,
        awardOnly: false,
        startTime: DateTime.now().add(const Duration(hours: 1)),
        budgetTier: BudgetTier.moderate,
        createdAt: DateTime.now(),
      );

      // Act
      final result = await service.generateTour(request);

      // Assert
      expect(result.isPartialTour, isTrue);
      expect(result.warningMessage, isNotNull);
      expect(result.warningMessage, contains('partial'));
      expect(countStops(result.stopsJson), greaterThan(0)); // Should still return what we have
    });

    test('applies cuisine preference filtering', () async {
      // Arrange - restaurants with different cuisines
      final restaurants = [
        _createRestaurantWithCuisine('rest-1', ['Italian']),
        _createRestaurantWithCuisine('rest-2', ['Mexican']),
        _createRestaurantWithCuisine('rest-3', ['Italian']),
        _createRestaurantWithCuisine('rest-4', ['Japanese']),
        _createRestaurantWithCuisine('rest-5', ['Italian']),
        _createRestaurantWithCuisine('rest-6', ['Mexican']),
        _createRestaurantWithCuisine('rest-7', ['Italian']),
        _createRestaurantWithCuisine('rest-8', ['French']),
        _createRestaurantWithCuisine('rest-9', ['Italian']),
        _createRestaurantWithCuisine('rest-10', ['Chinese']),
        _createRestaurantWithCuisine('rest-11', ['Italian']),
        _createRestaurantWithCuisine('rest-12', ['Thai']),
      ];

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
          )).thenAnswer((_) async => RouteResult(
            polyline: 'test_polyline',
            totalDistanceMeters: 2000,
            totalDurationSeconds: 1800,
            legs: [
              RouteLeg(
                distanceMeters: 500,
                durationSeconds: 450,
                transportMode: TransportMode.walking,
              ),
              RouteLeg(
                distanceMeters: 500,
                durationSeconds: 450,
                transportMode: TransportMode.walking,
              ),
              RouteLeg(
                distanceMeters: 500,
                durationSeconds: 450,
                transportMode: TransportMode.walking,
              ),
            ],
          ));

      final request = TourRequest(
        startLatitude: 41.8781,
        startLongitude: -87.6298,
        numStops: 4,
        transportMode: TransportMode.walking,
        cuisinePreferences: ['Italian'], // Only Italian restaurants
        awardOnly: false,
        startTime: DateTime.now().add(const Duration(hours: 1)),
        budgetTier: BudgetTier.moderate,
        createdAt: DateTime.now(),
      );

      // Act
      final result = await service.generateTour(request);

      // Assert
      expect(countStops(result.stopsJson), equals(4));
      final stopsData = jsonDecode(result.stopsJson) as List<dynamic>;
      for (final stop in stopsData) {
        final stopMap = stop as Map<String, dynamic>;
        final cuisines = stopMap['cuisineTypes'] as List<dynamic>;
        expect(
          cuisines.any((c) => c.toString().toLowerCase().contains('italian')),
          isTrue,
        );
      }
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

/// Create a restaurant with specific cuisine types.
Restaurant _createRestaurantWithCuisine(String fsqId, List<String> cuisines) {
  return Restaurant(
    fsqId: fsqId,
    name: 'Restaurant $fsqId',
    address: '123 Main St, Chicago, IL',
    latitude: 41.8781,
    longitude: -87.6298,
    priceTier: 2,
    cuisineTypes: cuisines,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
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
    'Seafood',
    'Japanese',
    'Chinese',
    'Thai',
  ];
  return cuisines[i % cuisines.length];
}
