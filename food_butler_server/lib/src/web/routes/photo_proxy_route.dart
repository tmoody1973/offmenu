import 'dart:async';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:relic/relic.dart';
import 'package:serverpod/serverpod.dart';

/// Route that proxies Google Places photos to avoid CORS issues.
///
/// Usage: /api/photos/{photoReference}?thumbnail=true
class PhotoProxyRoute extends Route {
  static const int _defaultWidth = 800;
  static const int _thumbnailWidth = 400;

  PhotoProxyRoute() : super(methods: {Method.get}, path: '/');

  @override
  FutureOr<Result> handleCall(Session session, Request request) async {
    // Extract photo reference from the path
    // Path format: /api/photos/{photoReference}
    final pathSegments = request.url.pathSegments;

    if (pathSegments.length < 3) {
      return Response(
        400,
        body: Body.fromString('Missing photo reference'),
      );
    }

    // The photo reference is everything after /api/photos/
    final photoReference = pathSegments.skip(2).join('/');

    if (photoReference.isEmpty) {
      return Response(
        400,
        body: Body.fromString('Missing photo reference'),
      );
    }

    // Get optional parameters
    final isThumbnail = request.url.queryParameters['thumbnail'] == 'true';
    final widthParam = request.url.queryParameters['w'];
    final width = widthParam != null
        ? int.tryParse(widthParam) ?? _defaultWidth
        : (isThumbnail ? _thumbnailWidth : _defaultWidth);

    // Get API key
    final apiKey = session.serverpod.getPassword('GOOGLE_PLACES_API_KEY');
    if (apiKey == null || apiKey.isEmpty) {
      return Response(
        503,
        body: Body.fromString('Photo service not configured'),
      );
    }

    try {
      // Fetch the photo from Google
      final googleUrl = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/photo'
        '?maxwidth=$width'
        '&photo_reference=$photoReference'
        '&key=$apiKey',
      );

      final response = await http.get(googleUrl);

      if (response.statusCode == 200) {
        // Get content type from Google's response
        final contentTypeStr = response.headers['content-type'] ?? 'image/jpeg';
        final mimeType = MimeType.parse(contentTypeStr);

        // Build response with caching and CORS headers
        final headers = Headers.build((builder) {
          builder.cacheControl = CacheControlHeader(
            publicCache: true,
            maxAge: 86400, // Cache for 24 hours
          );
          // Add CORS headers for cross-origin image loading
          builder['Access-Control-Allow-Origin'] = ['*'];
          builder['Access-Control-Allow-Methods'] = ['GET, OPTIONS'];
          builder['Access-Control-Allow-Headers'] = ['Content-Type'];
        });

        return Response.ok(
          body: Body.fromData(
            Uint8List.fromList(response.bodyBytes),
            mimeType: mimeType,
          ),
          headers: headers,
        );
      } else {
        session.log(
          'Google Photo API error: ${response.statusCode}',
          level: LogLevel.warning,
        );
        return Response(
          404,
          body: Body.fromString('Photo not found'),
        );
      }
    } catch (e) {
      session.log('Photo proxy error: $e', level: LogLevel.error);
      return Response(
        500,
        body: Body.fromString('Error fetching photo'),
      );
    }
  }
}
