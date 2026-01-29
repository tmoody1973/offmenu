import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

/// A complete AI-curated food tour experience.
class CuratedFoodTour {
  /// The tour's creative title/theme.
  final String title;

  /// Opening narrative setting the stage (like a documentary intro).
  final String introduction;

  /// The curated stops with full storytelling.
  final List<CuratedStop> stops;

  /// Closing narrative wrapping up the experience.
  final String closing;

  /// The overall vibe/mood of the tour.
  final String vibe;

  CuratedFoodTour({
    required this.title,
    required this.introduction,
    required this.stops,
    required this.closing,
    required this.vibe,
  });

  factory CuratedFoodTour.fromJson(Map<String, dynamic> json) {
    final stopsJson = json['stops'] as List<dynamic>? ?? [];
    return CuratedFoodTour(
      title: json['title'] as String? ?? 'Food Tour',
      introduction: json['introduction'] as String? ?? '',
      stops: stopsJson.map((s) => CuratedStop.fromJson(s as Map<String, dynamic>)).toList(),
      closing: json['closing'] as String? ?? '',
      vibe: json['vibe'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'introduction': introduction,
    'stops': stops.map((s) => s.toJson()).toList(),
    'closing': closing,
    'vibe': vibe,
  };
}

/// A single stop in the curated tour with full storytelling.
class CuratedStop {
  /// Restaurant name.
  final String name;

  /// The neighborhood/area.
  final String neighborhood;

  /// Why this place is special - the story.
  final String story;

  /// The must-order dish.
  final String signatureDish;

  /// Why this dish matters - the food story.
  final String dishStory;

  /// Insider tip (secret menu, best seat, when to go).
  final String insiderTip;

  /// Price range indication.
  final String priceRange;

  /// Cuisine type.
  final String cuisine;

  /// Transition narrative to the next stop.
  final String? transitionToNext;

  /// Estimated time to spend here.
  final int minutesToSpend;

  // These get filled in by Google Places
  String? placeId;
  double? latitude;
  double? longitude;
  String? address;
  double? rating;

  CuratedStop({
    required this.name,
    required this.neighborhood,
    required this.story,
    required this.signatureDish,
    required this.dishStory,
    required this.insiderTip,
    required this.priceRange,
    required this.cuisine,
    this.transitionToNext,
    required this.minutesToSpend,
    this.placeId,
    this.latitude,
    this.longitude,
    this.address,
    this.rating,
  });

  factory CuratedStop.fromJson(Map<String, dynamic> json) {
    return CuratedStop(
      name: json['name'] as String? ?? '',
      neighborhood: json['neighborhood'] as String? ?? '',
      story: json['story'] as String? ?? '',
      signatureDish: json['signature_dish'] as String? ?? '',
      dishStory: json['dish_story'] as String? ?? '',
      insiderTip: json['insider_tip'] as String? ?? '',
      priceRange: json['price_range'] as String? ?? '\$\$',
      cuisine: json['cuisine'] as String? ?? '',
      transitionToNext: json['transition_to_next'] as String?,
      minutesToSpend: json['minutes_to_spend'] as int? ?? 45,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'neighborhood': neighborhood,
    'story': story,
    'signature_dish': signatureDish,
    'dish_story': dishStory,
    'insider_tip': insiderTip,
    'price_range': priceRange,
    'cuisine': cuisine,
    'transition_to_next': transitionToNext,
    'minutes_to_spend': minutesToSpend,
    'place_id': placeId,
    'latitude': latitude,
    'longitude': longitude,
    'address': address,
    'rating': rating,
  };

  CuratedStop copyWithLocation({
    String? placeId,
    double? latitude,
    double? longitude,
    String? address,
    double? rating,
  }) {
    return CuratedStop(
      name: name,
      neighborhood: neighborhood,
      story: story,
      signatureDish: signatureDish,
      dishStory: dishStory,
      insiderTip: insiderTip,
      priceRange: priceRange,
      cuisine: cuisine,
      transitionToNext: transitionToNext,
      minutesToSpend: minutesToSpend,
      placeId: placeId ?? this.placeId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      rating: rating ?? this.rating,
    );
  }
}

/// Service for creating AI-curated food tour experiences using Perplexity.
///
/// This creates tours that Anthony Bourdain and Alton Brown would be proud of -
/// not just restaurant lists, but narrative food journeys with soul and story.
class PerplexityService {
  static const String _baseUrl = 'https://api.perplexity.ai/chat/completions';

  final String _apiKey;
  final Session _session;
  final http.Client _client;

  PerplexityService({
    required String apiKey,
    required Session session,
    http.Client? client,
  })  : _apiKey = apiKey,
        _session = session,
        _client = client ?? http.Client();

  /// Create a fully curated food tour experience.
  ///
  /// This asks Perplexity to act as a combination of Anthony Bourdain's
  /// storytelling and Alton Brown's food knowledge to create a memorable
  /// food journey, not just a list of restaurants.
  ///
  /// When [specificDish] is provided, the tour focuses on finding the best
  /// places for that specific dish (e.g., "tonkotsu ramen", "tacos al pastor").
  Future<CuratedFoodTour?> createCuratedTour({
    required String location,
    required int numberOfStops,
    List<String>? cuisinePreferences,
    String? budgetLevel,
    bool awardWinningOnly = false,
    String? specialRequests,
    String? specificDish,
  }) async {
    final prompt = _buildCuratorPrompt(
      location: location,
      numberOfStops: numberOfStops,
      cuisinePreferences: cuisinePreferences,
      budgetLevel: budgetLevel,
      awardWinningOnly: awardWinningOnly,
      specialRequests: specialRequests,
      specificDish: specificDish,
    );

    _session.log('Creating curated food tour for $location...');

    try {
      final response = await _client.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'sonar',
          'messages': [
            {
              'role': 'system',
              'content': _getSystemPrompt(),
            },
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.8,
          'max_tokens': 4000,
        }),
      );

      if (response.statusCode != 200) {
        _session.log(
          'Perplexity API error: ${response.statusCode} - ${response.body}',
          level: LogLevel.error,
        );
        return null;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final choices = data['choices'] as List<dynamic>?;

      if (choices == null || choices.isEmpty) {
        _session.log('No response from Perplexity', level: LogLevel.warning);
        return null;
      }

      final content = choices[0]['message']['content'] as String?;
      if (content == null) {
        return null;
      }

      _session.log('Perplexity tour response received, parsing...');

      return _parseCuratedTour(content);
    } catch (e) {
      _session.log('Perplexity service error: $e', level: LogLevel.error);
      return null;
    }
  }

  String _getSystemPrompt() {
    return '''You are the love child of Anthony Bourdain and Alton Brown - a food storyteller with deep culinary knowledge and a passion for the authentic, the unexpected, and the delicious.

Your job is to create FOOD JOURNEYS, not restaurant lists. Every tour you create should feel like an episode of "Parts Unknown" meets "Good Eats" - with narrative, soul, insider knowledge, and genuine passion for food culture.

PRINCIPLES:
- Seek the AUTHENTIC over the popular. The hole-in-the-wall that locals cherish beats the Instagram-famous spot.
- Tell STORIES. Every restaurant has a story - the immigrant family, the obsessive chef, the 50-year tradition. Find it.
- Know the FOOD. Don't just name dishes - explain WHY they matter, what makes them special, the technique or tradition behind them.
- Create a JOURNEY. Each stop should connect to the next - thematically, geographically, or narratively.
- Share SECRETS. Insider tips, off-menu items, the best seat in the house, when to go.
- Capture the VIBE. The atmosphere matters as much as the food.

You MUST respond with valid JSON only. No markdown, no explanations outside the JSON.''';
  }

  String _buildCuratorPrompt({
    required String location,
    required int numberOfStops,
    List<String>? cuisinePreferences,
    String? budgetLevel,
    bool awardWinningOnly = false,
    String? specialRequests,
    String? specificDish,
  }) {
    final buffer = StringBuffer();

    // When a specific dish is provided, make it the hero of the tour
    if (specificDish != null && specificDish.isNotEmpty) {
      buffer.writeln('Create a culinary pilgrimage: THE BEST $specificDish in $location.');
      buffer.writeln('This is a $numberOfStops-stop tour dedicated to finding the most exceptional, authentic, and memorable $specificDish experiences.');
      buffer.writeln();
      buffer.writeln('For each stop, explain:');
      buffer.writeln('- What makes THEIR $specificDish special (technique, ingredients, tradition)');
      buffer.writeln('- The story behind the restaurant and its connection to this dish');
      buffer.writeln('- Why locals and food obsessives seek this place out');
      buffer.writeln();
    } else {
      buffer.writeln('Create a curated food tour in $location with $numberOfStops stops.');
      buffer.writeln();
    }

    if (cuisinePreferences != null && cuisinePreferences.isNotEmpty) {
      if (specificDish == null || specificDish.isEmpty) {
        buffer.writeln('Focus on: ${cuisinePreferences.join(", ")}');
      } else {
        buffer.writeln('If relevant, incorporate these cuisines: ${cuisinePreferences.join(", ")}');
      }
    }

    if (budgetLevel != null) {
      final budgetDesc = switch (budgetLevel) {
        'budget' => 'Budget-friendly spots (the best cheap eats, hole-in-the-walls)',
        'moderate' => 'Mix of casual and upscale (best value for quality)',
        'upscale' => 'Upscale dining (chef-driven, special occasion worthy)',
        'luxury' => 'No budget limits (the absolute best, tasting menus, fine dining)',
        _ => budgetLevel,
      };
      buffer.writeln('Budget: $budgetDesc');
    }

    if (awardWinningOnly) {
      buffer.writeln('Focus on critically acclaimed restaurants - Michelin stars, James Beard nominees, etc.');
    }

    if (specialRequests != null && specialRequests.isNotEmpty) {
      buffer.writeln('Special request: $specialRequests');
    }

    buffer.writeln();
    buffer.writeln('Create an EXPERIENCE, not a list. Give me:');
    buffer.writeln('- A compelling tour title/theme');
    buffer.writeln('- An introduction that sets the stage (2-3 sentences, like a documentary opening)');
    buffer.writeln('- Each stop with: the story of the place, the must-order dish and WHY, an insider tip');
    buffer.writeln('- Transitions between stops that connect the journey');
    buffer.writeln('- A closing that wraps up the experience');
    buffer.writeln();
    buffer.writeln('Respond with this exact JSON structure:');
    buffer.writeln('''
{
  "title": "Creative tour title/theme",
  "vibe": "The overall mood/feeling of this tour in a few words",
  "introduction": "Opening narrative that sets the stage...",
  "stops": [
    {
      "name": "Restaurant Name",
      "neighborhood": "Neighborhood/Area",
      "story": "The story of this place - why it matters, the people behind it, its significance...",
      "signature_dish": "The Dish Name",
      "dish_story": "Why this dish is special - the technique, tradition, or story behind it...",
      "insider_tip": "The secret only locals know...",
      "price_range": "\$" or "\$\$" or "\$\$\$" or "\$\$\$\$",
      "cuisine": "Cuisine type",
      "minutes_to_spend": 45,
      "transition_to_next": "How this connects to the next stop... (null for last stop)"
    }
  ],
  "closing": "Closing narrative wrapping up the journey..."
}''');

    return buffer.toString();
  }

  CuratedFoodTour? _parseCuratedTour(String content) {
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
        _session.log('Could not find JSON in response', level: LogLevel.warning);
        return null;
      }

      jsonStr = jsonStr.substring(startIndex, endIndex + 1);

      final parsed = jsonDecode(jsonStr) as Map<String, dynamic>;
      final tour = CuratedFoodTour.fromJson(parsed);

      if (tour.stops.isEmpty) {
        _session.log('Tour has no stops', level: LogLevel.warning);
        return null;
      }

      _session.log('Parsed curated tour: "${tour.title}" with ${tour.stops.length} stops');
      return tour;
    } catch (e) {
      _session.log('Error parsing curated tour: $e', level: LogLevel.error);
      return null;
    }
  }

