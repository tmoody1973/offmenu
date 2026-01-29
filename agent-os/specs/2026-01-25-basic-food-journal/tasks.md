# Task Breakdown: Basic Food Journal

## Overview
Total Tasks: 41
Estimated Total Complexity: Large

This feature enables users to capture and organize culinary experiences through journal entries with photos, notes, ratings, and timestamps, linked to restaurants and optionally to food tours.

## Technology Stack Reference
- **Frontend:** Flutter Web 3.x (mobile-first)
- **Backend:** Serverpod 2.x
- **Database:** PostgreSQL via Serverpod ORM
- **Image Storage:** Cloudflare R2
- **Language:** Dart (unified client/server)

---

## Task List

### Database Layer

#### Task Group 1: Data Models and Migrations
**Dependencies:** None
**Complexity:** M

- [x] 1.0 Complete database layer for journal entries
  - [x] 1.1 Write 4-6 focused tests for JournalEntry model functionality
    - Test JournalEntry creation with required fields (rating, restaurant association, timestamp)
    - Test JournalEntry validation (rating must be 1-5, restaurant_id required)
    - Test JournalEntry associations (belongs_to Restaurant, optional belongs_to Tour)
    - Test photo metadata storage and retrieval
    - Skip exhaustive validation edge cases
  - [x] 1.2 Create JournalEntry model with Serverpod ORM
    - Fields:
      - `id` (int, primary key)
      - `userId` (int, foreign key to User, required)
      - `restaurantId` (int, foreign key to Restaurant, required)
      - `tourId` (int?, foreign key to Tour, optional)
      - `tourStopId` (int?, foreign key to TourStop, optional)
      - `rating` (int, required, 1-5)
      - `notes` (String?, optional, no character limit)
      - `visitedAt` (DateTime, required, stored as UTC)
      - `createdAt` (DateTime, auto-generated)
      - `updatedAt` (DateTime, auto-updated)
    - Validations:
      - Rating must be between 1 and 5
      - restaurantId must reference valid Restaurant
      - visitedAt must not be in the future
  - [x] 1.3 Create JournalPhoto model for photo metadata
    - Fields:
      - `id` (int, primary key)
      - `journalEntryId` (int, foreign key to JournalEntry, required)
      - `originalUrl` (String, R2 URL for full-size image)
      - `thumbnailUrl` (String, R2 URL for 200x200 thumbnail)
      - `displayOrder` (int, 0-2 for ordering)
      - `uploadedAt` (DateTime, auto-generated)
    - Constraint: Maximum 3 photos per entry (enforced at API layer)
  - [x] 1.4 Create database migration for journal_entries table
    - Add indexes for: `userId`, `restaurantId`, `tourId`, `visitedAt`
    - Foreign keys: User, Restaurant, Tour (with ON DELETE behaviors)
    - Include created_at, updated_at timestamps
  - [x] 1.5 Create database migration for journal_photos table
    - Add index for: `journalEntryId`
    - Foreign key: JournalEntry with ON DELETE CASCADE
  - [x] 1.6 Set up model associations
    - JournalEntry has_many JournalPhotos
    - JournalEntry belongs_to Restaurant
    - JournalEntry belongs_to Tour (optional)
    - JournalEntry belongs_to User
  - [x] 1.7 Ensure database layer tests pass
    - Run ONLY the 4-6 tests written in 1.1
    - Verify migrations run successfully via `serverpod generate`
    - Do NOT run the entire test suite at this stage

**Acceptance Criteria:**
- The 4-6 tests written in 1.1 pass
- JournalEntry and JournalPhoto models defined correctly
- Migrations generate and apply without errors
- Associations configured properly with correct cascade behaviors
- Indexes created on frequently queried columns

---

### Cloudflare R2 Integration

#### Task Group 2: Image Upload Infrastructure
**Dependencies:** Task Group 1
**Complexity:** M

