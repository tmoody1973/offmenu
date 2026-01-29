import 'dart:convert';
import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Result of matching a restaurant to awards.
class AwardMatchResult {
  final List<Award> awards;
  final double confidence;

  AwardMatchResult({
    required this.awards,
    required this.confidence,
  });
}

/// Service for matching restaurants to James Beard and Michelin awards.
class AwardMatchingService {
  static const double _matchThreshold = 0.75;
  static const double _awardBoostMultiplier = 1.2;
  static const double _maxAwardBoost = 1.5;

  final Session _session;

  // In-memory cache of award data for faster matching
  List<_AwardRecord>? _jamesBeardCache;
  List<_AwardRecord>? _michelinCache;

  AwardMatchingService({required Session session}) : _session = session;

  /// Load award data into memory cache.
  Future<void> loadAwardData() async {
    try {
      final awards = await Award.db.find(_session);

      _jamesBeardCache = awards
          .where((a) => a.awardType == AwardType.jamesBeard)
          .map((a) => _AwardRecord.fromAward(a))
          .toList();

      _michelinCache = awards
          .where((a) => a.awardType == AwardType.michelin)
          .map((a) => _AwardRecord.fromAward(a))
          .toList();

      _session.log(
        'Loaded ${_jamesBeardCache!.length} James Beard and ${_michelinCache!.length} Michelin awards',
        level: LogLevel.info,
      );
    } catch (e) {
      _session.log(
        'Error loading award data: $e',
        level: LogLevel.error,
      );
      _jamesBeardCache = [];
      _michelinCache = [];
    }
  }

  /// Match a restaurant to awards using fuzzy name matching.
  Future<AwardMatchResult> matchRestaurantToAwards(Restaurant restaurant) async {
    // Ensure cache is loaded
    if (_jamesBeardCache == null || _michelinCache == null) {
      await loadAwardData();
    }

    final matchedAwards = <Award>[];
    var totalConfidence = 0.0;
    var matchCount = 0;

    // Extract city from address
    final city = _extractCity(restaurant.address);

    // Match against James Beard awards
    final jamesBeardMatches = _findMatches(
      restaurantName: restaurant.name,
      city: city,
      awards: _jamesBeardCache!,
      awardType: AwardType.jamesBeard,
    );

    for (final match in jamesBeardMatches) {
      if (match.confidence >= _matchThreshold) {
        matchedAwards.add(match.award);
        totalConfidence += match.confidence;
        matchCount++;
      }
    }

    // Match against Michelin awards
    final michelinMatches = _findMatches(
      restaurantName: restaurant.name,
      city: city,
      awards: _michelinCache!,
      awardType: AwardType.michelin,
    );

    for (final match in michelinMatches) {
      if (match.confidence >= _matchThreshold) {
        matchedAwards.add(match.award);
        totalConfidence += match.confidence;
        matchCount++;
      }
    }

    final avgConfidence = matchCount > 0 ? totalConfidence / matchCount : 0.0;

    return AwardMatchResult(
      awards: matchedAwards,
      confidence: avgConfidence,
    );
  }

  /// Find matching awards using fuzzy name and location matching.
  List<_MatchResult> _findMatches({
    required String restaurantName,
    required String city,
    required List<_AwardRecord> awards,
    required AwardType awardType,
  }) {
    final matches = <_MatchResult>[];
    final normalizedName = _normalizeString(restaurantName);
    final normalizedCity = _normalizeString(city);

    for (final record in awards) {
      // Calculate name similarity
      final nameSimilarity = _calculateSimilarity(
        normalizedName,
        _normalizeString(record.restaurantName),
      );

      // Calculate location similarity (if city is available)
      var locationSimilarity = 1.0;
      if (record.city != null && city.isNotEmpty) {
        locationSimilarity = _calculateSimilarity(
          normalizedCity,
          _normalizeString(record.city!),
        );
      }

      // Combined score (weighted more heavily toward name)
      final combinedScore = nameSimilarity * 0.8 + locationSimilarity * 0.2;

      if (combinedScore >= _matchThreshold * 0.9) {
        matches.add(_MatchResult(
          award: Award(
            restaurantFsqId: record.restaurantFsqId ?? '',
            awardType: awardType,
            awardLevel: record.awardLevel,
            year: record.year,
            createdAt: DateTime.now(),
          ),
          confidence: combinedScore,
        ));
      }
    }

    // Sort by confidence and return top matches
    matches.sort((a, b) => b.confidence.compareTo(a.confidence));
    return matches.take(3).toList();
  }

  /// Calculate the award boost multiplier for a restaurant.
  double calculateAwardBoost(List<Award> awards) {
    if (awards.isEmpty) return 1.0;

    var boost = 1.0;

    for (final award in awards) {
      // Base boost for any award
      boost += (_awardBoostMultiplier - 1.0);

      // Additional boost for higher-tier awards
      if (award.awardLevel == 'winner' ||
          award.awardLevel == 'threeStar' ||
          award.awardLevel == 'twoStar') {
        boost += 0.1;
      }
    }

    return min(boost, _maxAwardBoost);
  }

