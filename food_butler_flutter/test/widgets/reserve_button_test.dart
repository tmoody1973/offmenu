import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:food_butler_client/food_butler_client.dart';
import 'package:food_butler_flutter/widgets/reservation/reserve_button.dart';
import 'package:food_butler_flutter/services/opentable/reservation_launcher.dart';
import 'package:food_butler_flutter/services/opentable/url_launcher_wrapper.dart';

class MockUrlLauncherWrapper extends Mock implements UrlLauncherWrapper {}

void main() {
  late MockUrlLauncherWrapper mockLauncher;

  setUpAll(() {
    registerFallbackValue(url_launcher.LaunchMode.platformDefault);
  });

  setUp(() {
    mockLauncher = MockUrlLauncherWrapper();
  });

  Widget buildTestWidget(Restaurant restaurant, {bool compact = false}) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ReserveButton(
            restaurant: restaurant,
            compact: compact,
            launcher: ReservationLauncher(urlLauncher: mockLauncher),
          ),
        ),
      ),
    );
  }

  final now = DateTime.now();

  group('ReserveButton', () {
    testWidgets('shows Reserve button when OpenTable ID is present', (tester) async {
      final restaurant = Restaurant(
        fsqId: 'fsq_123',
        name: 'Test Restaurant',
        address: '123 Main St',
        latitude: 37.7749,
        longitude: -122.4194,
        priceTier: 2,
        cuisineTypes: ['Italian'],
        createdAt: now,
        updatedAt: now,
        opentableId: 'ot_12345',
      );

      await tester.pumpWidget(buildTestWidget(restaurant));

      expect(find.text('Reserve'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today_rounded), findsOneWidget);
    });

    testWidgets('shows Reserve button when only address is present (search fallback)', (tester) async {
      final restaurant = Restaurant(
        fsqId: 'fsq_456',
        name: 'Another Restaurant',
        address: '456 Oak Ave, San Francisco',
        latitude: 37.7850,
        longitude: -122.4094,
        priceTier: 3,
        cuisineTypes: ['Mexican'],
        createdAt: now,
        updatedAt: now,
      );

      await tester.pumpWidget(buildTestWidget(restaurant));

      // Should show Reserve button because search fallback is available
      expect(find.text('Reserve'), findsOneWidget);
    });

    testWidgets('shows phone and website buttons when no OpenTable data', (tester) async {
      final restaurant = Restaurant(
        fsqId: 'fsq_789',
        name: 'No OpenTable Restaurant',
        address: '', // Empty address so no search fallback
        latitude: 37.7650,
        longitude: -122.4294,
        priceTier: 1,
        cuisineTypes: ['Japanese'],
        createdAt: now,
        updatedAt: now,
        phone: '+1-415-555-0000',
        websiteUrl: 'https://example.com',
      );

      await tester.pumpWidget(buildTestWidget(restaurant));

      expect(find.text('Call'), findsOneWidget);
      expect(find.text('Website'), findsOneWidget);
    });

    testWidgets('shows nothing when no contact options available', (tester) async {
      final restaurant = Restaurant(
        fsqId: 'fsq_000',
        name: 'No Contact Restaurant',
        address: '',
        latitude: 37.7550,
        longitude: -122.4394,
        priceTier: 2,
        cuisineTypes: ['Thai'],
        createdAt: now,
        updatedAt: now,
      );

      await tester.pumpWidget(buildTestWidget(restaurant));

      expect(find.text('Reserve'), findsNothing);
      expect(find.text('Call'), findsNothing);
      expect(find.text('Website'), findsNothing);
    });

    testWidgets('compact mode shows icon button instead of text button', (tester) async {
      final restaurant = Restaurant(
        fsqId: 'fsq_compact',
        name: 'Compact Test',
        address: '789 Elm St',
        latitude: 37.7749,
        longitude: -122.4194,
        priceTier: 2,
        cuisineTypes: ['French'],
        createdAt: now,
        updatedAt: now,
        opentableId: 'ot_compact',
      );

      await tester.pumpWidget(buildTestWidget(restaurant, compact: true));

      // Should show icon button, not text button
      expect(find.text('Reserve'), findsNothing);
      expect(find.byIcon(Icons.calendar_today_rounded), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('tapping Reserve button triggers launch', (tester) async {
      when(() => mockLauncher.canLaunch(any())).thenAnswer((_) async => true);
      when(() => mockLauncher.launch(any(), mode: any(named: 'mode')))
          .thenAnswer((_) async => true);

      final restaurant = Restaurant(
        fsqId: 'fsq_tap',
        name: 'Tap Test Restaurant',
        address: '111 Test St',
        latitude: 37.7749,
        longitude: -122.4194,
        priceTier: 2,
        cuisineTypes: ['American'],
        createdAt: now,
        updatedAt: now,
        opentableId: 'ot_tap',
      );

      await tester.pumpWidget(buildTestWidget(restaurant));
      await tester.tap(find.text('Reserve'));
      await tester.pumpAndSettle();

      verify(() => mockLauncher.canLaunch(any())).called(greaterThan(0));
    });
  });
}
