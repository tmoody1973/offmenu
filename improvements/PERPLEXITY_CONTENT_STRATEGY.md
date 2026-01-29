# Perplexity API Content Generation Strategy
## AI-Powered Restaurant Stories & Eater-Style Maps for Food Tour Butler

---

# 🎯 OVERVIEW

This guide shows you how to use Perplexity API to generate **all** content for Food Tour Butler:
- Restaurant origin stories (Bourdain-style narratives)
- "Current Intel" (real-time buzz, chef changes, closures)
- Eater-style neighborhood maps with thematic storytelling
- Tour narratives with cultural context
- Dish recommendations with sourcing stories

**Cost Estimate:** ~$25-40/month for 5,000 requests (well within hackathon budget)

---

# 🏗️ ARCHITECTURE

## Content Generation Pipeline

```
┌─────────────────────────────────────────────────────────────────┐
│                    CONTENT GENERATION PIPELINE                   │
└─────────────────────────────────────────────────────────────────┘

User Request (City/Neighborhood)
         │
         ▼
┌─────────────────┐     ┌──────────────────┐     ┌──────────────┐
│  Perplexity API │────▶│  Content Parser  │────▶│  Structured  │
│    (Research)   │     │   (Extract Data) │     │    Output    │
└─────────────────┘     └──────────────────┘     └──────────────┘
         │                                               │
         │                                               ▼
         │                                        ┌──────────────┐
         │                                        │  Flutter App │
         │                                        │   (Display)  │
         │                                        └──────────────┘
         │
         ▼
┌─────────────────┐
│  PostgreSQL     │
│  (Cache 24-48h) │
└─────────────────┘
```

---

# 📝 PERPLEXITY PROMPT TEMPLATES

## 1. Restaurant Origin Story Generator

**Purpose:** Create Bourdain-style narratives about restaurants

```dart
const String restaurantStoryPrompt = '''
You are a food writer in the style of Anthony Bourdain. Write a compelling origin story for this restaurant:

RESTAURANT: {restaurantName}
LOCATION: {city}, {neighborhood}
CUISINE: {cuisineType}
CHEF/OWNER: {chefName} (if known)

Write 3-4 paragraphs covering:
1. THE HOOK: Open with something intriguing - a surprising fact, a bold statement, or the chef's philosophy
2. THE ORIGIN: How did this restaurant come to be? What's the chef's journey?
3. THE PHILOSOPHY: What makes this place different? What's their approach to food?
4. WHY IT MATTERS: Why should someone visit? What will they experience?

Tone: Warm, knowledgeable, slightly irreverent. Avoid PR-speak. Include specific details.
Length: 200-250 words.
'''
```

**Example Output:**
```
"Kasama doesn't look like a Michelin restaurant. It looks like the kind of place where Titas (aunts) gather over pork belly and gossip. And that's exactly the point.

Timothy Flores grew up watching his grandmother make longganisa in their California kitchen. She never wrote down recipes—'You learn by tasting,' she'd say. Decades later, after staging at Alinea and Quay in Sydney, Flores returned to those flavors with a question: What if Filipino food could be both elevated and deeply authentic?

Kasama—'together' in Tagalog—opened in 2020 with his wife Genie Kwon. By 2022, it was Chicago's first Filipino restaurant to earn a Michelin star. But Flores isn't trying to be fine dining Filipino. He's trying to be himself.

The result? Longganisa that tastes like memory. Ube desserts that make you close your eyes. And a room full of people discovering that Filipino food isn't just comfort food—it's revelation."
```

---

## 2. "Current Intel" Generator

**Purpose:** Real-time updates about restaurants (openings, closings, chef changes, buzz)

