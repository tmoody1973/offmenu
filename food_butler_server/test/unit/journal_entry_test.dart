import 'package:test/test.dart';
import 'package:food_butler_server/src/generated/protocol.dart';

void main() {
  group('JournalEntry model', () {
    test('creates entry with required fields', () {
      final now = DateTime.now().toUtc();
      final entry = JournalEntry(
        userId: 'user-123',
        restaurantId: 1,
        rating: 4,
        visitedAt: now,
        createdAt: now,
        updatedAt: now,
      );

      expect(entry.userId, equals('user-123'));
      expect(entry.restaurantId, equals(1));
      expect(entry.rating, equals(4));
      expect(entry.visitedAt, equals(now));
      expect(entry.tourId, isNull);
      expect(entry.notes, isNull);
    });

    test('validates rating must be between 1 and 5', () {
      final now = DateTime.now().toUtc();

      final validEntry1 = JournalEntry(
        userId: 'user-123',
        restaurantId: 1,
        rating: 1,
        visitedAt: now,
        createdAt: now,
        updatedAt: now,
      );
      expect(validEntry1.rating, greaterThanOrEqualTo(1));
      expect(validEntry1.rating, lessThanOrEqualTo(5));

      final validEntry5 = JournalEntry(
        userId: 'user-456',
        restaurantId: 2,
        rating: 5,
        visitedAt: now,
        createdAt: now,
        updatedAt: now,
      );
      expect(validEntry5.rating, greaterThanOrEqualTo(1));
      expect(validEntry5.rating, lessThanOrEqualTo(5));
    });

    test('supports optional tour association', () {
      final now = DateTime.now().toUtc();
      final entryWithTour = JournalEntry(
        userId: 'user-123',
        restaurantId: 1,
        tourId: 10,
        tourStopId: 2,
        rating: 5,
        visitedAt: now,
        createdAt: now,
        updatedAt: now,
      );

      expect(entryWithTour.tourId, equals(10));
      expect(entryWithTour.tourStopId, equals(2));
    });

    test('stores notes as optional text field', () {
      final now = DateTime.now().toUtc();
      final entryWithNotes = JournalEntry(
        userId: 'user-123',
        restaurantId: 1,
        rating: 4,
        notes: 'Amazing pasta! The carbonara was perfectly creamy.',
        visitedAt: now,
        createdAt: now,
        updatedAt: now,
      );

      expect(entryWithNotes.notes, isNotNull);
      expect(entryWithNotes.notes, contains('carbonara'));

      final entryWithoutNotes = JournalEntry(
        userId: 'user-456',
        restaurantId: 2,
        rating: 3,
        visitedAt: now,
        createdAt: now,
        updatedAt: now,
      );
      expect(entryWithoutNotes.notes, isNull);
    });

    test('serializes to JSON correctly', () {
      final now = DateTime.now().toUtc();
      final entry = JournalEntry(
        id: 1,
        userId: 'user-123',
        restaurantId: 5,
        tourId: 10,
        rating: 4,
        notes: 'Great food',
        visitedAt: now,
        createdAt: now,
        updatedAt: now,
      );

      final json = entry.toJson();
      expect(json['userId'], equals('user-123'));
      expect(json['restaurantId'], equals(5));
      expect(json['tourId'], equals(10));
      expect(json['rating'], equals(4));
      expect(json['notes'], equals('Great food'));
    });
  });

  group('JournalPhoto model', () {
    test('creates photo with required fields', () {
      final now = DateTime.now().toUtc();
      final photo = JournalPhoto(
        journalEntryId: 1,
        originalUrl: 'https://r2.example.com/user/entry/photo.jpg',
        thumbnailUrl: 'https://r2.example.com/user/entry/photo_thumb.jpg',
        displayOrder: 0,
        uploadedAt: now,
      );

      expect(photo.journalEntryId, equals(1));
      expect(photo.originalUrl, contains('photo.jpg'));
      expect(photo.thumbnailUrl, contains('thumb'));
      expect(photo.displayOrder, equals(0));
    });

    test('validates display order is 0-2 for MVP', () {
      final now = DateTime.now().toUtc();

      for (var order = 0; order < 3; order++) {
        final photo = JournalPhoto(
          journalEntryId: 1,
          originalUrl: 'https://r2.example.com/photo$order.jpg',
          thumbnailUrl: 'https://r2.example.com/photo${order}_thumb.jpg',
          displayOrder: order,
          uploadedAt: now,
        );
        expect(photo.displayOrder, inInclusiveRange(0, 2));
      }
    });

    test('serializes to JSON correctly', () {
      final now = DateTime.now().toUtc();
      final photo = JournalPhoto(
        id: 1,
        journalEntryId: 5,
        originalUrl: 'https://r2.example.com/original.jpg',
        thumbnailUrl: 'https://r2.example.com/thumb.jpg',
        displayOrder: 1,
        uploadedAt: now,
      );

      final json = photo.toJson();
      expect(json['journalEntryId'], equals(5));
      expect(json['originalUrl'], contains('original'));
      expect(json['thumbnailUrl'], contains('thumb'));
      expect(json['displayOrder'], equals(1));
    });
  });
}
