Let me read through the PRD to see the full picture of what you're building.Let me see the middle section with the features and data models:Excellent. Now I see the full picture. You've got a robust functional PRD (trips, tours, reservations, journaling) and a soul-driven mission document. My "Counter Seat" UX concept was the aesthetic and interaction philosophy. Let me synthesize all three into **one cohesive UX vision** for Food Tour Butler.

---

## Food Tour Butler: Unified UX Design System

### The Synthesis Challenge

| Document | Contributes |
| :---- | :---- |
| **PRD** | Features, modes, data models, API architecture |
| **Mission** | Philosophy, differentiators, why this matters |
| **Counter Seat** | Visual language, interaction patterns, editorial voice |

The goal: Make the functional features (tours, trips, journals, reservations) *feel* like the mission (story-first, anti-algorithm, human connection) *through* the aesthetic (editorial, warm, opinionated).

---

## Design Principles

**1\. Story Before Stars** Every screen leads with narrative, not ratings. A restaurant is introduced by *who's behind it* before *how many stars it has*.

**2\. Dignified Utility** The app does serious work (routing, booking, journaling) but never feels transactional. Even the calendar view has warmth.

**3\. Earned Complexity** Simple surfaces reveal depth. A restaurant card looks minimal; tap and layers unfold. Experts get power; newcomers aren't overwhelmed.

**4\. The Butler Persona** The app has a voice — knowing, warm, slightly irreverent. Not a chatbot, but a consistent editorial tone throughout.

---

## Visual Design System

### Color Palette

```
Background (Primary):    #1A1A1A  (Deep charcoal, like a dimly-lit bar)
Background (Secondary):  #242424  (Card surfaces)
Text (Primary):          #F5F0E6  (Warm cream)
Text (Secondary):        #A89F91  (Muted warm gray)
Accent (Primary):        #E85A3D  (Burnt orange — the sear on a steak)
Accent (Secondary):      #C9A962  (Aged brass — like vintage fixtures)
Success/Booked:          #4A7C59  (Deep sage green)
Warning:                 #D4A84B  (Amber)
Award Badges:
  - James Beard:         #B8860B  (Old gold)
  - Michelin:            #8B0000  (Deep burgundy)
  - Bib Gourmand:        #CD5C5C  (Soft red)
```

### Typography

| Use | Font | Weight | Size |
| :---- | :---- | :---- | :---- |
| Headlines / Restaurant names | **Playfair Display** (serif) | Bold | 24-32pt |
| Section headers | **Inter** (sans) | SemiBold | 18-20pt |
| Body / Narratives | **Inter** | Regular | 15-16pt |
| Labels / Meta | **Inter** | Medium | 12-13pt |
| The Butler (AI voice) | **Playfair Display** | Italic | 16pt |

### Iconography

Custom line icons with 1.5px stroke. Warm, hand-drawn quality. Food-specific: knife, flame, plate, glass, map pin with fork.

### Photography Philosophy

No food styling. Real steam. Real hands. Imperfect lighting. If a photo looks like it came from a PR agency, it doesn't belong.

---

## Screen-by-Screen UX

### 1\. Onboarding (Revised for Mission Alignment)

**Not:** "What cuisines do you like?"  
**Instead:** Establish the user's *relationship* with food.

**Screen 1: The Philosophy Check**

```
┌─────────────────────────────────────────┐
│                                         │
│    "Food Tour Butler"                   │
│    [Elegant logo mark]                  │
│                                         │
│    Before we begin —                    │
│                                         │
│    Which matters more to you?           │
│                                         │
│    ┌─────────────────────────────────┐  │
│    │  The story behind the dish      │  │
│    └─────────────────────────────────┘  │
│                                         │
│    ┌─────────────────────────────────┐  │
│    │  The dish itself                │  │
│    └─────────────────────────────────┘  │
│                                         │
│    (Both answers are welcome here)      │
│                                         │
└─────────────────────────────────────────┘
```

