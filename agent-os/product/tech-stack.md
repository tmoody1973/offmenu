# Tech Stack

## Framework and Runtime

| Layer | Technology | Rationale |
|-------|------------|-----------|
| Mobile/Web Client | Flutter 3.x | Cross-platform (iOS, Android, Web) with single codebase |
| Backend | Serverpod 2.x | Dart full-stack, type-safe API generation, built-in auth |
| Language | Dart | Unified language for client and server, strong typing |
| Package Manager | pub (Dart) | Standard Dart package manager |

## Database and Storage

| Component | Technology | Rationale |
|-----------|------------|-----------|
| Primary Database | PostgreSQL | Serverpod default, robust spatial support for geo queries |
| ORM | Serverpod ORM | Built-in with Serverpod, type-safe Dart models |
| Image Storage | Cloudflare R2 | S3-compatible, generous free tier (10GB), low egress costs |
| Caching | PostgreSQL (TTL-based) | Simple caching for Perplexity responses, keyed by query type |

## Maps and Location

| Component | Technology | Rationale |
|-----------|------------|-----------|
| Maps SDK | Mapbox Maps Flutter SDK | Official Flutter SDK, native integration, beautiful styling |
| Directions/Routing | Mapbox Directions API | Walking + driving modes, turn-by-turn navigation |
| Geocoding | Mapbox Geocoding API | Address search and reverse geocoding |
| Geolocation | Platform Geolocation | Native location services (GPS, network) |
| Geofencing | Platform Geofencing APIs | Location-triggered stories in Documentary Mode |

## AI and Language Models

| Component | Technology | Rationale |
|-----------|------------|-----------|
| Restaurant Research | Perplexity Sonar API | Real-time web search, citations, current information |
| Story Generation | Perplexity Sonar Pro | Complex narrative synthesis for restaurant stories |
| Dish-Level Search | Perplexity Sonar API | Natural language dish queries with cited results |
| Complex Queries | Perplexity Sonar Pro | Multi-step reasoning for Ask the Butler chat |
| Backup/Narratives | Groq (Llama 3.3 70B) | Fast inference, 14,400 req/day free tier |

## Audio and Media

| Component | Technology | Rationale |
|-----------|------------|-----------|
| Text-to-Speech | ElevenLabs or Google Cloud TTS | Natural-sounding narration for Documentary Mode |
| Audio Playback | just_audio (Flutter) | Cross-platform audio player with streaming support |
| Image Processing | Cloudflare Images (optional) | Thumbnail generation, format optimization |

## External Data APIs

| Component | Technology | Rationale |
|-----------|------------|-----------|
| Restaurant Data | Google Places API | Rich metadata, photos, hours, ratings |
| Reservations | OpenTable Partner API | Industry standard, Experiences marketplace |
| Award Data (James Beard) | Static dataset + annual update | GitHub: cjwinchester/james-beard |
| Award Data (Michelin) | Static dataset + annual update | Kaggle michelin-guide dataset |

## Authentication

| Component | Technology | Rationale |
|-----------|------------|-----------|
| Auth Framework | Serverpod Auth | Built-in module, minimal setup |
| Social Login | Google Sign-In, Sign in with Apple | Standard OAuth providers |
| Session Management | Serverpod Sessions | Built-in token management |
| Industry Verification | Manual review + badge system | Chef/local verification workflow |

## Third-Party Integrations

| Component | Technology | Purpose |
|-----------|------------|---------|
| Reservations | OpenTable Partner API | In-app booking, availability, Experiences |
| Deep Links (Fallback) | OpenTable, Resy | External booking fallback |
| Social Sharing | Share Plus (Flutter) | Native share dialog on all platforms |
| Calendar Sync | Add to Calendar (Flutter) | Add reservations to device calendar |
| Push Notifications | Firebase Cloud Messaging | Re-engagement, tour reminders, quest updates |

## Performance and Optimization

| Component | Technology | Purpose |
|-----------|------------|---------|
| Code Splitting | Deferred loading | Load features on demand |
| Lazy Loading | Intersection Observer pattern | Load content as needed |
| Asset Optimization | Compressed images, WebP | Faster load times |
| Caching Strategy | Service Worker + HTTP caching | Offline support, faster repeat access |
| State Management | Riverpod or Provider | Efficient UI updates, dependency injection |

## Development and Quality

| Component | Technology | Purpose |
|-----------|------------|---------|
| Linting | dart analyze, flutter_lints | Code quality enforcement |
| Formatting | dart format | Consistent code style |
| Testing | flutter_test | Unit and widget testing |
| Integration Testing | integration_test | End-to-end testing |
| API Documentation | Serverpod-generated | Automatic API docs from models |

## Infrastructure and Deployment

| Component | Technology | Rationale |
|-----------|------------|-----------|
| Full-Stack Hosting | Globe.dev | Purpose-built for Dart/Flutter, native Serverpod support |
| Alternative Hosting | Railway, Render, AWS | Other viable backend options |
| Database Hosting | Globe.dev (built-in PostgreSQL) | Managed PostgreSQL included |
| CDN | Cloudflare | Global distribution for static assets |
| SSL/TLS | Automatic via hosting provider | Required for auth, location services |
| Domain | Custom domain | Professional URL |

## API Rate Limits and Costs

| API | Free Tier | Estimated Capacity |
|-----|-----------|-------------------|
| Perplexity Sonar | $5/1K requests + tokens | Primary research engine |
| Perplexity Sonar Pro | $5/1K requests + higher token costs | Complex narratives |
| Google Places | $200 credit/month | Restaurant data and photos |
| Mapbox Directions | 100K requests/month | Route optimization |
| Mapbox Maps | 50K loads/month | Interactive maps |
| Groq (Llama 3.3 70B) | 14,400 req/day | Backup narrative generation |
| OpenTable | Partner tier (TBD) | Based on approval |
| ElevenLabs | 10K chars/month free | Documentary Mode audio |
| Cloudflare R2 | 10GB storage free | Image storage |
| Globe.dev | 50K requests/month, 2GB bandwidth | Dart-native hosting |

## Environment Variables Required

```
# Database
DATABASE_URL=postgresql://...

# Google Places
GOOGLE_PLACES_API_KEY=...

# Mapbox
MAPBOX_ACCESS_TOKEN=...

# Perplexity
PERPLEXITY_API_KEY=...

# Groq (backup)
GROQ_API_KEY=...

# OpenTable (after Partner approval)
OPENTABLE_API_KEY=...
OPENTABLE_CLIENT_SECRET=...

# ElevenLabs (Documentary Mode)
ELEVENLABS_API_KEY=...

# Cloudflare R2
R2_ACCESS_KEY_ID=...
R2_SECRET_ACCESS_KEY=...
R2_BUCKET_NAME=...
R2_ENDPOINT=...

# Firebase (Push Notifications)
FIREBASE_PROJECT_ID=...
FIREBASE_PRIVATE_KEY=...
```

## Mobile-First Responsive Breakpoints

| Breakpoint | Width | Target |
|------------|-------|--------|
| Mobile (default) | < 600px | Phones (primary target) |
| Tablet | 600px - 1024px | Tablets, small laptops |
| Desktop | > 1024px | Desktops, large screens |

## Platform Support

| Platform | Priority | Notes |
|----------|----------|-------|
| iOS | Primary | Native app via Flutter |
| Android | Primary | Native app via Flutter |
| Web | Secondary | Progressive Web App for desktop/mobile web |
