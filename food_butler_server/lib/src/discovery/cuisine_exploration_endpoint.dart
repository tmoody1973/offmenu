import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/google_places_service.dart';

/// Endpoint for cuisine exploration suggestions.
///
/// Suggests cuisines the user wants to try and finds nearby restaurants.
class CuisineExplorationEndpoint extends Endpoint {
  /// Get a cuisine exploration suggestion for the user.
  ///
  /// Returns a suggestion based on cuisines they want to try,
  /// with a nearby restaurant recommendation.
  Future<CuisineExplorationSuggestion?> getExplorationSuggestion(
    Session session, {
    required String cityName,
    String? stateOrRegion,
    double? latitude,
    double? longitude,
  }) async {
    final authenticated = session.authenticated;
    if (authenticated == null) {
      session.log('Exploration: User not authenticated');
      return null;
    }

    final userId = authenticated.userIdentifier.toString();

    // Get user profile
    final profile = await UserProfile.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );

    if (profile == null) {
      session.log('Exploration: No profile for user $userId');
      return null;
    }

    // Parse cuisines they want to try
    final wantToTry = profile.wantToTryCuisines;
    if (wantToTry == null || wantToTry.isEmpty) {
      session.log('Exploration: User has no cuisines to try');
      return null;
    }

    final cuisines = wantToTry
        .split(',')
        .map((c) => c.trim())
        .where((c) => c.isNotEmpty)
        .toList();

    if (cuisines.isEmpty) {
      return null;
    }

    // Pick a random cuisine
    final random = Random();
    final selectedCuisine = cuisines[random.nextInt(cuisines.length)];
    session.log('Exploration: Selected cuisine "$selectedCuisine" for user');

    // Build location string
    final location = stateOrRegion != null
        ? '$cityName, $stateOrRegion'
        : cityName;

    // Search for a nearby restaurant
    final googleApiKey = session.serverpod.getPassword('GOOGLE_PLACES_API_KEY');
    if (googleApiKey == null || googleApiKey.isEmpty) {
      // Return suggestion without restaurant details
      return CuisineExplorationSuggestion(
        cuisine: selectedCuisine,
        hookLine: 'Discover $selectedCuisine cuisine',
        ctaText: 'EXPLORE',
      );
    }

    final placesService = GooglePlacesService(
      apiKey: googleApiKey,
      session: session,
    );

    try {
      // Search for restaurants of this cuisine type
      final searchQuery = '$selectedCuisine restaurant $location';
      final placeResult = await placesService.searchAndGetDetails(searchQuery);

      if (placeResult != null) {
        final restaurantName = placeResult['name'] as String?;
        final address = placeResult['formatted_address'] as String?;
        final placeId = placeResult['place_id'] as String?;
        final rating = (placeResult['rating'] as num?)?.toDouble();

        // Get distance estimate if we have coordinates
        String? distanceText;
        if (latitude != null && longitude != null) {
          final geometry = placeResult['geometry'] as Map<String, dynamic>?;
          final location = geometry?['location'] as Map<String, dynamic>?;
          if (location != null) {
            final placeLat = (location['lat'] as num?)?.toDouble();
            final placeLng = (location['lng'] as num?)?.toDouble();
            if (placeLat != null && placeLng != null) {
              final distance = _calculateDistance(
                latitude, longitude, placeLat, placeLng,
              );
              // Estimate driving time (rough: ~2 min per mile in city)
              final minutes = (distance * 2).round();
              if (minutes <= 1) {
                distanceText = 'right around the corner';
              } else if (minutes < 60) {
                distanceText = '$minutes min away';
              }
            }
          }
        }

        // Build hook line
        String hookLine;
        if (restaurantName != null && distanceText != null) {
          hookLine = '$restaurantName is $distanceText.';
        } else if (restaurantName != null) {
          hookLine = '$restaurantName is waiting for you.';
        } else {
          hookLine = 'There\'s a great spot nearby.';
        }

        return CuisineExplorationSuggestion(
          cuisine: selectedCuisine,
          restaurantName: restaurantName,
          restaurantAddress: address,
          placeId: placeId,
          rating: rating,
          hookLine: hookLine,
          ctaText: 'SHOW ME',
        );
      }
    } catch (e) {
      session.log('Exploration: Error finding restaurant: $e');
    }

    // Fallback without restaurant
    return CuisineExplorationSuggestion(
      cuisine: selectedCuisine,
      hookLine: 'Discover something new.',
      ctaText: 'EXPLORE',
    );
  }

  /// Calculate distance in miles between two coordinates.
  double _calculateDistance(
    double lat1, double lon1,
    double lat2, double lon2,
  ) {
    const earthRadiusMiles = 3958.8;
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusMiles * c;
  }

  double _toRadians(double degrees) => degrees * pi / 180;
}
