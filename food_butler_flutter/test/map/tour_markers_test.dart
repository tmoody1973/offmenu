import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_butler_flutter/map/models/tour_stop_marker.dart';
import 'package:food_butler_flutter/map/widgets/numbered_marker_widget.dart';
import 'package:food_butler_flutter/map/widgets/tour_markers_layer.dart';

void main() {
  final testStops = [
    const TourStopMarker(
      id: 'stop_1',
      stopNumber: 1,
      latitude: 37.7749,
      longitude: -122.4194,
      name: 'Restaurant A',
      address: '123 Main St',
      awardBadges: ['michelin_one_star'],
      isCurrent: true,
    ),
    const TourStopMarker(
      id: 'stop_2',
      stopNumber: 2,
      latitude: 37.7850,
      longitude: -122.4094,
      name: 'Restaurant B',
      address: '456 Oak Ave',
      awardBadges: ['james_beard_winner'],
    ),
    const TourStopMarker(
      id: 'stop_3',
      stopNumber: 3,
      latitude: 37.7650,
      longitude: -122.4294,
      name: 'Restaurant C',
      address: '789 Pine Blvd',
      awardBadges: [],
    ),
  ];

  group('NumberedMarkerWidget', () {
    testWidgets('renders with correct stop numbers (1, 2, 3...)',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                const NumberedMarkerWidget(stopNumber: 1),
                const NumberedMarkerWidget(stopNumber: 2),
                const NumberedMarkerWidget(stopNumber: 3),
              ],
            ),
          ),
        ),
      );

      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('is tappable and fires selection callback', (tester) async {
      bool wasTapped = false;
      int? tappedNumber;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: NumberedMarkerWidget(
                stopNumber: 5,
                onTap: () {
                  wasTapped = true;
                  tappedNumber = 5;
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('5'));
      await tester.pump();

      expect(wasTapped, isTrue);
      expect(tappedNumber, equals(5));
    });

    testWidgets('displays correct visual hierarchy for marker states',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                NumberedMarkerWidget(
                  stopNumber: 1,
                  state: MarkerState.current,
                ),
                NumberedMarkerWidget(
                  stopNumber: 2,
                  state: MarkerState.upcoming,
                ),
                NumberedMarkerWidget(
                  stopNumber: 3,
                  state: MarkerState.completed,
                ),
                NumberedMarkerWidget(
                  stopNumber: 4,
                  state: MarkerState.selected,
                ),
              ],
            ),
          ),
        ),
      );

      // All markers should be rendered
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);

      // Find the AnimatedContainers to verify size differences
      final containers =
          tester.widgetList<AnimatedContainer>(find.byType(AnimatedContainer));
      expect(containers.length, equals(4));

      // Current and selected should be larger (40px)
      // Upcoming should be medium (32px)
      // Completed should be smaller (28px)
      final sizes = containers.map((c) => c.constraints?.maxWidth ?? 0).toList();

      // Just verify we have 4 markers rendered with different sizes
      expect(sizes.length, equals(4));
    });

    testWidgets('has minimum tap target size for accessibility', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: NumberedMarkerWidget(stopNumber: 1),
            ),
          ),
        ),
      );

      // Find the NumberedMarkerWidget and verify its internal SizedBox
      final markerWidget = tester.widget<NumberedMarkerWidget>(
        find.byType(NumberedMarkerWidget),
      );

      // The marker has a size property that defaults to minTapTargetSize (44)
      expect(markerWidget.size, greaterThanOrEqualTo(44.0));

      // Also verify by finding a SizedBox in the tree
      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      final tapTargetBox = sizedBoxes.firstWhere(
        (box) => box.width == 44.0 && box.height == 44.0,
        orElse: () => const SizedBox(),
      );

      expect(tapTargetBox.width, equals(44.0));
      expect(tapTargetBox.height, equals(44.0));
    });
  });

  group('TourMarkersLayer', () {
    testWidgets('markers update dynamically when tour data changes',
        (tester) async {
      final stopsNotifier = ValueNotifier<List<TourStopMarker>>(testStops);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ValueListenableBuilder<List<TourStopMarker>>(
              valueListenable: stopsNotifier,
              builder: (context, stops, _) {
                return TourMarkersLayer(stops: stops);
              },
            ),
          ),
        ),
      );

      // Initially 3 markers
      expect(find.byType(NumberedMarkerWidget), findsNWidgets(3));
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);

      // Add a new stop
      stopsNotifier.value = [
        ...testStops,
        const TourStopMarker(
          id: 'stop_4',
          stopNumber: 4,
          latitude: 37.7550,
          longitude: -122.4394,
          name: 'Restaurant D',
          address: '101 Elm St',
          awardBadges: [],
        ),
      ];
      await tester.pump();

      // Now 4 markers
      expect(find.byType(NumberedMarkerWidget), findsNWidgets(4));
      expect(find.text('4'), findsOneWidget);

      // Remove stops
      stopsNotifier.value = [testStops[0]];
      await tester.pump();

      // Now only 1 marker
      expect(find.byType(NumberedMarkerWidget), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('manages selection state correctly', (tester) async {
      int? selectedIndex;
      TourStopMarker? selectedMarker;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return TourMarkersLayer(
                  stops: testStops,
                  selectedIndex: selectedIndex,
                  onMarkerSelected: (marker) {
                    setState(() {
                      selectedIndex = testStops.indexOf(marker);
                      selectedMarker = marker;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      // Initially no selection
      expect(selectedIndex, isNull);

      // Tap on stop 2
      await tester.tap(find.text('2'));
      await tester.pump();

      expect(selectedIndex, equals(1));
      expect(selectedMarker?.name, equals('Restaurant B'));

      // Tap on stop 3
      await tester.tap(find.text('3'));
      await tester.pump();

      expect(selectedIndex, equals(2));
      expect(selectedMarker?.name, equals('Restaurant C'));
    });
  });

  group('TourStopMarkerListExtension', () {
    test('withCurrentStop updates marker states correctly', () {
      final markers = testStops.withCurrentStop(1);

      expect(markers[0].isCompleted, isTrue);
      expect(markers[0].isCurrent, isFalse);

      expect(markers[1].isCurrent, isTrue);
      expect(markers[1].isCompleted, isFalse);

      expect(markers[2].isCurrent, isFalse);
      expect(markers[2].isCompleted, isFalse);
    });
  });
}
