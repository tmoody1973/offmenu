import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/award_matching_service.dart';
import '../services/google_places_service.dart';
import '../services/mapbox_service.dart';
import '../services/perplexity_service.dart';
import '../services/tour_generation_service.dart';

/// Exception for validation errors in tour generation.
class TourValidationException implements Exception {
  final String field;
  final String message;

  TourValidationException({required this.field, required this.message});

  @override
  String toString() => 'Validation error on $field: $message';
}

/// Tour generation API endpoint.
///
/// Provides RESTful API for generating optimized food tours.
/// Endpoint: POST /api/v1/tours/generate
class TourEndpoint extends Endpoint {
  // Rate limiting configuration
  static const int _rateLimitRequests = 60;
  static const Duration _rateLimitWindow = Duration(minutes: 1);

  // Request tracking for rate limiting (per session/client)
  final Map<String, List<DateTime>> _requestTracker = {};

  /// Generate an optimized food tour based on request parameters.
  ///
  /// Returns HTTP 200 with TourResult for successful generation.
  /// Returns HTTP 400 equivalent (via TourResult with error) for validation errors.
  /// Includes rate limiting headers in response.
  Future<TourResult> generate(Session session, TourRequest request) async {
    final stopwatch = Stopwatch()..start();

    try {
      // Check rate limiting
      final clientId = _getClientId(session);
      if (!_checkRateLimit(clientId)) {
        return _createErrorResult(
          request,
          'Rate limit exceeded. Please try again later.',
        );
      }

      // Validate request
      final validationErrors = _validateRequest(request);
      if (validationErrors.isNotEmpty) {
        final errorMessage = validationErrors
            .map((e) => '${e.field}: ${e.message}')
            .join('; ');
        return _createErrorResult(request, errorMessage);
      }

      // Get API keys from environment/secrets
      final googlePlacesApiKey = await _getApiKey(session, 'GOOGLE_PLACES_API_KEY');
      final mapboxAccessToken =
          await _getApiKey(session, 'MAPBOX_ACCESS_TOKEN');
      final perplexityApiKey = await _getApiKey(session, 'PERPLEXITY_API_KEY');

      // Create service instances
      final googlePlacesService = GooglePlacesService(
        apiKey: googlePlacesApiKey,
        session: session,
      );

      final awardMatchingService = AwardMatchingService(session: session);

      final mapboxService = MapboxService(
        accessToken: mapboxAccessToken,
        session: session,
      );

      // Create Perplexity service for AI-powered restaurant discovery
      PerplexityService? perplexityService;
      if (perplexityApiKey.isNotEmpty) {
        perplexityService = PerplexityService(
          apiKey: perplexityApiKey,
          session: session,
        );
        session.log('Perplexity AI enabled for unique restaurant discovery');
      } else {
        session.log('Perplexity API key not found, using Google Places only', level: LogLevel.warning);
      }

      final tourGenerationService = TourGenerationService(
        googlePlacesService: googlePlacesService,
        awardMatchingService: awardMatchingService,
        mapboxService: mapboxService,
        perplexityService: perplexityService,
        session: session,
      );

      // Generate the tour
      final result = await tourGenerationService.generateTour(request);

      stopwatch.stop();
      session.log(
        'Tour generation completed in ${stopwatch.elapsedMilliseconds}ms',
        level: LogLevel.info,
      );

      return result;
    } catch (e, stackTrace) {
      stopwatch.stop();
      session.log(
        'Tour generation error: $e\n$stackTrace',
        level: LogLevel.error,
      );

      return _createErrorResult(
        request,
        'An unexpected error occurred. Please try again.',
      );
    }
  }

