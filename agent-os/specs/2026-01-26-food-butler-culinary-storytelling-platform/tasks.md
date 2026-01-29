# Task Breakdown: Culinary Storytelling Platform

## Overview

**Total Tasks:** 24 main tasks across 6 task groups
**Estimated Total Time:** 18-26 hours
**Hackathon Priority:** Ordered for maximum demo impact - get storytelling working FIRST

## Execution Order (Dependency-Based)

1. Backend: Model Extension & Perplexity Integration (Tasks 1-4)
2. Backend: Tour Generation Flow (Tasks 5-7)
3. Flutter UI: Tour Form Enhancement (Tasks 8-10)
4. Flutter UI: Documentary-Style Results (Tasks 11-16)
5. Map & Navigation Integration (Tasks 17-21)
6. Polish & Demo Prep (Tasks 22-24)

---

## Task Group 1: Backend Model Extension

**Dependencies:** None
**Why First:** All other tasks depend on the extended data model

### Task 1.1: Extend TourResult Model `S`

- [ ] **Add narrative fields to tour_result.spy.yaml**
  - Add `tourTitle: String?` - Creative tour title from Perplexity
  - Add `tourIntroduction: String?` - Opening narrative paragraph
  - Add `tourVibe: String?` - Overall mood/feeling description
  - Add `tourClosing: String?` - Closing narrative wrap-up
  - Add `curatedTourJson: String?` - Full CuratedFoodTour response for UI consumption
  - **Files:** `/food_butler_server/lib/src/tours/tour_result.spy.yaml`
  - **Acceptance:** Fields added to protocol definition

### Task 1.2: Create Database Migration `XS`

- [ ] **Generate and run migration for new columns**
  - Run `serverpod generate` to create migration
  - Verify migration file creates nullable columns
  - Test migration runs successfully
  - **Files:** `/food_butler_server/migrations/` (new migration folder)
  - **Acceptance:** Migration runs without error, columns added to tour_results table

### Task 1.3: Regenerate Protocol Files `XS`

- [ ] **Run Serverpod code generation**
  - Run `serverpod generate` in server directory
  - Run `dart pub get` in client directory
  - Run `flutter pub get` in flutter directory
  - Verify TourResult class has new fields in generated code
  - **Files:**
    - `/food_butler_server/lib/src/generated/tours/tour_result.dart`
    - `/food_butler_client/lib/src/protocol/`
  - **Acceptance:** Generated code compiles, new fields accessible

**Task Group 1 Acceptance Criteria:**
- TourResult model has all 5 new narrative fields
- Migration runs successfully
- Generated protocol code compiles in server, client, and flutter packages

---

## Task Group 2: Perplexity Integration Enhancement

**Dependencies:** Task Group 1
**Why Second:** Enables the core storytelling capability

### Task 2.1: Update createCuratedTour Prompt for Dish Focus `S`

- [ ] **Enhance prompt when specificDish is provided**
  - Modify `_buildCuratorPrompt()` to accept `specificDish` parameter
  - When dish provided, lead with: "Create a tour featuring the BEST {dish} in {location}"
  - Emphasize dish expertise: "Focus on places where this dish is exceptional"
  - Request dish-specific stories in each stop
  - **Files:** `/food_butler_server/lib/src/services/perplexity_service.dart`
  - **Acceptance:** Prompt changes based on specificDish presence

### Task 2.2: Wire createCuratedTour into Tour Generation `M`

- [ ] **Replace discoverRestaurants with createCuratedTour as primary path**
  - Create new method `_collectFromCuratedTour()` in TourGenerationService
  - Call `perplexityService.createCuratedTour()` with request parameters
  - Map CuratedStop fields to candidate restaurants
  - Preserve CuratedFoodTour object for later storage
  - Fall back to `discoverRestaurants()` if curated tour fails
  - **Files:** `/food_butler_server/lib/src/services/tour_generation_service.dart`
  - **Acceptance:** Tour generation uses createCuratedTour when Perplexity available

### Task 2.3: Enrich CuratedStops with Google Places Data `S`

- [ ] **Add coordinates and details to Perplexity recommendations**
  - For each CuratedStop, call `googlePlacesService.searchByName()`
  - Populate placeId, latitude, longitude, address, rating fields
  - Preserve all narrative fields (story, dishStory, insiderTip, etc.)
  - Log warnings for stops that cannot be found
  - **Files:** `/food_butler_server/lib/src/services/tour_generation_service.dart`
  - **Acceptance:** CuratedStops have Google Places coordinates while retaining Perplexity narratives

