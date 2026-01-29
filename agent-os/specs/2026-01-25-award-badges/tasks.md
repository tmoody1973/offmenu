# Task Breakdown: Award Badges (James Beard / Michelin Integration)

## Overview
Total Tasks: 7 Task Groups
Estimated Total Complexity: Medium-Large (2-3 days as per roadmap)

## Task List

### Database Layer

#### Task Group 1: Award Data Models and Migrations
**Dependencies:** None
**Complexity:** Medium

- [x] 1.0 Complete database layer for award data
  - [x] 1.1 Write 4-6 focused tests for award models
    - Test MichelinAward model validation (required fields: restaurant_name, city, designation, year)
    - Test JamesBeardAward model validation (required fields: name, city, category, year, distinction_level)
    - Test RestaurantAwardLink model association and confidence_score validation
    - Test index lookups on restaurant_name + city perform efficiently
  - [x] 1.2 Create MichelinAward model with Serverpod ORM
    - Fields: id, restaurant_name, city, address, latitude, longitude, designation (enum: one_star, two_star, three_star, bib_gourmand), award_year, created_at, updated_at
    - Validations: restaurant_name required, city required, designation required, award_year required (2018-2025 range)
    - Add composite index on (restaurant_name, city) for fast fuzzy matching lookups
  - [x] 1.3 Create JamesBeardAward model with Serverpod ORM
    - Fields: id, name (chef/restaurant), city, category (enum or string for flexibility), distinction_level (enum: winner, nominee, semifinalist), award_year, created_at, updated_at
    - Validations: name required, city required, category required, distinction_level required, award_year required (2018-2025)
    - Add composite index on (name, city) for fast fuzzy matching lookups
  - [x] 1.4 Create RestaurantAwardLink junction table
    - Fields: id, restaurant_id (FK), award_type (enum: michelin, james_beard), award_id, match_confidence_score (0.0-1.0), match_status (enum: auto_matched, manual_confirmed, manual_rejected, pending_review), matched_by_user_id (nullable FK), created_at, updated_at
    - Foreign keys: restaurant_id references restaurants table
    - Index on restaurant_id for fast badge lookups
    - Index on match_status for review queue queries
  - [x] 1.5 Create AwardImportLog model for audit trail
    - Fields: id, import_type (enum: michelin, james_beard), file_name, records_imported, records_matched, records_pending_review, imported_by_user_id (FK), created_at
    - For tracking who imported data and when
  - [x] 1.6 Create reversible migrations for all award tables
    - Migration 1: Create michelin_awards table with indexes
    - Migration 2: Create james_beard_awards table with indexes
    - Migration 3: Create restaurant_award_links junction table
    - Migration 4: Create award_import_logs table
    - Ensure rollback/down methods are implemented
  - [x] 1.7 Ensure database layer tests pass
    - Run ONLY the 4-6 tests written in 1.1
    - Verify all migrations run and rollback successfully
    - Do NOT run the entire test suite at this stage

**Acceptance Criteria:**
- The 4-6 tests written in 1.1 pass
- All four tables created with proper constraints and indexes
- Migrations are reversible
- Models enforce validation rules at both model and database levels
- Timestamps (created_at, updated_at) present on all models

---

### Fuzzy Matching Service

#### Task Group 2: Restaurant-Award Matching Algorithm
**Dependencies:** Task Group 1
**Complexity:** Medium

- [x] 2.0 Complete fuzzy matching service
  - [x] 2.1 Write 4-6 focused tests for matching algorithm
    - Test exact name + city match returns confidence score >= 0.95
    - Test fuzzy match handles minor spelling variations (e.g., "Joe's" vs "Joes")
    - Test coordinate proximity validation improves confidence for ambiguous name matches
    - Test low-confidence matches (< 0.7) are flagged for review
  - [x] 2.2 Implement FuzzyMatchService class
    - Add string_similarity package (or implement Levenshtein/Jaro-Winkler algorithm)
    - Primary matching: normalize strings (lowercase, remove punctuation), compare restaurant_name + city
    - Return confidence score based on string similarity threshold
  - [x] 2.3 Add coordinate-based secondary validation
    - For matches with confidence 0.7-0.9, use coordinate proximity as tiebreaker
    - If coordinates within 100m, boost confidence by 0.1
    - If coordinates within 500m, boost confidence by 0.05
    - Handle cases where coordinates are missing gracefully
  - [x] 2.4 Implement batch matching method for imports
    - Accept list of awards and list of restaurants
    - Return list of RestaurantAwardLink objects with confidence scores
    - Automatically confirm matches >= 0.9 confidence
    - Flag matches 0.7-0.9 as pending_review
    - Mark matches < 0.7 as unmatched for manual linking
  - [x] 2.5 Handle edge cases in matching logic
    - Restaurant name changes: match against aliases if available
    - Closed establishments: allow matching but flag as "restaurant_closed"
    - Multiple locations: match based on city + address combination
  - [x] 2.6 Ensure fuzzy matching tests pass
    - Run ONLY the 4-6 tests written in 2.1
    - Verify matching algorithm produces consistent results
    - Do NOT run the entire test suite at this stage

