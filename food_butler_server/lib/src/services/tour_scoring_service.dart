import 'dart:convert';
import 'dart:math';

import '../generated/protocol.dart';
import 'mapbox_service.dart';

/// Weight category for digestion scoring.
enum DishWeight {
  light,
  medium,
  heavy,
}

/// Scored restaurant with all metrics.
class ScoredRestaurant {
  final Restaurant restaurant;
  final List<Award> awards;
  final DishWeight dishWeight;
  final double baseScore;
  final double awardBoost;

  // Narrative fields from curated tour
  final String? story;
  final String? signatureDish;
  final String? dishStory;
  final String? insiderTip;
  final String? transitionToNext;
  final int? minutesToSpend;

  ScoredRestaurant({
    required this.restaurant,
    required this.awards,
    required this.dishWeight,
    required this.baseScore,
    required this.awardBoost,
    this.story,
    this.signatureDish,
    this.dishStory,
    this.insiderTip,
    this.transitionToNext,
    this.minutesToSpend,
  });

  double get totalScore => baseScore * awardBoost;
}

/// Result of tour scoring.
class TourScore {
  final double digestionScore;
  final double geographicScore;
  final double timingScore;
  final int confidenceScore;
  final String? warningMessage;

  TourScore({
    required this.digestionScore,
    required this.geographicScore,
    required this.timingScore,
    required this.confidenceScore,
    this.warningMessage,
  });
}

/// Service for scoring tour permutations.
class TourScoringService {
  // Scoring weights (equal by default)
  static const double _digestionWeight = 1.0 / 3.0;
  static const double _geographicWeight = 1.0 / 3.0;
  static const double _timingWeight = 1.0 / 3.0;

  // Award boost multipliers
  static const double _baseAwardBoost = 1.2;
  static const double _maxAwardBoost = 1.5;

  // Digestion gap settings (in minutes)
  static const int _minDigestionGapMinutes = 20;
  static const int _maxDigestionGapMinutes = 45;
  static const int _defaultVisitDurationMinutes = 30;

  // Cuisine type heuristics for dish weight when no dish data available
  // Sorted by key length (longest first) to prioritize specific matches
  static final List<MapEntry<String, DishWeight>> _cuisineWeightHeuristics = [
    // Heavy (longer/more specific first)
    const MapEntry('steakhouse', DishWeight.heavy),
    const MapEntry('barbecue', DishWeight.heavy),
    const MapEntry('italian', DishWeight.heavy),
    const MapEntry('mexican', DishWeight.heavy),
    const MapEntry('dessert', DishWeight.heavy),
    const MapEntry('indian', DishWeight.heavy),
    const MapEntry('burger', DishWeight.heavy),
    const MapEntry('pasta', DishWeight.heavy),
    const MapEntry('pizza', DishWeight.heavy),
    const MapEntry('bbq', DishWeight.heavy),
    // Medium
    const MapEntry('small plates', DishWeight.medium),
    const MapEntry('appetizer', DishWeight.medium),
    const MapEntry('sandwich', DishWeight.medium),
    const MapEntry('tapas', DishWeight.medium),
    const MapEntry('salad', DishWeight.medium),
    const MapEntry('sushi', DishWeight.medium),
    const MapEntry('poke', DishWeight.medium),
    // Light (shorter/less specific last)
    const MapEntry('smoothie', DishWeight.light),
    const MapEntry('coffee', DishWeight.light),
    const MapEntry('bakery', DishWeight.light),
    const MapEntry('pastry', DishWeight.light),
    const MapEntry('juice', DishWeight.light),
    const MapEntry('cafe', DishWeight.light),
    const MapEntry('tea', DishWeight.light),
  ];

  /// Calculate the overall score for a tour permutation.
  TourScore scoreTour({
    required List<ScoredRestaurant> stops,
    required List<RouteLeg> routeLegs,
    required DateTime startTime,
    required TransportMode transportMode,
  }) {
    if (stops.isEmpty) {
      return TourScore(
        digestionScore: 0,
        geographicScore: 0,
        timingScore: 0,
        confidenceScore: 0,
        warningMessage: 'No stops in tour',
      );
    }

    final digestionScore = calculateDigestionScore(stops);
    final geographicScore = calculateGeographicScore(routeLegs, transportMode);
    final timingScore = calculateTimingScore(stops, routeLegs, startTime);

    // Calculate weighted average
    final weightedScore = digestionScore * _digestionWeight +
        geographicScore * _geographicWeight +
        timingScore * _timingWeight;

    // Scale to 0-100
    final confidenceScore = (weightedScore * 100).round().clamp(0, 100);

    String? warning;
    if (confidenceScore < 50) {
      warning = 'Tour quality is low. Consider adjusting filters.';
    }

    return TourScore(
      digestionScore: digestionScore,
      geographicScore: geographicScore,
      timingScore: timingScore,
      confidenceScore: confidenceScore,
      warningMessage: warning,
    );
  }