- [x] 2.0 Complete Cloudflare R2 image upload system
  - [x] 2.1 Write 3-4 focused tests for R2 upload functionality
    - Test signed URL generation returns valid URL structure
    - Test upload endpoint accepts image data and returns R2 URLs
    - Test thumbnail generation produces 200x200 image
    - Mock R2 API calls in tests
  - [x] 2.2 Configure R2 bucket and credentials
    - Create dedicated bucket for journal photos (via Cloudflare dashboard)
    - Configure CORS policy for Flutter Web uploads
    - Set up environment variables: `R2_ACCESS_KEY_ID`, `R2_SECRET_ACCESS_KEY`, `R2_BUCKET_NAME`, `R2_ENDPOINT`
    - Document bucket path structure: `/{userId}/{entryId}/{photoId}.{ext}`
  - [x] 2.3 Create R2Service class in Serverpod
    - Method: `generateSignedUploadUrl(userId, entryId, filename)` - returns pre-signed PUT URL
    - Method: `generateSignedReadUrl(objectKey)` - returns time-limited GET URL
    - Method: `deleteObject(objectKey)` - removes image from R2
    - Use S3-compatible API client (aws_signature_v4 or similar Dart package)
  - [x] 2.4 Implement server-side thumbnail generation
    - Use image processing package (e.g., image package for Dart)
    - Resize to 200x200px maintaining aspect ratio
    - Store thumbnail at separate path: `/{userId}/{entryId}/{photoId}_thumb.{ext}`
    - Generate thumbnail after successful original upload
  - [x] 2.5 Create PhotoUploadEndpoint in Serverpod
    - `POST /photos/upload-url` - returns signed URL for client-side upload
    - `POST /photos/confirm` - confirms upload, triggers thumbnail generation, returns both URLs
    - `DELETE /photos/{id}` - deletes photo and associated R2 objects
    - Validate user authentication and ownership
  - [x] 2.6 Ensure R2 integration tests pass
    - Run ONLY the 3-4 tests written in 2.1
    - Verify signed URL generation works
    - Do NOT run the entire test suite at this stage

**Acceptance Criteria:**
- The 3-4 tests written in 2.1 pass
- Signed URLs generated correctly for uploads
- Thumbnails created at 200x200px
- Photo URLs stored in database after upload confirmation
- Proper error handling for upload failures

---

### API Layer

#### Task Group 3: Journal Entry API Endpoints
**Dependencies:** Task Groups 1, 2
**Complexity:** M

- [x] 3.0 Complete journal entry API layer
  - [x] 3.1 Write 5-6 focused tests for API endpoints
    - Test create journal entry with valid data returns 201
    - Test create entry requires authentication (returns 401 if unauthenticated)
    - Test get entries returns paginated results for authenticated user
    - Test get entries by restaurant filters correctly
    - Test update entry validates ownership
    - Skip testing all error scenarios and edge cases
  - [x] 3.2 Create JournalEntryEndpoint class
    - `POST /journal-entries` - create new entry
      - Accept: rating, notes, visitedAt, restaurantId, tourId (optional), tourStopId (optional)
      - Validate rating 1-5, restaurant exists
      - Auto-set userId from session
      - Return created entry with ID
    - `GET /journal-entries` - list user's entries (paginated)
      - Query params: page, limit, sortBy (visitedAt, rating), sortOrder (asc, desc)
      - Default: newest first, 20 per page
      - Include restaurant name, photo thumbnails in response
    - `GET /journal-entries/{id}` - get single entry with full details
      - Include all photos (original URLs), restaurant details
      - Validate user owns the entry
    - `PUT /journal-entries/{id}` - update entry
      - Allow updating: rating, notes, visitedAt
      - Cannot change restaurant or tour association after creation
      - Validate ownership
    - `DELETE /journal-entries/{id}` - delete entry and associated photos
      - Cascade delete photos from R2
      - Validate ownership
  - [x] 3.3 Create filtered query endpoints
    - `GET /journal-entries/by-restaurant/{restaurantId}` - entries for specific restaurant
      - Paginated, chronological order
      - Include aggregate stats (visit count, average rating)
    - `GET /journal-entries/by-tour/{tourId}` - entries linked to a tour
      - Group by tour stop
    - `GET /journal-entries/by-date-range` - filter by date range
      - Query params: startDate, endDate
  - [x] 3.4 Create restaurant visit summary endpoint
    - `GET /restaurants/visited` - list all restaurants user has visited
      - Include: visit count, average rating, last visit date, thumbnail from most recent entry
      - Support sorting: by visit count, by rating, by last visit
  - [x] 3.5 Implement response formatting and error handling
    - Consistent JSON response structure
    - Appropriate HTTP status codes (200, 201, 400, 401, 403, 404)
    - User-friendly error messages without exposing internals
  - [x] 3.6 Ensure API layer tests pass
    - Run ONLY the 5-6 tests written in 3.1
    - Verify CRUD operations work correctly
    - Do NOT run the entire test suite at this stage

**Acceptance Criteria:**
- The 5-6 tests written in 3.1 pass
- All CRUD operations work with proper authentication
- Pagination implemented correctly
- Filtering by restaurant, tour, and date range works
- Proper ownership validation on all mutating operations
- Consistent response format across endpoints

---

