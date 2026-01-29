# Task Breakdown: Tour Generation Engine

## Overview
Total Tasks: 42
Estimated Total Complexity: Large (Backend-heavy feature with multiple API integrations)

This is the core algorithm for generating optimized 3-6 stop food tours. The engine combines Foursquare restaurant data, award matching (James Beard/Michelin), scoring algorithms, and Mapbox routing to create digestion-paced, geographically efficient itineraries.

## Task List

### Database Layer

#### Task Group 1: Core Data Models and Migrations
**Dependencies:** None
**Complexity:** Medium

- [x] 1.0 Complete core database models for tour generation
  - [x] 1.1 Write 6 focused tests for core model functionality
    - Test Restaurant model validation (coordinates, price tier enum)
    - Test Award model association with Restaurant
    - Test TourRequest model validation (stops range 3-6, transport mode enum)
    - Test TourResult model structure
    - Test CachedFoursquareResponse TTL behavior
    - Test CachedRoute cache key generation
  - [x] 1.2 Create Restaurant model with Serverpod ORM
    - Fields: fsqId (String, unique), name, address, latitude, longitude, priceTier (int 1-4), rating (double), cuisineTypes (List<String>), hours (JSON), dishData (JSON nullable), createdAt, updatedAt
    - Validations: latitude/longitude range, priceTier 1-4
    - Indexes: fsqId (unique), coordinates (spatial), priceTier
  - [x] 1.3 Create Award model for James Beard and Michelin data
    - Fields: restaurantFsqId, awardType (enum: jamesBeard, michelin), awardLevel (String: winner, nominee, semifinalist, oneStar, twoStar, threeStar, bibGourmand), year, createdAt
    - Association: belongs_to Restaurant via fsqId
    - Indexes: restaurantFsqId, awardType, year
  - [x] 1.4 Create TourRequest model for input parameters
    - Fields: startLatitude, startLongitude, startAddress (nullable), numStops (int 3-6), transportMode (enum: walking, driving), cuisinePreferences (List<String> nullable), awardOnly (bool), startTime (DateTime), endTime (DateTime nullable), budgetTier (enum: budget, moderate, upscale, luxury), createdAt
    - Validations: numStops 3-6, coordinates range, startTime not in past
  - [x] 1.5 Create TourResult model for generated tour output
    - Fields: requestId, stops (JSON array), confidenceScore (int 0-100), routePolyline (String), totalDistanceMeters (int), totalDurationSeconds (int), isPartialTour (bool), warningMessage (String nullable), createdAt
    - Association: belongs_to TourRequest
  - [x] 1.6 Create CachedFoursquareResponse model for API caching
    - Fields: cacheKey (String, unique), responseData (JSON), expiresAt (DateTime), createdAt
    - TTL: 24 hours default
    - Index: cacheKey (unique), expiresAt
  - [x] 1.7 Create CachedRoute model for Mapbox route caching
    - Fields: waypointsHash (String, unique), transportMode (enum), polyline (String), distanceMeters (int), durationSeconds (int), expiresAt (DateTime), createdAt
    - TTL: 7 days default
    - Index: waypointsHash (unique), expiresAt
  - [x] 1.8 Create database migrations for all models
    - Generate Serverpod migrations with proper ordering
    - Add foreign key constraints
    - Add spatial indexes for coordinate queries
    - Ensure reversible migrations
  - [x] 1.9 Ensure database layer tests pass
    - Run ONLY the 6 tests written in 1.1
    - Verify migrations run successfully
    - Do NOT run the entire test suite at this stage

**Acceptance Criteria:**
- The 6 tests written in 1.1 pass
- All models compile and validate correctly
- Migrations run successfully without errors
- Indexes are created for performance-critical columns
- Spatial queries work on coordinate fields

---

### External API Integration Layer

#### Task Group 2: Foursquare Places API Integration
**Dependencies:** Task Group 1
**Complexity:** Large

