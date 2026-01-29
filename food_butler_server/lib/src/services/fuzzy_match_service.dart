import 'dart:math';

import '../generated/protocol.dart';

/// Service for fuzzy matching restaurants to awards.
///
/// Provides string similarity matching with optional coordinate-based
/// validation for improved accuracy.
class FuzzyMatchService {
  /// Threshold for automatic match confirmation.
  static const double autoMatchThreshold = 0.9;

  /// Threshold for pending review (between this and autoMatchThreshold).
  static const double reviewThreshold = 0.7;

  /// Confidence boost for coordinates within 100m.
  static const double nearbyBoost = 0.1;

  /// Confidence boost for coordinates within 500m.
  static const double proximityBoost = 0.05;

  /// Distance in meters considered "nearby".
  static const double nearbyDistanceMeters = 100.0;

  /// Distance in meters considered "in proximity".
  static const double proximityDistanceMeters = 500.0;

  /// Calculate match confidence based on name and city comparison.
  ///
  /// Returns a confidence score between 0.0 and 1.0.
  double calculateMatchConfidence({
    required String awardName,
    required String awardCity,
    required String restaurantName,
    required String restaurantCity,
  }) {
    final normalizedAwardName = _normalizeString(awardName);
    final normalizedAwardCity = _normalizeString(awardCity);
    final normalizedRestaurantName = _normalizeString(restaurantName);
    final normalizedRestaurantCity = _normalizeString(restaurantCity);

    // Calculate name similarity (weighted 80%)
    final nameSimilarity = _calculateStringSimilarity(
      normalizedAwardName,
      normalizedRestaurantName,
    );

    // Calculate city similarity (weighted 20%)
    final citySimilarity = _calculateStringSimilarity(
      normalizedAwardCity,
      normalizedRestaurantCity,
    );

    // Combined weighted score
    final combinedScore = nameSimilarity * 0.8 + citySimilarity * 0.2;

    return combinedScore.clamp(0.0, 1.0);
  }

  /// Calculate match confidence with coordinate-based validation.
  ///
  /// Coordinates can boost confidence for ambiguous name matches.
  double calculateMatchConfidenceWithCoordinates({
    required String awardName,
    required String awardCity,
    required double? awardLatitude,
    required double? awardLongitude,
    required String restaurantName,
    required String restaurantCity,
    required double? restaurantLatitude,
    required double? restaurantLongitude,
  }) {
    // Start with base string matching confidence
    var confidence = calculateMatchConfidence(
      awardName: awardName,
      awardCity: awardCity,
      restaurantName: restaurantName,
      restaurantCity: restaurantCity,
    );

    // Apply coordinate boost if both sets of coordinates are available
    if (awardLatitude != null &&
        awardLongitude != null &&
        restaurantLatitude != null &&
        restaurantLongitude != null) {
      final distance = _calculateDistance(
        awardLatitude,
        awardLongitude,
        restaurantLatitude,
        restaurantLongitude,
      );

      if (distance <= nearbyDistanceMeters) {
        confidence += nearbyBoost;
      } else if (distance <= proximityDistanceMeters) {
        confidence += proximityBoost;
      }
    }

    return confidence.clamp(0.0, 1.0);
  }

  /// Determine the match status based on confidence score.
  ///
  /// Returns:
  /// - [MatchStatus.autoMatched] for confidence >= 0.9
  /// - [MatchStatus.pendingReview] for confidence 0.7-0.9
  /// - null for confidence < 0.7 (no match)
  MatchStatus? determineMatchStatus(double confidence) {
    if (confidence >= autoMatchThreshold) {
      return MatchStatus.autoMatched;
    } else if (confidence >= reviewThreshold) {
      return MatchStatus.pendingReview;
    }
    return null; // No match / unmatched
  }

  /// Batch match Michelin awards against restaurants.
  ///
  /// Returns a list of [RestaurantAwardLink] objects for successful matches.
  List<RestaurantAwardLink> batchMatchMichelinAwards({
    required List<MichelinAward> awards,
    required List<Restaurant> restaurants,
  }) {
    final links = <RestaurantAwardLink>[];
    final now = DateTime.now();

    for (final award in awards) {
      RestaurantAwardLink? bestMatch;
      var bestConfidence = 0.0;

      for (final restaurant in restaurants) {
        final city = _extractCity(restaurant.address);

        final confidence = calculateMatchConfidenceWithCoordinates(
          awardName: award.restaurantName,
          awardCity: award.city,
          awardLatitude: award.latitude,
          awardLongitude: award.longitude,
          restaurantName: restaurant.name,
          restaurantCity: city,
          restaurantLatitude: restaurant.latitude,
          restaurantLongitude: restaurant.longitude,
        );

        if (confidence > bestConfidence) {
          bestConfidence = confidence;
          final status = determineMatchStatus(confidence);

          if (status != null) {
            bestMatch = RestaurantAwardLink(
              restaurantId: restaurant.id ?? 0,
              awardType: AwardType.michelin,
              awardId: award.id ?? 0,
              matchConfidenceScore: confidence,
              matchStatus: status,
              createdAt: now,
              updatedAt: now,
            );
          }
        }
      }

      if (bestMatch != null) {
        links.add(bestMatch);
      }
    }

    return links;
  }

