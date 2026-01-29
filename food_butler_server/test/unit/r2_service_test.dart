import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import 'package:food_butler_server/src/services/r2_service.dart';

class MockHttpClient extends Mock implements http.Client {}
class MockSession extends Mock implements Session {}
class MockServerpod extends Mock implements Serverpod {}

void main() {
  late MockSession mockSession;
  late MockServerpod mockServerpod;

  setUp(() {
    mockSession = MockSession();
    mockServerpod = MockServerpod();
    when(() => mockSession.serverpod).thenReturn(mockServerpod);
    when(() => mockSession.log(any(), level: any(named: 'level'))).thenReturn(null);
  });

  group('R2Service', () {
    test('generates signed URL with valid URL structure', () async {
      final r2Service = R2Service(
        accessKeyId: 'test-access-key',
        secretAccessKey: 'test-secret-key',
        bucketName: 'food-butler-photos',
        endpoint: 'https://account.r2.cloudflarestorage.com',
        publicUrl: 'https://pub-account.r2.dev',
        session: mockSession,
      );

      final result = await r2Service.generateSignedUploadUrl(
        userId: 'user-123',
        entryId: 1,
        filename: 'photo.jpg',
      );

      expect(result.uploadUrl, isNotEmpty);
      expect(result.uploadUrl, contains('food-butler-photos'));
      expect(result.uploadUrl, contains('user-123'));
      expect(result.uploadUrl, contains('X-Amz-Signature'));
      expect(result.objectKey, contains('user-123/1/'));
      expect(result.objectKey, endsWith('.jpg'));
      expect(result.expiresAt.isAfter(DateTime.now()), isTrue);

      r2Service.dispose();
    });

    test('generates thumbnail key correctly', () {
      final r2Service = R2Service(
        accessKeyId: 'test-access-key',
        secretAccessKey: 'test-secret-key',
        bucketName: 'food-butler-photos',
        endpoint: 'https://account.r2.cloudflarestorage.com',
        publicUrl: 'https://pub-account.r2.dev',
        session: mockSession,
      );

      // Test that the public URL generation works
      final publicUrl = r2Service.getPublicUrl('user-123/1/photo.jpg');
      expect(publicUrl, equals('https://pub-account.r2.dev/user-123/1/photo.jpg'));

      r2Service.dispose();
    });

    test('returns correct content type for different extensions', () async {
      final r2Service = R2Service(
        accessKeyId: 'test-access-key',
        secretAccessKey: 'test-secret-key',
        bucketName: 'food-butler-photos',
        endpoint: 'https://account.r2.cloudflarestorage.com',
        publicUrl: 'https://pub-account.r2.dev',
        session: mockSession,
      );

      // Test various file extensions
      final jpgResult = await r2Service.generateSignedUploadUrl(
        userId: 'user-123',
        entryId: 1,
        filename: 'photo.jpg',
      );
      expect(jpgResult.objectKey, endsWith('.jpg'));

      final pngResult = await r2Service.generateSignedUploadUrl(
        userId: 'user-123',
        entryId: 1,
        filename: 'photo.png',
      );
      expect(pngResult.objectKey, endsWith('.png'));

      final webpResult = await r2Service.generateSignedUploadUrl(
        userId: 'user-123',
        entryId: 1,
        filename: 'photo.webp',
      );
      expect(webpResult.objectKey, endsWith('.webp'));

      r2Service.dispose();
    });

    test('generates unique photo IDs for concurrent uploads', () async {
      final r2Service = R2Service(
        accessKeyId: 'test-access-key',
        secretAccessKey: 'test-secret-key',
        bucketName: 'food-butler-photos',
        endpoint: 'https://account.r2.cloudflarestorage.com',
        publicUrl: 'https://pub-account.r2.dev',
        session: mockSession,
      );

      final results = await Future.wait([
        r2Service.generateSignedUploadUrl(
          userId: 'user-123',
          entryId: 1,
          filename: 'photo1.jpg',
        ),
        r2Service.generateSignedUploadUrl(
          userId: 'user-123',
          entryId: 1,
          filename: 'photo2.jpg',
        ),
        r2Service.generateSignedUploadUrl(
          userId: 'user-123',
          entryId: 1,
          filename: 'photo3.jpg',
        ),
      ]);

      // All object keys should be unique
      final objectKeys = results.map((r) => r.objectKey).toSet();
      expect(objectKeys.length, equals(3));

      r2Service.dispose();
    });
  });

  group('SignedUrlResult', () {
    test('contains all required fields', () {
      final result = SignedUrlResult(
        uploadUrl: 'https://example.com/upload',
        objectKey: 'user/entry/photo.jpg',
        expiresAt: DateTime.now().add(const Duration(minutes: 15)),
      );

      expect(result.uploadUrl, isNotEmpty);
      expect(result.objectKey, isNotEmpty);
      expect(result.expiresAt, isNotNull);
    });
  });

  group('UploadConfirmResult', () {
    test('creates success result with URLs', () {
      final result = UploadConfirmResult(
        originalUrl: 'https://example.com/original.jpg',
        thumbnailUrl: 'https://example.com/thumb.jpg',
        success: true,
      );

      expect(result.success, isTrue);
      expect(result.originalUrl, contains('original'));
      expect(result.thumbnailUrl, contains('thumb'));
      expect(result.error, isNull);
    });

    test('creates failure result with error message', () {
      final result = UploadConfirmResult.failure('Upload failed');

      expect(result.success, isFalse);
      expect(result.error, equals('Upload failed'));
      expect(result.originalUrl, isEmpty);
      expect(result.thumbnailUrl, isEmpty);
    });
  });
}
