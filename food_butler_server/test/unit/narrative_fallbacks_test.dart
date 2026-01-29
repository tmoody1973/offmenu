import 'package:test/test.dart';

import 'package:food_butler_server/src/narratives/narrative_fallbacks.dart';
import 'package:food_butler_server/src/services/narrative_service.dart';

void main() {
  group('NarrativeFallbacks', () {
    group('getIntroFallback', () {
      test('returns grammatically complete introduction', () {
        final tourData = TourData(
          tourId: 1,
          neighborhood: 'West Loop',
          transportMode: 'walking',
          timeOfDay: 'evening',
          stops: [
            TourStopData(
              name: 'Restaurant A',
              cuisineType: 'Italian',
              signatureDishes: [],
              awards: [],
              neighborhood: 'West Loop',
            ),
            TourStopData(
              name: 'Restaurant B',
              cuisineType: 'Korean',
              signatureDishes: [],
              awards: [],
              neighborhood: 'West Loop',
            ),
          ],
          routeLegs: [
            RouteLegData(durationMinutes: 5),
          ],
        );

        final fallback = NarrativeFallbacks.getIntroFallback(tourData);

        expect(fallback, contains('West Loop'));
        expect(fallback, contains('2 stops'));
        expect(fallback.endsWith('.'), isTrue);
      });

      test('includes cuisine diversity', () {
        final tourData = TourData(
          tourId: 2,
          neighborhood: 'River North',
          transportMode: 'driving',
          timeOfDay: 'lunch',
          stops: [
            TourStopData(
              name: 'A',
              cuisineType: 'Mexican',
              signatureDishes: [],
              awards: [],
              neighborhood: 'River North',
            ),
            TourStopData(
              name: 'B',
              cuisineType: 'Japanese',
              signatureDishes: [],
              awards: [],
              neighborhood: 'River North',
            ),
            TourStopData(
              name: 'C',
              cuisineType: 'French',
              signatureDishes: [],
              awards: [],
              neighborhood: 'River North',
            ),
          ],
          routeLegs: [
            RouteLegData(durationMinutes: 5),
            RouteLegData(durationMinutes: 7),
          ],
        );

        final fallback = NarrativeFallbacks.getIntroFallback(tourData);

        expect(fallback, contains('and more'));
      });
    });

    group('getDescriptionFallback', () {
      test('returns grammatically complete description', () {
        final stop = TourStopData(
          name: 'Alinea',
          cuisineType: 'Contemporary American',
          signatureDishes: ['Edible Balloon'],
          awards: ['Michelin 3-Star'],
          neighborhood: 'Lincoln Park',
        );

        final fallback =
            NarrativeFallbacks.getDescriptionFallback(stop, 2, 4);

        expect(fallback, contains('Alinea'));
        expect(fallback, contains('Contemporary American'));
        expect(fallback.endsWith('.'), isTrue);
      });

      test('includes awards when present', () {
        final stop = TourStopData(
          name: 'Girl & The Goat',
          cuisineType: 'American',
          signatureDishes: [],
          awards: ['James Beard Award'],
          neighborhood: 'West Loop',
        );

        final fallback =
            NarrativeFallbacks.getDescriptionFallback(stop, 1, 3);

        expect(fallback, contains('James Beard'));
      });

      test('adapts text for first stop', () {
        final stop = TourStopData(
          name: 'First Restaurant',
          cuisineType: 'Italian',
          signatureDishes: [],
          awards: [],
          neighborhood: 'Downtown',
        );

        final fallback =
            NarrativeFallbacks.getDescriptionFallback(stop, 1, 3);

        expect(fallback, contains('begin'));
      });

      test('adapts text for final stop', () {
        final stop = TourStopData(
          name: 'Last Restaurant',
          cuisineType: 'Dessert',
          signatureDishes: [],
          awards: [],
          neighborhood: 'Downtown',
        );

        final fallback =
            NarrativeFallbacks.getDescriptionFallback(stop, 3, 3);

        expect(fallback, contains('final'));
      });
    });

    group('getTransitionFallback', () {
      test('returns grammatically complete transition', () {
        final fromStop = TourStopData(
          name: 'Sushi Place',
          cuisineType: 'Japanese',
          signatureDishes: [],
          awards: [],
          neighborhood: 'River North',
        );
        final toStop = TourStopData(
          name: 'Taco Joint',
          cuisineType: 'Mexican',
          signatureDishes: [],
          awards: [],
          neighborhood: 'River North',
        );
        final leg = RouteLegData(durationMinutes: 8);

        final fallback = NarrativeFallbacks.getTransitionFallback(
          fromStop,
          toStop,
          leg,
          'walking',
        );

        expect(fallback, contains('8 minutes'));
        expect(fallback, contains('Sushi Place'));
        expect(fallback, contains('Taco Joint'));
        expect(fallback, contains('Mexican'));
        expect(fallback.endsWith('.'), isTrue);
      });

      test('uses correct transport mode verb', () {
        final stop = TourStopData(
          name: 'A',
          cuisineType: 'X',
          signatureDishes: [],
          awards: [],
          neighborhood: 'Y',
        );
        final leg = RouteLegData(durationMinutes: 5);

        final walkingFallback = NarrativeFallbacks.getTransitionFallback(
          stop,
          stop,
          leg,
          'walking',
        );
        expect(walkingFallback, contains('walk'));

        final drivingFallback = NarrativeFallbacks.getTransitionFallback(
          stop,
          stop,
          leg,
          'driving',
        );
        expect(drivingFallback, contains('drive'));
      });

      test('handles singular minute', () {
        final stop = TourStopData(
          name: 'A',
          cuisineType: 'X',
          signatureDishes: [],
          awards: [],
          neighborhood: 'Y',
        );
        final leg = RouteLegData(durationMinutes: 1);

        final fallback = NarrativeFallbacks.getTransitionFallback(
          stop,
          stop,
          leg,
          'walking',
        );

        expect(fallback, contains('a minute'));
        expect(fallback.contains('1 minute'), isFalse);
      });
    });
  });

  group('NarrativeGenerationException', () {
    test('creates structured log entry', () {
      final exception = NarrativeGenerationException(
        message: 'API timeout',
        narrativeType: 'description',
        stopIndex: 2,
        tourId: '123',
        originalError: 'TimeoutException',
      );

      final logEntry = exception.toLogEntry();

      expect(logEntry['error_type'], equals('narrative_generation_failed'));
      expect(logEntry['narrative_type'], equals('description'));
      expect(logEntry['stop_index'], equals(2));
      expect(logEntry['tour_id'], equals('123'));
      expect(logEntry['timestamp'], isNotNull);
    });
  });

  group('NarrativeErrorLogger', () {
    test('creates complete failure log with all context', () {
      final log = NarrativeErrorLogger.createFailureLog(
        tourId: 456,
        narrativeType: 'intro',
        stopIndex: null,
        errorType: 'groq_api_error',
        errorMessage: 'Rate limit exceeded',
        attemptCount: 3,
      );

      expect(log['event'], equals('narrative_generation_failed'));
      expect(log['tour_id'], equals(456));
      expect(log['narrative_type'], equals('intro'));
      expect(log['error_type'], equals('groq_api_error'));
      expect(log['error_message'], equals('Rate limit exceeded'));
      expect(log['attempt_count'], equals(3));
      expect(log['fallback_used'], isTrue);
    });
  });
}
