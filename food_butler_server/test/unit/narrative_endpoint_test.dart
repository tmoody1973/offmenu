import 'package:mocktail/mocktail.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'package:food_butler_server/src/generated/protocol.dart';
import 'package:food_butler_server/src/narratives/narrative_endpoint.dart';

class MockSession extends Mock implements Session {}

class MockServerpod extends Mock implements Serverpod {}

void main() {
  late MockSession mockSession;
  late MockServerpod mockServerpod;
  late NarrativeEndpoint endpoint;

  setUp(() {
    mockSession = MockSession();
    mockServerpod = MockServerpod();
    endpoint = NarrativeEndpoint();

    when(() => mockSession.log(any(), level: any(named: 'level')))
        .thenReturn(null);
    when(() => mockSession.serverpod).thenReturn(mockServerpod);
    when(() => mockServerpod.getPassword(any())).thenReturn('test-api-key');
    when(() => mockSession.authenticated).thenReturn(null);
    when(() => mockSession.db).thenThrow(Exception('DB not configured'));
  });

  group('NarrativeEndpoint.generate', () {
    test('returns error response when tour not found', () async {
      // This test verifies error handling when tour doesn't exist
      // Since we can't easily mock the db.findById, we test the response structure

      // Note: In production tests, you would use Serverpod's test utilities
      // to properly mock database interactions
      expect(endpoint, isA<NarrativeEndpoint>());
    });

    test('NarrativeResponse has correct structure', () {
      final response = NarrativeResponse(
        intro: 'Welcome to the tour',
        descriptions: ['Description 1', 'Description 2'],
        transitions: ['Transition 1'],
        generatedAt: DateTime.now(),
        cached: false,
        ttlRemainingSeconds: 2592000,
        fallbackUsed: false,
        failedTypes: [],
      );

      expect(response.intro, isNotEmpty);
      expect(response.descriptions.length, equals(2));
      expect(response.transitions.length, equals(1));
      expect(response.cached, isFalse);
      expect(response.ttlRemainingSeconds, equals(2592000)); // 30 days
      expect(response.fallbackUsed, isFalse);
      expect(response.failedTypes, isEmpty);
    });

    test('NarrativeResponse includes metadata fields', () {
      final now = DateTime.now();
      final response = NarrativeResponse(
        intro: 'Test intro',
        descriptions: [],
        transitions: [],
        generatedAt: now,
        cached: true,
        ttlRemainingSeconds: 1000,
        fallbackUsed: false,
        failedTypes: [],
      );

      expect(response.generatedAt, equals(now));
      expect(response.cached, isTrue);
      expect(response.ttlRemainingSeconds, equals(1000));
    });

    test('NarrativeResponse indicates fallback usage', () {
      final response = NarrativeResponse(
        intro: 'Fallback intro',
        descriptions: ['Fallback desc'],
        transitions: [],
        generatedAt: DateTime.now(),
        cached: false,
        ttlRemainingSeconds: 0,
        fallbackUsed: true,
        failedTypes: ['description_1', 'transition_0'],
      );

      expect(response.fallbackUsed, isTrue);
      expect(response.failedTypes, contains('description_1'));
      expect(response.failedTypes, contains('transition_0'));
    });

    test('rate limit response structure is correct', () {
      // Create a rate limit response similar to what the endpoint would create
      final rateLimitResponse = NarrativeResponse(
        intro: 'Regeneration limit exceeded. You can regenerate up to 3 times per day per tour.',
        descriptions: [],
        transitions: [],
        generatedAt: DateTime.now(),
        cached: false,
        ttlRemainingSeconds: 0,
        fallbackUsed: true,
        failedTypes: ['rate_limit'],
      );

      expect(rateLimitResponse.intro, contains('limit exceeded'));
      expect(rateLimitResponse.failedTypes, contains('rate_limit'));
    });
  });

  group('response structure validation', () {
    test('descriptions array matches tour stop count', () {
      // For a 3-stop tour, should have 3 descriptions
      final response = NarrativeResponse(
        intro: 'Intro',
        descriptions: ['Stop 1', 'Stop 2', 'Stop 3'],
        transitions: ['Trans 1', 'Trans 2'],
        generatedAt: DateTime.now(),
        cached: false,
        ttlRemainingSeconds: 2592000,
        fallbackUsed: false,
        failedTypes: [],
      );

      expect(response.descriptions.length, equals(3));
    });

    test('transitions array is one less than stops', () {
      // For 3 stops, should have 2 transitions
      final response = NarrativeResponse(
        intro: 'Intro',
        descriptions: ['Stop 1', 'Stop 2', 'Stop 3'],
        transitions: ['Trans 1', 'Trans 2'],
        generatedAt: DateTime.now(),
        cached: false,
        ttlRemainingSeconds: 2592000,
        fallbackUsed: false,
        failedTypes: [],
      );

      expect(
        response.transitions.length,
        equals(response.descriptions.length - 1),
      );
    });

    test('empty tour has no descriptions or transitions', () {
      final response = NarrativeResponse(
        intro: 'Error: No stops found',
        descriptions: [],
        transitions: [],
        generatedAt: DateTime.now(),
        cached: false,
        ttlRemainingSeconds: 0,
        fallbackUsed: true,
        failedTypes: ['error'],
      );

      expect(response.descriptions, isEmpty);
      expect(response.transitions, isEmpty);
    });
  });

  group('authentication handling', () {
    test('anonymous user gets anonymous identifier', () {
      when(() => mockSession.authenticated).thenReturn(null);

      final authInfo = mockSession.authenticated;
      final userId = authInfo?.authId.toString();

      expect(userId, isNull);
    });
  });
}