### Task 2.4: Store CuratedTour Data in TourResult `S`

- [ ] **Populate new TourResult fields from CuratedFoodTour**
  - Set `tourTitle` from CuratedFoodTour.title
  - Set `tourIntroduction` from CuratedFoodTour.introduction
  - Set `tourVibe` from CuratedFoodTour.vibe
  - Set `tourClosing` from CuratedFoodTour.closing
  - Serialize full CuratedFoodTour to `curatedTourJson`
  - Update stopsJson to include story, dishStory, insiderTip, transitionToNext, minutesToSpend
  - **Files:** `/food_butler_server/lib/src/services/tour_generation_service.dart`
  - **Acceptance:** TourResult returned from generate() contains all narrative data

**Task Group 2 Acceptance Criteria:**
- Perplexity prompt emphasizes dish when specificDish provided
- Tour generation uses createCuratedTour() for rich storytelling
- Stops have both Google Places coordinates AND Perplexity narratives
- TourResult contains tourTitle, tourIntroduction, tourVibe, tourClosing

---

## Task Group 3: Tour Form UI Enhancement

**Dependencies:** Task Group 2
**Why Third:** Improves the input experience for the demo

### Task 3.1: Elevate Dish Search to Hero Position `S`

- [ ] **Redesign form layout with dish search as primary input**
  - Move "Search by Dish" section to top of form, after location
  - Increase text field size and prominence
  - Add hero icon (chef hat or dish icon)
  - Update section header to "What are you craving?"
  - Keep cuisine preferences as secondary section below
  - **Files:** `/food_butler_flutter/lib/screens/tour_form_screen.dart`
  - **Acceptance:** Dish search is visually prominent at top of form

### Task 3.2: Add Example Dish Chips `S`

- [ ] **Create tappable dish suggestion chips**
  - Add constant list: `['tonkotsu ramen', 'tacos al pastor', 'Neapolitan pizza', 'Nashville hot chicken', 'pho', 'birria']`
  - Create Wrap of ActionChip widgets below dish text field
  - On chip tap, populate text field and set `_specificDish`
  - Style chips with food-themed colors
  - **Files:** `/food_butler_flutter/lib/screens/tour_form_screen.dart`
  - **Acceptance:** Tapping chip fills in dish field, chips are visually appealing

### Task 3.3: Improve Form Visual Hierarchy `XS`

- [ ] **Polish form section styling**
  - Add subtle dividers between sections
  - Increase spacing between hero dish section and other sections
  - Add subtle background color to dish section to make it stand out
  - Ensure consistent padding and alignment
  - **Files:** `/food_butler_flutter/lib/screens/tour_form_screen.dart`
  - **Acceptance:** Form has clear visual hierarchy with dish search as focal point

**Task Group 3 Acceptance Criteria:**
- Dish search is the most prominent input after location
- Example dish chips are visible and functional
- Form has improved visual hierarchy

---

## Task Group 4: Documentary-Style Tour Results UI

**Dependencies:** Task Groups 2, 3
**Why Fourth:** The main demo showcase - makes storytelling visible

### Task 4.1: Create Tour Hero Section Widget `S`

- [ ] **Build documentary-style header with tour title and intro**
  - Create `_TourHeroSection` widget
  - Display tourTitle as large, bold headline
  - Show tourVibe as styled subtitle
  - Display tourIntroduction as prose paragraph with 1.5 line height
  - Add subtle gradient or background treatment
  - Animate fade-in on load
  - **Files:** `/food_butler_flutter/lib/screens/tour_results_screen.dart`
  - **Acceptance:** Hero section displays title, vibe, and intro with documentary feel

### Task 4.2: Parse Extended Stop Data `XS`

- [ ] **Update _parseStops to extract narrative fields**
  - Add story, signatureDish, dishStory, insiderTip, transitionToNext, minutesToSpend to TourStopMarker
  - Update TourStopMarker model if needed
  - Handle null/missing fields gracefully
  - **Files:**
    - `/food_butler_flutter/lib/screens/tour_results_screen.dart`
    - `/food_butler_flutter/lib/map/models/tour_stop_marker.dart`
  - **Acceptance:** TourStopMarker contains all narrative fields from stopsJson