- [x] 2.0 Complete Foursquare API integration service
  - [x] 2.1 Write 6 focused tests for Foursquare service
    - Test restaurant search with location and radius
    - Test cuisine filter application
    - Test dish-level data parsing
    - Test response caching (cache hit/miss)
    - Test rate limit handling with exponential backoff
    - Test partial results on API error
  - [x] 2.2 Create FoursquareService class
    - Configuration: API key from environment, base URL, timeout settings
    - HTTP client setup with proper headers (Authorization, Accept)
    - Follow Serverpod service patterns
  - [x] 2.3 Implement searchRestaurants method
    - Parameters: latitude, longitude, radius (meters), cuisineTypes (optional), limit
    - Query Foursquare /places/search endpoint
    - Map response to Restaurant models
    - Parse price tier, rating, hours from response
  - [x] 2.4 Implement getRestaurantDetails method
    - Fetch dish-level data (menu items, categories)
    - Parse appetizers, mains, desserts for digestion classification
    - Store parsed dish data in Restaurant.dishData JSON field
  - [x] 2.5 Implement response caching layer
    - Generate cache key from query parameters
    - Check CachedFoursquareResponse before API call
    - Store successful responses with 24-hour TTL
    - Implement cache cleanup for expired entries
  - [x] 2.6 Implement rate limiting and retry logic
    - Track request count against Foursquare limits
    - Implement exponential backoff (1s, 2s, 4s, 8s, max 16s)
    - Return partial results with warning on persistent failures
    - Log rate limit events for monitoring
  - [x] 2.7 Implement error handling for API failures
    - Handle 401 (auth), 429 (rate limit), 5xx (server errors)
    - Return graceful degradation with cached data if available
    - Never throw unhandled exceptions to caller
  - [x] 2.8 Ensure Foursquare integration tests pass
    - Run ONLY the 6 tests written in 2.1
    - Verify mock API responses are handled correctly
    - Do NOT run the entire test suite at this stage

**Acceptance Criteria:**
- The 6 tests written in 2.1 pass
- Restaurant search returns properly mapped models
- Dish-level data is parsed correctly
- Caching reduces API calls on repeated queries
- Rate limits are respected with proper backoff
- Partial results returned on failures with warnings

---

#### Task Group 3: Award Data Integration
**Dependencies:** Task Group 1
**Complexity:** Medium

- [x] 3.0 Complete award data loading and matching
  - [x] 3.1 Write 4 focused tests for award matching
    - Test James Beard data loading from CSV/JSON
    - Test Michelin data loading from CSV/JSON
    - Test fuzzy name matching algorithm
    - Test award boost application in scoring
  - [x] 3.2 Create data migration scripts for award datasets
    - Download James Beard data from cjwinchester/james-beard GitHub
    - Download Michelin data from Kaggle
    - Parse CSV/JSON formats into Award model structure
    - Create seed script for initial data load
  - [x] 3.3 Create AwardMatchingService class
    - Load award data into memory cache on startup
    - Implement fuzzy name matching (Levenshtein distance or similar)
    - Match by name + city/location for disambiguation
    - Return match confidence score
  - [x] 3.4 Implement matchRestaurantToAwards method
    - Input: Restaurant model with name, address, city
    - Fuzzy match against James Beard dataset
    - Fuzzy match against Michelin dataset
    - Return list of Award records for matches above threshold
    - Handle ambiguous matches (multiple restaurants with similar names)
  - [x] 3.5 Create annual refresh migration pattern
    - Document process for updating award datasets
    - Create migration template for new year's data
    - Preserve historical award records
  - [x] 3.6 Ensure award matching tests pass
    - Run ONLY the 4 tests written in 3.1
    - Verify data loading works correctly
    - Do NOT run the entire test suite at this stage

**Acceptance Criteria:**
- The 4 tests written in 3.1 pass
- James Beard and Michelin data loads successfully
- Fuzzy matching identifies restaurants with high accuracy
- Award status is retrievable for any restaurant
- Annual refresh process is documented

---

#### Task Group 4: Mapbox Routing Integration
**Dependencies:** Task Group 1
**Complexity:** Medium

- [x] 4.0 Complete Mapbox Directions API integration
  - [x] 4.1 Write 5 focused tests for Mapbox service
    - Test route calculation for walking mode
    - Test route calculation for driving mode
    - Test polyline encoding/decoding
    - Test route caching (cache hit/miss)
    - Test multi-waypoint route optimization
  - [x] 4.2 Create MapboxService class
    - Configuration: Access token from environment, base URL
    - HTTP client setup with proper headers
    - Follow Serverpod service patterns
  - [x] 4.3 Implement calculateRoute method
    - Parameters: waypoints (List<LatLng>), transportMode
    - Query Mapbox Directions API with profile (walking/driving)
    - Parse route geometry (encoded polyline)
    - Extract per-leg distance and duration
    - Calculate total distance and duration
  - [x] 4.4 Implement route caching layer
    - Generate cache key from sorted waypoints hash + transport mode
    - Check CachedRoute before API call
    - Store successful routes with 7-day TTL
    - Handle waypoint order variations (same stops, different order)
  - [x] 4.5 Implement error handling
    - Handle 401, 429, 5xx errors appropriately
    - Return fallback straight-line distance estimation on failure
    - Log errors for monitoring
  - [x] 4.6 Ensure Mapbox integration tests pass
    - Run ONLY the 5 tests written in 4.1
    - Verify mock API responses are handled correctly
    - Do NOT run the entire test suite at this stage

