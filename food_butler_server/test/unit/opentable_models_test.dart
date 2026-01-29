import 'package:test/test.dart';
import 'package:food_butler_server/src/generated/protocol.dart';

void main() {
  group('Restaurant OpenTable fields', () {
    test('Restaurant model includes OpenTable fields', () {
      final now = DateTime.now();
      final restaurant = Restaurant(
        fsqId: 'fsq_123',
        name: 'Test Restaurant',
        address: '123 Main St',
        latitude: 37.7749,
        longitude: -122.4194,
        priceTier: 2,
        cuisineTypes: ['Italian'],
        createdAt: now,
        updatedAt: now,
        opentableId: 'ot_12345',
        opentableSlug: 'test-restaurant-san-francisco',
        phone: '+1-415-555-1234',
        websiteUrl: 'https://testrestaurant.com',
      );

      expect(restaurant.opentableId, equals('ot_12345'));
      expect(restaurant.opentableSlug, equals('test-restaurant-san-francisco'));
      expect(restaurant.phone, equals('+1-415-555-1234'));
      expect(restaurant.websiteUrl, equals('https://testrestaurant.com'));
    });

    test('Restaurant model handles null OpenTable fields', () {
      final now = DateTime.now();
      final restaurant = Restaurant(
        fsqId: 'fsq_456',
        name: 'Restaurant Without OpenTable',
        address: '456 Oak Ave',
        latitude: 37.7850,
        longitude: -122.4094,
        priceTier: 3,
        cuisineTypes: ['Mexican'],
        createdAt: now,
        updatedAt: now,
      );

      expect(restaurant.opentableId, isNull);
      expect(restaurant.opentableSlug, isNull);
      expect(restaurant.phone, isNull);
      expect(restaurant.websiteUrl, isNull);
    });

    test('Restaurant copyWith preserves OpenTable fields', () {
      final now = DateTime.now();
      final original = Restaurant(
        fsqId: 'fsq_789',
        name: 'Original Restaurant',
        address: '789 Pine Blvd',
        latitude: 37.7650,
        longitude: -122.4294,
        priceTier: 1,
        cuisineTypes: ['Japanese'],
        createdAt: now,
        updatedAt: now,
        opentableId: 'ot_original',
        opentableSlug: 'original-restaurant',
        phone: '+1-415-555-9876',
        websiteUrl: 'https://original.com',
      );

      final copied = original.copyWith(name: 'Updated Restaurant');

      expect(copied.name, equals('Updated Restaurant'));
      expect(copied.opentableId, equals('ot_original'));
      expect(copied.opentableSlug, equals('original-restaurant'));
      expect(copied.phone, equals('+1-415-555-9876'));
      expect(copied.websiteUrl, equals('https://original.com'));
    });
  });

  group('ReservationClickEvent model', () {
    test('ReservationClickEvent model creation and validation', () {
      final now = DateTime.now();
      final event = ReservationClickEvent(
        restaurantId: 1,
        linkType: ReservationLinkType.opentableApp,
        launchSuccess: true,
        timestamp: now,
        createdAt: now,
      );

      expect(event.restaurantId, equals(1));
      expect(event.linkType, equals(ReservationLinkType.opentableApp));
      expect(event.launchSuccess, isTrue);
      expect(event.userId, isNull);
    });

    test('ReservationClickEvent with user ID', () {
      final now = DateTime.now();
      final event = ReservationClickEvent(
        restaurantId: 2,
        linkType: ReservationLinkType.phone,
        userId: 'user_123',
        launchSuccess: true,
        timestamp: now,
        createdAt: now,
      );

      expect(event.userId, equals('user_123'));
      expect(event.linkType, equals(ReservationLinkType.phone));
    });

    test('ReservationLinkType enum values', () {
      expect(ReservationLinkType.values, contains(ReservationLinkType.opentableApp));
      expect(ReservationLinkType.values, contains(ReservationLinkType.opentableWeb));
      expect(ReservationLinkType.values, contains(ReservationLinkType.opentableSearch));
      expect(ReservationLinkType.values, contains(ReservationLinkType.phone));
      expect(ReservationLinkType.values, contains(ReservationLinkType.website));
    });
  });
}
