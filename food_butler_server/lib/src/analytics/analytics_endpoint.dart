import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Analytics API endpoint for tracking user interactions.
///
/// Provides endpoints for recording analytics events like reservation clicks.
class AnalyticsEndpoint extends Endpoint {
  /// Record a reservation link click event.
  ///
  /// Accepts click data and stores it in the database for analytics purposes.
  /// Returns the created event ID on success.
  Future<int> recordReservationClick(
    Session session,
    int restaurantId,
    String linkType,
    bool launchSuccess, {
    String? userId,
  }) async {
    // Validate linkType against allowed values
    ReservationLinkType parsedLinkType;
    try {
      parsedLinkType = ReservationLinkType.fromJson(linkType);
    } catch (e) {
      session.log(
        'Invalid linkType: $linkType',
        level: LogLevel.warning,
      );
      throw ArgumentError('Invalid linkType: $linkType');
    }

    final now = DateTime.now();
    final event = ReservationClickEvent(
      restaurantId: restaurantId,
      linkType: parsedLinkType,
      userId: userId,
      launchSuccess: launchSuccess,
      timestamp: now,
      createdAt: now,
    );

    try {
      final insertedEvent = await ReservationClickEvent.db.insertRow(
        session,
        event,
      );

      session.log(
        'Recorded reservation click: restaurant=$restaurantId, type=$linkType, success=$launchSuccess',
        level: LogLevel.info,
      );

      return insertedEvent.id!;
    } catch (e, stackTrace) {
      session.log(
        'Failed to record reservation click: $e\n$stackTrace',
        level: LogLevel.error,
      );
      rethrow;
    }
  }

  /// Get reservation click analytics for a restaurant.
  ///
  /// Returns the most recent click events for the specified restaurant.
  Future<List<ReservationClickEvent>> getClicksByRestaurant(
    Session session,
    int restaurantId, {
    int limit = 100,
  }) async {
    return ReservationClickEvent.db.find(
      session,
      where: (t) => t.restaurantId.equals(restaurantId),
      orderBy: (t) => t.timestamp,
      orderDescending: true,
      limit: limit,
    );
  }

  /// Get aggregated click counts for analytics dashboard.
  ///
  /// Returns click counts grouped by link type for a restaurant.
  Future<Map<String, int>> getClickCountsByType(
    Session session, {
    int? restaurantId,
  }) async {
    List<ReservationClickEvent> events;

    if (restaurantId != null) {
      events = await ReservationClickEvent.db.find(
        session,
        where: (t) => t.restaurantId.equals(restaurantId),
      );
    } else {
      events = await ReservationClickEvent.db.find(session);
    }

    // Group by link type and count
    final counts = <String, int>{};
    for (final event in events) {
      final type = event.linkType.name;
      counts[type] = (counts[type] ?? 0) + 1;
    }

    return counts;
  }
}
