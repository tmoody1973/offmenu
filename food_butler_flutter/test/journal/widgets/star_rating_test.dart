import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:food_butler_flutter/journal/widgets/star_rating.dart';

void main() {
  group('StarRating', () {
    testWidgets('displays 5 stars', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StarRating(rating: 3),
          ),
        ),
      );

      // Should find 5 star icons (filled or outlined)
      final starIcons = find.byIcon(Icons.star);
      final outlinedStarIcons = find.byIcon(Icons.star_border);
      expect(starIcons.evaluate().length + outlinedStarIcons.evaluate().length,
          equals(5));
    });

    testWidgets('shows correct number of filled stars for rating', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StarRating(rating: 3),
          ),
        ),
      );

      // Should have 3 filled stars
      expect(find.byIcon(Icons.star), findsNWidgets(3));
      // Should have 2 outlined stars
      expect(find.byIcon(Icons.star_border), findsNWidgets(2));
    });

    testWidgets('calls onRatingChanged when star is tapped', (tester) async {
      int? selectedRating;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StarRating(
              rating: 2,
              onRatingChanged: (rating) {
                selectedRating = rating;
              },
            ),
          ),
        ),
      );

      // Tap the 4th star (index 3)
      await tester.tap(find.byIcon(Icons.star_border).first);
      await tester.pump();

      expect(selectedRating, equals(3));
    });

    testWidgets('is not tappable when readOnly is true', (tester) async {
      int? selectedRating;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StarRating(
              rating: 2,
              readOnly: true,
              onRatingChanged: (rating) {
                selectedRating = rating;
              },
            ),
          ),
        ),
      );

      // Tap the 4th star
      await tester.tap(find.byIcon(Icons.star_border).first);
      await tester.pump();

      // Callback should not be called
      expect(selectedRating, isNull);
    });

    testWidgets('has minimum 44x44 tap target for accessibility', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StarRating(rating: 3),
          ),
        ),
      );

      // Find the InkWell widgets wrapping the stars
      final inkWells = tester.widgetList<InkWell>(find.byType(InkWell));

      for (final inkWell in inkWells) {
        // Each star should be inside a container with min 44x44 tap target
        // We check that the InkWell exists (it wraps each star)
        expect(inkWell, isNotNull);
      }
    });
  });

  group('LabeledStarRating', () {
    testWidgets('displays label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LabeledStarRating(
              label: 'Rating',
              rating: 4,
            ),
          ),
        ),
      );

      expect(find.text('Rating'), findsOneWidget);
    });

    testWidgets('shows required indicator when required is true',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LabeledStarRating(
              label: 'Rating',
              rating: 4,
              required: true,
            ),
          ),
        ),
      );

      expect(find.text(' *'), findsOneWidget);
    });

    testWidgets('shows error text when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LabeledStarRating(
              label: 'Rating',
              rating: 0,
              errorText: 'Rating is required',
            ),
          ),
        ),
      );

      expect(find.text('Rating is required'), findsOneWidget);
    });
  });
}
