# Spec Requirements: OpenTable Deep Links

## Initial Description

OpenTable Deep Links - Redirect users to OpenTable for reservations via deep links, with fallback phone/website links for non-OpenTable restaurants. (MVP Phase 1, Item #5, XS effort)

This feature enables users to make reservations at restaurants discovered through Food Tour Butler by launching OpenTable with pre-filled restaurant and party details, providing a seamless booking experience without requiring full OpenTable Partner API integration.

## Requirements Discussion

### First Round Questions

**Q1:** What deep link format should we support - standard OpenTable web URLs, the `opentable://` app scheme, or both?
**Answer:** Support BOTH web URLs and `opentable://` app scheme fallback.

**Q2:** How should we handle restaurant ID mapping - should we store OpenTable restaurant IDs in our database, or construct search-based deep links using restaurant name and location?
**Answer:** Use best practices. Recommendation accepted: Add OpenTable ID field for exact matching when available, fall back to search query for restaurants without ID.

**Q3:** Where in the UI should the reservation action be placed - restaurant detail view only, or also on tour stop cards?
**Answer:** Use UX best practices. Recommendation accepted: Show "Reserve" button on BOTH restaurant detail view AND tour overview stop cards for easy access.

**Q4:** Should we pre-fill the reservation time based on the tour's scheduled timing for that stop?
**Answer:** Round to nearest 15/30 minutes for typical reservation slots.

**Q5:** For non-OpenTable restaurants, should we show separate Phone and Website buttons, or a single "Contact" button with options?
**Answer:** Yes, show separate Phone and Website buttons.

**Q6:** Should we track when users tap reservation links for analytics purposes?
**Answer:** Yes, track reservation clicks for analytics.

**Q7:** Is there anything that should be explicitly out of scope for this feature?
**Answer:** Nothing explicitly excluded for MVP.

### Existing Code to Reference

No similar existing features identified for reference (new project).

### Follow-up Questions

No follow-up questions were needed.

## Visual Assets

### Files Provided:
No visual assets provided.

### Visual Insights:
Not applicable - no visuals provided.

## Requirements Summary

### Functional Requirements

- Generate OpenTable deep links that launch the OpenTable app or website with pre-filled restaurant details
- Support both `opentable://` app scheme (primary) and web URL (fallback) formats
- Store OpenTable restaurant ID field in restaurant data model for exact matching
- Fall back to search-based deep links using restaurant name + location when ID is unavailable
- Pre-fill reservation time based on tour stop timing, rounded to nearest 15 or 30 minutes
- Pre-fill party size (default to 2, or user-specified if available)
- Display "Reserve" button on restaurant detail view
- Display "Reserve" button on tour overview stop cards
- For non-OpenTable restaurants, display separate "Phone" and "Website" buttons
- Track all reservation link clicks for analytics (restaurant ID, link type, timestamp)

### Reusability Opportunities

- None identified (new project with no existing codebase)
- This feature will establish patterns for future external service deep links (Resy, Yelp, etc.)

### Scope Boundaries

**In Scope:**
- OpenTable deep link generation (app scheme + web URL)
- Restaurant ID storage and lookup
- Search-based fallback link construction
- Time pre-filling with 15/30 minute rounding
- Party size pre-filling
- Reserve button on detail view and stop cards
- Separate Phone and Website fallback buttons
- Click tracking for analytics
- Basic link validation

**Out of Scope:**
- OpenTable Partner API integration (requires approval, planned for Phase 2)
- In-app availability checking
- Direct reservation booking
- Reservation confirmation handling
- Resy integration (future consideration)
- Deep analytics dashboard (basic tracking only for MVP)

### Technical Considerations

- **Platform:** Flutter Web (mobile-first) with Serverpod backend
- **Deep Link Handling:** Use `url_launcher` package for launching external URLs
- **App Detection:** Attempt `opentable://` scheme first, fall back to web URL on failure
- **Data Model:** Add `opentableId` nullable field to restaurant model
- **Time Rounding:** Implement utility function to round DateTime to nearest 15/30 minutes
- **Analytics:** Log clicks to PostgreSQL with restaurant_id, link_type, user_id (if authenticated), timestamp
- **URL Construction:** Build deep links per OpenTable's documented format with query parameters for covers, datetime, restaurant ID or search terms
- **Fallback Links:** Use `tel:` scheme for phone, standard HTTPS for website
- **Button Placement:** Integrate with existing restaurant card and detail view components (to be created)
