import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

/// Response from Groq API chat completion.
class GroqChatResponse {
  final String content;
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;

  GroqChatResponse({
    required this.content,
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });
}

/// Exception for Groq API errors.
class GroqApiException implements Exception {
  final String message;
  final int? statusCode;
  final bool isRetryable;

  GroqApiException({
    required this.message,
    this.statusCode,
    this.isRetryable = false,
  });

  @override
  String toString() => 'GroqApiException: $message (status: $statusCode)';
}

/// Client for interacting with Groq API.
///
/// Uses OpenAI GPT-OSS 120B model for narrative generation.
class GroqClient {
  static const String _baseUrl = 'https://api.groq.com/openai/v1';
  static const String _model = 'openai/gpt-oss-120b';
  static const Duration _timeout = Duration(seconds: 10);
  static const int _maxRetries = 3;
  static const List<Duration> _retryDelays = [
    Duration(seconds: 1),
    Duration(seconds: 2),
    Duration(seconds: 4),
  ];

  // Daily rate limit tracking (14,400 requests/day free tier)
  static const int _dailyRateLimit = 14400;
  static int _dailyRequestCount = 0;
  static DateTime? _rateLimitResetDate;

  final String _apiKey;
  final http.Client _httpClient;
  final Session _session;
  final double _temperature;

  GroqClient({
    required String apiKey,
    required Session session,
    http.Client? httpClient,
    double temperature = 0.75,
  })  : _apiKey = apiKey,
        _session = session,
        _httpClient = httpClient ?? http.Client(),
        _temperature = temperature.clamp(0.7, 0.8);

  /// Complete a chat request with the given prompts.
  ///
  /// Parameters:
  /// - [systemPrompt]: The system prompt defining the AI persona
  /// - [userPrompt]: The user prompt with context and instructions
  /// - [tourId]: Optional tour ID for tracing
  /// - [narrativeType]: Optional narrative type for tracing
  Future<GroqChatResponse> chatCompletion({
    required String systemPrompt,
    required String userPrompt,
    int? tourId,
    String? narrativeType,
  }) async {
    // Check and update daily rate limit
    _checkDailyRateLimit();

    final requestBody = {
      'model': _model,
      'messages': [
        {'role': 'system', 'content': systemPrompt},
        {'role': 'user', 'content': userPrompt},
      ],
      'temperature': _temperature,
      'max_tokens': 500,
    };

    final metadata = <String, dynamic>{};
    if (tourId != null) metadata['tour_id'] = tourId;
    if (narrativeType != null) metadata['narrative_type'] = narrativeType;

    return _makeRequestWithRetry(
      requestBody: requestBody,
      metadata: metadata,
    );
  }

  /// Make the API request with retry logic.
  Future<GroqChatResponse> _makeRequestWithRetry({
    required Map<String, dynamic> requestBody,
    required Map<String, dynamic> metadata,
  }) async {
    GroqApiException? lastException;

    for (var attempt = 0; attempt < _maxRetries; attempt++) {
      try {
        final response = await _makeRequest(requestBody);
        _incrementRequestCount();
        return response;
      } on GroqApiException catch (e) {
        lastException = e;

        if (!e.isRetryable) {
          _session.log(
            'Groq API non-retryable error: ${e.message}',
            level: LogLevel.error,
          );
          rethrow;
        }

        if (attempt < _maxRetries - 1) {
          final delay = _retryDelays[attempt];
          _session.log(
            'Groq API error (attempt ${attempt + 1}/$_maxRetries), '
            'retrying in ${delay.inSeconds}s: ${e.message}',
            level: LogLevel.warning,
          );
          await Future.delayed(delay);
        }
      } on TimeoutException {
        lastException = GroqApiException(
          message: 'Request timed out',
          isRetryable: true,
        );

        if (attempt < _maxRetries - 1) {
          final delay = _retryDelays[attempt];
          _session.log(
            'Groq API timeout (attempt ${attempt + 1}/$_maxRetries), '
            'retrying in ${delay.inSeconds}s',
            level: LogLevel.warning,
          );
          await Future.delayed(delay);
        }
      }
    }

    _session.log(
      'Groq API failed after $_maxRetries attempts. '
      'Metadata: ${jsonEncode(metadata)}',
      level: LogLevel.error,
    );

    throw lastException ??
        GroqApiException(
          message: 'All retry attempts exhausted',
          isRetryable: false,
        );
  }

  /// Make a single API request.
  Future<GroqChatResponse> _makeRequest(Map<String, dynamic> requestBody) async {
    final uri = Uri.parse('$_baseUrl/chat/completions');

    final response = await _httpClient
        .post(
          uri,
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(requestBody),
        )
        .timeout(_timeout);

    if (response.statusCode == 200) {
      return _parseResponse(response.body);
    }

    // Handle specific error codes
    final isRetryable = response.statusCode == 429 ||
        response.statusCode == 503 ||
        response.statusCode >= 500;

    String errorMessage;
    try {
      final errorJson = jsonDecode(response.body) as Map<String, dynamic>;
      errorMessage = errorJson['error']?['message'] as String? ??
          'Unknown error: ${response.statusCode}';
    } catch (_) {
      errorMessage = 'HTTP ${response.statusCode}: ${response.body}';
    }

    throw GroqApiException(
      message: errorMessage,
      statusCode: response.statusCode,
      isRetryable: isRetryable,
    );
  }

  /// Parse the API response.
  GroqChatResponse _parseResponse(String body) {
    final json = jsonDecode(body) as Map<String, dynamic>;
    final choices = json['choices'] as List<dynamic>?;

    if (choices == null || choices.isEmpty) {
      throw GroqApiException(
        message: 'No choices in response',
        isRetryable: false,
      );
    }

    final message = choices[0]['message'] as Map<String, dynamic>?;
    final content = message?['content'] as String?;

    if (content == null || content.isEmpty) {
      throw GroqApiException(
        message: 'Empty content in response',
        isRetryable: false,
      );
    }

    final usage = json['usage'] as Map<String, dynamic>? ?? {};

    return GroqChatResponse(
      content: content.trim(),
      promptTokens: usage['prompt_tokens'] as int? ?? 0,
      completionTokens: usage['completion_tokens'] as int? ?? 0,
      totalTokens: usage['total_tokens'] as int? ?? 0,
    );
  }

  /// Check if we're approaching the daily rate limit.
  void _checkDailyRateLimit() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Reset counter if it's a new day
    if (_rateLimitResetDate == null || _rateLimitResetDate!.isBefore(today)) {
      _rateLimitResetDate = today;
      _dailyRequestCount = 0;
    }

    // Log warning when approaching limit
    final usagePercent = (_dailyRequestCount / _dailyRateLimit) * 100;
    if (usagePercent >= 80) {
      _session.log(
        'Groq API daily usage at ${usagePercent.toStringAsFixed(1)}% '
        '($_dailyRequestCount/$_dailyRateLimit)',
        level: LogLevel.warning,
      );
    }
  }

  /// Increment the daily request counter.
  void _incrementRequestCount() {
    _dailyRequestCount++;
  }

  /// Get current daily request count for monitoring.
  int get dailyRequestCount => _dailyRequestCount;

  /// Get remaining daily requests.
  int get remainingDailyRequests => _dailyRateLimit - _dailyRequestCount;

  /// Close the HTTP client.
  void dispose() {
    _httpClient.close();
  }
}