### Frontend Components - Core

#### Task Group 4: Photo Capture and Upload UI
**Dependencies:** Task Group 2
**Complexity:** M

- [x] 4.0 Complete photo capture and upload components
  - [x] 4.1 Write 3-4 focused tests for photo components
    - Test PhotoPicker widget renders camera and gallery options
    - Test photo selection updates state with selected image
    - Test upload progress indicator displays during upload
    - Mock device camera/gallery APIs in tests
  - [x] 4.2 Create PhotoPicker widget
    - Display add photo button when fewer than 3 photos
    - Two capture modes: camera capture, gallery selection
    - Use `image_picker` package for device integration
    - Touch-friendly buttons with 44x44px minimum tap targets
    - Display selected photos as thumbnails in row
  - [x] 4.3 Implement client-side image compression
    - Compress images to approximately 1MB before upload
    - Use `flutter_image_compress` package
    - Maintain reasonable quality (80% quality setting)
    - Handle compression errors gracefully
  - [x] 4.4 Create PhotoUploadManager service
    - Handle signed URL request from server
    - Upload compressed image to R2 via signed URL
    - Confirm upload and receive final URLs
    - Track upload progress percentage
    - Support cancellation of in-progress uploads
  - [x] 4.5 Create UploadProgressIndicator widget
    - Display progress bar during upload
    - Show upload state: uploading, processing, complete, error
    - Allow retry on failure
  - [x] 4.6 Create PhotoThumbnailGrid widget
    - Display 1-3 photos in horizontal row
    - Show remove button on each photo
    - Consistent aspect ratio display
    - Tap to view full-size image
  - [ ] 4.7 Ensure photo component tests pass
    - Run ONLY the 3-4 tests written in 4.1
    - Verify component rendering
    - Do NOT run the entire test suite at this stage

**Acceptance Criteria:**
- The 3-4 tests written in 4.1 pass
- Camera and gallery capture both functional
- Images compressed before upload
- Upload progress visible to user
- Photos display correctly as thumbnails
- Maximum 3 photos enforced in UI

---

#### Task Group 5: Journal Entry Form UI
**Dependencies:** Task Groups 3, 4
**Complexity:** M

- [x] 5.0 Complete journal entry form components
  - [x] 5.1 Write 3-4 focused tests for form components
    - Test StarRating widget updates on tap
    - Test form validates required fields (rating, restaurant)
    - Test form submission calls API with correct data
    - Skip testing all validation scenarios
  - [x] 5.2 Create StarRating widget
    - Display 5 tappable stars in horizontal row
    - Minimum 44x44px tap target per star
    - Visual states: empty (outlined), filled (solid)
    - Update rating on tap with immediate visual feedback
    - Required field - show error if not set on submit
  - [x] 5.3 Create NotesTextField widget
    - Plain text textarea with no character limit
    - Mobile-optimized with `TextInputType.multiline`
    - Auto-expanding height as content grows
    - Optional field - no validation required
  - [x] 5.4 Create TimestampPicker widget
    - Auto-populate with current time on form load
    - Allow manual override via date/time picker
    - Display in user's local timezone
    - Convert to UTC before submission
    - Use Flutter's built-in date/time picker dialogs
  - [ ] 5.5 Create RestaurantSelector widget (for standalone entries)
    - Search input with debounced API calls
    - Query local database first, then Foursquare Places API
    - Display results in dropdown/list
    - Show restaurant name, address in results
    - Required field for standalone entries
  - [x] 5.6 Create JournalEntryForm widget
    - Combine all form fields: rating, notes, timestamp, photos, restaurant
    - Handle two modes:
      - Tour context: restaurant pre-filled, tour association set
      - Standalone: restaurant selection required
    - Form validation before submission
    - Loading state during API call
    - Success/error feedback to user
  - [x] 5.7 Create JournalEntryFormPage screen
    - Full-page form with scroll support
    - Mobile-first layout (< 600px primary)
    - Back navigation with unsaved changes warning
    - Submit button in app bar or bottom
    - Return to previous screen on success
  - [x] 5.8 Ensure form component tests pass
    - Run ONLY the 3-4 tests written in 5.1
    - Verify form validation and submission
    - Do NOT run the entire test suite at this stage

**Acceptance Criteria:**
- The 3-4 tests written in 5.1 pass
- Star rating functional with proper touch targets
- Notes field auto-expands
- Timestamp picker works with timezone handling
- Restaurant search functional for standalone entries
- Form validates required fields before submission
- Mobile-first responsive layout

---

### Frontend Components - Views

#### Task Group 6: Timeline View
**Dependencies:** Task Group 3
**Complexity:** M

