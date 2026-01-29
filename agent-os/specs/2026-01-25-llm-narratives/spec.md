# Specification: LLM Tour Narratives

## Goal

Generate engaging, Anthony Bourdain-inspired tour descriptions using Groq (Llama 3.3 70B) that transform a sequence of restaurant stops into a cohesive culinary journey with personalized storytelling.

## User Stories

- As a food tour user, I want AI-generated descriptions for my tour and each stop so that my dining experience feels like a curated culinary adventure rather than a simple list of restaurants.
- As an authenticated user, I want narratives personalized to my dietary preferences and cuisine history so that the descriptions feel relevant to my tastes.

## Specific Requirements

**Tour Introduction Narrative Generation**
- Generate 50-75 word introduction setting the theme and mood for the entire tour
- Reference the neighborhood/area, cuisine diversity represented, and tour highlights
- Use Anthony Bourdain-inspired tone: warm, knowledgeable, slightly irreverent, storytelling-focused
- Include local color and culinary vocabulary appropriate to the area
- For authenticated users, subtly reference their cuisine preferences when relevant

**Restaurant Description Narrative Generation**
- Generate 75-100 word description for each restaurant stop
- Include culinary context: signature dishes, cuisine style, what makes the spot notable
- Reference any James Beard or Michelin awards prominently
- Personalize based on user dietary restrictions for authenticated users (highlight safe dishes)
- Avoid generic food-review language; favor vivid, specific details
- Connect each description to the overall tour narrative arc

**Transition Narrative Generation**
- Generate 25-40 word transitions between consecutive stops
- Reference the travel mode (walking/driving) and approximate time between stops
- Build anticipation for the next stop while providing closure on the previous
- Connect stops thematically (e.g., "from seafood to barbecue, we cross neighborhoods...")

**Prompt Engineering Guidelines**
- Design system prompts that capture Anthony Bourdain's voice: curious, honest, passionate about food culture
- Include explicit instructions to avoid cliches ("hidden gem", "must-try", "foodie paradise")
- Provide structured context about each restaurant (name, cuisine, awards, signature dishes, neighborhood)
- Use temperature setting between 0.7-0.8 for creativity while maintaining coherence
- Include few-shot examples in prompts demonstrating desired tone and length

**Groq API Integration**
- Use Llama 3.3 70B model via Groq API
- Batch all narrative requests for a tour into a single API call when possible
- Implement timeout of 10 seconds per request
- Include tour_id and narrative_type in request metadata for tracing
- Respect Groq's 14,400 requests/day free tier limit

**Caching Strategy**
- Store generated narratives in PostgreSQL with 30-day TTL
- Cache key composition: tour_id + user_id (or "anonymous") + narrative_type + stop_index
- Serve cached narratives immediately on subsequent views
- Support cache invalidation via regenerate action
- Track cache hit/miss rates for monitoring

**Regenerate Functionality**
- Provide API endpoint to regenerate narratives for a specific tour
- Invalidate existing cache entries before generating fresh content
- Return new narratives and update cache with fresh 30-day TTL
- Rate limit regeneration to prevent abuse (suggest 3 per tour per day)

**Error Handling and Fallback**
- Implement retry logic: 3 attempts with exponential backoff (1s, 2s, 4s delays)
- On all retries exhausted, fall back to static template text per narrative type
- Static fallbacks should be grammatically complete but generic
- Log all failures with tour_id, narrative_type, error details for monitoring
- Return partial results if some narratives succeed and others fail

**Personalization Data Inputs**
- For authenticated users: pull dietary restrictions, cuisine preferences, visit history from user profile
- For anonymous users: use only tour parameters (mode, time of day, neighborhood, restaurants)
- Pass user preferences to prompt context to influence narrative generation
- Never expose raw user preference data in generated text; integrate naturally

**API Endpoint Design**
- Create Serverpod endpoint for narrative generation following REST principles
- Accept tour_id and optional regenerate flag
- Return structured response with all three narrative types (intro, descriptions[], transitions[])
- Include metadata: generated_at timestamp, cached boolean, ttl_remaining

## Visual Design

No visual assets provided for this specification.

## Existing Code to Leverage

**Tour Generation Engine (sibling spec)**
- The Tour Generation Engine provides the tour structure this feature consumes
- Tour output includes: ordered restaurant list, per-leg distances/durations, transport mode
- Restaurant data includes: name, cuisine type, awards, signature dishes from Foursquare
- Design narrative service to accept tour output structure as input

**Static Award Datasets**
- James Beard data from GitHub (cjwinchester/james-beard) provides award context
- Michelin data from Kaggle provides star/Bib Gourmand designations
- Reference award status in prompts to highlight accolades in narratives

## Out of Scope

- Multi-language narrative generation (English only for MVP)
- User-customizable tone settings (fixed Anthony Bourdain style)
- Narrative analytics or A/B testing infrastructure
- Audio narration or text-to-speech conversion
- User editing or modification of generated narratives
- Real-time streaming of narrative generation
- Narrative generation for non-tour contexts (individual restaurant pages)
- Integration with other LLM providers (Groq only)
- Fine-tuning or custom model training
- Storing multiple narrative versions per tour (only latest cached)