  /// Batch match James Beard awards against restaurants.
  ///
  /// Returns a list of [RestaurantAwardLink] objects for successful matches.
  List<RestaurantAwardLink> batchMatchJamesBeardAwards({
    required List<JamesBeardAward> awards,
    required List<Restaurant> restaurants,
  }) {
    final links = <RestaurantAwardLink>[];
    final now = DateTime.now();

    for (final award in awards) {
      RestaurantAwardLink? bestMatch;
      var bestConfidence = 0.0;

      for (final restaurant in restaurants) {
        final city = _extractCity(restaurant.address);

        final confidence = calculateMatchConfidence(
          awardName: award.name,
          awardCity: award.city,
          restaurantName: restaurant.name,
          restaurantCity: city,
        );

        if (confidence > bestConfidence) {
          bestConfidence = confidence;
          final status = determineMatchStatus(confidence);

          if (status != null) {
            bestMatch = RestaurantAwardLink(
              restaurantId: restaurant.id ?? 0,
              awardType: AwardType.jamesBeard,
              awardId: award.id ?? 0,
              matchConfidenceScore: confidence,
              matchStatus: status,
              createdAt: now,
              updatedAt: now,
            );
          }
        }
      }

      if (bestMatch != null) {
        links.add(bestMatch);
      }
    }

    return links;
  }

  /// Find the best matching restaurant for a Michelin award.
  MatchResult? findBestMichelinMatch({
    required MichelinAward award,
    required List<Restaurant> restaurants,
  }) {
    Restaurant? bestRestaurant;
    var bestConfidence = 0.0;

    for (final restaurant in restaurants) {
      final city = _extractCity(restaurant.address);

      final confidence = calculateMatchConfidenceWithCoordinates(
        awardName: award.restaurantName,
        awardCity: award.city,
        awardLatitude: award.latitude,
        awardLongitude: award.longitude,
        restaurantName: restaurant.name,
        restaurantCity: city,
        restaurantLatitude: restaurant.latitude,
        restaurantLongitude: restaurant.longitude,
      );

      if (confidence > bestConfidence) {
        bestConfidence = confidence;
        bestRestaurant = restaurant;
      }
    }

    if (bestRestaurant != null && bestConfidence >= reviewThreshold) {
      return MatchResult(
        restaurant: bestRestaurant,
        confidence: bestConfidence,
        status: determineMatchStatus(bestConfidence),
      );
    }

    return null;
  }

  /// Find the best matching restaurant for a James Beard award.
  MatchResult? findBestJamesBeardMatch({
    required JamesBeardAward award,
    required List<Restaurant> restaurants,
  }) {
    Restaurant? bestRestaurant;
    var bestConfidence = 0.0;

    for (final restaurant in restaurants) {
      final city = _extractCity(restaurant.address);

      final confidence = calculateMatchConfidence(
        awardName: award.name,
        awardCity: award.city,
        restaurantName: restaurant.name,
        restaurantCity: city,
      );

      if (confidence > bestConfidence) {
        bestConfidence = confidence;
        bestRestaurant = restaurant;
      }
    }

    if (bestRestaurant != null && bestConfidence >= reviewThreshold) {
      return MatchResult(
        restaurant: bestRestaurant,
        confidence: bestConfidence,
        status: determineMatchStatus(bestConfidence),
      );
    }

    return null;
  }

  /// Normalize a string for comparison.
  ///
  /// Converts to lowercase, removes punctuation, and normalizes whitespace.
  String _normalizeString(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r"['\u2019]"), '') // Remove apostrophes
        .replaceAll(RegExp(r'[^\w\s]'), '') // Remove other punctuation
        .replaceAll(RegExp(r'\s+'), ' ') // Normalize whitespace
        .replaceAll(RegExp(r'^the\s+'), '') // Remove leading "the"
        .trim();
  }

  /// Extract city from address string.
  ///
  /// Handles common US address formats:
  /// - "123 Main St, Chicago, IL" -> "Chicago"
  /// - "123 Main St, Chicago, IL 60601" -> "Chicago"
  /// - "Chicago, IL" -> "Chicago"
  String _extractCity(String address) {
    final parts = address.split(',').map((p) => p.trim()).toList();

    if (parts.length >= 3) {
      // Format: "Street, City, State" or "Street, City, State ZIP"
      // City is the second part (index 1)
      return parts[1].trim();
    } else if (parts.length == 2) {
      // Format: "City, State" - City is the first part
      return parts[0].trim();
    }

    return address.trim();
  }

  /// Calculate string similarity using Levenshtein distance.
  ///
  /// Returns a value between 0.0 (no similarity) and 1.0 (identical).
  double _calculateStringSimilarity(String a, String b) {
    if (a.isEmpty && b.isEmpty) return 1.0;
    if (a.isEmpty || b.isEmpty) return 0.0;

    final distance = _levenshteinDistance(a, b);
    final maxLength = max(a.length, b.length);

    return 1.0 - (distance / maxLength);
  }

  /// Calculate Levenshtein distance between two strings.
  int _levenshteinDistance(String a, String b) {
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    final matrix = List.generate(
      a.length + 1,
      (i) => List.generate(b.length + 1, (j) => 0),
    );

    for (var i = 0; i <= a.length; i++) {
      matrix[i][0] = i;
    }
    for (var j = 0; j <= b.length; j++) {
      matrix[0][j] = j;
    }

    for (var i = 1; i <= a.length; i++) {
      for (var j = 1; j <= b.length; j++) {
        final cost = a[i - 1] == b[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1, // deletion
          matrix[i][j - 1] + 1, // insertion
          matrix[i - 1][j - 1] + cost, // substitution
        ].reduce(min);
      }
    }

    return matrix[a.length][b.length];
  }

  /// Calculate distance between two coordinates using Haversine formula.
  ///
  /// Returns distance in meters.
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadiusMeters = 6371000.0;

    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusMeters * c;
  }

  /// Convert degrees to radians.
  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}

/// Result of a match attempt.
class MatchResult {
  final Restaurant restaurant;
  final double confidence;
  final MatchStatus? status;

  MatchResult({
    required this.restaurant,
    required this.confidence,
    this.status,
  });
}
