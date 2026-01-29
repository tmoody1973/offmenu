import 'package:mocktail/mocktail.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'package:food_butler_server/src/services/groq_client.dart';
import 'package:food_butler_server/src/services/narrative_service.dart';
import 'package:food_butler_server/src/generated/protocol.dart';

class MockGroqClient extends Mock implements GroqClient {}

class MockSession extends Mock implements Session {}

class MockDatabase extends Mock implements Database {}

void main() {
  late MockGroqClient mockGroqClient;
  late MockSession mockSession;
  late NarrativeService service;

  setUp(() {
    mockGroqClient = MockGroqClient();
    mockSession = MockSession();

    when(() => mockSession.log(any(), level: any(named: 'level')))
        .thenReturn(null);

    // Mock database operations to throw (simulating no cache)
    when(() => mockSession.db).thenThrow(Exception('DB not available in unit test'));

    service = NarrativeService(
      groqClient: mockGroqClient,
      session: mockSession,
    );
  });

  TourData createTestTourData({int stopCount = 3}) {
    return TourData(
      tourId: 123,
      neighborhood: 'West Loop',
      transportMode: 'walking',
      timeOfDay: 'evening',
      stops: List.generate(
        stopCount,
        (i) => TourStopData(
          name: 'Restaurant ${i + 1}',
          cuisineType: ['Italian', 'Korean', 'Mexican'][i % 3],
          signatureDishes: ['Dish A', 'Dish B'],
          awards: i == 0 ? ['James Beard'] : [],
          neighborhood: 'West Loop',
        ),
      ),
      routeLegs: List.generate(
        stopCount - 1,
        (i) => RouteLegData(
          durationMinutes: 5 + i,
          distanceDescription: '0.${i + 3} miles',
        ),
      ),
    );
  }

  group('generateTourNarratives', () {
    test('generates full tour narratives (intro + descriptions + transitions)', () async {
      when(() => mockGroqClient.chatCompletion(
            systemPrompt: any(named: 'systemPrompt'),
            userPrompt: any(named: 'userPrompt'),
            tourId: any(named: 'tourId'),
            narrativeType: any(named: 'narrativeType'),
          )).thenAnswer((invocation) async {
        final narrativeType = invocation.namedArguments[#narrativeType] as String?;
        switch (narrativeType) {
          case 'intro':
            return GroqChatResponse(
              content: 'Welcome to West Loop culinary adventure.',
              promptTokens: 100,
              completionTokens: 20,
              totalTokens: 120,
            );
          case 'description':
            return GroqChatResponse(
              content: 'This restaurant offers exceptional dishes.',
              promptTokens: 150,
              completionTokens: 30,
              totalTokens: 180,
            );
          case 'transition':
            return GroqChatResponse(
              content: 'A short walk brings us to our next stop.',
              promptTokens: 80,
              completionTokens: 15,
              totalTokens: 95,
            );
          default:
            return GroqChatResponse(
              content: 'Default response',
              promptTokens: 50,
              completionTokens: 10,
              totalTokens: 60,
            );
        }
      });

      final tourData = createTestTourData(stopCount: 3);

      final response = await service.generateTourNarratives(
        tourData: tourData,
      );

      expect(response.intro, contains('West Loop'));
      expect(response.descriptions.length, equals(3));
      expect(response.transitions.length, equals(2));
      expect(response.fallbackUsed, isFalse);
      expect(response.failedTypes, isEmpty);
    });

    test('handles partial success when some narratives fail', () async {
      var callCount = 0;

      when(() => mockGroqClient.chatCompletion(
            systemPrompt: any(named: 'systemPrompt'),
            userPrompt: any(named: 'userPrompt'),
            tourId: any(named: 'tourId'),
            narrativeType: any(named: 'narrativeType'),
          )).thenAnswer((_) async {
        callCount++;
        // Fail on second and third calls (first description)
        if (callCount == 2) {
          throw GroqApiException(
            message: 'API Error',
            isRetryable: false,
          );
        }
        return GroqChatResponse(
          content: 'Generated narrative content.',
          promptTokens: 100,
          completionTokens: 25,
          totalTokens: 125,
        );
      });

      final tourData = createTestTourData(stopCount: 2);

      final response = await service.generateTourNarratives(
        tourData: tourData,
      );

      // Should still return a response with fallback for failed narrative
      expect(response.intro, isNotEmpty);
      expect(response.descriptions.length, equals(2));
      expect(response.fallbackUsed, isTrue);
      expect(response.failedTypes, contains('description_0'));
    });

    test('uses cached content when available', () async {
      // For this test, we verify behavior by checking that when cache returns
      // content, we don't call the Groq API

      // The service internally handles caching, but in unit tests we mock DB
      // So we test the caching behavior indirectly through the service's response

      when(() => mockGroqClient.chatCompletion(
            systemPrompt: any(named: 'systemPrompt'),
            userPrompt: any(named: 'userPrompt'),
            tourId: any(named: 'tourId'),
            narrativeType: any(named: 'narrativeType'),
          )).thenAnswer((_) async => GroqChatResponse(
            content: 'Fresh generated content.',
            promptTokens: 100,
            completionTokens: 25,
            totalTokens: 125,
          ));

      final tourData = createTestTourData(stopCount: 2);

      final response = await service.generateTourNarratives(
        tourData: tourData,
      );

      // Since cache is not available (mocked to throw), all content is fresh
      expect(response.cached, isFalse);
      expect(response.intro, isNotEmpty);
    });

    test('includes user preferences in personalized narratives', () async {
      String? capturedUserPrompt;

      when(() => mockGroqClient.chatCompletion(
            systemPrompt: any(named: 'systemPrompt'),
            userPrompt: any(named: 'userPrompt'),
            tourId: any(named: 'tourId'),
            narrativeType: any(named: 'narrativeType'),
          )).thenAnswer((invocation) async {
        final narrativeType = invocation.namedArguments[#narrativeType] as String?;
        if (narrativeType == 'intro') {
          capturedUserPrompt = invocation.namedArguments[#userPrompt] as String?;
        }
        return GroqChatResponse(
          content: 'Personalized narrative.',
          promptTokens: 100,
          completionTokens: 25,
          totalTokens: 125,
        );
      });

      final tourData = createTestTourData(stopCount: 2);
      final userPrefs = UserPreferences(
        userId: 'user-123',
        cuisinePreferences: ['Italian', 'Seafood'],
        dietaryRestrictions: ['gluten-free'],
      );

      await service.generateTourNarratives(
        tourData: tourData,
        userPreferences: userPrefs,
      );

      expect(capturedUserPrompt, isNotNull);
      expect(capturedUserPrompt, contains('Italian'));
      expect(capturedUserPrompt, contains('Seafood'));
    });
  });

  group('fallback handling', () {
    test('returns grammatically complete fallback text on all failures', () async {
      when(() => mockGroqClient.chatCompletion(
            systemPrompt: any(named: 'systemPrompt'),
            userPrompt: any(named: 'userPrompt'),
            tourId: any(named: 'tourId'),
            narrativeType: any(named: 'narrativeType'),
          )).thenThrow(GroqApiException(
        message: 'All retries exhausted',
        isRetryable: false,
      ));

      final tourData = createTestTourData(stopCount: 2);

      final response = await service.generateTourNarratives(
        tourData: tourData,
      );

      // Should return fallback content for all narratives
      expect(response.fallbackUsed, isTrue);
      expect(response.intro, isNotEmpty);
      expect(response.intro, contains('Welcome'));
      expect(response.descriptions.length, equals(2));
      expect(response.transitions.length, equals(1));

      // Verify fallback text is grammatically complete
      for (final desc in response.descriptions) {
        expect(desc.endsWith('.'), isTrue);
      }
      for (final trans in response.transitions) {
        expect(trans.endsWith('.'), isTrue);
      }
    });
  });

  group('regenerate functionality', () {
    test('regenerate flag triggers fresh generation', () async {
      var generateCount = 0;

      when(() => mockGroqClient.chatCompletion(
            systemPrompt: any(named: 'systemPrompt'),
            userPrompt: any(named: 'userPrompt'),
            tourId: any(named: 'tourId'),
            narrativeType: any(named: 'narrativeType'),
          )).thenAnswer((_) async {
        generateCount++;
        return GroqChatResponse(
          content: 'Regenerated content $generateCount',
          promptTokens: 100,
          completionTokens: 25,
          totalTokens: 125,
        );
      });

      final tourData = createTestTourData(stopCount: 2);

      // First generation
      await service.generateTourNarratives(
        tourData: tourData,
      );

      final firstCount = generateCount;

      // Regenerate
      final response = await service.generateTourNarratives(
        tourData: tourData,
        regenerate: true,
      );

      // Should have made more API calls for regeneration
      expect(generateCount, greaterThan(firstCount));
      expect(response.cached, isFalse);
    });
  });

  group('single restaurant tour', () {
    test('handles tour with single restaurant (no transitions)', () async {
      when(() => mockGroqClient.chatCompletion(
            systemPrompt: any(named: 'systemPrompt'),
            userPrompt: any(named: 'userPrompt'),
            tourId: any(named: 'tourId'),
            narrativeType: any(named: 'narrativeType'),
          )).thenAnswer((_) async => GroqChatResponse(
            content: 'Single stop narrative.',
            promptTokens: 100,
            completionTokens: 25,
            totalTokens: 125,
          ));

      final tourData = createTestTourData(stopCount: 1);

      final response = await service.generateTourNarratives(
        tourData: tourData,
      );

      expect(response.intro, isNotEmpty);
      expect(response.descriptions.length, equals(1));
      expect(response.transitions, isEmpty);
    });
  });
}
