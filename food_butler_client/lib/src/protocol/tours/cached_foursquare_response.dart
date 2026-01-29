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

/// Cached Foursquare API response for reducing API calls.
abstract class CachedFoursquareResponse implements _i1.SerializableModel {
  CachedFoursquareResponse._({
    this.id,
    required this.cacheKey,
    required this.responseData,
    required this.expiresAt,
    required this.createdAt,
  });

  factory CachedFoursquareResponse({
    int? id,
    required String cacheKey,
    required String responseData,
    required DateTime expiresAt,
    required DateTime createdAt,
  }) = _CachedFoursquareResponseImpl;

  factory CachedFoursquareResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CachedFoursquareResponse(
      id: jsonSerialization['id'] as int?,
      cacheKey: jsonSerialization['cacheKey'] as String,
      responseData: jsonSerialization['responseData'] as String,
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Unique cache key generated from query parameters.
  String cacheKey;

  /// Raw response data as JSON string.
  String responseData;

  /// When the cache entry expires.
  DateTime expiresAt;

  /// When the cache entry was created.
  DateTime createdAt;

  /// Returns a shallow copy of this [CachedFoursquareResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CachedFoursquareResponse copyWith({
    int? id,
    String? cacheKey,
    String? responseData,
    DateTime? expiresAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CachedFoursquareResponse',
      if (id != null) 'id': id,
      'cacheKey': cacheKey,
      'responseData': responseData,
      'expiresAt': expiresAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CachedFoursquareResponseImpl extends CachedFoursquareResponse {
  _CachedFoursquareResponseImpl({
    int? id,
    required String cacheKey,
    required String responseData,
    required DateTime expiresAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         cacheKey: cacheKey,
         responseData: responseData,
         expiresAt: expiresAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [CachedFoursquareResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CachedFoursquareResponse copyWith({
    Object? id = _Undefined,
    String? cacheKey,
    String? responseData,
    DateTime? expiresAt,
    DateTime? createdAt,
  }) {
    return CachedFoursquareResponse(
      id: id is int? ? id : this.id,
      cacheKey: cacheKey ?? this.cacheKey,
      responseData: responseData ?? this.responseData,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
