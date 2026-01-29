# Spec Requirements: Basic Food Journal

## Initial Description

Basic Food Journal feature for the Food Tour Butler application - allowing users to log restaurant visits with ratings, notes, photos, and timestamps.

## Requirements Discussion

### First Round Questions

**Q1:** I assume entries should be created from the tour detail screen after visiting a stop. Should users also be able to create standalone entries unrelated to tours?
**Answer:** BOTH - create from tour detail screen after visiting a stop AND allow entries unrelated to tours (standalone entries)

**Q2:** For timestamps, should we auto-capture the current time when creating an entry, or include a timestamp picker to override?
**Answer:** Include timestamp picker to override auto-captured time

**Q3:** For photos, I'm thinking 3 photos per entry is sufficient for MVP. Is that acceptable, or do you need more?
**Answer:** 3 photos per entry is fine for MVP, compressed to ~1MB

**Q4:** Should photos support both camera capture and gallery selection, or gallery only for MVP?
**Answer:** Support both camera capture AND gallery selection

**Q5:** For notes, should we support plain text only, or include rich formatting (bold, lists, etc.)?
**Answer:** Plain text only, no character limit

**Q6:** Should entries be organized in any specific way - linked to restaurant, chronological timeline, or viewable by tour?
**Answer:** Yes to all - linked to restaurant + tour, chronological timeline view, AND viewable grouped by restaurant

**Q7:** Should journal entries be private by default, or include sharing options in MVP?
**Answer:** Private by default, sharing in Phase 3

**Q8:** For offline support, should users be able to create draft entries without internet and sync later?
**Answer:** Requires internet (no offline draft persistence for MVP)

### Existing Code to Reference

No similar existing features identified for reference. This is a new project.

### Follow-up Questions

None required - user provided comprehensive answers to all initial questions.

## Visual Assets

### Files Provided:

No visual assets provided.

### Visual Insights:

N/A - No visuals to analyze.

## Requirements Summary

### Functional Requirements

**Entry Creation:**
- Create journal entries from tour detail screen after visiting a stop (linked to tour + restaurant)
- Create standalone journal entries unrelated to tours (linked to restaurant only)
- Both flows should capture the same data fields

**Data Fields per Entry:**
- 1-5 star rating (required)
- Free-text notes (plain text, no character limit)
- Visited timestamp (auto-captured with manual override via timestamp picker)
- Up to 3 photos (compressed to ~1MB each)
- Restaurant association (required)
- Tour association (optional - only when created from tour context)

**Photo Handling:**
- Support camera capture for taking new photos
- Support gallery selection for existing photos
- Compress images to ~1MB before upload
- Store in Cloudflare R2 per tech stack specification
- Generate thumbnails for efficient loading

**Entry Organization and Views:**
- Chronological timeline view (all entries, newest first)
- Grouped by restaurant view (see all visits to a specific restaurant)
- Entries linked to tours should be viewable within tour context
- Filter/sort options for timeline view

**Privacy:**
- All entries are private by default
- No sharing functionality in MVP (deferred to Phase 3)

**Connectivity:**
- Requires internet connection to create/save entries
- No offline draft persistence for MVP

### Reusability Opportunities

No existing code to reuse (new project). However, this feature should be designed with future extensibility in mind for:
- Dish Logging (Phase 3, Roadmap item #17) - individual dish entries within journal
- Journal Timeline View (Phase 3, Roadmap item #18) - enhanced timeline with filtering
- Journal Map View (Phase 3, Roadmap item #19) - map-based journal visualization
- Expense Tracking Export (Phase 4, Roadmap item #30) - spend amount per entry

### Scope Boundaries

**In Scope:**
- Journal entry creation from tour stops
- Standalone journal entry creation
- 1-5 star rating system
- Plain text notes field (no character limit)
- Timestamp with auto-capture and manual override
- Up to 3 photos per entry (camera + gallery)
- Image compression to ~1MB
- Cloudflare R2 image storage with thumbnails
- Restaurant association for all entries
- Tour association for tour-linked entries
- Chronological timeline view
- Grouped by restaurant view
- Private entries only

**Out of Scope:**
- Offline draft persistence (requires internet)
- Rich text formatting in notes
- More than 3 photos per entry (full 10 photos in Phase 2)
- Individual dish logging within entries (Phase 3)
- Public/shared journal entries (Phase 3)
- Map view of journal entries (Phase 3)
- Expense/spend amount tracking (Phase 4)
- "Would Return" indicator
- Tags (date night, business, family)

### Technical Considerations

**Database:**
- PostgreSQL via Serverpod ORM
- JournalEntry model with foreign keys to Restaurant and optionally Tour
- Photo metadata storage (R2 URLs, thumbnails)

**Image Storage:**
- Cloudflare R2 for photo storage
- Client-side compression before upload
- Server-side thumbnail generation
- Secure URL generation for image access

**API Endpoints:**
- Create journal entry (with optional tour context)
- Get entries (paginated, filterable by date range, restaurant)
- Get entries by restaurant
- Get entries for tour
- Update entry
- Delete entry
- Upload photo (returns R2 URL)

**UI Components (Flutter Web):**
- Journal entry form (rating, notes, timestamp picker, photo picker)
- Photo capture/selection widget (camera + gallery)
- Timeline view with entry cards
- Restaurant detail page integration (show past visits)
- Tour detail page integration (create entry for stop)

**Authentication:**
- Requires Serverpod Auth (Roadmap item #7 dependency)
- All journal data is user-scoped

**Mobile-First Design:**
- Primary breakpoint < 600px (phones)
- Touch-friendly rating input
- Mobile-optimized photo capture flow
