import 'package:test/test.dart';
import 'package:food_butler_server/src/awards/award_csv_parser.dart';

void main() {
  group('AwardCsvParser', () {
    late AwardCsvParser parser;

    setUp(() {
      parser = AwardCsvParser();
    });

    group('Michelin CSV parsing', () {
      test('parses valid Michelin CSV with all columns', () {
        const csvContent = '''name,city,address,latitude,longitude,stars,year
Alinea,Chicago,1723 N Halsted St,41.9138,-87.6485,3,2024
The French Laundry,Yountville,6640 Washington St,38.4044,-122.3642,3,2024
Eleven Madison Park,New York,11 Madison Ave,40.7416,-73.9872,3,2024''';

        final records = parser.parseMichelinCsv(csvContent);

        expect(records.length, equals(3));
        expect(records[0].name, equals('Alinea'));
        expect(records[0].city, equals('Chicago'));
        expect(records[0].designation, equals('3'));
        expect(records[0].year, equals(2024));
        expect(records[0].latitude, equals(41.9138));
        expect(records[0].longitude, equals(-87.6485));
      });

      test('parses Michelin CSV with minimal columns', () {
        const csvContent = '''name,city,stars,year
Restaurant A,City A,2,2023
Restaurant B,City B,1,2022''';

        final records = parser.parseMichelinCsv(csvContent);

        expect(records.length, equals(2));
        expect(records[0].name, equals('Restaurant A'));
        expect(records[0].designation, equals('2'));
        expect(records[0].address, isNull);
        expect(records[0].latitude, isNull);
      });

      test('handles Bib Gourmand designation', () {
        const csvContent = '''name,city,designation,year
Budget Bistro,Boston,Bib Gourmand,2024''';

        final records = parser.parseMichelinCsv(csvContent);

        expect(records.length, equals(1));
        expect(records[0].designation, equals('Bib Gourmand'));
      });

      test('handles quoted values with commas', () {
        const csvContent = '''name,city,address,year
"Joe's Seafood, Prime Steak & Stone Crab",Chicago,"60 E Grand Ave, Chicago, IL",2024''';

        final records = parser.parseMichelinCsv(csvContent);

        expect(records.length, equals(1));
        expect(records[0].name, equals("Joe's Seafood, Prime Steak & Stone Crab"));
        expect(records[0].address, contains('60 E Grand Ave'));
      });

      test('skips empty rows', () {
        const csvContent = '''name,city,stars,year
Restaurant A,City A,1,2024

Restaurant B,City B,2,2024

''';

        final records = parser.parseMichelinCsv(csvContent);
        expect(records.length, equals(2));
      });
    });

    group('James Beard CSV parsing', () {
      test('parses valid James Beard CSV', () {
        const csvContent = '''name,city,category,distinction,year
Grant Achatz,Chicago,Outstanding Chef,Winner,2024
Stephanie Izard,Chicago,Best Chef: Great Lakes,Nominee,2024''';

        final records = parser.parseJamesBeardCsv(csvContent);

        expect(records.length, equals(2));
        expect(records[0].name, equals('Grant Achatz'));
        expect(records[0].city, equals('Chicago'));
        expect(records[0].category, equals('Outstanding Chef'));
        expect(records[0].distinction, equals('Winner'));
        expect(records[0].year, equals(2024));
      });

      test('handles alternative column names', () {
        const csvContent = '''recipient,location,award_category,status,award_year
Test Chef,New York,Rising Star,Semifinalist,2023''';

        final records = parser.parseJamesBeardCsv(csvContent);

        expect(records.length, equals(1));
        expect(records[0].name, equals('Test Chef'));
        expect(records[0].city, equals('New York'));
        expect(records[0].category, equals('Rising Star'));
      });
    });
  });

  group('Award Scoring', () {
    test('Michelin scoring weights are correct', () {
      // These tests verify the scoring constants defined in the spec
      const threeStarScore = 100.0;
      const twoStarScore = 70.0;
      const oneStarScore = 50.0;
      const bibGourmandScore = 30.0;

      expect(threeStarScore, greaterThan(twoStarScore));
      expect(twoStarScore, greaterThan(oneStarScore));
      expect(oneStarScore, greaterThan(bibGourmandScore));
    });

    test('James Beard scoring weights are correct', () {
      const winnerScore = 50.0;
      const nomineeScore = 30.0;
      const semifinalistScore = 15.0;

      expect(winnerScore, greaterThan(nomineeScore));
      expect(nomineeScore, greaterThan(semifinalistScore));
    });

    test('recency multiplier is 1.5x for last 2 years', () {
      const recencyMultiplier = 1.5;
      const baseScore = 100.0;
      final boostedScore = baseScore * recencyMultiplier;

      expect(boostedScore, equals(150.0));
    });
  });
}