- [x] 6.0 Complete chronological timeline view
  - [ ] 6.1 Write 3-4 focused tests for timeline view
    - Test TimelinePage renders list of entry cards
    - Test infinite scroll loads more entries
    - Test sort/filter controls update displayed entries
    - Skip testing all filter combinations
  - [x] 6.2 Create JournalEntryCard widget
    - Display: thumbnail (first photo), restaurant name, rating (stars), date, notes preview (truncated)
    - Card-based layout with consistent padding
    - Tap to navigate to entry detail
    - Show tour badge if entry has tour association
  - [x] 6.3 Create TimelinePage screen
    - Reverse chronological list of JournalEntryCards
    - Pull-to-refresh functionality
    - Empty state when no entries exist
    - Mobile-first layout with appropriate spacing
  - [x] 6.4 Implement pagination with infinite scroll
    - Load initial 20 entries
    - Load more when scrolled near bottom
    - Show loading indicator while fetching
    - Handle end of list gracefully
  - [x] 6.5 Create FilterSortControls widget
    - Sort options: newest first, oldest first, highest rated
    - Date range filter with start/end date pickers
    - Clear filters button
    - Persist filter state during session
  - [x] 6.6 Create JournalEntryDetailPage screen
    - Full entry view with all photos (swipeable gallery)
    - Full notes text
    - Restaurant name with link to restaurant detail
    - Tour name with link to tour detail (if applicable)
    - Edit and delete actions
  - [ ] 6.7 Ensure timeline view tests pass
    - Run ONLY the 3-4 tests written in 6.1
    - Verify list rendering and pagination
    - Do NOT run the entire test suite at this stage

**Acceptance Criteria:**
- The 3-4 tests written in 6.1 pass
- Entries display in reverse chronological order
- Infinite scroll loads more entries smoothly
- Sort and filter options work correctly
- Entry cards show essential info at a glance
- Navigation to detail view works

---

#### Task Group 7: Restaurant-Grouped View
**Dependencies:** Task Group 3
**Complexity:** S

- [x] 7.0 Complete restaurant-grouped view
  - [ ] 7.1 Write 2-3 focused tests for restaurant view
    - Test RestaurantsVisitedPage renders list of restaurants
    - Test restaurant tap navigates to filtered entries view
    - Skip testing aggregate calculations
  - [x] 7.2 Create RestaurantVisitCard widget
    - Display: restaurant name, visit count, average rating, last visit date
    - Thumbnail from most recent entry
    - Tap to see all entries for restaurant
  - [x] 7.3 Create RestaurantsVisitedPage screen
    - List all restaurants user has journal entries for
    - Sort options: most visited, highest rated, most recent
    - Empty state for new users
  - [ ] 7.4 Create RestaurantEntriesPage screen
    - Display all entries for selected restaurant
    - Chronological order within restaurant
    - Show aggregate stats at top (total visits, average rating)
    - Link to restaurant detail page
  - [ ] 7.5 Ensure restaurant view tests pass
    - Run ONLY the 2-3 tests written in 7.1
    - Verify list rendering and navigation
    - Do NOT run the entire test suite at this stage

**Acceptance Criteria:**
- The 2-3 tests written in 7.1 pass
- Restaurants listed with visit counts
- Tap navigates to filtered entries
- Aggregate stats display correctly
- Sorting options work

---

#### Task Group 8: Tour Context Integration
**Dependencies:** Task Groups 5, 6
**Complexity:** S

- [ ] 8.0 Complete tour context integration
  - [ ] 8.1 Write 2-3 focused tests for tour integration
    - Test "Log Visit" button appears on completed tour stops
    - Test creating entry from tour pre-fills restaurant and tour
    - Skip testing navigation edge cases
  - [ ] 8.2 Add "Log Visit" button to TourStopCard
    - Display on tour detail screen for each completed stop
    - Button visible only after stop is marked complete
    - Navigate to JournalEntryFormPage with context
  - [ ] 8.3 Implement tour context passing
    - Pass restaurantId from tour stop data
    - Pass tourId and tourStopId for association
    - Pre-populate fields in JournalEntryForm
    - Return to tour detail screen after submission
  - [ ] 8.4 Display journal entries within tour detail
    - Show existing entries under each tour stop
    - Display mini entry card (rating, date, thumbnail)
    - Tap to view full entry
  - [ ] 8.5 Add tour badge to entry displays
    - Show badge/indicator on entries with tour association
    - Include tour name in entry detail view
    - Link to tour detail page from entry
  - [ ] 8.6 Ensure tour integration tests pass
    - Run ONLY the 2-3 tests written in 8.1
    - Verify tour context flows correctly
    - Do NOT run the entire test suite at this stage