```dart
const String currentIntelPrompt = '''
You are a local food expert. Provide current intelligence about this restaurant:

RESTAURANT: {restaurantName}
LOCATION: {city}

Research and provide:
1. CURRENT STATUS: Is it open? Any recent issues or closures?
2. RECENT BUZZ: What's being said about this place in the last 3 months?
3. CHEF/OWNERSHIP: Any recent changes?
4. MENU UPDATES: New dishes, seasonal menus, or specials?
5. WAIT TIMES: How hard is it to get a table?
6. SENTIMENT: Overall positive, mixed, or negative?

Format as JSON:
{
  "status": "open|closed|temporarily_closed",
  "issues": ["list any issues"],
  "recentBuzz": "paragraph summary",
  "chefChanges": "any changes or 'none reported'",
  "menuUpdates": ["list updates"],
  "waitTimes": "description",
  "sentiment": "positive|mixed|negative",
  "confidence": "high|medium|low"
}

Cite sources. Be factual. If uncertain, say so.
'''
```

---

## 3. Eater-Style Neighborhood Map Generator

**Purpose:** Generate thematic restaurant maps like "Best Tacos in Logan Square" or "James Beard Winners in Chicago"

```dart
const String eaterMapPrompt = '''
You are creating an Eater-style restaurant map for a food publication. Create a curated guide for:

THEME: {theme} (e.g., "Best Tacos", "James Beard Winners", "Late-Night Eats")
LOCATION: {neighborhood}, {city}

Provide 6-8 restaurants that fit this theme. For each:

1. NAME: Restaurant name
2. WHY IT'S ON THIS MAP: One sentence hook
3. THE STORY: 2-3 sentences about what makes it special
4. MUST-TRY: The signature dish or order
5. PRICE: $ | $$ | $$$ | $$$$
6. GOOD FOR: Date night, solo dining, groups, etc.
7. ADDRESS: Full address
8. CITATION: Source URL

Format as JSON array:
[
  {
    "name": "Restaurant Name",
    "hook": "Why it's here",
    "story": "The narrative",
    "mustTry": "Signature dish",
    "price": "$$",
    "goodFor": ["date night", "groups"],
    "address": "123 Main St",
    "citation": "https://..."
  }
]

Tone: Editorial, opinionated, knowledgeable. Like you're recommending to a friend.
Include diverse options (price points, vibes, cuisines if applicable).
'''
```

**Example Output:**
```json
[
  {
    "name": "L'Patron",
    "hook": "The taco truck that grew up and got serious about masa",
    "story": "After years running a beloved truck, the Cuevas family opened this brick-and-mortar in 2015. The tortillas are still pressed to order, the carnitas still slow-cooked in lard. But now there's mezcal and a patio.",
    "mustTry": "Carnitas taco with extra cilantro and onion",
    "price": "$$",
    "goodFor": ["casual dinner", "taco pilgrimage"],
    "address": "2815 W Diversey Ave, Chicago",
    "citation": "https://chicago.eater.com/lpatron"
  }
]
```

---

## 4. Tour Narrative Generator

**Purpose:** Create progressive dining tour stories that connect multiple restaurants

```dart
const String tourNarrativePrompt = '''
You are a culinary tour guide. Create a narrative for this food tour:

TOUR THEME: {theme} (e.g., "Logan Square Evolution", "Chinatown Dim Sum Crawl")
STOPS: {stopList} (list of 3-5 restaurants)
TRANSPORT: {walking|driving}
TOTAL TIME: {duration} hours

Write:
1. TOUR INTRO (100 words): Set the scene. What's the story of this neighborhood/cuisine?
2. THE JOURNEY: For each stop, write 2-3 sentences:
   - Why this stop is here
   - What to order
   - How it connects to the next stop
3. PROGRESSION LOGIC: Explain the flow (light to heavy, casual to fancy, historical to modern, etc.)
4. INSIDER TIP: One piece of advice for the tour-taker

Tone: Enthusiastic, knowledgeable, like a friend showing you their city.
Include sensory details: smells, sounds, atmosphere.
'''
```

