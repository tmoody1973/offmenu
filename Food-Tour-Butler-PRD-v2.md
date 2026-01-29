  
**FOOD TOUR BUTLER**

Product Requirements Document

with OpenTable Integration, Multi-Day Trips & Food Journal

*Serverpod 3 Flutter Butler Hackathon Submission*

Version 2.0

January 24, 2026

Author: Tarik Moody

# **1\. Executive Summary**

Food Tour Butler is a comprehensive mobile application that generates personalized, multi-stop food tours optimized for digestion timing and routing. The app combines curated culinary award data (James Beard, Michelin) with real-time restaurant information and OpenTable reservations to create memorable progressive dining experiences. Whether exploring for a single afternoon, a week-long vacation, or monthly local adventures, Food Tour Butler serves as your personal food concierge with built-in journaling and social sharing.

## **1.1 Problem Statement**

Travelers and food enthusiasts face multiple challenges: planning efficient multi-restaurant tours, discovering unique dining experiences beyond standard reservations, tracking their culinary adventures across extended trips, and sharing their food journeys with others. Current solutions are fragmented \- one app for discovery, another for reservations, manual notes for journaling.

## **1.2 Solution**

Food Tour Butler provides an integrated solution:

* Single-day optimized tours with walking/driving modes  
* Multi-day trip itineraries for vacations and business travel  
* OpenTable integration for reservations AND unique Experiences  
* James Beard and Michelin award highlighting  
* Food Journal with photos, ratings, and notes  
* Social sharing and exportable trip summaries  
* Local Explorer mode for ongoing neighborhood discovery

## **1.3 Target Market**

| Segment | Description |
| :---- | :---- |
| Vacation Travelers | Week-long trips, want curated dining across multiple days |
| Business Travelers | Frequent city visits, limited time, want memorable meals |
| Local Explorers | Systematically discover their own city over weeks/months |
| Experience Seekers | Want special events: tasting menus, chef's tables, wine pairings |
| Food Content Creators | Bloggers/influencers who need to document and share journeys |

# **2\. Product Overview**

## **2.1 Core Value Proposition**

*"Your personal food concierge that crafts the perfect dining journey \- from a single afternoon to a month-long adventure \- with seamless reservations, unique experiences, and a beautiful journal to remember it all."*

## **2.2 Key Differentiators**

| Feature | Description |
| :---- | :---- |
| Trip Planning Modes | Single-day tours, multi-day itineraries, or ongoing local exploration |
| OpenTable Experiences | Book unique dining events: tasting menus, wine pairings, chef's tables, live music dinners |
| Integrated Reservations | One-tap booking through OpenTable with real-time availability |
| Award Integration | James Beard and Michelin data prominently displayed |
| Food Journal | Log visits with photos, ratings, notes, and favorite dishes |
| Social Sharing | Share trips via link, export to social media, create shareable itineraries |
| Dual Transport Modes | Walking and driving with digestion-optimized pacing |

# **3\. User Personas**

## **3.1 The Vacation Foodie \- "Elena"**

* **Age:** 38  
* **Occupation:** Architect  
* **Trip Type:** 7-day vacation to Chicago with husband  
* **Behavior:** Plans 1-2 special dinners per trip, wants mix of fancy and casual  
* **Pain Points:** Hard to coordinate reservations across multiple days, forgets what she ate  
* **Goals:** Create a week-long dining plan, book a tasting menu experience, keep photo journal  
* **Key Features:** Multi-day trip mode, OpenTable Experiences, Food Journal

## **3.2 The Business Traveler \- "David"**

* **Age:** 45  
* **Occupation:** Management Consultant  
* **Trip Type:** 3-day client visit to NYC, happens monthly  
* **Behavior:** Needs quick dinner recommendations near hotel, tracks expenses  
* **Pain Points:** Limited time to research, wants to avoid repeating same restaurants  
* **Goals:** Quick recommendations, see visit history, log for expense reports  
* **Key Features:** Location-based suggestions, visit history, receipt/expense logging

## **3.3 The Local Explorer \- "Marcus"**

* **Age:** 52  
* **Occupation:** Software Engineer  
* **Trip Type:** Ongoing exploration of Milwaukee neighborhoods  
* **Behavior:** One food adventure per weekend, follows James Beard nominations  
* **Pain Points:** Forgets which spots he's tried, no organized way to track favorites  
* **Goals:** Visit all JB nominees in region, build a personal food map over months  
* **Key Features:** Local Explorer mode, award tracking, long-term journal

