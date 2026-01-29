import 'package:flutter_test/flutter_test.dart';
import 'package:food_butler_flutter/services/opentable/opentable_url_builder.dart';
import 'package:food_butler_flutter/services/opentable/datetime_rounder.dart';

void main() {
  group('OpenTableUrlBuilder', () {
    test('buildAppSchemeUrl generates correct format with restaurantId', () {
      final dateTime = DateTime(2026, 1, 25, 18, 30);
      final url = OpenTableUrlBuilder.buildAppSchemeUrl(
        restaurantId: '12345',
        partySize: 2,
        dateTime: dateTime,
      );

      expect(url, startsWith('opentable://restaurant/12345'));
      expect(url, contains('covers=2'));
      expect(url, contains('dateTime='));
    });

    test('buildWebUrl generates correct format with slug', () {
      final dateTime = DateTime(2026, 1, 25, 19, 0);
      final url = OpenTableUrlBuilder.buildWebUrl(
        slug: 'amazing-restaurant-san-francisco',
        partySize: 4,
        dateTime: dateTime,
      );

      expect(url, startsWith('https://www.opentable.com/r/amazing-restaurant-san-francisco'));
      expect(url, contains('covers=4'));
      expect(url, contains('dateTime='));
    });

    test('buildSearchUrl generates correct format with name and location', () {
      final dateTime = DateTime(2026, 1, 25, 20, 0);
      final url = OpenTableUrlBuilder.buildSearchUrl(
        name: 'Test Restaurant',
        location: 'San Francisco, CA',
        partySize: 3,
        dateTime: dateTime,
      );

      expect(url, startsWith('https://www.opentable.com/s'));
      expect(url, contains('term='));
      expect(url, contains('geo='));
      expect(url, contains('covers=3'));
    });

    test('buildSearchUrl properly URL encodes special characters', () {
      final dateTime = DateTime(2026, 1, 25, 20, 0);
      final url = OpenTableUrlBuilder.buildSearchUrl(
        name: "Joe's Bar & Grill",
        location: 'New York, NY',
        partySize: 2,
        dateTime: dateTime,
      );

      // Ampersand should be encoded as %26 so it doesn't break URL parameters
      expect(url, contains('%26')); // URL encoded ampersand
      // Spaces should be encoded
      expect(url, contains('%20'));
      // Comma should be encoded
      expect(url, contains('%2C'));
    });

    test('party size defaults to 2', () {
      final dateTime = DateTime(2026, 1, 25, 18, 30);
      final url = OpenTableUrlBuilder.buildWebUrl(
        slug: 'test-restaurant',
        dateTime: dateTime,
      );

      expect(url, contains('covers=2'));
    });

    test('datetime is formatted as ISO 8601', () {
      final dateTime = DateTime(2026, 1, 25, 18, 30);
      final url = OpenTableUrlBuilder.buildWebUrl(
        slug: 'test-restaurant',
        partySize: 2,
        dateTime: dateTime,
      );

      // ISO 8601 format should be present
      expect(url, contains('2026-01-25'));
    });
  });

  group('DateTimeRounder', () {
    test('rounds down for 0-7 minutes past quarter', () {
      // 18:07 should round to 18:00
      final input = DateTime(2026, 1, 25, 18, 7);
      final rounded = DateTimeRounder.roundToNearest15Minutes(input);

      expect(rounded.hour, equals(18));
      expect(rounded.minute, equals(0));
    });

    test('rounds up for 8-14 minutes past quarter', () {
      // 18:08 should round to 18:15
      final input = DateTime(2026, 1, 25, 18, 8);
      final rounded = DateTimeRounder.roundToNearest15Minutes(input);

      expect(rounded.hour, equals(18));
      expect(rounded.minute, equals(15));
    });

    test('handles rounding at hour boundary', () {
      // 18:53 should round to 19:00
      final input = DateTime(2026, 1, 25, 18, 53);
      final rounded = DateTimeRounder.roundToNearest15Minutes(input);

      expect(rounded.hour, equals(19));
      expect(rounded.minute, equals(0));
    });

    test('exact quarter times remain unchanged', () {
      final input = DateTime(2026, 1, 25, 18, 15);
      final rounded = DateTimeRounder.roundToNearest15Minutes(input);

      expect(rounded.hour, equals(18));
      expect(rounded.minute, equals(15));
    });

    test('handles midnight crossing', () {
      // 23:53 should round to 00:00 next day
      final input = DateTime(2026, 1, 25, 23, 53);
      final rounded = DateTimeRounder.roundToNearest15Minutes(input);

      expect(rounded.day, equals(26));
      expect(rounded.hour, equals(0));
      expect(rounded.minute, equals(0));
    });

    test('preserves date when rounding within hour', () {
      final input = DateTime(2026, 1, 25, 18, 22);
      final rounded = DateTimeRounder.roundToNearest15Minutes(input);

      expect(rounded.year, equals(2026));
      expect(rounded.month, equals(1));
      expect(rounded.day, equals(25));
    });
  });
}
