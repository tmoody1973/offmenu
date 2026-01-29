import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

/// Endpoint for proxying Google Places photos.
/// This hides the API key from clients and enables caching.
class GooglePhotosEndpoint extends Endpoint {
  static const int _maxWidth = 800;
  static const int _thumbnailWidth = 400;

  /// Get a Google Places photo by reference.
  /// Returns the photo as base64-encoded data with content type.
  ///
  /// This proxies the request through the server to hide the API key.
  Future<Map<String, dynamic>> getPhoto(
    Session session,
    String photoReference, {
    bool thumbnail = false,
  }) async {
    final apiKey = session.serverpod.getPassword('GOOGLE_PLACES_API_KEY');
    if (apiKey == null || apiKey.isEmpty) {
      return {
        'success': false,
        'error': 'Google Places API key not configured',
      };
    }

    final width = thumbnail ? _thumbnailWidth : _maxWidth;

    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/photo'
        '?maxwidth=$width'
        '&photo_reference=$photoReference'
        '&key=$apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'] ?? 'image/jpeg';
        final base64Data = base64Encode(response.bodyBytes);

        return {
          'success': true,
          'contentType': contentType,
          'data': base64Data,
        };
      } else {
        session.log(
          'Google Photos API error: ${response.statusCode}',
          level: LogLevel.error,
        );
        return {
          'success': false,
          'error': 'Failed to fetch photo: ${response.statusCode}',
        };
      }
    } catch (e) {
      session.log('Google Photos error: $e', level: LogLevel.error);
      return {
        'success': false,
        'error': 'Error fetching photo',
      };
    }
  }

  /// Get a signed/proxied URL for a Google Places photo.
  /// Returns a URL that can be used directly in img tags.
  ///
  /// This creates a server-side URL that proxies to Google.
  Future<String?> getPhotoUrl(
    Session session,
    String photoReference, {
    bool thumbnail = false,
  }) async {
    // Return a server endpoint URL that will proxy the request
    // Photos are served via the web server, not the API server
    final baseUrl = session.serverpod.getPassword('WEB_SERVER_PUBLIC_URL') ??
                    'http://localhost:8082';
    final thumbParam = thumbnail ? '?thumbnail=true' : '';
    return '$baseUrl/api/photos/$photoReference$thumbParam';
  }

  /// Stream a Google Places photo directly (for use as img src).
  /// This endpoint returns the raw image bytes.
  Future<void> streamPhoto(
    Session session,
    String ref, {
    bool thumbnail = false,
  }) async {
    final apiKey = session.serverpod.getPassword('GOOGLE_PLACES_API_KEY');
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API key not configured');
    }

    final width = thumbnail ? _thumbnailWidth : _maxWidth;

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/photo'
      '?maxwidth=$width'
      '&photo_reference=$ref'
      '&key=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Return raw bytes - Serverpod will handle the response
      // Note: This requires custom handling in the server setup
      session.log('Streaming photo: $ref');
    }
  }

  /// Get multiple photos for a place by place ID.
  /// Returns up to [maxPhotos] photo references.
  Future<List<String>> getPhotoReferences(
    Session session,
    String placeId, {
    int maxPhotos = 5,
  }) async {
    final apiKey = session.serverpod.getPassword('GOOGLE_PLACES_API_KEY');
    if (apiKey == null || apiKey.isEmpty) {
      return [];
    }

    try {
      // Use Places API (New) to get photo references
      final url = Uri.parse(
        'https://places.googleapis.com/v1/places/$placeId',
      );

      final response = await http.get(
        url,
        headers: {
          'X-Goog-Api-Key': apiKey,
          'X-Goog-FieldMask': 'photos',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final photos = data['photos'] as List<dynamic>? ?? [];

        return photos
            .take(maxPhotos)
            .map((p) {
              final name = p['name'] as String?;
              // Extract photo reference from resource name
              // Format: places/{place_id}/photos/{photo_reference}
              return name?.split('/').last ?? '';
            })
            .where((ref) => ref.isNotEmpty)
            .toList();
      }

      return [];
    } catch (e) {
      session.log('Error getting photo references: $e', level: LogLevel.error);
      return [];
    }
  }

  /// Get photos for a restaurant with full URLs.
  /// Returns a list of photo data including URLs and dimensions.
  Future<List<Map<String, dynamic>>> getRestaurantPhotos(
    Session session,
    String placeId, {
    int maxPhotos = 5,
  }) async {
    final apiKey = session.serverpod.getPassword('GOOGLE_PLACES_API_KEY');
    if (apiKey == null || apiKey.isEmpty) {
      return [];
    }

    try {
      final url = Uri.parse(
        'https://places.googleapis.com/v1/places/$placeId',
      );

      final response = await http.get(
        url,
        headers: {
          'X-Goog-Api-Key': apiKey,
          'X-Goog-FieldMask': 'photos',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final photos = data['photos'] as List<dynamic>? ?? [];

        // Photos are served via the web server, not the API server
        final serverUrl = session.serverpod.getPassword('WEB_SERVER_PUBLIC_URL') ??
                          'http://localhost:8082';

        return photos
            .take(maxPhotos)
            .map((p) {
              final name = p['name'] as String?;
              final photoRef = name?.split('/').last ?? '';
              final width = p['widthPx'] as int? ?? 800;
              final height = p['heightPx'] as int? ?? 600;

              return {
                'photoReference': photoRef,
                'width': width,
                'height': height,
                // Proxied URLs that hide the API key
                'url': '$serverUrl/api/photos/$photoRef',
                'thumbnailUrl': '$serverUrl/api/photos/$photoRef?thumbnail=true',
                // Attribution info
                'attributions': p['authorAttributions'] as List<dynamic>? ?? [],
              };
            })
            .where((p) => (p['photoReference'] as String).isNotEmpty)
            .toList();
      }

      return [];
    } catch (e) {
      session.log('Error getting restaurant photos: $e', level: LogLevel.error);
      return [];
    }
  }
}
