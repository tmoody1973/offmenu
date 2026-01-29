# Off Menu — Your Personal Food Butler

> "Every meal has a story. Let the Butler help you find yours."

## What is Off Menu?

Off Menu is an AI-powered food discovery app that acts as your **personal Food Butler** — a knowledgeable, opinionated guide to restaurants that goes beyond ratings and reviews to help you find meals that actually matter.

Unlike traditional restaurant apps that overwhelm you with endless lists and star ratings, Off Menu takes an editorial approach. Think of it as having a well-traveled friend who knows every hidden gem in town and can answer questions like:

- *"Where do the kitchen workers eat after their shift?"*
- *"I want to understand mole"*
- *"Take me somewhere I'd never pick myself"*

## The Butler Experience

### Ask the Butler
The heart of Off Menu is the AI-powered Butler — powered by Perplexity AI. Ask natural questions and get thoughtful, context-aware responses with real restaurant recommendations. The Butler doesn't just search; it **understands intent**:

- Discovery queries ("find tacos near me") show an interactive map
- Information queries ("what should I order at Ruta's?") focus on the answer
- The Butler speaks with personality — witty, opinionated, like a trusted friend

### The Daily
Every day, Off Menu curates an editorial experience:

- **Lead Story** — A narrative about a restaurant, chef, or food moment in your city
- **Three for Tonight** — Context-aware picks based on weather, time, and your history
- **The Adventure** — A challenge to try something new based on your eating patterns

### Your Food Journal
Track your culinary journey with a personal journal. Save restaurants, log visits, and build your own food story over time.

### Custom Maps
Create and share curated restaurant collections — your personal guide to "Best Tacos in Milwaukee" or "Date Night Spots."

## Technical Implementation

### Full-Stack Dart
Off Menu is built entirely in Dart — **Flutter** for the frontend and **Serverpod** for the backend. This enables:

- Shared type-safe models between client and server
- Seamless code generation with `serverpod generate`
- Unified development experience

### Serverpod Cloud Deployment
The backend runs on **Serverpod Cloud** with:
- Managed PostgreSQL database
- Automatic migrations on deploy
- Secrets management for API keys
- Production URL: `https://offmenu.api.serverpod.space`

### AI Integration
- **Perplexity AI** for intelligent restaurant discovery and natural language understanding
- **Google Places API** for location data, photos, and place details
- Context-aware responses that adapt to query intent

### Key Features
- Google Sign-In authentication via `serverpod_auth_idp`
- Real-time "Three for Tonight" picks based on weather and time
- Responsive design — works beautifully on mobile and desktop
- Save/unsave restaurants with source tracking
- Editorial typography using Literata (serif) and DM Sans

## Why Off Menu?

**The Problem:** Finding a restaurant shouldn't feel like homework. Yelp gives you 500 results. Google Maps shows the nearest option. Neither helps you discover something meaningful.

**The Solution:** Off Menu is a Butler, not a database. It curates, recommends, and tells stories. It knows that the best meal isn't always the highest-rated — sometimes it's the 22-year-old Laotian grandmother in a strip mall who hasn't changed her larb recipe since 2002.

**The Impact:** Off Menu transforms dining from a utilitarian decision into an adventure. It helps users:
- Discover hidden gems they'd never find otherwise
- Break out of eating ruts with personalized challenges
- Build a meaningful record of their food journey
- Support local restaurants that deserve attention

## Live Demo

- **Frontend:** https://offmenu-two.vercel.app
- **Backend API:** https://offmenu.api.serverpod.space
- **GitHub:** https://github.com/tmoody1973/offmenu

## Built With

- Flutter 3.x (Web)
- Serverpod 3.2.x
- Serverpod Cloud
- Serverpod Auth IDP (Google Sign-In)
- Perplexity AI API
- Google Places API
- Vercel (Frontend hosting)
- PostgreSQL (via Serverpod Cloud)

---

*Off Menu — Because the best restaurants aren't always on the menu.*
