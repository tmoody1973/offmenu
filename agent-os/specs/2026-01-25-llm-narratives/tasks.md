# Task Breakdown: LLM Tour Narratives

## Overview
Total Tasks: 32
Estimated Total Effort: Small-Medium (2-4 days)

This feature implements AI-generated tour narratives using Groq (Llama 3.3 70B) with Anthony Bourdain-inspired storytelling. The implementation covers Groq API integration, prompt templates, narrative generation service, PostgreSQL caching, and error handling with fallbacks.

## Task List

### Database Layer

#### Task Group 1: Narrative Cache Model and Migration
**Dependencies:** None
**Complexity:** S (Small)

- [x] 1.0 Complete database layer for narrative caching
  - [x] 1.1 Write 3-4 focused tests for NarrativeCache model
    - Test cache key composition (tour_id + user_id + narrative_type + stop_index)
    - Test TTL expiration logic (30-day TTL)
    - Test cache invalidation on regenerate
  - [x] 1.2 Create NarrativeCache model with Serverpod ORM
    - Fields: id, tour_id, user_id (nullable for anonymous), narrative_type (enum: intro/description/transition), stop_index (nullable), content (text), generated_at (datetime), expires_at (datetime), cache_hit_count (int)
    - Validations: tour_id required, narrative_type required, content required
  - [x] 1.3 Create migration for narrative_cache table
    - Add composite index on: (tour_id, user_id, narrative_type, stop_index) for cache lookups
    - Add index on expires_at for TTL cleanup queries
    - Include created_at and updated_at timestamps
  - [x] 1.4 Create NarrativeType enum
    - Values: intro, description, transition
    - Use Serverpod's enum serialization pattern
  - [x] 1.5 Ensure database layer tests pass
    - Run ONLY the 3-4 tests written in 1.1
    - Verify migration runs successfully

**Acceptance Criteria:**
- The 3-4 tests from 1.1 pass
- NarrativeCache model validates required fields
- Migration creates table with proper indexes
- Cache key composition works correctly

---

### External API Integration

#### Task Group 2: Groq API Client
**Dependencies:** None (can run in parallel with Task Group 1)
**Complexity:** M (Medium)

- [x] 2.0 Complete Groq API client implementation
  - [x] 2.1 Write 4-5 focused tests for Groq client
    - Test successful API call with mocked response
    - Test timeout handling (10 second timeout)
    - Test retry logic (3 attempts with exponential backoff: 1s, 2s, 4s)
    - Test error response handling
  - [x] 2.2 Create GroqClient service class
    - Configure base URL and API key from environment (GROQ_API_KEY)
    - Set model to "llama-3.3-70b-versatile"
    - Implement 10-second request timeout
    - Include tour_id and narrative_type in request metadata for tracing
  - [x] 2.3 Implement chat completion method
    - Accept system prompt and user prompt parameters
    - Set temperature between 0.7-0.8 for creative but coherent output
    - Parse and return generated text content
    - Handle JSON response structure from Groq API
  - [x] 2.4 Implement retry logic with exponential backoff
    - 3 retry attempts maximum
    - Delays: 1 second, 2 seconds, 4 seconds
    - Only retry on transient errors (timeout, 5xx, rate limit)
    - Do not retry on 4xx client errors
  - [x] 2.5 Add rate limit awareness
    - Track request count for daily limit monitoring (14,400/day free tier)
    - Log warnings when approaching 80% of daily limit
  - [x] 2.6 Ensure Groq client tests pass
    - Run ONLY the 4-5 tests written in 2.1
    - Verify all mocked scenarios work correctly

**Acceptance Criteria:**
- The 4-5 tests from 2.1 pass
- Groq API calls complete successfully with valid responses
- Timeout and retry logic functions correctly
- Request metadata included for tracing

---

### Prompt Engineering

#### Task Group 3: Prompt Templates
**Dependencies:** None (can run in parallel with Task Groups 1 and 2)
**Complexity:** M (Medium)

