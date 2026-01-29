import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:food_butler_client/food_butler_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';

/// Global Serverpod client instance.
///
/// Initialized in main() and available throughout the app.
/// In production, consider using dependency injection instead.
late final Client client;

/// Server URL for the Serverpod backend.
late String serverUrl;

/// Global Google API key for Maps and Places.
String? googleApiKey;

/// App configuration loaded from config files.
class AppConfig {
  final String apiUrl;
  final String? googleApiKey;

  AppConfig({required this.apiUrl, this.googleApiKey});
}

/// Loads app configuration from config files or environment.
///
/// Priority:
/// 1. Dart defines (--dart-define=KEY=value)
/// 2. Local config file: assets/config.local.json (gitignored, for dev secrets)
/// 3. Config file: assets/config.json
/// 4. Defaults
Future<AppConfig> loadConfig() async {
  // Check for dart-define overrides first
  const definedUrl = String.fromEnvironment('SERVER_URL');
  const definedGoogleKey = String.fromEnvironment('GOOGLE_API_KEY');

  String apiUrl = 'http://localhost:8080/';
  String? googleKey;

  // Try loading from config.local.json first (development secrets)
  try {
    final configString =
        await rootBundle.loadString('assets/config.local.json');
    final config = jsonDecode(configString) as Map<String, dynamic>;

    final configApiUrl = config['apiUrl'] as String?;
    if (configApiUrl != null && configApiUrl.isNotEmpty) {
      apiUrl = configApiUrl;
    }

    final configGoogleKey = config['googleApiKey'] as String?;
    if (configGoogleKey != null && configGoogleKey.isNotEmpty) {
      googleKey = configGoogleKey;
    }
  } catch (e) {
    debugPrint('Could not load config.local.json: $e');

    // Fall back to config.json
    try {
      final configString = await rootBundle.loadString('assets/config.json');
      final config = jsonDecode(configString) as Map<String, dynamic>;

      final configApiUrl = config['apiUrl'] as String?;
      if (configApiUrl != null && configApiUrl.isNotEmpty) {
        apiUrl = configApiUrl;
      }

      final configGoogleKey = config['googleApiKey'] as String?;
      if (configGoogleKey != null && configGoogleKey.isNotEmpty) {
        googleKey = configGoogleKey;
      }
    } catch (e) {
      debugPrint('Could not load config.json: $e');
    }
  }

  // Dart defines override config files
  if (definedUrl.isNotEmpty) {
    apiUrl = definedUrl;
  }
  if (definedGoogleKey.isNotEmpty) {
    googleKey = definedGoogleKey;
  }

  return AppConfig(apiUrl: apiUrl, googleApiKey: googleKey);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load configuration from config files
  final config = await loadConfig();
  serverUrl = config.apiUrl;
  googleApiKey = config.googleApiKey;

  if (googleApiKey != null && googleApiKey!.isNotEmpty) {
    debugPrint('Google API key configured');
  } else {
    debugPrint('Warning: Google API key not configured');
  }

  // Initialize Serverpod client with auth support
  // Increased timeout for Perplexity AI calls which can take 30-60 seconds
  client = Client(
    serverUrl,
    connectionTimeout: const Duration(seconds: 90),
  )
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();

  // Initialize authentication
  client.auth.initialize();

  // Initialize Google Sign-In (if configured)
  try {
    client.auth.initializeGoogleSignIn();
  } catch (e) {
    debugPrint('Google Sign-In not configured: $e');
  }

  runApp(const FoodButlerApp());
}

/// Root widget for Off Menu.
///
/// Design Philosophy: Editorial, magazine-quality — like opening a food
/// magazine, not a database. Warm, analog vibes. Witty, opinionated.
///
/// Sets up:
/// - Dark editorial theme via AppTheme
/// - GoRouter navigation
/// - Mobile-first responsive design
class FoodButlerApp extends StatelessWidget {
  const FoodButlerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Off Menu',
      debugShowCheckedModeBanner: false,

      // Dark editorial theme - "like a dimly-lit bar"
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,

      // Router configuration
      routerConfig: AppRouter.router,

      // Builder for global overlays and accessibility
      builder: (context, child) {
        // Apply text scale factor limits for accessibility
        final mediaQueryData = MediaQuery.of(context);
        final constrainedTextScaler = mediaQueryData.textScaler.clamp(
          minScaleFactor: 0.8,
          maxScaleFactor: 1.4,
        );

        return MediaQuery(
          data: mediaQueryData.copyWith(
            textScaler: constrainedTextScaler,
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