## **3.4 The Experience Seeker \- "Aisha"**

* **Age:** 29  
* **Occupation:** Marketing Director  
* **Trip Type:** Anniversary weekend, wants something special  
* **Behavior:** Seeks unique dining events, willing to pay premium for experience  
* **Pain Points:** Hard to find special events beyond standard reservations  
* **Goals:** Book a chef's table or wine pairing dinner, create memorable evening  
* **Key Features:** OpenTable Experiences, curated special events, prepaid bookings

## **3.5 The Food Content Creator \- "Jordan"**

* **Age:** 26  
* **Occupation:** Food Blogger / Instagram Influencer  
* **Trip Type:** Content trip to document Austin food scene  
* **Behavior:** Photographs every dish, needs organized content for posts  
* **Pain Points:** Manually organizing photos by restaurant, recreating itinerary for posts  
* **Goals:** Beautiful exportable trip summary, organized photo library, shareable links  
* **Key Features:** Photo journal, trip export, social sharing, public trip links

# **4\. Trip Planning Modes**

## **4.1 Mode Overview**

| Mode | Duration | Use Case |
| :---- | :---- | :---- |
| Single-Day Tour | 2-6 hours | Classic food crawl: 3-5 stops in one afternoon/evening |
| Multi-Day Trip | 2-14 days | Vacation/business travel with 1-3 restaurants per day |
| Extended Journey | Weeks/months | Local exploration, tracking visits over time |
| Quick Pick | Single meal | "Where should I eat right now?" with instant booking |

## **4.2 Single-Day Tour Mode**

The classic Food Tour Butler experience \- a curated progressive tasting route for one day.

* **Stops:** 3-6 restaurants  
* **Transport:** Walking (0.8mi max between stops) or Driving (10mi max)  
* **Pacing:** 20-45 minute gaps for digestion  
* **Output:** Ordered itinerary with times, directions, dish recommendations

## **4.3 Multi-Day Trip Mode**

Plan an entire vacation or business trip with dining across multiple days.

### **4.3.1 Trip Setup**

* **Destination:** City or region  
* **Dates:** Start and end dates  
* **Lodging Location:** Hotel/Airbnb address for proximity-based suggestions  
* **Daily Meals:** Select which meals to plan (breakfast, lunch, dinner)  
* **Budget per Day:** $50, $100, $150, $200+  
* **Special Occasions:** Mark days for splurge meals (anniversary, birthday)

### **4.3.2 Daily Planning**

* AI generates daily dining recommendations  
* Mix of cuisines across the trip (no repeats unless requested)  
* At least one award-winning restaurant per 3-day period  
* Balance of casual and upscale based on budget  
* Suggest OpenTable Experiences for special occasion days

### **4.3.3 Trip Calendar View**

* Calendar grid showing each day  
* Meal slots: Breakfast, Lunch, Dinner  
* Drag-and-drop to rearrange  
* Tap to book reservation or swap restaurant  
* Color coding: Booked (green), Suggested (yellow), Open (gray)

## **4.4 Extended Journey Mode (Local Explorer)**

For users exploring their own city over weeks or months.

* **Goal Setting:** "Visit all James Beard nominees in Milwaukee"  
* **Progress Tracking:** X of Y restaurants visited, % complete  
* **Neighborhood Focus:** Explore one area at a time  
* **Weekly Suggestions:** "This weekend, try these 3 spots in Bay View"  
* **Map View:** See visited (green), planned (yellow), unvisited (gray) pins

# **5\. OpenTable Integration**

## **5.1 Integration Overview**

OpenTable provides the reservation backbone and unique Experiences marketplace. The integration enables seamless booking within the Food Tour Butler app while surfacing special dining events that elevate the user experience beyond standard restaurant visits.

## **5.2 OpenTable Partner API**

### **5.2.1 API Access**

* **Portal:** dev.opentable.com  
* **Approval:** 3-4 week affiliate application process  
* **Sandbox:** Test environment available for development  
* **Authentication:** API key \+ OAuth 2.0 for user-linked bookings

### **5.2.2 Core Capabilities**

