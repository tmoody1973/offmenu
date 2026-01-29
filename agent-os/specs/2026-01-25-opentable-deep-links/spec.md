# Specification: OpenTable Deep Links

## Goal

Enable Food Tour Butler users to seamlessly book restaurant reservations by launching OpenTable with pre-filled restaurant and party details via deep links, with fallback contact options for non-OpenTable restaurants.

## User Stories

- As a food tour user, I want to tap a "Reserve" button to open OpenTable with my desired restaurant and time pre-filled so that I can quickly complete my booking without re-entering details
- As a user viewing a non-OpenTable restaurant, I want separate Phone and Website buttons so that I can easily contact the restaurant to make a manual reservation

## Specific Requirements

**Deep Link URL Generation**
- Generate OpenTable web URLs in format: `https://www.opentable.com/r/{restaurant-slug}?covers={partySize}&dateTime={ISO8601}`
- Generate OpenTable app scheme URLs in format: `opentable://restaurant/{restaurantId}?covers={partySize}&dateTime={ISO8601}`
- For restaurants without OpenTable ID, construct search-based URLs: `https://www.opentable.com/s?term={encodedName}&geo={encodedLocation}&covers={partySize}&dateTime={ISO8601}`
- URL-encode all dynamic parameters (restaurant name, location) to handle special characters

**App Scheme Fallback Strategy**
- Attempt `opentable://` app scheme first using `url_launcher` package's `launchUrl` with `LaunchMode.externalApplication`
- If app scheme fails (app not installed), automatically fall back to HTTPS web URL
- Use `canLaunchUrl` check before attempting app scheme to determine fallback strategy
- Log which link type was ultimately used for analytics purposes

**Restaurant Data Model Extension**
- Add nullable `opentableId` field (String) to restaurant model for exact OpenTable matching
- Add nullable `opentableSlug` field (String) for constructing web URLs
- Include `phone` (String, nullable) and `websiteUrl` (String, nullable) fields for fallback contact options
- Index `opentableId` field for efficient lookup queries

**Reservation Time Pre-filling**
- Extract scheduled time from tour stop data when available
- Round time to nearest 15-minute increment (e.g., 6:07 PM becomes 6:00 PM, 6:08 PM becomes 6:15 PM)
- Default to current time rounded to next 15-minute slot if no tour stop time available
- Format datetime as ISO 8601 string for URL parameter compatibility

**Party Size Handling**
- Default party size to 2 (most common reservation size)
- Allow user to specify party size in tour settings if feature exists
- Pass party size as `covers` parameter in deep link URL

**Reserve Button UI Placement**
- Display "Reserve" button prominently on restaurant detail view
- Display compact "Reserve" button on tour overview stop cards
- Show "Reserve" button only when restaurant has `opentableId` OR `opentableSlug` OR valid name/location for search
- Use consistent button styling with OpenTable brand color (#DA3743) or app's action button style

**Non-OpenTable Fallback Buttons**
- Display separate "Phone" button when restaurant has phone number (uses `tel:` scheme)
- Display separate "Website" button when restaurant has website URL (uses standard HTTPS)
- Show fallback buttons only when OpenTable reservation is not available
- Style fallback buttons distinctly from primary Reserve button (secondary/outline style)

**Analytics Click Tracking**
- Log reservation link clicks to PostgreSQL analytics table
- Capture: restaurant_id, link_type (opentable_app, opentable_web, opentable_search, phone, website), user_id (nullable), timestamp
- Track success/failure of app scheme launch for fallback analysis
- Create analytics endpoint on Serverpod backend to receive click events

**URL Launcher Integration**
- Use Flutter `url_launcher` package for all external URL launching
- Configure appropriate launch modes: `LaunchMode.externalApplication` for app schemes, `LaunchMode.platformDefault` for web
- Handle launch failures gracefully with user-friendly error message
- Test URL validity before launch attempt using `canLaunchUrl`

## Visual Design

No visual assets provided. Follow these design guidelines:

- Reserve button should be prominent with high-contrast styling
- Use recognizable icons: fork/knife or calendar icon for Reserve, phone icon for Phone, globe/link icon for Website
- Buttons should be touch-friendly with minimum 44x44px tap target
- On tour stop cards, use icon-only or compact button to save space

## Existing Code to Leverage

**New Project - Establishing Patterns**
- This feature establishes the pattern for external service deep links
- Future integrations (Resy, Yelp) should follow the same URL generation and fallback approach
- Analytics tracking pattern will be reused for other click tracking needs
- Button component patterns will be reused across the application

**Flutter url_launcher Package**
- Standard Flutter package for launching external URLs
- Supports both app schemes and web URLs with appropriate launch modes
- Provides `canLaunchUrl` for checking URL support before launch
- Well-documented with established usage patterns in Flutter ecosystem

## Out of Scope

- OpenTable Partner API integration (requires approval process, planned for Phase 2)
- In-app availability checking or real-time table availability display
- Direct in-app reservation booking and confirmation
- Reservation management (viewing, modifying, canceling bookings)
- Resy or other reservation platform integration
- Advanced analytics dashboard or reporting UI
- Push notifications for reservation reminders
- Calendar integration for adding reservations
- Restaurant search or discovery features (this spec is for booking only)
- OpenTable Experiences booking (special dining events)
