import '../services/narrative_service.dart';

/// Static fallback templates for when LLM generation fails.
///
/// These fallbacks are grammatically complete but generic, providing
/// a reasonable user experience when the API is unavailable.
class NarrativeFallbacks {
  /// Generate fallback tour introduction.
  static String getIntroFallback(TourData tourData) {
    final cuisines = tourData.stops.map((s) => s.cuisineType).toSet();
    final cuisineStr = cuisines.length > 2
        ? '${cuisines.take(2).join(', ')}, and more'
        : cuisines.join(' and ');

    return 'Welcome to your culinary tour through ${tourData.neighborhood}. '
        'Over the next ${tourData.stops.length} stops, you will discover '
        'the diverse flavors of $cuisineStr that define this neighborhood. '
        'Each restaurant has been selected to showcase the best of local cuisine.';
  }

  /// Generate fallback restaurant description.
  static String getDescriptionFallback(TourStopData stop, int stopNumber, int totalStops) {
    final positionText = stopNumber == 1
        ? 'We begin our journey at'
        : stopNumber == totalStops
            ? 'For our final stop, we arrive at'
            : 'Our next destination is';

    final awardsNote = stop.awards.isNotEmpty
        ? ' This establishment has earned recognition with ${stop.awards.first}.'
        : '';

    final dishNote = stop.signatureDishes.isNotEmpty
        ? ' Notable dishes include ${stop.signatureDishes.take(2).join(' and ')}.'
        : '';

    return '$positionText ${stop.name}, offering an authentic ${stop.cuisineType} '
        'dining experience in the heart of ${stop.neighborhood}.$awardsNote$dishNote';
  }

  /// Generate fallback transition narrative.
  static String getTransitionFallback(
    TourStopData fromStop,
    TourStopData toStop,
    RouteLegData leg,
    String transportMode,
  ) {
    final durationText = leg.durationMinutes == 1
        ? 'a minute'
        : '${leg.durationMinutes} minutes';

    final modeText = transportMode.toLowerCase() == 'walking'
        ? 'walk'
        : 'drive';

    return 'A $durationText $modeText brings us from ${fromStop.name} '
        'to ${toStop.name}, where ${toStop.cuisineType} awaits.';
  }
}

/// Exception types for narrative generation errors.
class NarrativeGenerationException implements Exception {
  final String message;
  final String narrativeType;
  final int? stopIndex;
  final String? tourId;
  final String? originalError;

  NarrativeGenerationException({
    required this.message,
    required this.narrativeType,
    this.stopIndex,
    this.tourId,
    this.originalError,
  });

  @override
  String toString() {
    final stopInfo = stopIndex != null ? ', stop: $stopIndex' : '';
    return 'NarrativeGenerationException: $message '
        '(type: $narrativeType$stopInfo, tour: $tourId)';
  }

  /// Convert to structured log entry.
  Map<String, dynamic> toLogEntry() {
    return {
      'error_type': 'narrative_generation_failed',
      'message': message,
      'narrative_type': narrativeType,
      'stop_index': stopIndex,
      'tour_id': tourId,
      'original_error': originalError,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}

/// Logging helper for narrative failures.
class NarrativeErrorLogger {
  /// Log a narrative generation failure with full context.
  static Map<String, dynamic> createFailureLog({
    required int tourId,
    required String narrativeType,
    int? stopIndex,
    required String errorType,
    required String errorMessage,
    required int attemptCount,
  }) {
    return {
      'event': 'narrative_generation_failed',
      'tour_id': tourId,
      'narrative_type': narrativeType,
      'stop_index': stopIndex,
      'error_type': errorType,
      'error_message': errorMessage,
      'attempt_count': attemptCount,
      'timestamp': DateTime.now().toIso8601String(),
      'fallback_used': true,
    };
  }
}
