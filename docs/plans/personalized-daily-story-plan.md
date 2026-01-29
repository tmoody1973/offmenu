# Personalized Daily Story - Implementation Plan

## Overview

Transform the hardcoded "Today's Story" on the Daily screen into a dynamic, personalized story that changes daily based on the user's profile, preferences, and cities.

## Current State

The `_LeadStory` widget in `daily_screen.dart` is completely hardcoded:
- Static Unsplash image
- Fixed headline: "The Laotian Grandmother Who's Been Making Larb..."
- Fixed subhead about Sabaidee restaurant

## Goal

Generate unique, personalized food stories daily that:
1. Rotate based on user's cities (home + additional cities)
2. Match user's food philosophy (story-first, dish-first, balanced)
3. Align with adventure level (local explorer, landmark first, etc.)
4. Feature cuisines the user wants to explore
5. Feel like editorial content from Eater/Bon Appetit

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Flutter Client                            │
│  ┌─────────────┐                                            │
│  │ DailyScreen │ ──► calls getDailyStory()                  │
│  └─────────────┘                                            │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    Serverpod Server                          │
│  ┌──────────────────────┐                                   │
│  │ DailyStoryEndpoint   │                                   │
│  │  - getDailyStory()   │ ──► Check cache/DB for today      │
│  │  - generateStory()   │ ──► Generate if needed            │
│  └──────────────────────┘                                   │
│              │                                              │
│              ▼                                              │
│  ┌──────────────────────┐    ┌─────────────────────┐       │
│  │ PerplexityService    │ ◄──│ UserProfile (DB)    │       │
│  │  - Generate story    │    │  - cities           │       │
│  │  - Find restaurant   │    │  - cuisines         │       │
│  └──────────────────────┘    │  - philosophy       │       │
│              │               │  - adventure level  │       │
│              ▼               └─────────────────────┘       │
│  ┌──────────────────────┐                                   │
│  │ GooglePlacesService  │                                   │
│  │  - Get photos        │                                   │
│  │  - Verify restaurant │                                   │
│  └──────────────────────┘                                   │
└─────────────────────────────────────────────────────────────┘
```

---

## Data Model

### New Protocol: `DailyStory` (`daily_story.spy.yaml`)

```yaml
class: DailyStory
table: daily_stories
fields:
  ### User ID this story is for
  userId: String

  ### Date this story is for (YYYY-MM-DD)
  storyDate: String

  ### City the story is about
  city: String
  state: String?
  country: String?

  ### Story content
  headline: String
  subheadline: String
  bodyText: String?

  ### Restaurant featured
  restaurantName: String
  restaurantAddress: String?
  restaurantPlaceId: String?

  ### Photo URLs (proxied through our server)
  heroImageUrl: String
  thumbnailUrl: String?

  ### Story metadata
  storyType: DailyStoryType
  cuisineType: String?

  ### Perplexity citation for authenticity
  sourceUrl: String?

  createdAt: DateTime

indexes:
  daily_story_user_date_idx:
    fields: userId, storyDate
    unique: true
```

### New Enum: `DailyStoryType`

```yaml
enum: DailyStoryType
values:
  - hiddenGem        # "The spot locals won't tell you about"
  - legacyStory      # "22 years in a strip mall" - history/founder stories
  - cuisineDeepDive  # "Why this city's pho is different"
  - chefSpotlight    # "The chef who trained under..."
  - neighborhoodGuide # "The block that's quietly becoming..."
  - seasonalFeature  # "What to eat right now"
```

---

## Implementation Steps

### Phase 1: Backend - Protocol & Endpoint

**Files to create:**
1. `food_butler_server/lib/src/daily/daily_story.spy.yaml`
2. `food_butler_server/lib/src/daily/daily_story_type.spy.yaml`
3. `food_butler_server/lib/src/daily/daily_story_endpoint.dart`

**Endpoint methods:**
```dart
class DailyStoryEndpoint extends Endpoint {
  /// Get today's personalized story for the current user.
  /// Returns cached story if already generated today, otherwise generates new.
  Future<DailyStory?> getDailyStory(Session session) async;

