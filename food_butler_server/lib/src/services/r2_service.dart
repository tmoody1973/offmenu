import 'dart:convert';
import 'dart:typed_data';

import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:serverpod/serverpod.dart';

/// Result of a signed URL generation.
class SignedUrlResult {
  final String uploadUrl;
  final String objectKey;
  final DateTime expiresAt;

  SignedUrlResult({
    required this.uploadUrl,
    required this.objectKey,
    required this.expiresAt,
  });
}

/// Result of an image upload confirmation.
class UploadConfirmResult {
  final String originalUrl;
  final String thumbnailUrl;
  final bool success;
  final String? error;

  UploadConfirmResult({
    required this.originalUrl,
    required this.thumbnailUrl,
    required this.success,
    this.error,
  });

  factory UploadConfirmResult.failure(String error) {
    return UploadConfirmResult(
      originalUrl: '',
      thumbnailUrl: '',
      success: false,
      error: error,
    );
  }
}

/// Service for managing image storage in Cloudflare R2.
///
/// R2 is S3-compatible, so we use AWS signature V4 for authentication.
/// Storage path structure: /{userId}/{entryId}/{photoId}.{ext}
class R2Service {
  static const int thumbnailSize = 200;
  static const Duration signedUrlExpiry = Duration(minutes: 15);

  final String _accessKeyId;
  final String _secretAccessKey;
  final String _bucketName;
  final String _endpoint;
  final String _publicUrl;
  final Session _session;
  final http.Client _httpClient;

  R2Service({
    required String accessKeyId,
    required String secretAccessKey,
    required String bucketName,
    required String endpoint,
    required String publicUrl,
    required Session session,
    http.Client? httpClient,
  })  : _accessKeyId = accessKeyId,
        _secretAccessKey = secretAccessKey,
        _bucketName = bucketName,
        _endpoint = endpoint,
        _publicUrl = publicUrl,
        _session = session,
        _httpClient = httpClient ?? http.Client();

  /// Generate a pre-signed URL for uploading an image.
  ///
  /// Returns a signed PUT URL that the client can use to upload directly to R2.
  Future<SignedUrlResult> generateSignedUploadUrl({
    required String userId,
    required int entryId,
    required String filename,
  }) async {
    final extension = _getFileExtension(filename);
    final photoId = _generatePhotoId();
    final objectKey = '$userId/$entryId/$photoId.$extension';
    final expiresAt = DateTime.now().add(signedUrlExpiry);

    try {
      final signedUrl = await _generatePresignedPutUrl(
        objectKey: objectKey,
        expiresAt: expiresAt,
        contentType: _getContentType(extension),
      );

      return SignedUrlResult(
        uploadUrl: signedUrl,
        objectKey: objectKey,
        expiresAt: expiresAt,
      );
    } catch (e) {
      _session.log(
        'Error generating signed upload URL: $e',
        level: LogLevel.error,
      );
      rethrow;
    }
  }

  /// Generate a pre-signed URL for reading an image.
  ///
  /// Returns a time-limited GET URL for secure image access.
  Future<String> generateSignedReadUrl({
    required String objectKey,
    Duration expiry = const Duration(hours: 1),
  }) async {
    try {
      return await _generatePresignedGetUrl(
        objectKey: objectKey,
        expiresAt: DateTime.now().add(expiry),
      );
    } catch (e) {
      _session.log(
        'Error generating signed read URL: $e',
        level: LogLevel.error,
      );
      rethrow;
    }
  }

  /// Get the public URL for an object (if bucket has public access).
  String getPublicUrl(String objectKey) {
    return '$_publicUrl/$objectKey';
  }