### Task 4.3: Redesign StopCard as Expandable Story Card `M`

- [ ] **Transform _StopCard into expandable documentary-style card**
  - Collapsed state: stop number, restaurant name, neighborhood, cuisine, price
  - Add expand/collapse animation with rotation indicator
  - Expanded state reveals:
    - Restaurant story (full paragraph)
    - Signature dish name with dish story
    - Insider tip with special styling (icon + italic)
    - Time to spend indicator
  - Award badges remain visible in collapsed state
  - **Files:** `/food_butler_flutter/lib/screens/tour_results_screen.dart`
  - **Acceptance:** Cards expand/collapse smoothly, narrative content displays well

### Task 4.4: Add Transition Text Between Stops `S`

- [ ] **Display narrative transitions between stop cards**
  - Create `_TransitionText` widget for transitionToNext content
  - Style as connecting prose with subtle visual treatment
  - Add walking/driving icon based on transport mode
  - Position between stop cards in the list
  - Handle null transitions gracefully (skip for last stop)
  - **Files:** `/food_butler_flutter/lib/screens/tour_results_screen.dart`
  - **Acceptance:** Transitions appear between stops with narrative flow

### Task 4.5: Create Tour Closing Section `S`

- [ ] **Add closing narrative at end of tour**
  - Create `_TourClosingSection` widget
  - Display tourClosing as reflective wrap-up paragraph
  - Style differently from intro (subtle background, quote styling)
  - Add "Your journey awaits" or similar call-to-action
  - Position after last stop card
  - **Files:** `/food_butler_flutter/lib/screens/tour_results_screen.dart`
  - **Acceptance:** Tour ends with meaningful closing narrative

### Task 4.6: Replace Narrative Loading with Tour Data `XS`

- [ ] **Use TourResult narrative fields instead of separate API call**
  - Remove `_loadNarrative()` API call to narrative.generate()
  - Extract tourIntroduction directly from widget.tourResult
  - Update `_NarrativeCard` to use TourResult data
  - Remove isLoadingNarrative state
  - **Files:** `/food_butler_flutter/lib/screens/tour_results_screen.dart`
  - **Acceptance:** Narrative displays immediately from TourResult, no loading spinner

**Task Group 4 Acceptance Criteria:**
- Tour results open with dramatic hero section (title, vibe, intro)
- Stop cards expand to reveal stories, dish stories, insider tips
- Transitions connect the stops narratively
- Tour ends with closing reflection
- No separate narrative loading required

---

## Task Group 5: Map & Navigation Enhancement

**Dependencies:** Task Group 4
**Why Fifth:** Enhances the interactive tour experience

### Task 5.1: Add Navigate Button to Stop Cards `S`

- [ ] **Implement "Navigate Here" functionality**
  - Add "Navigate" button to stop card action row
  - Use url_launcher to open Google Maps with directions
  - Construct URL: `https://www.google.com/maps/dir/?api=1&destination={lat},{lng}&travelmode={mode}`
  - Pass walking or driving based on tour transport mode
  - **Files:** `/food_butler_flutter/lib/screens/tour_results_screen.dart`
  - **Acceptance:** Tapping Navigate opens Google Maps with directions to stop

### Task 5.2: Implement Start Tour Navigation `S`

- [ ] **Wire up "Start Tour" button in bottom bar**
  - Get first stop coordinates from tour data
  - Open Google Maps with directions from current location to first stop
  - Pass transport mode preference
  - **Files:** `/food_butler_flutter/lib/screens/tour_results_screen.dart`
  - **Acceptance:** "Start Tour" opens navigation to first stop

### Task 5.3: Add "I've Arrived" Progress Tracking `M`

- [ ] **Implement stop completion tracking**
  - Add local state for completed stop indices
  - Add "I've Arrived" button to each stop card
  - On tap, mark stop as completed and update UI
  - Store progress in SharedPreferences for persistence
  - Load saved progress on screen init
  - **Files:** `/food_butler_flutter/lib/screens/tour_results_screen.dart`
  - **Acceptance:** Users can mark stops complete, progress persists across sessions

### Task 5.4: Visual Progress Indicator `S`

- [ ] **Show tour completion progress**
  - Add progress bar or step indicator showing completed/total stops
  - Update stop card styling for completed stops (checkmark, muted colors)
  - Update map markers to show visited stops differently
  - **Files:**
    - `/food_butler_flutter/lib/screens/tour_results_screen.dart`
    - `/food_butler_flutter/lib/map/widgets/tour_map_view.dart`
  - **Acceptance:** Visual indication of tour progress in both list and map views

