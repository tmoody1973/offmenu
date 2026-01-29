import 'package:test/test.dart';
import 'package:food_butler_server/src/services/fuzzy_match_service.dart';
import 'package:food_butler_server/src/generated/protocol.dart';

void main() {
  late FuzzyMatchService service;

  setUp(() {
    service = FuzzyMatchService();
  });

  group('FuzzyMatchService', () {
    group('String matching', () {
      test('exact name + city match returns confidence score >= 0.95', () {
        final confidence = service.calculateMatchConfidence(
          awardName: 'Alinea',
          awardCity: 'Chicago',
          restaurantName: 'Alinea',
          restaurantCity: 'Chicago',
        );

        expect(confidence, greaterThanOrEqualTo(0.95));
      });

      test('fuzzy match handles minor spelling variations', () {
        // Test apostrophe variations
        final apostropheConfidence = service.calculateMatchConfidence(
          awardName: "Joe's Pizza",
          awardCity: 'New York',
          restaurantName: 'Joes Pizza',
          restaurantCity: 'New York',
        );
        expect(apostropheConfidence, greaterThan(0.85));

        // Test "The" prefix variations
        final thePrefixConfidence = service.calculateMatchConfidence(
          awardName: 'The French Laundry',
          awardCity: 'Yountville',
          restaurantName: 'French Laundry',
          restaurantCity: 'Yountville',
        );
        expect(thePrefixConfidence, greaterThan(0.80));

        // Test minor typos
        final typoConfidence = service.calculateMatchConfidence(
          awardName: 'Eleven Madison Park',
          awardCity: 'New York',
          restaurantName: 'Eleven Madison Pk',
          restaurantCity: 'New York',
        );
        expect(typoConfidence, greaterThan(0.75));
      });

      test('case insensitivity works correctly', () {
        final confidence = service.calculateMatchConfidence(
          awardName: 'ALINEA',
          awardCity: 'CHICAGO',
          restaurantName: 'alinea',
          restaurantCity: 'chicago',
        );

        expect(confidence, greaterThanOrEqualTo(0.95));
      });

      test('very different names have low confidence', () {
        final confidence = service.calculateMatchConfidence(
          awardName: 'Alinea',
          awardCity: 'Chicago',
          restaurantName: 'McDonalds',
          restaurantCity: 'Chicago',
        );

        expect(confidence, lessThan(0.5));
      });
    });

    group('Coordinate proximity validation', () {
      test('coordinate proximity improves confidence for ambiguous name matches', () {
        // Base confidence without coordinates
        final baseConfidence = service.calculateMatchConfidence(
          awardName: 'Cafe Roma',
          awardCity: 'San Francisco',
          restaurantName: 'Cafe Roma SF',
          restaurantCity: 'San Francisco',
        );

        // Enhanced confidence with nearby coordinates (within 100m)
        final enhancedConfidence = service.calculateMatchConfidenceWithCoordinates(
          awardName: 'Cafe Roma',
          awardCity: 'San Francisco',
          awardLatitude: 37.7749,
          awardLongitude: -122.4194,
          restaurantName: 'Cafe Roma SF',
          restaurantCity: 'San Francisco',
          restaurantLatitude: 37.7750,
          restaurantLongitude: -122.4195,
        );

        expect(enhancedConfidence, greaterThan(baseConfidence));
      });

      test('coordinates within 100m boost confidence by approximately 0.1', () {
        final confidence = service.calculateMatchConfidenceWithCoordinates(
          awardName: 'Test Restaurant',
          awardCity: 'Test City',
          awardLatitude: 41.8781,
          awardLongitude: -87.6298,
          restaurantName: 'Test Restaurant',
          restaurantCity: 'Test City',
          restaurantLatitude: 41.8782, // Very close - within 100m
          restaurantLongitude: -87.6299,
        );

        // Exact name match (0.95+) plus coordinate boost
        expect(confidence, greaterThanOrEqualTo(0.99));
      });

      test('coordinates within 500m boost confidence by approximately 0.05', () {
        final confidence = service.calculateMatchConfidenceWithCoordinates(
          awardName: 'Test Restaurant',
          awardCity: 'Test City',
          awardLatitude: 41.8781,
          awardLongitude: -87.6298,
          restaurantName: 'Test Restaurant',
          restaurantCity: 'Test City',
          restaurantLatitude: 41.8820, // About 450m away
          restaurantLongitude: -87.6298,
        );

        expect(confidence, greaterThan(0.95));
      });

      test('handles missing coordinates gracefully', () {
        final confidence = service.calculateMatchConfidenceWithCoordinates(
          awardName: 'Test Restaurant',
          awardCity: 'Test City',
          awardLatitude: null,
          awardLongitude: null,
          restaurantName: 'Test Restaurant',
          restaurantCity: 'Test City',
          restaurantLatitude: 41.8781,
          restaurantLongitude: -87.6298,
        );

        // Should still work, just without coordinate boost
        expect(confidence, greaterThanOrEqualTo(0.95));
      });
    });

    group('Match status determination', () {
      test('low confidence matches (< 0.7) are flagged for review or unmatched', () {
        final status = service.determineMatchStatus(0.65);
        expect(
          status,
          anyOf(equals(MatchStatus.pendingReview), isNull),
        );
      });

      test('medium confidence matches (0.7-0.9) are flagged for review', () {
        final status = service.determineMatchStatus(0.75);
        expect(status, equals(MatchStatus.pendingReview));

        final status2 = service.determineMatchStatus(0.85);
        expect(status2, equals(MatchStatus.pendingReview));
      });

      test('high confidence matches (>= 0.9) are auto-matched', () {
        final status = service.determineMatchStatus(0.92);
        expect(status, equals(MatchStatus.autoMatched));

        final status2 = service.determineMatchStatus(0.99);
        expect(status2, equals(MatchStatus.autoMatched));
      });
    });

    group('Batch matching', () {
      test('batch matching returns correct link objects', () {
        final michelinAwards = [
          MichelinAward(
            id: 1,
            restaurantName: 'Alinea',
            city: 'Chicago',
            designation: MichelinDesignation.threeStar,
            awardYear: 2024,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ];

        final restaurants = [
          Restaurant(
            id: 1,
            fsqId: 'fsq-123',
            name: 'Alinea',
            address: '1723 N Halsted St, Chicago, IL',
            latitude: 41.9138,
            longitude: -87.6485,
            priceTier: 4,
            cuisineTypes: ['American', 'Contemporary'],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ];

        final links = service.batchMatchMichelinAwards(
          awards: michelinAwards,
          restaurants: restaurants,
        );

        expect(links.length, equals(1));
        expect(links.first.restaurantId, equals(1));
        expect(links.first.awardId, equals(1));
        expect(links.first.awardType, equals(AwardType.michelin));
        expect(links.first.matchConfidenceScore, greaterThanOrEqualTo(0.9));
        expect(links.first.matchStatus, equals(MatchStatus.autoMatched));
      });
    });
  });
}
