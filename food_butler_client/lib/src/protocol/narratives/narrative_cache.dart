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

/// Cached LLM-generated narrative content for tours.
abstract class NarrativeCache implements _i1.SerializableModel {
  NarrativeCache._({
    this.id,
    required this.tourId,
    this.userId,
    required this.narrativeType,
    this.stopIndex,
    required this.content,
    required this.generatedAt,
    required this.expiresAt,
    required this.cacheHitCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NarrativeCache({
    int? id,
    required int tourId,
    String? userId,
    required String narrativeType,
    int? stopIndex,
    required String content,
    required DateTime generatedAt,
    required DateTime expiresAt,
    required int cacheHitCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _NarrativeCacheImpl;

  factory NarrativeCache.fromJson(Map<String, dynamic> jsonSerialization) {
    return NarrativeCache(
      id: jsonSerialization['id'] as int?,
      tourId: jsonSerialization['tourId'] as int,
      userId: jsonSerialization['userId'] as String?,
      narrativeType: jsonSerialization['narrativeType'] as String,
      stopIndex: jsonSerialization['stopIndex'] as int?,
      content: jsonSerialization['content'] as String,
      generatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['generatedAt'],
      ),
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      cacheHitCount: jsonSerialization['cacheHitCount'] as int,
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

  /// Reference to the tour result this narrative belongs to.
  int tourId;

  /// User ID for personalized narratives (null for anonymous users).
  String? userId;

  /// Type of narrative (intro, description, transition).
  String narrativeType;

  /// Stop index for description/transition narratives (null for intro).
  int? stopIndex;

  /// The generated narrative content.
  String content;

  /// When the narrative was generated.
  DateTime generatedAt;

  /// When the cache entry expires.
  DateTime expiresAt;

  /// Number of cache hits for monitoring.
  int cacheHitCount;

  /// When the record was created.
  DateTime createdAt;

  /// When the record was last updated.
  DateTime updatedAt;

  /// Returns a shallow copy of this [NarrativeCache]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NarrativeCache copyWith({
    int? id,
    int? tourId,
    String? userId,
    String? narrativeType,
    int? stopIndex,
    String? content,
    DateTime? generatedAt,
    DateTime? expiresAt,
    int? cacheHitCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NarrativeCache',
      if (id != null) 'id': id,
      'tourId': tourId,
      if (userId != null) 'userId': userId,
      'narrativeType': narrativeType,
      if (stopIndex != null) 'stopIndex': stopIndex,
      'content': content,
      'generatedAt': generatedAt.toJson(),
      'expiresAt': expiresAt.toJson(),
      'cacheHitCount': cacheHitCount,
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

class _NarrativeCacheImpl extends NarrativeCache {
  _NarrativeCacheImpl({
    int? id,
    required int tourId,
    String? userId,
    required String narrativeType,
    int? stopIndex,
    required String content,
    required DateTime generatedAt,
    required DateTime expiresAt,
    required int cacheHitCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         tourId: tourId,
         userId: userId,
         narrativeType: narrativeType,
         stopIndex: stopIndex,
         content: content,
         generatedAt: generatedAt,
         expiresAt: expiresAt,
         cacheHitCount: cacheHitCount,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [NarrativeCache]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NarrativeCache copyWith({
    Object? id = _Undefined,
    int? tourId,
    Object? userId = _Undefined,
    String? narrativeType,
    Object? stopIndex = _Undefined,
    String? content,
    DateTime? generatedAt,
    DateTime? expiresAt,
    int? cacheHitCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NarrativeCache(
      id: id is int? ? id : this.id,
      tourId: tourId ?? this.tourId,
      userId: userId is String? ? userId : this.userId,
      narrativeType: narrativeType ?? this.narrativeType,
      stopIndex: stopIndex is int? ? stopIndex : this.stopIndex,
      content: content ?? this.content,
      generatedAt: generatedAt ?? this.generatedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      cacheHitCount: cacheHitCount ?? this.cacheHitCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