**Acceptance Criteria:**
- The 4-6 tests written in 2.1 pass
- Exact matches score >= 0.95
- Minor variations still match with reasonable confidence
- Coordinate validation improves ambiguous matches
- Low-confidence matches flagged appropriately for review

---

### API Layer

#### Task Group 3: Award API Endpoints
**Dependencies:** Task Groups 1, 2
**Complexity:** Medium

- [x] 3.0 Complete API layer for awards
  - [x] 3.1 Write 4-6 focused tests for API endpoints
    - Test GET /restaurants/:id/awards returns linked awards for a restaurant
    - Test GET /awards/michelin with city filter returns Michelin awards
    - Test POST /admin/awards/import requires admin authentication
    - Test POST /admin/awards/links/:id/confirm updates match_status correctly
  - [x] 3.2 Create AwardEndpoint for public award queries
    - GET /restaurants/:id/awards - Return all linked awards for a restaurant (badges data)
    - GET /awards/michelin - List Michelin awards with optional city/designation filters
    - GET /awards/james-beard - List James Beard awards with optional category/year filters
    - Follow Serverpod endpoint conventions
  - [x] 3.3 Create AdminAwardEndpoint for import and review
    - POST /admin/awards/import - Upload and process CSV/JSON file
    - GET /admin/awards/import/preview - Dry-run mode to preview matches
    - GET /admin/awards/review-queue - List pending_review matches with pagination
    - POST /admin/awards/links/:id/confirm - Manually confirm a match
    - POST /admin/awards/links/:id/reject - Manually reject a match
    - POST /admin/awards/links - Manually create a new link
    - DELETE /admin/awards/links/:id - Remove a link
    - Require admin authorization for all endpoints
  - [x] 3.4 Implement file parsing for import
    - Parse Michelin CSV format (Kaggle dataset structure)
    - Parse James Beard CSV/JSON format (GitHub dataset structure)
    - Validate required fields, detect duplicates, flag parsing errors
    - Return structured validation report before committing
  - [x] 3.5 Implement import audit logging
    - Create AwardImportLog entry on successful import
    - Track records_imported, records_matched, records_pending_review
    - Associate with importing user for accountability
  - [x] 3.6 Add award scoring data to restaurant queries
    - Extend existing restaurant endpoint to include award_score field
    - Calculate score based on tiered weighting:
      - Michelin: 3-star=100, 2-star=70, 1-star=50, Bib Gourmand=30
      - James Beard: Winner=50, Nominee=30, Semifinalist=15
    - Recent awards (last 2 years) get 1.5x multiplier
    - Multiple awards compound with diminishing returns (sqrt scaling)
  - [x] 3.7 Ensure API layer tests pass
    - Run ONLY the 4-6 tests written in 3.1
    - Verify endpoints return proper HTTP status codes
    - Do NOT run the entire test suite at this stage

**Acceptance Criteria:**
- The 4-6 tests written in 3.1 pass
- Public endpoints return correct award data
- Admin endpoints require authentication
- File parsing handles both Michelin and James Beard formats
- Import audit logs are created
- Award scoring integrated into restaurant data

---

### Frontend Components

#### Task Group 4: Badge UI Component
**Dependencies:** Task Group 3
**Complexity:** Small

- [x] 4.0 Complete badge UI component
  - [x] 4.1 Write 3-5 focused tests for badge component
    - Test AwardBadge renders correct icon for Michelin star designation
    - Test AwardBadge renders correct icon for James Beard award
    - Test BadgeRow handles overflow with "+N more" when > 3 badges
    - Test badges have proper ARIA labels for accessibility
  - [x] 4.2 Create AwardBadge widget (single badge)
    - Props: awardType (michelin/james_beard), designation/category, size (compact/standard/expanded), size (compact/standard/expanded), year
    - Michelin variants: star icon (1/2/3 stars), fork/spoon icon for Bib Gourmand
    - James Beard variants: medal/ribbon icon with distinction level
    - Color schemes: gold/red for Michelin, blue for James Beard
    - Rounded corners, subtle shadow, WCAG AA contrast compliance
  - [x] 4.3 Create BadgeRow widget (multiple badges)
    - Props: awards list, maxVisible (default 3), size
    - Horizontal stacking with consistent spacing
    - Overflow handling: show "+N more" chip when badges exceed maxVisible
    - Tap on "+N more" expands to show all (or navigates to detail)
  - [x] 4.4 Implement responsive badge sizing
    - Compact size for map popups (icon-only, 16-20px)
    - Standard size for restaurant cards (icon + abbreviated text, 24-28px)
    - Expanded size for detail pages (full icon + text + year, 32-40px)
    - Use relative units (rem) for scalability
  - [x] 4.5 Add accessibility features
    - Semantic alt text: "Michelin 2-Star 2024" not just "star"
    - ARIA labels describing the award fully
    - Sufficient color contrast (4.5:1 minimum)
    - Keyboard focusable when interactive
  - [x] 4.6 Ensure badge component tests pass
    - Run ONLY the 3-5 tests written in 4.1
    - Verify visual rendering matches design guidelines
    - Do NOT run the entire test suite at this stage

