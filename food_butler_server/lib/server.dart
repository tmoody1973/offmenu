import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';

import 'src/future_calls/daily_story_generation_call.dart';
import 'src/generated/endpoints.dart';
import 'src/generated/protocol.dart';
import 'src/web/middleware/cors_middleware.dart';
import 'src/web/routes/app_config_route.dart';
import 'src/web/routes/photo_proxy_route.dart';
import 'src/web/routes/root.dart';

/// The starting point of the Serverpod server.
void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(args, Protocol(), Endpoints());

  // Initialize authentication services for the server.
  // Token managers will be used to validate and issue authentication keys,
  // and the identity providers will be the authentication options available for users.
  //
  // Required secrets (in passwords.yaml or as SERVERPOD_PASSWORD_<name> env vars):
  // - jwtRefreshTokenHashPepper: Random string for hashing refresh tokens
  // - jwtHmacSha512PrivateKey: Private key for signing JWTs
  // - emailSecretHashPepper: Random string for hashing email verification codes
  // - serverpod_auth_googleClientSecret: Google OAuth client secret JSON

  // Debug: Check if Google client secret is configured
  final googleClientSecret = pod.getPassword('serverpod_auth_googleClientSecret');
  if (googleClientSecret != null) {
    print('[Auth] Google client secret found (${googleClientSecret.length} chars)');
  } else {
    print('[Auth] WARNING: Google client secret NOT found');
    print('[Auth] Expected: SERVERPOD_PASSWORD_serverpod_auth_googleClientSecret');
    // Debug: List relevant env vars to help diagnose
    final relevantVars = Platform.environment.keys
        .where((k) => k.toLowerCase().contains('google') ||
                      k.toLowerCase().contains('secret') ||
                      k.contains('SERVERPOD'))
        .toList();
    print('[Auth] Available relevant env vars: $relevantVars');
  }

  pod.initializeAuthServices(
    tokenManagerBuilders: [
      // Use JWT for authentication keys towards the server.
      // Requires: jwtRefreshTokenHashPepper, jwtHmacSha512PrivateKey
      JwtConfigFromPasswords(),
    ],
    identityProviderBuilders: [
      // Configure the email identity provider for email/password authentication.
      // Requires: emailSecretHashPepper
      EmailIdpConfigFromPasswords(
        sendRegistrationVerificationCode: _sendRegistrationCode,
        sendPasswordResetVerificationCode: _sendPasswordResetCode,
      ),
      // Configure Google identity provider using the standard secret name.
      // Requires: serverpod_auth_googleClientSecret
      GoogleIdpConfigFromPasswords(),
    ],
  );

  // Configure CORS for Flutter web clients
  const allowedOrigins = [
    'https://offmenu-two.vercel.app',
    'https://offmenu.vercel.app',
    'http://localhost:8080',
    'http://localhost:3000',
  ];
  pod.webServer.addMiddleware(corsMiddleware(allowedOrigins), '/**');

  // Setup a default page at the web root.
  // These are used by the default page.
  pod.webServer.addRoute(RootRoute(), '/');
  pod.webServer.addRoute(RootRoute(), '/index.html');

  // Photo proxy route - serves Google Places photos to avoid CORS issues.
  pod.webServer.addRoute(PhotoProxyRoute(), '/api/photos/**');

  // Serve all files in the web/static relative directory under /.
  // These are used by the default web page.
  final root = Directory(Uri(path: 'web/static').toFilePath());
  pod.webServer.addRoute(StaticRoute.directory(root));

  // Setup the app config route.
  // We build this configuration based on the servers api url and serve it to
  // the flutter app.
  pod.webServer.addRoute(
    AppConfigRoute(apiConfig: pod.config.apiServer),
    '/app/assets/assets/config.json',
  );

  // Checks if the flutter web app has been built and serves it if it has.
  final appDir = Directory(Uri(path: 'web/app').toFilePath());
  if (appDir.existsSync()) {
    // Serve the flutter web app under the /app path.
    pod.webServer.addRoute(
      FlutterRoute(
        Directory(
          Uri(path: 'web/app').toFilePath(),
        ),
      ),
      '/app',
    );
  } else {
    // If the flutter web app has not been built, serve the build app page.
    pod.webServer.addRoute(
      StaticRoute.file(
        File(
          Uri(path: 'web/pages/build_flutter_app.html').toFilePath(),
        ),
      ),
      '/app/**',
    );
  }

  // Register future calls for scheduled tasks
  pod.registerFutureCall(DailyStoryGenerationCall(), 'dailyStoryGeneration');

  // Schedule initial daily story generation if not already scheduled
  final startupSession = await pod.createSession();
  try {
    final now = DateTime.now();
    var nextRun = DateTime(now.year, now.month, now.day, DailyStoryGenerationCall.runHour, 0, 0);

    // If it's already past the run hour today, schedule for tomorrow
    if (now.hour >= DailyStoryGenerationCall.runHour) {
      nextRun = nextRun.add(const Duration(days: 1));
    }

    startupSession.log('[Scheduler] Scheduling initial daily story generation for $nextRun');

    await startupSession.serverpod.futureCallAtTime(
      'dailyStoryGeneration',
      null,
      nextRun,
    );
  } catch (e) {
    startupSession.log('[Scheduler] Error scheduling daily story generation: $e', level: LogLevel.warning);
  } finally {
    await startupSession.close();
  }

  // Start the server.
  await pod.start();
}

void _sendRegistrationCode(
  Session session, {
  required String email,
  required UuidValue accountRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  // NOTE: Here you call your mail service to send the verification code to
  // the user. For testing, we will just log the verification code.
  session.log('[EmailIdp] Registration code ($email): $verificationCode');
}

void _sendPasswordResetCode(
  Session session, {
  required String email,
  required UuidValue passwordResetRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  // NOTE: Here you call your mail service to send the verification code to
  // the user. For testing, we will just log the verification code.
  session.log('[EmailIdp] Password reset code ($email): $verificationCode');
}
