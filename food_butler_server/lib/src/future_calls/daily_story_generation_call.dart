import 'dart:convert';
import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/google_places_service.dart';
import '../services/perplexity_service.dart';

/// FutureCall that pre-generates daily stories for all users.
///
/// Runs daily at 5 AM to ensure users have fresh stories when they wake up.
/// Stories are personalized based on user profiles and preferences.
class DailyStoryGenerationCall extends FutureCall<EmptyData> {
  /// The hour to run the daily generation (5 AM).
  static const int runHour = 5;

  @override
  Future<void> invoke(Session session, EmptyData? object) async {
    session.log('DailyStoryGenerationCall started at ${DateTime.now()}');

    try {
      await _generateStoriesForAllUsers(session);
    } catch (e, stackTrace) {
      session.log(
        'Error in DailyStoryGenerationCall: $e\n$stackTrace',
        level: LogLevel.error,
      );
    }

    // Reschedule for tomorrow at 5 AM
    await _scheduleNextRun(session);
  }

  /// Generate stories for all users with completed profiles.
  Future<void> _generateStoriesForAllUsers(Session session) async {
    final today = _getTodayString();

    // Get all users with completed onboarding and a home city
    final profiles = await UserProfile.db.find(
      session,
      where: (t) =>
          t.onboardingCompleted.equals(true) &
          t.homeCity.notEquals(null),
    );

    session.log('Found ${profiles.length} users with completed profiles');

    if (profiles.isEmpty) return;

    // Get API keys
    final perplexityApiKey = session.serverpod.getPassword('PERPLEXITY_API_KEY');
    final googleApiKey = session.serverpod.getPassword('GOOGLE_PLACES_API_KEY');

    if (perplexityApiKey == null || perplexityApiKey.isEmpty) {
      session.log('Perplexity API key not configured', level: LogLevel.error);
      return;
    }

    int generated = 0;
    int skipped = 0;
    int failed = 0;

    for (final profile in profiles) {
      try {
        // Check if user already has a story for today
        final existing = await DailyStory.db.findFirstRow(
          session,
          where: (t) =>
              t.userId.equals(profile.userId) & t.storyDate.equals(today),
        );

        if (existing != null) {
          skipped++;
          continue;
        }

        // Generate story for this user
        await _generateStoryForUser(
          session,
          profile,
          perplexityApiKey: perplexityApiKey,
          googleApiKey: googleApiKey,
        );
        generated++;

        // Small delay between users to avoid rate limiting
        await Future.delayed(const Duration(seconds: 2));
      } catch (e) {
        session.log('Failed to generate story for user ${profile.userId}: $e');
        failed++;
      }
    }

    session.log(
      'Daily story generation complete: $generated generated, $skipped skipped (already had), $failed failed',
    );
  }

