import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:food_butler_client/food_butler_client.dart';
import 'package:food_butler_flutter/services/opentable/reservation_launcher.dart';
import 'package:food_butler_flutter/services/opentable/url_launcher_wrapper.dart';

class MockUrlLauncherWrapper extends Mock implements UrlLauncherWrapper {}

void main() {
  late MockUrlLauncherWrapper mockLauncher;
  late ReservationLauncher reservationLauncher;

  setUpAll(() {
    registerFallbackValue(url_launcher.LaunchMode.platformDefault);
  });

  setUp(() {
    mockLauncher = MockUrlLauncherWrapper();
    reservationLauncher = ReservationLauncher(urlLauncher: mockLauncher);
  });

  group('ReservationLauncher', () {
    final now = DateTime.now();
    final testRestaurant = Restaurant(
      fsqId: 'fsq_123',
      name: 'Test Restaurant',
      address: '123 Main St, San Francisco, CA',
      latitude: 37.7749,
      longitude: -122.4194,
      priceTier: 2,
      cuisineTypes: ['Italian'],
      createdAt: now,
      updatedAt: now,
      opentableId: 'ot_12345',
      opentableSlug: 'test-restaurant-sf',
      phone: '+1-415-555-1234',
      websiteUrl: 'https://testrestaurant.com',
    );

    test('attempts app scheme first then falls back to web', () async {
      // App scheme fails (not installed)
      when(() => mockLauncher.canLaunch(any())).thenAnswer((invocation) async {
        final url = invocation.positionalArguments[0] as String;
        return !url.startsWith('opentable://');
      });
      when(() => mockLauncher.launch(any(), mode: any(named: 'mode')))
          .thenAnswer((_) async => true);

      final result = await reservationLauncher.launchReservation(
        restaurant: testRestaurant,
        partySize: 2,
      );

      expect(result.success, isTrue);
      expect(result.linkType, equals(ReservationLinkType.opentableWeb));
    });

    test('returns success when app scheme works', () async {
      when(() => mockLauncher.canLaunch(any())).thenAnswer((_) async => true);
      when(() => mockLauncher.launch(any(), mode: any(named: 'mode')))
          .thenAnswer((_) async => true);

      final result = await reservationLauncher.launchReservation(
        restaurant: testRestaurant,
        partySize: 2,
      );

      expect(result.success, isTrue);
      expect(result.linkType, equals(ReservationLinkType.opentableApp));
    });

    test('phone link uses tel scheme', () async {
      when(() => mockLauncher.canLaunch(any())).thenAnswer((_) async => true);
      when(() => mockLauncher.launch(any(), mode: any(named: 'mode')))
          .thenAnswer((_) async => true);

      final result = await reservationLauncher.launchPhone(testRestaurant);

      expect(result.success, isTrue);
      expect(result.linkType, equals(ReservationLinkType.phone));
      expect(result.url, startsWith('tel:'));
    });

    test('website link launches with correct URL', () async {
      when(() => mockLauncher.canLaunch(any())).thenAnswer((_) async => true);
      when(() => mockLauncher.launch(any(), mode: any(named: 'mode')))
          .thenAnswer((_) async => true);

      final result = await reservationLauncher.launchWebsite(testRestaurant);

      expect(result.success, isTrue);
      expect(result.linkType, equals(ReservationLinkType.website));
      expect(result.url, equals('https://testrestaurant.com'));
    });

    test('handles launch failure gracefully', () async {
      when(() => mockLauncher.canLaunch(any())).thenAnswer((_) async => true);
      when(() => mockLauncher.launch(any(), mode: any(named: 'mode')))
          .thenAnswer((_) async => false);

      final result = await reservationLauncher.launchReservation(
        restaurant: testRestaurant,
        partySize: 2,
      );

      expect(result.success, isFalse);
    });

    test('returns failure for restaurant without contact info', () async {
      final noContactRestaurant = Restaurant(
        fsqId: 'fsq_456',
        name: 'No Contact Restaurant',
        address: '',
        latitude: 37.7749,
        longitude: -122.4194,
        priceTier: 2,
        cuisineTypes: ['Thai'],
        createdAt: now,
        updatedAt: now,
      );

      final result = await reservationLauncher.launchPhone(noContactRestaurant);

      expect(result.success, isFalse);
      expect(result.errorMessage, isNotNull);
    });
  });
}