| Capability | Description |
| :---- | :---- |
| Restaurant Search | Find OpenTable restaurants by location, cuisine, price |
| Availability Check | Real-time table availability for date/time/party size |
| Reservation Booking | Create, modify, cancel reservations |
| Experiences Listing | Browse special menus, events, and prepaid experiences |
| Webhook Notifications | Real-time updates on booking confirmations/changes |

## **5.3 OpenTable Experiences**

OpenTable Experiences are special dining events beyond standard reservations. These are high-value, memorable occasions that align perfectly with Food Tour Butler's mission.

### **5.3.1 Experience Categories**

| Category | Examples | Typical Price |
| :---- | :---- | :---- |
| Tasting Menus | 5-7 course chef's menu | $85-$250 per person |
| Wine Pairings | Sommelier-curated pairings | $50-$150 add-on |
| Chef's Table | Kitchen-adjacent seating | $150-$400 per person |
| Prix-Fixe Dinner | 3-course set menu | $45-$95 per person |
| Special Events | Live jazz, holiday menus | $60-$200 per person |
| Happy Hour Deals | Discounted appetizers/drinks | $20-$40 per person |

### **5.3.2 Experience Integration Features**

* **Prominent Display:** "Special Experience Available" badge on restaurant cards  
* **Dedicated Browse:** "Experiences Near You" section on home screen  
* **Trip Suggestions:** AI recommends experiences for special occasion days  
* **Prepaid Checkout:** Book and pay within app, no check at restaurant  
* **Calendar Sync:** Add experience to phone calendar with details

## **5.4 Reservation Flow**

1\. User selects restaurant in tour2. App queries OpenTable for availability3. User selects date/time/party size4. If Experience available, show option to upgrade5. User confirms booking6. OpenTable processes reservation7. Webhook confirms back to app8. Confirmation added to tour itinerary9. Reminder notification before reservation

## **5.5 Fallback for Non-OpenTable Restaurants**

Not all restaurants are on OpenTable. For these, provide alternatives:

* **Phone Link:** One-tap call to restaurant  
* **Website Link:** Open restaurant's own booking page  
* **Resy/Yelp:** Deep link to alternative platforms (future)  
* **Manual Entry:** User marks as "booked" after calling

# **6\. Food Journal**

## **6.1 Journal Overview**

The Food Journal transforms Food Tour Butler from a planning tool into a lifelong culinary companion. Users log visits, capture photos, rate experiences, and build a personal food history that informs future recommendations and creates shareable memories.

## **6.2 Journal Entry Components**

| Component | Type | Description |
| :---- | :---- | :---- |
| Restaurant | Auto-linked | Connected to Foursquare venue |
| Visit Date/Time | Auto or manual | When user dined |
| Photos | Camera/gallery | Up to 10 photos per entry |
| Overall Rating | 1-5 stars | General experience rating |
| Dishes Tried | List with ratings | Individual dish names \+ mini ratings |
| Notes | Free text | Personal observations, memories |
| Tags | Multi-select | Date night, Business, Family, Solo |
| Would Return | Yes/No/Maybe | Quick indicator for future |
| Spend Amount | Currency input | Optional expense tracking |

## **6.3 Journal Entry Flow**

DURING VISIT:1. User marks stop as "Checked In" in live tour2. Prompt: "Add photos now or later?"3. Optional quick photo captureAFTER VISIT:1. Notification: "How was \[Restaurant\]?"2. Quick rating prompt (1-5 stars)3. Option to "Add Details" or "Done"DETAILED ENTRY (optional):1. Add/edit photos from camera roll2. Log specific dishes tried3. Write notes4. Add tags5. Mark "Would Return" status

## **6.4 Journal Views**

### **6.4.1 Timeline View**

* Chronological feed of all journal entries  
* Photo-forward cards with key details  
* Filter by date range, rating, city  
* Infinite scroll with lazy loading

### **6.4.2 Map View**

* All visited restaurants as pins on map  
* Pin color \= rating (red=1, green=5)  
* Tap pin to see mini journal card  
* Cluster pins when zoomed out

### **6.4.3 Trip View**

* Group entries by trip  
* Trip cover photo (auto or user-selected)  
* Trip stats: total spent, restaurants visited, top rated  
* Export trip as PDF or shareable link

### **6.4.4 Stats Dashboard**

