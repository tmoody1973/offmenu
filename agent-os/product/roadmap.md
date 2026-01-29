# Product Roadmap

## Phase 1: Foundation - Core Discovery and Storytelling

1. [ ] Story-First Restaurant Profiles — Build restaurant detail screens that lead with narrative content (origin story, chef background, cultural significance) before ratings and logistics, using Perplexity to research and synthesize restaurant stories. `M`

2. [ ] Dish-Level Search — Implement search that understands specific dishes ("best tonkotsu ramen near me", "authentic birria tacos") using Perplexity Sonar to find dish-specific recommendations with citations. `M`

3. [ ] Award Database Integration — Integrate Michelin and James Beard award data with prominent badges, filter options, and contextual explanations of what each award signifies. `S`

4. [ ] AI-Curated Food Tours — Generate multi-stop narrative food journeys with thematic storytelling (e.g., "The Italian Immigration Story of this Neighborhood") connecting stops through cultural or culinary threads. `L`

5. [ ] Tour Route Optimization — Calculate walking and driving routes between tour stops with digestion-optimized timing gaps using Mapbox Directions API. `S`

6. [ ] Interactive Tour Map — Display tour routes on Mapbox with restaurant pins, route visualization, and tap-to-reveal story snippets for each stop. `S`

7. [ ] Restaurant Story Generation — Use Perplexity to research and generate compelling narratives for restaurants including chef history, signature dishes, and cultural context with source citations. `M`

8. [ ] Basic User Accounts — Implement Serverpod Auth with email and social login (Google, Apple) to enable saved tours, favorites, and preference persistence. `M`

## Phase 2: Personalization - Culinary DNA System

9. [ ] Culinary DNA Onboarding — Create an engaging onboarding flow that profiles users across dimensions: flavor intensity preferences, texture affinities, spice tolerance, adventure threshold, and dining context preferences. `M`

10. [ ] Palate Profile Storage — Build backend models and APIs to store and update user palate profiles with versioning to track taste evolution over time. `S`

11. [ ] Preference-Matched Recommendations — Integrate Culinary DNA profiles into the recommendation engine, weighting suggestions based on flavor/texture/adventure alignment. `L`

12. [ ] Moment-Aware Context — Enable users to specify current context (date night, solo exploration, business dinner, family meal) and adjust recommendations accordingly. `S`

13. [ ] Adventure Level Slider — Add UI control allowing users to dial up or down how far outside their comfort zone recommendations should venture. `S`

14. [ ] Palate Evolution Insights — Display visualizations showing how user preferences have shifted over time based on their ratings and visits. `M`

## Phase 3: Storytelling - Documentary Experience

15. [ ] Documentary Mode Audio — Generate and play narrated audio stories about restaurants as users approach, covering chef lineage, dish origins, and neighborhood history. `L`

16. [ ] Text-to-Speech Integration — Integrate a natural-sounding TTS service to convert generated narratives into audio content. `M`

17. [ ] Chef Lineage Visualization — Build interactive "family trees" showing where chefs trained, who their mentors were, and which restaurants share culinary DNA. `L`

18. [ ] Neighborhood History Context — Research and display cultural and historical context for neighborhoods, explaining how immigration patterns, industry, and history shaped local cuisine. `M`

19. [ ] Dish Origin Stories — Create detailed narratives for signature dishes tracing their journey across generations, borders, and adaptations. `M`

20. [ ] Location-Triggered Stories — Use geofencing to automatically trigger relevant audio/visual stories as users physically approach restaurants on their tour. `M`

## Phase 4: Community - The Locals Network

21. [ ] User Trust Profiles — Build reputation system distinguishing between industry professionals, longtime locals, travelers, and casual users based on verification and activity. `M`

22. [ ] Chef Recommendations — Enable verified industry professionals to share where they eat on their nights off, with special "Chef Picks" designation. `M`

23. [ ] Insider Tips System — Allow verified locals to submit insider knowledge: off-menu items, best times to visit, kitchen secrets, seating tips. `S`

24. [ ] Trust-Weighted Discovery — Weight recommendation visibility based on source trust level and taste-profile similarity between recommender and user. `L`

25. [ ] Recommendation Accuracy Tracking — Track how well users' recommendations land with others, building reputation scores based on prediction accuracy. `M`

26. [ ] Local Verification Flow — Implement verification system for locals (residence duration, neighborhood knowledge quiz) and industry (employer verification, badge upload). `M`

## Phase 5: Gamification - Culinary Quests

27. [ ] Quest Framework — Build system for defining themed culinary journeys (The Ramen Pilgrimage, The Immigrant Journey, The Farmer's Path) with stops, objectives, and completion criteria. `M`

28. [ ] Quest Discovery and Enrollment — Create UI for browsing available quests, viewing requirements, and enrolling in multi-stop culinary adventures. `S`

29. [ ] Quest Progress Tracking — Track user progress through quests, marking completed stops, awarding checkpoints, and displaying journey maps. `S`

30. [ ] Serendipity Engine — Build the "Anti-Algorithm" that intentionally surfaces unexpected recommendations outside user profiles to promote culinary adventure. `L`

31. [ ] Achievement System — Design and implement achievement badges for milestones: first quest completed, visited 5 cuisines, explored new neighborhood, etc. `M`

32. [ ] Shareable Food Journeys — Generate beautiful visual narratives of completed tours and quests that users can share to social media or export. `M`

33. [ ] Quest Leaderboards — Optional competitive element showing quest completion rates and culinary exploration breadth. `S`

## Phase 6: Intelligence - Real-Time and Values

34. [ ] Time-Aware Recommendations — Adjust recommendations based on time of day, day of week, accounting for restaurant hours, meal service periods, and crowd patterns. `M`

35. [ ] Real-Time Wait Times — Integrate or estimate current wait times and table availability through API partnerships or crowd-sourced data. `L`

36. [ ] Seasonal Dish Tracking — Monitor and surface seasonal specialties, limited-time offerings, and dishes only available at certain times. `M`

37. [ ] The Integrity Layer — Research and display values-based information: local sourcing practices, labor treatment, cultural authenticity scores, sustainability efforts. `L`

38. [ ] Perplexity Current Intelligence — Use Perplexity Sonar for on-demand restaurant research: recent reviews, chef changes, closure warnings, current buzz. `M`

39. [ ] Reservation Integration — Connect with OpenTable Partner API for in-app availability checking and booking with confirmation management. `L`

40. [ ] OpenTable Experiences — Browse and book special dining events (tasting menus, wine pairings, chef's tables) from OpenTable Experiences marketplace. `M`

---

> Notes
> - Order reflects technical dependencies: user accounts before personalization, basic stories before documentary mode, profiles before community trust
> - Phase 1 establishes core product value: AI-powered storytelling and dish-level discovery
> - Perplexity Sonar is the primary research engine throughout, providing cited, current information
> - OpenTable integration (items 39-40) depends on 3-4 week affiliate approval process - can develop in parallel
> - Documentary Mode (Phase 3) is a significant differentiator requiring TTS integration and content generation
> - Community features (Phase 4) require critical mass - consider seeding with curated content initially
> - Effort: XS (1 day), S (2-3 days), M (1 week), L (2 weeks), XL (3+ weeks)
