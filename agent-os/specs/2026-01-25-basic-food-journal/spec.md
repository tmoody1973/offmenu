# Specification: Basic Food Journal

## Goal

Enable users to capture and organize their culinary experiences by creating journal entries with photos, notes, ratings, and timestamps, linked to restaurants and optionally to food tours.

## User Stories

- As a food enthusiast, I want to log my restaurant visits with photos and notes so that I can remember my culinary experiences.
- As a tour participant, I want to create journal entries directly from tour stops so that my dining history is automatically linked to the tours I complete.

## Specific Requirements

**Journal Entry Creation from Tour Context**
- Add "Log Visit" button on tour detail screen for each completed stop
- Pre-populate restaurant association from the tour stop data
- Pre-populate tour association automatically when creating from tour context
- Navigate to journal entry form with pre-filled context
- Return user to tour detail screen after successful submission

**Standalone Journal Entry Creation**
- Provide entry point from main navigation or restaurant detail page
- Require user to search and select a restaurant for association
- Use Foursquare Places API for restaurant search if restaurant not already in local database
- No tour association for standalone entries

**Rating Input Component**
- Implement 1-5 star rating using touch-friendly tappable stars
- Minimum tap target size of 44x44px per star for mobile accessibility
- Visual feedback on selection with filled vs outlined star states
- Rating is required before submission

**Notes Field**
- Plain text textarea with no character limit
- Mobile-optimized keyboard with appropriate input type
- Auto-expanding height as content grows
- Notes are optional

**Timestamp Capture**
- Auto-capture current timestamp on form load
- Provide timestamp picker to override default value
- Display in user's local timezone
- Store as UTC in database

**Photo Capture and Upload**
- Support up to 3 photos per entry for MVP
- Enable camera capture via device camera API
- Enable gallery selection from device photo library
- Compress images client-side to approximately 1MB before upload
- Upload to Cloudflare R2 with secure URL generation
- Generate thumbnail variants server-side for efficient list loading
- Display upload progress indicator during photo submission

**Cloudflare R2 Integration**
- Create dedicated bucket for journal photos
- Organize storage by user ID and entry ID path structure
- Generate signed URLs for secure image access
- Store original and thumbnail URLs in database
- Implement server-side thumbnail generation at 200x200px

**Chronological Timeline View**
- Display all user's journal entries in reverse chronological order
- Show entry cards with thumbnail, restaurant name, rating, date, and notes preview
- Implement pagination with infinite scroll or load-more pattern
- Support filtering by date range via date picker
- Support sorting options (newest first, oldest first, highest rated)

**Restaurant-Grouped View**
- List all restaurants user has visited with visit count
- Tap restaurant to see all journal entries for that location
- Display restaurant entries in chronological order within detail view
- Show aggregate stats per restaurant (visit count, average rating)

**Tour-Linked Entry Display**
- Show journal entries within tour detail page under each stop
- Display tour badge or indicator on entries that have tour association
- Enable navigation from entry to associated tour detail

## Visual Design

No visual assets were provided for this specification. The following design guidelines apply:

- Mobile-first layout optimized for screens under 600px width
- Touch-friendly controls with minimum 44x44px tap targets
- Card-based entry display in timeline and list views
- Photo thumbnails displayed at consistent aspect ratio
- Star rating displayed inline with restaurant name on entry cards

## Existing Code to Leverage

**No Existing Codebase**
- This is a greenfield project with no existing Flutter or Serverpod code
- Follow patterns established in Tour Generation Engine spec for API design
- Use Serverpod ORM conventions for model definitions
- Apply consistent RESTful API patterns per project standards

**Static Award Datasets (Reference)**
- James Beard data from GitHub: cjwinchester/james-beard
- Michelin data from Kaggle dataset
- Restaurant entries may reference awarded establishments; coordinate with Award Badge Display spec

## Out of Scope

- Offline draft persistence and sync (requires internet for MVP)
- Rich text formatting in notes (bold, lists, etc.)
- More than 3 photos per entry (expanded to 10 in Phase 2)
- Individual dish logging within entries (Phase 3, roadmap item 17)
- Public or shared journal entries (Phase 3, roadmap item 20)
- Map view of journal entries (Phase 3, roadmap item 19)
- Expense or spend amount tracking (Phase 4, roadmap item 30)
- "Would Return" indicator field
- Tags system (date night, business, family)
- Journal search functionality
- Export or sharing features
