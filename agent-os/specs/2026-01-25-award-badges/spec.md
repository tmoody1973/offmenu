# Specification: Award Badges

## Goal
Integrate James Beard and Michelin award data into the Food Tour Butler app, displaying award badges across all restaurant contexts and providing admin tooling for non-developers to import annual award updates.

## User Stories
- As a food enthusiast, I want to see James Beard and Michelin badges on restaurant cards so that I can quickly identify award-winning establishments when planning food tours.
- As an admin, I want to import updated award data through a web interface so that I can keep the app current without developer assistance.

## Specific Requirements

**Michelin Award Data Model**
- Store Michelin designations: 1-Star, 2-Star, 3-Star, and Bib Gourmand (no Plate or Green Star)
- Include restaurant name, city, address, coordinates, and award year
- Use gold/red color scheme for all Michelin badge variants
- Support multiple years of awards per restaurant (track year awarded)
- Index on restaurant name + city for fast lookup during matching

**James Beard Award Data Model**
- Store all categories: Winner, Nominee, Semifinalist, Best Chef regional, Outstanding Restaurant, Rising Star, Outstanding Pastry, and all others
- Include chef/restaurant name, city, category, year, and distinction level
- Historical data range: 2018-2025 (8 years)
- Use blue color scheme for all James Beard badge variants
- Support multiple awards per restaurant across different years and categories

**Restaurant-Award Linking**
- Create many-to-many junction table between restaurants and awards
- Primary matching: fuzzy name + city comparison using string similarity algorithm
- Secondary validation: address and/or coordinate proximity for ambiguous matches
- Store match confidence score for potential manual review queue
- Handle edge cases: restaurant name changes, relocations, closed establishments

**Badge UI Component**
- Single reusable badge component with variants for Michelin and James Beard
- Compact icon-based design with award logos (Michelin star icon, James Beard medal)
- Support stacking multiple badges horizontally when restaurant has multiple awards
- Responsive sizing: smaller in map popups, standard on cards, expanded on detail pages
- Accessible with proper alt text and ARIA labels for screen readers

**Badge Display Integration**
- Restaurant cards: compact badge row below restaurant name, max 3 visible with "+N more" overflow
- Restaurant detail pages: full award history section with years and categories
- Map popups: icon-only badges due to space constraints
- Tour summary screen: aggregate award count for the tour ("3 Michelin-starred stops")

**Scoring Algorithm Integration**
- Award status boosts restaurant score in tour generation algorithm
- Tiered weighting: 3-star > 2-star > 1-star > Bib Gourmand for Michelin
- Tiered weighting: Winner > Nominee > Semifinalist for James Beard
- Recent awards (last 2 years) weighted higher than older awards
- Multiple awards compound the boost (but with diminishing returns)

**Admin Data Import Interface**
- Web-based admin panel accessible to authorized non-developer users
- CSV/JSON file upload for Michelin and James Beard datasets
- Preview imported data before committing to database
- Validation: check required fields, detect duplicates, flag parsing errors
- Dry-run mode to see which restaurants would be matched before saving

**Admin Matching Review**
- Display low-confidence matches for manual review and approval
- Allow admin to manually link/unlink awards from restaurants
- Search interface to find specific restaurants or awards
- Audit log tracking who imported data and when

## Visual Design

No visual mockups provided. Follow these design guidelines:

**Badge Appearance**
- Michelin badges: gold/red color palette, star icon for stars, fork/spoon icon for Bib Gourmand
- James Beard badges: blue color palette, medal/ribbon icon
- Rounded corners, subtle shadow for depth, consistent sizing across badge types
- High contrast for accessibility (WCAG AA minimum)

**Admin Panel**
- Clean table-based layout for data review
- Clear upload zone with drag-and-drop support
- Progress indicators during import processing
- Color-coded status indicators (green=matched, yellow=review, red=error)

## Existing Code to Leverage

**No existing codebase**
- This is a greenfield project with no existing Dart/Flutter code
- Establish reusable patterns: badge component, data service, fuzzy matching utility
- Follow Serverpod 2.x conventions for models, endpoints, and database migrations
- Follow Flutter Web 3.x patterns for responsive, mobile-first UI components

**External Data Sources**
- James Beard: GitHub repository cjwinchester/james-beard (static CSV/JSON dataset)
- Michelin: Kaggle michelin-guide dataset (static CSV dataset)
- Parse and transform these formats during admin import process

## Out of Scope
- User-submitted awards (only official James Beard and Michelin data)
- Michelin Plate designation
- Michelin Green Star designation
- James Beard data prior to 2018
- Real-time API integration with James Beard or Michelin organizations
- Award verification or dispute handling workflows
- Social features around awards (collecting, sharing, gamification)
- Automated data fetching or web scraping of award sources
- Push notifications for new award announcements
- Award filtering in tour generation (filter for "award-only" tours is future scope)