  /// Get award badges for display.
  List<String> getAwardBadges(List<Award> awards) {
    return awards.map((a) {
      switch (a.awardType) {
        case AwardType.jamesBeard:
          return 'James Beard ${_formatAwardLevel(a.awardLevel)} ${a.year}';
        case AwardType.michelin:
          return 'Michelin ${_formatAwardLevel(a.awardLevel)} ${a.year}';
      }
    }).toList();
  }

  /// Format award level for display.
  String _formatAwardLevel(String level) {
    switch (level) {
      case 'winner':
        return 'Winner';
      case 'nominee':
        return 'Nominee';
      case 'semifinalist':
        return 'Semifinalist';
      case 'oneStar':
        return '1 Star';
      case 'twoStar':
        return '2 Stars';
      case 'threeStar':
        return '3 Stars';
      case 'bibGourmand':
        return 'Bib Gourmand';
      default:
        return level;
    }
  }

  /// Normalize a string for comparison.
  String _normalizeString(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '') // Remove punctuation
        .replaceAll(RegExp(r'\s+'), ' ') // Normalize whitespace
        .trim();
  }

  /// Extract city from address string.
  String _extractCity(String address) {
    final parts = address.split(',');
    if (parts.length >= 2) {
      // City is typically the second-to-last part
      return parts[parts.length - 2].trim();
    }
    return address;
  }

  /// Calculate Levenshtein distance-based similarity between two strings.
  double _calculateSimilarity(String a, String b) {
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

  /// Load James Beard data from JSON string.
  Future<int> loadJamesBeardData(String jsonData) async {
    try {
      final data = jsonDecode(jsonData) as List<dynamic>;
      var count = 0;

      for (final item in data) {
        final record = item as Map<String, dynamic>;
        await Award.db.insertRow(
          _session,
          Award(
            restaurantFsqId: '', // Will be matched later
            awardType: AwardType.jamesBeard,
            awardLevel: _parseJamesBeardLevel(record['award'] as String? ?? ''),
            year: record['year'] as int? ?? DateTime.now().year,
            createdAt: DateTime.now(),
          ),
        );
        count++;
      }

      // Refresh cache
      await loadAwardData();
      return count;
    } catch (e) {
      _session.log(
        'Error loading James Beard data: $e',
        level: LogLevel.error,
      );
      return 0;
    }
  }

  /// Load Michelin data from JSON string.
  Future<int> loadMichelinData(String jsonData) async {
    try {
      final data = jsonDecode(jsonData) as List<dynamic>;
      var count = 0;

      for (final item in data) {
        final record = item as Map<String, dynamic>;
        await Award.db.insertRow(
          _session,
          Award(
            restaurantFsqId: '', // Will be matched later
            awardType: AwardType.michelin,
            awardLevel: _parseMichelinLevel(record['stars'] as int? ?? 0),
            year: record['year'] as int? ?? DateTime.now().year,
            createdAt: DateTime.now(),
          ),
        );
        count++;
      }

      // Refresh cache
      await loadAwardData();
      return count;
    } catch (e) {
      _session.log(
        'Error loading Michelin data: $e',
        level: LogLevel.error,
      );
      return 0;
    }
  }

  /// Parse James Beard award level from string.
  String _parseJamesBeardLevel(String award) {
    final lower = award.toLowerCase();
    if (lower.contains('winner')) return 'winner';
    if (lower.contains('nominee')) return 'nominee';
    if (lower.contains('semifinalist')) return 'semifinalist';
    return 'nominee';
  }

  /// Parse Michelin level from star count.
  String _parseMichelinLevel(int stars) {
    switch (stars) {
      case 3:
        return 'threeStar';
      case 2:
        return 'twoStar';
      case 1:
        return 'oneStar';
      case 0:
        return 'bibGourmand';
      default:
        return 'oneStar';
    }
  }
}

/// Internal record for award matching.
class _AwardRecord {
  final String restaurantName;
  final String? city;
  final String? restaurantFsqId;
  final String awardLevel;
  final int year;

  _AwardRecord({
    required this.restaurantName,
    this.city,
    this.restaurantFsqId,
    required this.awardLevel,
    required this.year,
  });

  factory _AwardRecord.fromAward(Award award) {
    return _AwardRecord(
      restaurantName: '', // Will be populated from a join or lookup
      restaurantFsqId: award.restaurantFsqId,
      awardLevel: award.awardLevel,
      year: award.year,
    );
  }
}

/// Internal result of a match attempt.
class _MatchResult {
  final Award award;
  final double confidence;

  _MatchResult({
    required this.award,
    required this.confidence,
  });
}