  /// Force refresh today's story (for testing/admin).
  Future<DailyStory> refreshDailyStory(Session session) async;
}
```

### Phase 2: Backend - Story Generation Logic

**In `daily_story_endpoint.dart`:**

```dart
Future<DailyStory> _generateStory(Session session, UserProfile profile) async {
  // 1. Pick a city (rotate through user's cities)
  final city = _pickCityForToday(profile);

  // 2. Determine story type based on profile
  final storyType = _pickStoryType(profile);

  // 3. Build Perplexity prompt based on profile
  final prompt = _buildStoryPrompt(
    city: city,
    storyType: storyType,
    philosophy: profile.foodPhilosophy,
    adventureLevel: profile.adventureLevel,
    wantToTryCuisines: profile.wantToTryCuisines?.split(','),
  );

  // 4. Call Perplexity to generate story
  final perplexityResponse = await perplexityService.generateStory(prompt);

  // 5. Extract restaurant name and get photos from Google Places
  final placeDetails = await googlePlacesService.findPlace(
    perplexityResponse.restaurantName,
    city,
  );
  final photos = await googlePlacesService.getPlacePhotos(placeDetails.placeId);

  // 6. Save and return
  return DailyStory(...);
}
```

**City rotation logic:**
```dart
String _pickCityForToday(UserProfile profile) {
  final allCities = [profile.homeCity, ...additionalCities];
  final dayOfYear = DateTime.now().difference(DateTime(2024)).inDays;
  return allCities[dayOfYear % allCities.length];
}
```

**Story type selection based on profile:**
```dart
DailyStoryType _pickStoryType(UserProfile profile) {
  // Weight story types based on user preferences
  if (profile.foodPhilosophy == FoodPhilosophy.storyFirst) {
    // Prefer legacy stories, chef spotlights
    return _weightedPick([
      (DailyStoryType.legacyStory, 0.35),
      (DailyStoryType.chefSpotlight, 0.25),
      (DailyStoryType.hiddenGem, 0.20),
      (DailyStoryType.cuisineDeepDive, 0.15),
      (DailyStoryType.neighborhoodGuide, 0.05),
    ]);
  } else if (profile.adventureLevel == AdventureLevel.localExplorer) {
    // Prefer hidden gems, neighborhood guides
    return _weightedPick([
      (DailyStoryType.hiddenGem, 0.40),
      (DailyStoryType.neighborhoodGuide, 0.25),
      ...
    ]);
  }
  // ... etc
}
```

### Phase 3: Perplexity Prompt Engineering

**Example prompt for "Legacy Story" type:**

```
You are a food journalist writing for a magazine like Eater or Bon Appetit.

Find a compelling restaurant story in {city}, {state} that fits this profile:
- Story type: Legacy/Founder story (long-running family restaurant, immigrant story, etc.)
- User prefers: Story-first content (they love the narrative behind the food)
- Cuisines to explore: {wantToTryCuisines}

Requirements:
1. Must be a REAL restaurant that currently exists
2. Focus on the human story - the founder, the family, the journey
3. Include specific details that make it feel authentic
4. The restaurant should be somewhat hidden/underrated (not a tourist trap)

