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

/// Tracks regenerate attempts per tour per day for rate limiting.
abstract class NarrativeRegenerateLimit implements _i1.SerializableModel {
  NarrativeRegenerateLimit._({
    this.id,
    required this.tourId,
    required this.userId,
    required this.limitDate,
    required this.attemptCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NarrativeRegenerateLimit({
    int? id,
    required int tourId,
    required String userId,
    required DateTime limitDate,
    required int attemptCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _NarrativeRegenerateLimitImpl;

  factory NarrativeRegenerateLimit.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NarrativeRegenerateLimit(
      id: jsonSerialization['id'] as int?,
      tourId: jsonSerialization['tourId'] as int,
      userId: jsonSerialization['userId'] as String,
      limitDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['limitDate'],
      ),
      attemptCount: jsonSerialization['attemptCount'] as int,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Reference to the tour result.
  int tourId;

  /// User ID for tracking (or 'anonymous').
  String userId;

  /// Date for the limit tracking (truncated to day).
  DateTime limitDate;

  /// Number of regenerate attempts on this date.
  int attemptCount;

  /// When the record was created.
  DateTime createdAt;

  /// When the record was last updated.
  DateTime updatedAt;

  /// Returns a shallow copy of this [NarrativeRegenerateLimit]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NarrativeRegenerateLimit copyWith({
    int? id,
    int? tourId,
    String? userId,
    DateTime? limitDate,
    int? attemptCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NarrativeRegenerateLimit',
      if (id != null) 'id': id,
      'tourId': tourId,
      'userId': userId,
      'limitDate': limitDate.toJson(),
      'attemptCount': attemptCount,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NarrativeRegenerateLimitImpl extends NarrativeRegenerateLimit {
  _NarrativeRegenerateLimitImpl({
    int? id,
    required int tourId,
    required String userId,
    required DateTime limitDate,
    required int attemptCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         tourId: tourId,
         userId: userId,
         limitDate: limitDate,
         attemptCount: attemptCount,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [NarrativeRegenerateLimit]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NarrativeRegenerateLimit copyWith({
    Object? id = _Undefined,
    int? tourId,
    String? userId,
    DateTime? limitDate,
    int? attemptCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NarrativeRegenerateLimit(
      id: id is int? ? id : this.id,
      tourId: tourId ?? this.tourId,
      userId: userId ?? this.userId,
      limitDate: limitDate ?? this.limitDate,
      attemptCount: attemptCount ?? this.attemptCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