**Example Output:**
```
"Logan Square was once a Norwegian enclave, then Puerto Rican, now a kaleidoscope. This tour traces that evolution through four kitchens—each one a different chapter of the neighborhood's story.

Start at L'Patron (12:00 PM), where the Cuevas family has been hand-pressing tortillas since their truck days. The carnitas taco is a masterclass in fat and acid balance—start light, you'll need room.

Walk 8 minutes to Spinning J (12:45 PM), a palate cleanser in a 1950s soda fountain. Get an egg cream and whatever pie they're pushing today. The sugar rush will carry you to...

[Continue for each stop...]

INSIDER TIP: Save room for the ube cookie at the end. You'll want to take one home, but eat it while it's fresh."
```

---

## 5. "Why This Matters" (Alton Brown Style) Generator

**Purpose:** Educational content about cuisines, ingredients, and techniques

```dart
const String whyItMattersPrompt = '''
You are a food educator in the style of Alton Brown. Explain why this cuisine/dish/technique matters:

TOPIC: {topic} (e.g., "Filipino Cuisine", "Longganisa sausage", "Calamansi")
CONTEXT: {restaurantName} in {city}

Write 150-200 words covering:
1. WHAT IT IS: Define the topic simply
2. THE HISTORY: Brief cultural/geographic context
3. THE SCIENCE/TECHNIQUE: Why it's prepared this way
4. WHY IT'S SPECIAL HERE: How this restaurant does it differently

Tone: Educational but accessible. Use analogies. Make it interesting to a curious diner.
Avoid being preachy or academic.
'''
```

**Example Output:**
```
"Filipino food is often called the 'original fusion'—centuries of Spanish, Chinese, Malay, and American influence layered over indigenous techniques. The result? A cuisine that balances sour (suka), sweet, and umami like a tightrope walker.

Take calamansi. This tiny citrus—about the size of a key lime—grows throughout the Philippines and shows up in everything from marinades to cocktails. It's more tart than a lemon but with a floral complexity that makes your mouth water.

At Kasama, chef Timothy Flores uses calamansi where a French kitchen might use lemon—but the effect is entirely different. The acid cuts through rich pork dishes, but the floral notes add something lemon simply can't. It's not substitution. It's translation."
```

---

## 6. Dish Recommendation Generator

**Purpose:** Generate specific dish recommendations with sourcing stories

```dart
const String dishRecommendationPrompt = '''
You are a food critic. Recommend specific dishes at this restaurant:

RESTAURANT: {restaurantName}
LOCATION: {city}
CUISINE: {cuisineType}

Provide 3-4 dishes:

1. THE SIGNATURE: The dish everyone talks about
2. THE HIDDEN GEM: Something underrated that locals love
3. THE ADVENTURE: For the brave eater
4. THE SKIP: What to avoid (be honest)

For each dish, provide:
- Name
- Why to order it (or skip it)
- Flavor profile
- Best shared or solo?

Tone: Opinionated, specific, honest. Like you're texting a friend.
'''
```

---

# 🗺️ EATER-STYLE MAP IMPLEMENTATION

## Map Types to Generate

### 1. Award Winners Map
```dart
const String awardWinnersMapPrompt = '''
Create an Eater-style map of James Beard Award winners and Michelin-starred restaurants in {city}.

For each restaurant:
- Name and award (James Beard Winner/Nominee/Semifinalist, Michelin stars)
- Year awarded
- Why it matters (2 sentences)
- Signature dish
- Price point
- Neighborhood

Format as JSON array. Include 8-10 restaurants.
'''
```

### 2. Neighborhood Guide Map
```dart
const String neighborhoodGuidePrompt = '''
Create a comprehensive food map of {neighborhood} in {city}.

Include categories:
- Breakfast/Brunch (2-3 spots)
- Lunch (2-3 spots)
- Dinner - Casual (2-3 spots)
- Dinner - Special Occasion (2-3 spots)
- Late Night (1-2 spots)
- Drinks (2-3 spots)

For each: Name, hook, must-try, price, vibe.
Format as JSON with category grouping.
'''
```

