import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Endpoint for managing user profile, preferences, and onboarding.
class UserProfileEndpoint extends Endpoint {
  /// Get the current user's profile.
  /// Returns null if no profile exists (user hasn't onboarded).
  Future<UserProfile?> getProfile(Session session) async {
    final authenticated = session.authenticated;
    if (authenticated == null) {
      throw Exception('User must be authenticated');
    }

    final userId = authenticated.userIdentifier.toString();

    return await UserProfile.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );
  }

  /// Check if the current user has completed onboarding.
  Future<bool> hasCompletedOnboarding(Session session) async {
    final profile = await getProfile(session);
    return profile?.onboardingCompleted ?? false;
  }

  /// Create or update user profile.
  /// Called during onboarding to save user's choices.
  Future<UserProfile> saveProfile(
    Session session, {
    FoodPhilosophy? foodPhilosophy,
    AdventureLevel? adventureLevel,
    List<String>? familiarCuisines,
    List<String>? wantToTryCuisines,
    List<String>? dietaryRestrictions,
    String? homeCity,
    String? homeState,
    String? homeCountry,
    double? homeLatitude,
    double? homeLongitude,
    String? additionalCities,
    bool? onboardingCompleted,
  }) async {
    final authenticated = session.authenticated;
    if (authenticated == null) {
      throw Exception('User must be authenticated');
    }

    final userId = authenticated.userIdentifier.toString();
    final now = DateTime.now().toUtc();

    // Check if profile already exists
    var existing = await UserProfile.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );

    if (existing != null) {
      // Update existing profile
      final updated = existing.copyWith(
        foodPhilosophy: foodPhilosophy ?? existing.foodPhilosophy,
        adventureLevel: adventureLevel ?? existing.adventureLevel,
        familiarCuisines: familiarCuisines?.join(',') ?? existing.familiarCuisines,
        wantToTryCuisines: wantToTryCuisines?.join(',') ?? existing.wantToTryCuisines,
        dietaryRestrictions: dietaryRestrictions?.join(',') ?? existing.dietaryRestrictions,
        homeCity: homeCity ?? existing.homeCity,
        homeState: homeState ?? existing.homeState,
        homeCountry: homeCountry ?? existing.homeCountry,
        homeLatitude: homeLatitude ?? existing.homeLatitude,
        homeLongitude: homeLongitude ?? existing.homeLongitude,
        additionalCities: additionalCities ?? existing.additionalCities,
        onboardingCompleted: onboardingCompleted ?? existing.onboardingCompleted,
        updatedAt: now,
      );

      return await UserProfile.db.updateRow(session, updated);
    } else {
      // Create new profile
      final profile = UserProfile(
        userId: userId,
        foodPhilosophy: foodPhilosophy,
        adventureLevel: adventureLevel,
        familiarCuisines: familiarCuisines?.join(','),
        wantToTryCuisines: wantToTryCuisines?.join(','),
        dietaryRestrictions: dietaryRestrictions?.join(','),
        homeCity: homeCity,
        homeState: homeState,
        homeCountry: homeCountry,
        homeLatitude: homeLatitude,
        homeLongitude: homeLongitude,
        additionalCities: additionalCities,
        onboardingCompleted: onboardingCompleted ?? false,
        createdAt: now,
        updatedAt: now,
      );

      return await UserProfile.db.insertRow(session, profile);
    }
  }

  /// Complete onboarding - marks profile as complete.
  Future<UserProfile> completeOnboarding(Session session) async {
    return await saveProfile(session, onboardingCompleted: true);
  }

  /// Update just the user's home location.
  Future<UserProfile> updateLocation(
    Session session, {
    required String city,
    String? state,
    String? country,
    double? latitude,
    double? longitude,
  }) async {
    return await saveProfile(
      session,
      homeCity: city,
      homeState: state,
      homeCountry: country,
      homeLatitude: latitude,
      homeLongitude: longitude,
    );
  }

  /// Update food philosophy preference.
  Future<UserProfile> updateFoodPhilosophy(
    Session session,
    FoodPhilosophy philosophy,
  ) async {
    return await saveProfile(session, foodPhilosophy: philosophy);
  }

  /// Update adventure level preference.
  Future<UserProfile> updateAdventureLevel(
    Session session,
    AdventureLevel level,
  ) async {
    return await saveProfile(session, adventureLevel: level);
  }

  /// Update cuisine preferences.
  Future<UserProfile> updateCuisinePreferences(
    Session session, {
    List<String>? familiar,
    List<String>? wantToTry,
  }) async {
    return await saveProfile(
      session,
      familiarCuisines: familiar,
      wantToTryCuisines: wantToTry,
    );
  }

  /// Update dietary restrictions.
  Future<UserProfile> updateDietaryRestrictions(
    Session session,
    List<String> restrictions,
  ) async {
    return await saveProfile(session, dietaryRestrictions: restrictions);
  }

  /// Update additional cities for personalized content.
  /// Cities should be a JSON string array.
  Future<UserProfile> updateAdditionalCities(
    Session session,
    String citiesJson,
  ) async {
    return await saveProfile(session, additionalCities: citiesJson);
  }

  /// Debug endpoint to check profile status for Daily Story.
  /// Returns a diagnostic summary of what's needed for Daily Story to work.
  Future<Map<String, dynamic>> debugProfileStatus(Session session) async {
    final authenticated = session.authenticated;
    if (authenticated == null) {
      return {
        'error': 'Not authenticated',
        'dailyStoryReady': false,
      };
    }

    final userId = authenticated.userIdentifier.toString();
    final profile = await UserProfile.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );

    if (profile == null) {
      return {
        'userId': userId,
        'hasProfile': false,
        'dailyStoryReady': false,
        'message': 'No profile found. Complete onboarding first.',
      };
    }

    final hasHomeCity = profile.homeCity != null && profile.homeCity!.isNotEmpty;
    final dailyStoryReady = profile.onboardingCompleted && hasHomeCity;

    return {
      'userId': userId,
      'hasProfile': true,
      'onboardingCompleted': profile.onboardingCompleted,
      'homeCity': profile.homeCity,
      'homeState': profile.homeState,
      'hasHomeCity': hasHomeCity,
      'foodPhilosophy': profile.foodPhilosophy?.name,
      'adventureLevel': profile.adventureLevel?.name,
      'dailyStoryReady': dailyStoryReady,
      'message': dailyStoryReady
          ? 'Profile ready for Daily Story'
          : hasHomeCity
              ? 'Complete onboarding to enable Daily Story'
              : 'Set your home city to enable Daily Story',
    };
  }
}
