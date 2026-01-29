import 'package:flutter/material.dart';
import 'package:food_butler_client/food_butler_client.dart';
import 'package:go_router/go_router.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../main.dart';
import '../map/models/tour_stop_marker.dart';
import '../screens/ask_screen.dart';
import '../screens/create_map_screen.dart';
import '../screens/daily_screen.dart';
import '../screens/journal_screen.dart';
import '../screens/landing_screen.dart';
import '../screens/maps/map_detail_screen.dart';
import '../screens/maps/maps_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/profile_settings_screen.dart';
import '../screens/restaurant_detail_screen.dart';
import '../screens/saved_restaurants_screen.dart';
import '../screens/sign_in_screen.dart';
import '../screens/story_detail_screen.dart';
import '../screens/tour_form_screen.dart';
import '../screens/tour_results_screen.dart';
import '../widgets/app_shell.dart';

/// Application router configuration using GoRouter.
///
/// Uses StatefulShellRoute for persistent bottom navigation.
///
/// Main tabs:
/// - Home (The Daily)
/// - Maps (Browse/Create)
/// - Ask (AI Butler)
/// - Journal
/// - Profile
class AppRouter {
  AppRouter._();

  /// Global navigator key
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  /// Shell navigator key for bottom nav
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  /// Router configuration
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    // Redirect unauthenticated users to landing page
    redirect: (context, state) {
      final isAuthenticated = client.auth.isAuthenticated;
      final isLanding = state.matchedLocation == '/landing';
      final isSigningIn = state.matchedLocation == '/sign-in';
      final isOnboarding = state.matchedLocation == '/onboarding';

      // If not authenticated and not on landing/sign-in page, redirect to landing
      if (!isAuthenticated && !isLanding && !isSigningIn) {
        return '/landing';
      }

      return null; // No redirect needed
    },
    routes: [
      // Landing page for unauthenticated users
      GoRoute(
        path: '/landing',
        name: 'landing',
        builder: (context, state) => const LandingScreen(),
      ),

      // Sign in (outside shell - no bottom nav)
      GoRoute(
        path: '/sign-in',
        name: 'sign-in',
        builder: (context, state) => const SignInScreen(
          child: _SignInSuccess(),
        ),
      ),

      // Onboarding (outside shell - no bottom nav)
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Main app shell with bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Home / Daily
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                builder: (context, state) => const DailyScreen(),
              ),
            ],
          ),

          // Branch 1: Maps
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/maps',
                name: 'maps',
                builder: (context, state) => const MapsScreen(),
                routes: [
                  // Create Map
                  GoRoute(
                    path: 'create',
                    name: 'map-create',
                    builder: (context, state) => const CreateMapScreen(),
                  ),
                  // Map detail
                  GoRoute(
                    path: ':slug',
                    name: 'map-detail',
                    builder: (context, state) {
                      final slug = state.pathParameters['slug'];
                      if (slug == null) {
                        return const _ErrorScreen(message: 'Invalid map slug');
                      }
                      return MapDetailScreen(slug: slug);
                    },
                  ),
                ],
              ),
            ],
          ),

          // Branch 2: Ask
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/ask',
                name: 'ask',
                builder: (context, state) {
                  final extra = state.extra as Map<String, dynamic>?;
                  return AskScreen(
                    initialPrompt: extra?['prompt'] as String?,
                  );
                },
              ),
            ],
          ),

          // Branch 3: Journal
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/journal',
                name: 'journal',
                builder: (context, state) => const JournalScreen(),
                routes: [
                  // Journal entry detail
                  GoRoute(
                    path: 'entry/:id',
                    name: 'journal-entry',
                    builder: (context, state) {
                      final id = state.pathParameters['id'];
                      if (id == null) {
                        return const _ErrorScreen(message: 'Invalid entry ID');
                      }
                      return JournalEntryDetailScreen(
                        entryId: int.parse(id),
                      );
                    },
                  ),

                  // New journal entry
                  GoRoute(
                    path: 'new',
                    name: 'journal-new',
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>?;
                      return NewJournalEntryScreen(
                        restaurantId: extra?['restaurantId'] as int?,
                        restaurantName: extra?['restaurantName'] as String?,
                      );
                    },
                  ),

                  // Restaurant visits detail
                  GoRoute(
                    path: 'restaurant/:id',
                    name: 'journal-restaurant',
                    builder: (context, state) {
                      final id = state.pathParameters['id'];
                      if (id == null) {
                        return const _ErrorScreen(message: 'Invalid restaurant ID');
                      }
                      return _RestaurantEntriesScreen(
                        restaurantId: int.parse(id),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          // Branch 4: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfileSettingsScreen(),
              ),
            ],
          ),
        ],
      ),

      // Routes outside the shell (full-screen, no bottom nav)

      // Tour creation flow
      GoRoute(
        path: '/tour/create',
        name: 'tour-create',
        builder: (context, state) => const TourFormScreen(),
      ),

      // Tour results
      GoRoute(
        path: '/tour/results',
        name: 'tour-results',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          if (extra == null ||
              !extra.containsKey('tourResult') ||
              !extra.containsKey('transportMode')) {
            return const _ErrorScreen(
              message: 'Missing tour data. Please generate a tour first.',
            );
          }

          return TourResultsScreen(
            tourResult: extra['tourResult'] as TourResult,
            transportMode: extra['transportMode'] as TransportMode,
          );
        },
      ),

      // Restaurant detail
      GoRoute(
        path: '/restaurant/:id',
        name: 'restaurant-detail',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          final extra = state.extra as Map<String, dynamic>?;
          final stop = extra?['stop'] as TourStopMarker?;

          return RestaurantDetailScreen(
            stop: stop,
            restaurantId: id != null ? int.tryParse(id) : null,
          );
        },
      ),

      // Story detail (Daily Story full narrative view)
      GoRoute(
        path: '/story',
        name: 'story-detail',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final story = extra?['story'] as DailyStory?;

          if (story == null) {
            return const _ErrorScreen(message: 'Story not found');
          }

          return StoryDetailScreen(story: story);
        },
      ),

      // Saved restaurants
      GoRoute(
        path: '/saved',
        name: 'saved-restaurants',
        builder: (context, state) => const SavedRestaurantsScreen(),
      ),
    ],

    // Error handling
    errorBuilder: (context, state) => _ErrorScreen(
      message: state.error?.message ?? 'Page not found',
    ),
  );
}

