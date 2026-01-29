# Spec Requirements: Award Badge Display

## Initial Description

Show James Beard (Winner/Nominee/Semifinalist) and Michelin (1-3 stars, Bib Gourmand) badges on restaurant cards with scoring algorithm integration. This is item #3 on the Phase 1: MVP Core roadmap, sized as Small (2-3 days).

## Requirements Discussion

### First Round Questions

**Q1:** Badge visuals - Should we use compact icon badges with award logos (e.g., Michelin star icon, James Beard medal), or text-based labels, or both?
**Answer:** Use best UX practices. Recommendation accepted: compact icon badges with award logos, color-coded - gold/red for Michelin, blue for James Beard.

**Q2:** For Michelin awards, which designations should we include - just stars (1-3), or also Bib Gourmand, Michelin Plate, and/or Green Star?
**Answer:** 1-star, 2-star, 3-star, and Bib Gourmand. No Plate or Green Star.

**Q3:** For James Beard categories, should we include all categories (Winner, Nominee, Semifinalist, Best Chef regional awards, Outstanding Restaurant, Rising Star, Outstanding Pastry, etc.), or focus on specific ones? How many years of history should we track (e.g., just current year, past 5 years, all time)?
**Answer:** ALL categories - Winner, Nominee, Semifinalist, Best Chef regional awards, Outstanding Restaurant, Rising Star, Outstanding Pastry, etc. History: 2018-2025 (8 years).

**Q4:** For data matching between award datasets and Foursquare restaurant data, what approach should we use - exact name matching, fuzzy matching with manual review, or coordinate-based proximity matching?
**Answer:** Use best practice approach. Recommendation accepted: name + city fuzzy matching, with address/coordinates as secondary validation for ambiguous cases.

**Q5:** How should award data be updated? Developer-managed static files with occasional updates, or admin tooling for non-developers to import updates?
**Answer:** Need admin tooling for importing updates (not just developer scripts).

**Q6:** In which display contexts should badges appear - restaurant cards only, or also on detail pages, map popups, and/or tour summary screens?
**Answer:** ALL - restaurant cards, detail pages, map popups, AND tour summary screen.

**Q7:** Is there anything that should explicitly be OUT of scope for this spec?
**Answer:** User-submitted awards.

### Existing Code to Reference

No similar existing features identified for reference. This is a new project.

### Follow-up Questions

None required - user provided comprehensive answers.

## Visual Assets

### Files Provided:
No visual assets provided.

### Visual Insights:
N/A - no visual files found in `/Users/tarikmoody/Documents/Projects/food-butler/agent-os/specs/2026-01-25-award-badges/planning/visuals/`

## Requirements Summary

### Functional Requirements

**Award Data Sources:**
- James Beard awards from static dataset (GitHub: cjwinchester/james-beard)
- Michelin Guide data from static dataset (Kaggle michelin-guide dataset)
- Both datasets require periodic updates via admin tooling

**Michelin Awards to Display:**
- 1-Star (gold/red color scheme)
- 2-Star (gold/red color scheme)
- 3-Star (gold/red color scheme)
- Bib Gourmand (gold/red color scheme)

**James Beard Awards to Display:**
- Winner (blue color scheme)
- Nominee (blue color scheme)
- Semifinalist (blue color scheme)
- Best Chef regional awards (blue color scheme)
- Outstanding Restaurant (blue color scheme)
- Rising Star (blue color scheme)
- Outstanding Pastry (blue color scheme)
- All other James Beard categories
- Historical data: 2018-2025 (8 years)

**Badge Display Contexts:**
- Restaurant cards (in tour listings, search results)
- Restaurant detail pages
- Map popups (when tapping restaurant pins)
- Tour summary screen

**Badge Visual Design:**
- Compact icon badges with award logos
- Color-coded: gold/red for Michelin, blue for James Beard
- Multiple badges should stack/display cleanly for restaurants with multiple awards

**Data Matching Algorithm:**
- Primary: Fuzzy matching on restaurant name + city
- Secondary: Address and/or coordinate validation for ambiguous matches
- Handle edge cases like restaurant name changes, relocations

**Admin Tooling:**
- Admin interface for importing updated award data
- Support for annual Michelin Guide releases
- Support for annual James Beard award announcements
- Non-developer friendly (not just CLI scripts)

**Scoring Algorithm Integration:**
- Award status should boost restaurant scoring in tour generation
- Higher-tier awards (e.g., 3-star vs 1-star) should have proportionally higher weight
- James Beard winners should score higher than nominees/semifinalists

### Reusability Opportunities

This is a new project with no existing code to reference. However, the following patterns should be established as reusable:
- Badge component (reusable across all display contexts)
- Award data service (centralized award lookup)
- Fuzzy matching utility (potentially reusable for other data matching needs)

### Scope Boundaries

**In Scope:**
- Badge UI components for all four display contexts
- Michelin data import and storage (1-3 stars, Bib Gourmand)
- James Beard data import and storage (all categories, 2018-2025)
- Fuzzy matching algorithm for restaurant-award linking
- Admin interface for data import/updates
- Scoring algorithm integration for tour generation
- Database schema for award data

**Out of Scope:**
- User-submitted awards
- Michelin Plate designation
- Michelin Green Star designation
- James Beard data prior to 2018
- Real-time API integration with James Beard or Michelin (static datasets only)
- Award verification/dispute handling
- Social features around awards (e.g., "collecting" awards)

### Technical Considerations

**Data Sources:**
- James Beard: GitHub repository cjwinchester/james-beard (static dataset)
- Michelin: Kaggle michelin-guide dataset (static dataset)
- Both require parsing/transformation for database import

**Database Requirements:**
- Award tables with proper indexing for fast lookups
- Restaurant-award junction table for many-to-many relationships
- Timestamps for tracking when awards were imported/updated
- Support for historical award data (year-based)

**Matching Complexity:**
- Fuzzy string matching library needed (consider Dart packages)
- May need manual review queue for low-confidence matches
- Coordinate-based validation using existing Mapbox/Foursquare data

**Display Contexts Integration:**
- Restaurant cards: Compact badge row, limited space
- Detail pages: Can show full award history with years
- Map popups: Very compact, possibly just icons
- Tour summary: Aggregate award information for the tour

**Tech Stack Alignment:**
- Frontend: Flutter Web 3.x with mobile-first responsive design
- Backend: Serverpod 2.x with PostgreSQL
- Follow component standards: single responsibility, reusability, composability
- Follow API standards: RESTful design, proper HTTP status codes
- Follow model standards: timestamps, data integrity constraints, indexed foreign keys
