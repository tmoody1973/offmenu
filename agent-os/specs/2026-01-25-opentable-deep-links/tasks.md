# Task Breakdown: OpenTable Deep Links

## Overview

**Total Tasks:** 32 tasks across 5 task groups
**Estimated Total Effort:** Medium (combines XS spec with foundational patterns)
**Tech Stack:** Flutter Web 3.x + Serverpod 2.x + PostgreSQL

This feature establishes foundational patterns for external service deep links, analytics tracking, and action button components that will be reused across the application.

---

## Task List

### Data Layer

#### Task Group 1: Restaurant Model Extension & Analytics Table
**Dependencies:** None
**Complexity:** S (Small)

- [x] 1.0 Complete data layer for OpenTable integration
  - [x] 1.1 Write 4-6 focused tests for data models
    - Test Restaurant model with OpenTable fields (opentableId, opentableSlug)
    - Test Restaurant model with fallback contact fields (phone, websiteUrl)
    - Test ReservationClickEvent model creation and validation
    - Test nullable field handling for optional OpenTable data
  - [x] 1.2 Extend Restaurant model with OpenTable fields
    - Add `opentableId` (String, nullable) - exact OpenTable restaurant ID
    - Add `opentableSlug` (String, nullable) - URL slug for web links
    - Add `phone` (String, nullable) - fallback phone contact
    - Add `websiteUrl` (String, nullable) - fallback website URL
    - Include standard timestamps (createdAt, updatedAt)
  - [x] 1.3 Create migration for Restaurant table extension
    - Add columns: opentable_id, opentable_slug, phone, website_url
    - Add index on opentable_id for efficient lookup queries
    - Ensure migration is reversible
  - [x] 1.4 Create ReservationClickEvent model for analytics
    - Fields: id, restaurantId (FK), linkType (enum), userId (nullable FK), launchSuccess (bool), timestamp
    - linkType enum values: opentable_app, opentable_web, opentable_search, phone, website
  - [x] 1.5 Create migration for reservation_click_events table
    - Add foreign key to restaurants table
    - Add nullable foreign key to users table
    - Add index on restaurantId for analytics queries
    - Add index on timestamp for time-based queries
  - [x] 1.6 Ensure data layer tests pass
    - Run ONLY the 4-6 tests written in 1.1
    - Verify migrations run successfully with `serverpod generate`

**Acceptance Criteria:**
- Restaurant model includes all OpenTable and fallback fields
- ReservationClickEvent model captures all required analytics data
- Migrations run successfully and are reversible
- Index on opentable_id enables efficient lookups
- All 4-6 tests pass

---

### Service Layer

#### Task Group 2: Deep Link URL Builder Service
**Dependencies:** Task Group 1
**Complexity:** M (Medium)

- [x] 2.0 Complete deep link URL generation service
  - [x] 2.1 Write 6-8 focused tests for URL builder
    - Test OpenTable app scheme URL generation with restaurantId
    - Test OpenTable web URL generation with slug
    - Test search-based fallback URL with name + location encoding
    - Test datetime rounding to nearest 15-minute increment
    - Test party size parameter handling (default to 2)
    - Test URL encoding of special characters in restaurant names
  - [x] 2.2 Create OpenTableUrlBuilder utility class
    - Method: `buildAppSchemeUrl(restaurantId, partySize, dateTime)` -> `opentable://restaurant/{id}?covers={n}&dateTime={iso}`
    - Method: `buildWebUrl(slug, partySize, dateTime)` -> `https://www.opentable.com/r/{slug}?covers={n}&dateTime={iso}`
    - Method: `buildSearchUrl(name, location, partySize, dateTime)` -> `https://www.opentable.com/s?term={encoded}&geo={encoded}&...`
  - [x] 2.3 Create DateTimeRounder utility
    - Method: `roundToNearest15Minutes(DateTime)` -> DateTime
    - Round down for 0-7 minutes, round up for 8-14 minutes
    - Handle edge cases (crossing hour boundaries)
  - [x] 2.4 Create ReservationLinkService
    - Method: `getPreferredUrl(Restaurant, partySize, dateTime)` -> returns best available URL type
    - Priority: app scheme (if opentableId) > web URL (if slug) > search URL (if name/location)
    - Method: `hasOpenTableSupport(Restaurant)` -> bool
    - Method: `hasFallbackContact(Restaurant)` -> bool (phone or website available)
  - [x] 2.5 Implement URL encoding utility
    - Properly encode restaurant names with special characters (apostrophes, ampersands, etc.)
    - Encode location strings for geo parameter
  - [x] 2.6 Ensure URL builder tests pass
    - Run ONLY the 6-8 tests written in 2.1
    - Verify all URL formats match OpenTable's documented structure

**Acceptance Criteria:**
- All three URL formats generate correctly
- DateTime rounds to nearest 15 minutes accurately
- Special characters are properly URL-encoded
- Service correctly determines URL priority based on available data
- All 6-8 tests pass

