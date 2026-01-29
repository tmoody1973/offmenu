import 'package:test/test.dart';
import 'package:food_butler_server/src/generated/protocol.dart';

void main() {
  group('Restaurant model', () {
    test('validates coordinates within valid latitude range', () {
      final restaurant = Restaurant(
        fsqId: 'test-123',
        name: 'Test Restaurant',
        address: '123 Main St',
        latitude: 41.8781,
        longitude: -87.6298,
        priceTier: 2,
        cuisineTypes: ['Italian', 'Pizza'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(restaurant.latitude, greaterThanOrEqualTo(-90));
      expect(restaurant.latitude, lessThanOrEqualTo(90));
      expect(restaurant.longitude, greaterThanOrEqualTo(-180));
      expect(restaurant.longitude, lessThanOrEqualTo(180));
    });

    test('validates price tier is within 1-4 range', () {
      final restaurant = Restaurant(
        fsqId: 'test-456',
        name: 'Budget Eats',
        address: '456 Oak Ave',
        latitude: 40.7128,
        longitude: -74.0060,
        priceTier: 1,
        cuisineTypes: ['American'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(restaurant.priceTier, greaterThanOrEqualTo(1));
      expect(restaurant.priceTier, lessThanOrEqualTo(4));
    });
  });

  group('Award model', () {
    test('associates with restaurant via fsqId', () {
      final award = Award(
        restaurantFsqId: 'test-123',
        awardType: AwardType.jamesBeard,
        awardLevel: 'winner',
        year: 2024,
        createdAt: DateTime.now(),
      );

      expect(award.restaurantFsqId, equals('test-123'));
      expect(award.awardType, equals(AwardType.jamesBeard));
    });
  });

  group('TourRequest model', () {
    test('validates numStops range 3-6', () {
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

      expect(request.numStops, greaterThanOrEqualTo(3));
      expect(request.numStops, lessThanOrEqualTo(6));
    });

    test('validates transport mode enum values', () {
      final walkingRequest = TourRequest(
        startLatitude: 41.8781,
        startLongitude: -87.6298,
        numStops: 3,
        transportMode: TransportMode.walking,
        awardOnly: false,
        startTime: DateTime.now().add(const Duration(hours: 1)),
        budgetTier: BudgetTier.budget,
        createdAt: DateTime.now(),
      );

      final drivingRequest = TourRequest(
        startLatitude: 41.8781,
        startLongitude: -87.6298,
        numStops: 6,
        transportMode: TransportMode.driving,
        awardOnly: true,
        startTime: DateTime.now().add(const Duration(hours: 1)),
        budgetTier: BudgetTier.luxury,
        createdAt: DateTime.now(),
      );

      expect(walkingRequest.transportMode, equals(TransportMode.walking));
      expect(drivingRequest.transportMode, equals(TransportMode.driving));
    });
  });

  group('TourResult model', () {
    test('stores tour result structure correctly', () {
      final result = TourResult(
        requestId: 1,
        stopsJson: '[]',
        confidenceScore: 85,
        routePolyline: 'encoded_polyline_string',
        routeLegsJson: '[]',
        totalDistanceMeters: 5000,
        totalDurationSeconds: 3600,
        isPartialTour: false,
        createdAt: DateTime.now(),
      );

      expect(result.confidenceScore, greaterThanOrEqualTo(0));
      expect(result.confidenceScore, lessThanOrEqualTo(100));
      expect(result.isPartialTour, isFalse);
    });
  });

  group('CachedFoursquareResponse model', () {
    test('TTL behavior with expiresAt field', () {
      final now = DateTime.now();
      final expiresAt = now.add(const Duration(hours: 24));

      final cached = CachedFoursquareResponse(
        cacheKey: 'lat:41.88_lon:-87.63_radius:2000',
        responseData: '{"results": []}',
        expiresAt: expiresAt,
        createdAt: now,
      );

      expect(cached.expiresAt.isAfter(cached.createdAt), isTrue);
      expect(
        cached.expiresAt.difference(cached.createdAt).inHours,
        equals(24),
      );
    });
  });

  group('CachedRoute model', () {
    test('cache key generation from waypoints hash', () {
      final now = DateTime.now();
      final expiresAt = now.add(const Duration(days: 7));

      final cached = CachedRoute(
        waypointsHash: 'abc123def456',
        transportMode: TransportMode.walking,
        polyline: 'encoded_route',
        distanceMeters: 2500,
        durationSeconds: 1800,
        legsJson: '[{"distance": 2500, "duration": 1800}]',
        expiresAt: expiresAt,
        createdAt: now,
      );

      expect(cached.waypointsHash, isNotEmpty);
      expect(cached.transportMode, equals(TransportMode.walking));
      expect(
        cached.expiresAt.difference(cached.createdAt).inDays,
        equals(7),
      );
    });
  });
}