Return JSON:
{
  "restaurantName": "exact name",
  "headline": "compelling 8-15 word headline in magazine style",
  "subheadline": "1-2 sentence teaser that hooks the reader",
  "bodyText": "2-3 paragraph story (optional, for full article view)",
  "cuisineType": "type of cuisine",
  "whyThisMatters": "why this story fits the user's preferences",
  "sourceUrl": "article or review URL if available"
}
```

### Phase 4: Flutter Client Updates

**Update `daily_screen.dart`:**

1. Convert `DailyScreen` to `StatefulWidget`
2. Add state for `DailyStory?` and loading state
3. Call `client.dailyStory.getDailyStory()` on init
4. Update `_LeadStory` to accept `DailyStory` data

```dart
class _DailyScreenState extends State<DailyScreen> {
  DailyStory? _dailyStory;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDailyStory();
  }

  Future<void> _loadDailyStory() async {
    try {
      final story = await client.dailyStory.getDailyStory();
      setState(() {
        _dailyStory = story;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  // ... build method uses _dailyStory
}
```

**Update `_LeadStory` widget:**

```dart
class _LeadStory extends StatelessWidget {
  final DailyStory? story;
  final VoidCallback onTap;
  final bool isLoading;

  // If story is null or loading, show skeleton/placeholder
  // Otherwise show personalized content
}
```

### Phase 5: Story Detail Screen (Optional Enhancement)

Create a full story view when user taps "Read the story":
- Full article with `bodyText`
- Restaurant details (address, hours, photos)
- "Get Directions" / "Save to List" buttons
- Source attribution

---

## Story Type Examples

### 1. Legacy Story
> **"The Laotian Grandmother Who's Been Making Larb in a Strip Mall for 22 Years"**
> At Sabaidee, the recipes haven't changed since 2002. Neither has the line out the door.

### 2. Hidden Gem
> **"This Garage-Turned-Taqueria Only Has 4 Tables. They're Always Full."**
> No sign, no website, just word of mouth and the best al pastor in Milwaukee.

### 3. Cuisine Deep Dive
> **"Why Milwaukee's Vietnamese Food Tastes Different Than Anywhere Else"**
> The Hmong influence you didn't know was shaping your pho.

### 4. Chef Spotlight
> **"He Trained at Noma. Now He's Cooking for His Neighborhood."**
> Chef Marcus left fine dining to open a soul food spot in his childhood zip code.

### 5. Neighborhood Guide
> **"The 3-Block Stretch That's Quietly Becoming the Best Food Street in the City"**
> A Somali cafe, a Oaxacan bakery, and a Filipino BBQ joint walk into Brady Street...

---

## Caching Strategy

1. **Daily cache per user**: One story per user per day
2. **Regeneration**: Midnight UTC or first request of new day
3. **Fallback**: If generation fails, show curated editorial content
4. **Pre-generation**: Consider batch generating stories overnight

---

## Database Migration

```sql
CREATE TABLE daily_stories (
  id SERIAL PRIMARY KEY,
  user_id TEXT NOT NULL,
  story_date TEXT NOT NULL,
  city TEXT NOT NULL,
  state TEXT,
  country TEXT,
  headline TEXT NOT NULL,
  subheadline TEXT NOT NULL,
  body_text TEXT,
  restaurant_name TEXT NOT NULL,
  restaurant_address TEXT,
  restaurant_place_id TEXT,
  hero_image_url TEXT NOT NULL,
  thumbnail_url TEXT,
  story_type TEXT NOT NULL,
  cuisine_type TEXT,
  source_url TEXT,
  created_at TIMESTAMP NOT NULL,
  UNIQUE(user_id, story_date)
);

CREATE INDEX daily_story_user_date_idx ON daily_stories(user_id, story_date);
```

---

## Implementation Order

1. **Create protocol files** (daily_story.spy.yaml, daily_story_type.spy.yaml)
2. **Run serverpod generate**
3. **Create DailyStoryEndpoint** with basic getDailyStory
4. **Add story generation logic** with Perplexity integration
5. **Update Flutter DailyScreen** to fetch and display
6. **Add loading states and fallbacks**
7. **Test with real user profiles**
8. **Add story detail screen** (optional)

---

## Estimated Complexity

| Component | Complexity | Notes |
|-----------|------------|-------|
| Protocol/DB | Low | Standard Serverpod patterns |
| Endpoint | Medium | City rotation, type selection logic |
| Perplexity prompts | Medium | Prompt engineering for quality |
| Google Places integration | Low | Reuse existing service |
| Flutter UI updates | Low | Minor changes to existing screen |
| Story detail screen | Medium | New screen, optional |

---

## Success Metrics

1. Stories feel personalized (not generic)
2. Featured restaurants are real and currently open
3. Photos load correctly via proxy
4. Stories rotate daily
5. Content matches user's stated preferences
