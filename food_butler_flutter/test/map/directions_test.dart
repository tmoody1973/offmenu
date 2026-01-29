import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_butler_client/food_butler_client.dart';
import 'package:food_butler_flutter/map/services/directions_service.dart';
import 'package:food_butler_flutter/map/widgets/directions_panel.dart';
import 'package:food_butler_flutter/map/widgets/directions_step_card.dart';

void main() {
  group('DirectionsService', () {
    test('fetches directions from Mapbox API on-demand', () async {
      final service = MockDirectionsService();
      service.mockResult = MockDirectionsService.createMockResult();

      final result = await service.getDirections(
        coordinates: [
          [37.7749, -122.4194],
          [37.7850, -122.4094],
        ],
        stopNames: ['Stop 1', 'Stop 2'],
        transportMode: TransportMode.walking,
      );

      expect(result, isNotNull);
      expect(result!.legs, isNotEmpty);
    });

    test('handles API errors gracefully', () async {
      final service = MockDirectionsService();
      // No mock result set - simulates error

      final result = await service.getDirections(
        coordinates: [
          [37.7749, -122.4194],
          [37.7850, -122.4094],
        ],
        stopNames: ['Stop 1', 'Stop 2'],
        transportMode: TransportMode.walking,
      );

      expect(result, isNull);
    });
  });

  group('DirectionsStepCard', () {
    testWidgets('renders direction step in scrollable list', (tester) async {
      const step = DirectionStep(
        instruction: 'Turn right onto Main St',
        distanceMeters: 250,
        durationSeconds: 180,
        maneuverType: 'turn',
        modifier: 'right',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DirectionsStepCard(
                step: step,
                stepNumber: 1,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Turn right onto Main St'), findsOneWidget);
      expect(find.text('250 m'), findsOneWidget);
      expect(find.text('3 min'), findsOneWidget);
    });

    testWidgets('displays distance and time for each step', (tester) async {
      const steps = [
        DirectionStep(
          instruction: 'Head north',
          distanceMeters: 100,
          durationSeconds: 60,
          maneuverType: 'depart',
        ),
        DirectionStep(
          instruction: 'Turn left',
          distanceMeters: 500,
          durationSeconds: 300,
          maneuverType: 'turn',
          modifier: 'left',
        ),
        DirectionStep(
          instruction: 'Walk 2 km',
          distanceMeters: 2000,
          durationSeconds: 1500,
          maneuverType: 'straight',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: steps
                  .asMap()
                  .entries
                  .map((e) => DirectionsStepCard(
                        step: e.value,
                        stepNumber: e.key + 1,
                      ))
                  .toList(),
            ),
          ),
        ),
      );

      // First step
      expect(find.text('100 m'), findsOneWidget);
      expect(find.text('1 min'), findsOneWidget);

      // Second step
      expect(find.text('500 m'), findsOneWidget);
      expect(find.text('5 min'), findsOneWidget);

      // Third step (shows km)
      expect(find.text('2.0 km'), findsOneWidget);
      expect(find.text('25 min'), findsOneWidget);
    });

    testWidgets('highlights current/next step', (tester) async {
      const step = DirectionStep(
        instruction: 'Current step',
        distanceMeters: 100,
        durationSeconds: 60,
        maneuverType: 'straight',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: const [
                  DirectionsStepCard(
                    step: step,
                    stepNumber: 1,
                    isCurrent: true,
                  ),
                  DirectionsStepCard(
                    step: DirectionStep(
                      instruction: 'Next step',
                      distanceMeters: 200,
                      durationSeconds: 120,
                      maneuverType: 'turn',
                    ),
                    stepNumber: 2,
                    isNext: true,
                  ),
                  DirectionsStepCard(
                    step: DirectionStep(
                      instruction: 'Future step',
                      distanceMeters: 300,
                      durationSeconds: 180,
                      maneuverType: 'turn',
                    ),
                    stepNumber: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // All steps should be visible
      expect(find.text('Current step'), findsOneWidget);
      expect(find.text('Next step'), findsOneWidget);
      expect(find.text('Future step'), findsOneWidget);
    });
  });

  group('DirectionsPanel', () {
    testWidgets('collapse/expand works', (tester) async {
      final directions = MockDirectionsService.createMockResult(legCount: 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400, // Give enough height
              child: DirectionsPanel(
                directions: directions,
                initiallyExpanded: true,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initially expanded - header visible
      expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsOneWidget);

      // Tap collapse button
      await tester.tap(find.byIcon(Icons.keyboard_arrow_down_rounded));
      await tester.pumpAndSettle();

      // Panel should be collapsed
      expect(find.byIcon(Icons.keyboard_arrow_up_rounded), findsOneWidget);

      // Tap expand button
      await tester.tap(find.byIcon(Icons.keyboard_arrow_up_rounded));
      await tester.pumpAndSettle();

      // Panel should be expanded again
      expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsOneWidget);
    });

    testWidgets('renders nothing when directions is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DirectionsPanel(
              directions: null,
            ),
          ),
        ),
      );

      // Should render SizedBox.shrink
      expect(find.byType(DirectionsPanel), findsOneWidget);
      expect(find.byType(DirectionsStepCard), findsNothing);
    });
  });

  group('GetDirectionsButton', () {
    testWidgets('triggers fetch on tap', (tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GetDirectionsButton(
              onTap: () {
                wasTapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GetDirectionsButton));
      await tester.pump();

      expect(wasTapped, isTrue);
    });

    testWidgets('shows loading state', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GetDirectionsButton(
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);
    });
  });

  group('DirectionStep formatting', () {
    test('formats distance correctly', () {
      const short = DirectionStep(
        instruction: '',
        distanceMeters: 500,
        durationSeconds: 0,
        maneuverType: '',
      );
      expect(short.distanceText, equals('500 m'));

      const long = DirectionStep(
        instruction: '',
        distanceMeters: 2500,
        durationSeconds: 0,
        maneuverType: '',
      );
      expect(long.distanceText, equals('2.5 km'));
    });

    test('formats duration correctly', () {
      const seconds = DirectionStep(
        instruction: '',
        distanceMeters: 0,
        durationSeconds: 45,
        maneuverType: '',
      );
      expect(seconds.durationText, equals('45 sec'));

      const minutes = DirectionStep(
        instruction: '',
        distanceMeters: 0,
        durationSeconds: 300,
        maneuverType: '',
      );
      expect(minutes.durationText, equals('5 min'));

      const hours = DirectionStep(
        instruction: '',
        distanceMeters: 0,
        durationSeconds: 3900, // 1h 5min
        maneuverType: '',
      );
      expect(hours.durationText, equals('1h 5min'));
    });
  });
}