### 3. Thematic Map
```dart
const String thematicMapPrompt = '''
Create an Eater-style map: "Best {cuisine} in {city}"

Include 6-8 restaurants. For each:
- Name
- Hook (why it's special)
- The Story (2-3 sentences)
- Must-Try dish
- Price
- Address
- Good for (date night, groups, solo, etc.)

Diversity matters: Mix price points, neighborhoods, vibes.
'''
```

---

# 💻 FLUTTER + SERVERPOD IMPLEMENTATION

## 1. Serverpod Endpoint

```dart
// server/lib/src/endpoints/content_endpoint.dart
import 'package:serverpod/serverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContentEndpoint extends Endpoint {
  final String _perplexityApiKey = const String.fromEnvironment('PERPLEXITY_API_KEY');
  final String _perplexityBaseUrl = 'https://api.perplexity.ai/chat/completions';
  
  // Cache for 24 hours
  final Map<String, CachedContent> _cache = {};
  
  /// Generate restaurant story
  Future<RestaurantStory> generateStory(
    Session session, {
    required String restaurantName,
    required String city,
    required String cuisine,
    String? chefName,
  }) async {
    final cacheKey = 'story_$restaurantName_$city';
    
    // Check cache
    if (_cache.containsKey(cacheKey) && !_cache[cacheKey]!.isExpired) {
      session.log('Returning cached story for $restaurantName');
      return _cache[cacheKey]!.content as RestaurantStory;
    }
    
    final prompt = '''
    You are a food writer in the style of Anthony Bourdain. Write a compelling origin story for:
    
    RESTAURANT: $restaurantName
    LOCATION: $city
    CUISINE: $cuisine
    ${chefName != null ? 'CHEF: $chefName' : ''}
    
    Write 3-4 paragraphs covering: The Hook, The Origin, The Philosophy, Why It Matters.
    Tone: Warm, knowledgeable, slightly irreverent. 200-250 words.
    ''';
    
    final response = await _callPerplexity(prompt, session);
    
    final story = RestaurantStory(
      restaurantName: restaurantName,
      content: response['content'],
      citations: response['citations'],
      generatedAt: DateTime.now(),
    );
    
    // Cache for 48 hours
    _cache[cacheKey] = CachedContent(
      content: story,
      expiresAt: DateTime.now().add(Duration(hours: 48)),
    );
    
    return story;
  }
  
  /// Generate Eater-style map
  Future<List<MapRestaurant>> generateMap(
    Session session, {
    required String theme,
    required String neighborhood,
    required String city,
  }) async {
    final cacheKey = 'map_${theme}_${neighborhood}_$city';
    
    if (_cache.containsKey(cacheKey) && !_cache[cacheKey]!.isExpired) {
      return _cache[cacheKey]!.content as List<MapRestaurant>;
    }
    
    final prompt = '''
    Create an Eater-style restaurant map for:
    
    THEME: $theme
    LOCATION: $neighborhood, $city
    
    Provide 6-8 restaurants as JSON array with:
    - name, hook, story, mustTry, price, goodFor, address, citation
    
    Tone: Editorial, opinionated. Include diverse options.
    ''';
    
    final response = await _callPerplexity(prompt, session);
    
    // Parse JSON from response
    final List<dynamic> jsonList = jsonDecode(response['content']);
    final restaurants = jsonList.map((j) => MapRestaurant.fromJson(j)).toList();
    
    // Cache for 24 hours
    _cache[cacheKey] = CachedContent(
      content: restaurants,
      expiresAt: DateTime.now().add(Duration(hours: 24)),
    );
    
    return restaurants;
  }
  
  /// Generate "Current Intel"
  Future<CurrentIntel> generateIntel(
    Session session, {
    required String restaurantName,
    required String city,
  }) async {
    final cacheKey = 'intel_$restaurantName_$city';
    
    // Intel changes frequently - cache only 6 hours
    if (_cache.containsKey(cacheKey) && !_cache[cacheKey]!.isExpired) {
      return _cache[cacheKey]!.content as CurrentIntel;
    }
    
    final prompt = '''
    Provide current intelligence about $restaurantName in $city.
    
    Research: Current status, recent buzz (last 3 months), chef changes, 
    menu updates, wait times, sentiment.
    
    Format as JSON with fields: status, issues, recentBuzz, chefChanges, 
    menuUpdates, waitTimes, sentiment, confidence.
    
    Cite sources. Be factual.
    ''';
    
    final response = await _callPerplexity(prompt, session);
    
    final intel = CurrentIntel.fromJson(jsonDecode(response['content']));
    intel.citations = response['citations'];
    
    _cache[cacheKey] = CachedContent(
      content: intel,
      expiresAt: DateTime.now().add(Duration(hours: 6)),
    );
    
    return intel;
  }
  
  /// Core Perplexity API call
  Future<Map<String, dynamic>> _callPerplexity(String prompt, Session session) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      final response = await http.post(
        Uri.parse(_perplexityBaseUrl),
        headers: {
          'Authorization': 'Bearer $_perplexityApiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'sonar', // or 'sonar-pro' for complex queries
          'messages': [
            {
              'role': 'system',
              'content': 'You are a local food expert. Provide concise, '
                  'current information about restaurants. Always cite sources. '
                  'Respond in the requested format.',
            },
            {
              'role': 'user',
              'content': prompt,
            },
          ],
          'search_domain_filter': [
            'eater.com',
            'timeout.com',
            'chicagotribune.com',
            'chicagomag.com',
            'bonappetit.com',
            'seriouseats.com',
          ],
          'return_citations': true,
          'search_recency_filter': 'month',
          'temperature': 0.7,
        }),
      ).timeout(Duration(seconds: 30));
      
      stopwatch.stop();
      session.log('Perplexity call took ${stopwatch.elapsedMilliseconds}ms');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'content': data['choices'][0]['message']['content'],
          'citations': data['citations'] ?? [],
        };
      } else {
        throw Exception('Perplexity API error: ${response.statusCode}');
      }
    } catch (e) {
      session.log('Perplexity error: $e');
      throw Exception('Failed to generate content: $e');
    }
  }
}

// Cache helper class
class CachedContent {
  final dynamic content;
  final DateTime expiresAt;
  
  CachedContent({required this.content, required this.expiresAt});
  
  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
```

