import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/r2_service.dart';

/// Response for signed URL request.
class SignedUploadUrlResponse {
  final String uploadUrl;
  final String objectKey;
  final DateTime expiresAt;
  final bool success;
  final String? error;

  SignedUploadUrlResponse({
    required this.uploadUrl,
    required this.objectKey,
    required this.expiresAt,
    required this.success,
    this.error,
  });

  factory SignedUploadUrlResponse.failure(String error) {
    return SignedUploadUrlResponse(
      uploadUrl: '',
      objectKey: '',
      expiresAt: DateTime.now(),
      success: false,
      error: error,
    );
  }

  Map<String, dynamic> toJson() => {
        'uploadUrl': uploadUrl,
        'objectKey': objectKey,
        'expiresAt': expiresAt.toIso8601String(),
        'success': success,
        if (error != null) 'error': error,
      };
}

/// Response for upload confirmation.
class UploadConfirmResponse {
  final String originalUrl;
  final String thumbnailUrl;
  final int photoId;
  final bool success;
  final String? error;

  UploadConfirmResponse({
    required this.originalUrl,
    required this.thumbnailUrl,
    required this.photoId,
    required this.success,
    this.error,
  });

  factory UploadConfirmResponse.failure(String error) {
    return UploadConfirmResponse(
      originalUrl: '',
      thumbnailUrl: '',
      photoId: 0,
      success: false,
      error: error,
    );
  }

  Map<String, dynamic> toJson() => {
        'originalUrl': originalUrl,
        'thumbnailUrl': thumbnailUrl,
        'photoId': photoId,
        'success': success,
        if (error != null) 'error': error,
      };
}

/// Photo upload API endpoint for journal entries.
///
/// Handles pre-signed URL generation and upload confirmation.
class PhotoEndpoint extends Endpoint {
  /// Maximum photos per journal entry (MVP limit).
  static const int maxPhotosPerEntry = 3;

  /// Get a pre-signed URL for uploading a photo.
  ///
  /// Returns a signed PUT URL that the client can use to upload directly to R2.
  /// Requires authentication.
  Future<Map<String, dynamic>> getUploadUrl(
    Session session, {
    required int journalEntryId,
    required String filename,
  }) async {
    // Verify authentication
    final userId = await _getAuthenticatedUserId(session);
    if (userId == null) {
      return SignedUploadUrlResponse.failure('Authentication required').toJson();
    }

    // Verify user owns the journal entry
    final entry = await JournalEntry.db.findById(session, journalEntryId);
    if (entry == null) {
      return SignedUploadUrlResponse.failure('Journal entry not found').toJson();
    }

    if (entry.userId != userId) {
      return SignedUploadUrlResponse.failure('Not authorized to add photos to this entry').toJson();
    }

    // Check if entry already has maximum photos
    final existingPhotos = await JournalPhoto.db.count(
      session,
      where: (t) => t.journalEntryId.equals(journalEntryId),
    );

    if (existingPhotos >= maxPhotosPerEntry) {
      return SignedUploadUrlResponse.failure('Maximum $maxPhotosPerEntry photos per entry').toJson();
    }

    try {
      final r2Service = await _getR2Service(session);
      final result = await r2Service.generateSignedUploadUrl(
        userId: userId,
        entryId: journalEntryId,
        filename: filename,
      );

      return SignedUploadUrlResponse(
        uploadUrl: result.uploadUrl,
        objectKey: result.objectKey,
        expiresAt: result.expiresAt,
        success: true,
      ).toJson();
    } catch (e) {
      session.log(
        'Error generating upload URL: $e',
        level: LogLevel.error,
      );
      return SignedUploadUrlResponse.failure('Failed to generate upload URL').toJson();
    }
  }