  /// Generate a story for a single user.
  Future<void> _generateStoryForUser(
    Session session,
    UserProfile profile, {
    required String perplexityApiKey,
    String? googleApiKey,
  }) async {
    final userId = profile.userId;

    // Pick a city for today
    final cityInfo = _pickCityForToday(profile);
    if (cityInfo == null) {
      session.log('No cities available for user $userId');
      return;
    }

    // Pick story type based on preferences
    final storyType = _pickStoryType(profile);

    session.log(
      'Generating ${storyType.name} story for user $userId in ${cityInfo['city']}',
    );

    final perplexityService = PerplexityService(
      apiKey: perplexityApiKey,
      session: session,
    );

    try {
      // Build and send prompt
      final prompt = _buildStoryPrompt(
        location: cityInfo['state'] != null
            ? "${cityInfo['city']}, ${cityInfo['state']}"
            : cityInfo['city'] as String,
        storyType: storyType,
        philosophy: profile.foodPhilosophy,
        adventureLevel: profile.adventureLevel,
        wantToTryCuisines: profile.wantToTryCuisines?.split(','),
      );

      final response = await perplexityService.query(prompt);
      if (response.isEmpty) {
        session.log('Empty response from Perplexity for user $userId');
        return;
      }

      final storyData = _parseStoryResponse(session, response);
      if (storyData == null) {
        session.log('Failed to parse story for user $userId');
        return;
      }

      // Get restaurant photos from Google Places
      String heroImageUrl =
          'https://images.unsplash.com/photo-1555126634-323283e090fa?w=800&q=80';
      String? thumbnailUrl;
      String? placeId;
      String? restaurantAddress;

      if (googleApiKey != null && googleApiKey.isNotEmpty) {
        final placesService = GooglePlacesService(
          apiKey: googleApiKey,
          session: session,
        );

        final searchQuery =
            '${storyData['restaurantName']} ${cityInfo['city']} ${cityInfo['state'] ?? ''}';
        final placeResult = await placesService.searchAndGetDetails(searchQuery);

        if (placeResult != null) {
          placeId = placeResult['place_id'] as String?;
          restaurantAddress = placeResult['formatted_address'] as String?;

          final photos = placeResult['photos'] as List<dynamic>? ?? [];
          if (photos.isNotEmpty && placeId != null) {
            final serverBaseUrl =
                session.serverpod.getPassword('WEB_SERVER_PUBLIC_URL') ??
                    'http://localhost:8082';
            final photosList = await placesService.getPlacePhotos(
              placeId,
              maxPhotos: 2,
              serverBaseUrl: serverBaseUrl,
            );

            if (photosList.isNotEmpty) {
              heroImageUrl = photosList[0]['url'] as String? ?? heroImageUrl;
              if (photosList.length > 1) {
                thumbnailUrl = photosList[1]['thumbnailUrl'] as String?;
              }
            }
          }
        }
      }

      // Save the story
      final story = DailyStory(
        userId: userId,
        storyDate: _getTodayString(),
        city: cityInfo['city'] as String,
        state: cityInfo['state'] as String?,
        country: cityInfo['country'] as String?,
        headline: storyData['headline'] as String,
        subheadline: storyData['subheadline'] as String,
        bodyText: storyData['bodyText'] as String?,
        restaurantName: storyData['restaurantName'] as String,
        restaurantAddress: restaurantAddress,
        restaurantPlaceId: placeId,
        heroImageUrl: heroImageUrl,
        thumbnailUrl: thumbnailUrl,
        storyType: storyType,
        cuisineType: storyData['cuisineType'] as String?,
        sourceUrl: storyData['sourceUrl'] as String?,
        createdAt: DateTime.now().toUtc(),
      );

      await DailyStory.db.insertRow(session, story);
      session.log('Saved story "${story.headline}" for user $userId');
    } finally {
      perplexityService.dispose();
    }
  }

  /// Schedule the next run for tomorrow at 5 AM.
  Future<void> _scheduleNextRun(Session session) async {
    final now = DateTime.now();
    var nextRun = DateTime(now.year, now.month, now.day, runHour, 0, 0);

    // If it's already past 5 AM today, schedule for tomorrow
    if (now.hour >= runHour) {
      nextRun = nextRun.add(const Duration(days: 1));
    }

    session.log('Scheduling next DailyStoryGenerationCall for $nextRun');

    await session.serverpod.futureCallAtTime(
      'dailyStoryGeneration',
      null,
      nextRun,
    );
  }

  /// Get today's date as YYYY-MM-DD string.
  String _getTodayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// Pick a city for today's story.
  Map<String, dynamic>? _pickCityForToday(UserProfile profile) {
    final cities = <Map<String, dynamic>>[];

    if (profile.homeCity != null) {
      cities.add({
        'city': profile.homeCity!,
        'state': profile.homeState,
        'country': profile.homeCountry ?? 'USA',
      });
    }

    if (profile.additionalCities != null &&
        profile.additionalCities!.isNotEmpty) {
      try {
        final additionalList =
            jsonDecode(profile.additionalCities!) as List<dynamic>;
        for (final c in additionalList) {
          if (c is Map<String, dynamic>) {
            cities.add({
              'city': c['city'] as String? ?? '',
              'state': c['state'] as String?,
              'country': c['country'] as String? ?? 'USA',
            });
          }
        }
      } catch (e) {
        // Ignore parsing errors
      }
    }

    if (cities.isEmpty) return null;

    final dayOfYear = DateTime.now().difference(DateTime(2024)).inDays;
    return cities[dayOfYear % cities.length];
  }