---

#### Task Group 3: URL Launcher & Analytics Backend
**Dependencies:** Task Group 2
**Complexity:** M (Medium)

- [x] 3.0 Complete URL launching and analytics tracking
  - [x] 3.1 Write 5-7 focused tests for launcher and analytics
    - Test app scheme launch attempt with fallback to web
    - Test canLaunchUrl check behavior
    - Test analytics event creation on link click
    - Test phone link (tel: scheme) generation
    - Test website link launch
  - [x] 3.2 Create ReservationLauncher service (Flutter client)
    - Method: `launchReservation(Restaurant, partySize, dateTime)` -> LaunchResult
    - Attempt `opentable://` app scheme first with `LaunchMode.externalApplication`
    - Fall back to HTTPS web URL if app scheme fails
    - Return LaunchResult with linkType used and success status
  - [x] 3.3 Implement app scheme fallback logic
    - Use `canLaunchUrl` to check app scheme support before attempting
    - If canLaunchUrl returns false, skip directly to web URL
    - If launchUrl fails, catch error and attempt web fallback
    - Log fallback events for debugging
  - [x] 3.4 Create fallback contact launchers
    - Method: `launchPhone(phoneNumber)` -> uses `tel:{number}` scheme
    - Method: `launchWebsite(url)` -> uses `LaunchMode.platformDefault`
    - Handle launch failures with user-friendly error messages
  - [x] 3.5 Create ReservationClickEndpoint on Serverpod backend
    - POST endpoint: `/api/analytics/reservation-click`
    - Accept: restaurantId, linkType, userId (optional), launchSuccess, timestamp
    - Validate linkType against allowed enum values
    - Return 201 on success, appropriate error codes on failure
  - [x] 3.6 Integrate analytics tracking in launcher
    - Call analytics endpoint after each launch attempt
    - Include linkType actually used (not just attempted)
    - Track success/failure of launch for fallback analysis
    - Handle analytics failures gracefully (don't block user flow)
  - [x] 3.7 Ensure launcher and analytics tests pass
    - Run ONLY the 5-7 tests written in 3.1
    - Mock url_launcher calls in tests

**Acceptance Criteria:**
- App scheme fallback works correctly when OpenTable app not installed
- Analytics events are recorded for all link types
- Phone and website launchers work with appropriate schemes
- Analytics endpoint validates and stores click events
- User sees graceful error message if all launch attempts fail
- All 5-7 tests pass

---

### UI Layer

#### Task Group 4: Reserve & Fallback Button Components
**Dependencies:** Task Group 3
**Complexity:** M (Medium)

- [x] 4.0 Complete reservation button UI components
  - [x] 4.1 Write 4-6 focused tests for button components
    - Test ReserveButton renders when OpenTable data available
    - Test ReserveButton hidden when no OpenTable data
    - Test PhoneButton and WebsiteButton render with fallback data
    - Test button tap triggers launcher service
    - Test compact variant renders correctly for tour stop cards
  - [x] 4.2 Create ReserveButton widget
    - Props: restaurant, partySize, scheduledTime (optional), variant (standard/compact)
    - Standard variant: Full button with "Reserve" text and icon
    - Compact variant: Icon-only button for tour stop cards
    - Styling: OpenTable brand color (#DA3743) or app action button style
    - Minimum tap target: 44x44px
    - Icon: fork/knife or calendar icon
  - [x] 4.3 Create PhoneButton widget
    - Props: phoneNumber, variant (standard/compact)
    - Secondary/outline style to differentiate from primary Reserve button
    - Phone icon
    - Minimum tap target: 44x44px
  - [x] 4.4 Create WebsiteButton widget
    - Props: websiteUrl, variant (standard/compact)
    - Secondary/outline style matching PhoneButton
    - Globe/link icon
    - Minimum tap target: 44x44px
  - [x] 4.5 Create ReservationActions composite widget
    - Combines Reserve, Phone, and Website buttons based on availability
    - Shows ReserveButton when `hasOpenTableSupport(restaurant)` is true
    - Shows Phone/Website buttons when OpenTable not available but contact info exists
    - Handles layout for both detail view (horizontal) and stop card (compact)
  - [x] 4.6 Implement loading and error states
    - Show loading indicator while launch is in progress
    - Display snackbar or toast on launch failure with friendly message
    - Disable button briefly after tap to prevent double-clicks
  - [x] 4.7 Ensure button component tests pass
    - Run ONLY the 4-6 tests written in 4.1
    - Verify rendering and interaction behavior

**Acceptance Criteria:**
- ReserveButton displays prominently with high-contrast styling
- Fallback buttons (Phone, Website) are visually distinct as secondary actions
- All buttons meet 44x44px minimum tap target
- Conditional rendering based on available restaurant data works correctly
- Components are reusable with clear props interface
- All 4-6 tests pass

---

### Integration Layer

#### Task Group 5: Integration & Test Review
**Dependencies:** Task Groups 1-4
**Complexity:** S (Small)

- [ ] 5.0 Complete integration and test coverage review
  - [ ] 5.1 Integrate ReservationActions into RestaurantDetailView
    - Place Reserve button prominently in restaurant detail view
    - Position below restaurant info, above reviews/additional content
    - Pass tour stop scheduled time if viewing from tour context
  - [ ] 5.2 Integrate compact ReservationActions into TourStopCard
    - Add compact Reserve button to tour overview stop cards
    - Position in card footer or action area
    - Ensure button doesn't clutter compact card layout
  - [x] 5.3 Review tests from Task Groups 1-4
    - Review 4-6 tests from data layer (Task 1.1)
    - Review 6-8 tests from URL builder (Task 2.1)
    - Review 5-7 tests from launcher/analytics (Task 3.1)
    - Review 4-6 tests from UI components (Task 4.1)
    - Total existing tests: approximately 19-27 tests
  - [ ] 5.4 Analyze test coverage gaps for this feature
    - Identify critical user workflows lacking test coverage
    - Focus on end-to-end reservation flow
    - Prioritize integration points between services
  - [ ] 5.5 Write up to 8 additional tests to fill critical gaps
    - End-to-end: User taps Reserve, analytics recorded, OpenTable opens
    - End-to-end: User taps Reserve, app fallback to web URL works
    - End-to-end: Phone button launches tel: scheme correctly
    - Integration: ReservationActions correctly determines which buttons to show
    - Integration: Analytics endpoint stores events correctly
    - Skip exhaustive edge case testing
  - [ ] 5.6 Run all feature-specific tests
    - Run ONLY tests related to OpenTable deep links feature
    - Expected total: approximately 27-35 tests maximum
    - Verify all critical workflows pass
  - [ ] 5.7 Manual integration verification
    - Test Reserve button on actual restaurant detail view
    - Test compact button on tour stop card
    - Verify analytics events appear in database
    - Test on mobile browser to verify touch targets

**Acceptance Criteria:**
- ReservationActions integrated into both detail view and stop cards
- All feature-specific tests pass (approximately 27-35 tests total)
- Critical user workflows for reservation flow are covered
- No more than 8 additional tests added for gap coverage
- Manual verification confirms end-to-end functionality

---

## Execution Order

**Recommended implementation sequence:**

```
1. Data Layer (Task Group 1)
   - Establishes data models and migrations
   - No dependencies, can start immediately

2. URL Builder Service (Task Group 2)
   - Depends on Restaurant model from Group 1
   - Pure utility functions, highly testable

3. URL Launcher & Analytics (Task Group 3)
   - Depends on URL builder from Group 2
   - Depends on analytics model from Group 1
   - Integrates Flutter url_launcher package

4. UI Components (Task Group 4)
   - Depends on launcher service from Group 3
   - Creates reusable button components

5. Integration & Testing (Task Group 5)
   - Depends on all previous groups
   - Wires components into actual views
   - Final test coverage review
```

---

## Complexity Summary

| Task Group | Complexity | Est. Effort | Key Risk Areas |
|------------|------------|-------------|----------------|
| 1. Data Layer | S | 2-3 hours | None - straightforward model extension |
| 2. URL Builder | M | 3-4 hours | URL encoding edge cases, datetime rounding |
| 3. Launcher/Analytics | M | 4-5 hours | App scheme fallback logic, cross-platform url_launcher behavior |
| 4. UI Components | M | 4-5 hours | Responsive layout, touch targets on mobile web |
| 5. Integration | S | 2-3 hours | Wiring into views that may not exist yet |

**Total Estimated Effort:** 15-20 hours

---

## Technical Notes

### Serverpod Model Definition Pattern
```yaml
# lib/src/protocol/restaurant.yaml (extend existing)
class: Restaurant
fields:
  # ... existing fields ...
  opentableId: String?
  opentableSlug: String?
  phone: String?
  websiteUrl: String?
```

### url_launcher Package Setup
```yaml
# pubspec.yaml
dependencies:
  url_launcher: ^6.2.0
```

### Key URL Formats
- App Scheme: `opentable://restaurant/{restaurantId}?covers={n}&dateTime={iso8601}`
- Web URL: `https://www.opentable.com/r/{slug}?covers={n}&dateTime={iso8601}`
- Search URL: `https://www.opentable.com/s?term={name}&geo={location}&covers={n}&dateTime={iso8601}`

### Analytics Link Types (Enum)
- `opentable_app` - App scheme launched successfully
- `opentable_web` - Web URL used (fallback or direct)
- `opentable_search` - Search-based URL used
- `phone` - Phone number link clicked
- `website` - Website link clicked