**Acceptance Criteria:**
- The 5 tests written in 4.1 pass
- Routes calculate correctly for walking and driving
- Polylines are properly encoded for frontend consumption
- Per-leg and total distances/durations are accurate
- Caching reduces API calls for repeated routes

---

### Core Algorithm Layer

#### Task Group 5: Tour Scoring Algorithm
**Dependencies:** Task Groups 2, 3, 4
**Complexity:** Large

- [x] 5.0 Complete tour scoring algorithm implementation
  - [x] 5.1 Write 6 focused tests for scoring algorithm
    - Test digestion score calculation (light to heavy progression)
    - Test geographic efficiency score calculation
    - Test timing window score calculation
    - Test award boost multiplier application (1.2x)
    - Test overall confidence score aggregation
    - Test fallback to cuisine heuristics when dish data unavailable
  - [x] 5.2 Create TourScoringService class
    - Define scoring weights (equal by default)
    - Define award boost multiplier (1.2x)
    - Define dish weight classifications
  - [x] 5.3 Implement calculateDigestionScore method
    - Classify each restaurant by predominant dish weight
    - Categories: light (coffee, pastries, appetizers), medium (salads, sandwiches), heavy (mains, rich desserts)
    - Score based on progression from light to heavy
    - Penalize heavy-to-light transitions
    - Fall back to cuisine-type heuristics when dish data missing
  - [x] 5.4 Implement calculateGeographicScore method
    - Use Mapbox distance/duration between consecutive stops
    - Score based on total travel time efficiency
    - Penalize excessive backtracking
    - Consider transport mode in scoring thresholds
  - [x] 5.5 Implement calculateTimingScore method
    - Check restaurant hours against proposed visit times
    - Score based on optimal visit windows (not too early, not rushed)
    - Account for 20-45 minute digestion gaps between stops
    - Penalize visits outside operating hours
  - [x] 5.6 Implement applyAwardBoost method
    - Check restaurant for James Beard or Michelin awards
    - Apply 1.2x multiplier to qualifying restaurants
    - Stack boosts for multiple awards (cap at 1.5x)
  - [x] 5.7 Implement calculateConfidenceScore method
    - Aggregate digestion, geographic, and timing scores
    - Weight equally unless constraint cannot be satisfied
    - Scale to 0-100 integer output
    - Reduce confidence for partial tours
  - [x] 5.8 Ensure scoring algorithm tests pass
    - Run ONLY the 6 tests written in 5.1
    - Verify scoring produces expected results
    - Do NOT run the entire test suite at this stage

**Acceptance Criteria:**
- The 6 tests written in 5.1 pass
- Digestion scoring correctly orders light-to-heavy
- Geographic scoring optimizes for travel efficiency
- Timing scoring respects restaurant hours and pacing
- Award boost applies correctly (1.2x multiplier)
- Confidence score accurately reflects tour quality

---

#### Task Group 6: Tour Generation Engine
**Dependencies:** Task Groups 2, 3, 4, 5
**Complexity:** Large

- [x] 6.0 Complete tour generation engine implementation
  - [x] 6.1 Write 6 focused tests for tour generation
    - Test successful 4-stop tour generation
    - Test 3-stop minimum tour generation
    - Test 6-stop maximum tour generation
    - Test award-only filter application
    - Test partial tour generation with warning
    - Test cuisine preference filtering
  - [x] 6.2 Create TourGenerationService class
    - Inject FoursquareService, AwardMatchingService, MapboxService, TourScoringService
    - Define search radius defaults (walking: 2km, driving: 10km)
    - Define candidate pool multiplier (3x requested stops)
  - [x] 6.3 Implement generateTour main method
    - Validate TourRequest input parameters
    - Orchestrate service calls in optimal order
    - Return TourResult with all metadata
    - Handle errors gracefully at each step
  - [x] 6.4 Implement restaurant candidate collection
    - Search Foursquare with location and radius
    - Apply cuisine preference filters
    - Fetch dish-level data for top candidates
    - Match awards for all candidates
    - Filter by budget tier (price level)
    - Apply award-only filter if requested
  - [x] 6.5 Implement tour optimization algorithm
    - Generate candidate permutations for requested stop count
    - Score each permutation using TourScoringService
    - Select highest-scoring permutation
    - Optimize for performance (limit permutations for large candidate pools)
  - [x] 6.6 Implement alternative suggestions generation
    - For each selected stop, identify 1-2 similar alternatives
    - Alternatives should be nearby with similar cuisine/price
    - Exclude already-selected restaurants
  - [x] 6.7 Implement partial tour handling
    - When fewer candidates than requested stops
    - Set isPartialTour flag to true
    - Generate descriptive warning message
    - Suggest filter relaxation (expand radius, remove award-only, broaden cuisine)
    - Always return at least 1 stop if any match exists
  - [x] 6.8 Implement tour result assembly
    - Build ordered stop array with full restaurant details
    - Include award badges, recommended dishes, visit duration
    - Attach route polyline and leg summaries
    - Calculate total distance and duration
    - Set confidence score
  - [x] 6.9 Ensure tour generation tests pass
    - Run ONLY the 6 tests written in 6.1
    - Verify tours generate correctly for all configurations
    - Do NOT run the entire test suite at this stage