**Acceptance Criteria:**
- The 2-3 tests written in 8.1 pass
- "Log Visit" button appears on completed stops
- Entry form pre-fills correctly from tour context
- Entries display within tour detail view
- Tour badge visible on associated entries

---

### Testing

#### Task Group 9: Test Review and Gap Analysis
**Dependencies:** Task Groups 1-8
**Complexity:** S

- [ ] 9.0 Review existing tests and fill critical gaps only
  - [ ] 9.1 Review tests from Task Groups 1-8
    - Review 4-6 tests from database layer (Task 1.1)
    - Review 3-4 tests from R2 integration (Task 2.1)
    - Review 5-6 tests from API layer (Task 3.1)
    - Review 3-4 tests from photo components (Task 4.1)
    - Review 3-4 tests from form components (Task 5.1)
    - Review 3-4 tests from timeline view (Task 6.1)
    - Review 2-3 tests from restaurant view (Task 7.1)
    - Review 2-3 tests from tour integration (Task 8.1)
    - Total existing tests: approximately 26-34 tests
  - [ ] 9.2 Analyze test coverage gaps for Basic Food Journal feature only
    - Identify critical end-to-end workflows lacking coverage:
      - Complete entry creation flow (form to API to database)
      - Photo upload flow (capture to R2 to display)
      - Entry retrieval and display flow
    - Focus ONLY on gaps related to this feature
    - Do NOT assess entire application test coverage
  - [ ] 9.3 Write up to 8 additional strategic tests maximum
    - Integration test: Create entry with photos end-to-end
    - Integration test: Edit entry updates correctly
    - Integration test: Delete entry removes photos from R2
    - Integration test: Timeline view loads and paginates
    - Integration test: Restaurant filter returns correct entries
    - Integration test: Tour context pre-fills form correctly
    - Skip edge cases, performance tests, accessibility tests unless business-critical
    - Maximum 8 new tests to fill identified gaps
  - [ ] 9.4 Run feature-specific tests only
    - Run ONLY tests related to Basic Food Journal feature
    - Expected total: approximately 34-42 tests maximum
    - Do NOT run the entire application test suite
    - Verify all critical workflows pass

**Acceptance Criteria:**
- All feature-specific tests pass (approximately 34-42 tests total)
- Critical user workflows covered:
  - Create journal entry (standalone and from tour)
  - Upload and display photos
  - View entries in timeline and by restaurant
  - Edit and delete entries
- No more than 8 additional tests added
- Testing focused exclusively on Basic Food Journal feature requirements

---

## Execution Order

Recommended implementation sequence:

```
Phase 1: Foundation
  1. Database Layer (Task Group 1) - Models and migrations first
  2. R2 Integration (Task Group 2) - Image storage infrastructure

Phase 2: Backend
  3. API Layer (Task Group 3) - All endpoints for journal entries

Phase 3: Frontend Core
  4. Photo Components (Task Group 4) - Camera, gallery, upload
  5. Entry Form (Task Group 5) - Rating, notes, timestamp, form

Phase 4: Frontend Views
  6. Timeline View (Task Group 6) - Chronological list
  7. Restaurant View (Task Group 7) - Grouped by restaurant
  8. Tour Integration (Task Group 8) - Connect to tour context

Phase 5: Quality Assurance
  9. Test Review (Task Group 9) - Fill gaps, verify coverage
```

---

## Dependencies Diagram

```
Task Group 1 (Database)
        |
        v
Task Group 2 (R2) -----> Task Group 4 (Photo UI)
        |                        |
        v                        v
Task Group 3 (API) -----> Task Group 5 (Form UI)
        |                        |
        |                        v
        +--------------> Task Group 6 (Timeline)
        |                        |
        +--------------> Task Group 7 (Restaurant View)
        |                        |
        +--------------> Task Group 8 (Tour Integration)
                                 |
                                 v
                        Task Group 9 (Testing)
```

---

## Complexity Legend
- **S (Small):** 1-2 days estimated effort
- **M (Medium):** 3-5 days estimated effort
- **L (Large):** 1-2 weeks estimated effort

## Notes

- This is a greenfield project - no existing Flutter or Serverpod code to reference
- Authentication is a dependency (Serverpod Auth must be configured)
- All journal data is user-scoped and private
- Mobile-first design with < 600px as primary breakpoint
- Follow Serverpod ORM conventions for all model definitions
- Use RESTful API patterns per project standards