**Screen 2: Adventure Calibration**

```
┌─────────────────────────────────────────┐
│                                         │
│    When you travel, you tend to:        │
│                                         │
│    ○ Find the places locals love        │
│    ○ Hit the landmarks, then explore    │
│    ○ Let serendipity guide you          │
│    ○ Research obsessively beforehand    │
│                                         │
│    [This sets Serendipity Engine level] │
│                                         │
└─────────────────────────────────────────┘
```

**Screen 3: Cuisine Comfort Map** A visual grid — not flags, but *ingredient photographs* (miso paste, olive oil, corn masa, gochujang). Tap to indicate familiarity. Unfamiliar ones glow slightly, inviting.

---

### 2\. Home Screen: "The Daily Briefing"

This is where Counter Seat meets the PRD. Not a list of options — a curated *editorial spread*.

```
┌─────────────────────────────────────────┐
│  ☰                    Milwaukee      🔔 │
│─────────────────────────────────────────│
│                                         │
│  Good evening, Tarik.                   │
│                                         │
│  ┌─────────────────────────────────────┐│
│  │ [Full-bleed photo: hands making    ││
│  │  fresh pasta, flour dusted]        ││
│  │                                     ││
│  │  TODAY'S STORY                      ││
│  │  ─────────────                      ││
│  │  The Sicilian Butcher's            ││
│  │  Granddaughter                      ││
│  │                                     ││
│  │  "She learned to break down a      ││
│  │   whole pig before she could       ││
│  │   read. Now she's redefining       ││
│  │   Milwaukee's meat scene."         ││
│  │                                     ││
│  │  Bavette La Boucherie              ││
│  │  ★ James Beard Semifinalist '25    ││
│  │                                     ││
│  │          Read the Story →          ││
│  └─────────────────────────────────────┘│
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  YOUR ACTIVE TRIP                       │
│  Chicago — Feb 14-17                    │
│  ┌───────┬───────┬───────┬───────┐     │
│  │ Fri   │ Sat   │ Sun   │ Mon   │     │
│  │ 2/3   │ 1/3   │ 0/3   │ 0/2   │     │
│  │ meals │ meals │ meals │ meals │     │
│  └───────┴───────┴───────┴───────┘     │
│         Continue Planning →             │
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  🔥 WHAT'S HOT THIS WEEK               │
│  ←  [Kasama] [Bonci] [Uncle Nearest] → │
│     (horizontal scroll cards)           │
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  QUICK ACTIONS                          │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐   │
│  │ 🍽️      │ │ 📍      │ │ 🎩      │   │
│  │ Start a │ │ Where   │ │ Ask the │   │
│  │ Tour    │ │ Tonight │ │ Butler  │   │
│  └─────────┘ └─────────┘ └─────────┘   │
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  FROM YOUR JOURNAL                      │
│  "You visited 3 spots last week.        │
│   One favorite: the pork belly at       │
│   Goodkind. Care to note why?"          │
│                        Add Memory →     │
│                                         │
└─────────────────────────────────────────┘
│  [Home]  [Trips]  [Journal]  [Profile]  │
└─────────────────────────────────────────┘
```

**Key UX Decisions:**

- **The Daily Story** — Powered by Perplexity \+ Groq. One featured restaurant with narrative, refreshed daily. This is the "Bourdain hook."  
- **Active Trip** — If user has a trip in progress, it's front and center. Progress visualization.  
- **What's Hot** — Perplexity's real-time intel, horizontal scroll.  
- **Quick Actions** — The three primary flows: Tour, Quick Pick, Butler Chat.  
- **Journal Prompt** — Gentle nudge to complete entries, personalized.

---

### 3\. Trip Planning Mode (Multi-Day)

**Trip Setup Flow:**

