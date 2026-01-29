/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// A photo attached to a journal entry, stored in Cloudflare R2.
abstract class JournalPhoto implements _i1.SerializableModel {
  JournalPhoto._({
    this.id,
    required this.journalEntryId,
    required this.originalUrl,
    required this.thumbnailUrl,
    required this.displayOrder,
    required this.uploadedAt,
  });

  factory JournalPhoto({
    int? id,
    required int journalEntryId,
    required String originalUrl,
    required String thumbnailUrl,
    required int displayOrder,
    required DateTime uploadedAt,
  }) = _JournalPhotoImpl;

  factory JournalPhoto.fromJson(Map<String, dynamic> jsonSerialization) {
    return JournalPhoto(
      id: jsonSerialization['id'] as int?,
      journalEntryId: jsonSerialization['journalEntryId'] as int,
      originalUrl: jsonSerialization['originalUrl'] as String,
      thumbnailUrl: jsonSerialization['thumbnailUrl'] as String,
      displayOrder: jsonSerialization['displayOrder'] as int,
      uploadedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['uploadedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The journal entry this photo belongs to.
  int journalEntryId;

  /// URL for the full-size image in R2.
  String originalUrl;

  /// URL for the 200x200 thumbnail in R2.
  String thumbnailUrl;

  /// Display order for the photo (0-2).
  int displayOrder;

  /// When the photo was uploaded.
  DateTime uploadedAt;

  /// Returns a shallow copy of this [JournalPhoto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  JournalPhoto copyWith({
    int? id,
    int? journalEntryId,
    String? originalUrl,
    String? thumbnailUrl,
    int? displayOrder,
    DateTime? uploadedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'JournalPhoto',
      if (id != null) 'id': id,
      'journalEntryId': journalEntryId,
      'originalUrl': originalUrl,
      'thumbnailUrl': thumbnailUrl,
      'displayOrder': displayOrder,
      'uploadedAt': uploadedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _JournalPhotoImpl extends JournalPhoto {
  _JournalPhotoImpl({
    int? id,
    required int journalEntryId,
    required String originalUrl,
    required String thumbnailUrl,
    required int displayOrder,
    required DateTime uploadedAt,
  }) : super._(
         id: id,
         journalEntryId: journalEntryId,
         originalUrl: originalUrl,
         thumbnailUrl: thumbnailUrl,
         displayOrder: displayOrder,
         uploadedAt: uploadedAt,
       );

  /// Returns a shallow copy of this [JournalPhoto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  JournalPhoto copyWith({
    Object? id = _Undefined,
    int? journalEntryId,
    String? originalUrl,
    String? thumbnailUrl,
    int? displayOrder,
    DateTime? uploadedAt,
  }) {
    return JournalPhoto(
      id: id is int? ? id : this.id,
      journalEntryId: journalEntryId ?? this.journalEntryId,
      originalUrl: originalUrl ?? this.originalUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      displayOrder: displayOrder ?? this.displayOrder,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }
}