---

## 2. Flutter Repository

```dart
// lib/data/repositories/content_repository.dart
import 'package:food_tour_butler/client.dart';

class ContentRepository {
  final Client _client;
  
  ContentRepository(this._client);
  
  Future<RestaurantStory> getRestaurantStory({
    required String restaurantName,
    required String city,
    required String cuisine,
    String? chefName,
  }) async {
    return await _client.content.generateStory(
      restaurantName: restaurantName,
      city: city,
      cuisine: cuisine,
      chefName: chefName,
    );
  }
  
  Future<List<MapRestaurant>> getEaterStyleMap({
    required String theme,
    required String neighborhood,
    required String city,
  }) async {
    return await _client.content.generateMap(
      theme: theme,
      neighborhood: neighborhood,
      city: city,
    );
  }
  
  Future<CurrentIntel> getCurrentIntel({
    required String restaurantName,
    required String city,
  }) async {
    return await _client.content.generateIntel(
      restaurantName: restaurantName,
      city: city,
    );
  }
}
```

---

## 3. Flutter UI - Eater-Style Map Screen

```dart
// lib/features/maps/eater_style_map_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EaterStyleMapScreen extends ConsumerWidget {
  final String theme;
  final String neighborhood;
  final String city;
  
  const EaterStyleMapScreen({
    super.key,
    required this.theme,
    required this.neighborhood,
    required this.city,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapAsync = ref.watch(eaterMapProvider(
      theme: theme,
      neighborhood: neighborhood,
      city: city,
    ));
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero header with map preview
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('$theme in $neighborhood'),
              background: MapPreviewPlaceholder(
                neighborhood: neighborhood,
                city: city,
              ),
            ),
          ),
          
          // Restaurant list
          mapAsync.when(
            data: (restaurants) => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => EaterMapCard(
                  restaurant: restaurants[index],
                  index: index + 1,
                ),
                childCount: restaurants.length,
              ),
            ),
            loading: () => SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}

// Individual map card (Eater-style)
class EaterMapCard extends StatelessWidget {
  final MapRestaurant restaurant;
  final int index;
  
  const EaterMapCard({
    super.key,
    required this.restaurant,
    required this.index,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number badge + Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  restaurant.photoUrl ?? 'https://placeholder.com/400x200',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$index',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        restaurant.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Text(
                      restaurant.price,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 8),
                
                // Hook
                Text(
                  restaurant.hook,
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[800],
                  ),
                ),
                
                SizedBox(height: 12),
                
                // Story
                Text(
                  restaurant.story,
                  style: TextStyle(fontSize: 14, height: 1.5),
                ),
                
                SizedBox(height: 12),
                
                // Must Try
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.restaurant, color: Colors.orange[800]),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Must Try: ${restaurant.mustTry}',
                          style: TextStyle(
                            color: Colors.orange[900],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 12),
                
                // Tags
                Wrap(
                  spacing: 8,
                  children: restaurant.goodFor.map((tag) {
                    return Chip(
                      label: Text(tag),
                      backgroundColor: Colors.grey[200],
                      padding: EdgeInsets.zero,
                    );
                  }).toList(),
                ),
                
                SizedBox(height: 8),
                
                // Address + Citation
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        restaurant.address,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ),
                  ],
                ),
                
                if (restaurant.citation != null) ...[
                  SizedBox(height: 4),
                  InkWell(
                    onTap: () => launchUrl(Uri.parse(restaurant.citation!)),
                    child: Text(
                      'Source',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 4. Provider Setup

```dart
// lib/providers/content_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'content_providers.g.dart';

