/// Base exception class for tour generation errors.
///
/// Provides user-friendly error messages without exposing internal details.
abstract class TourGenerationException implements Exception {
  /// User-friendly error message safe to display to clients.
  final String userMessage;

  /// Internal error details for logging (not exposed to users).
  final String? internalDetails;

  /// Original exception that caused this error (for logging).
  final Object? cause;

  TourGenerationException({
    required this.userMessage,
    this.internalDetails,
    this.cause,
  });

  @override
  String toString() => userMessage;

  /// Get detailed message for logging purposes.
  String toLogMessage() {
    final buffer = StringBuffer(userMessage);
    if (internalDetails != null) {
      buffer.write(' | Details: $internalDetails');
    }
    if (cause != null) {
      buffer.write(' | Cause: $cause');
    }
    return buffer.toString();
  }
}

/// Exception for API-related errors (Foursquare, Mapbox, etc.).
class ApiException extends TourGenerationException {
  /// The API service that failed.
  final String service;

  /// HTTP status code if available.
  final int? statusCode;

  ApiException({
    required this.service,
    this.statusCode,
    String? internalDetails,
    Object? cause,
  }) : super(
          userMessage: _getApiErrorMessage(service, statusCode),
          internalDetails: internalDetails,
          cause: cause,
        );

  static String _getApiErrorMessage(String service, int? statusCode) {
    if (statusCode == 401) {
      return 'Service authentication error. Please try again later.';
    }
    if (statusCode == 429) {
      return 'Too many requests. Please wait a moment and try again.';
    }
    if (statusCode != null && statusCode >= 500) {
      return 'Service temporarily unavailable. Please try again later.';
    }
    return 'Unable to connect to services. Please try again later.';
  }

  /// Whether this error can potentially be recovered from with cached data.
  bool get isRecoverable => statusCode != 401;
}

/// Exception for request validation errors.
class ValidationException extends TourGenerationException {
  /// The field that failed validation.
  final String field;

  /// The validation rule that was violated.
  final String rule;

  ValidationException({
    required this.field,
    required this.rule,
    required String message,
  }) : super(
          userMessage: message,
          internalDetails: 'Field: $field, Rule: $rule',
        );

  /// Create a validation exception for numStops.
  factory ValidationException.invalidNumStops(int value) {
    return ValidationException(
      field: 'numStops',
      rule: 'range',
      message: 'Number of stops must be between 3 and 6.',
    );
  }

  /// Create a validation exception for invalid coordinates.
  factory ValidationException.invalidCoordinates(
      String field, double value, double min, double max) {
    return ValidationException(
      field: field,
      rule: 'range',
      message: '$field must be between $min and $max.',
    );
  }

  /// Create a validation exception for past start time.
  factory ValidationException.pastStartTime() {
    return ValidationException(
      field: 'startTime',
      rule: 'future',
      message: 'Start time cannot be in the past.',
    );
  }
}

/// Exception for cache-related errors.
class CacheException extends TourGenerationException {
  /// The cache operation that failed.
  final String operation;

  CacheException({
    required this.operation,
    String? internalDetails,
    Object? cause,
  }) : super(
          userMessage: 'Unable to access cached data.',
          internalDetails: 'Operation: $operation, $internalDetails',
          cause: cause,
        );

  /// Whether the application can continue without the cached data.
  bool get canContinueWithoutCache => true;
}

/// Exception for insufficient results (partial tour scenario).
class InsufficientResultsException extends TourGenerationException {
  /// Number of results requested.
  final int requested;

  /// Number of results available.
  final int available;

  /// Suggestions for relaxing filters.
  final List<String> suggestions;

  InsufficientResultsException({
    required this.requested,
    required this.available,
    this.suggestions = const [],
  }) : super(
          userMessage: _buildMessage(requested, available, suggestions),
        );

  static String _buildMessage(
      int requested, int available, List<String> suggestions) {
    final buffer = StringBuffer(
      'Only $available of $requested stops could be found.',
    );
    if (suggestions.isNotEmpty) {
      buffer.write(' Try: ${suggestions.join(", ")}.');
    }
    return buffer.toString();
  }

  /// Whether any results are available (not a complete failure).
  bool get hasPartialResults => available > 0;
}

/// Exception for unexpected internal errors.
class InternalException extends TourGenerationException {
  InternalException({
    String? internalDetails,
    Object? cause,
  }) : super(
          userMessage:
              'An unexpected error occurred. Please try again later.',
          internalDetails: internalDetails,
          cause: cause,
        );
}

/// Helper class for formatting error responses.
class ErrorResponseFormatter {
  /// Format an exception for API response.
  static Map<String, dynamic> formatForResponse(TourGenerationException e) {
    return {
      'error': true,
      'message': e.userMessage,
      'type': _getErrorType(e),
    };
  }

  static String _getErrorType(TourGenerationException e) {
    if (e is ApiException) return 'api_error';
    if (e is ValidationException) return 'validation_error';
    if (e is CacheException) return 'cache_error';
    if (e is InsufficientResultsException) return 'insufficient_results';
    return 'internal_error';
  }

  /// Create a user-friendly error message from any exception.
  static String getUserFriendlyMessage(Object e) {
    if (e is TourGenerationException) {
      return e.userMessage;
    }
    // Never expose internal exception details to users
    return 'An error occurred while generating your tour. Please try again.';
  }
}
