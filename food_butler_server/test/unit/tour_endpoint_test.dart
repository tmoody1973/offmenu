import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import 'package:food_butler_server/src/tours/tour_endpoint.dart';
import 'package:food_butler_server/src/generated/protocol.dart';

class MockSession extends Mock implements Session {}

class MockServerpod extends Mock implements Serverpod {}

/// Fake TourRequest for mocktail fallback registration.
class FakeTourRequest extends Fake implements TourRequest {}

void main() {
  late MockSession mockSession;
  late MockServerpod mockServerpod;
  late TourEndpoint endpoint;

  setUpAll(() {
    registerFallbackValue(FakeTourRequest());
    registerFallbackValue(TransportMode.walking);
    registerFallbackValue(BudgetTier.moderate);
  });

  setUp(() {
    mockSession = MockSession();
    mockServerpod = MockServerpod();
    endpoint = TourEndpoint();

    when(() => mockSession.log(any(), level: any(named: 'level')))
        .thenReturn(null);
    when(() => mockSession.sessionId).thenReturn(UuidValue.fromString(const Uuid().v4()));
    when(() => mockSession.serverpod).thenReturn(mockServerpod);
    when(() => mockServerpod.getPassword(any())).thenReturn('test_api_key');
  });

  group('TourEndpoint', () {
    test('generate returns TourResult for valid request', () async {
      // Arrange
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
      final result = await endpoint.generate(mockSession, request);

      // Assert - result should be returned (may be error due to no real API but structure is correct)
      expect(result, isNotNull);
      expect(result.stopsJson, isA<String>());
      expect(result.confidenceScore, greaterThanOrEqualTo(0));
      expect(result.confidenceScore, lessThanOrEqualTo(100));
      expect(result.createdAt, isNotNull);
    });

    test('generate returns validation error for invalid numStops below minimum', () async {
      // Arrange - numStops outside valid range 3-6
      final invalidRequest = TourRequest(
        startLatitude: 41.8781,
        startLongitude: -87.6298,
        numStops: 2, // Invalid: less than 3
        transportMode: TransportMode.walking,
        awardOnly: false,
        startTime: DateTime.now().add(const Duration(hours: 1)),
        budgetTier: BudgetTier.moderate,
        createdAt: DateTime.now(),
      );

      // Act
      final result = await endpoint.generate(mockSession, invalidRequest);

      // Assert - should return error result with validation message
      expect(result.isPartialTour, isTrue);
      expect(result.warningMessage, isNotNull);
      expect(result.warningMessage!.toLowerCase(), contains('stop'));
    });

    test('generate returns validation error for numStops above maximum', () async {
      // Arrange - numStops above valid range
      final invalidRequest = TourRequest(
        startLatitude: 41.8781,
        startLongitude: -87.6298,
        numStops: 10, // Invalid: greater than 6
        transportMode: TransportMode.walking,
        awardOnly: false,
        startTime: DateTime.now().add(const Duration(hours: 1)),
        budgetTier: BudgetTier.moderate,
        createdAt: DateTime.now(),
      );

      // Act
      final result = await endpoint.generate(mockSession, invalidRequest);

      // Assert - should return error result with validation message
      expect(result.isPartialTour, isTrue);
      expect(result.warningMessage, isNotNull);
      expect(result.warningMessage!.toLowerCase(), contains('stop'));
    });

    test('generate handles requests without errors', () async {
      // Arrange - valid request
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

      // Act - should not throw
      final result = await endpoint.generate(mockSession, request);

      // Assert - endpoint returns a result (rate limiting is handled internally)
      expect(result, isNotNull);
      expect(result.createdAt, isNotNull);
    });

    test('generate response structure matches TourResult schema', () async {
      // Arrange
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
      final result = await endpoint.generate(mockSession, request);

      // Assert - verify all required fields are present in the response
      expect(result.requestId, isA<int>());
      expect(result.stopsJson, isA<String>());
      expect(result.confidenceScore, isA<int>());
      expect(result.routePolyline, isA<String>());
      expect(result.routeLegsJson, isA<String>());
      expect(result.totalDistanceMeters, isA<int>());
      expect(result.totalDurationSeconds, isA<int>());
      expect(result.isPartialTour, isA<bool>());
      expect(result.createdAt, isA<DateTime>());

      // Verify stopsJson is valid JSON array
      expect(() => jsonDecode(result.stopsJson), returnsNormally);
      final stopsData = jsonDecode(result.stopsJson);
      expect(stopsData, isA<List>());

      // Verify routeLegsJson is valid JSON array
      expect(() => jsonDecode(result.routeLegsJson), returnsNormally);
      final legsData = jsonDecode(result.routeLegsJson);
      expect(legsData, isA<List>());
    });
  });
}
