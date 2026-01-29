import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'package:food_butler_server/src/services/groq_client.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockSession extends Mock implements Session {}

class FakeUri extends Fake implements Uri {}

void main() {
  late MockHttpClient mockHttpClient;
  late MockSession mockSession;
  late GroqClient client;

  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockSession = MockSession();

    when(() => mockSession.log(any(), level: any(named: 'level')))
        .thenReturn(null);

    client = GroqClient(
      apiKey: 'test-groq-api-key',
      session: mockSession,
      httpClient: mockHttpClient,
      temperature: 0.75,
    );
  });

  tearDown(() {
    client.dispose();
  });

  group('chatCompletion', () {
    test('returns response on successful API call', () async {
      final mockResponse = jsonEncode({
        'choices': [
          {
            'message': {
              'role': 'assistant',
              'content': 'Welcome to the culinary adventure through downtown.',
            },
          },
        ],
        'usage': {
          'prompt_tokens': 100,
          'completion_tokens': 50,
          'total_tokens': 150,
        },
      });

      when(() => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response(mockResponse, 200));

      final response = await client.chatCompletion(
        systemPrompt: 'You are a food guide.',
        userPrompt: 'Generate a tour introduction.',
        tourId: 123,
        narrativeType: 'intro',
      );

      expect(response.content, contains('culinary adventure'));
      expect(response.promptTokens, equals(100));
      expect(response.completionTokens, equals(50));
      expect(response.totalTokens, equals(150));
    });

    test('handles timeout with retry', () async {
      var callCount = 0;
      final mockResponse = jsonEncode({
        'choices': [
          {
            'message': {
              'content': 'Successful after retry.',
            },
          },
        ],
        'usage': {},
      });

      when(() => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async {
        callCount++;
        if (callCount < 2) {
          await Future.delayed(const Duration(seconds: 15));
          throw Exception('Timeout');
        }
        return http.Response(mockResponse, 200);
      });

      final response = await client.chatCompletion(
        systemPrompt: 'Test system prompt',
        userPrompt: 'Test user prompt',
      );

      expect(response.content, equals('Successful after retry.'));
      expect(callCount, equals(2));
    });

    test('retries with exponential backoff on 5xx errors', () async {
      var callCount = 0;
      final timestamps = <DateTime>[];
      final mockResponse = jsonEncode({
        'choices': [
          {
            'message': {
              'content': 'Success after 5xx retries.',
            },
          },
        ],
        'usage': {},
      });

      when(() => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async {
        callCount++;
        timestamps.add(DateTime.now());

        if (callCount < 3) {
          return http.Response('Server Error', 503);
        }
        return http.Response(mockResponse, 200);
      });

      final response = await client.chatCompletion(
        systemPrompt: 'Test',
        userPrompt: 'Test',
      );

      expect(callCount, equals(3));
      expect(response.content, equals('Success after 5xx retries.'));
    });

    test('does not retry on 4xx client errors', () async {
      when(() => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response(
                jsonEncode({
                  'error': {'message': 'Invalid API key'}
                }),
                401,
              ));

      expect(
        () => client.chatCompletion(
          systemPrompt: 'Test',
          userPrompt: 'Test',
        ),
        throwsA(isA<GroqApiException>()
            .having((e) => e.statusCode, 'statusCode', 401)
            .having((e) => e.isRetryable, 'isRetryable', false)),
      );
    });

    test('handles rate limit (429) with retry', () async {
      var callCount = 0;
      final mockResponse = jsonEncode({
        'choices': [
          {
            'message': {
              'content': 'Success after rate limit.',
            },
          },
        ],
        'usage': {},
      });

      when(() => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async {
        callCount++;
        if (callCount == 1) {
          return http.Response(
            jsonEncode({'error': {'message': 'Rate limit exceeded'}}),
            429,
          );
        }
        return http.Response(mockResponse, 200);
      });

      final response = await client.chatCompletion(
        systemPrompt: 'Test',
        userPrompt: 'Test',
      );

      expect(callCount, equals(2));
      expect(response.content, equals('Success after rate limit.'));
    });

    test('throws after all retries exhausted', () async {
      when(() => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response('Server Error', 500));

      expect(
        () => client.chatCompletion(
          systemPrompt: 'Test',
          userPrompt: 'Test',
        ),
        throwsA(isA<GroqApiException>()),
      );
    });
  });

  group('rate limit tracking', () {
    test('tracks daily request count', () async {
      final mockResponse = jsonEncode({
        'choices': [
          {
            'message': {'content': 'Test response'},
          },
        ],
        'usage': {},
      });

      when(() => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response(mockResponse, 200));

      final initialCount = client.dailyRequestCount;

      await client.chatCompletion(
        systemPrompt: 'Test',
        userPrompt: 'Test',
      );

      expect(client.dailyRequestCount, equals(initialCount + 1));
    });
  });
}
