# Specification: Mapbox Integration

## Goal

Provide interactive map visualization and location services for Food Tour Butler, enabling users to view generated food tours on a map with restaurant markers, route polylines, turn-by-turn directions, and real-time location tracking.

## User Stories

- As a food tour user, I want to see my generated tour displayed on an interactive map so that I can visualize the route and restaurant locations before starting my food crawl.
- As a user navigating a food tour, I want to see turn-by-turn directions between stops so that I can easily walk or drive to each restaurant without leaving the app.

## Specific Requirements

**Interactive Map Display**
- Use Mapbox Maps Flutter SDK as the mapping framework
- Configure map with mobile-first responsive design following project breakpoints (mobile < 600px, tablet 600-1024px, desktop > 1024px)
- Apply a clean, readable map style appropriate for food/dining context
- Ensure touch-friendly interactions with minimum 44x44px tap targets per accessibility standards
- Map should fill the available viewport with appropriate padding for UI controls

**Restaurant Pin Markers**
- Display numbered circular markers (1, 2, 3...) corresponding to tour stop order
- Markers should be visually distinct and easily tappable on mobile devices
- Use consistent pin styling that stands out against varying map backgrounds
- Support dynamic marker updates when tour data changes
- Markers should include subtle visual hierarchy (current stop vs upcoming stops)

**Route Polyline Visualization**
- Render route as a polyline connecting stops in sequential order
- Use green color for walking mode routes
- Use blue color for driving mode routes
- Polyline should have appropriate stroke width for visibility on mobile
- Fetch polyline coordinates from Mapbox Directions API via backend (Tour Generation Engine provides route data)
- Support smooth polyline rendering without jagged edges

**Restaurant Info Bottom Sheet**
- Display bottom sheet/popup when user taps a restaurant pin marker
- Include: restaurant name, award badges (James Beard, Michelin), stop number, cuisine type, mini-photo thumbnail
- Include "View Details" button to navigate to full restaurant detail page
- Reuse award badge component from Award Badge Display spec
- Thumbnail images served from Cloudflare R2
- Bottom sheet should be dismissible via swipe-down gesture or tap-outside

**User Location Display**
- Show user's current location with pulsing blue dot indicator
- Request location permission via Browser Geolocation API (HTTPS required)
- Handle permission denied gracefully with informative message
- Location dot should update as user moves (reasonable refresh interval to conserve battery)
- Provide clear visual distinction between user location and restaurant markers

**Center on Location Button**
- Floating action button to re-center map on user's current location
- Position button in accessible location (bottom-right recommended)
- Show loading state while fetching location
- Disable button if location permission denied
- Animate map pan to user location smoothly

**Auto-Fit Map Bounds**
- When a tour loads, automatically calculate bounding box to show all stops
- Apply appropriate padding so markers are not cut off at edges
- Consider user location in bounds calculation if available
- Provide smooth zoom animation to final bounds

**In-App Turn-by-Turn Directions**
- Fetch detailed turn-by-turn directions from Mapbox Directions API on-demand when user requests
- Display directions in a scrollable list or step-by-step card interface
- Show distance and estimated time for each leg
- Support both walking and driving instruction sets
- Highlight current/next maneuver instruction
- Allow collapsing directions panel to maximize map view

**Geocoding for Starting Location (Tour Generation Flow)**
- Integrate Mapbox Geocoding API for address search in tour generation form
- Provide autocomplete suggestions as user types
- Display search results with address details for disambiguation
- Support "Use my current location" option alongside manual address entry
- Validate and geocode selected address to coordinates for tour generation

## Visual Design

No visual mockups were provided for this specification.

## Existing Code to Leverage

**Tour Generation Engine (spec: 2026-01-25-tour-generation-engine)**
- Backend provides route polyline coordinates via Mapbox Directions API integration
- Tour output includes per-leg distance and duration summaries
- Frontend receives structured tour data with ordered restaurant stops
- Follow the hybrid approach: backend provides route overview, frontend fetches turn-by-turn on-demand

**Award Badge Display (spec: 2026-01-25-award-badges)**
- Reuse award badge component for displaying James Beard and Michelin badges in restaurant info bottom sheet
- Follow established color scheme: gold/red for Michelin, blue for James Beard
- Badge component designed for compact display in map popups context

**Cloudflare R2 Image Storage (tech-stack)**
- Restaurant thumbnail photos already served from Cloudflare R2
- Use existing image URL patterns for mini-photos in bottom sheet
- Apply appropriate image sizing/compression for popup thumbnails

## Out of Scope

- Offline maps caching and offline map display
- 3D buildings layer rendering
- Traffic layer overlay
- Opening external maps apps (Google Maps, Apple Maps) for navigation
- Real-time location sharing between users
- Map-based journal view (separate roadmap item #19)
- Public transit or cycling directions modes
- Custom map style design/theming beyond default Mapbox styles
- Map rotation or 3D tilt gestures
- Restaurant clustering at low zoom levels (can be added later if needed)