* Total restaurants visited (all time)  
* Cities explored  
* Award-winning restaurants visited  
* Top cuisines by visit count  
* Monthly spending trends (if tracked)  
* Badges/achievements unlocked

# **7\. Social Sharing & Export**

## **7.1 Sharing Overview**

Food experiences are inherently social. Food Tour Butler makes it easy to share trips before (for planning), during (for updates), and after (for memories and recommendations).

## **7.2 Share Types**

| Share Type | Content | Use Case |
| :---- | :---- | :---- |
| Trip Itinerary | Planned restaurants \+ dates | Share with travel companions |
| Trip Recap | Completed trip with photos/ratings | Post-trip social sharing |
| Single Entry | One restaurant journal entry | Quick recommendation share |
| Public Profile | User's food stats \+ top picks | Food blogger portfolio |
| Live Trip | Real-time location during tour | Friends following along |

## **7.3 Share Destinations**

### **7.3.1 Native Share Sheet**

* Share to any app via system share  
* Generates shareable link \+ preview image  
* Copy link to clipboard

### **7.3.2 Instagram Stories**

* Auto-generate story-sized graphics  
* Trip highlight template with photos  
* Single dish spotlight template  
* "Now visiting" live update template

### **7.3.3 Export Formats**

* **PDF:** Beautiful trip report with photos, maps, notes  
* **CSV:** Spreadsheet of all entries (for expense reports)  
* **JSON:** Data export for power users/developers  
* **Photo Album:** Export all trip photos organized by restaurant

## **7.4 Public Trip Pages**

Users can make trips public, generating a web-viewable URL:

