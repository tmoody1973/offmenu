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
You are a local food expert and concierge. The user is asking about food/restaurants.

USER QUERY: "$query"

Analyze the query and provide restaurant recommendations. Extract any location mentioned.
If no location is mentioned, ask the user to specify one.

IMPORTANT: First determine the QUERY INTENT:
- "discovery" = user is LOOKING FOR restaurants/places (e.g., "find tacos near me", "best restaurants in Seattle", "where to eat tonight")
- "info" = user is asking about a SPECIFIC restaurant they already know (e.g., "what should I order at Ruta's?", "tell me about the menu at DanDan", "what's the signature dish at Canlis?")

IMPORTANT: Respond ONLY with valid JSON in this exact format:
{
  "query_intent": "discovery" or "info",
  "detected_location": "city, state or neighborhood mentioned in query",
  "summary": "A friendly, playful 1-2 sentence response addressing their query",
  "restaurants": [
    {
      "name": "Exact restaurant name",
      "neighborhood": "Specific neighborhood",
      "why_recommended": "1 sentence about why this fits their query",
      "categories": ["cuisine type", "style"]
    }
  ]
}

Rules:
- Set query_intent to "info" if the user is asking about menu, dishes, what to order, or details about a restaurant they named
- Set query_intent to "discovery" if the user is searching for restaurants to go to
- Include 5-8 specific, real restaurants that match the query (for discovery queries)
- For "info" queries about a specific restaurant, just include that one restaurant
- Focus on hidden gems and local favorites when asked for non-touristy spots
- Be playful and conversational in the summary
- If query mentions budget, factor that into recommendations
- If query mentions time (late night, brunch), factor that in
- Only recommend places you're confident actually exist

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
