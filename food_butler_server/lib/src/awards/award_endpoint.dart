import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Public API endpoint for querying award data.
///
/// Provides read-only access to award information for restaurants.
class AwardEndpoint extends Endpoint {
  /// Get all linked awards for a restaurant.
  ///
  /// Returns a list of awards associated with the restaurant identified by [restaurantId].
  Future<List<Map<String, dynamic>>> getRestaurantAwards(
    Session session,
    int restaurantId,
  ) async {
    final awards = <Map<String, dynamic>>[];

    // Get all links for this restaurant
    final links = await RestaurantAwardLink.db.find(
      session,
      where: (t) => t.restaurantId.equals(restaurantId) &
          (t.matchStatus.equals(MatchStatus.autoMatched) |
           t.matchStatus.equals(MatchStatus.manualConfirmed)),
    );

    for (final link in links) {
      if (link.awardType == AwardType.michelin) {
        final award = await MichelinAward.db.findById(session, link.awardId);
        if (award != null) {
          awards.add({
            'type': 'michelin',
            'designation': award.designation.name,
            'year': award.awardYear,
            'restaurantName': award.restaurantName,
            'city': award.city,
          });
        }
      } else if (link.awardType == AwardType.jamesBeard) {
        final award = await JamesBeardAward.db.findById(session, link.awardId);
        if (award != null) {
          awards.add({
            'type': 'jamesBeard',
            'category': award.category,
            'distinctionLevel': award.distinctionLevel.name,
            'year': award.awardYear,
            'name': award.name,
            'city': award.city,
          });
        }
      }
    }

    return awards;
  }

  /// List Michelin awards with optional filters.
  ///
  /// Filters:
  /// - [city]: Filter by city name (case-insensitive partial match)
  /// - [designation]: Filter by designation type
  /// - [year]: Filter by award year
  /// - [limit]: Maximum number of results (default 50)
  /// - [offset]: Number of results to skip for pagination
  Future<List<MichelinAward>> getMichelinAwards(
    Session session, {
    String? city,
    MichelinDesignation? designation,
    int? year,
    int limit = 50,
    int offset = 0,
  }) async {
    return await MichelinAward.db.find(
      session,
      where: (t) {
        var condition = t.id.notEquals(0); // Always true condition

        if (city != null && city.isNotEmpty) {
          condition = condition & t.city.ilike('%$city%');
        }
        if (designation != null) {
          condition = condition & t.designation.equals(designation);
        }
        if (year != null) {
          condition = condition & t.awardYear.equals(year);
        }

        return condition;
      },
      limit: limit,
      offset: offset,
      orderBy: (t) => t.awardYear,
      orderDescending: true,
    );
  }

  /// List James Beard awards with optional filters.
  ///
  /// Filters:
  /// - [city]: Filter by city name (case-insensitive partial match)
  /// - [category]: Filter by award category
  /// - [distinctionLevel]: Filter by distinction level (winner, nominee, semifinalist)
  /// - [year]: Filter by award year
  /// - [limit]: Maximum number of results (default 50)
  /// - [offset]: Number of results to skip for pagination
  Future<List<JamesBeardAward>> getJamesBeardAwards(
    Session session, {
    String? city,
    String? category,
    JamesBeardDistinction? distinctionLevel,
    int? year,
    int limit = 50,
    int offset = 0,
  }) async {
    return await JamesBeardAward.db.find(
      session,
      where: (t) {
        var condition = t.id.notEquals(0); // Always true condition

        if (city != null && city.isNotEmpty) {
          condition = condition & t.city.ilike('%$city%');
        }
        if (category != null && category.isNotEmpty) {
          condition = condition & t.category.ilike('%$category%');
        }
        if (distinctionLevel != null) {
          condition = condition & t.distinctionLevel.equals(distinctionLevel);
        }
        if (year != null) {
          condition = condition & t.awardYear.equals(year);
        }

        return condition;
      },
      limit: limit,
      offset: offset,
      orderBy: (t) => t.awardYear,
      orderDescending: true,
    );
  }

  /// Calculate award score for a restaurant.
  ///
  /// Scoring:
  /// - Michelin: 3-star=100, 2-star=70, 1-star=50, Bib Gourmand=30
  /// - James Beard: Winner=50, Nominee=30, Semifinalist=15
  /// - Recent awards (last 2 years) get 1.5x multiplier
  /// - Multiple awards compound with diminishing returns (sqrt scaling)
  Future<double> calculateRestaurantAwardScore(
    Session session,
    int restaurantId,
  ) async {
    final currentYear = DateTime.now().year;

    // Get all confirmed links for this restaurant
    final links = await RestaurantAwardLink.db.find(
      session,
      where: (t) => t.restaurantId.equals(restaurantId) &
          (t.matchStatus.equals(MatchStatus.autoMatched) |
           t.matchStatus.equals(MatchStatus.manualConfirmed)),
    );

    if (links.isEmpty) return 0.0;

    var totalScore = 0.0;
    var awardCount = 0;

    for (final link in links) {
      double baseScore = 0.0;
      int awardYear = currentYear;

      if (link.awardType == AwardType.michelin) {
        final award = await MichelinAward.db.findById(session, link.awardId);
        if (award != null) {
          awardYear = award.awardYear;
          baseScore = _getMichelinScore(award.designation);
        }
      } else if (link.awardType == AwardType.jamesBeard) {
        final award = await JamesBeardAward.db.findById(session, link.awardId);
        if (award != null) {
          awardYear = award.awardYear;
          baseScore = _getJamesBeardScore(award.distinctionLevel);
        }
      }

      // Apply recency multiplier
      if (currentYear - awardYear <= 2) {
        baseScore *= 1.5;
      }

      // Apply diminishing returns via sqrt scaling
      awardCount++;
      totalScore += baseScore / sqrt(awardCount);
    }

    return totalScore;
  }

  /// Get Michelin score based on designation.
  double _getMichelinScore(MichelinDesignation designation) {
    switch (designation) {
      case MichelinDesignation.threeStar:
        return 100.0;
      case MichelinDesignation.twoStar:
        return 70.0;
      case MichelinDesignation.oneStar:
        return 50.0;
      case MichelinDesignation.bibGourmand:
        return 30.0;
    }
  }

  /// Get James Beard score based on distinction level.
  double _getJamesBeardScore(JamesBeardDistinction distinction) {
    switch (distinction) {
      case JamesBeardDistinction.winner:
        return 50.0;
      case JamesBeardDistinction.nominee:
        return 30.0;
      case JamesBeardDistinction.semifinalist:
        return 15.0;
    }
  }
}