  /// Pick story type based on user preferences.
  DailyStoryType _pickStoryType(UserProfile profile) {
    final random = Random(DateTime.now().day);

    final weights = <DailyStoryType, double>{};

    if (profile.foodPhilosophy == FoodPhilosophy.storyFirst) {
      weights[DailyStoryType.legacyStory] = 0.35;
      weights[DailyStoryType.chefSpotlight] = 0.25;
      weights[DailyStoryType.hiddenGem] = 0.15;
      weights[DailyStoryType.cuisineDeepDive] = 0.15;
      weights[DailyStoryType.neighborhoodGuide] = 0.05;
      weights[DailyStoryType.seasonalFeature] = 0.05;
    } else if (profile.adventureLevel == AdventureLevel.localExplorer) {
      weights[DailyStoryType.hiddenGem] = 0.40;
      weights[DailyStoryType.neighborhoodGuide] = 0.25;
      weights[DailyStoryType.legacyStory] = 0.15;
      weights[DailyStoryType.cuisineDeepDive] = 0.10;
      weights[DailyStoryType.chefSpotlight] = 0.05;
      weights[DailyStoryType.seasonalFeature] = 0.05;
    } else if (profile.adventureLevel == AdventureLevel.researcher) {
      weights[DailyStoryType.cuisineDeepDive] = 0.35;
      weights[DailyStoryType.chefSpotlight] = 0.25;
      weights[DailyStoryType.legacyStory] = 0.20;
      weights[DailyStoryType.hiddenGem] = 0.10;
      weights[DailyStoryType.neighborhoodGuide] = 0.05;
      weights[DailyStoryType.seasonalFeature] = 0.05;
    } else {
      weights[DailyStoryType.hiddenGem] = 0.25;
      weights[DailyStoryType.legacyStory] = 0.25;
      weights[DailyStoryType.cuisineDeepDive] = 0.15;
      weights[DailyStoryType.chefSpotlight] = 0.15;
      weights[DailyStoryType.neighborhoodGuide] = 0.10;
      weights[DailyStoryType.seasonalFeature] = 0.10;
    }

    final roll = random.nextDouble();
    var cumulative = 0.0;

    for (final entry in weights.entries) {
      cumulative += entry.value;
      if (roll <= cumulative) {
        return entry.key;
      }
    }

    return DailyStoryType.hiddenGem;
  }