**Acceptance Criteria:**
- The 3-5 tests written in 4.1 pass
- Single badge renders correctly for all award types
- Badge row handles overflow gracefully
- Responsive sizing works across breakpoints
- Accessibility requirements met (ARIA, contrast, keyboard)

---

#### Task Group 5: Badge Display Integration
**Dependencies:** Task Group 4
**Complexity:** Small

- [x] 5.0 Integrate badges into existing display contexts
  - [x] 5.1 Write 3-5 focused tests for integration
    - Test RestaurantCard displays BadgeRow when restaurant has awards
    - Test RestaurantDetailPage shows full award history section
    - Test MapPopup shows compact icon-only badges
  - [x] 5.2 Integrate BadgeRow into RestaurantCard widget
    - Position below restaurant name
    - Use standard size badges
    - Max 3 visible with "+N more" overflow
    - Fetch awards data from restaurant model
  - [x] 5.3 Create AwardHistorySection for RestaurantDetailPage
    - Full list of all awards with years and categories
    - Group by award type (Michelin section, James Beard section)
    - Use expanded size badges
    - Show year awarded for each
  - [x] 5.4 Integrate compact badges into MapPopup widget
    - Icon-only badges due to space constraints
    - Position below restaurant name in popup
    - Max 2 visible (tighter space constraints)
  - [x] 5.5 Add award aggregation to TourSummaryScreen
    - Display aggregate count: "3 Michelin-starred stops"
    - Show breakdown by award type if multiple
    - Highlight highest-tier awards (e.g., "includes 1 three-star restaurant")
  - [x] 5.6 Ensure integration tests pass
    - Run ONLY the 3-5 tests written in 5.1
    - Verify badges appear in all four display contexts
    - Do NOT run the entire test suite at this stage

**Acceptance Criteria:**
- The 3-5 tests written in 5.1 pass
- Badges appear on restaurant cards
- Detail pages show full award history
- Map popups show compact badges
- Tour summary shows aggregated award information

---

### Admin Interface

#### Task Group 6: Admin Import and Review Interface
**Dependencies:** Task Groups 3, 4
**Complexity:** Medium

- [x] 6.0 Complete admin interface for award management
  - [x] 6.1 Write 3-5 focused tests for admin UI
    - Test file upload triggers import preview API call
    - Test review queue displays pending matches with confidence scores
    - Test confirm/reject actions update match status
  - [x] 6.2 Create AdminAwardImportPage
    - Drag-and-drop file upload zone (supports CSV/JSON)
    - File type selection: Michelin or James Beard
    - Upload progress indicator
    - Validation error display (missing fields, parsing errors)
  - [x] 6.3 Create ImportPreviewSection
    - Table showing records to be imported
    - Preview of matching results (dry-run)
    - Color-coded status: green=auto-match, yellow=review, red=no match
    - Confirm import button to commit to database
    - Cancel button to discard
  - [x] 6.4 Create AdminReviewQueuePage
    - Table of pending_review matches with columns: Restaurant, Award, Confidence Score, Actions
    - Sort by confidence score (lowest first for attention)
    - Pagination for large queues
    - Bulk actions: confirm selected, reject selected
  - [x] 6.5 Create MatchDetailModal for review decisions
    - Show restaurant details side-by-side with award details
    - Display confidence score and matching factors
    - Confirm match button
    - Reject match button
    - Manual search to link to different restaurant
  - [x] 6.6 Create AdminAwardSearchPage
    - Search interface to find specific restaurants or awards
    - Filter by award type, year, city, status
    - Manual link/unlink capability
    - View audit log entries
  - [x] 6.7 Ensure admin UI tests pass
    - Run ONLY the 3-5 tests written in 6.1
    - Verify admin workflows complete successfully
    - Do NOT run the entire test suite at this stage

**Acceptance Criteria:**
- The 3-5 tests written in 6.1 pass
- File upload with drag-and-drop works
- Preview shows matching results before commit
- Review queue displays pending matches
- Manual confirm/reject updates match status
- Search and manual linking functional

---

### Testing

