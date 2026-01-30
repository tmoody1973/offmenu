import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'google_places_service.dart';

/// Service for AI-powered food discovery using Perplexity.
///
/// Handles natural language queries and returns enriched results
/// with Google Places data for photos and coordinates.
class FoodDiscoveryService {
  final Session _session;
  final String? _perplexityApiKey;
  final GooglePlacesService _placesService;

  static const _baseUrl = 'https://api.perplexity.ai/chat/completions';

  FoodDiscoveryService(this._session)
      : _perplexityApiKey = _session.serverpod.getPassword('PERPLEXITY_API_KEY'),
        _placesService = GooglePlacesService.fromSession(_session) {
    final key = _session.serverpod.getPassword('PERPLEXITY_API_KEY');
    print('[FoodDiscoveryService] Perplexity API key: ${key != null ? "found (${key.length} chars)" : "NOT FOUND"}');
  }

  /// Discover restaurants based on a natural language query.
  Future<FoodDiscoveryResponse> discover(String query) async {
    if (_perplexityApiKey == null || _perplexityApiKey!.isEmpty) {
      _session.log('Perplexity API key not configured', level: LogLevel.warning);
      return FoodDiscoveryResponse(
        summary: 'Sorry, the AI service is not configured. Please try again later.',
        places: [],
        query: query,
        showMap: false,
      );
    }

    try {
      // Ask Perplexity for restaurant recommendations
      print('[FoodDiscoveryService] Calling Perplexity API for: $query');
      final aiResponse = await _queryPerplexity(query);
      print('[FoodDiscoveryService] Perplexity response: ${aiResponse != null ? "received with keys: ${aiResponse.keys}" : "null"}');

      if (aiResponse == null) {
        print('[FoodDiscoveryService] Returning no recommendations');
        return FoodDiscoveryResponse(
          summary: 'I couldn\'t find any recommendations for that query. Try being more specific about the location!',
          places: [],
          query: query,
          showMap: false,
        );
      }

      // Determine if we should show the map based on query intent
      final queryIntent = aiResponse['query_intent'] as String? ?? 'discovery';
      final showMap = queryIntent == 'discovery';
      _session.log('Query intent: $queryIntent, showMap: $showMap', level: LogLevel.info);

      // Extract location from response or query
      final location = aiResponse['detected_location'] as String? ??
          _extractLocationFromQuery(query);

      // Get Perplexity images to use as fallback
      final perplexityImages = (aiResponse['_perplexity_images'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [];
      print('[FoodDiscovery] Have ${perplexityImages.length} Perplexity images for fallback');

      // Enrich each restaurant with Google Places data
      final enrichedPlaces = <DiscoveredPlace>[];
      final restaurants = aiResponse['restaurants'] as List<dynamic>? ?? [];
      int perplexityImageIndex = 0;

      for (final restaurant in restaurants.take(10)) {
        final name = restaurant['name'] as String?;
        final aiAddress = restaurant['address'] as String?;
        final neighborhood = restaurant['neighborhood'] as String?;
        final whyRecommended = restaurant['why_recommended'] as String? ?? '';
        final categories = (restaurant['categories'] as List<dynamic>?)
                ?.map((c) => c.toString())
                .toList() ??
            [];
        final mustOrder = (restaurant['must_order'] as List<dynamic>?)
                ?.map((d) => d.toString())
                .toList();
        final proTips = restaurant['pro_tips'] as String?;

        if (name == null) continue;

        // Build fallback address from AI data
        final fallbackAddress = aiAddress ??
            (neighborhood != null ? '$neighborhood, $location' : location ?? '');

        // Search Google Places for this restaurant
        // Use simple query: just name + location (city/state)
        // The neighborhood description is too verbose for Google Places search
        final searchQuery = '$name $location';

        try {
          final placeDetails = await _placesService.searchAndGetDetails(searchQuery);

          if (placeDetails != null) {
            // Try Google Places photo first, fall back to Perplexity images
            String? photoUrl = _getPhotoUrl(placeDetails);
            if (photoUrl == null && perplexityImageIndex < perplexityImages.length) {
              photoUrl = perplexityImages[perplexityImageIndex++];
              print('[FoodDiscovery] Using Perplexity image for $name: ${photoUrl.substring(0, 50)}...');
            }

            enrichedPlaces.add(DiscoveredPlace(
              placeId: placeDetails['place_id'] as String? ?? '',
              name: placeDetails['name'] as String? ?? name,
              address: placeDetails['formatted_address'] as String? ?? '',
              latitude: (placeDetails['geometry']?['location']?['lat'] as num?)?.toDouble() ?? 0,
              longitude: (placeDetails['geometry']?['location']?['lng'] as num?)?.toDouble() ?? 0,
              rating: (placeDetails['rating'] as num?)?.toDouble() ?? 0,
              reviewCount: (placeDetails['user_ratings_total'] as num?)?.toInt() ?? 0,
              priceLevel: _formatPriceLevel(placeDetails['price_level'] as int?),
              photoUrl: photoUrl,
              whyRecommended: whyRecommended,
              categories: categories,
              isOpen: placeDetails['opening_hours']?['open_now'] as bool?,
              mustOrder: mustOrder,
              proTips: proTips,
              websiteUrl: placeDetails['website'] as String?,
              phoneNumber: placeDetails['phone_number'] as String?,
              googleMapsUrl: placeDetails['google_maps_url'] as String?,
            ));
          } else {
            // Google Places failed - still show the restaurant with basic info from AI
            _session.log('Google Places lookup failed for $name, using AI data only', level: LogLevel.info);

            // Use Perplexity image as fallback
            String? photoUrl;
            if (perplexityImageIndex < perplexityImages.length) {
              photoUrl = perplexityImages[perplexityImageIndex++];
              print('[FoodDiscovery] Using Perplexity image for $name (no Places data): ${photoUrl.substring(0, 50)}...');
            }

            enrichedPlaces.add(DiscoveredPlace(
              placeId: 'ai_${name.hashCode}',
              name: name,
              address: fallbackAddress,
              latitude: 0,
              longitude: 0,
              rating: 0,
              reviewCount: 0,
              priceLevel: '\$\$',
              photoUrl: photoUrl,
              whyRecommended: whyRecommended,
              categories: categories,
              isOpen: null,
              mustOrder: mustOrder,
              proTips: proTips,
              websiteUrl: null,
              phoneNumber: null,
              googleMapsUrl: null,
            ));
          }
        } catch (e) {
          _session.log('Failed to enrich $name: $e', level: LogLevel.warning);

          // Use Perplexity image as fallback
          String? photoUrl;
          if (perplexityImageIndex < perplexityImages.length) {
            photoUrl = perplexityImages[perplexityImageIndex++];
          }

          // Still add the restaurant with basic info
          enrichedPlaces.add(DiscoveredPlace(
            placeId: 'ai_${name.hashCode}',
            name: name,
            address: fallbackAddress,
            latitude: 0,
            longitude: 0,
            rating: 0,
            reviewCount: 0,
            priceLevel: '\$\$',
            photoUrl: photoUrl,
            whyRecommended: whyRecommended,
            categories: categories,
            isOpen: null,
            mustOrder: mustOrder,
            proTips: proTips,
            websiteUrl: null,
            phoneNumber: null,
            googleMapsUrl: null,
          ));
        }
      }

      return FoodDiscoveryResponse(
        summary: aiResponse['summary'] as String? ?? '',
        places: enrichedPlaces,
        query: query,
        detectedLocation: location,
        showMap: showMap,
      );
    } catch (e, stack) {
      _session.log('Food discovery error: $e\n$stack', level: LogLevel.error);
      return FoodDiscoveryResponse(
        summary: 'Oops! Something went wrong. Please try again.',
        places: [],
        query: query,
        showMap: false,
      );
    }
  }

  /// Query Perplexity AI for restaurant recommendations.
  Future<Map<String, dynamic>?> _queryPerplexity(String query) async {
    final prompt = '''
You are a local food expert writing for a magazine like Eater or Bon Appetit. The user is asking about food/restaurants.

USER QUERY: "$query"

Analyze the query and provide rich, editorial-quality restaurant information. Extract any location mentioned.
If no location is mentioned, ask the user to specify one.

IMPORTANT: First determine the QUERY INTENT:
- "discovery" = user is LOOKING FOR restaurants/places (e.g., "find tacos near me", "best restaurants in Seattle")
- "info" = user is asking about a SPECIFIC restaurant (e.g., "tell me about Hell's Kitchen Minneapolis")

IMPORTANT: Respond ONLY with valid JSON in this exact format:
{
  "query_intent": "discovery" or "info",
  "detected_location": "city, state or neighborhood mentioned in query",
  "summary": "A rich, editorial 2-4 sentence response. Include the restaurant's story, vibe, and what makes it special. Mention specific dishes. For discovery queries, set the scene for what they'll find.",
  "restaurants": [
    {
      "name": "Exact restaurant name",
      "address": "Full street address including city and state (e.g., '1234 Main St, Los Angeles, CA')",
      "neighborhood": "Specific neighborhood with brief context (e.g., 'the bustling North Loop', 'quiet residential Tangletown')",
      "why_recommended": "2-3 sentences: What makes this place special? Include the vibe, who goes there, what the experience is like.",
      "must_order": ["Specific dish 1 with brief description", "Specific dish 2", "Their famous X"],
      "pro_tips": "Insider knowledge: best time to go, where to sit, what to skip, secret menu items, etc.",
      "categories": ["cuisine type", "style", "vibe"]
    }
  ]
}

Rules:
- Write like a food journalist, not a search engine. Be specific and opinionated.
- ALWAYS include the full street address for each restaurant (e.g., "1234 Main St, Los Angeles, CA")
- ALWAYS include 2-4 specific dishes in "must_order" with brief descriptions
- Include "pro_tips" with insider knowledge (best seats, when to avoid crowds, ordering secrets)
- For "why_recommended", paint a picture of the experience, not just the food
- Mention the neighborhood character when relevant (trendy? historic? up-and-coming?)
- For discovery queries: include 3-5 restaurants that you are CERTAIN exist. Quality over quantity - only include restaurants you have high confidence are real and currently operating.
- For info queries about a specific restaurant: include just that one with extra detail
- Be playful and conversational but substantive
- CRITICAL: Only recommend places you are CONFIDENT actually exist. Do NOT make up restaurant names. If you're unsure, include fewer restaurants rather than inventing ones.
- Include price context and vibe (date night? casual? rowdy?)

JSON RESPONSE:''';

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_perplexityApiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'sonar',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a knowledgeable local food guide. Always respond with valid JSON only. No markdown, no explanation, just the JSON object.',
            },
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.7,
          'max_tokens': 2000,
          'return_images': true,
          'image_domain_filter': [
            '-gettyimages.com',
            '-shutterstock.com',
            '-istockphoto.com',
            '-stock.adobe.com',
          ],
        }),
      );

      print('[Perplexity] Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices']?[0]?['message']?['content'] as String?;
        print('[Perplexity] Content received: ${content != null ? "${content.length} chars" : "null"}');

        // Extract images from Perplexity response
        final perplexityImages = <String>[];
        if (data.containsKey('images')) {
          final imageList = data['images'] as List<dynamic>?;
          if (imageList != null) {
            for (final img in imageList) {
              if (img is String) {
                perplexityImages.add(img);
              } else if (img is Map<String, dynamic>) {
                final url = img['image_url'] as String? ?? img['url'] as String?;
                if (url != null && url.isNotEmpty) {
                  perplexityImages.add(url);
                }
              }
            }
          }
        }
        print('[Perplexity] Got ${perplexityImages.length} images from Perplexity');

        if (content != null) {
          // Parse the JSON from the response
          // Sometimes it comes wrapped in markdown code blocks
          var jsonStr = content.trim();
          if (jsonStr.startsWith('```')) {
            jsonStr = jsonStr
                .replaceFirst(RegExp(r'^```json?\n?'), '')
                .replaceFirst(RegExp(r'\n?```$'), '');
          }

          try {
            final parsed = jsonDecode(jsonStr) as Map<String, dynamic>;
            print('[Perplexity] Parsed JSON with keys: ${parsed.keys.toList()}');

            // Add images to the parsed response
            parsed['_perplexity_images'] = perplexityImages;

            return parsed;
          } catch (parseError) {
            print('[Perplexity] JSON parse error: $parseError');
            print('[Perplexity] Raw content (first 500 chars): ${jsonStr.substring(0, jsonStr.length > 500 ? 500 : jsonStr.length)}');
          }
        }
      } else {
        print('[Perplexity] API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e, stack) {
      print('[Perplexity] Request failed: $e');
      print('[Perplexity] Stack: $stack');
    }

    return null;
  }

  /// Extract location from query using simple heuristics.
  String _extractLocationFromQuery(String query) {
    final lowered = query.toLowerCase();

    // Common location patterns
    final patterns = [
      RegExp(r'\bin\s+([a-z\s]+)(?:,\s*[a-z]{2})?', caseSensitive: false),
      RegExp(r'\bnear\s+([a-z\s]+)', caseSensitive: false),
      RegExp(r'\baround\s+([a-z\s]+)', caseSensitive: false),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(lowered);
      if (match != null && match.group(1) != null) {
        return match.group(1)!.trim();
      }
    }

    return '';
  }

  /// Format price level to dollar signs.
  String _formatPriceLevel(int? level) {
    if (level == null) return '\$\$';
    return '\$' * level.clamp(1, 4);
  }

  /// Get photo URL from place details.
  /// Returns a server-proxied URL to avoid API key referrer restrictions.
  String? _getPhotoUrl(Map<String, dynamic> placeDetails) {
    final photos = placeDetails['photos'] as List<dynamic>?;
    if (photos == null || photos.isEmpty) return null;

    final photoReference = photos[0]['photo_reference'] as String?;
    if (photoReference == null || photoReference.isEmpty) return null;

    // Use the API server URL (port 8080) which Cloud Run exposes
    const apiServerUrl = 'https://offmenu-api-862293483750.us-central1.run.app';

    // Use the photo proxy route on the API server
    return '$apiServerUrl/api/photos/$photoReference';
  }
}
