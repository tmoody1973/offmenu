import 'dart:convert';
import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/google_places_service.dart';
import '../services/perplexity_service.dart';

/// Endpoint for personalized daily food stories.
///
/// Generates unique, editorial-quality stories daily based on
/// user profile, preferences, and cities.
class DailyStoryEndpoint extends Endpoint {
  /// Get today's personalized story for the current user.
  ///
  /// Returns cached story if already generated today, otherwise generates new.
  Future<DailyStory?> getDailyStory(Session session) async {
    final authenticated = session.authenticated;
    if (authenticated == null) {
      session.log('Daily Story: User not authenticated', level: LogLevel.warning);
      throw Exception('User must be authenticated');
    }

    final userId = authenticated.userIdentifier.toString();
    final today = _getTodayString();
    session.log('Daily Story: Checking for user $userId on $today');

    // Check if we already have a story for today
    final existing = await DailyStory.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId) & t.storyDate.equals(today),
    );

    if (existing != null) {
      session.log('Daily Story: Returning cached story "${existing.headline}"');
      return existing;
    }

    // Get user profile for personalization
    final profile = await UserProfile.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );

    if (profile == null) {
      session.log('Daily Story: No user profile found for userId=$userId', level: LogLevel.warning);
      return null;
    }

    session.log('Daily Story: Found profile - homeCity=${profile.homeCity}, onboardingCompleted=${profile.onboardingCompleted}');

    if (profile.homeCity == null || profile.homeCity!.isEmpty) {
      session.log('Daily Story: Profile has no homeCity set', level: LogLevel.warning);
      return null;
    }

    // Generate new story
    return await _generateStory(session, userId, profile);
  }

  /// Force refresh today's story (for testing/admin).
  Future<DailyStory?> refreshDailyStory(Session session) async {
    final authenticated = session.authenticated;
    if (authenticated == null) {
      throw Exception('User must be authenticated');
    }

    final userId = authenticated.userIdentifier.toString();
    final today = _getTodayString();

    // Delete existing story for today
    await DailyStory.db.deleteWhere(
      session,
      where: (t) => t.userId.equals(userId) & t.storyDate.equals(today),
    );

    // Get user profile
    final profile = await UserProfile.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );

    if (profile == null) {
      return null;
    }

    return await _generateStory(session, userId, profile);
  }

  /// Generate a new personalized daily story.
  Future<DailyStory?> _generateStory(
    Session session,
    String userId,
    UserProfile profile,
  ) async {
    session.log('Generating new daily story for user $userId');

    // 1. Pick a city (rotate through user's cities)
    final cityInfo = _pickCityForToday(profile);
    if (cityInfo == null) {
      session.log('No cities available for story generation');
      return null;
    }

    // 2. Determine story type based on profile
    final storyType = _pickStoryType(profile);
    session.log('Story type: ${storyType.name} for city: ${cityInfo['city']}');

    // 3. Parse cuisines user wants to explore
    final wantToTryCuisines = profile.wantToTryCuisines?.split(',') ?? [];

    // 4. Build Perplexity prompt and generate story
    final perplexityApiKey = session.serverpod.getPassword('PERPLEXITY_API_KEY');
    if (perplexityApiKey == null || perplexityApiKey.isEmpty) {
      session.log('Perplexity API key not configured', level: LogLevel.error);
      return null;
    }

    final perplexityService = PerplexityService(
      apiKey: perplexityApiKey,
      session: session,
    );

    try {
      final storyData = await _generateStoryWithPerplexity(
        session,
        perplexityService,
        cityInfo: cityInfo,
        storyType: storyType,
        philosophy: profile.foodPhilosophy,
        adventureLevel: profile.adventureLevel,
        wantToTryCuisines: wantToTryCuisines,
      );

      if (storyData == null) {
        session.log('Failed to generate story from Perplexity');
        return null;
      }

      // 5. Get restaurant photos from Google Places
      String heroImageUrl = 'https://images.unsplash.com/photo-1555126634-323283e090fa?w=800&q=80';
      String? thumbnailUrl;
      String? placeId;
      String? restaurantAddress;

      final googleApiKey = session.serverpod.getPassword('GOOGLE_PLACES_API_KEY');
      if (googleApiKey != null && googleApiKey.isNotEmpty) {
        final placesService = GooglePlacesService(
          apiKey: googleApiKey,
          session: session,
        );

        // Find the restaurant using text search
        final searchQuery = '${storyData['restaurantName']} ${cityInfo['city']} ${cityInfo['state'] ?? ''}';
        final placeResult = await placesService.searchAndGetDetails(searchQuery);

        if (placeResult != null) {
          placeId = placeResult['place_id'] as String?;
          restaurantAddress = placeResult['formatted_address'] as String?;

          // Get photos from the place result
          final photos = placeResult['photos'] as List<dynamic>? ?? [];
          if (photos.isNotEmpty && placeId != null) {
            // Photos are served via the web server, not the API server
            final serverBaseUrl = session.serverpod.getPassword('WEB_SERVER_PUBLIC_URL') ?? 'http://localhost:8082';
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

      // 6. Create and save the story
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

      final saved = await DailyStory.db.insertRow(session, story);
      session.log('Daily story saved: "${saved.headline}"');

      return saved;
    } finally {
      perplexityService.dispose();
    }
  }

  /// Pick a city for today's story, rotating through user's cities.
  Map<String, dynamic>? _pickCityForToday(UserProfile profile) {
    final cities = <Map<String, dynamic>>[];

    // Add home city
    if (profile.homeCity != null) {
      cities.add({
        'city': profile.homeCity!,
        'state': profile.homeState,
        'country': profile.homeCountry ?? 'USA',
      });
    }

    // Add additional cities
    if (profile.additionalCities != null && profile.additionalCities!.isNotEmpty) {
      try {
        final additionalList = jsonDecode(profile.additionalCities!) as List<dynamic>;
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

    if (cities.isEmpty) {
      return null;
    }

    // Rotate based on day of year
    final dayOfYear = DateTime.now().difference(DateTime(2024)).inDays;
    return cities[dayOfYear % cities.length];
  }

  /// Pick story type based on user preferences.
  DailyStoryType _pickStoryType(UserProfile profile) {
    final random = Random(DateTime.now().day); // Deterministic for the day

    // Weight story types based on user preferences
    final weights = <DailyStoryType, double>{};

    if (profile.foodPhilosophy == FoodPhilosophy.storyFirst) {
      // Story lovers get more legacy and chef stories
      weights[DailyStoryType.legacyStory] = 0.35;
      weights[DailyStoryType.chefSpotlight] = 0.25;
      weights[DailyStoryType.hiddenGem] = 0.15;
      weights[DailyStoryType.cuisineDeepDive] = 0.15;
      weights[DailyStoryType.neighborhoodGuide] = 0.05;
      weights[DailyStoryType.seasonalFeature] = 0.05;
    } else if (profile.adventureLevel == AdventureLevel.localExplorer) {
      // Local explorers get hidden gems and neighborhood guides
      weights[DailyStoryType.hiddenGem] = 0.40;
      weights[DailyStoryType.neighborhoodGuide] = 0.25;
      weights[DailyStoryType.legacyStory] = 0.15;
      weights[DailyStoryType.cuisineDeepDive] = 0.10;
      weights[DailyStoryType.chefSpotlight] = 0.05;
      weights[DailyStoryType.seasonalFeature] = 0.05;
    } else if (profile.adventureLevel == AdventureLevel.researcher) {
      // Researchers get deep dives
      weights[DailyStoryType.cuisineDeepDive] = 0.35;
      weights[DailyStoryType.chefSpotlight] = 0.25;
      weights[DailyStoryType.legacyStory] = 0.20;
      weights[DailyStoryType.hiddenGem] = 0.10;
      weights[DailyStoryType.neighborhoodGuide] = 0.05;
      weights[DailyStoryType.seasonalFeature] = 0.05;
    } else {
      // Default balanced weights
      weights[DailyStoryType.hiddenGem] = 0.25;
      weights[DailyStoryType.legacyStory] = 0.25;
      weights[DailyStoryType.cuisineDeepDive] = 0.15;
      weights[DailyStoryType.chefSpotlight] = 0.15;
      weights[DailyStoryType.neighborhoodGuide] = 0.10;
      weights[DailyStoryType.seasonalFeature] = 0.10;
    }

    // Weighted random selection
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

  /// Generate story content using Perplexity.
  Future<Map<String, dynamic>?> _generateStoryWithPerplexity(
    Session session,
    PerplexityService perplexityService, {
    required Map<String, dynamic> cityInfo,
    required DailyStoryType storyType,
    FoodPhilosophy? philosophy,
    AdventureLevel? adventureLevel,
    List<String>? wantToTryCuisines,
  }) async {
    final city = cityInfo['city'] as String;
    final state = cityInfo['state'] as String? ?? '';
    final location = state.isNotEmpty ? '$city, $state' : city;

    final prompt = _buildStoryPrompt(
      location: location,
      storyType: storyType,
      philosophy: philosophy,
      adventureLevel: adventureLevel,
      wantToTryCuisines: wantToTryCuisines,
    );

    session.log('Generating story with prompt for $location, type: ${storyType.name}');

    final response = await perplexityService.query(prompt);
    if (response.isEmpty) {
      return null;
    }

    return _parseStoryResponse(session, response);
  }

  /// Build the Perplexity prompt for story generation.
  String _buildStoryPrompt({
    required String location,
    required DailyStoryType storyType,
    FoodPhilosophy? philosophy,
    AdventureLevel? adventureLevel,
    List<String>? wantToTryCuisines,
  }) {
    final buffer = StringBuffer();

    buffer.writeln('You are a food journalist writing for a magazine like Eater or Bon Appetit.');
    buffer.writeln();

    // Story type specific instructions
    switch (storyType) {
      case DailyStoryType.legacyStory:
        buffer.writeln('Find a compelling LEGACY STORY restaurant in $location.');
        buffer.writeln('Look for: long-running family restaurants, immigrant stories, multi-generational establishments, restaurants with 10+ years of history.');
        buffer.writeln('Focus on the human story - the founder, the family, the journey.');
        break;

      case DailyStoryType.hiddenGem:
        buffer.writeln('Find a TRUE HIDDEN GEM restaurant in $location.');
        buffer.writeln('Look for: places without much online presence, no-sign spots, word-of-mouth favorites, restaurants in unexpected locations.');
        buffer.writeln('Not tourist traps or Instagram-famous spots.');
        break;

      case DailyStoryType.cuisineDeepDive:
        buffer.writeln('Find a restaurant in $location for a CUISINE DEEP DIVE story.');
        buffer.writeln('Explain what makes this city\'s version of a cuisine unique or different.');
        buffer.writeln('Focus on regional variations, immigrant influences, or technique differences.');
        break;

      case DailyStoryType.chefSpotlight:
        buffer.writeln('Find a restaurant in $location with a CHEF worth spotlighting.');
        buffer.writeln('Look for: trained chefs doing something interesting, career pivots, chefs returning to their roots.');
        buffer.writeln('Tell their story and what drives them.');
        break;

      case DailyStoryType.neighborhoodGuide:
        buffer.writeln('Find a restaurant that anchors an interesting FOOD NEIGHBORHOOD in $location.');
        buffer.writeln('Focus on an emerging food street/area or an established but underrated food district.');
        break;

      case DailyStoryType.seasonalFeature:
        buffer.writeln('Find a restaurant in $location doing something special RIGHT NOW.');
        buffer.writeln('Seasonal menu, limited-time dish, or something timely about the current moment.');
        break;
    }

    buffer.writeln();

    // User preferences
    if (philosophy == FoodPhilosophy.storyFirst) {
      buffer.writeln('User preference: They love the narrative behind food - the people, history, culture.');
    } else if (philosophy == FoodPhilosophy.dishFirst) {
      buffer.writeln('User preference: They focus on the food itself - flavors, technique, quality.');
    }

    if (wantToTryCuisines != null && wantToTryCuisines.isNotEmpty) {
      buffer.writeln('Cuisines they want to explore: ${wantToTryCuisines.join(", ")}');
      buffer.writeln('Consider featuring one of these cuisines if it fits the story type.');
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

  /// Parse the Perplexity response into story data.
  Map<String, dynamic>? _parseStoryResponse(Session session, String content) {
    try {
      String jsonStr = content.trim();

      // Remove markdown code blocks if present
      if (jsonStr.startsWith('```json')) {
        jsonStr = jsonStr.substring(7);
      } else if (jsonStr.startsWith('```')) {
        jsonStr = jsonStr.substring(3);
      }
      if (jsonStr.endsWith('```')) {
        jsonStr = jsonStr.substring(0, jsonStr.length - 3);
      }
      jsonStr = jsonStr.trim();

      // Find the JSON object
      final startIndex = jsonStr.indexOf('{');
      final endIndex = jsonStr.lastIndexOf('}');

      if (startIndex == -1 || endIndex == -1 || endIndex <= startIndex) {
        session.log('Could not find JSON in story response', level: LogLevel.warning);
        return null;
      }

      jsonStr = jsonStr.substring(startIndex, endIndex + 1);
      final parsed = jsonDecode(jsonStr) as Map<String, dynamic>;

      // Validate required fields
      if (parsed['restaurantName'] == null || parsed['headline'] == null) {
        session.log('Story response missing required fields', level: LogLevel.warning);
        return null;
      }

      return parsed;
    } catch (e) {
      session.log('Error parsing story response: $e', level: LogLevel.error);
      return null;
    }
  }

  /// Get today's date as YYYY-MM-DD string.
  String _getTodayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
