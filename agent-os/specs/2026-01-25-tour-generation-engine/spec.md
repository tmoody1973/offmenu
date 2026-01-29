# Specification: Tour Generation Engine

## Goal

Build the core algorithm that generates optimized 3-6 stop food tours based on user preferences, location, and constraints, combining Foursquare restaurant data with Mapbox routing to create digestion-paced, geographically efficient itineraries with award-winning restaurant prioritization.

## User Stories

- As a food enthusiast, I want to generate a personalized food tour based on my cuisine preferences, budget, and time constraints so that I can experience a curated progressive dining journey.
- As a traveler, I want the tour to optimize for both walking efficiency and digestion timing so that I can comfortably enjoy multiple stops without rushing or feeling overly full.

## Specific Requirements

**Tour Input Parameters Endpoint**
- Accept starting location as latitude/longitude coordinates or geocodable address string
- Accept number of stops (integer, 3-6 inclusive, default 4)
- Accept transport mode enum: "walking" or "driving"
- Accept optional cuisine preferences as array of cuisine type strings
- Accept optional award-only boolean filter for James Beard and Michelin establishments
- Accept time constraints: tour start time (ISO 8601), optional end time preference
- Accept budget tier enum: "budget", "moderate", "upscale", "luxury"
- Validate all inputs server-side following project validation standards

**Foursquare Restaurant Search Integration**
- Query Foursquare Places API with location, radius, and cuisine filters
- Fetch dish-level data (appetizers, mains, desserts) for digestion optimization
- Parse restaurant hours, price tier, and rating from API response
- Cache Foursquare responses in PostgreSQL with TTL to reduce API calls
- Handle rate limits with exponential backoff retry strategy
- Return partial results with warning when API errors occur

**Award Data Matching**
- Load James Beard dataset (from cjwinchester/james-beard GitHub repo) into PostgreSQL
- Load Michelin dataset (from Kaggle) into PostgreSQL
- Match restaurants by name and location fuzzy matching
- Store award status (winner, nominee, semifinalist, stars, Bib Gourmand) per restaurant
- Refresh award datasets annually with migration scripts

**Tour Scoring Algorithm**
- Calculate digestion score based on dish-level progression (light to heavy ordering)
- Calculate geographic efficiency score using Mapbox distance/duration between stops
- Calculate timing window score based on restaurant hours and optimal visit times
- Apply award boost multiplier (1.2x suggested) for James Beard and Michelin restaurants
- Generate overall tour confidence score (0-100 scale) representing optimization quality
- Weight all three factors equally unless one constraint cannot be satisfied

**Digestion Optimization Logic**
- Classify restaurants by predominant dish weight using Foursquare dish data
- Order stops from lightest (coffee, pastries, appetizers) to heaviest (mains, rich desserts)
- Space stops with 20-45 minute gaps for comfortable digestion pacing
- Fall back to cuisine-type heuristics when dish-level data unavailable

**Mapbox Routing Integration**
- Request Mapbox Directions API for walking or driving mode per tour request
- Retrieve route polyline coordinates for map visualization on frontend
- Calculate per-leg distance (meters) and duration (seconds)
- Calculate total tour distance and duration
- Cache route calculations for identical waypoint combinations
- Do NOT fetch turn-by-turn directions; frontend fetches on-demand

**Tour Output Structure**
- Return ordered array of restaurant stops with: name, address, coordinates, price tier, rating, award badges, recommended dishes, visit duration estimate
- Return tour confidence score (0-100)
- Return 1-2 alternative restaurant suggestions per stop
- Return route polyline as encoded string for map rendering
- Return per-leg summaries: distance, duration, transport mode
- Return total tour duration and distance
- Return partial tour flag (boolean) and warning message when applicable

**Partial Tour Handling**
- When fewer restaurants match criteria than requested stops, return available matches
- Set partial tour flag to true and include descriptive warning message
- Suggest relaxing filters (remove award-only, expand cuisine types, increase radius)
- Never fail completely; always return at least 1 stop if any restaurant matches

**API Endpoint Design**
- Implement as RESTful POST endpoint: `/api/v1/tours/generate`
- Return HTTP 200 for successful generation, 400 for validation errors
- Include rate limiting headers in response per project API standards
- Target response time under 5 seconds for typical 4-stop tour

## Visual Design

No visual assets provided. Frontend implementation is out of scope for this specification.

## Existing Code to Leverage

**No existing codebase**
- This is a greenfield project; no existing code to reference
- Design the tour generation service as a modular, reusable component
- Structure for future extension by Multi-Day Trip Planning, Local Explorer Mode, and Quick Pick Mode
- Follow Serverpod 2.x conventions for endpoint and model definitions
- Use Serverpod ORM for PostgreSQL data access

## Out of Scope

- Public transit and cycling transport modes (MVP supports walking and driving only)
- Real-time availability checking via OpenTable integration (Phase 2 feature)
- Reservation booking functionality
- LLM-generated tour narratives (separate roadmap item)
- User authentication and saved tours (Phase 2)
- Turn-by-turn navigation UI (frontend handles on-demand via Mapbox)
- Frontend implementation and UI components
- Push notifications for tour reminders
- Social sharing of generated tours
- Multi-day trip planning (Phase 2)
