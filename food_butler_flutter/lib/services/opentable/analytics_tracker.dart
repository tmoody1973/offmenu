import 'package:food_butler_client/food_butler_client.dart';
import 'reservation_launcher.dart';

/// Service for tracking reservation click analytics.
class ReservationAnalyticsTracker {
  final Client _client;

  ReservationAnalyticsTracker({
    required Client client,
  }) : _client = client;

  /// Track a reservation click event.
  ///
  /// Sends the event to the backend analytics service.
  /// Failures are logged but don't throw to avoid blocking user flow.
  Future<void> trackClick({
    required int restaurantId,
    required LaunchResult result,
    String? userId,
  }) async {
    try {
      await _client.analytics.recordReservationClick(
        restaurantId,
        result.linkType.name,
        result.success,
        userId: userId,
      );
    } catch (e) {
      // Log but don't throw - analytics failures shouldn't block user flow
      // In production, this would log to a monitoring service
      print('Analytics tracking failed: $e');
    }
  }
}
