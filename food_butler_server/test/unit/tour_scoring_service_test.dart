import 'dart:convert';

import 'package:test/test.dart';

import 'package:food_butler_server/src/services/tour_scoring_service.dart';
import 'package:food_butler_server/src/generated/protocol.dart';

void main() {
  late TourScoringService service;

  setUp(() {
    service = TourScoringService();
  });

  group('calculateDigestionScore', () {
    test('scores light to heavy progression highly', () {
      final stops = [
        _createScoredRestaurant(DishWeight.light),
        _createScoredRestaurant(DishWeight.medium),
        _createScoredRestaurant(DishWeight.heavy),
      ];

      final score = service.calculateDigestionScore(stops);

      // Good progression should score well
      expect(score, greaterThan(0.9));
    });

    test('penalizes heavy to light transitions', () {
      final badStops = [
        _createScoredRestaurant(DishWeight.heavy),
        _createScoredRestaurant(DishWeight.medium),
        _createScoredRestaurant(DishWeight.light),
      ];

      final goodStops = [
        _createScoredRestaurant(DishWeight.light),
        _createScoredRestaurant(DishWeight.medium),
        _createScoredRestaurant(DishWeight.heavy),
      ];

      final badScore = service.calculateDigestionScore(badStops);
      final goodScore = service.calculateDigestionScore(goodStops);

      expect(badScore, lessThan(goodScore));
    });
  });

  group('calculateGeographicScore', () {
    test('scores efficient routes highly', () {
      // 30 minutes total walking - under threshold
      final efficientLegs = [
        RouteLeg(
          distanceMeters: 500,
          durationSeconds: 600, // 10 minutes
          transportMode: TransportMode.walking,
        ),
        RouteLeg(
          distanceMeters: 500,
          durationSeconds: 600, // 10 minutes
          transportMode: TransportMode.walking,
        ),
      ];

      final score = service.calculateGeographicScore(
        efficientLegs,
        TransportMode.walking,
      );

      expect(score, equals(1.0));
    });

    test('penalizes excessive travel time', () {
      // 90 minutes total - way over threshold
      final inefficientLegs = [
        RouteLeg(
          distanceMeters: 5000,
          durationSeconds: 2700, // 45 minutes
          transportMode: TransportMode.walking,
        ),
        RouteLeg(
          distanceMeters: 5000,
          durationSeconds: 2700, // 45 minutes
          transportMode: TransportMode.walking,
        ),
      ];

      final score = service.calculateGeographicScore(
        inefficientLegs,
        TransportMode.walking,
      );

      expect(score, lessThan(0.5));
    });
  });

  group('calculateTimingScore', () {
    test('scores good timing with digestion gaps', () {
      final stops = [
        _createScoredRestaurant(DishWeight.light),
        _createScoredRestaurant(DishWeight.medium),
      ];

      // 25 minute travel time - within ideal gap
      final legs = [
        RouteLeg(
          distanceMeters: 1000,
          durationSeconds: 1500, // 25 minutes
          transportMode: TransportMode.walking,
        ),
      ];

      final score = service.calculateTimingScore(
        stops,
        legs,
        DateTime.now(),
      );

      expect(score, greaterThan(0.8));
    });

    test('penalizes rushed timing', () {
      final stops = [
        _createScoredRestaurant(DishWeight.light),
        _createScoredRestaurant(DishWeight.medium),
      ];

      // 10 minute travel time - too rushed
      final rushedLegs = [
        RouteLeg(
          distanceMeters: 500,
          durationSeconds: 600, // 10 minutes
          transportMode: TransportMode.walking,
        ),
      ];

      // 25 minute travel time - good pace
      final goodLegs = [
        RouteLeg(
          distanceMeters: 1000,
          durationSeconds: 1500, // 25 minutes
          transportMode: TransportMode.walking,
        ),
      ];

      final rushedScore = service.calculateTimingScore(
        stops,
        rushedLegs,
        DateTime.now(),
      );

      final goodScore = service.calculateTimingScore(
        stops,
        goodLegs,
        DateTime.now(),
      );

      expect(rushedScore, lessThan(goodScore));
    });
  });

  group('applyAwardBoost', () {
    test('applies 1.2x multiplier for single award', () {
      final awards = [
        Award(
          restaurantFsqId: 'test',
          awardType: AwardType.jamesBeard,
          awardLevel: 'nominee',
          year: 2024,
          createdAt: DateTime.now(),
        ),
      ];

      final boost = service.applyAwardBoost(awards);

      expect(boost, closeTo(1.2, 0.01));
    });

    test('caps boost at 1.5x for multiple awards', () {
      final awards = [
        Award(
          restaurantFsqId: 'test',
          awardType: AwardType.jamesBeard,
          awardLevel: 'winner',
          year: 2024,
          createdAt: DateTime.now(),
        ),
        Award(
          restaurantFsqId: 'test',
          awardType: AwardType.michelin,
          awardLevel: 'threeStar',
          year: 2024,
          createdAt: DateTime.now(),
        ),
        Award(
          restaurantFsqId: 'test',
          awardType: AwardType.michelin,
          awardLevel: 'twoStar',
          year: 2023,
          createdAt: DateTime.now(),
        ),
      ];

      final boost = service.applyAwardBoost(awards);

      expect(boost, equals(1.5));
    });
  });

  group('scoreTour', () {
    test('calculates overall confidence score', () {
      final stops = [
        _createScoredRestaurant(DishWeight.light),
        _createScoredRestaurant(DishWeight.medium),
        _createScoredRestaurant(DishWeight.heavy),
      ];

      final legs = [
        RouteLeg(
          distanceMeters: 800,
          durationSeconds: 1200, // 20 min
          transportMode: TransportMode.walking,
        ),
        RouteLeg(
          distanceMeters: 800,
          durationSeconds: 1200, // 20 min
          transportMode: TransportMode.walking,
        ),
      ];

      final score = service.scoreTour(
        stops: stops,
        routeLegs: legs,
        startTime: DateTime.now(),
        transportMode: TransportMode.walking,
      );

      expect(score.confidenceScore, greaterThan(0));
      expect(score.confidenceScore, lessThanOrEqualTo(100));
      expect(score.digestionScore, greaterThan(0));
      expect(score.geographicScore, greaterThan(0));
      expect(score.timingScore, greaterThan(0));
    });
  });

  group('classifyDishWeight', () {
    test('uses dish data when available', () {
      final restaurant = Restaurant(
        fsqId: 'test',
        name: 'Test Restaurant',
        address: '123 Main St',
        latitude: 41.88,
        longitude: -87.63,
        priceTier: 2,
        cuisineTypes: ['Restaurant'],
        dishData: jsonEncode({
          'tastes': ['light', 'fresh', 'crisp'],
        }),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final weight = service.classifyDishWeight(restaurant);

      expect(weight, equals(DishWeight.light));
    });

    test('falls back to cuisine heuristics when no dish data', () {
      final coffeeShop = Restaurant(
        fsqId: 'coffee-1',
        name: 'Local Coffee',
        address: '123 Main St',
        latitude: 41.88,
        longitude: -87.63,
        priceTier: 1,
        cuisineTypes: ['Coffee Shop'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final steakhouse = Restaurant(
        fsqId: 'steak-1',
        name: 'Prime Steakhouse',
        address: '456 Oak Ave',
        latitude: 41.89,
        longitude: -87.64,
        priceTier: 4,
        cuisineTypes: ['Steakhouse'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(service.classifyDishWeight(coffeeShop), equals(DishWeight.light));
      expect(service.classifyDishWeight(steakhouse), equals(DishWeight.heavy));
    });

    test('defaults to medium when no match', () {
      final unknownRestaurant = Restaurant(
        fsqId: 'unknown-1',
        name: 'Mystery Restaurant',
        address: '789 Elm St',
        latitude: 41.87,
        longitude: -87.62,
        priceTier: 2,
        cuisineTypes: ['Fusion', 'Modern'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final weight = service.classifyDishWeight(unknownRestaurant);

      expect(weight, equals(DishWeight.medium));
    });
  });
}

/// Helper to create a scored restaurant for testing.
ScoredRestaurant _createScoredRestaurant(DishWeight weight) {
  return ScoredRestaurant(
    restaurant: Restaurant(
      fsqId: 'test-${weight.name}',
      name: 'Test ${weight.name}',
      address: '123 Main St, Chicago, IL',
      latitude: 41.88,
      longitude: -87.63,
      priceTier: 2,
      cuisineTypes: ['Test'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    awards: [],
    dishWeight: weight,
    baseScore: 1.0,
    awardBoost: 1.0,
  );
}
