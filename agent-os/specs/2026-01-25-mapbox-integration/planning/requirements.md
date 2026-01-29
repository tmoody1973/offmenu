# Spec Requirements: Mapbox Integration

## Initial Description

Maps, routing, and location services for the Food Tour Butler app. Includes displaying interactive maps with restaurant markers, route visualization between stops, walking/driving directions, geocoding for address search, and user location tracking. This integrates with the Tour Generation Engine to visualize generated food tours on an interactive map.

## Requirements Discussion

### First Round Questions

**Q1:** I assume the map should display restaurant pins with numbered markers (1, 2, 3...) corresponding to the tour stop order. Is that correct, or should pins show restaurant names/icons instead?
**Answer:** Numbered markers corresponding to tour stop order.

**Q2:** I'm thinking the route visualization should show a polyline connecting stops in sequence with different colors for walking (green) vs driving (blue) modes. Should we use these colors, or do you have a different color scheme preference?
**Answer:** Confirmed - green for walking, blue for driving route visualization.

**Q3:** When a user taps a restaurant pin, I assume a popup/bottom sheet should appear with restaurant details. What information should be displayed in this quick-view popup?
**Answer:** The popup/bottom sheet should include:
- Restaurant name
- Award badges (James Beard, Michelin)
- Stop number in tour sequence
- Cuisine type
- Mini-photo
- "View Details" button to navigate to full restaurant page

**Q4:** For the geocoding/address search, should this be a standalone search bar on the map, or integrated into the tour generation flow where users search for a starting location?
**Answer:** Integrated into the tour generation flow for searching starting location.

**Q5:** I assume we should show the user's current location on the map with a pulsing blue dot, similar to standard mapping apps. Should users be able to center the map on their location with a button?
**Answer:** Yes, show current location with pulsing blue dot and include a "center on my location" button.

**Q6:** For turn-by-turn directions between stops, should we display directions in-app, or open the native maps app (Google Maps/Apple Maps) for navigation?
**Answer:** Display directions in-app for the MVP.

**Q7:** Should the map automatically zoom/fit to show all tour stops when a tour is loaded, or start at a default zoom level on the first stop?
**Answer:** Automatically zoom/fit to show all tour stops when loaded.

**Q8:** Is there anything specific you want to exclude from this initial Mapbox integration (e.g., offline maps, 3D buildings, traffic layer)?
**Answer:** Exclude offline maps, 3D buildings, and traffic layer for MVP. Keep it focused on core functionality.

### Existing Code to Reference

No similar existing features identified for reference. This is a new feature building on the Mapbox Maps Flutter SDK.

### Follow-up Questions

No follow-up questions were needed - all requirements were clarified in the first round.

## Visual Assets

### Files Provided:
No visual assets provided.

### Visual Insights:
N/A

## Requirements Summary

### Functional Requirements
- Display interactive Mapbox map with restaurant pins as numbered markers (1, 2, 3...) corresponding to tour stop order
- Visualize tour route as polyline connecting stops in sequence
  - Green polyline for walking mode
  - Blue polyline for driving mode
- Restaurant pin tap interaction displays popup/bottom sheet containing:
  - Restaurant name
  - Award badges (James Beard, Michelin)
  - Stop number in tour sequence
  - Cuisine type
  - Mini-photo (thumbnail)
  - "View Details" button to navigate to full restaurant page
- Geocoding/address search integrated into tour generation flow for starting location
- Display user's current location with pulsing blue dot
- "Center on my location" button to re-center map on user position
- In-app turn-by-turn directions display between stops
- Auto-fit map bounds to show all tour stops when a tour is loaded

### Reusability Opportunities
- Award badge component (likely exists or will be created for restaurant cards)
- Restaurant mini-card/popup component pattern
- Navigation/routing state management

### Scope Boundaries

**In Scope:**
- Mapbox GL map display with Flutter SDK
- Restaurant pin markers with stop numbers
- Route polyline visualization (walking/driving)
- Popup/bottom sheet for restaurant quick-view
- Geocoding for starting location search
- User location display with centering button
- In-app directions display
- Auto-fit bounds on tour load
- Walking and driving mode support via Mapbox Directions API

**Out of Scope:**
- Offline maps (deferred to future phase)
- 3D buildings layer
- Traffic layer
- Opening external maps apps for navigation
- Real-time location tracking/sharing (separate roadmap item)
- Map-based journal view (separate roadmap item #19)

### Technical Considerations
- Use Mapbox Maps Flutter SDK (https://docs.mapbox.com/flutter/maps/guides/)
- Use Mapbox Directions API for route polylines and turn-by-turn directions
- Use Mapbox Geocoding API for address search
- Use Browser Geolocation API for user location
- Map style should be mobile-first and responsive per tech stack breakpoints
- Consider Mapbox rate limits: 100K direction requests/month, 50K map loads/month
- Environment variable: MAPBOX_ACCESS_TOKEN required
- Restaurant photo thumbnails served from Cloudflare R2