  /// Calculate digestion score based on light-to-heavy progression.
  double calculateDigestionScore(List<ScoredRestaurant> stops) {
    if (stops.length < 2) return 1.0;

    var score = 1.0;
    var consecutivePenalties = 0;

    for (var i = 0; i < stops.length - 1; i++) {
      final currentWeight = stops[i].dishWeight;
      final nextWeight = stops[i + 1].dishWeight;

      // Check progression
      if (_isGoodProgression(currentWeight, nextWeight)) {
        // Good progression - reward
        score += 0.1;
      } else if (_isBadProgression(currentWeight, nextWeight)) {
        // Heavy to light - penalize
        score -= 0.2;
        consecutivePenalties++;
      }
      // Same weight is neutral (no change)
    }

    // Extra penalty for multiple consecutive bad progressions
    if (consecutivePenalties > 1) {
      score -= 0.1 * (consecutivePenalties - 1);
    }

    return score.clamp(0.0, 1.0);
  }

  /// Check if progression from current to next is good (light to heavier).
  bool _isGoodProgression(DishWeight current, DishWeight next) {
    if (current == DishWeight.light && next == DishWeight.medium) return true;
    if (current == DishWeight.light && next == DishWeight.heavy) return true;
    if (current == DishWeight.medium && next == DishWeight.heavy) return true;
    return false;
  }

  /// Check if progression from current to next is bad (heavy to lighter).
  bool _isBadProgression(DishWeight current, DishWeight next) {
    if (current == DishWeight.heavy && next == DishWeight.medium) return true;
    if (current == DishWeight.heavy && next == DishWeight.light) return true;
    if (current == DishWeight.medium && next == DishWeight.light) return true;
    return false;
  }

  /// Calculate geographic efficiency score.
  double calculateGeographicScore(
    List<RouteLeg> routeLegs,
    TransportMode transportMode,
  ) {
    if (routeLegs.isEmpty) return 1.0;

    // Calculate total travel time
    final totalTravelSeconds =
        routeLegs.fold<int>(0, (sum, leg) => sum + leg.durationSeconds);

    // Thresholds based on transport mode
    final idealMaxTravelMinutes = transportMode == TransportMode.walking
        ? 45 // 45 minutes max walking for a good tour
        : 30; // 30 minutes max driving

    final travelMinutes = totalTravelSeconds / 60;

    // Score based on how close we are to ideal
    if (travelMinutes <= idealMaxTravelMinutes) {
      return 1.0;
    }

    // Penalize linearly for excess travel time
    final excessMinutes = travelMinutes - idealMaxTravelMinutes;
    final penalty = excessMinutes / idealMaxTravelMinutes;

    return max(0.0, 1.0 - penalty);
  }

  /// Calculate timing score based on restaurant hours and pacing.
  double calculateTimingScore(
    List<ScoredRestaurant> stops,
    List<RouteLeg> routeLegs,
    DateTime startTime,
  ) {
    if (stops.isEmpty) return 1.0;

    var score = 1.0;
    var currentTime = startTime;

    for (var i = 0; i < stops.length; i++) {
      final stop = stops[i];

      // Check if restaurant is open at visit time
      if (!_isOpenAt(stop.restaurant, currentTime)) {
        score -= 0.3; // Significant penalty for closed restaurant
      }

      // Add visit duration
      currentTime = currentTime.add(
        Duration(minutes: _defaultVisitDurationMinutes),
      );

      // Add travel time to next stop (if not last)
      if (i < routeLegs.length) {
        currentTime = currentTime.add(
          Duration(seconds: routeLegs[i].durationSeconds),
        );

        // Check digestion gap
        final gapMinutes = routeLegs[i].durationSeconds / 60;
        if (gapMinutes < _minDigestionGapMinutes) {
          score -= 0.1; // Too rushed
        } else if (gapMinutes > _maxDigestionGapMinutes) {
          score -= 0.05; // Too long between stops
        }
      }
    }

    return max(0.0, min(1.0, score));
  }

