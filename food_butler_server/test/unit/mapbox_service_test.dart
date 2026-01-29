import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'package:food_butler_server/src/services/mapbox_service.dart';
import 'package:food_butler_server/src/generated/protocol.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockSession extends Mock implements Session {}

class FakeUri extends Fake implements Uri {}

void main() {
  late MockHttpClient mockHttpClient;
  late MockSession mockSession;
  late MapboxService service;

  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockSession = MockSession();

    when(() => mockSession.log(any(), level: any(named: 'level')))
        .thenReturn(null);

    service = MapboxService(
      accessToken: 'test-token',
      session: mockSession,
      httpClient: mockHttpClient,
    );
  });

  tearDown(() {
    service.dispose();
  });

  group('calculateRoute', () {
    test('calculates route for walking mode', () async {
      final mockResponse = jsonEncode({
        'routes': [
          {
            'geometry': 'test_polyline_encoded',
            'duration': 1800,
            'distance': 2500,
            'legs': [
              {'duration': 900, 'distance': 1200},
              {'duration': 900, 'distance': 1300},
            ],
          },
        ],
      });

      when(() => mockHttpClient.get(any()))
          .thenAnswer((_) async => http.Response(mockResponse, 200));

      final waypoints = [
        LatLng(latitude: 41.8781, longitude: -87.6298),
        LatLng(latitude: 41.8850, longitude: -87.6250),
        LatLng(latitude: 41.8900, longitude: -87.6200),
      ];

      final result = await service.calculateRoute(
        waypoints: waypoints,
        transportMode: TransportMode.walking,
      );

      expect(result.totalDistanceMeters, equals(2500));
      expect(result.totalDurationSeconds, equals(1800));
      expect(result.polyline, equals('test_polyline_encoded'));
      expect(result.legs.length, equals(2));
    });

    test('calculates route for driving mode', () async {
      final mockResponse = jsonEncode({
        'routes': [
          {
            'geometry': 'driving_polyline',
            'duration': 600,
            'distance': 5000,
            'legs': [
              {'duration': 300, 'distance': 2500},
              {'duration': 300, 'distance': 2500},
            ],
          },
        ],
      });

      Uri? capturedUri;
      when(() => mockHttpClient.get(any())).thenAnswer((invocation) async {
        capturedUri = invocation.positionalArguments[0] as Uri;
        return http.Response(mockResponse, 200);
      });

      final waypoints = [
        LatLng(latitude: 41.8781, longitude: -87.6298),
        LatLng(latitude: 41.9000, longitude: -87.6500),
      ];

      final result = await service.calculateRoute(
        waypoints: waypoints,
        transportMode: TransportMode.driving,
      );

      expect(result.totalDistanceMeters, equals(5000));
      expect(result.totalDurationSeconds, equals(600));
      expect(capturedUri?.path, contains('driving'));
    });

    test('returns fallback with estimated distances on API failure', () async {
      when(() => mockHttpClient.get(any()))
          .thenAnswer((_) async => http.Response('Server error', 500));

      final waypoints = [
        LatLng(latitude: 41.8781, longitude: -87.6298),
        LatLng(latitude: 41.8850, longitude: -87.6250),
      ];

      final result = await service.calculateRoute(
        waypoints: waypoints,
        transportMode: TransportMode.walking,
      );

      expect(result.warning, isNotNull);
      expect(result.totalDistanceMeters, greaterThan(0));
      expect(result.totalDurationSeconds, greaterThan(0));
      expect(result.legs.length, equals(1));
    });

    test('handles multi-waypoint route optimization', () async {
      final mockResponse = jsonEncode({
        'routes': [
          {
            'geometry': 'multi_waypoint_polyline',
            'duration': 3600,
            'distance': 8000,
            'legs': [
              {'duration': 900, 'distance': 2000},
              {'duration': 900, 'distance': 2000},
              {'duration': 900, 'distance': 2000},
              {'duration': 900, 'distance': 2000},
            ],
          },
        ],
      });

      when(() => mockHttpClient.get(any()))
          .thenAnswer((_) async => http.Response(mockResponse, 200));

      final waypoints = [
        LatLng(latitude: 41.8781, longitude: -87.6298),
        LatLng(latitude: 41.8850, longitude: -87.6250),
        LatLng(latitude: 41.8900, longitude: -87.6200),
        LatLng(latitude: 41.8950, longitude: -87.6150),
        LatLng(latitude: 41.9000, longitude: -87.6100),
      ];

      final result = await service.calculateRoute(
        waypoints: waypoints,
        transportMode: TransportMode.walking,
      );

      expect(result.legs.length, equals(4)); // n-1 legs for n waypoints
      expect(result.totalDistanceMeters, equals(8000));
    });
  });

  group('PolylineCodec', () {
    test('encodes and decodes polyline correctly', () {
      final original = [
        LatLng(latitude: 41.878113, longitude: -87.629799),
        LatLng(latitude: 41.885001, longitude: -87.625001),
        LatLng(latitude: 41.890000, longitude: -87.620000),
      ];

      final encoded = PolylineCodec.encode(original);
      expect(encoded, isNotEmpty);

      final decoded = PolylineCodec.decode(encoded);
      expect(decoded.length, equals(original.length));

      // Check coordinates are close (floating point precision)
      for (var i = 0; i < original.length; i++) {
        expect(
          decoded[i].latitude,
          closeTo(original[i].latitude, 0.00001),
        );
        expect(
          decoded[i].longitude,
          closeTo(original[i].longitude, 0.00001),
        );
      }
    });

    test('decodes Mapbox-style polyline', () {
      // Pre-encoded test polyline
      const encoded = '_p~iF~ps|U_ulLnnqC_mqNvxq`@';

      final decoded = PolylineCodec.decode(encoded, precision: 5);

      expect(decoded.length, equals(3));
      expect(decoded[0].latitude, closeTo(38.5, 0.1));
      expect(decoded[0].longitude, closeTo(-120.2, 0.1));
    });
  });

  group('RouteResult.fallback', () {
    test('calculates straight-line distance estimation', () {
      final waypoints = [
        LatLng(latitude: 41.8781, longitude: -87.6298),
        LatLng(latitude: 41.8881, longitude: -87.6298), // ~1.1 km north
      ];

      final result = RouteResult.fallback(
        waypoints: waypoints,
        transportMode: TransportMode.walking,
        warning: 'Test fallback',
      );

      // Distance should be approximately 1.1 km
      expect(result.totalDistanceMeters, greaterThan(1000));
      expect(result.totalDistanceMeters, lessThan(1200));
      expect(result.warning, equals('Test fallback'));
      expect(result.legs.length, equals(1));
    });

    test('estimates walking duration correctly', () {
      final waypoints = [
        LatLng(latitude: 41.8781, longitude: -87.6298),
        LatLng(latitude: 41.8881, longitude: -87.6298),
      ];

      final walkingResult = RouteResult.fallback(
        waypoints: waypoints,
        transportMode: TransportMode.walking,
        warning: 'Walking fallback',
      );

      final drivingResult = RouteResult.fallback(
        waypoints: waypoints,
        transportMode: TransportMode.driving,
        warning: 'Driving fallback',
      );

      // Walking should take longer than driving
      expect(
        walkingResult.totalDurationSeconds,
        greaterThan(drivingResult.totalDurationSeconds),
      );
    });
  });
}