**Acceptance Criteria:**
- The 6 tests written in 6.1 pass
- Tours generate successfully for 3-6 stops
- Award-only and cuisine filters work correctly
- Partial tours return with appropriate warnings
- Alternatives are provided for each stop
- Tour results include all required metadata

---

### API Layer

#### Task Group 7: Tour Generation API Endpoint
**Dependencies:** Task Group 6
**Complexity:** Medium

- [x] 7.0 Complete tour generation API endpoint
  - [x] 7.1 Write 5 focused tests for API endpoint
    - Test successful POST /api/v1/tours/generate returns 200
    - Test validation error returns 400 with field-specific errors
    - Test invalid numStops (outside 3-6) returns 400
    - Test rate limiting headers are present in response
    - Test response structure matches TourResult schema
  - [x] 7.2 Create TourEndpoint class following Serverpod conventions
    - Define POST /api/v1/tours/generate endpoint
    - Accept TourRequest as request body
    - Return TourResult as response
    - Follow RESTful design principles
  - [x] 7.3 Implement input validation
    - Validate all TourRequest fields server-side
    - Check numStops is 3-6 inclusive
    - Validate coordinates are within valid ranges
    - Validate transportMode and budgetTier enums
    - Validate startTime is not in the past
    - Return 400 with field-specific error messages
  - [x] 7.4 Implement endpoint handler
    - Parse and validate request
    - Call TourGenerationService.generateTour
    - Format response with proper HTTP status
    - Include rate limiting headers
  - [x] 7.5 Implement rate limiting
    - Track requests per client (IP or API key)
    - Include X-RateLimit-Limit, X-RateLimit-Remaining, X-RateLimit-Reset headers
    - Return 429 when limit exceeded
  - [x] 7.6 Implement response formatting
    - Serialize TourResult to JSON
    - Include all stop details, route data, scores
    - Format timestamps as ISO 8601
    - Ensure consistent response structure
  - [x] 7.7 Ensure API endpoint tests pass
    - Run ONLY the 5 tests written in 7.1
    - Verify endpoint responds correctly
    - Do NOT run the entire test suite at this stage

**Acceptance Criteria:**
- The 5 tests written in 7.1 pass
- POST endpoint returns 200 for valid requests
- Validation errors return 400 with specific messages
- Rate limiting headers present in all responses
- Response time under 5 seconds for typical 4-stop tour
- Response structure matches documented schema

---

### Error Handling and Resilience

#### Task Group 8: Error Handling and Graceful Degradation
**Dependencies:** Task Groups 2, 4, 6, 7
**Complexity:** Small

- [x] 8.0 Complete error handling implementation
  - [x] 8.1 Write 4 focused tests for error handling
    - Test Foursquare API failure returns partial results
    - Test Mapbox API failure returns estimated distances
    - Test combined API failures return graceful error
    - Test error messages are user-friendly (no stack traces)
  - [x] 8.2 Implement centralized error handling
    - Create TourGenerationException class hierarchy
    - Define specific exception types (ApiException, ValidationException, CacheException)
    - Implement error response formatting
  - [x] 8.3 Implement graceful degradation patterns
    - Foursquare failure: return cached data or empty results with warning
    - Mapbox failure: estimate distances using straight-line calculation
    - Award matching failure: continue without award data
    - Never fail completely if any data is available
  - [x] 8.4 Implement logging and monitoring hooks
    - Log all API failures with context
    - Log performance metrics (response times)
    - Structure logs for future monitoring integration
  - [x] 8.5 Ensure error handling tests pass
    - Run ONLY the 4 tests written in 8.1
    - Verify graceful degradation works
    - Do NOT run the entire test suite at this stage

