import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/google_places_service.dart';
import '../services/perplexity_service.dart';

/// Endpoint for curated restaurant maps (Eater-style).
class CuratedMapsEndpoint extends Endpoint {
  /// Get all curated maps for a city.
  Future<List<CuratedMap>> getMapsForCity(
    Session session,
    String cityName,
  ) async {
    return await CuratedMap.db.find(
      session,
      where: (t) => t.cityName.equals(cityName) & t.isPublished.equals(true),
      orderBy: (t) => t.restaurantCount,
      orderDescending: true,
    );
  }

  /// Get maps for a specific category in a city.
  Future<List<CuratedMap>> getMapsByCategory(
    Session session,
    String cityName,
    String category,
  ) async {
    return await CuratedMap.db.find(
      session,
      where: (t) =>
          t.cityName.equals(cityName) &
          t.category.equals(category) &
          t.isPublished.equals(true),
      orderBy: (t) => t.restaurantCount,
      orderDescending: true,
    );
  }

  /// Get a single map by slug.
  Future<CuratedMap?> getMapBySlug(Session session, String slug) async {
    return await CuratedMap.db.findFirstRow(
      session,
      where: (t) => t.slug.equals(slug),
    );
  }

  /// Get all restaurants in a map.
  Future<List<MapRestaurant>> getMapRestaurants(
    Session session,
    int mapId,
  ) async {
    return await MapRestaurant.db.find(
      session,
      where: (t) => t.mapId.equals(mapId),
      orderBy: (t) => t.displayOrder,
    );
  }