/// Simple error screen for routing errors
class _ErrorScreen extends StatelessWidget {
  final String message;

  const _ErrorScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 24),
              Text(
                'Oops!',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.home),
                label: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Success screen after sign-in - redirects to onboarding or home
class _SignInSuccess extends StatefulWidget {
  const _SignInSuccess();

  @override
  State<_SignInSuccess> createState() => _SignInSuccessState();
}

class _SignInSuccessState extends State<_SignInSuccess> {
  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    // Small delay to ensure auth is fully initialized
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    try {
      // Check if user has completed onboarding
      final hasCompleted = await client.userProfile.hasCompletedOnboarding();

      if (!mounted) return;

      if (hasCompleted) {
        // User has onboarded, go to home
        context.go('/');
      } else {
        // New user or incomplete onboarding, go to onboarding flow
        context.go('/onboarding');
      }
    } catch (e) {
      // If API call fails (e.g., endpoint not generated yet), go to onboarding
      // This handles the case where serverpod generate hasn't been run
      debugPrint('Onboarding check failed: $e');
      if (mounted) {
        context.go('/onboarding');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

/// Placeholder screen for restaurant entries list
class _RestaurantEntriesScreen extends StatelessWidget {
  final int restaurantId;

  const _RestaurantEntriesScreen({required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Visits'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Restaurant #$restaurantId',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Visit history would be displayed here.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
