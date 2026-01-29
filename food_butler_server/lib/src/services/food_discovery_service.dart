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
        _placesService = GooglePlacesService.fromSession(_session);

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
      final aiResponse = await _queryPerplexity(query);

      if (aiResponse == null) {
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

      // Enrich each restaurant with Google Places data
      final enrichedPlaces = <DiscoveredPlace>[];
      final restaurants = aiResponse['restaurants'] as List<dynamic>? ?? [];

      for (final restaurant in restaurants.take(10)) {
        final name = restaurant['name'] as String?;
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

        // Search Google Places for this restaurant
        final searchQuery = neighborhood != null
            ? '$name $neighborhood $location'
            : '$name $location';

        try {
          final placeDetails = await _placesService.searchAndGetDetails(searchQuery);

          if (placeDetails != null) {
            enrichedPlaces.add(DiscoveredPlace(
              placeId: placeDetails['place_id'] as String? ?? '',
              name: placeDetails['name'] as String? ?? name,
              address: placeDetails['formatted_address'] as String? ?? '',
              latitude: (placeDetails['geometry']?['location']?['lat'] as num?)?.toDouble() ?? 0,
              longitude: (placeDetails['geometry']?['location']?['lng'] as num?)?.toDouble() ?? 0,
              rating: (placeDetails['rating'] as num?)?.toDouble() ?? 0,
              reviewCount: (placeDetails['user_ratings_total'] as num?)?.toInt() ?? 0,
              priceLevel: _formatPriceLevel(placeDetails['price_level'] as int?),
              photoUrl: _getPhotoUrl(placeDetails),
              whyRecommended: whyRecommended,
              categories: categories,
              isOpen: placeDetails['opening_hours']?['open_now'] as bool?,
              mustOrder: mustOrder,
              proTips: proTips,
            ));
          } else {
            // Google Places failed - still show the restaurant with basic info from AI
            _session.log('Google Places lookup failed for $name, using AI data only', level: LogLevel.info);
            enrichedPlaces.add(DiscoveredPlace(
              placeId: 'ai_${name.hashCode}',
              name: name,
              address: neighborhood != null ? '$neighborhood, $location' : location ?? '',
              latitude: 0,
              longitude: 0,
              rating: 0,
              reviewCount: 0,
              priceLevel: '\$\$',
              photoUrl: null,
              whyRecommended: whyRecommended,
              categories: categories,
              isOpen: null,
              mustOrder: mustOrder,
              proTips: proTips,
            ));
          }
        } catch (e) {
          _session.log('Failed to enrich $name: $e', level: LogLevel.warning);
          // Still add the restaurant with basic info
          enrichedPlaces.add(DiscoveredPlace(
            placeId: 'ai_${name.hashCode}',
            name: name,
            address: neighborhood != null ? '$neighborhood, $location' : location ?? '',
            latitude: 0,
            longitude: 0,
            rating: 0,
            reviewCount: 0,
            priceLevel: '\$\$',
            photoUrl: null,
            whyRecommended: whyRecommended,
            categories: categories,
            isOpen: null,
            mustOrder: mustOrder,
            proTips: proTips,
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
- ALWAYS include 2-4 specific dishes in "must_order" with brief descriptions
- Include "pro_tips" with insider knowledge (best seats, when to avoid crowds, ordering secrets)
- For "why_recommended", paint a picture of the experience, not just the food
- Mention the neighborhood character when relevant (trendy? historic? up-and-coming?)
- For discovery queries: include 5-8 restaurants
- For info queries about a specific restaurant: include just that one with extra detail
- Be playful and conversational but substantive
- Only recommend places you're confident actually exist
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
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices']?[0]?['message']?['content'] as String?;

        if (content != null) {
          // Parse the JSON from the response
          // Sometimes it comes wrapped in markdown code blocks
          var jsonStr = content.trim();
          if (jsonStr.startsWith('```')) {
            jsonStr = jsonStr
                .replaceFirst(RegExp(r'^```json?\n?'), '')
                .replaceFirst(RegExp(r'\n?```$'), '');
          }

          return jsonDecode(jsonStr) as Map<String, dynamic>;
        }
      } else {
        _session.log(
          'Perplexity API error: ${response.statusCode} - ${response.body}',
          level: LogLevel.error,
        );
      }
    } catch (e) {
      _session.log('Perplexity request failed: $e', level: LogLevel.error);
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
  /// Returns a server-proxied URL that won't have CORS issues.
  String? _getPhotoUrl(Map<String, dynamic> placeDetails) {
    final photos = placeDetails['photos'] as List<dynamic>?;
    if (photos == null || photos.isEmpty) return null;

    final photoReference = photos[0]['photo_reference'] as String?;
    if (photoReference == null || photoReference.isEmpty) return null;

    // Return a server-proxied URL that works without CORS issues
    // Photos are served via the web server, not the API server
    final webServerUrl = _session.serverpod.getPassword('WEB_SERVER_PUBLIC_URL') ??
        'http://localhost:8082';

    // Use the photo proxy route on the web server
    return '$webServerUrl/api/photos/$photoReference';
  }
}