@riverpod
ContentRepository contentRepository(ContentRepositoryRef ref) {
  return ContentRepository(ref.watch(clientProvider));
}

@riverpod
Future<RestaurantStory> restaurantStory(
  RestaurantStoryRef ref, {
  required String restaurantName,
  required String city,
  required String cuisine,
}) async {
  final repo = ref.watch(contentRepositoryProvider);
  return await repo.getRestaurantStory(
    restaurantName: restaurantName,
    city: city,
    cuisine: cuisine,
  );
}

@riverpod
Future<List<MapRestaurant>> eaterMap(
  EaterMapRef ref, {
  required String theme,
  required String neighborhood,
  required String city,
}) async {
  final repo = ref.watch(contentRepositoryProvider);
  return await repo.getEaterStyleMap(
    theme: theme,
    neighborhood: neighborhood,
    city: city,
  );
}

@riverpod
Future<CurrentIntel> currentIntel(
  CurrentIntelRef ref, {
  required String restaurantName,
  required String city,
}) async {
  final repo = ref.watch(contentRepositoryProvider);
  return await repo.getCurrentIntel(
    restaurantName: restaurantName,
    city: city,
  );
}
```

---

# 💰 COST OPTIMIZATION

## Caching Strategy

| Content Type | Cache Duration | Rationale |
|--------------|----------------|-----------|
| Restaurant Stories | 48 hours | Don't change often |
| Eater Maps | 24 hours | Update daily for freshness |
| Current Intel | 6 hours | Changes frequently |
| Tour Narratives | 24 hours | Context-dependent |

## Request Batching

```dart
// Batch multiple restaurant intel requests
Future<List<CurrentIntel>> getBatchIntel(
  List<String> restaurantNames,
  String city,
) async {
  // Make parallel requests
  final futures = restaurantNames.map((name) => 
    getCurrentIntel(restaurantName: name, city: city)
  );
  
  return await Future.wait(futures);
}
```

## Fallback Content

```dart
// If Perplexity fails, use cached or generic content
Future<RestaurantStory> getStoryWithFallback({
  required String restaurantName,
  required String city,
  required String cuisine,
}) async {
  try {
    return await getRestaurantStory(
      restaurantName: restaurantName,
      city: city,
      cuisine: cuisine,
    );
  } catch (e) {
    // Return cached version if available
    final cached = await _localCache.getStory(restaurantName);
    if (cached != null) return cached;
    
    // Return generic template as last resort
    return RestaurantStory(
      restaurantName: restaurantName,
      content: '$restaurantName is a beloved $cuisine spot in $city. '
          'Known for its authentic flavors and welcoming atmosphere, '
          'it\'s a favorite among locals and visitors alike.',
      citations: [],
      generatedAt: DateTime.now(),
    );
  }
}
```

---

# 🎨 DEMO SCRIPT INTEGRATION

## Show Perplexity-Powered Features (0:30-0:50)

```
[0:30-0:35] "The Butler stays current with real-time intelligence."
    Tap: "Current Intel" button on restaurant card
    