  /// Get user's favorite cities.
  Future<List<FavoriteCity>> getFavoriteCities(Session session) async {
    final authenticated = session.authenticated;
    if (authenticated == null) {
      return [];
    }

    final userId = authenticated.userIdentifier.toString();

    return await FavoriteCity.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      orderBy: (t) => t.displayOrder,
    );
  }

  /// Add a favorite city.
  Future<FavoriteCity> addFavoriteCity(
    Session session, {
    required String cityName,
    String? stateOrRegion,
    required String country,
    required double latitude,
    required double longitude,
    required bool isHomeCity,
  }) async {
    final authenticated = session.authenticated;
    if (authenticated == null) {
      throw Exception('User must be authenticated');
    }

    final userId = authenticated.userIdentifier.toString();

    // Check current count
    final existing = await FavoriteCity.db.find(
      session,
      where: (t) => t.userId.equals(userId),
    );

    if (existing.length >= 11) {
      throw Exception('Maximum of 11 cities allowed (1 home + 10 favorites)');
    }

    // If setting as home city, unset any existing home city
    if (isHomeCity) {
      for (final city in existing.where((c) => c.isHomeCity)) {
        await FavoriteCity.db.updateRow(
          session,
          city.copyWith(isHomeCity: false),
        );
      }
    }

    // Determine display order
    int displayOrder;
    if (isHomeCity) {
      displayOrder = 0;
    } else {
      final nonHomeCities = existing.where((c) => !c.isHomeCity).length;
      displayOrder = nonHomeCities + 1;
    }

    final favoriteCity = FavoriteCity(
      userId: userId,
      cityName: cityName,
      stateOrRegion: stateOrRegion,
      country: country,
      latitude: latitude,
      longitude: longitude,
      isHomeCity: isHomeCity,
      displayOrder: displayOrder,
      createdAt: DateTime.now().toUtc(),
    );

    return await FavoriteCity.db.insertRow(session, favoriteCity);
  }

  /// Remove a favorite city.
  Future<bool> removeFavoriteCity(Session session, int cityId) async {
    final authenticated = session.authenticated;
    if (authenticated == null) {
      throw Exception('User must be authenticated');
    }

    final city = await FavoriteCity.db.findById(session, cityId);
    if (city == null) {
      return false;
    }

    // Don't allow removing home city
    if (city.isHomeCity) {
      throw Exception('Cannot remove home city. Change home city first.');
    }

    await FavoriteCity.db.deleteRow(session, city);
    return true;
  }

  /// Get user's custom maps.
  Future<List<CuratedMap>> getUserMaps(Session session) async {
    final authenticated = session.authenticated;
    if (authenticated == null) {
      return [];
    }

    final userId = authenticated.userIdentifier.toString();

    return await CuratedMap.db.find(
      session,
      where: (t) => t.userId.equals(userId) & t.isUserCreated.equals(true),
      orderBy: (t) => t.lastUpdatedAt,
      orderDescending: true,
    );
  }

  /// Create a user's custom map.
  Future<CuratedMap> createUserMap(
    Session session, {
    required String cityName,
    String? stateOrRegion,
    required String country,
    required String title,
    required String shortDescription,
  }) async {
    final authenticated = session.authenticated;
    if (authenticated == null) {
      throw Exception('User must be authenticated');
    }

    final userId = authenticated.userIdentifier.toString();
    final now = DateTime.now().toUtc();

    // Generate slug from title
    final slug =
        '${userId.substring(0, 8)}-${title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-')}-${now.millisecondsSinceEpoch}';

    final map = CuratedMap(
      userId: userId,
      isUserCreated: true,
      cityName: cityName,
      stateOrRegion: stateOrRegion,
      country: country,
      title: title,
      slug: slug,
      category: 'custom',
      shortDescription: shortDescription,
      restaurantCount: 0,
      lastUpdatedAt: now,
      createdAt: now,
      isPublished: true,
    );

    return await CuratedMap.db.insertRow(session, map);
  }

  /// Add a restaurant to a user's map with AI-generated description.
  Future<MapRestaurant> addRestaurantToMap(
    Session session, {
    required int mapId,
    required String name,
    String? googlePlaceId,
    String? editorialDescription,
    required String address,
    required String city,
    String? stateOrRegion,
    required double latitude,
    required double longitude,
    String? phoneNumber,
    String? websiteUrl,
    String? reservationUrl,
    String? primaryPhotoUrl,
  }) async {
    final authenticated = session.authenticated;
    if (authenticated == null) {
      throw Exception('User must be authenticated');
    }

    // Verify user owns this map
    final map = await CuratedMap.db.findById(session, mapId);
    if (map == null) {
      throw Exception('Map not found');
    }
    if (map.userId != authenticated.userIdentifier.toString()) {
      throw Exception('You can only add restaurants to your own maps');
    }

    final now = DateTime.now().toUtc();

    // Get display order
    final existingRestaurants = await MapRestaurant.db.count(
      session,
      where: (t) => t.mapId.equals(mapId),
    );

    // Generate editorial description and image if not provided
    String description = editorialDescription ?? '';
    String? photoUrl = primaryPhotoUrl;

    if (description.isEmpty) {
      final result = await _generateEditorialWithImages(session, name, city);
      description = result.description;
      // Use Perplexity image if no photo provided and Perplexity returned one
      photoUrl ??= result.imageUrl;
    }

    final restaurant = MapRestaurant(
      mapId: mapId,
      name: name,
      googlePlaceId: googlePlaceId,
      editorialDescription: description,
      address: address,
      city: city,
      stateOrRegion: stateOrRegion,
      latitude: latitude,
      longitude: longitude,
      phoneNumber: phoneNumber,
      websiteUrl: websiteUrl,
      reservationUrl: reservationUrl,
      primaryPhotoUrl: photoUrl,
      displayOrder: existingRestaurants,
      createdAt: now,
      updatedAt: now,
    );

    final inserted = await MapRestaurant.db.insertRow(session, restaurant);

    // Update map restaurant count
    await CuratedMap.db.updateRow(
      session,
      map.copyWith(
        restaurantCount: existingRestaurants + 1,
        lastUpdatedAt: now,
        coverImageUrl: map.coverImageUrl ?? photoUrl,
      ),
    );

    return inserted;
  }

  /// Generate editorial description and optionally get images for a restaurant using Perplexity.
  Future<({String description, String? imageUrl})> _generateEditorialWithImages(
    Session session,
    String restaurantName,
    String city,
  ) async {
    try {
      final perplexityApiKey =
          session.serverpod.getPassword('PERPLEXITY_API_KEY');
      if (perplexityApiKey == null || perplexityApiKey.isEmpty) {
        return (description: 'A notable restaurant in $city.', imageUrl: null);
      }

      final perplexity = PerplexityService(
        apiKey: perplexityApiKey,
        session: session,
      );

      // Use the user's suggested prompt style with image request
      final prompt = '''
Write a description about $restaurantName in $city including dishes to try.

Write in the style of Eater magazine - evocative, storytelling, capturing what makes this place special.
Keep it to 2-3 sentences. Mention signature dishes or what to order.
Be specific and authoritative, not generic.

Also show me photos of the food and restaurant interior.
''';

      final response = await perplexity.queryWithImages(prompt);
      final description = response.content.isNotEmpty
          ? response.content
          : 'A notable dining destination in $city.';

      return (description: description, imageUrl: response.firstImage);
    } catch (e) {
      session.log('Failed to generate description: $e');
      return (
        description: 'A popular restaurant in $city worth visiting.',
        imageUrl: null
      );
    }
  }

  /// Generate a curated map using Perplexity AI.
  Future<CuratedMap> generateMap(
    Session session, {
    required String cityName,
    String? stateOrRegion,
    required String country,
    required String mapType,
    String? customPrompt,
    int maxRestaurants = 12,
  }) async {
    // Get user ID if authenticated (so map shows in "My Maps")
    final authenticated = session.authenticated;
    final userId = authenticated?.userIdentifier.toString();

    session.log('generateMap called: city=$cityName, type=$mapType, maxRestaurants=$maxRestaurants, userId=$userId');
    final now = DateTime.now().toUtc();

    // Build title and prompt based on map type
    String title;
    String category;
    String shortDescription;
    String searchPrompt;

    switch (mapType) {
      case 'best_tacos':
        title = 'Best Tacos in $cityName';
        category = 'cuisine';
        shortDescription = 'The taco spots locals swear by in $cityName.';
        searchPrompt = 'Find the best taco restaurants and taquerias in $cityName. Focus on authentic tacos, street-style tacos, and local favorites.';
        break;
      case 'date_night':
        title = 'Date Night in $cityName';
        category = 'occasion';
        shortDescription = 'Romantic spots that impress in $cityName.';
        searchPrompt = 'Find the most romantic date night restaurants in $cityName. Include intimate atmosphere, great ambiance, impressive food.';
        break;
      case 'hidden_gems':
        title = 'Hidden Gems in $cityName';
        category = 'hiddenGems';
        shortDescription = 'Off-radar restaurants worth finding in $cityName.';
        searchPrompt = 'Find hidden gem restaurants in $cityName that locals love but tourists don\'t know about. Underrated, under-the-radar spots.';
        break;
      case 'late_night':
        title = 'Late Night Eats in $cityName';
        category = 'occasion';
        shortDescription = 'Where to go after midnight in $cityName.';
        searchPrompt = 'Find the best late night restaurants and food spots in $cityName that are open after 10pm or midnight.';
        break;
      case 'brunch':
        title = 'Best Brunch in $cityName';
        category = 'occasion';
        shortDescription = 'Weekend brunch destinations in $cityName.';
        searchPrompt = 'Find the best brunch restaurants in $cityName. Include bottomless brunch, classic brunch spots, and trendy new places.';
        break;
      case 'budget_eats':
        title = 'Budget Eats in $cityName';
        category = 'budget';
        shortDescription = 'Great food under \$15 in $cityName.';
        searchPrompt = 'Find the best cheap eats and budget-friendly restaurants in $cityName under \$15 per person. Delicious food that won\'t break the bank.';
        break;
      case 'award_winners':
        title = 'Award Winners in $cityName';
        category = 'awards';
        shortDescription = 'James Beard & Michelin picks in $cityName.';
        searchPrompt = 'Find award-winning restaurants in $cityName including James Beard nominees, Michelin starred, and critically acclaimed restaurants.';
        break;
      case 'food_crawl':
        title = 'Food Crawl: $cityName';
        category = 'crawl';
        shortDescription = 'A walkable tasting tour through $cityName.';
        searchPrompt = 'Find restaurants close together in $cityName for a walkable food crawl. Small plates, diverse cuisines, all within walking distance.';
        break;
      case 'custom':
        if (customPrompt == null || customPrompt.isEmpty) {
          throw Exception('customPrompt required for custom maps');
        }
        // Generate title from custom prompt
        title = customPrompt.length > 40
            ? '${customPrompt.substring(0, 37)}...'
            : customPrompt;
        title = '$title in $cityName';
        category = 'custom';
        shortDescription = 'A custom curated guide for $cityName.';
        searchPrompt = '$customPrompt in $cityName. Find the best restaurants that match this criteria.';
        break;
      default:
        title = 'Best of $cityName';
        category = 'bestOf';
        shortDescription = 'The essential guide to $cityName right now.';
        searchPrompt = 'Find the best restaurants in $cityName across all cuisines and price ranges.';
    }

    // Generate slug
    final slug =
        '${title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-')}-${now.millisecondsSinceEpoch}';

    // Derive cuisine type from map type if applicable
    String? derivedCuisineType;
    if (mapType == 'best_tacos') derivedCuisineType = 'Mexican/Tacos';

    // Create the map - mark as user-created if authenticated
    final map = CuratedMap(
      userId: userId,
      isUserCreated: userId != null, // User-created if logged in
      cityName: cityName,
      stateOrRegion: stateOrRegion,
      country: country,
      title: title,
      slug: slug,
      category: category,
      cuisineType: derivedCuisineType,
      shortDescription: shortDescription,
      restaurantCount: 0,
      lastUpdatedAt: now,
      createdAt: now,
      isPublished: false,
    );

    session.log('Inserting initial map record...');
    final insertedMap = await CuratedMap.db.insertRow(session, map);
    session.log('Map record inserted with id: ${insertedMap.id}');

    // Generate restaurants using Perplexity
    try {
      final perplexityApiKey =
          session.serverpod.getPassword('PERPLEXITY_API_KEY');
      session.log('Perplexity API key configured: ${perplexityApiKey != null && perplexityApiKey.isNotEmpty}');
      if (perplexityApiKey == null || perplexityApiKey.isEmpty) {
        throw Exception('Perplexity API key not configured');
      }

      session.log('Creating PerplexityService...');
      final perplexity = PerplexityService(
        apiKey: perplexityApiKey,
        session: session,
      );

      final location =
          stateOrRegion != null ? '$cityName, $stateOrRegion' : cityName;

      session.log('Generating map: $title with prompt: $searchPrompt');
      session.log('Calling Perplexity queryWithImages...');

      final prompt = '''
$searchPrompt

Find exactly $maxRestaurants restaurants in $location.

For EACH restaurant, provide a JSON object with:
- name: Restaurant name (must be a REAL restaurant that exists)
- address: Full street address in $location
- description: 2-3 sentence editorial description in Eater magazine style - evocative, storytelling, what makes this place special
- mustOrder: 2-3 signature dishes to try
- cuisineType: Type of cuisine
- priceRange: \$ or \$\$ or \$\$\$ or \$\$\$\$

Return as a JSON array. Be specific and authoritative.

Also include photos of these restaurants and their food.
''';

      session.log('Awaiting Perplexity response...');
      final response = await perplexity.queryWithImages(prompt);
      session.log('Perplexity response received. Content length: ${response.content.length}, Images: ${response.images.length}');
      session.log('Perplexity response preview: ${response.content.substring(0, response.content.length > 500 ? 500 : response.content.length)}');

      final restaurants = _parseRestaurantJson(response.content);
      session.log('Parsed ${restaurants.length} restaurants from response');

      // Store Perplexity images as fallback
      final perplexityImages = response.images;

      // Create Google Places service for geocoding and photos
      final googlePlaces = GooglePlacesService.fromSession(session);

      // Get web server URL for proxied photo URLs
      // Photos are served via the web server, not the API server
      final serverBaseUrl = session.serverpod.getPassword('WEB_SERVER_PUBLIC_URL') ??
                            'http://localhost:8082';

      int order = 0;
      String? firstImageUrl;

      for (final r in restaurants.take(maxRestaurants)) {
        try {
          final restaurantName = r['name'] as String? ?? 'Unknown';
          final restaurantAddress = r['address'] as String?;

          // Try to geocode using Google Places
          double latitude = 0;
          double longitude = 0;
          String? googlePlaceId;
          String? primaryPhotoUrl;
          String? additionalPhotosJson;
          double? googleRating;
          int? reviewCount;
          int? priceLevel;

          // Search for restaurant in Google Places to get coordinates and photos
          final searchQuery = '$restaurantName $cityName ${stateOrRegion ?? ''}';
          final placeDetails = await googlePlaces.searchAndGetDetails(searchQuery);

          if (placeDetails != null) {
            final geometry = placeDetails['geometry'] as Map<String, dynamic>?;
            final loc = geometry?['location'] as Map<String, dynamic>?;

            if (loc != null) {
              latitude = (loc['lat'] as num?)?.toDouble() ?? 0;
              longitude = (loc['lng'] as num?)?.toDouble() ?? 0;
            }

            googlePlaceId = placeDetails['place_id'] as String?;
            googleRating = (placeDetails['rating'] as num?)?.toDouble();
            reviewCount = placeDetails['user_ratings_total'] as int?;
            priceLevel = placeDetails['price_level'] as int?;

            // Fetch multiple photos using the place ID
            if (googlePlaceId != null) {
              final photos = await googlePlaces.getPlacePhotos(
                googlePlaceId,
                maxPhotos: 5,
                serverBaseUrl: serverBaseUrl,
              );

              if (photos.isNotEmpty) {
                // First photo is the primary
                primaryPhotoUrl = photos.first['url'] as String?;

                // Store all photos as JSON for gallery view
                additionalPhotosJson = jsonEncode(photos);
              }
            }
          }

          // Fallback to Perplexity image if no Google photo
          if (primaryPhotoUrl == null) {
            // First try images from the main query
            if (perplexityImages.isNotEmpty) {
              primaryPhotoUrl = perplexityImages[order % perplexityImages.length];
            } else {
              // Fetch restaurant-specific images from Perplexity
              try {
                final restaurantImages = await perplexity.getRestaurantImages(
                  restaurantName: restaurantName,
                  city: cityName,
                  maxImages: 1,
                );
                if (restaurantImages.isNotEmpty) {
                  primaryPhotoUrl = restaurantImages.first;
                  session.log('Got Perplexity image for $restaurantName');
                }
              } catch (e) {
                session.log('Failed to get Perplexity image for $restaurantName: $e');
              }
            }
          }

          // Save first image for map cover
          firstImageUrl ??= primaryPhotoUrl;

          // Parse mustOrder - could be String or List
          String? mustOrderDishes;
          final rawMustOrder = r['mustOrder'];
          if (rawMustOrder is String) {
            mustOrderDishes = rawMustOrder;
          } else if (rawMustOrder is List) {
            mustOrderDishes = rawMustOrder.map((e) => e.toString()).join(', ');
          }

          // Parse cuisineType - could be String or List
          String? cuisineTypes;
          final rawCuisineType = r['cuisineType'];
          if (rawCuisineType is String) {
            cuisineTypes = rawCuisineType;
          } else if (rawCuisineType is List) {
            cuisineTypes = rawCuisineType.map((e) => e.toString()).join(', ');
          }

          final restaurant = MapRestaurant(
            mapId: insertedMap.id!,
            name: restaurantName,
            googlePlaceId: googlePlaceId,
            editorialDescription:
                r['description'] as String? ?? 'A notable restaurant.',
            mustOrderDishes: mustOrderDishes,
            cuisineTypes: cuisineTypes,
            address: restaurantAddress ?? cityName,
            city: cityName,
            stateOrRegion: stateOrRegion,
            latitude: latitude,
            longitude: longitude,
            googleRating: googleRating,
            googleReviewCount: reviewCount,
            priceLevel: priceLevel,
            primaryPhotoUrl: primaryPhotoUrl,
            additionalPhotosJson: additionalPhotosJson,
            displayOrder: order++,
            createdAt: now,
            updatedAt: now,
          );

          await MapRestaurant.db.insertRow(session, restaurant);
        } catch (e) {
          session.log('Failed to add restaurant: $e');
        }
      }

      // Update map with restaurant count and cover image
      final updatedMap = insertedMap.copyWith(
        restaurantCount: order,
        isPublished: true,
        lastUpdatedAt: DateTime.now().toUtc(),
        coverImageUrl: firstImageUrl,
      );

      return await CuratedMap.db.updateRow(session, updatedMap);
    } catch (e, stackTrace) {
      session.log('Failed to generate map: $e', level: LogLevel.error);
      session.log('Stack trace: $stackTrace', level: LogLevel.error);
      try {
        await CuratedMap.db.deleteRow(session, insertedMap);
      } catch (deleteError) {
        session.log('Failed to delete map after error: $deleteError', level: LogLevel.error);
      }
      rethrow;
    }
  }

  List<Map<String, dynamic>> _parseRestaurantJson(String response) {
    try {
      String jsonStr = response.trim();

      // Remove markdown code blocks if present
      if (jsonStr.contains('```json')) {
        final start = jsonStr.indexOf('```json') + 7;
        final end = jsonStr.indexOf('```', start);
        if (end > start) {
          jsonStr = jsonStr.substring(start, end).trim();
        }
      } else if (jsonStr.contains('```')) {
        final start = jsonStr.indexOf('```') + 3;
        final end = jsonStr.indexOf('```', start);
        if (end > start) {
          jsonStr = jsonStr.substring(start, end).trim();
        }
      }

      // Find the JSON array - use greedy matching to get the full array
      final startIndex = jsonStr.indexOf('[');
      final endIndex = jsonStr.lastIndexOf(']');

      if (startIndex != -1 && endIndex > startIndex) {
        jsonStr = jsonStr.substring(startIndex, endIndex + 1);
        final List<dynamic> parsed = jsonDecode(jsonStr);
        return parsed.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      // Log parsing failure for debugging
    }
    return [];
  }
}
