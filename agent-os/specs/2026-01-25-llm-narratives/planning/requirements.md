# Spec Requirements: LLM Tour Narratives

## Initial Description

Generate engaging, contextual descriptions for each tour stop and overall tour theme using Groq (Llama 3.3 70B) with culinary and local context. This is item #4 from the Phase 1 MVP roadmap, estimated as a Small (S) effort of 2-3 days.

## Requirements Discussion

### First Round Questions

**Q1:** What types of narratives should be generated - tour intro/theme only, individual restaurant descriptions, or both plus transitions between stops?
**Answer:** Include ALL three - tour intro/theme, restaurant descriptions, and transitions between stops.

**Q2:** What tone/style should the narratives have - formal food critic, conversational local guide, enthusiastic foodie, or something else?
**Answer:** Conversational like a local food guide, inspired by Anthony Bourdain - warm, knowledgeable, with culinary enthusiasm and storytelling flair.

**Q3:** What are the expected length constraints for each narrative type?
**Answer:** Approved as proposed - tour intro 50-75 words, restaurant descriptions 75-100 words, transitions 25-40 words.

**Q4:** Should narratives incorporate user preferences (dietary restrictions, cuisine preferences) or tour parameters (walking vs driving, time of day)?
**Answer:** Use tour data AND factor in user preferences/history for authenticated users.

**Q5:** How should narratives be cached - generate once and store, regenerate on each view, or cache with TTL?
**Answer:** User didn't specify - default to caching with 30-day TTL and support "refresh/regenerate" button.

**Q6:** What fallback behavior should occur if the LLM API fails or times out?
**Answer:** Use retry logic before falling back to static text.

**Q7:** Is anything explicitly out of scope for this spec?
**Answer:** Nothing explicitly excluded.

### Existing Code to Reference

No similar existing features identified for reference. This is a new project.

### Follow-up Questions

None required - user provided comprehensive answers.

## Visual Assets

### Files Provided:
No visual assets provided.

### Visual Insights:
N/A

## Requirements Summary

### Functional Requirements

**Tour Introduction Narratives:**
- Generate 50-75 word introduction for each tour
- Set the theme and mood for the overall dining journey
- Reference the neighborhood/area, cuisine diversity, and tour highlights
- Incorporate Anthony Bourdain-inspired storytelling style

**Restaurant Description Narratives:**
- Generate 75-100 word description for each restaurant stop
- Include culinary context (signature dishes, chef background, cuisine style)
- Reference local significance and what makes the spot special
- Personalize based on user preferences for authenticated users

**Transition Narratives:**
- Generate 25-40 word transitions between consecutive stops
- Reference the walking/driving route and what to expect
- Build anticipation for the next stop
- Connect the culinary journey thematically

**Personalization:**
- For authenticated users: incorporate dietary restrictions, cuisine preferences, and visit history
- For anonymous users: use tour parameters only (mode, time of day, neighborhood)

**Caching and Regeneration:**
- Cache generated narratives with 30-day TTL
- Provide "refresh/regenerate" button in UI to get fresh narratives
- Cache key should include tour parameters and user preferences to ensure appropriate personalization

**Error Handling:**
- Implement retry logic (suggest 3 attempts with exponential backoff)
- Fall back to static template text if all retries fail
- Log failures for monitoring and improvement

### Reusability Opportunities

- None identified (new project)

### Scope Boundaries

**In Scope:**
- Tour introduction narrative generation (50-75 words)
- Restaurant description narrative generation (75-100 words)
- Transition narrative generation between stops (25-40 words)
- Anthony Bourdain-inspired conversational tone
- User preference integration for personalization
- Caching with 30-day TTL
- Regenerate/refresh capability
- Retry logic with static text fallback
- Integration with Groq API (Llama 3.3 70B)

**Out of Scope:**
- Nothing explicitly excluded by user
- Implicitly out of scope for MVP: multi-language support, user-customizable tone settings, narrative analytics

### Technical Considerations

**LLM Provider:**
- Groq with Llama 3.3 70B model (per tech-stack.md)
- 14,400 requests/day free tier capacity
- Known for fastest inference speeds

**Backend:**
- Serverpod 2.x (Dart)
- PostgreSQL for caching (TTL-based, per tech-stack.md)

**API Design:**
- Should follow Serverpod endpoint patterns
- Consider batch generation (all narratives for a tour in one call) vs individual calls

**Prompt Engineering:**
- Design prompts that capture Anthony Bourdain's voice: warm, irreverent, knowledgeable, storytelling-focused
- Include culinary vocabulary and local color
- Avoid generic food-review language

**Data Inputs Required:**
- Tour metadata: neighborhood, mode (walking/driving), time of day, total stops
- Restaurant data: name, cuisine type, signature dishes, awards, neighborhood context
- User preferences (authenticated): dietary restrictions, cuisine preferences, visit history
- Previous stop info (for transitions): restaurant name, cuisine, distance to next stop

**Cache Strategy:**
- PostgreSQL-based caching (per tech-stack.md)
- 30-day TTL
- Cache key composition: tour_id + user_id (or anonymous) + narrative_type + stop_index
- Invalidation on regenerate request