  /// Confirm an upload and generate a thumbnail.
  ///
  /// This should be called after the client successfully uploads the image.
  /// It verifies the upload, generates a thumbnail, and returns both URLs.
  Future<UploadConfirmResult> confirmUploadAndGenerateThumbnail({
    required String objectKey,
  }) async {
    try {
      // Verify the original image exists
      final originalExists = await _objectExists(objectKey);
      if (!originalExists) {
        return UploadConfirmResult.failure('Original image not found');
      }

      // Download the original image
      final imageBytes = await _downloadObject(objectKey);
      if (imageBytes == null) {
        return UploadConfirmResult.failure('Failed to download original image');
      }

      // Generate thumbnail
      final thumbnailBytes = await _generateThumbnail(imageBytes);
      if (thumbnailBytes == null) {
        return UploadConfirmResult.failure('Failed to generate thumbnail');
      }

      // Upload thumbnail
      final thumbnailKey = _getThumbnailKey(objectKey);
      final thumbnailUploaded = await _uploadObject(
        objectKey: thumbnailKey,
        data: thumbnailBytes,
        contentType: _getContentType(_getFileExtension(objectKey)),
      );

      if (!thumbnailUploaded) {
        return UploadConfirmResult.failure('Failed to upload thumbnail');
      }

      return UploadConfirmResult(
        originalUrl: getPublicUrl(objectKey),
        thumbnailUrl: getPublicUrl(thumbnailKey),
        success: true,
      );
    } catch (e) {
      _session.log(
        'Error confirming upload: $e',
        level: LogLevel.error,
      );
      return UploadConfirmResult.failure('Error processing upload: $e');
    }
  }

  /// Delete an object from R2.
  Future<bool> deleteObject(String objectKey) async {
    try {
      final url = '$_endpoint/$_bucketName/$objectKey';
      final headers = await _getSignedHeaders(
        method: 'DELETE',
        path: '/$_bucketName/$objectKey',
      );

      final response = await _httpClient.delete(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        // Also delete thumbnail if it exists
        final thumbnailKey = _getThumbnailKey(objectKey);
        await _deleteObjectInternal(thumbnailKey);
        return true;
      }

      _session.log(
        'Delete failed: ${response.statusCode} - ${response.body}',
        level: LogLevel.warning,
      );
      return false;
    } catch (e) {
      _session.log(
        'Error deleting object: $e',
        level: LogLevel.error,
      );
      return false;
    }
  }

  /// Internal delete without thumbnail cascade.
  Future<void> _deleteObjectInternal(String objectKey) async {
    try {
      final url = '$_endpoint/$_bucketName/$objectKey';
      final headers = await _getSignedHeaders(
        method: 'DELETE',
        path: '/$_bucketName/$objectKey',
      );

      await _httpClient.delete(Uri.parse(url), headers: headers);
    } catch (e) {
      // Ignore errors for thumbnail deletion
    }
  }

