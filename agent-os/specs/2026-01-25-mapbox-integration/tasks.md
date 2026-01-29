# Task Breakdown: Mapbox Integration

## Overview

Total Tasks: 42
Estimated Total Effort: Large (L)

This task breakdown covers the implementation of interactive map visualization and location services for Food Tour Butler using the Mapbox Maps Flutter SDK. The feature enables users to view generated food tours on a map with restaurant markers, route polylines, turn-by-turn directions, and real-time location tracking.

## Task List

### Core Map Infrastructure

#### Task Group 1: Mapbox SDK Setup and Base Map Widget
**Dependencies:** None
**Complexity:** Medium (M)

- [x] 1.0 Complete Mapbox SDK setup and base map widget
  - [x] 1.1 Write 4 focused tests for map widget functionality
    - Test map widget renders without errors
    - Test map initializes with correct default center/zoom
    - Test map responds to viewport changes (responsive breakpoints)
    - Test MAPBOX_ACCESS_TOKEN configuration is validated
  - [x] 1.2 Add Mapbox Maps Flutter SDK dependency
    - Add `mapbox_maps_flutter` to pubspec.yaml
    - Configure platform-specific settings (iOS/Android/Web)
    - Set up MAPBOX_ACCESS_TOKEN environment variable
  - [x] 1.3 Create base `FoodTourMapWidget` component
    - Props: initialCenter, initialZoom, onMapReady callback
    - Apply clean, readable map style (Mapbox Streets or similar)
    - Implement mobile-first responsive sizing per breakpoints (mobile < 600px, tablet 600-1024px, desktop > 1024px)
    - Ensure map fills available viewport with appropriate padding
  - [x] 1.4 Implement touch-friendly map controls
    - Minimum 44x44px tap targets per accessibility standards
    - Zoom controls positioned accessibly
    - Gesture handling for pan/pinch-zoom
  - [x] 1.5 Ensure base map widget tests pass
    - Run ONLY the 4 tests written in 1.1
    - Verify map renders correctly across breakpoints

**Acceptance Criteria:**
- The 4 tests written in 1.1 pass
- Map displays correctly on mobile, tablet, and desktop
- Touch interactions work smoothly
- Map style is clean and readable for food/dining context

---

### Marker System

#### Task Group 2: Restaurant Pin Markers
**Dependencies:** Task Group 1
**Complexity:** Medium (M)

- [x] 2.0 Complete restaurant marker system
  - [x] 2.1 Write 4 focused tests for marker functionality
    - Test markers render with correct stop numbers (1, 2, 3...)
    - Test markers are tappable and fire selection callback
    - Test marker visual hierarchy (current stop vs upcoming)
    - Test markers update dynamically when tour data changes
  - [x] 2.2 Create `NumberedMarkerWidget` component
    - Circular marker with stop number centered
    - Visually distinct design that stands out against map backgrounds
    - Props: stopNumber, isCurrentStop, isSelected, onTap
    - Minimum 44x44px tap target for accessibility
  - [x] 2.3 Create `TourMarkersLayer` component
    - Accepts list of tour stops with coordinates
    - Renders NumberedMarkerWidget for each stop
    - Manages marker selection state
    - Supports dynamic updates when tour data changes
  - [x] 2.4 Implement marker visual hierarchy
    - Current stop: emphasized styling (larger, highlighted)
    - Upcoming stops: standard styling
    - Completed stops: muted/faded styling (optional)
  - [x] 2.5 Ensure marker tests pass
    - Run ONLY the 4 tests written in 2.1
    - Verify markers render and interact correctly

**Acceptance Criteria:**
- The 4 tests written in 2.1 pass
- Numbered markers display correctly for all tour stops
- Markers are easily tappable on mobile devices
- Visual hierarchy clearly indicates current stop

---

### Route Visualization

#### Task Group 3: Route Polyline Rendering
**Dependencies:** Task Groups 1, 2
**Complexity:** Medium (M)