```
┌─────────────────────────────────────────┐
│  ←  New Trip                            │
│─────────────────────────────────────────│
│                                         │
│  Where to?                              │
│  ┌─────────────────────────────────────┐│
│  │ Chicago                          ✓ ││
│  └─────────────────────────────────────┘│
│                                         │
│  When?                                  │
│  ┌────────────────┐ ┌────────────────┐ │
│  │ Feb 14, 2026   │ │ Feb 17, 2026   │ │
│  │ Friday         │→│ Monday         │ │
│  └────────────────┘ └────────────────┘ │
│  4 days                                 │
│                                         │
│  Where are you staying?                 │
│  ┌─────────────────────────────────────┐│
│  │ 📍 The Hoxton, Fulton Market     ✎ ││
│  └─────────────────────────────────────┘│
│  (We'll suggest spots nearby)           │
│                                         │
│  What's the vibe?                       │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐   │
│  │ 💼      │ │ ❤️      │ │ 🧭      │   │
│  │Business │ │Romance  │ │Adventure│   │
│  │ Trip    │ │ Weekend │ │ Quest   │   │
│  │    ○    │ │    ●    │ │    ○    │   │
│  └─────────┘ └─────────┘ └─────────┘   │
│                                         │
│  Any special occasions?                 │
│  ┌─────────────────────────────────────┐│
│  │ ✓ Anniversary dinner (Feb 14)       ││
│  │   The Butler will suggest something ││
│  │   exceptional.                       ││
│  └─────────────────────────────────────┘│
│                                         │
│           [Let the Butler Plan]         │
│                                         │
└─────────────────────────────────────────┘
```

**Trip Calendar View:**

```
┌─────────────────────────────────────────┐
│  ←  Chicago Trip         ⋮  Share  Edit │
│  Feb 14-17, 2026 · Romance Weekend      │
│─────────────────────────────────────────│
│                                         │
│  ┌─────────────────────────────────────┐│
│  │ Fri, Feb 14 · ANNIVERSARY           ││
│  │─────────────────────────────────────││
│  │                                     ││
│  │ Dinner · 7:30 PM                    ││
│  │ ┌─────────────────────────────────┐ ││
│  │ │ [Photo]  Alinea                 │ ││
│  │ │          ★★★ Michelin           │ ││
│  │ │          🎟️ EXPERIENCE BOOKED    │ ││
│  │ │          20-course tasting      │ ││
│  │ │          $395/person · Prepaid  │ ││
│  │ │                                 │ ││
│  │ │  "Grant Achatz's temple of      │ ││
│  │ │   molecular gastronomy..."      │ ││
│  │ │                     Read More → │ ││
│  │ └─────────────────────────────────┘ ││
│  └─────────────────────────────────────┘│
│                                         │
│  ┌─────────────────────────────────────┐│
│  │ Sat, Feb 15                         ││
│  │─────────────────────────────────────││
│  │                                     ││
│  │ Breakfast · Open                    ││
│  │ ┌─────────────────────────────────┐ ││
│  │ │  ＋ Add a spot                   │ ││
│  │ │    or let Butler suggest        │ ││
│  │ └─────────────────────────────────┘ ││
│  │                                     ││
│  │ Lunch · Suggested                   ││
│  │ ┌─────────────────────────────────┐ ││
│  │ │ [Photo]  Kasama                 │ ││
│  │ │          ★ Michelin · Filipino  │ ││
│  │ │          "The longganisa is     │ ││
│  │ │           transcendent"         │ ││
│  │ │                                 │ ││
│  │ │  [Book] [Swap] [Remove]         │ ││
│  │ └─────────────────────────────────┘ ││
│  │                                     ││
│  │ Dinner · Suggested                  ││
│  │ ┌─────────────────────────────────┐ ││
│  │ │ [Photo]  Girl & The Goat        │ ││
│  │ │          JB Winner · American   │ ││
│  │ │          "Stephanie Izard's     │ ││
│  │ │           flagship remains..."  │ ││
│  │ │                                 │ ││
│  │ │  [Book] [Swap] [Remove]         │ ││
│  │ └─────────────────────────────────┘ ││
│  └─────────────────────────────────────┘│
│                                         │
│  [  View Full Day as Tour  ]            │
│                                         │
└─────────────────────────────────────────┘
```