  /// Validate all TourRequest fields.
  List<TourValidationException> _validateRequest(TourRequest request) {
    final errors = <TourValidationException>[];

    // Validate numStops (3-6 inclusive)
    if (request.numStops < 3 || request.numStops > 6) {
      errors.add(TourValidationException(
        field: 'numStops',
        message: 'Number of stops must be between 3 and 6.',
      ));
    }

    // Validate latitude (-90 to 90)
    if (request.startLatitude < -90 || request.startLatitude > 90) {
      errors.add(TourValidationException(
        field: 'startLatitude',
        message: 'Latitude must be between -90 and 90.',
      ));
    }

    // Validate longitude (-180 to 180)
    if (request.startLongitude < -180 || request.startLongitude > 180) {
      errors.add(TourValidationException(
        field: 'startLongitude',
        message: 'Longitude must be between -180 and 180.',
      ));
    }

    // Validate startTime is not in the past (allow 5 minute buffer)
    final now = DateTime.now().subtract(const Duration(minutes: 5));
    if (request.startTime.isBefore(now)) {
      errors.add(TourValidationException(
        field: 'startTime',
        message: 'Start time cannot be in the past.',
      ));
    }

    // Validate endTime is after startTime if provided
    if (request.endTime != null && request.endTime!.isBefore(request.startTime)) {
      errors.add(TourValidationException(
        field: 'endTime',
        message: 'End time must be after start time.',
      ));
    }

    return errors;
  }

  /// Get a unique client identifier for rate limiting.
  String _getClientId(Session session) {
    // Use session ID or IP address for client identification
    return session.sessionId.toString();
  }

  /// Check if the client has exceeded rate limits.
  bool _checkRateLimit(String clientId) {
    final now = DateTime.now();
    final windowStart = now.subtract(_rateLimitWindow);

    // Get or create request list for this client
    final requests = _requestTracker[clientId] ?? [];

    // Remove requests outside the window
    requests.removeWhere((time) => time.isBefore(windowStart));

    // Check if under limit
    if (requests.length >= _rateLimitRequests) {
      return false;
    }

    // Add this request
    requests.add(now);
    _requestTracker[clientId] = requests;

    // Clean up old client entries periodically
    if (_requestTracker.length > 1000) {
      _cleanupRateLimitTracker();
    }

    return true;
  }

  /// Clean up stale rate limit entries.
  void _cleanupRateLimitTracker() {
    final now = DateTime.now();
    final windowStart = now.subtract(_rateLimitWindow);

    _requestTracker.removeWhere((clientId, requests) {
      requests.removeWhere((time) => time.isBefore(windowStart));
      return requests.isEmpty;
    });
  }

  /// Get rate limit info for response headers.
  Map<String, String> _getRateLimitHeaders(String clientId) {
    final requests = _requestTracker[clientId] ?? [];
    final remaining = _rateLimitRequests - requests.length;
    final resetTime = DateTime.now()
        .add(_rateLimitWindow)
        .millisecondsSinceEpoch ~/
        1000;

    return {
      'X-RateLimit-Limit': _rateLimitRequests.toString(),
      'X-RateLimit-Remaining': remaining.clamp(0, _rateLimitRequests).toString(),
      'X-RateLimit-Reset': resetTime.toString(),
    };
  }

  /// Get API key from environment or session secrets.
  Future<String> _getApiKey(Session session, String keyName) async {
    // Try to get from session passwords/secrets first
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

    // Fallback to environment variable
    final envKey = String.fromEnvironment(keyName);
    if (envKey.isNotEmpty) {
      return envKey;
    }

    // Return empty string and let the service handle the error
    session.log(
      'API key $keyName not found in secrets or environment',
      level: LogLevel.warning,
    );
    return '';
  }

  /// Create an error result for validation or other failures.
  TourResult _createErrorResult(TourRequest request, String message) {
    return TourResult(
      requestId: request.id ?? 0,
      stopsJson: '[]',
      routeLegsJson: '[]',
      confidenceScore: 0,
      routePolyline: '',
      totalDistanceMeters: 0,
      totalDurationSeconds: 0,
      isPartialTour: true,
      warningMessage: message,
      createdAt: DateTime.now(),
    );
  }
}