**Acceptance Criteria:**
- The 4 tests written in 8.1 pass
- API failures do not crash the service
- Partial results returned when possible
- Error messages are user-friendly
- All errors are logged appropriately

---

### Testing and Quality Assurance

#### Task Group 9: Test Review and Gap Analysis
**Dependencies:** Task Groups 1-8
**Complexity:** Medium

- [x] 9.0 Review existing tests and fill critical gaps only
  - [x] 9.1 Review tests from Task Groups 1-8
    - Review 6 tests from database models (Task 1.1)
    - Review 6 tests from Foursquare integration (Task 2.1)
    - Review 4 tests from award matching (Task 3.1)
    - Review 5 tests from Mapbox integration (Task 4.1)
    - Review 6 tests from scoring algorithm (Task 5.1)
    - Review 6 tests from tour generation (Task 6.1)
    - Review 5 tests from API endpoint (Task 7.1)
    - Review 4 tests from error handling (Task 8.1)
    - Total existing tests: approximately 42 tests
  - [x] 9.2 Analyze test coverage gaps for tour generation feature
    - Identify critical end-to-end workflows lacking coverage
    - Focus on integration points between services
    - Prioritize user-facing scenarios
    - Do NOT assess entire application coverage
  - [x] 9.3 Write up to 8 additional strategic tests
    - Integration test: full tour generation flow (request to response)
    - Integration test: Foursquare + Award matching combined
    - Integration test: scoring with real route data
    - Edge case: exactly 3 stops with award-only filter
    - Edge case: 6 stops with multiple cuisine preferences
    - Edge case: no restaurants match criteria (graceful failure)
    - Performance test: response time under 5 seconds
    - Cache test: repeated identical requests use cache
  - [x] 9.4 Run feature-specific tests only
    - Run all tests related to tour generation (Tasks 1-8 + 9.3)
    - Expected total: approximately 50 tests maximum
    - Verify all critical workflows pass
    - Do NOT run unrelated application tests

**Acceptance Criteria:**
- All 42+ tests from Task Groups 1-8 pass
- Additional 8 strategic tests pass
- Full end-to-end tour generation works correctly
- Response time meets 5-second target
- No critical gaps in test coverage for this feature

---

## Execution Order

Recommended implementation sequence:

```
Phase 1: Foundation
  1. Task Group 1: Core Data Models and Migrations

Phase 2: External Integrations (can run in parallel)
  2a. Task Group 2: Foursquare Places API Integration
  2b. Task Group 3: Award Data Integration
  2c. Task Group 4: Mapbox Routing Integration

Phase 3: Core Algorithm
  3. Task Group 5: Tour Scoring Algorithm
  4. Task Group 6: Tour Generation Engine

Phase 4: API and Polish
  5. Task Group 7: Tour Generation API Endpoint
  6. Task Group 8: Error Handling and Graceful Degradation

Phase 5: Quality Assurance
  7. Task Group 9: Test Review and Gap Analysis
```

## Complexity Summary

| Task Group | Complexity | Estimated Effort |
|------------|------------|------------------|
| 1. Database Models | Medium | 2-3 hours |
| 2. Foursquare Integration | Large | 4-5 hours |
| 3. Award Data Integration | Medium | 2-3 hours |
| 4. Mapbox Integration | Medium | 2-3 hours |
| 5. Scoring Algorithm | Large | 4-5 hours |
| 6. Tour Generation Engine | Large | 5-6 hours |
| 7. API Endpoint | Medium | 2-3 hours |
| 8. Error Handling | Small | 1-2 hours |
| 9. Test Review | Medium | 2-3 hours |

**Total Estimated Effort:** 24-33 hours

## Technical Notes

### Serverpod Conventions
- Models defined in `lib/src/protocol/` with `.spy.yaml` files
- Endpoints in `lib/src/endpoints/` extending `Endpoint` class
- Services in `lib/src/services/` as singleton or injectable classes
- Migrations generated via `serverpod generate` command

### Environment Variables Required
```
FOURSQUARE_API_KEY=...
MAPBOX_ACCESS_TOKEN=...
DATABASE_URL=postgresql://...
```

### Key Design Decisions
- Foursquare responses cached 24 hours to stay within API limits
- Routes cached 7 days since physical distances rarely change
- Award data refreshed annually via migration scripts
- Permutation optimization limits candidates to avoid exponential complexity
- Award boost capped at 1.5x to prevent over-weighting