**Interaction Notes:**

- **Drag to reorder** meals or swap days  
- **Swipe left** on a restaurant to remove  
- **Tap the card** to see full restaurant profile  
- **Status colors:** Booked (sage green), Suggested (amber), Open (muted)  
- **"View as Tour"** converts a single day into the route-optimized Single-Day Tour flow

---

### 4\. Restaurant Profile: "The Dossier"

This is the **soul of the app** — where the Bourdain/Brown philosophy lives.

```
┌─────────────────────────────────────────┐
│  ←                                   ♡  │
│─────────────────────────────────────────│
│                                         │
│  [Full-bleed hero: the kitchen,         │
│   chef's hands plating, steam rising]   │
│                                         │
│  Kasama                                 │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━          │
│  "Filipino soul, Chicago ambition"       │
│                                         │
│  ★ Michelin Star · 📍 West Town         │
│  $$$$ · Filipino · Tasting Menu         │
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  THE STORY                              │
│  ─────────                              │
│                                         │
│  Timothy Flores grew up watching his    │
│  grandmother make longanisa in their    │
│  California kitchen. She never wrote    │
│  down recipes — "You learn by tasting," │
│  she'd say.                             │
│                                         │
│  Decades later, after staging at Alinea │
│  and Quay in Sydney, Flores returned    │
│  to those flavors. Kasama — "together"  │
│  in Tagalog — opened in 2020 with his   │
│  wife Genie Kwon. By 2022, it was       │
│  Chicago's first Filipino restaurant    │
│  to earn a Michelin star.               │
│                                         │
│  "We're not trying to be fine dining    │
│   Filipino," Flores told Eater.         │
│   "We're trying to be us."              │
│                                         │
│  Sources: Eater, Chicago Tribune        │
│                        Full Story →     │
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  WHY THIS MATTERS                       │
│  (The Alton Brown Section)              │
│  ─────────                              │
│                                         │
│  ┌─────────────────────────────────────┐│
│  │ 🔬 On Filipino Cuisine              ││
│  │                                     ││
│  │ Filipino food is often called the   ││
│  │ "original fusion" — centuries of    ││
│  │ Spanish, Chinese, Malay, and        ││
│  │ American influence layered over     ││
│  │ indigenous techniques.              ││
│  │                                     ││
│  │ The balance of sour (suka), sweet,  ││
│  │ and umami defines the palate.       ││
│  │ Notice how Kasama uses calamansi    ││
│  │ where a French kitchen might use    ││
│  │ lemon — same acid function, but     ││
│  │ floral, distinct.                   ││
│  └─────────────────────────────────────┘│
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  THE ORDER                              │
│  (What people actually get)             │
│  ─────────                              │
│                                         │
│  ┌─────────────────────────────────────┐│
│  │ Longganisa                          ││
│  │ "The reason you came. Sweet, garlicky,│
│  │  made in-house. Ask for extra rice." ││
│  │                     — @chitown.eats  ││
│  └─────────────────────────────────────┘│
│  ┌─────────────────────────────────────┐│
│  │ Ube Crinkle Cookie (bakery)         ││
│  │ "Even if you skip the tasting menu, ││
│  │  hit the morning bakery for this."  ││
│  │                     — @marcus_mke   ││
│  └─────────────────────────────────────┘│
│                                         │
│         What to skip →                  │
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  📰 CURRENT INTEL                       │
│  Updated 3 hours ago                    │
│  ─────────                              │
│                                         │
│  ✓ Open, no recent issues               │
│  • Spring tasting menu just launched    │
│    [Eater Chicago]                      │
│  • Weekend brunch wait: ~45 min         │
│  • Sentiment: Overwhelmingly Positive   │
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  THE INTEL                              │
│  (Practical knowledge)                  │
│  ─────────                              │
│                                         │
│  Best time    Tues-Thurs dinner         │
│  Skip         Weekend brunch (chaos)    │
│  Best seat    Bar, to watch the line    │
│  Booking      2-3 weeks out for dinner  │
│  Parking      Street only. Uber.        │
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  OPENABLE EXPERIENCES                   │
│  ─────────                              │
│  ┌─────────────────────────────────────┐│
│  │ 🎟️ Tasting Menu Experience          ││
│  │    12 courses · $185/person         ││
│  │    Prepaid · Includes beverage pair ││
│  │                                     ││
│  │    [Check Availability]             ││
│  └─────────────────────────────────────┘│
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│        [Add to Trip]   [Book Now]       │
│                                         │
└─────────────────────────────────────────┘
```

