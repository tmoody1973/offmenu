import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/google_places_service.dart';
import '../services/perplexity_service.dart';
import '../services/weather_service.dart';

/// Endpoint for "Three for Tonight" - context-aware quick picks.
///
/// Returns 3 restaurant recommendations based on:
/// - Time of day (breakfast/lunch/dinner/late-night)
/// - Current weather conditions
/// - User's cuisine preferences
/// - User's selected city
///
/// Caching: Picks are cached per user per day per meal context.
/// New picks are generated when meal context changes (breakfast -> lunch -> dinner).
class ThreeForTonightEndpoint extends Endpoint {
  /// Get three contextual restaurant picks for tonight.
  ///
  /// [cityName] - The city to search in
  /// [stateOrRegion] - Optional state/region for more accurate results
  /// [latitude] - Optional latitude for weather data
  /// [longitude] - Optional longitude for weather data
  /// [forceRefresh] - If true, bypass cache and generate fresh picks
  Future<List<TonightPick>> getThreeForTonight(
    Session session, {
    required String cityName,
    String? stateOrRegion,
    double? latitude,
    double? longitude,
    bool? forceRefresh,
  }) async {
    final shouldRefresh = forceRefresh ?? false;
    session.log('Getting Three for Tonight in $cityName');

    // Determine meal context based on time
    final mealContext = _getMealContext();
    session.log('Meal context: ${mealContext.name} (${mealContext.description})');

    // Check cache first (if user is authenticated and not forcing refresh)
    final authenticated = session.authenticated;
    if (authenticated != null && !shouldRefresh) {
      final userId = authenticated.userIdentifier.toString();
      final cachedPicks = await _getCachedPicks(session, userId, cityName, mealContext);
      if (cachedPicks != null && cachedPicks.isNotEmpty) {
        session.log('Returning ${cachedPicks.length} cached picks for $cityName');
        return cachedPicks;
      }
    }

    // Get user preferences if authenticated
    String? cuisinePreferences;
    String? dietaryRestrictions;
    double? userLat = latitude;
    double? userLng = longitude;

    if (authenticated != null) {
      final userId = authenticated.userIdentifier.toString();
      final profile = await UserProfile.db.findFirstRow(
        session,
        where: (t) => t.userId.equals(userId),
      );
      if (profile != null) {
        // Combine familiar cuisines and cuisines they want to try
        final familiar = profile.familiarCuisines ?? '';
        final wantToTry = profile.wantToTryCuisines ?? '';
        if (familiar.isNotEmpty || wantToTry.isNotEmpty) {
          cuisinePreferences = [familiar, wantToTry]
              .where((s) => s.isNotEmpty)
              .join(', ');
        }
        dietaryRestrictions = profile.dietaryRestrictions;

        // Use profile coordinates if not provided
        userLat ??= profile.homeLatitude;
        userLng ??= profile.homeLongitude;
      }
    }

    // Get current weather if we have coordinates
    WeatherData? weather;
    if (userLat != null && userLng != null) {
      final weatherService = WeatherService(session: session);
      weather = await weatherService.getCurrentWeather(
        latitude: userLat,
        longitude: userLng,
      );
    }

    // Get API keys
    final perplexityApiKey = session.serverpod.getPassword('PERPLEXITY_API_KEY');
    if (perplexityApiKey == null || perplexityApiKey.isEmpty) {
      session.log('Perplexity API key not configured', level: LogLevel.error);
      return [];
    }

    final perplexity = PerplexityService(
      apiKey: perplexityApiKey,
      session: session,
    );

    try {
      // Build the prompt
      final location = stateOrRegion != null
          ? '$cityName, $stateOrRegion'
          : cityName;

      final prompt = _buildPrompt(
        location: location,
        mealContext: mealContext,
        cuisinePreferences: cuisinePreferences,
        dietaryRestrictions: dietaryRestrictions,
        weather: weather,
      );

      session.log('Querying Perplexity for tonight picks...');
      final response = await perplexity.queryWithImages(prompt);

      if (response.content.isEmpty) {
        session.log('Empty response from Perplexity');
        return [];
      }

      // Parse the response
      final picks = _parseResponse(session, response.content, response.images);

      if (picks.isEmpty) {
        session.log('No picks parsed from response');
        return [];
      }

      // Enrich with Google Places data
      final googleApiKey = session.serverpod.getPassword('GOOGLE_PLACES_API_KEY');
      if (googleApiKey != null && googleApiKey.isNotEmpty) {
        final placesService = GooglePlacesService(
          apiKey: googleApiKey,
          session: session,
        );
        final serverBaseUrl = session.serverpod.getPassword('WEB_SERVER_PUBLIC_URL') ??
                              'http://localhost:8082';

        for (var i = 0; i < picks.length; i++) {
          try {
            final searchQuery = '${picks[i].name} $location';
            final placeDetails = await placesService.searchAndGetDetails(searchQuery);

            if (placeDetails != null) {
              // Get photo URL
              String? photoUrl;
              final photos = placeDetails['photos'] as List<dynamic>?;
              if (photos != null && photos.isNotEmpty) {
                final photoRef = photos[0]['photo_reference'] as String?;
                if (photoRef != null) {
                  photoUrl = '$serverBaseUrl/api/photos/$photoRef';
                }
              }

              // Update the pick with Google data
              picks[i] = TonightPick(
                name: picks[i].name,
                hook: picks[i].hook,
                cuisineType: picks[i].cuisineType,
                imageUrl: photoUrl ?? picks[i].imageUrl,
                placeId: placeDetails['place_id'] as String?,
                address: placeDetails['formatted_address'] as String?,
                rating: (placeDetails['rating'] as num?)?.toDouble(),
                priceLevel: placeDetails['price_level'] as int?,
              );
            }
          } catch (e) {
            session.log('Failed to enrich ${picks[i].name}: $e');
          }
        }
      }

      session.log('Returning ${picks.length} picks for tonight');

      // Cache the picks for this user/day/meal context
      if (authenticated != null && picks.isNotEmpty) {
        final userId = authenticated.userIdentifier.toString();
        await _cachePicks(session, userId, cityName, stateOrRegion, mealContext, picks);
      }

      return picks;
    } finally {
      perplexity.dispose();
    }
  }

