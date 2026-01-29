import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/groq_client.dart';
import '../services/narrative_service.dart';

/// Narrative generation API endpoint.
///
/// Provides RESTful API for generating AI-powered tour narratives.
/// Endpoint: /api/v1/narratives/tour/{tour_id}
class NarrativeEndpoint extends Endpoint {
  /// Generate narratives for a tour.
  ///
  /// Parameters:
  /// - [tourId]: The tour result ID to generate narratives for
  /// - [regenerate]: If true, invalidates cache and generates fresh content
  ///
  /// Returns NarrativeResponse with intro, descriptions, and transitions.
  /// Rate limited to 3 regenerations per tour per day.
  Future<NarrativeResponse> generate(
    Session session,
    int tourId, {
    bool regenerate = false,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      // Get user ID from authenticated session (if available)
      final userId = _getAuthenticatedUserId(session);
      final userIdForTracking = userId ?? 'anonymous';

      // Check rate limit for regeneration
      if (regenerate) {
        final groqApiKey = await _getApiKey(session, 'GROQ_API_KEY');
        final groqClient = GroqClient(
          apiKey: groqApiKey,
          session: session,
        );

        final narrativeService = NarrativeService(
          groqClient: groqClient,
          session: session,
        );

        final canRegen = await narrativeService.canRegenerate(
          tourId,
          userIdForTracking,
        );

        if (!canRegen) {
          return _createRateLimitResponse();
        }

        // Increment regenerate count
        await narrativeService.incrementRegenerateCount(
          tourId,
          userIdForTracking,
        );
      }

      // Fetch the tour result
      final tourResult = await TourResult.db.findById(session, tourId);
      if (tourResult == null) {
        return _createErrorResponse('Tour not found');
      }

      // Fetch the tour request for additional context
      final tourRequest = await TourRequest.db.findById(
        session,
        tourResult.requestId,
      );
      if (tourRequest == null) {
        return _createErrorResponse('Tour request not found');
      }

      // Parse tour data from stored JSON
      final tourData = _parseTourData(tourResult, tourRequest);

      // Get user preferences if authenticated
      final userPrefs = await _getUserPreferences(session, userId);

      // Get API key and create service
      final groqApiKey = await _getApiKey(session, 'GROQ_API_KEY');
      final groqClient = GroqClient(
        apiKey: groqApiKey,
        session: session,
      );

      final narrativeService = NarrativeService(
        groqClient: groqClient,
        session: session,
      );

      // Generate narratives
      final response = await narrativeService.generateTourNarratives(
        tourData: tourData,
        userPreferences: userPrefs,
        regenerate: regenerate,
      );

      stopwatch.stop();
      session.log(
        'Narrative generation completed in ${stopwatch.elapsedMilliseconds}ms '
        '(cached: ${response.cached}, fallback: ${response.fallbackUsed})',
        level: LogLevel.info,
      );

      return response;
    } catch (e, stackTrace) {
      stopwatch.stop();
      session.log(
        'Narrative generation error: $e\n$stackTrace',
        level: LogLevel.error,
      );

      return _createErrorResponse(
        'An unexpected error occurred. Please try again.',
      );
    }
  }

  /// Parse tour data from stored result and request.
  TourData _parseTourData(TourResult tourResult, TourRequest tourRequest) {
    // Parse stops JSON
    final stopsJson = jsonDecode(tourResult.stopsJson) as List<dynamic>;
    final stops = stopsJson.map((s) {
      final stop = s as Map<String, dynamic>;
      return TourStopData(
        name: stop['name'] as String? ?? 'Unknown',
        cuisineType: (stop['cuisineTypes'] as List<dynamic>?)?.firstOrNull as String? ??
            'Restaurant',
        signatureDishes: (stop['recommendedDishes'] as List<dynamic>?)
                ?.map((d) => d as String)
                .toList() ??
            [],
        awards: (stop['awardBadges'] as List<dynamic>?)
                ?.map((a) => a as String)
                .toList() ??
            [],
        neighborhood: tourRequest.startAddress ?? 'the area',
      );
    }).toList();

    // Parse route legs JSON
    final legsJson = jsonDecode(tourResult.routeLegsJson) as List<dynamic>;
    final routeLegs = legsJson.map((l) {
      final leg = l as Map<String, dynamic>;
      final durationSeconds = leg['durationSeconds'] as int? ?? 300;
      final distanceMeters = leg['distanceMeters'] as int? ?? 0;

      return RouteLegData(
        durationMinutes: (durationSeconds / 60).ceil(),
        distanceDescription: distanceMeters > 0
            ? '${(distanceMeters / 1609.34).toStringAsFixed(1)} miles'
            : null,
      );
    }).toList();

    // Determine time of day from start time
    final hour = tourRequest.startTime.hour;
    String timeOfDay;
    if (hour < 11) {
      timeOfDay = 'morning';
    } else if (hour < 14) {
      timeOfDay = 'lunch';
    } else if (hour < 17) {
      timeOfDay = 'afternoon';
    } else {
      timeOfDay = 'evening';
    }

    // Convert TransportMode enum to string
    final transportModeStr = tourRequest.transportMode.toString();

    return TourData(
      tourId: tourResult.id!,
      neighborhood: tourRequest.startAddress ?? 'the neighborhood',
      transportMode: transportModeStr,
      timeOfDay: timeOfDay,
      stops: stops,
      routeLegs: routeLegs,
    );
  }

  /// Get authenticated user ID from session.
  String? _getAuthenticatedUserId(Session session) {
    try {
      final authInfo = session.authenticated;
      return authInfo?.authId.toString();
    } catch (e) {
      return null;
    }
  }

  /// Get user preferences for authenticated users.
  Future<UserPreferences> _getUserPreferences(
    Session session,
    String? userId,
  ) async {
    if (userId == null) {
      return UserPreferences.anonymous();
    }

    // TODO: In production, fetch from user profile table
    // For now, return basic authenticated user preferences
    return UserPreferences(
      userId: userId,
      cuisinePreferences: [],
      dietaryRestrictions: [],
      visitHistory: [],
    );
  }

  /// Get API key from environment or session secrets.
  Future<String> _getApiKey(Session session, String keyName) async {
    try {
      final key = session.serverpod.getPassword(keyName);
      if (key != null && key.isNotEmpty) {
        return key;
      }
    } catch (e) {
      session.log(
        'Could not get $keyName from secrets: $e',
        level: LogLevel.warning,
      );
    }

    final envKey = String.fromEnvironment(keyName);
    if (envKey.isNotEmpty) {
      return envKey;
    }

    session.log(
      'API key $keyName not found in secrets or environment',
      level: LogLevel.warning,
    );
    return '';
  }

  /// Create error response.
  NarrativeResponse _createErrorResponse(String message) {
    return NarrativeResponse(
      intro: message,
      descriptions: [],
      transitions: [],
      generatedAt: DateTime.now(),
      cached: false,
      ttlRemainingSeconds: 0,
      fallbackUsed: true,
      failedTypes: ['error'],
    );
  }

  /// Create rate limit exceeded response.
  NarrativeResponse _createRateLimitResponse() {
    return NarrativeResponse(
      intro: 'Regeneration limit exceeded. You can regenerate up to 3 times per day per tour. Please try again tomorrow.',
      descriptions: [],
      transitions: [],
      generatedAt: DateTime.now(),
      cached: false,
      ttlRemainingSeconds: 0,
      fallbackUsed: true,
      failedTypes: ['rate_limit'],
    );
  }
}