**Sections Breakdown:**

| Section | Source | Purpose |
| :---- | :---- | :---- |
| **The Story** | Perplexity \+ Groq synthesis | Emotional hook, human connection |
| **Why This Matters** | Perplexity \+ Groq | Alton Brown-style education |
| **The Order** | Community submissions | Practical guidance, trusted voices |
| **Current Intel** | Perplexity real-time | Dynamic freshness, warnings |
| **The Intel** | Community \+ Foursquare | Practical logistics |
| **Experiences** | OpenTable API | Premium booking upsell |

---

### 5\. Single-Day Tour: "The Journey"

When a user generates a walking/driving tour:

```
┌─────────────────────────────────────────┐
│  ←  Your Tour                     📤    │
│  Saturday in Logan Square               │
│─────────────────────────────────────────│
│                                         │
│  ┌─────────────────────────────────────┐│
│  │         [MAP VIEW]                  ││
│  │    • ─ ─ • ─ ─ • ─ ─ •              ││
│  │    1     2     3     4              ││
│  │                                     ││
│  │    Walking · 2.4 mi total           ││
│  │    Est. 4 hours with meals          ││
│  └─────────────────────────────────────┘│
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  THE NARRATIVE                          │
│  ─────────                              │
│                                         │
│  "Logan Square was once a Norwegian     │
│   enclave, then Puerto Rican, now a     │
│   kaleidoscope. This tour traces that   │
│   evolution through four kitchens —     │
│   each one a different chapter of the   │
│   neighborhood's story."                │
│                                         │
│            Listen to Introduction 🎧    │
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  STOP 1 · 12:00 PM                      │
│  ┌─────────────────────────────────────┐│
│  │ [Photo]                             ││
│  │ L'Patron                            ││
│  │ Tacos · $$ · JB Semifinalist        ││
│  │                                     ││
│  │ "Start light. The carnitas taco     ││
│  │  here is a masterclass in fat       ││
│  │  and acid balance."                 ││
│  │                                     ││
│  │ Get: Carnitas, Al Pastor            ││
│  │ Skip: Quesadilla (ordinary)         ││
│  │                                     ││
│  │        [Mark Visited]               ││
│  └─────────────────────────────────────┘│
│                                         │
│      ↓ 8 min walk · 0.4 mi              │
│        [View Directions]                │
│                                         │
│  STOP 2 · 12:45 PM                      │
│  ┌─────────────────────────────────────┐│
│  │ [Photo]                             ││
│  │ Spinning J                          ││
│  │ Bakery + Soda Fountain · $          ││
│  │                                     ││
│  │ "Palate cleanser. Get an egg cream  ││
│  │  and a slice of whatever pie        ││
│  │  they're pushing today."            ││
│  │                                     ││
│  │ Get: Egg cream, daily pie           ││
│  │                                     ││
│  │        [Mark Visited]               ││
│  └─────────────────────────────────────┘│
│                                         │
│      ↓ 12 min walk · 0.6 mi             │
│                                         │
│  STOP 3 · 1:30 PM                       │
│  ...                                    │
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  [  Start This Tour  ]                  │
│                                         │
└─────────────────────────────────────────┘
```