  /// Check if an object exists in R2.
  Future<bool> _objectExists(String objectKey) async {
    try {
      final url = '$_endpoint/$_bucketName/$objectKey';
      final headers = await _getSignedHeaders(
        method: 'HEAD',
        path: '/$_bucketName/$objectKey',
      );

      final response = await _httpClient.head(Uri.parse(url), headers: headers);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Download an object from R2.
  Future<Uint8List?> _downloadObject(String objectKey) async {
    try {
      final url = '$_endpoint/$_bucketName/$objectKey';
      final headers = await _getSignedHeaders(
        method: 'GET',
        path: '/$_bucketName/$objectKey',
      );

      final response = await _httpClient.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
      return null;
    } catch (e) {
      _session.log(
        'Error downloading object: $e',
        level: LogLevel.error,
      );
      return null;
    }
  }

  /// Upload an object to R2.
  Future<bool> _uploadObject({
    required String objectKey,
    required Uint8List data,
    required String contentType,
  }) async {
    try {
      final url = '$_endpoint/$_bucketName/$objectKey';
      final headers = await _getSignedHeaders(
        method: 'PUT',
        path: '/$_bucketName/$objectKey',
        contentType: contentType,
        payloadHash: _hashPayload(data),
      );

      final response = await _httpClient.put(
        Uri.parse(url),
        headers: headers,
        body: data,
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      _session.log(
        'Error uploading object: $e',
        level: LogLevel.error,
      );
      return false;
    }
  }

  /// Generate a thumbnail from image bytes.
  Future<Uint8List?> _generateThumbnail(Uint8List imageBytes) async {
    try {
      final image = img.decodeImage(imageBytes);
      if (image == null) return null;

      // Resize maintaining aspect ratio, fitting within thumbnailSize x thumbnailSize
      final thumbnail = img.copyResize(
        image,
        width: image.width > image.height ? thumbnailSize : null,
        height: image.width <= image.height ? thumbnailSize : null,
        interpolation: img.Interpolation.linear,
      );

      // Encode as JPEG with good quality
      return Uint8List.fromList(img.encodeJpg(thumbnail, quality: 85));
    } catch (e) {
      _session.log(
        'Error generating thumbnail: $e',
        level: LogLevel.error,
      );
      return null;
    }
  }

  /// Generate a pre-signed PUT URL using AWS Signature V4.
  Future<String> _generatePresignedPutUrl({
    required String objectKey,
    required DateTime expiresAt,
    required String contentType,
  }) async {
    final expirySeconds = expiresAt.difference(DateTime.now()).inSeconds;

    // Build the canonical request for pre-signing
    final uri = Uri.parse('$_endpoint/$_bucketName/$objectKey');
    final now = DateTime.now().toUtc();
    final dateStamp = _formatDateStamp(now);
    final amzDate = _formatAmzDate(now);
    final region = 'auto'; // Cloudflare R2 uses 'auto' as the region
    final service = 's3';

    final credentialScope = '$dateStamp/$region/$service/aws4_request';
    final signedHeaders = 'host';

    final queryParams = {
      'X-Amz-Algorithm': 'AWS4-HMAC-SHA256',
      'X-Amz-Credential': '$_accessKeyId/$credentialScope',
      'X-Amz-Date': amzDate,
      'X-Amz-Expires': expirySeconds.toString(),
      'X-Amz-SignedHeaders': signedHeaders,
    };

    final canonicalQueryString = queryParams.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .toList()
      ..sort()
      ..join('&');

    final canonicalRequest = [
      'PUT',
      '/${_bucketName}/$objectKey',
      canonicalQueryString.join('&'),
      'host:${uri.host}',
      '',
      signedHeaders,
      'UNSIGNED-PAYLOAD',
    ].join('\n');

    final stringToSign = [
      'AWS4-HMAC-SHA256',
      amzDate,
      credentialScope,
      sha256.convert(utf8.encode(canonicalRequest)).toString(),
    ].join('\n');

    final signature = _calculateSignature(
      stringToSign: stringToSign,
      dateStamp: dateStamp,
      region: region,
      service: service,
    );

    return '${uri.toString()}?${canonicalQueryString.join('&')}&X-Amz-Signature=$signature';
  }

  /// Generate a pre-signed GET URL using AWS Signature V4.
  Future<String> _generatePresignedGetUrl({
    required String objectKey,
    required DateTime expiresAt,
  }) async {
    final expirySeconds = expiresAt.difference(DateTime.now()).inSeconds;

    final uri = Uri.parse('$_endpoint/$_bucketName/$objectKey');
    final now = DateTime.now().toUtc();
    final dateStamp = _formatDateStamp(now);
    final amzDate = _formatAmzDate(now);
    final region = 'auto';
    final service = 's3';

    final credentialScope = '$dateStamp/$region/$service/aws4_request';
    final signedHeaders = 'host';

    final queryParams = {
      'X-Amz-Algorithm': 'AWS4-HMAC-SHA256',
      'X-Amz-Credential': '$_accessKeyId/$credentialScope',
      'X-Amz-Date': amzDate,
      'X-Amz-Expires': expirySeconds.toString(),
      'X-Amz-SignedHeaders': signedHeaders,
    };

    final canonicalQueryString = queryParams.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .toList()
      ..sort()
      ..join('&');

    final canonicalRequest = [
      'GET',
      '/${_bucketName}/$objectKey',
      canonicalQueryString.join('&'),
      'host:${uri.host}',
      '',
      signedHeaders,
      'UNSIGNED-PAYLOAD',
    ].join('\n');

    final stringToSign = [
      'AWS4-HMAC-SHA256',
      amzDate,
      credentialScope,
      sha256.convert(utf8.encode(canonicalRequest)).toString(),
    ].join('\n');

    final signature = _calculateSignature(
      stringToSign: stringToSign,
      dateStamp: dateStamp,
      region: region,
      service: service,
    );

    return '${uri.toString()}?${canonicalQueryString.join('&')}&X-Amz-Signature=$signature';
  }

  /// Get signed headers for direct API calls.
  Future<Map<String, String>> _getSignedHeaders({
    required String method,
    required String path,
    String? contentType,
    String? payloadHash,
  }) async {
    final now = DateTime.now().toUtc();
    final dateStamp = _formatDateStamp(now);
    final amzDate = _formatAmzDate(now);
    final region = 'auto';
    final service = 's3';

    final uri = Uri.parse('$_endpoint$path');
    final host = uri.host;

    final headers = <String, String>{
      'host': host,
      'x-amz-date': amzDate,
      'x-amz-content-sha256': payloadHash ?? 'UNSIGNED-PAYLOAD',
    };

    if (contentType != null) {
      headers['content-type'] = contentType;
    }

    final signedHeaderNames = headers.keys.toList()..sort();
    final signedHeaders = signedHeaderNames.join(';');

    final canonicalHeaders = signedHeaderNames
        .map((name) => '$name:${headers[name]}')
        .join('\n');

    final canonicalRequest = [
      method,
      path,
      '', // Query string (empty for direct calls)
      canonicalHeaders,
      '',
      signedHeaders,
      payloadHash ?? 'UNSIGNED-PAYLOAD',
    ].join('\n');

    final credentialScope = '$dateStamp/$region/$service/aws4_request';

    final stringToSign = [
      'AWS4-HMAC-SHA256',
      amzDate,
      credentialScope,
      sha256.convert(utf8.encode(canonicalRequest)).toString(),
    ].join('\n');

    final signature = _calculateSignature(
      stringToSign: stringToSign,
      dateStamp: dateStamp,
      region: region,
      service: service,
    );

    headers['authorization'] =
        'AWS4-HMAC-SHA256 Credential=$_accessKeyId/$credentialScope, SignedHeaders=$signedHeaders, Signature=$signature';

    return headers;
  }

  /// Calculate the AWS Signature V4.
  String _calculateSignature({
    required String stringToSign,
    required String dateStamp,
    required String region,
    required String service,
  }) {
    final kDate = Hmac(sha256, utf8.encode('AWS4$_secretAccessKey'))
        .convert(utf8.encode(dateStamp))
        .bytes;
    final kRegion = Hmac(sha256, kDate).convert(utf8.encode(region)).bytes;
    final kService = Hmac(sha256, kRegion).convert(utf8.encode(service)).bytes;
    final kSigning =
        Hmac(sha256, kService).convert(utf8.encode('aws4_request')).bytes;

    return Hmac(sha256, kSigning)
        .convert(utf8.encode(stringToSign))
        .toString();
  }

  /// Hash the payload for signing.
  String _hashPayload(Uint8List data) {
    return sha256.convert(data).toString();
  }

  /// Format date stamp for AWS signature.
  String _formatDateStamp(DateTime date) {
    return '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';
  }

  /// Format AMZ date for AWS signature.
  String _formatAmzDate(DateTime date) {
    return '${_formatDateStamp(date)}T${date.hour.toString().padLeft(2, '0')}${date.minute.toString().padLeft(2, '0')}${date.second.toString().padLeft(2, '0')}Z';
  }

  /// Get the thumbnail key for an object.
  String _getThumbnailKey(String objectKey) {
    final lastDot = objectKey.lastIndexOf('.');
    if (lastDot == -1) return '${objectKey}_thumb';
    return '${objectKey.substring(0, lastDot)}_thumb${objectKey.substring(lastDot)}';
  }

  /// Get file extension from filename.
  String _getFileExtension(String filename) {
    final lastDot = filename.lastIndexOf('.');
    if (lastDot == -1) return 'jpg';
    return filename.substring(lastDot + 1).toLowerCase();
  }

  /// Get content type from file extension.
  String _getContentType(String extension) {
    const mimeTypes = {
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'gif': 'image/gif',
      'webp': 'image/webp',
      'heic': 'image/heic',
      'heif': 'image/heif',
    };
    return mimeTypes[extension] ?? 'image/jpeg';
  }

  /// Generate a unique photo ID.
  String _generatePhotoId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecond;
    return '${timestamp}_$random';
  }

  /// Close the HTTP client.
  void dispose() {
    _httpClient.close();
  }
}
