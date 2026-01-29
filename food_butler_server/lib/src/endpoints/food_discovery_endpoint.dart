import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/food_discovery_service.dart';

/// Endpoint for the AI food concierge - "Ask the Butler".
///
/// Handles free-form natural language food queries like:
/// - "Hidden gems in Capitol Hill for locals"
/// - "Best late night eats after a Mariners game"
/// - "Hole-in-the-wall taquerias tourists miss"
class FoodDiscoveryEndpoint extends Endpoint {
  /// Ask the Butler any food-related question.
  ///
  /// The AI will understand natural language queries and return
  /// curated restaurant recommendations with photos and map data.
  Future<FoodDiscoveryResponse> ask(
    Session session,
    String query,
  ) async {
    session.log('Food Discovery query: $query', level: LogLevel.info);

    final service = FoodDiscoveryService(session);
    final response = await service.discover(query);

    session.log(
      'Food Discovery found ${response.places.length} places',
      level: LogLevel.info,
    );

    return response;
  }
}