**Active Tour Mode:** When user taps "Start This Tour," the interface shifts:

- Map becomes primary (full-screen toggle)  
- Current stop highlighted  
- "Next stop" directions always one tap away  
- Documentary Mode: "Listen to this stop's story" (Groq-generated, Perplexity-enriched audio via TTS)  
- After leaving each stop: Journal prompt ("How was L'Patron? Quick rate or add notes later")

---

### 6\. Food Journal: "Your Travels"

```
┌─────────────────────────────────────────┐
│  Journal                          ⋯     │
│─────────────────────────────────────────│
│                                         │
│  [Timeline] [Map] [Trips] [Stats]       │
│      ●                                  │
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  THIS WEEK                              │
│                                         │
│  ┌─────────────────────────────────────┐│
│  │ [Photo grid: 3 dishes]              ││
│  │                                     ││
│  │ Kasama                              ││
│  │ Saturday, Feb 8 · Dinner            ││
│  │ ★★★★★                               ││
│  │                                     ││
│  │ "The ube cookie alone was worth     ││
│  │  the trip. Tasting menu delivered   ││
│  │  on every level. Would return in    ││
│  │  a heartbeat."                      ││
│  │                                     ││
│  │ Dishes: Longganisa ★★★★★            ││
│  │         Kare-Kare ★★★★☆             ││
│  │                                     ││
│  │ 💰 $412 · 🏷️ Anniversary            ││
│  └─────────────────────────────────────┘│
│                                         │
│  ┌─────────────────────────────────────┐│
│  │ [Photo]                             ││
│  │                                     ││
│  │ L'Patron                            ││
│  │ Saturday, Feb 8 · Lunch             ││
│  │ ★★★★☆                               ││
│  │                                     ││
│  │ "Solid. Carnitas lived up to hype." ││
│  │                                     ││
│  └─────────────────────────────────────┘│
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  LAST WEEK                              │
│  ...                                    │
│                                         │
└─────────────────────────────────────────┘
```

**Journal Entry Flow (Post-Visit):**

Notification 2 hours after check-in:

"How was Kasama? 🎉"

Tap opens quick-entry:

```
┌─────────────────────────────────────────┐
│  Kasama · Feb 8                         │
│─────────────────────────────────────────│
│                                         │
│  How was it?                            │
│  ★ ★ ★ ★ ★                              │
│      (tap to rate)                      │
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  Add photos                             │
│  ┌─────┐ ┌─────┐ ┌─────┐               │
│  │ +   │ │     │ │     │               │
│  └─────┘ └─────┘ └─────┘               │
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  Would you return?                      │
│  [Absolutely] [Maybe] [Nope]            │
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  [Save & Done]   [Add More Details]     │
│                                         │
└─────────────────────────────────────────┘
```

"Add More Details" expands to: dish logging, notes, tags, spend amount.

---

### 7\. Ask the Butler: Conversational Intelligence

The Butler isn't a chatbot — it's a **concierge with opinions**.