### Task 5.5: Enhanced Map Info Windows `S`

- [ ] **Improve marker popup content**
  - Show restaurant name, cuisine type, and price in info window
  - Add "View Details" link that expands corresponding stop card
  - Add small award badge indicators if present
  - **Files:** `/food_butler_flutter/lib/map/widgets/tour_map_view.dart`
  - **Acceptance:** Map info windows show richer preview of stop information

**Task Group 5 Acceptance Criteria:**
- Navigate buttons work on all stop cards
- Start Tour navigates to first stop
- Progress tracking works and persists
- Visual progress shown in list and map
- Map popups show useful stop previews

---

## Task Group 6: Polish & Demo Preparation

**Dependencies:** All previous groups
**Why Last:** Final touches for hackathon presentation

### Task 6.1: Add Loading State with Storytelling Message `XS`

- [ ] **Improve tour generation loading experience**
  - Replace generic "Generating..." with rotating messages:
    - "Researching the best spots..."
    - "Gathering local stories..."
    - "Crafting your culinary journey..."
  - Add subtle animation during generation
  - **Files:** `/food_butler_flutter/lib/screens/tour_form_screen.dart`
  - **Acceptance:** Loading state feels more intentional and storytelling-focused

### Task 6.2: Error Handling & Fallback UI `S`

- [ ] **Handle cases where narrative data is missing**
  - Graceful fallback if tourTitle is null (use "Your Food Tour")
  - Fallback if tourIntroduction is null (show stop list without hero)
  - Handle missing stop narratives (show basic info without expansion)
  - Ensure app doesn't crash on malformed data
  - **Files:** `/food_butler_flutter/lib/screens/tour_results_screen.dart`
  - **Acceptance:** App handles missing data gracefully without crashing

### Task 6.3: Demo-Ready Test Data `S`

- [ ] **Create reliable demo scenario**
  - Identify location + dish combo that reliably generates good stories
  - Test "tonkotsu ramen" + San Francisco as baseline
  - Document 2-3 fallback demo scenarios
  - Verify Perplexity responses are consistently high quality
  - **Files:** Documentation only
  - **Acceptance:** Have reliable demo script with expected outputs

**Task Group 6 Acceptance Criteria:**
- Loading experience matches storytelling theme
- App handles edge cases gracefully
- Demo scenarios tested and documented

---

## Quick Reference: File Locations

### Server Files
- Protocol: `/food_butler_server/lib/src/tours/tour_result.spy.yaml`
- Perplexity: `/food_butler_server/lib/src/services/perplexity_service.dart`
- Tour Gen: `/food_butler_server/lib/src/services/tour_generation_service.dart`
- Endpoint: `/food_butler_server/lib/src/tours/tour_endpoint.dart`

### Flutter Files
- Form: `/food_butler_flutter/lib/screens/tour_form_screen.dart`
- Results: `/food_butler_flutter/lib/screens/tour_results_screen.dart`
- Map View: `/food_butler_flutter/lib/map/widgets/tour_map_view.dart`
- Stop Marker Model: `/food_butler_flutter/lib/map/models/tour_stop_marker.dart`

### Generated Files (DO NOT EDIT)
- Server Protocol: `/food_butler_server/lib/src/generated/`
- Client Protocol: `/food_butler_client/lib/src/protocol/`

---

## Hackathon Demo Impact Priority

If time is limited, prioritize in this order:

1. **Critical (Must Have for Demo):**
   - Tasks 1.1-1.3 (Model extension)
   - Tasks 2.2-2.4 (Perplexity integration)
   - Tasks 4.1, 4.3, 4.5 (Hero, expandable cards, closing)

2. **High Impact (Makes Demo Shine):**
   - Tasks 3.1-3.2 (Dish hero + chips)
   - Tasks 4.4 (Transitions)
   - Task 5.1 (Navigate button)

3. **Nice to Have (If Time Permits):**
   - Tasks 5.3-5.4 (Progress tracking)
   - Tasks 6.1-6.3 (Polish)

**Minimum Viable Demo:** Complete Groups 1, 2, and Tasks 4.1, 4.3, 4.5
**Full Demo Experience:** Complete all 6 groups
