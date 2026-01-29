import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'package:food_butler_server/src/services/foursquare_service.dart';
import 'package:food_butler_server/src/generated/protocol.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockSession extends Mock implements Session {}

class MockDatabase extends Mock implements Database {}

class FakeUri extends Fake implements Uri {}

void main() {
  late MockHttpClient mockHttpClient;
  late MockSession mockSession;
  late FoursquareService service;

  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockSession = MockSession();

    // Setup session mock to handle logging
    when(() => mockSession.log(any(), level: any(named: 'level')))
        .thenReturn(null);

    service = FoursquareService(
      apiKey: 'test-api-key',
      session: mockSession,
      httpClient: mockHttpClient,
    );
  });

  tearDown(() {
    service.dispose();
  });

  group('searchRestaurants', () {
    test('returns restaurants with location and radius', () async {
      final mockResponse = jsonEncode({
        'results': [
          {
            'fsq_id': 'test-123',
            'name': 'Test Restaurant',
            'location': {
              'address': '123 Main St',
              'locality': 'Chicago',
              'region': 'IL',
              'latitude': 41.8781,
              'longitude': -87.6298,
            },
            'price': 2,
            'rating': 8.5,
            'categories': [
              {'name': 'Italian'}
            ],
          },
        ],
      });

      when(() => mockHttpClient.get(
            any(),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => http.Response(mockResponse, 200));

      // Mock the database to return null (no cache)
      when(() => mockSession.db).thenThrow(
          Exception('DB not available in unit test'));

      final result = await service.searchRestaurants(
        latitude: 41.8781,
        longitude: -87.6298,
        radiusMeters: 2000,
      );

      expect(result.restaurants.length, equals(1));
      expect(result.restaurants.first.name, equals('Test Restaurant'));
      expect(result.restaurants.first.latitude, equals(41.8781));
      expect(result.restaurants.first.longitude, equals(-87.6298));
    });

    test('applies cuisine filter correctly', () async {
      final mockResponse = jsonEncode({
        'results': [
          {
            'fsq_id': 'italian-1',
            'name': 'Italian Place',
            'location': {
              'latitude': 41.88,
              'longitude': -87.63,
            },
            'categories': [
              {'name': 'Italian'}
            ],
          },
        ],
      });

      Uri? capturedUri;
      when(() => mockHttpClient.get(
            any(),
            headers: any(named: 'headers'),
          )).thenAnswer((invocation) async {
        capturedUri = invocation.positionalArguments[0] as Uri;
        return http.Response(mockResponse, 200);
      });

      await service.searchRestaurants(
        latitude: 41.8781,
        longitude: -87.6298,
        radiusMeters: 2000,
        cuisineTypes: ['italian'],
      );

      expect(capturedUri?.queryParameters['categories'], contains('13064'));
    });

    test('parses dish-level data correctly', () async {
      final mockResponse = jsonEncode({
        'results': [
          {
            'fsq_id': 'test-456',
            'name': 'Dish Data Restaurant',
            'location': {
              'latitude': 41.88,
              'longitude': -87.63,
            },
            'menu': {
              'url': 'https://example.com/menu',
              'mobileUrl': 'https://m.example.com/menu',
            },
            'tastes': ['savory', 'spicy', 'sweet'],
          },
        ],
      });

      when(() => mockHttpClient.get(
            any(),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => http.Response(mockResponse, 200));

      final result = await service.searchRestaurants(
        latitude: 41.8781,
        longitude: -87.6298,
        radiusMeters: 2000,
      );

      expect(result.restaurants.length, equals(1));
      expect(result.restaurants.first.dishData, isNotNull);

      final dishData = jsonDecode(result.restaurants.first.dishData!);
      expect(dishData['tastes'], contains('savory'));
      expect(dishData['menu'], isNotNull);
    });

    test('handles rate limit with exponential backoff', () async {
      var callCount = 0;
      final mockResponse = jsonEncode({
        'results': [
          {
            'fsq_id': 'retry-test',
            'name': 'Retry Restaurant',
            'location': {'latitude': 41.88, 'longitude': -87.63},
          },
        ],
      });

      when(() => mockHttpClient.get(
            any(),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async {
        callCount++;
        if (callCount < 3) {
          return http.Response('Rate limited', 429);
        }
        return http.Response(mockResponse, 200);
      });

      final result = await service.searchRestaurants(
        latitude: 41.8781,
        longitude: -87.6298,
        radiusMeters: 2000,
      );

      expect(callCount, equals(3));
      expect(result.restaurants.length, equals(1));
      expect(result.restaurants.first.name, equals('Retry Restaurant'));
    });

    test('returns partial results with warning on API error', () async {
      when(() => mockHttpClient.get(
            any(),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => http.Response('Server error', 500));

      final result = await service.searchRestaurants(
        latitude: 41.8781,
        longitude: -87.6298,
        radiusMeters: 2000,
      );

      expect(result.restaurants, isEmpty);
      expect(result.warning, isNotNull);
      expect(result.warning, contains('Unable to fetch'));
    });

    test('handles authentication error gracefully', () async {
      when(() => mockHttpClient.get(
            any(),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => http.Response('Unauthorized', 401));

      final result = await service.searchRestaurants(
        latitude: 41.8781,
        longitude: -87.6298,
        radiusMeters: 2000,
      );

      expect(result.restaurants, isEmpty);
      expect(result.warning, isNotNull);
    });
  });

  group('getRestaurantDetails', () {
    test('fetches and parses restaurant details', () async {
      final mockResponse = jsonEncode({
        'fsq_id': 'detail-test',
        'name': 'Detailed Restaurant',
        'location': {
          'address': '456 Oak Ave',
          'locality': 'Chicago',
          'latitude': 41.9,
          'longitude': -87.7,
        },
        'price': 3,
        'rating': 9.2,
        'categories': [
          {'name': 'Fine Dining'}
        ],
        'hours': {
          'display': 'Mon-Sat 5pm-10pm',
          'is_open': true,
        },
        'menu': {
          'url': 'https://example.com/menu',
        },
        'tastes': ['upscale', 'romantic'],
      });

      when(() => mockHttpClient.get(
            any(),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => http.Response(mockResponse, 200));

      final restaurant = await service.getRestaurantDetails('detail-test');

      expect(restaurant, isNotNull);
      expect(restaurant!.name, equals('Detailed Restaurant'));
      expect(restaurant.priceTier, equals(3));
      expect(restaurant.rating, equals(9.2));
      expect(restaurant.hours, isNotNull);
      expect(restaurant.dishData, isNotNull);
    });

    test('returns null on API failure', () async {
      when(() => mockHttpClient.get(
            any(),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => http.Response('Not found', 404));

      final restaurant = await service.getRestaurantDetails('nonexistent');

      expect(restaurant, isNull);
    });
  });
}
