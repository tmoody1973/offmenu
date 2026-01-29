## Tech Stack - Food Butler

### Framework & Runtime
- **Backend Framework:** Serverpod 3.2.3 (Dart full-stack framework)
- **Language/Runtime:** Dart 3.10.4
- **Package Manager:** pub (Dart)

### Frontend
- **UI Framework:** Flutter (Web + Mobile)
- **State Management:** Built-in Flutter state + Serverpod client
- **UI Components:** Material Design 3 with custom theming
- **Maps:** google_maps_flutter + Mapbox for routing

### Backend Services
- **API Style:** Serverpod endpoints (type-safe RPC)
- **Session Management:** Serverpod sessions
- **Background Jobs:** Serverpod future calls

### Database & Storage
- **Database:** PostgreSQL (via Serverpod)
- **ORM:** Serverpod database layer (auto-generated from .spy.yaml)
- **Migrations:** Serverpod migrations

### External APIs
- **AI/Research:** Perplexity AI (sonar-pro model)
- **Places Data:** Google Places API (New)
- **Geocoding:** Google Places Autocomplete (via server proxy)
- **Routing:** Mapbox Directions API
- **Maps Display:** Google Maps JavaScript/Flutter SDK

### Testing & Quality
- **Test Framework:** Serverpod test tools + Flutter test
- **Linting:** dart analyze, flutter analyze

### Deployment & Infrastructure
- **Hosting:** TBD (likely Google Cloud Run or similar)
- **CI/CD:** TBD

### Third-Party Services
- **Award Data:**
  - Michelin Guide (manual import)
  - James Beard Foundation (CSV import from GitHub)
- **Authentication:** TBD (Serverpod auth module available)

### Key Dependencies
```yaml
# Server
serverpod: ^3.2.3
http: ^1.1.0

# Client
food_butler_client: (generated)
serverpod_flutter: ^3.2.3
google_maps_flutter: latest
go_router: latest
```

### Project Structure
```
food-butler/
├── food_butler_server/     # Serverpod backend
│   ├── lib/src/
│   │   ├── services/       # Business logic services
│   │   ├── tours/          # Tour-related models/endpoints
│   │   ├── awards/         # Award data management
│   │   └── geocoding/      # Location services
│   └── config/
│       └── passwords.yaml  # API keys (gitignored)
├── food_butler_flutter/    # Flutter frontend
│   └── lib/
│       ├── screens/        # UI screens
│       └── map/            # Map-related widgets/services
└── food_butler_client/     # Generated client code
```