  /// Confirm an upload and create the photo record.
  ///
  /// This should be called after the client successfully uploads the image.
  /// It triggers thumbnail generation and creates the database record.
  Future<Map<String, dynamic>> confirmUpload(
    Session session, {
    required int journalEntryId,
    required String objectKey,
    required int displayOrder,
  }) async {
    // Verify authentication
    final userId = await _getAuthenticatedUserId(session);
    if (userId == null) {
      return UploadConfirmResponse.failure('Authentication required').toJson();
    }

    // Verify user owns the journal entry
    final entry = await JournalEntry.db.findById(session, journalEntryId);
    if (entry == null) {
      return UploadConfirmResponse.failure('Journal entry not found').toJson();
    }

    if (entry.userId != userId) {
      return UploadConfirmResponse.failure('Not authorized').toJson();
    }

    // Validate display order
    if (displayOrder < 0 || displayOrder >= maxPhotosPerEntry) {
      return UploadConfirmResponse.failure('Invalid display order').toJson();
    }

    try {
      final r2Service = await _getR2Service(session);
      final result = await r2Service.confirmUploadAndGenerateThumbnail(
        objectKey: objectKey,
      );

      if (!result.success) {
        return UploadConfirmResponse.failure(result.error ?? 'Upload confirmation failed').toJson();
      }

      // Create the photo record
      final photo = await JournalPhoto.db.insertRow(
        session,
        JournalPhoto(
          journalEntryId: journalEntryId,
          originalUrl: result.originalUrl,
          thumbnailUrl: result.thumbnailUrl,
          displayOrder: displayOrder,
          uploadedAt: DateTime.now().toUtc(),
        ),
      );

      return UploadConfirmResponse(
        originalUrl: result.originalUrl,
        thumbnailUrl: result.thumbnailUrl,
        photoId: photo.id!,
        success: true,
      ).toJson();
    } catch (e) {
      session.log(
        'Error confirming upload: $e',
        level: LogLevel.error,
      );
      return UploadConfirmResponse.failure('Failed to process upload').toJson();
    }
  }

  /// Delete a photo from a journal entry.
  ///
  /// Removes the photo from R2 and the database.
  Future<Map<String, dynamic>> deletePhoto(
    Session session, {
    required int photoId,
  }) async {
    // Verify authentication
    final userId = await _getAuthenticatedUserId(session);
    if (userId == null) {
      return {'success': false, 'error': 'Authentication required'};
    }

    // Get the photo
    final photo = await JournalPhoto.db.findById(session, photoId);
    if (photo == null) {
      return {'success': false, 'error': 'Photo not found'};
    }

    // Verify user owns the journal entry
    final entry = await JournalEntry.db.findById(session, photo.journalEntryId);
    if (entry == null || entry.userId != userId) {
      return {'success': false, 'error': 'Not authorized'};
    }

    try {
      // Extract object key from URL
      final objectKey = _extractObjectKey(photo.originalUrl);

      if (objectKey != null) {
        final r2Service = await _getR2Service(session);
        await r2Service.deleteObject(objectKey);
      }

      // Delete the database record
      await JournalPhoto.db.deleteRow(session, photo);

      return {'success': true};
    } catch (e) {
      session.log(
        'Error deleting photo: $e',
        level: LogLevel.error,
      );
      return {'success': false, 'error': 'Failed to delete photo'};
    }
  }

  /// Get authenticated user ID from session.
  Future<String?> _getAuthenticatedUserId(Session session) async {
    final authenticated = await session.authenticated;
    return authenticated?.userIdentifier.toString();
  }

  /// Get or create the R2 service instance.
  Future<R2Service> _getR2Service(Session session) async {
    final accessKeyId = session.serverpod.getPassword('R2_ACCESS_KEY_ID') ?? '';
    final secretAccessKey = session.serverpod.getPassword('R2_SECRET_ACCESS_KEY') ?? '';
    final bucketName = session.serverpod.getPassword('R2_BUCKET_NAME') ?? 'food-butler-photos';
    final endpoint = session.serverpod.getPassword('R2_ENDPOINT') ?? '';
    final publicUrl = session.serverpod.getPassword('R2_PUBLIC_URL') ?? endpoint;

    return R2Service(
      accessKeyId: accessKeyId,
      secretAccessKey: secretAccessKey,
      bucketName: bucketName,
      endpoint: endpoint,
      publicUrl: publicUrl,
      session: session,
    );
  }

  /// Extract object key from a public URL.
  String? _extractObjectKey(String url) {
    try {
      final uri = Uri.parse(url);
      final path = uri.path;
      // Remove leading slash and bucket name if present
      if (path.startsWith('/')) {
        return path.substring(1);
      }
      return path;
    } catch (e) {
      return null;
    }
  }
}