- [x] 3.0 Complete route polyline visualization
  - [x] 3.1 Write 3 focused tests for polyline functionality
    - Test polyline renders from route coordinates
    - Test correct color applied for walking (green) vs driving (blue) mode
    - Test polyline updates when route data changes
  - [x] 3.2 Create `RoutePolylineLayer` component
    - Accepts route coordinates from Tour Generation Engine backend
    - Props: coordinates, transportMode (walking/driving), strokeWidth
    - Renders smooth polyline without jagged edges
    - Appropriate stroke width for mobile visibility (3-5px recommended)
  - [x] 3.3 Implement transport mode color coding
    - Walking mode: green polyline (#22C55E or similar)
    - Driving mode: blue polyline (#3B82F6 or similar)
    - Consistent color scheme across the application
  - [x] 3.4 Integrate polyline with map widget
    - Polyline renders below markers in layer order
    - Coordinates from Mapbox Directions API via backend
    - Handle empty/null route data gracefully
  - [x] 3.5 Ensure polyline tests pass
    - Run ONLY the 3 tests written in 3.1
    - Verify polyline renders correctly for both modes

**Acceptance Criteria:**
- The 3 tests written in 3.1 pass
- Polyline connects stops in correct sequential order
- Green color for walking, blue for driving
- Smooth rendering on all devices

---

### Restaurant Info UI

#### Task Group 4: Restaurant Info Bottom Sheet
**Dependencies:** Task Groups 2, Award Badge Display spec
**Complexity:** Medium (M)

- [x] 4.0 Complete restaurant info bottom sheet
  - [x] 4.1 Write 4 focused tests for bottom sheet functionality
    - Test bottom sheet opens when marker is tapped
    - Test correct restaurant data displays (name, cuisine, stop number)
    - Test award badges render correctly (reusing AwardBadge component)
    - Test "View Details" navigation works
  - [x] 4.2 Create `RestaurantInfoBottomSheet` component
    - Displays on marker tap
    - Props: restaurant data object, onViewDetails callback, onDismiss
    - Dismissible via swipe-down gesture or tap-outside
    - Mobile-first layout with proper spacing
  - [x] 4.3 Implement bottom sheet content layout
    - Restaurant name (prominent heading)
    - Stop number badge (e.g., "Stop 1")
    - Cuisine type label
    - Award badges row (reuse AwardBadge component from Award Badge Display spec)
      - James Beard: blue styling
      - Michelin: gold/red styling
    - Mini-photo thumbnail (served from Cloudflare R2)
    - "View Details" button (primary action)
  - [x] 4.4 Implement thumbnail image handling
    - Load images from Cloudflare R2 URLs
    - Apply appropriate sizing for popup context (~80x80px or similar)
    - Handle image loading states and errors gracefully
    - Lazy load thumbnails for performance
  - [x] 4.5 Connect bottom sheet to marker tap events
    - Open sheet when marker is tapped
    - Update content when different marker selected
    - Maintain selection state sync with map markers
  - [x] 4.6 Ensure bottom sheet tests pass
    - Run ONLY the 4 tests written in 4.1
    - Verify all content renders correctly

**Acceptance Criteria:**
- The 4 tests written in 4.1 pass
- Bottom sheet displays all required restaurant info
- Award badges display correctly using shared component
- Navigation to restaurant detail page works
- Gestures for dismissal work on mobile

---

### User Location

#### Task Group 5: User Location Display and Controls
**Dependencies:** Task Group 1
**Complexity:** Medium (M)

- [x] 5.0 Complete user location functionality
  - [x] 5.1 Write 4 focused tests for location functionality
    - Test location permission request flow
    - Test pulsing blue dot renders at user location
    - Test "center on location" button works
    - Test permission denied state handled gracefully
  - [x] 5.2 Implement location permission handling
    - Request permission via Browser Geolocation API
    - Handle permission granted/denied/unavailable states
    - Display informative message when permission denied
    - Store permission state for UI updates
  - [x] 5.3 Create `UserLocationMarker` component
    - Pulsing blue dot indicator
    - Clear visual distinction from restaurant markers
    - Updates position as user moves (reasonable refresh interval ~5-10s to conserve battery)
  - [x] 5.4 Create `CenterOnLocationButton` component
    - Floating action button design
    - Position: bottom-right of map (accessible location)
    - Props: onTap, isLoading, isDisabled
    - Show loading state while fetching location
    - Disable when location permission denied
    - Animate map pan to user location smoothly
  - [x] 5.5 Integrate location features with map
    - Location marker layer above route polyline
    - Button positioned outside map bounds interaction area
    - Handle edge case: user location far from tour area
  - [x] 5.6 Ensure location tests pass
    - Run ONLY the 4 tests written in 5.1
    - Verify location features work on mobile browsers

**Acceptance Criteria:**
- The 4 tests written in 5.1 pass
- Permission request works correctly
- Pulsing blue dot clearly visible
- Center button animates map smoothly
- Graceful handling of denied permissions

---

### Map Bounds and Auto-Fit

#### Task Group 6: Auto-Fit Map Bounds
**Dependencies:** Task Groups 1, 2, 5
**Complexity:** Small (S)

- [x] 6.0 Complete auto-fit bounds functionality
  - [x] 6.1 Write 3 focused tests for bounds functionality
    - Test bounds calculation includes all tour stops
    - Test bounds calculation includes user location when available
    - Test smooth zoom animation to final bounds
  - [x] 6.2 Create `calculateTourBounds` utility function
    - Calculate bounding box from array of stop coordinates
    - Optional: include user location in calculation if available
    - Apply appropriate padding so markers not cut off (50-100px padding)
  - [x] 6.3 Implement auto-fit on tour load
    - Trigger when tour data is loaded/changed
    - Animate map camera to calculated bounds
    - Smooth zoom animation (duration ~500-800ms)
  - [x] 6.4 Ensure bounds tests pass
    - Run ONLY the 3 tests written in 6.1
    - Verify map shows all stops after tour load

**Acceptance Criteria:**
- The 3 tests written in 6.1 pass
- All tour stops visible when tour loads
- User location included in bounds when available
- Smooth camera animation

---

### Turn-by-Turn Directions

#### Task Group 7: In-App Directions Display
**Dependencies:** Task Groups 1, 3
**Complexity:** Large (L)

- [x] 7.0 Complete turn-by-turn directions feature
  - [x] 7.1 Write 5 focused tests for directions functionality
    - Test directions fetch from Mapbox Directions API on-demand
    - Test direction steps render in scrollable list
    - Test distance and time display for each leg
    - Test current/next maneuver highlighting
    - Test directions panel collapse/expand
  - [x] 7.2 Create directions API service layer
    - Fetch turn-by-turn directions from Mapbox Directions API
    - Support walking and driving instruction sets
    - Parse response into structured direction steps
    - Handle API errors gracefully
    - Mock external API calls in tests
  - [x] 7.3 Create `DirectionsStepCard` component
    - Display maneuver instruction text
    - Show distance and estimated time
    - Visual indicator for maneuver type (turn left, right, straight, etc.)
    - Highlight style for current/next step
  - [x] 7.4 Create `DirectionsPanel` component
    - Scrollable list of DirectionsStepCard components
    - Props: directionSteps, currentStepIndex, onCollapse
    - Collapsible to maximize map view
    - Shows leg summaries (total distance/time between stops)
  - [x] 7.5 Implement "Get Directions" trigger
    - Button or action to request directions on-demand
    - Loading state while fetching
    - Panel opens with results
  - [x] 7.6 Ensure directions tests pass
    - Run ONLY the 5 tests written in 7.1
    - Verify directions display correctly

**Acceptance Criteria:**
- The 5 tests written in 7.1 pass
- Directions fetched on-demand (not preloaded)
- Step-by-step instructions clear and readable
- Distance and time shown for each segment
- Panel can be collapsed for more map space

---

### Geocoding Integration

#### Task Group 8: Address Search for Tour Generation
**Dependencies:** None (can parallel with Task Groups 1-3)
**Complexity:** Medium (M)

- [x] 8.0 Complete geocoding/address search functionality
  - [x] 8.1 Write 4 focused tests for geocoding functionality
    - Test autocomplete suggestions appear as user types
    - Test address selection returns coordinates
    - Test "Use my current location" option works
    - Test search handles no results gracefully
  - [x] 8.2 Create geocoding API service layer
    - Integrate Mapbox Geocoding API
    - Fetch autocomplete suggestions with debounce (~300ms)
    - Parse response into address result objects
    - Handle API errors gracefully
    - Mock external API calls in tests
  - [x] 8.3 Create `AddressSearchInput` component
    - Text input with autocomplete dropdown
    - Props: onAddressSelect, placeholder, initialValue
    - Display suggestions with address details for disambiguation
    - Clear button to reset search
    - Keyboard accessible
  - [x] 8.4 Create `AddressSuggestionList` component
    - Renders list of geocoding results
    - Each item shows formatted address
    - Tap to select and close dropdown
    - Loading state while fetching
  - [x] 8.5 Implement "Use my current location" option
    - Button/option alongside address input
    - Triggers geolocation request
    - Reverse geocode coordinates to address for display
    - Pre-fill input with location address
  - [x] 8.6 Integrate with tour generation flow
    - Address search component in tour generation form
    - Selected address coordinates passed to tour generation
    - Validate address is geocodable before form submission
  - [x] 8.7 Ensure geocoding tests pass
    - Run ONLY the 4 tests written in 8.1
    - Verify search works in tour generation context

**Acceptance Criteria:**
- The 4 tests written in 8.1 pass
- Autocomplete suggestions appear quickly
- Selected address provides valid coordinates
- "Use my current location" works seamlessly
- Integrated into tour generation form

---

### Integration and Testing

#### Task Group 9: Full Map View Integration
**Dependencies:** Task Groups 1-8
**Complexity:** Medium (M)

- [x] 9.0 Complete full map view integration
  - [x] 9.1 Write 3 focused integration tests
    - Test complete tour renders with markers, polyline, and bounds
    - Test marker tap opens bottom sheet with correct data
    - Test directions request and display flow works end-to-end
  - [x] 9.2 Create `TourMapView` container component
    - Composes all map layers and controls:
      - FoodTourMapWidget (base map)
      - RoutePolylineLayer
      - TourMarkersLayer
      - UserLocationMarker
      - CenterOnLocationButton
    - Manages shared state between components
    - Props: tourData, onRestaurantSelect
  - [x] 9.3 Implement state management for map interactions
    - Selected marker state
    - Directions panel visibility state
    - Bottom sheet open/closed state
    - User location state
  - [x] 9.4 Connect to Tour Generation Engine data
    - Consume tour data from backend
    - Extract stop coordinates, route polyline, transport mode
    - Handle loading and error states for tour data
  - [x] 9.5 Ensure integration tests pass
    - Run ONLY the 3 tests written in 9.1
    - Verify all components work together

**Acceptance Criteria:**
- The 3 tests written in 9.1 pass
- All map features work together cohesively
- State management is clean and predictable
- Tour data flows correctly from backend

---

### Test Review and Gap Analysis

#### Task Group 10: Test Review and Gap Analysis
**Dependencies:** Task Groups 1-9
**Complexity:** Small (S)

- [x] 10.0 Review existing tests and fill critical gaps only
  - [x] 10.1 Review tests from Task Groups 1-9
    - Review the 4 tests from Task 1.1 (map widget)
    - Review the 4 tests from Task 2.1 (markers)
    - Review the 3 tests from Task 3.1 (polyline)
    - Review the 4 tests from Task 4.1 (bottom sheet)
    - Review the 4 tests from Task 5.1 (user location)
    - Review the 3 tests from Task 6.1 (bounds)
    - Review the 5 tests from Task 7.1 (directions)
    - Review the 4 tests from Task 8.1 (geocoding)
    - Review the 3 tests from Task 9.1 (integration)
    - Total existing tests: 34 tests
  - [x] 10.2 Analyze test coverage gaps for THIS feature only
    - Identify critical user workflows lacking coverage
    - Focus ONLY on gaps related to Mapbox integration requirements
    - Prioritize end-to-end workflows over unit test gaps
    - Do NOT assess entire application test coverage
  - [x] 10.3 Write up to 8 additional strategic tests if needed
    - Focus on critical integration points not covered:
      - Full tour load to map display flow
      - Marker selection to bottom sheet to navigation flow
      - Location permission to centering flow
      - Address search to tour generation submission flow
    - Do NOT write comprehensive coverage for all scenarios
    - Skip edge cases unless business-critical
  - [x] 10.4 Run feature-specific tests only
    - Run ONLY tests related to Mapbox integration (34 + up to 8 = max 42 tests)
    - Do NOT run entire application test suite
    - Verify critical user workflows pass

**Acceptance Criteria:**
- All feature-specific tests pass (approximately 34-42 tests total)
- Critical user workflows for map functionality are covered
- No more than 8 additional tests added
- Testing focused exclusively on Mapbox integration requirements

---

## Execution Order

Recommended implementation sequence based on dependencies:

```
Phase 1 - Foundation (can run in parallel):
  [Task Group 1: Map SDK Setup] -----> [Task Group 2: Markers]
                                   |
  [Task Group 8: Geocoding] ------+---> [Task Group 3: Polyline]

Phase 2 - Features (sequential dependencies):
  [Task Group 2] + [Award Badges] -----> [Task Group 4: Bottom Sheet]
  [Task Group 1] -----> [Task Group 5: User Location] -----> [Task Group 6: Bounds]
  [Task Group 3] -----> [Task Group 7: Directions]

Phase 3 - Integration:
  [All Task Groups 1-8] -----> [Task Group 9: Full Integration]

Phase 4 - Testing:
  [Task Group 9] -----> [Task Group 10: Test Review]
```

### Suggested Parallel Execution:

**Sprint 1:**
- Task Group 1: Map SDK Setup (M)
- Task Group 8: Geocoding (M) - no dependencies, can run parallel

**Sprint 2:**
- Task Group 2: Markers (M)
- Task Group 3: Polyline (M)
- Task Group 5: User Location (M)

**Sprint 3:**
- Task Group 4: Bottom Sheet (M) - needs markers + award badges
- Task Group 6: Auto-Fit Bounds (S)
- Task Group 7: Directions (L)

**Sprint 4:**
- Task Group 9: Full Integration (M)
- Task Group 10: Test Review (S)

---

## Technical Notes

### Environment Setup
- Ensure `MAPBOX_ACCESS_TOKEN` is configured in environment variables
- Mapbox rate limits: 100K direction requests/month, 50K map loads/month (per tech stack)

### Dependencies on Other Specs
- **Award Badge Display (2026-01-25-award-badges):** Reuse `AwardBadge` component for bottom sheet
- **Tour Generation Engine (2026-01-25-tour-generation-engine):** Consume tour data and route polylines

### Key Flutter Packages
- `mapbox_maps_flutter` - Official Mapbox Maps Flutter SDK
- Browser Geolocation API for user location (no additional package needed for web)

### Responsive Breakpoints (per tech stack)
- Mobile (default): < 600px
- Tablet: 600px - 1024px
- Desktop: > 1024px

### Accessibility Requirements
- Minimum 44x44px tap targets
- Keyboard navigation for interactive elements
- Screen reader support for map controls
- Visible focus indicators
