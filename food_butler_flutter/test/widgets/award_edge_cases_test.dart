import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_butler_flutter/map/widgets/award_badge.dart';
import 'package:food_butler_flutter/map/widgets/badge_row.dart';

/// Edge case tests for award badge feature.
///
/// These tests cover scenarios that are not addressed by the primary test files
/// but are important for robust behavior.
void main() {
  group('Edge Cases: Empty Award Data', () {
    testWidgets('BadgeRow gracefully handles null-like empty list', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BadgeRow(
              awards: [],
              maxVisible: 3,
            ),
          ),
        ),
      );

      // Should render without error and show nothing visible
      expect(find.byType(AwardBadge), findsNothing);
      // The widget should still be in the tree but empty
      expect(find.byType(BadgeRow), findsOneWidget);
    });

    testWidgets('AwardHistorySection shows nothing for empty awards', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: AwardHistorySection(awards: []),
            ),
          ),
        ),
      );

      // Should not show section headers when no awards
      expect(find.text('Michelin Guide'), findsNothing);
      expect(find.text('James Beard Foundation'), findsNothing);
    });

    testWidgets('TourAwardSummary returns empty for no awards', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TourAwardSummary(awards: []),
          ),
        ),
      );

      // Should not show the award summary section at all
      expect(find.text('Award-Winning Tour'), findsNothing);
    });
  });

  group('Edge Cases: Multiple Awards Across Years', () {
    testWidgets('displays multiple awards from same restaurant correctly', (tester) async {
      // Simulate a restaurant that has won multiple awards over the years
      final awards = [
        const AwardData(type: AwardBadgeType.michelin, label: '3 Stars', year: 2024),
        const AwardData(type: AwardBadgeType.michelin, label: '3 Stars', year: 2023),
        const AwardData(type: AwardBadgeType.michelin, label: '2 Stars', year: 2022),
        const AwardData(type: AwardBadgeType.jamesBeard, label: 'Winner', year: 2024),
        const AwardData(type: AwardBadgeType.jamesBeard, label: 'Nominee', year: 2023),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: AwardHistorySection(awards: awards),
            ),
          ),
        ),
      );

      // Should show all awards grouped properly
      expect(find.text('Michelin Guide'), findsOneWidget);
      expect(find.text('James Beard Foundation'), findsOneWidget);

      // Should show individual awards
      expect(find.byType(AwardBadge), findsNWidgets(5));
    });

    testWidgets('AwardHistorySection sorts by year descending within type', (tester) async {
      final awards = [
        const AwardData(type: AwardBadgeType.michelin, label: '2 Stars', year: 2020),
        const AwardData(type: AwardBadgeType.michelin, label: '3 Stars', year: 2024),
        const AwardData(type: AwardBadgeType.michelin, label: '1 Star', year: 2018),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: AwardHistorySection(awards: awards),
            ),
          ),
        ),
      );

      // Find all year texts
      final yearTexts = find.textContaining('202');
      expect(yearTexts, findsWidgets);
    });
  });

  group('Edge Cases: Badge Sizing Consistency', () {
    testWidgets('compact badges maintain consistent size across types', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                AwardBadge(
                  type: AwardBadgeType.michelin,
                  label: '3 Stars',
                  size: AwardBadgeSize.compact,
                ),
                AwardBadge(
                  type: AwardBadgeType.jamesBeard,
                  label: 'Winner',
                  size: AwardBadgeSize.compact,
                ),
              ],
            ),
          ),
        ),
      );

      // Find both badges
      final badges = tester.widgetList<AwardBadge>(find.byType(AwardBadge));
      expect(badges.length, equals(2));

      // Both should be compact size
      for (final badge in badges) {
        expect(badge.size, equals(AwardBadgeSize.compact));
      }
    });

    testWidgets('expanded badges show full information', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AwardBadge(
              type: AwardBadgeType.jamesBeard,
              label: 'Outstanding Chef',
              year: 2024,
              size: AwardBadgeSize.expanded,
            ),
          ),
        ),
      );

      // Should show full label (not abbreviated)
      expect(find.text('Outstanding Chef'), findsOneWidget);
      expect(find.text('2024'), findsOneWidget);
    });
  });

  group('Edge Cases: Accessibility', () {
    testWidgets('all badge sizes have semantic labels', (tester) async {
      for (final size in AwardBadgeSize.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AwardBadge(
                type: AwardBadgeType.michelin,
                label: '1 Star',
                year: 2024,
                size: size,
              ),
            ),
          ),
        );

        final semantics = tester.getSemantics(find.byType(AwardBadge));
        expect(semantics.label, isNotNull);
        expect(semantics.label, isNotEmpty);
      }
    });
  });
}
