import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Endpoint for managing saved/bookmarked restaurants.
class SavedRestaurantEndpoint extends Endpoint {
  /// Save a restaurant to the user's favorites.
  ///
  /// If the restaurant is already saved (by placeId), updates it instead.
  Future<SavedRestaurant> saveRestaurant(
    Session session, {
    required String name,
    String? placeId,
    String? address,
    String? cuisineType,
    String? imageUrl,
    double? rating,
    int? priceLevel,
    String? notes,
    int? userRating,
    required SavedRestaurantSource source,
  }) async {
    final authenticated = session.authenticated;
    if (authenticated == null) {
      throw Exception('User must be authenticated');
    }

    final userId = authenticated.userIdentifier.toString();
    final now = DateTime.now().toUtc();

    // Check if already saved (by placeId if available, otherwise by name)
    SavedRestaurant? existing;
    if (placeId != null) {
      existing = await SavedRestaurant.db.findFirstRow(
        session,
        where: (t) => t.userId.equals(userId) & t.placeId.equals(placeId),
      );
    }

    if (existing != null) {
      // Update existing
      final updated = existing.copyWith(
        name: name,
        address: address ?? existing.address,
        cuisineType: cuisineType ?? existing.cuisineType,
        imageUrl: imageUrl ?? existing.imageUrl,
        rating: rating ?? existing.rating,
        priceLevel: priceLevel ?? existing.priceLevel,
        notes: notes ?? existing.notes,
        userRating: userRating ?? existing.userRating,
      );
      return await SavedRestaurant.db.updateRow(session, updated);
    }

    // Create new
    final saved = SavedRestaurant(
      userId: userId,
      name: name,
      placeId: placeId,
      address: address,
      cuisineType: cuisineType,
      imageUrl: imageUrl,
      rating: rating,
      priceLevel: priceLevel,
      notes: notes,
      userRating: userRating,
      source: source,
      savedAt: now,
    );

    return await SavedRestaurant.db.insertRow(session, saved);
  }

  /// Remove a restaurant from favorites.
  Future<bool> unsaveRestaurant(
    Session session, {
    int? id,
    String? placeId,
  }) async {
    final authenticated = session.authenticated;
    if (authenticated == null) {
      throw Exception('User must be authenticated');
    }

    final userId = authenticated.userIdentifier.toString();

    if (id != null) {
      // Delete by ID
      final existing = await SavedRestaurant.db.findById(session, id);
      if (existing != null && existing.userId == userId) {
        await SavedRestaurant.db.deleteRow(session, existing);
        return true;
      }
    } else if (placeId != null) {
      // Delete by placeId
      final deleted = await SavedRestaurant.db.deleteWhere(
        session,
        where: (t) => t.userId.equals(userId) & t.placeId.equals(placeId),
      );
      return deleted.isNotEmpty;
    }

    return false;
  }

  /// Check if a restaurant is saved.
  Future<bool> isRestaurantSaved(
    Session session, {
    required String placeId,
  }) async {
    final authenticated = session.authenticated;
    if (authenticated == null) {
      return false;
    }

    final userId = authenticated.userIdentifier.toString();

    final existing = await SavedRestaurant.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId) & t.placeId.equals(placeId),
    );

    return existing != null;
  }

  /// Get all saved restaurants for the current user.
  Future<List<SavedRestaurant>> getSavedRestaurants(Session session) async {
    final authenticated = session.authenticated;
    if (authenticated == null) {
      throw Exception('User must be authenticated');
    }

    final userId = authenticated.userIdentifier.toString();

    return await SavedRestaurant.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      orderBy: (t) => t.savedAt,
      orderDescending: true,
    );
  }

  /// Update notes or user rating for a saved restaurant.
  Future<SavedRestaurant?> updateSavedRestaurant(
    Session session, {
    required int id,
    String? notes,
    int? userRating,
  }) async {
    final authenticated = session.authenticated;
    if (authenticated == null) {
      throw Exception('User must be authenticated');
    }

    final userId = authenticated.userIdentifier.toString();

    final existing = await SavedRestaurant.db.findById(session, id);
    if (existing == null || existing.userId != userId) {
      return null;
    }

    final updated = existing.copyWith(
      notes: notes ?? existing.notes,
      userRating: userRating ?? existing.userRating,
    );

    return await SavedRestaurant.db.updateRow(session, updated);
  }

  /// Get a single saved restaurant by ID.
  Future<SavedRestaurant?> getSavedRestaurant(
    Session session, {
    required int id,
  }) async {
    final authenticated = session.authenticated;
    if (authenticated == null) {
      throw Exception('User must be authenticated');
    }

    final userId = authenticated.userIdentifier.toString();

    final restaurant = await SavedRestaurant.db.findById(session, id);
    if (restaurant == null || restaurant.userId != userId) {
      return null;
    }

    return restaurant;
  }
}