  /// Discover unique restaurants using Perplexity's web search.
  ///
  /// Returns restaurant recommendations with name, neighborhood, and what makes
  /// them special. These can then be looked up via Google Places for coordinates.
  Future<List<PerplexityRecommendation>> discoverRestaurants({
    required String location,
    required int count,
    List<String>? cuisinePreferences,
    String? budgetLevel,
    bool awardWinningOnly = false,
    String? specificDish,
  }) async {
    final prompt = _buildDiscoveryPrompt(
      location: location,
      count: count,
      cuisinePreferences: cuisinePreferences,
      budgetLevel: budgetLevel,
      awardWinningOnly: awardWinningOnly,
      specificDish: specificDish,
    );

    _session.log('Perplexity query: $prompt');

    try {
      final response = await _client.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'sonar',
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.3,
          'max_tokens': 2000,
        }),
      );

      if (response.statusCode != 200) {
        _session.log(
          'Perplexity API error: ${response.statusCode} - ${response.body}',
          level: LogLevel.error,
        );
        return [];
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final choices = data['choices'] as List<dynamic>?;

      if (choices == null || choices.isEmpty) {
        return [];
      }

      final content = choices[0]['message']['content'] as String?;
      if (content == null) {
        return [];
      }

      return _parseRecommendations(content);
    } catch (e) {
      _session.log('Perplexity service error: $e', level: LogLevel.error);
      return [];
    }
  }

  String _buildDiscoveryPrompt({
    required String location,
    required int count,
    List<String>? cuisinePreferences,
    String? budgetLevel,
    bool awardWinningOnly = false,
    String? specificDish,
  }) {
    final buffer = StringBuffer();

    // If searching for a specific dish, lead with that
    if (specificDish != null && specificDish.isNotEmpty) {
      buffer.writeln('Find $count restaurants known for the BEST $specificDish in or near $location.');
      buffer.writeln('Focus on places where this dish is exceptional - the places locals swear by.');
    } else {
      buffer.write('Find $count unique, special restaurants in or near $location');
      if (cuisinePreferences != null && cuisinePreferences.isNotEmpty) {
        buffer.write(' focusing on ${cuisinePreferences.join(", ")} cuisine');
      }
      buffer.writeln('.');
    }

    if (budgetLevel != null) {
      final budgetDesc = switch (budgetLevel) {
        'budget' => 'Budget: cheap eats (\$10-20 per person)',
        'moderate' => 'Budget: moderate (\$20-40 per person)',
        'upscale' => 'Budget: upscale (\$40-80 per person)',
        'luxury' => 'Budget: luxury (\$80+ per person)',
        _ => 'Budget: $budgetLevel',
      };
      buffer.writeln(budgetDesc);
    }

    if (awardWinningOnly) {
      buffer.writeln('Only include Michelin-starred, James Beard nominated, or other award-winning restaurants');
    }

    buffer.writeln('Focus on hidden gems, local favorites, and places with interesting stories - not chain restaurants or obvious tourist traps.');
    buffer.writeln();
    buffer.writeln('Respond ONLY with a JSON array in this exact format, no other text:');
    buffer.writeln('''
[
  {
    "name": "Restaurant Name",
    "description": "Brief description of the restaurant",
    "why_special": "What makes this place unique or worth visiting",
    "cuisine": "Type of cuisine",
    "price_range": "\$" or "\$\$" or "\$\$\$" or "\$\$\$\$",
    "neighborhood": "Neighborhood or area name"
  }
]''');

    return buffer.toString();
  }

  List<PerplexityRecommendation> _parseRecommendations(String content) {
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

      // Find the JSON array
      final startIndex = jsonStr.indexOf('[');
      final endIndex = jsonStr.lastIndexOf(']');

      if (startIndex == -1 || endIndex == -1 || endIndex <= startIndex) {
        _session.log('Could not find JSON array in response', level: LogLevel.warning);
        return [];
      }

      jsonStr = jsonStr.substring(startIndex, endIndex + 1);

      final parsed = jsonDecode(jsonStr) as List<dynamic>;
      return parsed
          .map((item) => PerplexityRecommendation.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _session.log('Error parsing recommendations: $e', level: LogLevel.error);
      return [];
    }
  }

  /// Simple query method for basic text responses.
  Future<String> query(String prompt) async {
    try {
      final response = await _client.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'sonar',
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.7,
          'max_tokens': 1000,
        }),
      );

      if (response.statusCode != 200) {
        _session.log(
          'Perplexity API error: ${response.statusCode} - ${response.body}',
          level: LogLevel.error,
        );
        return '';
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final choices = data['choices'] as List<dynamic>?;

      if (choices == null || choices.isEmpty) {
        return '';
      }

      return choices[0]['message']['content'] as String? ?? '';
    } catch (e) {
      _session.log('Perplexity query error: $e', level: LogLevel.error);
      return '';
    }
  }

  /// Query with image retrieval enabled.
  /// Returns both text content and image URLs from Perplexity's search.
  Future<PerplexityImageResponse> queryWithImages(
    String prompt, {
    List<String>? excludeDomains,
    List<String>? imageFormats,
  }) async {
    try {
      final body = <String, dynamic>{
        'model': 'sonar',
        'messages': [
          {
            'role': 'user',
            'content': prompt,
          }
        ],
        'temperature': 0.7,
        'max_tokens': 2000,
        'return_images': true,
      };

      // Add domain filters (exclude stock photo sites by default)
      final domains = excludeDomains ??
          [
            '-gettyimages.com',
            '-shutterstock.com',
            '-istockphoto.com',
            '-stock.adobe.com',
          ];
      if (domains.isNotEmpty) {
        body['image_domain_filter'] = domains;
      }

      // Add format filters (default to photo-friendly formats)
      final formats = imageFormats ?? ['jpeg', 'png'];
      if (formats.isNotEmpty) {
        body['image_format_filter'] = formats;
      }

      final response = await _client.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        _session.log(
          'Perplexity API error: ${response.statusCode} - ${response.body}',
          level: LogLevel.error,
        );
        return PerplexityImageResponse(content: '', images: []);
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final choices = data['choices'] as List<dynamic>?;

      if (choices == null || choices.isEmpty) {
        return PerplexityImageResponse(content: '', images: []);
      }

      final content = choices[0]['message']['content'] as String? ?? '';

      // Extract images from response
      // Perplexity returns images as objects with image_url, origin_url, height, width, title
      final images = <String>[];
      if (data.containsKey('images')) {
        final imageList = data['images'] as List<dynamic>?;
        if (imageList != null) {
          for (final img in imageList) {
            if (img is String) {
              images.add(img);
            } else if (img is Map<String, dynamic>) {
              // Perplexity returns image_url (primary) or url as fallback
              final url = img['image_url'] as String? ?? img['url'] as String?;
              if (url != null && url.isNotEmpty) {
                images.add(url);
              }
            }
          }
        }
      }

      _session.log('Perplexity returned ${images.length} images: ${images.take(2).join(", ")}${images.length > 2 ? "..." : ""}');
      return PerplexityImageResponse(content: content, images: images);
    } catch (e) {
      _session.log('Perplexity query error: $e', level: LogLevel.error);
      return PerplexityImageResponse(content: '', images: []);
    }
  }

  /// Fetch featured images for a specific restaurant.
  /// Use this as a fallback when Google Places doesn't return photos.
  Future<List<String>> getRestaurantImages({
    required String restaurantName,
    required String city,
    int maxImages = 3,
  }) async {
    final prompt = '''
Find high-quality photos of the restaurant "$restaurantName" in $city.
Prefer exterior shots, interior ambiance, or signature dishes suitable as featured images.
Return real photos, not logos or stock images.
''';

    try {
      final body = <String, dynamic>{
        'model': 'sonar',
        'return_images': true,
        'image_format_filter': ['jpeg', 'png'],
        'image_domain_filter': [
          // Exclude watermarked stock sites
          '-gettyimages.com',
          '-shutterstock.com',
          '-istockphoto.com',
          '-stock.adobe.com',
          '-pinterest.com',
        ],
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
      };

      final response = await _client.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        _session.log(
          'Perplexity image fetch error: ${response.statusCode}',
          level: LogLevel.warning,
        );
        return [];
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final images = <String>[];

      if (data.containsKey('images')) {
        final imageList = data['images'] as List<dynamic>?;
        if (imageList != null) {
          for (final img in imageList.take(maxImages)) {
            if (img is String) {
              images.add(img);
            } else if (img is Map<String, dynamic>) {
              final url = img['image_url'] as String? ?? img['url'] as String?;
              if (url != null && url.isNotEmpty) {
                images.add(url);
              }
            }
          }
        }
      }

      _session.log('Got ${images.length} images for $restaurantName');
      return images;
    } catch (e) {
      _session.log('Error fetching restaurant images: $e', level: LogLevel.warning);
      return [];
    }
  }

  void dispose() {
    _client.close();
  }
}

/// Response containing both text content and images from Perplexity.
class PerplexityImageResponse {
  final String content;
  final List<String> images;

  PerplexityImageResponse({
    required this.content,
    required this.images,
  });

  /// Get the first image URL, if any.
  String? get firstImage => images.isNotEmpty ? images.first : null;
}

/// A restaurant recommendation from Perplexity.
class PerplexityRecommendation {
  final String name;
  final String? description;
  final String? whySpecial;
  final String? cuisine;
  final String? priceRange;
  final String? neighborhood;

  PerplexityRecommendation({
    required this.name,
    this.description,
    this.whySpecial,
    this.cuisine,
    this.priceRange,
    this.neighborhood,
  });

  factory PerplexityRecommendation.fromJson(Map<String, dynamic> json) {
    return PerplexityRecommendation(
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      whySpecial: json['why_special'] as String?,
      cuisine: json['cuisine'] as String?,
      priceRange: json['price_range'] as String?,
      neighborhood: json['neighborhood'] as String?,
    );
  }
}