```
┌─────────────────────────────────────────┐
│  🎩 Ask the Butler                      │
│─────────────────────────────────────────│
│                                         │
│  ┌─────────────────────────────────────┐│
│  │ You: I'm in Chicago for one night.  ││
│  │ Want something memorable but not    ││
│  │ crazy expensive. Surprise me.       ││
│  └─────────────────────────────────────┘│
│                                         │
│  ┌─────────────────────────────────────┐│
│  │ 🎩 Butler:                          ││
│  │                                     ││
│  │ One night. No pressure.             ││
│  │                                     ││
│  │ Skip Alinea — it's extraordinary,   ││
│  │ but it's a 3-hour commitment and    ││
│  │ your wallet will need therapy.      ││
│  │                                     ││
│  │ Instead: Giant in Logan Square.     ││
│  │ Michelin Bib Gourmand. Jason        ││
│  │ Vincent's pasta is obscene in the   ││
│  │ best way. The agnolotti will        ││
│  │ haunt you. $60-80/person with wine. ││
│  │                                     ││
│  │ If you're feeling bold, start the   ││
│  │ evening at Scofflaw next door —     ││
│  │ gin cocktails, taxidermy, no        ││
│  │ pretense.                           ││
│  │                                     ││
│  │ Sources: Eater [1], Bon Appétit [2] ││
│  │                                     ││
│  │ [Add Giant to Trip]                 ││
│  │ [Tell Me More About Giant]          ││
│  │ [Different Vibe]                    ││
│  └─────────────────────────────────────┘│
│                                         │
│  ┌─────────────────────────────────────┐│
│  │ Ask about your trip...           🎤 ││
│  └─────────────────────────────────────┘│
│                                         │
└─────────────────────────────────────────┘
```

**Butler Persona Guidelines:**

- Warm but not obsequious  
- Has opinions, will share them  
- Never says "I think you might enjoy..." — says "Go here."  
- Occasionally irreverent  
- Cites sources but doesn't lecture about them  
- Can decline: "I don't know enough about Topeka to be useful. Let me look into it."

---

### 8\. Serendipity Engine: The Adventure Card

On Home Screen, periodically:

```
┌─────────────────────────────────────────┐
│  🎲 THE ADVENTURE                       │
│─────────────────────────────────────────│
│                                         │
│  You've eaten Thai 8 times this month.  │
│  You've never tried Burmese.            │
│                                         │
│  Ruby's Café — a tea leaf salad that    │
│  will reset your palate.                │
│  12 minutes from you. $15 per person.   │
│                                         │
│  [Take Me There]    [Not Today]         │
│                                         │
└─────────────────────────────────────────┘
```

Or during Multi-Day Trip planning:

"Day 3 is wide open. I slipped in something you wouldn't pick yourself — Kie-Gol-Lanee in Pilsen. Thai-Mexican by a James Beard semifinalist. Trust me."

---

## Microinteractions & Polish

| Moment | Interaction |
| :---- | :---- |
| **Loading tour** | Knife rocks back and forth, chopping |
| **Reservation confirmed** | Gentle "clink" sound (glasses toasting) |
| **Adding to journal** | Photo slides into a polaroid stack |
| **Marking stop visited** | Pin transforms from outline to filled with soft bounce |
| **Butler thinking** | Three dots, but styled as steam wisps rising |
| **Award badge hover** | Badge pulses softly, reveals context on tap |
| **Empty state (no trips)** | "Your passport is empty. Let's fill it." with passport illustration |
| **Error state** | "We got lost. Even Bourdain got lost sometimes." |

---

## Component Library Summary (Flutter)

| Component | Description |
| :---- | :---- |
| `StoryCard` | Full-bleed editorial card (hero image \+ narrative hook) |
| `RestaurantTile` | Compact restaurant card for lists/grids |
| `AwardBadge` | JB / Michelin / Bib Gourmand with context tooltip |
| `MealSlotCard` | Day planner slot (open/suggested/booked states) |
| `JournalEntry` | Photo-forward card with rating, notes preview |
| `OrderItem` | Community recommendation with attribution |
| `IntelCard` | Current info card with citation links |
| `ButlerBubble` | Chat message with persona styling |
| `AdventurePrompt` | Serendipity engine card with CTA |
| `TourTimeline` | Vertical journey with stops and walking times |
| `QuickRatingSheet` | Bottom sheet for post-visit micro-journal |

---

## Next Steps

Want me to:

1. **Create a Figma-ready component spec** with exact spacing, shadows, and states?  
2. **Draft the Perplexity prompt templates** for Story generation, Why This Matters, and Current Intel?  
3. **Write the Serverpod endpoint contracts** for the Butler and Perplexity integration layer?  
4. **Mock up the Flutter widget tree** for the Restaurant Profile screen?