- [x] 3.0 Complete prompt template system
  - [x] 3.1 Write 3-4 focused tests for prompt generation
    - Test tour intro prompt includes neighborhood and cuisine diversity
    - Test restaurant description prompt includes awards when present
    - Test transition prompt includes travel mode and duration
    - Test user preference injection for authenticated users
  - [x] 3.2 Create system prompt for Anthony Bourdain voice
    - Define persona: curious, honest, passionate about food culture
    - Include explicit anti-cliche instructions (avoid "hidden gem", "must-try", "foodie paradise")
    - Specify conversational, storytelling-focused tone
    - Add culinary vocabulary guidelines
  - [x] 3.3 Create TourIntroPromptBuilder
    - Input: neighborhood, cuisine_types[], restaurant_count, time_of_day, transport_mode
    - Output: 50-75 word introduction prompt
    - Include few-shot example demonstrating desired output
    - For authenticated users: subtly integrate cuisine preferences
  - [x] 3.4 Create RestaurantDescriptionPromptBuilder
    - Input: restaurant_name, cuisine_type, signature_dishes[], awards[], neighborhood, stop_number, total_stops
    - Output: 75-100 word description prompt
    - Reference James Beard/Michelin awards prominently when present
    - For authenticated users: highlight dishes safe for dietary restrictions
    - Connect to overall tour narrative arc
  - [x] 3.5 Create TransitionPromptBuilder
    - Input: from_restaurant, to_restaurant, travel_mode, duration_minutes, distance
    - Output: 25-40 word transition prompt
    - Build anticipation for next stop
    - Connect stops thematically
  - [x] 3.6 Ensure prompt template tests pass
    - Run ONLY the 3-4 tests written in 3.1

**Acceptance Criteria:**
- The 3-4 tests from 3.1 pass
- System prompt captures Anthony Bourdain voice
- Each prompt type generates appropriate context
- User preferences integrated naturally when available

---

### Service Layer

#### Task Group 4: Narrative Generation Service
**Dependencies:** Task Groups 1, 2, 3
**Complexity:** M (Medium)

- [x] 4.0 Complete narrative generation service
  - [x] 4.1 Write 5-6 focused tests for NarrativeService
    - Test full tour narrative generation (intro + descriptions + transitions)
    - Test cache hit scenario (returns cached content, no API call)
    - Test cache miss scenario (generates new content, stores in cache)
    - Test partial success handling (some narratives succeed, some fail)
    - Test regenerate functionality (invalidates cache, generates fresh)
  - [x] 4.2 Create NarrativeService class
    - Inject GroqClient and cache repository dependencies
    - Accept tour data structure from Tour Generation Engine
    - Accept optional user preferences for personalization
  - [x] 4.3 Implement generateTourNarratives method
    - Generate all three narrative types: intro, descriptions[], transitions[]
    - Check cache first for each narrative type
    - Batch API requests when possible for efficiency
    - Return structured NarrativeResponse with all content
  - [x] 4.4 Implement cache lookup and storage logic
    - Compose cache key: tour_id + user_id (or "anonymous") + narrative_type + stop_index
    - Check TTL before returning cached content
    - Store new narratives with 30-day TTL
    - Increment cache_hit_count on cache hits
  - [x] 4.5 Implement regenerate functionality
    - Invalidate all existing cache entries for tour_id + user_id combination
    - Generate fresh narratives for all three types
    - Store new content with fresh 30-day TTL
    - Respect rate limit: 3 regenerations per tour per day
  - [x] 4.6 Ensure service layer tests pass
    - Run ONLY the 5-6 tests written in 4.1

**Acceptance Criteria:**
- The 5-6 tests from 4.1 pass
- Full tour narratives generate successfully
- Caching works correctly (hit/miss scenarios)
- Regenerate invalidates cache and creates fresh content
- Rate limiting prevents abuse

---

### Error Handling

#### Task Group 5: Fallbacks and Error Handling
**Dependencies:** Task Group 4
**Complexity:** S (Small)

- [x] 5.0 Complete error handling and fallback system
  - [x] 5.1 Write 3-4 focused tests for error handling
    - Test fallback to static text after all retries exhausted
    - Test partial results returned when some narratives fail
    - Test error logging with tour_id and narrative_type
  - [x] 5.2 Create static fallback templates
    - Tour intro fallback: generic but grammatically complete introduction
    - Restaurant description fallback: template using restaurant name and cuisine type
    - Transition fallback: generic travel transition text
  - [x] 5.3 Implement fallback selection logic
    - On all retries exhausted, return appropriate static fallback
    - Mark response with fallback_used: true flag
    - Include failed narrative types in response metadata
  - [x] 5.4 Implement comprehensive error logging
    - Log all failures with: tour_id, narrative_type, stop_index, error_type, error_message, attempt_count
    - Use structured logging format for monitoring/alerting
    - Track failure rates by narrative type
  - [x] 5.5 Ensure error handling tests pass
    - Run ONLY the 3-4 tests written in 5.1

**Acceptance Criteria:**
- The 3-4 tests from 5.1 pass
- Static fallbacks return grammatically complete text
- Partial results returned when some succeed
- All failures logged with full context

---

### API Layer

#### Task Group 6: Serverpod Endpoint
**Dependencies:** Task Groups 4, 5
**Complexity:** S (Small)