  /// Get cached picks for today if available.
  Future<List<TonightPick>?> _getCachedPicks(
    Session session,
    String userId,
    String cityName,
    _MealContext mealContext,
  ) async {
    final today = _getTodayString();

    final cached = await TonightPicksCache.db.findFirstRow(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.cacheDate.equals(today) &
          t.city.equals(cityName) &
          t.mealContext.equals(mealContext.name),
    );

    if (cached == null) return null;

    try {
      final picksData = jsonDecode(cached.picksJson) as List<dynamic>;
      return picksData.map((p) {
        final map = p as Map<String, dynamic>;
        return TonightPick(
          name: map['name'] as String,
          hook: map['hook'] as String,
          cuisineType: map['cuisineType'] as String?,
          imageUrl: map['imageUrl'] as String?,
          placeId: map['placeId'] as String?,
          address: map['address'] as String?,
          rating: (map['rating'] as num?)?.toDouble(),
          priceLevel: map['priceLevel'] as int?,
        );
      }).toList();
    } catch (e) {
      session.log('Error parsing cached picks: $e');
      return null;
    }
  }

  /// Cache picks for this user/day/meal context.
  Future<void> _cachePicks(
    Session session,
    String userId,
    String cityName,
    String? state,
    _MealContext mealContext,
    List<TonightPick> picks,
  ) async {
    final today = _getTodayString();

    // Convert picks to JSON
    final picksJson = jsonEncode(picks.map((p) => {
      'name': p.name,
      'hook': p.hook,
      'cuisineType': p.cuisineType,
      'imageUrl': p.imageUrl,
      'placeId': p.placeId,
      'address': p.address,
      'rating': p.rating,
      'priceLevel': p.priceLevel,
    }).toList());

    // Delete existing cache for this user/day/city/mealContext
    await TonightPicksCache.db.deleteWhere(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.cacheDate.equals(today) &
          t.city.equals(cityName) &
          t.mealContext.equals(mealContext.name),
    );

    // Insert new cache entry
    final cache = TonightPicksCache(
      userId: userId,
      cacheDate: today,
      city: cityName,
      state: state,
      mealContext: mealContext.name,
      picksJson: picksJson,
      createdAt: DateTime.now().toUtc(),
    );

    await TonightPicksCache.db.insertRow(session, cache);
    session.log('Cached ${picks.length} picks for $cityName (${mealContext.name})');
  }

