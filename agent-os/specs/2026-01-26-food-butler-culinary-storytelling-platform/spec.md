# Specification: Culinary Storytelling Platform (Hackathon Focus)

## Goal
Transform Food Butler from a restaurant finder into a documentary-style culinary storytelling platform that creates immersive food journeys with narrative depth, delivering ONE exceptional tour experience that feels like a mini "Parts Unknown" episode.

## User Stories
- As a food enthusiast, I want to search for a specific dish (like "tonkotsu ramen") and receive a curated tour of the best places for that dish with stories about each spot, so that I discover not just where to eat but why it matters.
- As a traveler, I want to experience my food tour as a narrative journey with an introduction, storytelling per stop, and a closing reflection, so that dining becomes an immersive cultural experience rather than a checklist.

## Specific Requirements

**Dish-First Search Experience**
- Make the `specificDish` field the hero input on the tour form with prominent placement and suggested examples
- Display example dishes as tappable chips: "tonkotsu ramen", "tacos al pastor", "Neapolitan pizza", "Nashville hot chicken"
- When a specific dish is entered, use it as the primary search criterion in `createCuratedTour()`
- Cuisine preferences become secondary filters when a dish is specified

**Narrative Tour Generation via Perplexity**
- Use existing `createCuratedTour()` method as the primary tour generation path
- Extend the prompt to emphasize dish-specific expertise when `specificDish` is provided
- Ensure all narrative fields are populated: title, introduction, vibe, per-stop stories, dish stories, insider tips, transitions, closing
- Parse and store the full `CuratedFoodTour` response before enriching with Google Places coordinates

**Extended TourResult Model**
- Add new fields to `TourResult`: `tourTitle`, `tourIntroduction`, `tourVibe`, `tourClosing`
- Keep existing `stopsJson` structure but ensure it includes: story, signatureDish, dishStory, insiderTip, transitionToNext, minutesToSpend
- Add `curatedTourJson` field to store the complete Perplexity response for later UI consumption
- Create migration to add new columns to the tour_results table

**Documentary-Style Tour Display**
- Create hero section showing tour title with vibe subtitle and opening narrative paragraph
- Design expandable story cards that show restaurant name, cuisine, and price by default
- Reveal full content on tap: restaurant story, signature dish with dish story, insider tip, and transition text
- Display closing narrative at tour end as a reflective wrap-up section
- Use typography hierarchy to distinguish narrative prose from logistical data

**Stop Card Design**
- Display stop number, restaurant name, neighborhood, and cuisine type in the collapsed state
- Show award badges (Michelin, James Beard) prominently when present
- Expandable section contains: full restaurant story, signature dish name, dish story, insider tip
- Include action buttons: "Navigate", "Reserve" (if available), "I've Arrived"
- Add estimated time to spend indicator

**Map Experience Enhancement**
- Use Google Maps Flutter for map display with custom-styled markers showing stop numbers
- Show route polyline between stops using existing Mapbox-generated polyline
- Tap marker to show info window with restaurant name, cuisine, and "View Details" link
- Add "Navigate to Next Stop" button that opens Google Maps app with directions intent
- Display route summary: total distance, estimated walking/driving time

**Tour Progress Tracking**
- Add "I've Arrived" button on each stop card to mark completion
- Auto-detect arrival when user location is within 50 meters of stop coordinates
- Visual progress indicator showing completed vs remaining stops
- Update map markers to show visited stops with checkmark overlay
- Store progress locally (SharedPreferences) to survive app restart

**Navigation Integration**
- "Start Tour" button in bottom bar opens directions to first stop in Google Maps app
- Each stop card has "Navigate Here" button that opens Google Maps with walking/driving directions
- Use `url_launcher` to construct Google Maps intent URLs with origin and destination
- Pass transport mode preference (walking vs driving) to navigation intent

## Visual Design

No visual mockups provided. Documentary-style UI should emphasize:
- Large, readable narrative text with proper line height (1.5-1.6)
- Collapsible cards with subtle expand indicators
- Award badges using existing `AwardBadge` widget patterns
- Map taking at least 60% of screen in Map tab
- Narrative flowing naturally in Stops tab with clear visual hierarchy

## Existing Code to Leverage

**`perplexity_service.dart` - CuratedFoodTour model and createCuratedTour()**
- Already defines `CuratedFoodTour` with title, introduction, stops, closing, vibe fields
- `CuratedStop` has story, signatureDish, dishStory, insiderTip, transitionToNext, minutesToSpend
- `createCuratedTour()` accepts cuisinePreferences, budgetLevel, awardWinningOnly, specialRequests
- JSON parsing and prompt construction already implemented

**`tour_generation_service.dart` - Tour orchestration**
- `_collectFromPerplexity()` currently only uses `discoverRestaurants()` for names
- Should be extended to call `createCuratedTour()` first, then enrich with Google Places
- Has existing patterns for Google Places enrichment via `searchByName()`
- Handles budget tier mapping and cuisine filtering

**`tour_results_screen.dart` - Current UI patterns**
- Has `_NarrativeCard` widget for displaying tour introduction
- `_StopCard` widget with stop number badge, action buttons, award badges
- Tab-based layout with Map and Stops tabs
- Uses `TourMapView` component for map display
- Bottom summary bar with "Start Tour" button

**`tour_form_screen.dart` - Form patterns**
- Already has `specificDish` field with text input
- `_SectionHeader` widget for consistent section styling
- `_CuisineSelector` with FilterChip wrap layout
- Existing integration with Serverpod client for tour generation

**`TourMapView` and map components**
- Uses `TourStopMarker` model for stop representation
- Existing polyline rendering and marker display
- `onRestaurantSelect` callback for marker taps

## Out of Scope
- Audio narration / Documentary Mode TTS (defer to Phase 3)
- Locals Network / Chef recommendations (defer to Phase 4)
- Culinary DNA / Palate profiling (defer to Phase 2)
- Quests and gamification (defer to Phase 5)
- User accounts and authentication (basic auth exists but not required for hackathon demo)
- Real-time wait times or availability
- OpenTable reservation integration
- Street View integration
- Heat maps or popularity visualization
- In-app turn-by-turn navigation (use external Google Maps app)
- Saving/bookmarking tours to user profile
- Social sharing of tours
