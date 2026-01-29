import 'package:flutter/material.dart';
import 'package:food_butler_client/food_butler_client.dart';
import 'package:go_router/go_router.dart';

import '../../main.dart';
import '../../theme/app_theme.dart';
import 'steps/location_step.dart';
import 'steps/philosophy_step.dart';
import 'steps/adventure_step.dart';
import 'steps/cuisine_step.dart';

/// Onboarding flow for new users.
///
/// Collects:
/// 1. Location - Home city for local recommendations
/// 2. Philosophy - Story vs dish preference
/// 3. Adventure Level - How they explore food
/// 4. Cuisine familiarity - What they know vs want to try
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isSubmitting = false;
  bool _isLoading = true;
  bool _isEditing = false; // True if editing existing preferences

  // Collected data
  String? _homeCity;
  String? _homeState;
  String? _homeCountry;
  double? _homeLatitude;
  double? _homeLongitude;
  FoodPhilosophy? _foodPhilosophy;
  AdventureLevel? _adventureLevel;
  List<String> _familiarCuisines = [];
  List<String> _wantToTryCuisines = [];

  static const _totalSteps = 4;

  @override
  void initState() {
    super.initState();
    _loadExistingProfile();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Load existing profile data if user has already onboarded.
  Future<void> _loadExistingProfile() async {
    try {
      final profile = await client.userProfile.getProfile();
      if (mounted && profile != null) {
        setState(() {
          _isEditing = profile.onboardingCompleted;
          _homeCity = profile.homeCity;
          _homeState = profile.homeState;
          _homeCountry = profile.homeCountry;
          _homeLatitude = profile.homeLatitude;
          _homeLongitude = profile.homeLongitude;
          _foodPhilosophy = profile.foodPhilosophy;
          _adventureLevel = profile.adventureLevel;

          // Parse comma-separated cuisines back to lists
          if (profile.familiarCuisines != null &&
              profile.familiarCuisines!.isNotEmpty) {
            _familiarCuisines = profile.familiarCuisines!.split(',');
          }
          if (profile.wantToTryCuisines != null &&
              profile.wantToTryCuisines!.isNotEmpty) {
            _wantToTryCuisines = profile.wantToTryCuisines!.split(',');
          }

          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Error loading existing profile: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    } else {
      _completeOnboarding();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    }
  }

  Future<void> _completeOnboarding() async {
    setState(() => _isSubmitting = true);

    try {
      await client.userProfile.saveProfile(
        foodPhilosophy: _foodPhilosophy,
        adventureLevel: _adventureLevel,
        familiarCuisines: _familiarCuisines,
        wantToTryCuisines: _wantToTryCuisines,
        homeCity: _homeCity,
        homeState: _homeState,
        homeCountry: _homeCountry,
        homeLatitude: _homeLatitude,
        homeLongitude: _homeLongitude,
        onboardingCompleted: true,
      );

      if (mounted) {
        if (_isEditing) {
          // Show success and go back to profile
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Preferences saved!'),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        } else {
          // First time onboarding - go to home
          context.go('/');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save preferences: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.charcoal,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.charcoal,
      appBar: AppBar(
        backgroundColor: AppTheme.charcoal,
        elevation: 0,
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousStep,
              )
            : (_isEditing
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                : null),
        title: Text(
          _isEditing ? 'Update Preferences' : 'Off Menu',
          style: AppTheme.headlineSerif.copyWith(fontSize: 20),
        ),
        actions: [
          // Skip button (only on non-essential steps)
          if (_currentStep > 0 && _currentStep < _totalSteps - 1)
            TextButton(
              onPressed: _nextStep,
              child: Text(
                'Skip',
                style: AppTheme.labelSans.copyWith(
                  color: AppTheme.creamMuted,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          _ProgressIndicator(
            currentStep: _currentStep,
            totalSteps: _totalSteps,
          ),

          // Content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Step 1: Location
                LocationStep(
                  initialCity: _homeCity,
                  onLocationSelected: (city, state, country, lat, lng) {
                    setState(() {
                      _homeCity = city;
                      _homeState = state;
                      _homeCountry = country;
                      _homeLatitude = lat;
                      _homeLongitude = lng;
                    });
                  },
                  onContinue: _nextStep,
                ),

                // Step 2: Food Philosophy
                PhilosophyStep(
                  selected: _foodPhilosophy,
                  onSelected: (philosophy) {
                    setState(() => _foodPhilosophy = philosophy);
                  },
                  onContinue: _nextStep,
                ),

                // Step 3: Adventure Level
                AdventureStep(
                  selected: _adventureLevel,
                  onSelected: (level) {
                    setState(() => _adventureLevel = level);
                  },
                  onContinue: _nextStep,
                ),

                // Step 4: Cuisine Preferences
                CuisineStep(
                  familiarCuisines: _familiarCuisines,
                  wantToTryCuisines: _wantToTryCuisines,
                  onFamiliarChanged: (cuisines) {
                    setState(() => _familiarCuisines = cuisines);
                  },
                  onWantToTryChanged: (cuisines) {
                    setState(() => _wantToTryCuisines = cuisines);
                  },
                  onContinue: _completeOnboarding,
                  isSubmitting: _isSubmitting,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Progress indicator showing current step.
class _ProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _ProgressIndicator({
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: List.generate(totalSteps, (index) {
          final isCompleted = index < currentStep;
          final isCurrent = index == currentStep;

          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: index < totalSteps - 1 ? 8 : 0),
              decoration: BoxDecoration(
                color: isCompleted || isCurrent
                    ? AppTheme.burntOrange
                    : AppTheme.charcoalLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}
