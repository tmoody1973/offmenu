import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_butler_flutter/map/widgets/award_badge.dart';
import 'package:food_butler_flutter/map/widgets/badge_row.dart';

void main() {
  group('AwardBadge', () {
    testWidgets('renders correct icon for Michelin star designation', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AwardBadge(
              type: AwardBadgeType.michelin,
              label: '3 Stars',
              size: AwardBadgeSize.standard,
            ),
          ),
        ),
      );

      // Should find star icons for Michelin
      expect(find.byIcon(Icons.star_rounded), findsWidgets);
      expect(find.text('3*'), findsOneWidget);
    });

    testWidgets('renders correct icon for Michelin Bib Gourmand', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AwardBadge(
              type: AwardBadgeType.michelin,
              label: 'Bib Gourmand',
              size: AwardBadgeSize.standard,
            ),
          ),
        ),
      );

      // Bib Gourmand uses restaurant icon
      expect(find.byIcon(Icons.restaurant), findsOneWidget);
      expect(find.text('Bib'), findsOneWidget);
    });

    testWidgets('renders correct icon for James Beard award', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AwardBadge(
              type: AwardBadgeType.jamesBeard,
              label: 'Winner',
              size: AwardBadgeSize.standard,
            ),
          ),
        ),
      );

      // James Beard uses medal/premium icon
      expect(find.byIcon(Icons.workspace_premium), findsOneWidget);
      expect(find.text('Winner'), findsOneWidget);
    });

    testWidgets('displays year in expanded size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AwardBadge(
              type: AwardBadgeType.michelin,
              label: '2 Stars',
              year: 2024,
              size: AwardBadgeSize.expanded,
            ),
          ),
        ),
      );

      expect(find.text('2 Stars'), findsOneWidget);
      expect(find.text('2024'), findsOneWidget);
    });

    testWidgets('has proper ARIA labels for accessibility', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AwardBadge(
              type: AwardBadgeType.michelin,
              label: '2 Stars',
              year: 2024,
              size: AwardBadgeSize.standard,
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(AwardBadge));
      expect(semantics.label, contains('Michelin'));
      expect(semantics.label, contains('2 Stars'));
      expect(semantics.label, contains('2024'));
    });

    testWidgets('compact size renders icon only', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AwardBadge(
              type: AwardBadgeType.michelin,
              label: '1 Star',
              size: AwardBadgeSize.compact,
            ),
          ),
        ),
      );

      // Should find the icon
      expect(find.byIcon(Icons.star_rounded), findsOneWidget);
      // Should NOT find text in compact mode
      expect(find.text('1*'), findsNothing);
      expect(find.text('1 Star'), findsNothing);
    });

    testWidgets('responds to tap callback when provided', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AwardBadge(
              type: AwardBadgeType.jamesBeard,
              label: 'Winner',
              size: AwardBadgeSize.standard,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AwardBadge));
      expect(tapped, isTrue);
    });
  });

  group('BadgeRow', () {
    testWidgets('handles overflow with "+N more" when > maxVisible badges', (tester) async {
      final awards = [
        const AwardData(type: AwardBadgeType.michelin, label: '3 Stars', year: 2024),
        const AwardData(type: AwardBadgeType.michelin, label: '2 Stars', year: 2023),
        const AwardData(type: AwardBadgeType.jamesBeard, label: 'Winner', year: 2024),
        const AwardData(type: AwardBadgeType.jamesBeard, label: 'Nominee', year: 2023),
        const AwardData(type: AwardBadgeType.jamesBeard, label: 'Semifinalist', year: 2022),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BadgeRow(
              awards: awards,
              maxVisible: 3,
            ),
          ),
        ),
      );

      // Should show first 3 badges
      expect(find.byType(AwardBadge), findsNWidgets(3));
      // Should show "+2 more"
      expect(find.text('+2 more'), findsOneWidget);
    });

    testWidgets('displays all badges when count <= maxVisible', (tester) async {
      final awards = [
        const AwardData(type: AwardBadgeType.michelin, label: '1 Star', year: 2024),
        const AwardData(type: AwardBadgeType.jamesBeard, label: 'Winner', year: 2024),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BadgeRow(
              awards: awards,
              maxVisible: 3,
            ),
          ),
        ),
      );

      // Should show both badges
      expect(find.byType(AwardBadge), findsNWidgets(2));
      // Should NOT show overflow
      expect(find.textContaining('more'), findsNothing);
    });

    testWidgets('returns empty widget when no awards', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BadgeRow(
              awards: [],
            ),
          ),
        ),
      );

      expect(find.byType(AwardBadge), findsNothing);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('overflow chip triggers callback when tapped', (tester) async {
      var tapped = false;
      final awards = [
        const AwardData(type: AwardBadgeType.michelin, label: '3 Stars'),
        const AwardData(type: AwardBadgeType.michelin, label: '2 Stars'),
        const AwardData(type: AwardBadgeType.michelin, label: '1 Star'),
        const AwardData(type: AwardBadgeType.jamesBeard, label: 'Winner'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BadgeRow(
              awards: awards,
              maxVisible: 3,
              onOverflowTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('+1 more'));
      expect(tapped, isTrue);
    });
  });

  group('AwardHistorySection', () {
    testWidgets('groups awards by type', (tester) async {
      final awards = [
        const AwardData(type: AwardBadgeType.michelin, label: '3 Stars', year: 2024),
        const AwardData(type: AwardBadgeType.jamesBeard, label: 'Winner', year: 2024),
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

      expect(find.text('Michelin Guide'), findsOneWidget);
      expect(find.text('James Beard Foundation'), findsOneWidget);
    });
  });

  group('TourAwardSummary', () {
    testWidgets('displays aggregated counts', (tester) async {
      final awards = [
        const AwardData(type: AwardBadgeType.michelin, label: '3 Stars', year: 2024),
        const AwardData(type: AwardBadgeType.michelin, label: '1 Star', year: 2024),
        const AwardData(type: AwardBadgeType.jamesBeard, label: 'Winner', year: 2024),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TourAwardSummary(awards: awards),
          ),
        ),
      );

      expect(find.text('Award-Winning Tour'), findsOneWidget);
      expect(find.textContaining('2 Michelin-starred'), findsOneWidget);
      expect(find.textContaining('1 James Beard'), findsOneWidget);
    });
  });
}
