import 'package:test/test.dart';
import 'package:food_butler_server/src/generated/protocol.dart';

void main() {
  group('Award Models', () {
    group('MichelinAward model', () {
      test('validates required fields are present', () {
        final now = DateTime.now();
        final award = MichelinAward(
          restaurantName: 'Alinea',
          city: 'Chicago',
          designation: MichelinDesignation.threeStar,
          awardYear: 2024,
          createdAt: now,
          updatedAt: now,
        );

        expect(award.restaurantName, equals('Alinea'));
        expect(award.city, equals('Chicago'));
        expect(award.designation, equals(MichelinDesignation.threeStar));
        expect(award.awardYear, equals(2024));
        expect(award.createdAt, equals(now));
        expect(award.updatedAt, equals(now));
      });

      test('supports optional address and coordinates', () {
        final now = DateTime.now();
        final awardWithLocation = MichelinAward(
          restaurantName: 'The French Laundry',
          city: 'Yountville',
          address: '6640 Washington St',
          latitude: 38.4044,
          longitude: -122.3642,
          designation: MichelinDesignation.threeStar,
          awardYear: 2024,
          createdAt: now,
          updatedAt: now,
        );

        expect(awardWithLocation.address, equals('6640 Washington St'));
        expect(awardWithLocation.latitude, equals(38.4044));
        expect(awardWithLocation.longitude, equals(-122.3642));

        final awardWithoutLocation = MichelinAward(
          restaurantName: 'Test Restaurant',
          city: 'Test City',
          designation: MichelinDesignation.oneStar,
          awardYear: 2023,
          createdAt: now,
          updatedAt: now,
        );

        expect(awardWithoutLocation.address, isNull);
        expect(awardWithoutLocation.latitude, isNull);
        expect(awardWithoutLocation.longitude, isNull);
      });

      test('supports all Michelin designation types', () {
        expect(MichelinDesignation.values, hasLength(4));
        expect(MichelinDesignation.values, contains(MichelinDesignation.oneStar));
        expect(MichelinDesignation.values, contains(MichelinDesignation.twoStar));
        expect(MichelinDesignation.values, contains(MichelinDesignation.threeStar));
        expect(MichelinDesignation.values, contains(MichelinDesignation.bibGourmand));
      });
    });

    group('JamesBeardAward model', () {
      test('validates required fields are present', () {
        final now = DateTime.now();
        final award = JamesBeardAward(
          name: 'Grant Achatz',
          city: 'Chicago',
          category: 'Outstanding Chef',
          distinctionLevel: JamesBeardDistinction.winner,
          awardYear: 2024,
          createdAt: now,
          updatedAt: now,
        );

        expect(award.name, equals('Grant Achatz'));
        expect(award.city, equals('Chicago'));
        expect(award.category, equals('Outstanding Chef'));
        expect(award.distinctionLevel, equals(JamesBeardDistinction.winner));
        expect(award.awardYear, equals(2024));
      });

      test('supports all James Beard distinction levels', () {
        expect(JamesBeardDistinction.values, hasLength(3));
        expect(JamesBeardDistinction.values, contains(JamesBeardDistinction.winner));
        expect(JamesBeardDistinction.values, contains(JamesBeardDistinction.nominee));
        expect(JamesBeardDistinction.values, contains(JamesBeardDistinction.semifinalist));
      });

      test('accepts any category string for flexibility', () {
        final now = DateTime.now();

        final categories = [
          'Outstanding Chef',
          'Best Chef: Great Lakes',
          'Outstanding Restaurant',
          'Rising Star Chef',
          'Outstanding Pastry Chef',
          'Best New Restaurant',
        ];

        for (final category in categories) {
          final award = JamesBeardAward(
            name: 'Test Chef',
            city: 'Test City',
            category: category,
            distinctionLevel: JamesBeardDistinction.nominee,
            awardYear: 2024,
            createdAt: now,
            updatedAt: now,
          );
          expect(award.category, equals(category));
        }
      });
    });

    group('RestaurantAwardLink model', () {
      test('validates association and confidence score', () {
        final now = DateTime.now();
        final link = RestaurantAwardLink(
          restaurantId: 123,
          awardType: AwardType.michelin,
          awardId: 456,
          matchConfidenceScore: 0.95,
          matchStatus: MatchStatus.autoMatched,
          createdAt: now,
          updatedAt: now,
        );

        expect(link.restaurantId, equals(123));
        expect(link.awardType, equals(AwardType.michelin));
        expect(link.awardId, equals(456));
        expect(link.matchConfidenceScore, equals(0.95));
        expect(link.matchStatus, equals(MatchStatus.autoMatched));
      });

      test('supports all match status values', () {
        expect(MatchStatus.values, hasLength(4));
        expect(MatchStatus.values, contains(MatchStatus.autoMatched));
        expect(MatchStatus.values, contains(MatchStatus.manualConfirmed));
        expect(MatchStatus.values, contains(MatchStatus.manualRejected));
        expect(MatchStatus.values, contains(MatchStatus.pendingReview));
      });

      test('allows nullable matchedByUserId for auto matches', () {
        final now = DateTime.now();

        final autoMatch = RestaurantAwardLink(
          restaurantId: 1,
          awardType: AwardType.jamesBeard,
          awardId: 1,
          matchConfidenceScore: 0.92,
          matchStatus: MatchStatus.autoMatched,
          createdAt: now,
          updatedAt: now,
        );
        expect(autoMatch.matchedByUserId, isNull);

        final manualMatch = RestaurantAwardLink(
          restaurantId: 2,
          awardType: AwardType.michelin,
          awardId: 2,
          matchConfidenceScore: 0.75,
          matchStatus: MatchStatus.manualConfirmed,
          matchedByUserId: 99,
          createdAt: now,
          updatedAt: now,
        );
        expect(manualMatch.matchedByUserId, equals(99));
      });
    });

    group('AwardImportLog model', () {
      test('tracks import statistics correctly', () {
        final now = DateTime.now();
        final log = AwardImportLog(
          importType: AwardType.michelin,
          fileName: 'michelin_2024.csv',
          recordsImported: 500,
          recordsMatched: 450,
          recordsPendingReview: 50,
          importedByUserId: 1,
          createdAt: now,
        );

        expect(log.importType, equals(AwardType.michelin));
        expect(log.fileName, equals('michelin_2024.csv'));
        expect(log.recordsImported, equals(500));
        expect(log.recordsMatched, equals(450));
        expect(log.recordsPendingReview, equals(50));
        expect(log.importedByUserId, equals(1));
      });
    });
  });
}
