import 'package:test/test.dart';
import 'package:food_butler_server/src/generated/protocol.dart';

void main() {
  group('NarrativeCache Model', () {
    test('creates cache entry with correct cache key composition', () {
      final cache = NarrativeCache(
        tourId: 123,
        userId: 'user-456',
        narrativeType: 'description',
        stopIndex: 2,
        content: 'Test narrative content',
        generatedAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(days: 30)),
        cacheHitCount: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Cache key composition should include all identifying fields
      expect(cache.tourId, equals(123));
      expect(cache.userId, equals('user-456'));
      expect(cache.narrativeType, equals('description'));
      expect(cache.stopIndex, equals(2));
    });

    test('creates cache entry for anonymous user with null userId', () {
      final cache = NarrativeCache(
        tourId: 789,
        userId: null,
        narrativeType: 'intro',
        stopIndex: null,
        content: 'Anonymous tour intro',
        generatedAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(days: 30)),
        cacheHitCount: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(cache.userId, isNull);
      expect(cache.narrativeType, equals('intro'));
      expect(cache.stopIndex, isNull);
    });

    test('validates TTL expiration with 30-day default', () {
      final now = DateTime.now();
      final thirtyDaysFromNow = now.add(const Duration(days: 30));

      final cache = NarrativeCache(
        tourId: 100,
        userId: 'test-user',
        narrativeType: 'transition',
        stopIndex: 1,
        content: 'Transition narrative',
        generatedAt: now,
        expiresAt: thirtyDaysFromNow,
        cacheHitCount: 0,
        createdAt: now,
        updatedAt: now,
      );

      final ttlDays = cache.expiresAt.difference(cache.generatedAt).inDays;
      expect(ttlDays, equals(30));
    });

    test('tracks cache hit count for monitoring', () {
      final cache = NarrativeCache(
        tourId: 200,
        userId: 'user-1',
        narrativeType: 'description',
        stopIndex: 0,
        content: 'First stop description',
        generatedAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(days: 30)),
        cacheHitCount: 5,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(cache.cacheHitCount, equals(5));
    });
  });

  group('NarrativeType Enum', () {
    test('contains all required narrative types', () {
      expect(NarrativeType.values, contains(NarrativeType.intro));
      expect(NarrativeType.values, contains(NarrativeType.description));
      expect(NarrativeType.values, contains(NarrativeType.transition));
      expect(NarrativeType.values.length, equals(3));
    });
  });

  group('NarrativeRegenerateLimit Model', () {
    test('tracks regenerate attempts per tour per day', () {
      final today = DateTime.now();
      final truncatedDate = DateTime(today.year, today.month, today.day);

      final limit = NarrativeRegenerateLimit(
        tourId: 500,
        userId: 'user-abc',
        limitDate: truncatedDate,
        attemptCount: 2,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(limit.tourId, equals(500));
      expect(limit.userId, equals('user-abc'));
      expect(limit.attemptCount, equals(2));
      expect(limit.limitDate.hour, equals(0));
      expect(limit.limitDate.minute, equals(0));
    });
  });
}
