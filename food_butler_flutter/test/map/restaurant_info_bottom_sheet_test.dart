import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_butler_flutter/map/models/tour_stop_marker.dart';
import 'package:food_butler_flutter/map/widgets/award_badge.dart';
import 'package:food_butler_flutter/map/widgets/restaurant_info_bottom_sheet.dart';
import 'package:food_butler_flutter/map/widgets/tour_markers_layer.dart';
import 'package:food_butler_flutter/map/widgets/numbered_marker_widget.dart';

void main() {
  final testStop = const TourStopMarker(
    id: 'test_stop_1',
    stopNumber: 1,
    latitude: 37.7749,
    longitude: -122.4194,
    name: 'Test Restaurant',
    address: '123 Main St, San Francisco, CA',
    cuisineType: 'Italian',
    awardBadges: ['michelin_one_star', 'james_beard_winner'],
  );

  group('RestaurantInfoBottomSheet', () {
    testWidgets('opens when marker is tapped', (tester) async {
      TourStopMarker? selectedStop;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    TourMarkersLayer(
                      stops: [testStop],
                      onMarkerSelected: (marker) {
                        setState(() {
                          selectedStop = marker;
                        });
                        RestaurantInfoBottomSheet.show(
                          context,
                          stop: marker,
                        );
                      },
                    ),
                    if (selectedStop != null)
                      Text('Selected: ${selectedStop!.name}'),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // Tap the marker
      await tester.tap(find.text('1'));
      await tester.pumpAndSettle();

      // Bottom sheet should be displayed
      expect(find.byType(RestaurantInfoBottomSheet), findsOneWidget);
      expect(find.text('Test Restaurant'), findsOneWidget);
    });

    testWidgets('displays correct restaurant data', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestaurantInfoBottomSheet(
              stop: testStop,
            ),
          ),
        ),
      );

      // Wait for sheet to build
      await tester.pumpAndSettle();

      // Check restaurant name
      expect(find.text('Test Restaurant'), findsOneWidget);

      // Check cuisine type
      expect(find.text('Italian'), findsOneWidget);

      // Check stop number badge
      expect(find.text('Stop 1'), findsOneWidget);

      // Check address
      expect(find.textContaining('123 Main St'), findsOneWidget);
    });

    testWidgets('renders award badges correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestaurantInfoBottomSheet(
              stop: testStop,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Award badges should be rendered
      expect(find.byType(AwardBadge), findsNWidgets(2));

      // Check for Michelin and James Beard badges (abbreviated in standard size)
      expect(find.text('1*'), findsOneWidget);
      expect(find.text('Winner'), findsOneWidget);
    });

    testWidgets('View Details navigation works', (tester) async {
      TourStopMarker? navigatedStop;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestaurantInfoBottomSheet(
              stop: testStop,
              onViewDetails: (stop) {
                navigatedStop = stop;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap View Details button
      await tester.tap(find.text('View Details'));
      await tester.pump();

      expect(navigatedStop, equals(testStop));
      expect(navigatedStop?.name, equals('Test Restaurant'));
    });
  });

  group('AwardBadge', () {
    test('fromString parses Michelin awards correctly', () {
      final oneStar = AwardBadge.fromString('michelin_one_star');
      expect(oneStar.type, equals(AwardBadgeType.michelin));
      expect(oneStar.label, equals('1 Star'));

      final twoStar = AwardBadge.fromString('michelin_two_star');
      expect(twoStar.type, equals(AwardBadgeType.michelin));
      expect(twoStar.label, equals('2 Stars'));

      final threeStar = AwardBadge.fromString('michelin_three_star');
      expect(threeStar.type, equals(AwardBadgeType.michelin));
      expect(threeStar.label, equals('3 Stars'));

      final bibGourmand = AwardBadge.fromString('michelin_bib_gourmand');
      expect(bibGourmand.type, equals(AwardBadgeType.michelin));
      expect(bibGourmand.label, equals('Bib Gourmand'));
    });

    test('fromString parses James Beard awards correctly', () {
      final winner = AwardBadge.fromString('james_beard_winner');
      expect(winner.type, equals(AwardBadgeType.jamesBeard));
      expect(winner.label, equals('Winner'));

      final nominee = AwardBadge.fromString('james_beard_nominee');
      expect(nominee.type, equals(AwardBadgeType.jamesBeard));
      expect(nominee.label, equals('Nominee'));

      final semifinalist = AwardBadge.fromString('james_beard_semifinalist');
      expect(semifinalist.type, equals(AwardBadgeType.jamesBeard));
      expect(semifinalist.label, equals('Semifinalist'));
    });

    testWidgets('renders with correct styling for each type', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                AwardBadge(
                  type: AwardBadgeType.michelin,
                  label: '1 Star',
                ),
                AwardBadge(
                  type: AwardBadgeType.jamesBeard,
                  label: 'Winner',
                ),
              ],
            ),
          ),
        ),
      );

      // Both badges should render
      expect(find.byType(AwardBadge), findsNWidgets(2));
      // Standard size uses abbreviated labels
      expect(find.text('1*'), findsOneWidget);
      expect(find.text('Winner'), findsOneWidget);

      // Check for icons (star for Michelin, medal for James Beard)
      expect(find.byIcon(Icons.star_rounded), findsOneWidget);
      expect(find.byIcon(Icons.workspace_premium), findsOneWidget);
    });
  });
}