  /// Get today's date as YYYY-MM-DD string.
  String _getTodayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// Determine meal context based on current time.
  _MealContext _getMealContext() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 11) {
      return _MealContext.breakfast;
    } else if (hour >= 11 && hour < 14) {
      return _MealContext.lunch;
    } else if (hour >= 14 && hour < 17) {
      return _MealContext.afternoon;
    } else if (hour >= 17 && hour < 21) {
      return _MealContext.dinner;
    } else {
      return _MealContext.lateNight;
    }
  }

  /// Build the Perplexity prompt.
  String _buildPrompt({
    required String location,
    required _MealContext mealContext,
    String? cuisinePreferences,
    String? dietaryRestrictions,
    WeatherData? weather,
  }) {
    final buffer = StringBuffer();

    buffer.writeln('You are a local food expert finding the perfect restaurant for RIGHT NOW.');
    buffer.writeln();
    buffer.writeln('CONTEXT:');
    buffer.writeln('- Location: $location');
    buffer.writeln('- Time: ${mealContext.description}');

    // Add weather context if available
    if (weather != null) {
      buffer.writeln('- ${weather.getFoodContext()}');
      buffer.writeln();
      buffer.writeln(weather.getFoodMoodSuggestions());
    }

    buffer.writeln('- Looking for: ${mealContext.lookingFor}');
    buffer.writeln();

    if (cuisinePreferences != null && cuisinePreferences.isNotEmpty) {
      buffer.writeln('User enjoys: $cuisinePreferences');
    }
    if (dietaryRestrictions != null && dietaryRestrictions.isNotEmpty) {
      buffer.writeln('Dietary restrictions: $dietaryRestrictions');
    }

    buffer.writeln();
    buffer.writeln('Find exactly 3 restaurants that are PERFECT for right now.');
    buffer.writeln('Mix it up - don\'t give 3 of the same cuisine.');
    buffer.writeln('Focus on places actually OPEN right now.');

    // Weather-specific guidance
    if (weather != null) {
      if (weather.isRaining || weather.condition.contains('storm')) {
        buffer.writeln('Consider places with cozy ambiance since it\'s rainy/stormy.');
      }
      if (weather.temperature < 50) {
        buffer.writeln('Lean toward warming, comforting food given the cold weather.');
      } else if (weather.temperature > 85) {
        buffer.writeln('Consider places with good AC or outdoor shade, and lighter fare for the heat.');
      }
    }

    buffer.writeln();
    buffer.writeln('For each restaurant, write a punchy one-liner "hook" that makes someone want to go.');
    buffer.writeln('Examples of great hooks:');
    buffer.writeln('- "The ramen that\'ll ruin all other ramen for you"');
    buffer.writeln('- "Street tacos. Cash only. No English menu. Perfect."');
    buffer.writeln('- "Skip the menu. Ask for the special."');
    buffer.writeln('- "The hangover cure locals swear by"');

    // Weather-specific hook examples
    if (weather != null && weather.isRaining) {
      buffer.writeln('- "The perfect rainy day bowl"');
    }
    if (weather != null && weather.temperature < 50) {
      buffer.writeln('- "Warm up with their legendary hot pot"');
    }

    buffer.writeln();
    buffer.writeln('Respond ONLY with valid JSON array:');
    buffer.writeln('''
[
  {
    "name": "exact restaurant name",
    "hook": "punchy one-liner hook",
    "cuisineType": "cuisine type"
  }
]''');

    return buffer.toString();
  }

  /// Parse the Perplexity response into picks.
  List<TonightPick> _parseResponse(
    Session session,
    String content,
    List<String> images,
  ) {
    try {
      var jsonStr = content.trim();

      // Remove markdown code blocks
      if (jsonStr.startsWith('```json')) {
        jsonStr = jsonStr.substring(7);
      } else if (jsonStr.startsWith('```')) {
        jsonStr = jsonStr.substring(3);
      }
      if (jsonStr.endsWith('```')) {
        jsonStr = jsonStr.substring(0, jsonStr.length - 3);
      }
      jsonStr = jsonStr.trim();

      // Find the JSON array
      final startIndex = jsonStr.indexOf('[');
      final endIndex = jsonStr.lastIndexOf(']');

      if (startIndex == -1 || endIndex == -1 || endIndex <= startIndex) {
        session.log('Could not find JSON array in response');
        return [];
      }

      jsonStr = jsonStr.substring(startIndex, endIndex + 1);
      final parsed = jsonDecode(jsonStr) as List<dynamic>;

      final picks = <TonightPick>[];
      for (var i = 0; i < parsed.length && i < 3; i++) {
        final item = parsed[i] as Map<String, dynamic>;
        final name = item['name'] as String?;
        final hook = item['hook'] as String?;

        if (name == null || hook == null) continue;

        // Use Perplexity image if available
        String? imageUrl;
        if (images.isNotEmpty && i < images.length) {
          imageUrl = images[i];
        }

        picks.add(TonightPick(
          name: name,
          hook: hook,
          cuisineType: item['cuisineType'] as String?,
          imageUrl: imageUrl,
        ));
      }

      return picks;
    } catch (e) {
      session.log('Error parsing tonight picks: $e', level: LogLevel.error);
      return [];
    }
  }
}

/// Meal context based on time of day.
enum _MealContext {
  breakfast(
    'breakfast time (morning)',
    'Breakfast spots, coffee shops, brunch places that are open now',
  ),
  lunch(
    'lunch time (midday)',
    'Quick lunch spots, casual restaurants, good for a midday meal',
  ),
  afternoon(
    'afternoon (between meals)',
    'Coffee, snacks, casual bites, happy hour spots opening soon',
  ),
  dinner(
    'dinner time (evening)',
    'Dinner restaurants, date night spots, places for a proper meal',
  ),
  lateNight(
    'late night',
    'Late-night eats, bars with food, diners, after-hours spots',
  );

  final String description;
  final String lookingFor;

  const _MealContext(this.description, this.lookingFor);
}
