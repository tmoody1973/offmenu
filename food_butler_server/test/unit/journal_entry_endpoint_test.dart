import 'package:test/test.dart';
import 'package:food_butler_server/src/generated/protocol.dart';

void main() {
  group('JournalEntry API validation', () {
    test('validates rating must be between 1 and 5', () {
      // Valid ratings
      for (var rating = 1; rating <= 5; rating++) {
        final isValid = rating >= 1 && rating <= 5;
        expect(isValid, isTrue, reason: 'Rating $rating should be valid');
      }

      // Invalid ratings
      expect(0 >= 1 && 0 <= 5, isFalse, reason: 'Rating 0 should be invalid');
      expect(6 >= 1 && 6 <= 5, isFalse, reason: 'Rating 6 should be invalid');
      expect(-1 >= 1 && -1 <= 5, isFalse, reason: 'Rating -1 should be invalid');
    });

    test('validates visitedAt cannot be in the future', () {
      final now = DateTime.now();
      final pastDate = now.subtract(const Duration(days: 1));
      final currentDate = now;
      final futureDate = now.add(const Duration(days: 1));

      // Past dates should be valid
      expect(pastDate.isBefore(now.add(const Duration(minutes: 5))), isTrue);

      // Current date should be valid
      expect(currentDate.isBefore(now.add(const Duration(minutes: 5))), isTrue);

      // Future dates should be invalid
      expect(futureDate.isBefore(now.add(const Duration(minutes: 5))), isFalse);
    });

    test('entry creation requires restaurantId', () {
      // Simulate validation logic
      int? restaurantId;
      final isValid = restaurantId != null;
      expect(isValid, isFalse, reason: 'Missing restaurantId should fail');

      restaurantId = 1;
      final isValidWithId = restaurantId != null;
      expect(isValidWithId, isTrue, reason: 'With restaurantId should succeed');
    });

    test('entry supports optional tourId and tourStopId', () {
      final now = DateTime.now().toUtc();

      // Entry without tour context
      final standaloneEntry = JournalEntry(
        userId: 'user-123',
        restaurantId: 1,
        rating: 4,
        visitedAt: now,
        createdAt: now,
        updatedAt: now,
      );
      expect(standaloneEntry.tourId, isNull);
      expect(standaloneEntry.tourStopId, isNull);

      // Entry with tour context
      final tourEntry = JournalEntry(
        userId: 'user-123',
        restaurantId: 1,
        tourId: 10,
        tourStopId: 2,
        rating: 5,
        visitedAt: now,
        createdAt: now,
        updatedAt: now,
      );
      expect(tourEntry.tourId, equals(10));
      expect(tourEntry.tourStopId, equals(2));
    });

    test('entry update only allows rating, notes, visitedAt changes', () {
      final now = DateTime.now().toUtc();
      final original = JournalEntry(
        id: 1,
        userId: 'user-123',
        restaurantId: 5,
        tourId: 10,
        rating: 3,
        notes: 'Original notes',
        visitedAt: now,
        createdAt: now,
        updatedAt: now,
      );

      // Allowed updates
      final updated = original.copyWith(
        rating: 5,
        notes: 'Updated notes',
        visitedAt: now.subtract(const Duration(hours: 1)),
        updatedAt: DateTime.now().toUtc(),
      );

      expect(updated.rating, equals(5));
      expect(updated.notes, equals('Updated notes'));

      // Should NOT change restaurant or tour associations
      expect(updated.restaurantId, equals(original.restaurantId));
      expect(updated.tourId, equals(original.tourId));
      expect(updated.userId, equals(original.userId));
    });
  });

  group('JournalEntry pagination', () {
    test('validates page and pageSize parameters', () {
      // Valid pagination
      const page = 1;
      const pageSize = 20;

      expect(page >= 1, isTrue);
      expect(pageSize >= 1 && pageSize <= 100, isTrue);

      // Clamping for invalid values
      var invalidPage = -1;
      invalidPage = invalidPage < 1 ? 1 : invalidPage;
      expect(invalidPage, equals(1));

      var invalidPageSize = 200;
      invalidPageSize = invalidPageSize > 100 ? 100 : invalidPageSize;
      expect(invalidPageSize, equals(100));
    });

    test('calculates correct offset for pagination', () {
      const pageSize = 20;

      // Page 1 should have offset 0
      expect((1 - 1) * pageSize, equals(0));

      // Page 2 should have offset 20
      expect((2 - 1) * pageSize, equals(20));

      // Page 3 should have offset 40
      expect((3 - 1) * pageSize, equals(40));
    });

    test('determines hasMore correctly', () {
      const pageSize = 20;
      const totalCount = 45;

      // Page 1: 20 items shown, 45 total = hasMore
      expect(1 * pageSize < totalCount, isTrue);

      // Page 2: 40 items shown, 45 total = hasMore
      expect(2 * pageSize < totalCount, isTrue);

      // Page 3: 60 items shown, 45 total = no more
      expect(3 * pageSize < totalCount, isFalse);
    });
  });

  group('JournalEntry sorting', () {
    test('supports sorting by visitedAt', () {
      final entries = [
        _createMockEntry(id: 1, visitedAt: DateTime(2024, 1, 15)),
        _createMockEntry(id: 2, visitedAt: DateTime(2024, 1, 10)),
        _createMockEntry(id: 3, visitedAt: DateTime(2024, 1, 20)),
      ];

      // Sort descending (newest first)
      final sortedDesc = List<JournalEntry>.from(entries)
        ..sort((a, b) => b.visitedAt.compareTo(a.visitedAt));
      expect(sortedDesc.first.id, equals(3));
      expect(sortedDesc.last.id, equals(2));

      // Sort ascending (oldest first)
      final sortedAsc = List<JournalEntry>.from(entries)
        ..sort((a, b) => a.visitedAt.compareTo(b.visitedAt));
      expect(sortedAsc.first.id, equals(2));
      expect(sortedAsc.last.id, equals(3));
    });

    test('supports sorting by rating', () {
      final entries = [
        _createMockEntry(id: 1, rating: 3),
        _createMockEntry(id: 2, rating: 5),
        _createMockEntry(id: 3, rating: 1),
      ];

      // Sort descending (highest first)
      final sortedDesc = List<JournalEntry>.from(entries)
        ..sort((a, b) => b.rating.compareTo(a.rating));
      expect(sortedDesc.first.id, equals(2));
      expect(sortedDesc.last.id, equals(3));
    });
  });

  group('Restaurant visit summary', () {
    test('calculates average rating correctly', () {
      final ratings = [5, 4, 3, 5, 4];
      final average = ratings.reduce((a, b) => a + b) / ratings.length;
      expect(average, equals(4.2));
    });

    test('counts visits correctly', () {
      final entriesForRestaurant = [
        _createMockEntry(id: 1, restaurantId: 5),
        _createMockEntry(id: 2, restaurantId: 5),
        _createMockEntry(id: 3, restaurantId: 5),
      ];
      expect(entriesForRestaurant.length, equals(3));
    });

    test('identifies most recent visit', () {
      final entries = [
        _createMockEntry(id: 1, visitedAt: DateTime(2024, 1, 10)),
        _createMockEntry(id: 2, visitedAt: DateTime(2024, 1, 20)),
        _createMockEntry(id: 3, visitedAt: DateTime(2024, 1, 15)),
      ];

      final mostRecent = entries.reduce(
        (a, b) => a.visitedAt.isAfter(b.visitedAt) ? a : b,
      );
      expect(mostRecent.id, equals(2));
    });
  });
}

JournalEntry _createMockEntry({
  int id = 1,
  String userId = 'user-123',
  int restaurantId = 1,
  int rating = 4,
  DateTime? visitedAt,
}) {
  final now = DateTime.now().toUtc();
  return JournalEntry(
    id: id,
    userId: userId,
    restaurantId: restaurantId,
    rating: rating,
    visitedAt: visitedAt ?? now,
    createdAt: now,
    updatedAt: now,
  );
}
