# Spec Requirements: Tour Generation Engine

## Initial Description

Tour Generation Engine for Food Tour Butler - the core algorithm that generates optimized 3-6 stop food tours based on user preferences, location, and constraints. This is a Phase 1 MVP feature for a Flutter Web + Serverpod application hosted on Globe.dev.

## Requirements Discussion

### First Round Questions

**Q1:** What input preferences should users be able to specify when requesting a tour?
**Answer:** Add "award-only restaurants" as an additional preference option. Users should be able to filter for only James Beard and Michelin award-winning establishments.

**Q2:** What transport modes should be supported?
**Answer:** Walking and driving are sufficient for MVP. No need for public transit or cycling modes initially.

**Q3:** How should the algorithm prioritize optimization factors (digestion timing, geographic efficiency, timing windows)?
**Answer:** No explicit priority ordering among the three factors. However, the algorithm SHOULD boost award-winning restaurants (James Beard and Michelin) in scoring, giving them preference when other factors are roughly equal.

**Q4:** How should digestion ordering be determined - by cuisine-type heuristics or more granular data?
**Answer:** Pull dish-level data from Foursquare for more granular digestion decisions. Don't rely solely on cuisine-type heuristics; use actual dish information (appetizers, mains, desserts, etc.) to optimize the progression.

**Q5:** What metadata should be included in the tour output?
**Answer:** Yes, include:
- Tour confidence score (indicating how well the tour meets all criteria)
- Alternative restaurant suggestions per stop (fallback options if primary choice is unavailable)

**Q6:** How should turn-by-turn directions be handled - backend pre-fetched or frontend on-demand?
**Answer:** User asked for a recommendation. See recommendation below.

**Q7:** How should edge cases be handled when not enough restaurants match criteria?
**Answer:** Return a partial tour with a warning when insufficient matches are found. Don't fail completely; provide what can be generated and clearly communicate the limitation.

**Q8:** What geographic scope should the engine support?
**Answer:** Worldwide coverage, relying on Foursquare's global restaurant database. No geographic restrictions.

### Recommendation: Directions Handling (Q6)

**Recommendation: Hybrid Approach - Backend Route Overview + Frontend On-Demand Details**

For the best UX, I recommend:

1. **Backend provides**: Route polyline coordinates (for map visualization), total distance, total duration, and simplified waypoint-to-waypoint summaries between each stop.

2. **Frontend fetches on-demand**: Full turn-by-turn directions only when user taps "Navigate" or "Get Directions" for a specific leg.

**Rationale:**
- **Faster tour generation**: Fetching full turn-by-turn for all legs upfront adds significant latency (Mapbox Directions API calls for each segment)
- **Lower API costs**: Users may not need turn-by-turn for every leg; on-demand saves Mapbox API quota
- **Better UX**: Users see the route visualization immediately; detailed directions appear when they actually need them
- **Offline consideration**: Backend-provided polylines can be cached for offline map display; turn-by-turn can be fetched when connectivity is available
- **Flexibility**: Users can open directions in their preferred navigation app (Google Maps, Apple Maps, Waze) via deep link rather than in-app turn-by-turn

This aligns with how apps like Yelp and TripAdvisor handle multi-stop itineraries.

### Existing Code to Reference

No similar existing features identified for reference. This is a new project without existing codebase.

### Follow-up Questions

No additional follow-up questions needed. The user's answers were comprehensive and clear.

## Visual Assets

### Files Provided:
No visual assets provided.

### Visual Insights:
N/A - No visuals to analyze.

## Requirements Summary

### Functional Requirements

**Tour Input Parameters:**
- Starting location (user's current location or specified address)
- Number of stops (3-6, configurable)
- Transport mode (walking or driving)
- Cuisine preferences (optional filters)
- Award-only filter (James Beard / Michelin only option)
- Time constraints (tour start time, end time preferences)
- Budget tier preferences

**Tour Generation Algorithm:**
- Query Foursquare Places API for restaurants matching criteria
- Pull dish-level data from Foursquare for digestion optimization
- Apply scoring algorithm that boosts award-winning restaurants
- Optimize for three balanced factors:
  - Digestion progression (light to heavy, using dish-level data)
  - Geographic efficiency (minimize travel time/distance between stops)
  - Timing windows (respect restaurant hours, optimal visit times)
- Generate route polyline via Mapbox Directions API
- Calculate per-leg distance and duration summaries

**Tour Output Structure:**
- Ordered list of 3-6 restaurant stops with full details
- Tour confidence score (0-100 or similar scale)
- Alternative restaurant suggestions per stop (1-2 alternatives each)
- Route visualization data (polyline coordinates)
- Per-leg summaries (distance, duration, transport mode)
- Total tour duration and distance
- Partial tour flag and warning message when applicable

**Edge Case Handling:**
- Partial tour generation when insufficient matches
- Clear warning messages explaining limitations
- Graceful degradation (fewer stops rather than failure)

### Reusability Opportunities

No existing code to reuse. However, this engine should be designed as a modular service that can be reused by:
- Multi-day trip planning (Phase 2)
- Local Explorer mode (Phase 3)
- Quick Pick mode (Phase 4)

### Scope Boundaries

**In Scope:**
- Core tour generation algorithm with scoring
- Foursquare Places API integration for restaurant data
- Foursquare dish-level data retrieval
- Award data matching (James Beard + Michelin static datasets)
- Mapbox Directions API integration for routing
- Walking and driving transport modes
- Tour confidence scoring
- Alternative restaurant suggestions
- Partial tour handling with warnings
- Worldwide geographic coverage

**Out of Scope:**
- Public transit or cycling modes
- Real-time availability checking (OpenTable integration is separate Phase 2 feature)
- Reservation booking
- LLM-generated tour narratives (separate roadmap item)
- User authentication and saved tours (Phase 2)
- Turn-by-turn navigation UI (frontend handles on-demand)

### Technical Considerations

**Integration Points:**
- Foursquare Places API: Restaurant search, details, dish-level data
- Mapbox Directions API: Route calculation, polylines, duration/distance
- James Beard static dataset (GitHub: cjwinchester/james-beard)
- Michelin static dataset (Kaggle)
- PostgreSQL for caching API responses

**Tech Stack Constraints:**
- Backend: Serverpod 2.x (Dart)
- Database: PostgreSQL with spatial support for geo queries
- Hosting: Globe.dev
- Must work within Foursquare's $200/month free credits (~2,500 tour generations)
- Must work within Mapbox Directions 100K requests/month free tier

**Performance Requirements:**
- Tour generation should complete within 3-5 seconds
- Backend provides route overview; frontend fetches turn-by-turn on-demand
- Cache Foursquare responses to reduce API calls

**API Design:**
- RESTful endpoint following project API standards
- Accept tour parameters as request body
- Return structured tour response with all metadata
- Include rate limiting headers per project standards