  /// Build the Perplexity prompt.
  String _buildStoryPrompt({
    required String location,
    required DailyStoryType storyType,
    FoodPhilosophy? philosophy,
    AdventureLevel? adventureLevel,
    List<String>? wantToTryCuisines,
  }) {
    final buffer = StringBuffer();

    buffer.writeln(
        'You are a food journalist writing for a magazine like Eater or Bon Appetit.');
    buffer.writeln();

    switch (storyType) {
      case DailyStoryType.legacyStory:
        buffer.writeln('Find a compelling LEGACY STORY restaurant in $location.');
        buffer.writeln(
            'Look for: long-running family restaurants, immigrant stories, multi-generational establishments, restaurants with 10+ years of history.');
        buffer.writeln(
            'Focus on the human story - the founder, the family, the journey.');
        break;

      case DailyStoryType.hiddenGem:
        buffer.writeln('Find a TRUE HIDDEN GEM restaurant in $location.');
        buffer.writeln(
            'Look for: places without much online presence, no-sign spots, word-of-mouth favorites, restaurants in unexpected locations.');
        buffer.writeln('Not tourist traps or Instagram-famous spots.');
        break;

      case DailyStoryType.cuisineDeepDive:
        buffer
            .writeln('Find a restaurant in $location for a CUISINE DEEP DIVE story.');
        buffer.writeln(
            "Explain what makes this city's version of a cuisine unique or different.");
        buffer.writeln(
            'Focus on regional variations, immigrant influences, or technique differences.');
        break;

      case DailyStoryType.chefSpotlight:
        buffer.writeln(
            'Find a restaurant in $location with a CHEF worth spotlighting.');
        buffer.writeln(
            'Look for: trained chefs doing something interesting, career pivots, chefs returning to their roots.');
        buffer.writeln('Tell their story and what drives them.');
        break;

      case DailyStoryType.neighborhoodGuide:
        buffer.writeln(
            'Find a restaurant that anchors an interesting FOOD NEIGHBORHOOD in $location.');
        buffer.writeln(
            'Focus on an emerging food street/area or an established but underrated food district.');
        break;

      case DailyStoryType.seasonalFeature:
        buffer
            .writeln('Find a restaurant in $location doing something special RIGHT NOW.');
        buffer.writeln(
            'Seasonal menu, limited-time dish, or something timely about the current moment.');
        break;
    }

    buffer.writeln();

    if (philosophy == FoodPhilosophy.storyFirst) {
      buffer.writeln(
          'User preference: They love the narrative behind food - the people, history, culture.');
    } else if (philosophy == FoodPhilosophy.dishFirst) {
      buffer.writeln(
          'User preference: They focus on the food itself - flavors, technique, quality.');
    }

    if (wantToTryCuisines != null && wantToTryCuisines.isNotEmpty) {
      buffer.writeln(
          'Cuisines they want to explore: ${wantToTryCuisines.join(", ")}');
      buffer.writeln(
          'Consider featuring one of these cuisines if it fits the story type.');
    }

    buffer.writeln();
    buffer.writeln('Requirements:');
    buffer.writeln('1. Must be a REAL restaurant that currently exists');
    buffer.writeln('2. Include specific details that make it feel authentic');
    buffer.writeln('3. The restaurant should feel special, not generic');
    buffer.writeln();
    buffer.writeln('Respond ONLY with valid JSON in this exact format:');
    buffer.writeln('''
{
  "restaurantName": "exact restaurant name",
  "headline": "compelling 8-15 word headline in magazine style",
  "subheadline": "1-2 sentence teaser that hooks the reader",
  "bodyText": "2-3 paragraph full story (optional, can be null)",
  "cuisineType": "type of cuisine",
  "sourceUrl": "article or review URL if available (can be null)"
}''');

    return buffer.toString();
  }

  /// Parse story response from Perplexity.
  Map<String, dynamic>? _parseStoryResponse(Session session, String content) {
    try {
      String jsonStr = content.trim();

      if (jsonStr.startsWith('```json')) {
        jsonStr = jsonStr.substring(7);
      } else if (jsonStr.startsWith('```')) {
        jsonStr = jsonStr.substring(3);
      }
      if (jsonStr.endsWith('```')) {
        jsonStr = jsonStr.substring(0, jsonStr.length - 3);
      }
      jsonStr = jsonStr.trim();

      final startIndex = jsonStr.indexOf('{');
      final endIndex = jsonStr.lastIndexOf('}');

      if (startIndex == -1 || endIndex == -1 || endIndex <= startIndex) {
        return null;
      }

      jsonStr = jsonStr.substring(startIndex, endIndex + 1);
      final parsed = jsonDecode(jsonStr) as Map<String, dynamic>;

      if (parsed['restaurantName'] == null || parsed['headline'] == null) {
        return null;
      }

      return parsed;
    } catch (e) {
      session.log('Error parsing story response: $e', level: LogLevel.error);
      return null;
    }
  }
}