[0:35-0:42] Show: "Updated 2 hours ago" with live pulse indicator
    Display: Recent buzz, chef changes, menu updates
    Highlight: Citations from Eater, Tribune, etc.
    
[0:42-0:50] "Every recommendation is backed by real sources."
    Expand: Citations section
    Show: Links to original articles
```

## Eater-Style Map Demo (1:10-1:30)

```
[1:10-1:15] "Explore curated maps like Eater's neighborhood guides."
    Navigate to: "Maps" tab
    Show: "Best Tacos in Logan Square" map
    
[1:15-1:25] Scroll through: 6-8 restaurant cards
    Highlight: Numbered pins, hooks, must-try dishes
    
[1:25-1:30] "Each map is AI-generated and updated daily."
    Pull-to-refresh: Show loading state
    Display: "Updated just now"
```

---

# 📋 IMPLEMENTATION CHECKLIST

## Serverpod Backend
- [ ] Create ContentEndpoint with Perplexity integration
- [ ] Set up caching layer (PostgreSQL or in-memory)
- [ ] Add environment variable for PERPLEXITY_API_KEY
- [ ] Create protocol models (RestaurantStory, CurrentIntel, MapRestaurant)
- [ ] Implement error handling and fallbacks

## Flutter Frontend
- [ ] Create ContentRepository
- [ ] Build Eater-style map screen
- [ ] Add "Current Intel" card to restaurant details
- [ ] Implement map caching with Hive or SQLite
- [ ] Add pull-to-refresh for live updates

## Content Generation
- [ ] Test all 6 prompt templates
- [ ] Fine-tune for your target cities
- [ ] Create fallback content library
- [ ] Set up monitoring for API costs

---

# 🚀 ADVANCED FEATURES

## 1. Personalized Maps

```dart
// Generate map based on user preferences
const String personalizedMapPrompt = '''
Create a personalized restaurant map for a user with these preferences:

LOCATION: {neighborhood}, {city}
PREFERENCES: {userPreferences} (e.g., "vegetarian", "date night", "casual")
AVOID: {avoidCuisines}
BUDGET: {priceRange}

Include 6-8 restaurants that match these criteria.
For each: Explain why it matches their preferences.
'''
```

## 2. Seasonal Content

```dart
// Generate seasonal recommendations
const String seasonalContentPrompt = '''
What's special about {city}'s food scene in {currentMonth}?

Include:
- Seasonal ingredients currently at peak
- Limited-time menu items
- Food events and festivals
- Restaurant openings/closings this month
- Best patios (if summer) or cozy spots (if winter)
'''
```

## 3. Tour Theme Generator

```dart
// Auto-generate tour themes based on trends
const String tourThemePrompt = '''
Based on current food trends in {city}, suggest 5 creative food tour themes.

For each theme:
- Name (catchy, evocative)
- Description (2 sentences)
- 3-4 neighborhoods that fit
- Target audience

Examples: "The Immigrant Journey", "From Cart to Kitchen", "Michelin on a Budget"
'''
```

---

**With this strategy, Perplexity API becomes your content engine, generating everything from Bourdain-style stories to Eater-quality maps—all in real-time with credible sources. 🍽️✨**