  /// Check if restaurant is open at given time.
  bool _isOpenAt(Restaurant restaurant, DateTime time) {
    if (restaurant.hours == null) {
      // Assume open if no hours data
      return true;
    }

    try {
      final hoursData = jsonDecode(restaurant.hours!) as Map<String, dynamic>;

      // Check if there's a simple is_open flag
      if (hoursData['is_local_holiday'] == true) {
        return false;
      }

      // Try to parse regular hours
      final regular = hoursData['regular'] as List<dynamic>?;
      if (regular == null) return true;

      final dayOfWeek = time.weekday; // 1 = Monday, 7 = Sunday
      final timeMinutes = time.hour * 60 + time.minute;

      for (final period in regular) {
        final periodMap = period as Map<String, dynamic>;
        final day = periodMap['day'] as int?;

        // Foursquare uses 1 = Monday, 7 = Sunday (same as Dart)
        if (day == dayOfWeek) {
          final open = periodMap['open'] as String?;
          final close = periodMap['close'] as String?;

          if (open != null && close != null) {
            final openMinutes = _parseTimeToMinutes(open);
            final closeMinutes = _parseTimeToMinutes(close);

            if (timeMinutes >= openMinutes && timeMinutes <= closeMinutes) {
              return true;
            }
          }
        }
      }

      return false;
    } catch (e) {
      // If parsing fails, assume open
      return true;
    }
  }

  /// Parse time string (e.g., "0900" or "09:00") to minutes since midnight.
  int _parseTimeToMinutes(String time) {
    final cleaned = time.replaceAll(':', '');
    if (cleaned.length >= 4) {
      final hours = int.tryParse(cleaned.substring(0, 2)) ?? 0;
      final minutes = int.tryParse(cleaned.substring(2, 4)) ?? 0;
      return hours * 60 + minutes;
    }
    return 0;
  }

  /// Apply award boost to a restaurant score.
  double applyAwardBoost(List<Award> awards) {
    if (awards.isEmpty) return 1.0;

    var boost = 1.0;

    for (final award in awards) {
      // Base boost for any award
      boost += (_baseAwardBoost - 1.0);

      // Additional boost for high-tier awards
      if (award.awardLevel == 'winner' ||
          award.awardLevel == 'threeStar' ||
          award.awardLevel == 'twoStar') {
        boost += 0.1;
      }
    }

    return min(boost, _maxAwardBoost);
  }

  /// Calculate confidence score for a partial tour.
  int calculatePartialTourConfidence({
    required int requestedStops,
    required int actualStops,
    required TourScore baseScore,
  }) {
    // Reduce confidence based on how many stops are missing
    final completionRatio = actualStops / requestedStops;
    final adjustedScore = baseScore.confidenceScore * completionRatio;

    // Additional penalty for significant shortfall
    if (completionRatio < 0.5) {
      return (adjustedScore * 0.7).round().clamp(0, 100);
    }

    return adjustedScore.round().clamp(0, 100);
  }

  /// Classify a restaurant's dish weight.
  DishWeight classifyDishWeight(Restaurant restaurant) {
    // Try to use dish data first
    if (restaurant.dishData != null) {
      try {
        final dishData =
            jsonDecode(restaurant.dishData!) as Map<String, dynamic>;
        final tastes = dishData['tastes'] as List<dynamic>?;

        if (tastes != null) {
          // Check for light indicators
          if (tastes.any((t) =>
              t.toString().toLowerCase().contains('light') ||
              t.toString().toLowerCase().contains('fresh') ||
              t.toString().toLowerCase().contains('crisp'))) {
            return DishWeight.light;
          }

          // Check for heavy indicators
          if (tastes.any((t) =>
              t.toString().toLowerCase().contains('rich') ||
              t.toString().toLowerCase().contains('savory') ||
              t.toString().toLowerCase().contains('hearty'))) {
            return DishWeight.heavy;
          }
        }
      } catch (e) {
        // Fall through to heuristics
      }
    }

    // Fall back to cuisine type heuristics (sorted by specificity)
    for (final cuisineType in restaurant.cuisineTypes) {
      final normalized = cuisineType.toLowerCase();
      for (final entry in _cuisineWeightHeuristics) {
        if (normalized.contains(entry.key)) {
          return entry.value;
        }
      }
    }

    // Default to medium if no match
    return DishWeight.medium;
  }

  /// Estimate visit duration for a restaurant.
  int estimateVisitDuration(Restaurant restaurant, DishWeight weight) {
    // Base duration by weight
    switch (weight) {
      case DishWeight.light:
        return 20; // Quick stop
      case DishWeight.medium:
        return 30; // Standard visit
      case DishWeight.heavy:
        return 45; // Full meal
    }
  }
}
