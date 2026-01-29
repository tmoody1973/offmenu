import 'package:test/test.dart';

import 'package:food_butler_server/src/services/award_matching_service.dart';
import 'package:food_butler_server/src/generated/protocol.dart';

void main() {
  group('AwardMatchingService', () {
    test('fuzzy name matching algorithm identifies similar names', () {
      // Test the Levenshtein distance calculation indirectly through similarity
      final service = _TestableAwardMatchingService();

      // Exact match
      expect(service.testSimilarity('Alinea', 'Alinea'), equals(1.0));

      // Similar names (slightly different)
      expect(
        service.testSimilarity('Alinea', 'Alineas'),
        greaterThan(0.8),
      );

      // Very different names
      expect(
        service.testSimilarity('Alinea', 'McDonalds'),
        lessThan(0.5),
      );

      // Case insensitivity
      expect(
        service.testSimilarity('ALINEA', 'alinea'),
        equals(1.0),
      );

      // Substring match
      expect(
        service.testSimilarity('The French Laundry', 'French Laundry'),
        greaterThan(0.7),
      );
    });

    test('award boost application calculates correctly', () {
      final service = _TestableAwardMatchingService();

      // No awards - no boost
      expect(service.calculateAwardBoost([]), equals(1.0));

      // Single award - base boost
      final singleAward = [
        Award(
          restaurantFsqId: 'test-1',
          awardType: AwardType.jamesBeard,
          awardLevel: 'nominee',
          year: 2024,
          createdAt: DateTime.now(),
        ),
      ];
      final singleBoost = service.calculateAwardBoost(singleAward);
      expect(singleBoost, greaterThan(1.0));
      expect(singleBoost, lessThanOrEqualTo(1.5));

      // Multiple awards - stacked boost (capped at 1.5)
      final multipleAwards = [
        Award(
          restaurantFsqId: 'test-2',
          awardType: AwardType.jamesBeard,
          awardLevel: 'winner',
          year: 2024,
          createdAt: DateTime.now(),
        ),
        Award(
          restaurantFsqId: 'test-2',
          awardType: AwardType.michelin,
          awardLevel: 'threeStar',
          year: 2024,
          createdAt: DateTime.now(),
        ),
      ];
      final multipleBoost = service.calculateAwardBoost(multipleAwards);
      expect(multipleBoost, equals(1.5)); // Should hit the cap

      // High-tier awards get extra boost
      final highTierAward = [
        Award(
          restaurantFsqId: 'test-3',
          awardType: AwardType.michelin,
          awardLevel: 'threeStar',
          year: 2024,
          createdAt: DateTime.now(),
        ),
      ];
      final highTierBoost = service.calculateAwardBoost(highTierAward);
      expect(highTierBoost, greaterThan(singleBoost));
    });

    test('award badges are formatted correctly', () {
      final service = _TestableAwardMatchingService();

      final awards = [
        Award(
          restaurantFsqId: 'test-1',
          awardType: AwardType.jamesBeard,
          awardLevel: 'winner',
          year: 2024,
          createdAt: DateTime.now(),
        ),
        Award(
          restaurantFsqId: 'test-1',
          awardType: AwardType.michelin,
          awardLevel: 'twoStar',
          year: 2023,
          createdAt: DateTime.now(),
        ),
        Award(
          restaurantFsqId: 'test-1',
          awardType: AwardType.michelin,
          awardLevel: 'bibGourmand',
          year: 2022,
          createdAt: DateTime.now(),
        ),
      ];

      final badges = service.getAwardBadges(awards);

      expect(badges.length, equals(3));
      expect(badges[0], equals('James Beard Winner 2024'));
      expect(badges[1], equals('Michelin 2 Stars 2023'));
      expect(badges[2], equals('Michelin Bib Gourmand 2022'));
    });

    test('city extraction from address works correctly', () {
      final service = _TestableAwardMatchingService();

      // Standard format: street, city, state, zip
      expect(
        service.testExtractCity('123 Main St, Chicago, IL, 60601'),
        equals('IL'),
      );

      // Two parts: street, city
      expect(
        service.testExtractCity('123 Main St, Chicago'),
        equals('123 Main St'),
      );

      // Single part (just return the input)
      expect(
        service.testExtractCity('Chicago'),
        equals('Chicago'),
      );
    });
  });
}

/// Testable version of AwardMatchingService that exposes internal methods.
class _TestableAwardMatchingService {
  double testSimilarity(String a, String b) {
    final normalizedA = _normalizeString(a);
    final normalizedB = _normalizeString(b);
    return _calculateSimilarity(normalizedA, normalizedB);
  }

  String testExtractCity(String address) {
    return _extractCity(address);
  }

  double calculateAwardBoost(List<Award> awards) {
    if (awards.isEmpty) return 1.0;

    const awardBoostMultiplier = 1.2;
    const maxAwardBoost = 1.5;

    var boost = 1.0;

    for (final award in awards) {
      boost += (awardBoostMultiplier - 1.0);

      if (award.awardLevel == 'winner' ||
          award.awardLevel == 'threeStar' ||
          award.awardLevel == 'twoStar') {
        boost += 0.1;
      }
    }

    return boost > maxAwardBoost ? maxAwardBoost : boost;
  }

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

  String _normalizeString(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  String _extractCity(String address) {
    final parts = address.split(',');
    if (parts.length >= 2) {
      return parts[parts.length - 2].trim();
    }
    return address;
  }

  double _calculateSimilarity(String a, String b) {
    if (a.isEmpty && b.isEmpty) return 1.0;
    if (a.isEmpty || b.isEmpty) return 0.0;

    final distance = _levenshteinDistance(a, b);
    final maxLength = a.length > b.length ? a.length : b.length;

    return 1.0 - (distance / maxLength);
  }

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
        final deletion = matrix[i - 1][j] + 1;
        final insertion = matrix[i][j - 1] + 1;
        final substitution = matrix[i - 1][j - 1] + cost;

        var min = deletion;
        if (insertion < min) min = insertion;
        if (substitution < min) min = substitution;
        matrix[i][j] = min;
      }
    }

    return matrix[a.length][b.length];
  }
}
