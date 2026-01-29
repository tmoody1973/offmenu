import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_butler_flutter/admin/awards/import_preview_section.dart';
import 'package:food_butler_flutter/admin/awards/admin_review_queue_page.dart';
import 'package:food_butler_flutter/admin/awards/match_detail_modal.dart';

void main() {
  group('ImportPreviewSection', () {
    testWidgets('displays status summary chips with counts', (tester) async {
      final items = [
        ImportPreviewItem(
          recordName: 'Alinea',
          recordCity: 'Chicago',
          recordYear: 2024,
          matchedRestaurantName: 'Alinea',
          confidence: 0.98,
          status: 'auto_match',
        ),
        ImportPreviewItem(
          recordName: 'The French Laundry',
          recordCity: 'Yountville',
          recordYear: 2024,
          matchedRestaurantName: 'French Laundry',
          confidence: 0.85,
          status: 'pending_review',
        ),
        ImportPreviewItem(
          recordName: 'Unknown Restaurant',
          recordCity: 'Unknown City',
          recordYear: 2024,
          matchedRestaurantName: null,
          confidence: null,
          status: 'no_match',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ImportPreviewSection(
                items: items,
                awardType: 'michelin',
                onConfirm: () {},
                onCancel: () {},
              ),
            ),
          ),
        ),
      );

      // Check status summary chips contain count info
      expect(find.text('Auto Match: 1'), findsOneWidget);
      expect(find.text('Needs Review: 1'), findsOneWidget);
      expect(find.text('No Match: 1'), findsOneWidget);

      // Check record count
      expect(find.text('3 records'), findsOneWidget);
    });

    testWidgets('triggers confirm callback when confirm button is pressed', (tester) async {
      var confirmed = false;
      final items = [
        ImportPreviewItem(
          recordName: 'Test',
          recordCity: 'City',
          recordYear: 2024,
          status: 'auto_match',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ImportPreviewSection(
                items: items,
                awardType: 'michelin',
                onConfirm: () => confirmed = true,
                onCancel: () {},
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Confirm Import'));
      expect(confirmed, isTrue);
    });

    testWidgets('triggers cancel callback when cancel button is pressed', (tester) async {
      var cancelled = false;
      final items = [
        ImportPreviewItem(
          recordName: 'Test',
          recordCity: 'City',
          recordYear: 2024,
          status: 'auto_match',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ImportPreviewSection(
                items: items,
                awardType: 'michelin',
                onConfirm: () {},
                onCancel: () => cancelled = true,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Cancel'));
      expect(cancelled, isTrue);
    });
  });

  group('MatchDetailModal', () {
    testWidgets('displays confidence score percentage', (tester) async {
      // Use a larger screen size for the modal
      tester.view.physicalSize = const Size(1200, 1200);
      tester.view.devicePixelRatio = 1.0;

      final item = ReviewQueueItem(
        linkId: 1,
        restaurantName: 'Test Restaurant',
        restaurantAddress: '123 Main St',
        awardName: 'Test Award',
        awardDetails: '2024',
        awardType: 'michelin',
        confidenceScore: 0.78,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MatchDetailModal(
                item: item,
                onConfirm: () {},
                onReject: () {},
              ),
            ),
          ),
        ),
      );

      // Check confidence is displayed
      expect(find.text('78%'), findsOneWidget);

      // Reset view
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('triggers confirm callback when confirm button is pressed', (tester) async {
      tester.view.physicalSize = const Size(1200, 1200);
      tester.view.devicePixelRatio = 1.0;

      var confirmed = false;
      final item = ReviewQueueItem(
        linkId: 1,
        restaurantName: 'Test',
        restaurantAddress: 'Address',
        awardName: 'Award',
        awardDetails: 'Details',
        awardType: 'michelin',
        confidenceScore: 0.85,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MatchDetailModal(
                item: item,
                onConfirm: () => confirmed = true,
                onReject: () {},
              ),
            ),
          ),
        ),
      );

      // Ensure the button is visible before tapping
      await tester.ensureVisible(find.text('Confirm Match'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirm Match'));
      expect(confirmed, isTrue);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('triggers reject callback when reject button is pressed', (tester) async {
      tester.view.physicalSize = const Size(1200, 1200);
      tester.view.devicePixelRatio = 1.0;

      var rejected = false;
      final item = ReviewQueueItem(
        linkId: 1,
        restaurantName: 'Test',
        restaurantAddress: 'Address',
        awardName: 'Award',
        awardDetails: 'Details',
        awardType: 'james_beard',
        confidenceScore: 0.72,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MatchDetailModal(
                item: item,
                onConfirm: () {},
                onReject: () => rejected = true,
              ),
            ),
          ),
        ),
      );

      // Ensure the button is visible before tapping
      await tester.ensureVisible(find.text('Reject Match'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reject Match'));
      expect(rejected, isTrue);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}