* **URL Format:** foodtourbutler.com/trip/abc123  
* **Content:** Map, restaurant list, photos, ratings (user controls what's visible)  
* **SEO:** Indexable for "Chicago food tour" searches  
* **Clone Trip:** Viewers can copy trip to their own account  
* **Embed:** Embed code for bloggers to include in posts

## **7.5 Privacy Controls**

* **Default:** All content private  
* **Per-Trip:** Set visibility (Private, Link-only, Public)  
* **Content Selection:** Choose which photos/notes to include in shares  
* **Spending Hidden:** Expense data never shared publicly

# **8\. Technical Architecture**

## **8.1 Technology Stack**

| Layer | Technology | Rationale |
| :---- | :---- | :---- |
| Mobile Client | Flutter 3.x | Cross-platform, hackathon requirement |
| Backend | Serverpod 2.x | Hackathon requirement, Dart full-stack |
| Database | PostgreSQL | Serverpod default, robust spatial support |
| Maps SDK | Mapbox GL | Free tier, beautiful styling, Flutter support |
| Places Data | Foursquare Places API | $200/mo free, rich restaurant data |
| Reservations | OpenTable Partner API | Industry standard, Experiences marketplace |
| Routing | Mapbox Directions API | Walking \+ driving, turn-by-turn |
| LLM | Groq (Llama 3.3 70B) | 14,400 req/day free, fastest inference |
| Real-time Search | Perplexity Sonar API | Current info with citations, $5/1K req |
| Image Storage | Cloudflare R2 | S3-compatible, generous free tier |
| Auth | Serverpod Auth | Built-in, supports social login |

## **8.2 Expanded Data Models**

### **8.2.1 Trip**

class Trip {  int id;  int userId;  String title;  String? description;  String tripType;              // 'single\_day', 'multi\_day', 'extended', 'quick\_pick'  String city;  String? state;  String country;  DateTime startDate;  DateTime? endDate;  double? lodgingLat, lodgingLng;  String? lodgingAddress;  String visibility;            // 'private', 'link\_only', 'public'  String? publicSlug;           // for shareable URLs  String? coverPhotoUrl;  DateTime createdAt;  DateTime updatedAt;  List\<TripDay\> days;  List\<JournalEntry\> entries;}

### **8.2.2 TripDay**

class TripDay {  int id;  int tripId;  DateTime date;  int dayNumber;               // Day 1, 2, 3...  String? theme;               // "Chinatown Day", "Anniversary"  bool isSpecialOccasion;  List\<MealSlot\> mealSlots;}

### **8.2.3 MealSlot**

class MealSlot {  int id;  int tripDayId;  String mealType;             // 'breakfast', 'lunch', 'dinner', 'snack'  String status;               // 'open', 'suggested', 'booked', 'completed'  int? restaurantId;  String? openTableConfirmation;  String? experienceId;        // OpenTable Experience ID  DateTime? reservationTime;  int? partySize;  List\<JournalEntry\>? entries;}

### **8.2.4 JournalEntry**

class JournalEntry {  int id;  int userId;  int? tripId;  int? mealSlotId;  String foursquareId;  String restaurantName;  double lat, lng;  DateTime visitedAt;  int rating;                  // 1-5  String? notes;  List\<String\> photoUrls;  List\<DishEntry\> dishes;  List\<String\> tags;           // \['date\_night', 'business', 'family'\]  String wouldReturn;          // 'yes', 'no', 'maybe'  double? spendAmount;  String? spendCurrency;  bool isPublic;  DateTime createdAt;}

### **8.2.5 DishEntry**

class DishEntry {  int id;  int journalEntryId;  String dishName;  int? rating;                 // 1-5  String? photoUrl;  String? notes;  bool isFavorite;}

# **9\. Award Integration**

## **9.1 Data Sources**

| Source | Data | Update Frequency |
| :---- | :---- | :---- |
| James Beard | Winners, nominees, semifinalists | Annual (June ceremony) |
| Michelin Guide | 1-3 stars, Bib Gourmand | Annual (varies by region) |

## **9.2 Scoring Algorithm**

Base Score: Foursquare rating (0-10) \* 10Award Bonuses:  James Beard Winner:        \+30 points  James Beard Nominee:       \+15 points  James Beard Semifinalist:  \+10 points  Michelin 3-Star:           \+50 points  Michelin 2-Star:           \+35 points  Michelin 1-Star:           \+25 points  Bib Gourmand:              \+15 pointsOpenTable Experience Available: \+5 points

# **10\. MVP Scope & Roadmap**

## **10.1 Hackathon MVP (P0)**

* Single-day tour generation (walking \+ driving)  
* Foursquare restaurant search  
* Mapbox map \+ directions  
* James Beard \+ Michelin award badges  
* LLM tour narratives  
* OpenTable deep links (reservation redirect)  
* Basic journal entry (rating \+ notes)

## **10.2 Post-Hackathon Phase 1 (P1) \- 4 weeks**

* OpenTable Partner API integration (in-app booking)  
* OpenTable Experiences browsing \+ booking  
* Multi-day trip mode (basic)  
* Photo journal with gallery  
* User accounts \+ saved trips

## **10.3 Phase 2 (P2) \- 8 weeks**

* Trip calendar view \+ drag/drop  
* Extended journey / Local Explorer mode  
* Dish logging with individual ratings  
* Public trip pages \+ shareable links  
* Instagram Stories export  
* PDF trip export

## **10.4 Phase 3 (P3) \- 12 weeks**

* Stats dashboard \+ achievements  
* Clone trip feature  
* Live trip sharing  
* Expense tracking \+ CSV export  
* Resy integration  
* AI personalization from journal history

# **11\. Demo Video Script (3 min)**

| Time | Content |
| :---- | :---- |
| 0:00-0:20 | Problem: Show traveler frustrated with multiple apps \- Yelp for discovery, OpenTable for booking, Notes for tracking |
| 0:20-0:40 | Intro: "Food Tour Butler \- your personal food concierge." Launch app, select Chicago, choose MULTI-DAY TRIP, enter dates |
| 0:40-1:00 | Trip Planning: Show calendar view, AI-suggested restaurants for each day, mix of cuisines and price points |
| 1:00-1:20 | Awards: Highlight James Beard winner for Day 2 dinner, show Michelin Bib Gourmand for Day 3 lunch |
| 1:20-1:40 | OpenTable Experience: Browse "Experiences Near You", find tasting menu event, book prepaid directly in app |
| 1:40-2:00 | Single-Day Tour: Switch to Day 1, generate walking food crawl with 4 stops, show route on map |
| 2:00-2:20 | Food Journal: After "visiting", log entry with photos, rate dishes, add notes |
| 2:20-2:40 | Share: Export trip recap, show beautiful PDF, demonstrate shareable public link |
| 2:40-2:55 | Tech Stack: Flutter \+ Serverpod \+ Foursquare \+ Mapbox \+ OpenTable \+ Groq |
| 2:55-3:00 | CTA: "From a single afternoon to a month-long journey \- Food Tour Butler remembers every bite." |

# **12\. Perplexity Sonar API Integration**

## **12.1 Why Perplexity?**

Static APIs (Foursquare, OpenTable) provide structured data but miss the dynamic, current context that makes food recommendations truly valuable. Perplexity's Sonar API combines real-time web search with LLM synthesis, delivering cited, up-to-date insights that transform Food Tour Butler from a route planner into an informed local guide.

## **12.2 Perplexity Sonar API Overview**

| Feature | Details |
| :---- | :---- |
| Endpoint | api.perplexity.ai/chat/completions |
| Models | Sonar (fast, lightweight) / Sonar Pro (complex queries) |
| Pricing \- Sonar | $5/1,000 requests \+ $1/1M input tokens \+ $1/1M output tokens |
| Pricing \- Sonar Pro | $5/1,000 requests \+ $3/1M input \+ $15/1M output tokens |
| Key Features | Real-time web access, citations, domain filtering, JSON mode |
| Pro Credit | $5/month included with Perplexity Pro subscription ($20/mo) |

## **12.3 Use Cases in Food Tour Butler**

| Use Case | Query Example | Value Added |
| :---- | :---- | :---- |
| Current Buzz | "What restaurants are hot in Chicago right now?" | Surfaces trending spots static data misses |
| Recent Openings | "New restaurant openings in Milwaukee last 3 months" | Catches venues not yet in Foursquare |
| Chef News | "Has the chef at \[restaurant\] changed recently?" | Flags when a venue's appeal may have shifted |
| Closures/Issues | "Is \[restaurant\] still open? Any recent issues?" | Prevents recommending closed/problematic venues |
| Seasonal Menus | "What seasonal dishes is \[restaurant\] serving now?" | Enables timely dish recommendations |
| Local Events | "Food festivals in Austin this week" | Incorporates pop-ups and events into tours |
| Award Updates | "2025 James Beard semifinalists in Texas" | Real-time award data before annual DB update |
| Local Context | "What makes Milwaukee's fish fry tradition unique?" | Enriches narratives with cultural depth |
| Blogger Recs | "Best tacos in San Diego according to food bloggers" | Incorporates influencer perspective |

## **12.4 User Flow Integration**

### **12.4.1 Tour Generation Flow (Enhanced)**

STEP 1: User inputs location \+ preferences  └─\> Foursquare: Get candidate restaurants (structured data)STEP 2: Perplexity enrichment (parallel)  └─\> Query: "What's hot in \[city\] food scene right now?        New openings, buzz-worthy spots, recent closures"  └─\> Returns: Trending restaurants, warnings, local eventsSTEP 3: Cross-reference \+ validation  └─\> Match Perplexity mentions to Foursquare venues  └─\> Flag any Foursquare picks that Perplexity reports as closed  └─\> Boost scores for venues mentioned positivelySTEP 4: Award data enrichment  └─\> James Beard / Michelin static data  └─\> Perplexity: "Any recent James Beard announcements for \[city\]?"STEP 5: Route optimization \+ narrative generation  └─\> Mapbox routing  └─\> Groq LLM narratives (enhanced with Perplexity context)STEP 6: Present tour with "Current Intel" section  └─\> Each stop includes recent news/buzz if available

### **12.4.2 "What's Hot" Discovery Feature**

A new home screen feature powered entirely by Perplexity:

* **Location:** Home screen card below "Start a Tour"  
* **Title:** "What's Hot in \[City\]" or "Local Intel"  
* **Content:** 3-5 trending restaurants/events with brief descriptions  
* **Sources:** Cited links to original articles (Perplexity citations)  
* **Refresh:** Daily cache, pull-to-refresh for fresh query  
* **Action:** Tap any item to add to tour or view details

### **12.4.3 Restaurant Detail Enhancement**

When viewing a restaurant's detail page, add a "Current Intel" section:

* **Trigger:** On-demand ("Get Latest Info" button) to conserve API calls  
* **Query:** "\[Restaurant name\] \[city\] recent news reviews 2025"  
* **Display:** Card with summary \+ expandable citations  
* **Includes:** Recent reviews sentiment, chef changes, menu updates, hours changes  
* **Warning Badge:** If negative news found (closure, health issues), show alert

### **12.4.4 Trip Planning Assistant**

For multi-day trips, Perplexity powers conversational planning:

* **Chat Interface:** "Ask the Butler" chat on trip planning screen  
* **Example Queries:**   
  * "What neighborhood should we focus on for dinner Friday?"  
  * "Any food festivals happening during my trip?"  
  * "What's the must-try dish at Alinea right now?"  
* **Response:** Cited answers with option to add suggestions to trip

## **12.5 UI Components**

### **12.5.1 "What's Hot" Home Card**

┌─────────────────────────────────────────┐│  🔥 What's Hot in Chicago               ││  ─────────────────────────────────────  ││                                         ││  📍 Kasama                              ││  "Michelin-starred Filipino, everyone's ││   talking about the longganisa"         ││  \[Eater Chicago\] \[Tribune\]              ││                                     \[+\] ││  ─────────────────────────────────────  ││  📍 Bonci                               ││  "Roman pizza master just opened,       ││   lines around the block"               ││  \[Chicago Magazine\]                     ││                                     \[+\] ││  ─────────────────────────────────────  ││  🎪 Taco Fest \- This Weekend            ││  "50+ vendors in Pilsen"                ││  \[Block Club Chicago\]                   ││                                     \[+\] ││                                         ││  Updated 2 hours ago    \[↻ Refresh\]     │└─────────────────────────────────────────┘

### **12.5.2 Restaurant Detail \- Current Intel Card**

┌─────────────────────────────────────────┐│  📰 Current Intel                       ││  ─────────────────────────────────────  ││                                         ││  ✓ Still open, no reported issues       ││                                         ││  Recent Highlights:                     ││  • New spring tasting menu launched     ││    March 2025 \[Eater\]                   ││  • Chef Sarah won Rising Star award     ││    \[James Beard Foundation\]             ││  • Wait times averaging 45min on        ││    weekends \[Yelp reviews\]              ││                                         ││  Sentiment: Mostly Positive (87%)       ││                                         ││  Last checked: Today at 3:42 PM         ││  Sources: 5 citations  \[View All →\]     │└─────────────────────────────────────────┘

### **12.5.3 Warning Alert (When Issues Found)**

┌─────────────────────────────────────────┐│  ⚠️  HEADS UP                           ││  ─────────────────────────────────────  ││                                         ││  Recent reports suggest this venue      ││  may have issues:                       ││                                         ││  • "Temporarily closed for renovation"  ││    \- Chicago Tribune, Jan 15            ││                                         ││  We recommend verifying before booking. ││                                         ││  \[Call Restaurant\]  \[Remove from Tour\]  │└─────────────────────────────────────────┘

### **12.5.4 Ask the Butler Chat Interface**

┌─────────────────────────────────────────┐│  🎩 Ask the Butler                      ││  Your AI food concierge                 ││  ─────────────────────────────────────  ││                                         ││  ┌─────────────────────────────────┐    ││  │ You: What neighborhood should   │    ││  │ we explore for our Saturday     │    ││  │ food crawl?                     │    ││  └─────────────────────────────────┘    ││                                         ││  ┌─────────────────────────────────┐    ││  │ Butler: Based on what's hot     │    ││  │ right now, I'd suggest Logan    │    ││  │ Square\! It has the highest      │    ││  │ concentration of buzz-worthy    │    ││  │ spots including:                │    ││  │                                 │    ││  │ • Giant \- recently featured in  │    ││  │   Bon Appétit \[1\]               │    ││  │ • Longman & Eagle \- new spring  │    ││  │   cocktail menu \[2\]             │    ││  │ • Fat Rice \- just reopened \[3\]  │    ││  │                                 │    ││  │ Sources: \[1\] \[2\] \[3\]            │    ││  │                                 │    ││  │ \[Create Logan Square Tour →\]    │    ││  └─────────────────────────────────┘    ││                                         ││  ┌─────────────────────────────────────┐││  │ Ask about your trip...           🎤 │││  └─────────────────────────────────────┘│└─────────────────────────────────────────┘

## **12.6 Technical Implementation**

### **12.6.1 API Call Structure**

// Perplexity Sonar API CallPOST https://api.perplexity.ai/chat/completionsHeaders:  Authorization: Bearer \<PERPLEXITY\_API\_KEY\>  Content-Type: application/jsonBody:{  "model": "sonar",  // or "sonar-pro" for complex queries  "messages": \[    {      "role": "system",      "content": "You are a local food expert. Provide concise,                   current information about restaurants and food                   scenes. Always cite sources."    },    {      "role": "user",       "content": "What restaurants are trending in Chicago right                   now? Include any new openings, recent closures,                   or notable chef changes in the last 3 months."    }  \],  "search\_domain\_filter": \[    "eater.com", "chicagotribune.com", "timeout.com",    "chicagomag.com", "blockclubchicago.org"  \],  "return\_citations": true,  "search\_recency\_filter": "month"}

### **12.6.2 Response Handling**

// Response includes citations{  "choices": \[{    "message": {      "content": "Several restaurants are generating buzz in                   Chicago right now:\\n\\n1. \*\*Kasama\*\* \- The                   Michelin-starred Filipino restaurant continues                   to draw crowds \[1\]\\n\\n2. \*\*Bonci\*\* \- Roman                   pizza legend just opened their Chicago                   location \[2\]..."    }  }\],  "citations": \[    "https://chicago.eater.com/kasama-review-2025",    "https://www.chicagomag.com/bonci-opening"  \]}// Parse and display with source linksclass PerplexityInsight {  String content;  List\<Citation\> citations;  DateTime fetchedAt;  String sentiment;  // 'positive', 'neutral', 'warning'}

### **12.6.3 Caching Strategy**

* **"What's Hot" queries:** Cache 24 hours per city  
* **Restaurant validation:** Cache 7 days per venue  
* **Local context:** Cache 30 days (cultural info rarely changes)  
* **Force refresh:** User can always pull-to-refresh  
* **Storage:** PostgreSQL with TTL, keyed by city \+ query type

## **12.7 Cost Estimation**

| Query Type | Est. Monthly Volume | Est. Cost |
| :---- | :---- | :---- |
| What's Hot (per city, daily) | 50 cities × 30 \= 1,500 | $7.50 |
| Tour generation enrichment | 2,000 tours × 1 \= 2,000 | $10.00 |
| Restaurant detail (on-demand) | 500 lookups | $2.50 |
| Ask the Butler chat | 1,000 queries (Sonar Pro) | $5.00 \+ tokens |
| TOTAL (early stage) | \~5,000 requests | \~$25-40/month |

*Note: Perplexity Pro subscription ($20/mo) includes $5 API credit, making early-stage costs very manageable. Scale costs with usage.*

# **13\. Appendix**

## **13.1 API Rate Limits**

| API | Free Tier | Est. Capacity |
| :---- | :---- | :---- |
| Foursquare Places | $200 credits/month | \~2,500 tour generations |
| Mapbox Directions | 100K requests/month | \~20,000 routes |
| Mapbox Maps | 50K loads/month | \~50,000 sessions |
| Groq LLM | 14,400 req/day | \~14,400 narratives/day |
| OpenTable | Partner tier (TBD) | Based on approval |
| Perplexity Sonar | $5/1K requests \+ tokens | \~5,000 queries/month @ $25 |
| Cloudflare R2 | 10GB storage free | \~50,000 photos |

## **13.2 Glossary**

| Term | Definition |
| :---- | :---- |
| Food Crawl | Multi-stop dining experience visiting several restaurants in one outing |
| Experience | OpenTable special event: tasting menu, wine pairing, chef's table, etc. |
| Trip | A collection of dining plans, can span one day to several months |
| Journal Entry | Record of a restaurant visit with photos, ratings, notes |
| Meal Slot | A designated meal time (breakfast, lunch, dinner) within a trip day |
| Bib Gourmand | Michelin designation for high-quality restaurants at moderate prices |

## **13.3 References**

* Foursquare Places API: https://docs.foursquare.com/developer/reference/places-api-overview  
* Mapbox APIs: https://docs.mapbox.com/api/  
* OpenTable Partner Portal: https://dev.opentable.com/  
* OpenTable Experiences: https://www.opentable.com/experiences  
* Groq API: https://console.groq.com/docs  
* Perplexity Sonar API: https://docs.perplexity.ai  
* James Beard Data: https://github.com/cjwinchester/james-beard  
* Michelin Data: https://www.kaggle.com/datasets/ngshiheng/michelin-guide-restaurants-2021  
* Serverpod Documentation: https://docs.serverpod.dev  
* Flutter Documentation: https://docs.flutter.dev

*— End of Document —*