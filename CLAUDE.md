# Off Menu / Food Butler Project

## Deployment Information

### Vercel (Flutter Web)
- **Project Name**: `offmenu` (NOT `offmenu-two`)
- **Production URL**: https://offmenu-two.vercel.app
- **Build Directory**: `food_butler_flutter/build/web`
- **Deploy Command**: `cd food_butler_flutter/build/web && vercel link --project=offmenu --yes && vercel --prod`

### Serverpod Cloud (Backend)
- **Project ID**: `offmenu`
- **API URL**: https://offmenu.api.serverpod.space
- **Deploy Command**: `cd food_butler_server && scloud deploy --yes`

## Build Commands

### Flutter Web Build
```bash
cd food_butler_flutter && flutter build web
```

### Serverpod Code Generation
```bash
cd food_butler_server && serverpod generate
```

## CORS Configuration
The server allows requests from:
- https://offmenu-two.vercel.app
- https://offmenu-two-snowy.vercel.app
- https://offmenu.vercel.app
- http://localhost:8080
- http://localhost:3000

## Google OAuth
When updating the Vercel domain, also update:
1. Google Cloud Console > APIs & Services > Credentials > OAuth 2.0 Client IDs
2. Add new domain to "Authorized JavaScript origins"
