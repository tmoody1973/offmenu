import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

/// State of a photo upload.
enum UploadState {
  idle,
  compressing,
  uploading,
  processing,
  complete,
  error,
}

/// Result of a photo upload operation.
class PhotoUploadResult {
  final bool success;
  final String? originalUrl;
  final String? thumbnailUrl;
  final int? photoId;
  final String? error;

  PhotoUploadResult({
    required this.success,
    this.originalUrl,
    this.thumbnailUrl,
    this.photoId,
    this.error,
  });

  factory PhotoUploadResult.success({
    required String originalUrl,
    required String thumbnailUrl,
    required int photoId,
  }) {
    return PhotoUploadResult(
      success: true,
      originalUrl: originalUrl,
      thumbnailUrl: thumbnailUrl,
      photoId: photoId,
    );
  }

  factory PhotoUploadResult.failure(String error) {
    return PhotoUploadResult(
      success: false,
      error: error,
    );
  }
}

/// Callback for upload progress updates.
typedef UploadProgressCallback = void Function(UploadState state, double progress);

/// Service for handling photo uploads to R2.
///
/// Manages the full upload flow:
/// 1. Compress image client-side
/// 2. Request signed URL from server
/// 3. Upload to R2 using signed URL
/// 4. Confirm upload with server
class PhotoUploadService {
  static const int targetSizeBytes = 1024 * 1024; // 1MB
  static const int maxPhotosPerEntry = 3;
  static const int compressionQuality = 80;

  final http.Client _httpClient;

  PhotoUploadService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  /// Pick an image from the camera.
  Future<XFile?> pickFromCamera() async {
    final picker = ImagePicker();
    return await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
    );
  }

  /// Pick an image from the gallery.
  Future<XFile?> pickFromGallery() async {
    final picker = ImagePicker();
    return await picker.pickImage(source: ImageSource.gallery);
  }

  /// Compress an image to approximately 1MB.
  ///
  /// Returns the compressed image bytes or null if compression fails.
  Future<Uint8List?> compressImage(XFile file) async {
    try {
      final bytes = await file.readAsBytes();

      // If already small enough, return as is
      if (bytes.length <= targetSizeBytes) {
        return bytes;
      }

      // Calculate quality to achieve target size
      // Start with base quality and adjust based on size ratio
      var quality = compressionQuality;
      final ratio = targetSizeBytes / bytes.length;
      if (ratio < 0.5) {
        quality = (quality * ratio).clamp(30, 80).toInt();
      }

      // Compress using flutter_image_compress
      final result = await FlutterImageCompress.compressWithList(
        bytes,
        quality: quality,
        format: CompressFormat.jpeg,
      );

      return result;
    } catch (e) {
      return null;
    }
  }

  /// Upload a photo to R2.
  ///
  /// This handles the full upload flow including compression,
  /// signed URL request, direct upload, and confirmation.
  Future<PhotoUploadResult> uploadPhoto({
    required XFile file,
    required int journalEntryId,
    required int displayOrder,
    required Future<Map<String, dynamic>> Function(int entryId, String filename)
        getUploadUrl,
    required Future<Map<String, dynamic>> Function(
            int entryId, String objectKey, int displayOrder)
        confirmUpload,
    UploadProgressCallback? onProgress,
  }) async {
    try {
      // Step 1: Compress the image
      onProgress?.call(UploadState.compressing, 0);
      final compressedBytes = await compressImage(file);
      if (compressedBytes == null) {
        return PhotoUploadResult.failure('Failed to compress image');
      }
      onProgress?.call(UploadState.compressing, 1.0);

      // Step 2: Get signed upload URL
      onProgress?.call(UploadState.uploading, 0);
      final filename = file.name.isNotEmpty ? file.name : 'photo.jpg';
      final urlResponse = await getUploadUrl(journalEntryId, filename);

      if (urlResponse['success'] != true) {
        return PhotoUploadResult.failure(
            urlResponse['error'] as String? ?? 'Failed to get upload URL');
      }

      final uploadUrl = urlResponse['uploadUrl'] as String;
      final objectKey = urlResponse['objectKey'] as String;

      // Step 3: Upload directly to R2
      final uploadResponse = await _uploadToR2(
        url: uploadUrl,
        data: compressedBytes,
        contentType: 'image/jpeg',
        onProgress: (progress) {
          onProgress?.call(UploadState.uploading, progress);
        },
      );

      if (!uploadResponse) {
        return PhotoUploadResult.failure('Failed to upload to storage');
      }
      onProgress?.call(UploadState.uploading, 1.0);

      // Step 4: Confirm upload with server
      onProgress?.call(UploadState.processing, 0);
      final confirmResponse = await confirmUpload(
        journalEntryId,
        objectKey,
        displayOrder,
      );

      if (confirmResponse['success'] != true) {
        return PhotoUploadResult.failure(
            confirmResponse['error'] as String? ?? 'Failed to confirm upload');
      }
      onProgress?.call(UploadState.processing, 1.0);

      onProgress?.call(UploadState.complete, 1.0);
      return PhotoUploadResult.success(
        originalUrl: confirmResponse['originalUrl'] as String,
        thumbnailUrl: confirmResponse['thumbnailUrl'] as String,
        photoId: confirmResponse['photoId'] as int,
      );
    } catch (e) {
      onProgress?.call(UploadState.error, 0);
      return PhotoUploadResult.failure('Upload error: $e');
    }
  }

  /// Upload bytes directly to R2 using a signed URL.
  Future<bool> _uploadToR2({
    required String url,
    required Uint8List data,
    required String contentType,
    void Function(double progress)? onProgress,
  }) async {
    try {
      // For progress tracking, we'd need a custom StreamedRequest
      // For simplicity, use a standard PUT request
      final response = await _httpClient.put(
        Uri.parse(url),
        headers: {'Content-Type': contentType},
        body: data,
      );

      // R2 returns 200 or 201 on success
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  /// Dispose of resources.
  void dispose() {
    _httpClient.close();
  }
}