#### Task Group 7: Test Review and Gap Analysis
**Dependencies:** Task Groups 1-6
**Complexity:** Small

- [x] 7.0 Review existing tests and fill critical gaps only
  - [x] 7.1 Review tests from Task Groups 1-6
    - Review 4-6 tests from database-engineer (Task 1.1) - 10 tests
    - Review 4-6 tests from fuzzy-matching (Task 2.1) - 12 tests
    - Review 4-6 tests from api-engineer (Task 3.1) - 10 tests
    - Review 3-5 tests from badge-component (Task 4.1) - 13 tests
    - Review 3-5 tests from integration (Task 5.1) - included in badge tests
    - Review 3-5 tests from admin-ui (Task 6.1) - 6 tests
    - Total existing tests: 51 tests
  - [x] 7.2 Analyze test coverage gaps for award badge feature only
    - Identify critical user workflows lacking coverage
    - Focus ONLY on gaps related to this spec
    - Prioritize end-to-end workflows:
      - Admin imports CSV -> awards matched -> badges display on restaurant
      - User views restaurant card -> sees correct badges -> taps for detail
    - Do NOT assess entire application test coverage
  - [x] 7.3 Write up to 8 additional strategic tests maximum
    - End-to-end: Full import workflow from file upload to badge display
    - Integration: Scoring algorithm correctly boosts awarded restaurants
    - Edge case: Restaurant with multiple awards across years displays correctly
    - Edge case: Empty award data gracefully shows no badges
    - Do NOT write comprehensive coverage for all scenarios
    - Added 8 edge case tests in award_edge_cases_test.dart
  - [x] 7.4 Run feature-specific tests only
    - Run ONLY tests related to award badge feature
    - Total: 59 tests (32 backend + 27 frontend)
    - Do NOT run the entire application test suite
    - Verify all critical workflows pass - ALL TESTS PASSING

**Acceptance Criteria:**
- All feature-specific tests pass (59 tests total) - PASSED
- Critical user workflows for award badges are covered
- 8 additional tests added (edge cases)
- End-to-end import-to-display workflow verified

---

## Execution Order

Recommended implementation sequence:

```
1. Database Layer (Task Group 1) - COMPLETE
   |
   v
2. Fuzzy Matching Service (Task Group 2) - COMPLETE
   |
   v
3. API Layer (Task Group 3) - COMPLETE
   |
   +------------------+
   |                  |
   v                  v
4. Badge UI          6. Admin Interface
   Component            (Task Group 6) - COMPLETE
   (Task Group 4)       |
   - COMPLETE           |
   |                    |
   v                    |
5. Badge Display        |
   Integration          |
   (Task Group 5)       |
   - COMPLETE           |
   |                    |
   +------------------+-+
                      |
                      v
               7. Test Review & Gap Analysis
                  (Task Group 7) - COMPLETE
```

**Parallel Execution Opportunities:**
- Task Groups 4-5 (Badge UI) and Task Group 6 (Admin Interface) can be developed in parallel after Task Group 3 completes
- These two tracks have no direct dependencies on each other

## Complexity Summary

| Task Group | Complexity | Estimated Effort | Status |
|------------|------------|------------------|--------|
| 1. Database Layer | Medium | 3-4 hours | COMPLETE |
| 2. Fuzzy Matching | Medium | 3-4 hours | COMPLETE |
| 3. API Layer | Medium | 4-5 hours | COMPLETE |
| 4. Badge Component | Small | 2-3 hours | COMPLETE |
| 5. Badge Integration | Small | 2-3 hours | COMPLETE |
| 6. Admin Interface | Medium | 4-5 hours | COMPLETE |
| 7. Test Review | Small | 1-2 hours | COMPLETE |

**Total Estimated Effort:** 19-26 hours (2-3 days as specified in roadmap)

## Final Test Summary

| Test File | Tests | Status |
|-----------|-------|--------|
| award_models_test.dart | 10 | PASS |
| fuzzy_match_service_test.dart | 12 | PASS |
| award_endpoint_test.dart | 10 | PASS |
| award_badge_test.dart | 13 | PASS |
| admin_award_test.dart | 6 | PASS |
| award_edge_cases_test.dart | 8 | PASS |
| **TOTAL** | **59** | **ALL PASS** |

## Tech Stack Alignment Notes

- **Backend:** Serverpod 2.x with PostgreSQL (per tech-stack.md)
- **Frontend:** Flutter Web 3.x with mobile-first responsive design
- **ORM:** Serverpod ORM for type-safe Dart models
- **Testing:** flutter_test for unit and widget testing
- **Responsive Breakpoints:** Mobile (<600px), Tablet (600-1024px), Desktop (>1024px)
- **Accessibility:** WCAG AA compliance, ARIA labels, 4.5:1 contrast ratio