- [x] 6.0 Complete API endpoint implementation
  - [x] 6.1 Write 4-5 focused tests for API endpoint
    - Test successful narrative generation response structure
    - Test regenerate flag triggers fresh generation
    - Test authentication check for personalized narratives
    - Test rate limit enforcement on regenerate
  - [x] 6.2 Create NarrativeEndpoint in Serverpod
    - Endpoint path: /narratives/tour/{tour_id}
    - Accept tour_id (required) and regenerate flag (optional, default false)
    - Follow Serverpod endpoint patterns
  - [x] 6.3 Implement response structure
    - Return NarrativeResponse with: intro, descriptions[], transitions[]
    - Include metadata: generated_at, cached (boolean), ttl_remaining_seconds
    - Include fallback_used flag and failed_types[] when applicable
  - [x] 6.4 Implement authentication handling
    - For authenticated users: pull dietary restrictions, cuisine preferences from user profile
    - For anonymous users: generate narratives using tour parameters only
    - Pass user context to NarrativeService for personalization
  - [x] 6.5 Implement regenerate rate limiting
    - Track regenerate attempts per tour_id + user_id per day
    - Limit to 3 regenerations per tour per day
    - Return 429 status with retry_after when limit exceeded
  - [x] 6.6 Ensure API endpoint tests pass
    - Run ONLY the 4-5 tests written in 6.1

**Acceptance Criteria:**
- The 4-5 tests from 6.1 pass
- Endpoint returns properly structured response
- Authentication determines personalization level
- Rate limiting enforced on regenerate requests

---

### Testing

#### Task Group 7: Test Review and Gap Analysis
**Dependencies:** Task Groups 1-6
**Complexity:** S (Small)

- [x] 7.0 Review existing tests and fill critical gaps only
  - [x] 7.1 Review tests from Task Groups 1-6
    - Review 3-4 tests from database layer (Task 1.1)
    - Review 4-5 tests from Groq client (Task 2.1)
    - Review 3-4 tests from prompt templates (Task 3.1)
    - Review 5-6 tests from narrative service (Task 4.1)
    - Review 3-4 tests from error handling (Task 5.1)
    - Review 4-5 tests from API endpoint (Task 6.1)
    - Total existing tests: approximately 22-28 tests
  - [x] 7.2 Analyze test coverage gaps for this feature only
    - Identify critical end-to-end workflows lacking coverage
    - Focus on integration points between components
    - Do NOT assess entire application test coverage
  - [x] 7.3 Write up to 6 additional strategic tests if needed
    - Integration test: full flow from API request to cached response
    - Integration test: regenerate flow with cache invalidation
    - Integration test: anonymous vs authenticated user paths
    - Edge case: tour with single restaurant (no transitions)
    - Edge case: tour with many restaurants (10+ stops)
    - Performance: verify timeout handling under load
  - [x] 7.4 Run feature-specific tests only
    - Run ONLY tests related to LLM Narratives feature
    - Expected total: approximately 28-34 tests maximum
    - Do NOT run the entire application test suite
    - Verify all critical workflows pass

**Acceptance Criteria:**
- All feature-specific tests pass (approximately 28-34 tests total)
- Critical user workflows covered
- No more than 6 additional tests added
- Testing focused exclusively on LLM Narratives feature

---

## Execution Order

Recommended implementation sequence:

```
Phase 1 (Parallel - No Dependencies):
  - Task Group 1: Database Layer (Narrative Cache)
  - Task Group 2: Groq API Client
  - Task Group 3: Prompt Templates

Phase 2 (Sequential - Depends on Phase 1):
  - Task Group 4: Narrative Generation Service

Phase 3 (Sequential - Depends on Phase 2):
  - Task Group 5: Fallbacks and Error Handling

Phase 4 (Sequential - Depends on Phase 3):
  - Task Group 6: Serverpod Endpoint

Phase 5 (Final - Depends on All):
  - Task Group 7: Test Review and Gap Analysis
```

## Technical Notes

### Tech Stack Reference
- **Backend:** Serverpod 2.x (Dart)
- **Database:** PostgreSQL with Serverpod ORM
- **LLM Provider:** Groq with Llama 3.3 70B model
- **Caching:** PostgreSQL-based with TTL (30 days)

### Key Configuration Values
- Groq model: `llama-3.3-70b-versatile`
- Temperature: 0.7-0.8
- Request timeout: 10 seconds
- Retry delays: 1s, 2s, 4s (exponential backoff)
- Cache TTL: 30 days
- Daily rate limit: 14,400 requests (Groq free tier)
- Regenerate limit: 3 per tour per day

### Environment Variables Required
```
GROQ_API_KEY=...
```

### Data Dependencies
- Tour Generation Engine provides tour structure input
- User profile provides dietary restrictions and cuisine preferences
- James Beard and Michelin static datasets provide award context
