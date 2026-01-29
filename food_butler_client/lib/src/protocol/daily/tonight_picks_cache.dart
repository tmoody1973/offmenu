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

/// Cached "Three for Tonight" picks for a user.
/// Generated once per day based on user location and preferences.
abstract class TonightPicksCache implements _i1.SerializableModel {
  TonightPicksCache._({
    this.id,
    required this.userId,
    required this.cacheDate,
    required this.city,
    this.state,
    required this.mealContext,
    required this.picksJson,
    required this.createdAt,
  });

  factory TonightPicksCache({
    int? id,
    required String userId,
    required String cacheDate,
    required String city,
    String? state,
    required String mealContext,
    required String picksJson,
    required DateTime createdAt,
  }) = _TonightPicksCacheImpl;

  factory TonightPicksCache.fromJson(Map<String, dynamic> jsonSerialization) {
    return TonightPicksCache(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      cacheDate: jsonSerialization['cacheDate'] as String,
      city: jsonSerialization['city'] as String,
      state: jsonSerialization['state'] as String?,
      mealContext: jsonSerialization['mealContext'] as String,
      picksJson: jsonSerialization['picksJson'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// User ID this cache is for.
  String userId;

  /// Date this cache is for (YYYY-MM-DD format).
  String cacheDate;

  /// City the picks are for.
  String city;

  /// State/region of the city.
  String? state;

  /// Meal context (breakfast, lunch, dinner, etc).
  String mealContext;

  /// JSON-encoded list of TonightPick objects.
  String picksJson;

  /// When this cache was created.
  DateTime createdAt;

  /// Returns a shallow copy of this [TonightPicksCache]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TonightPicksCache copyWith({
    int? id,
    String? userId,
    String? cacheDate,
    String? city,
    String? state,
    String? mealContext,
    String? picksJson,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TonightPicksCache',
      if (id != null) 'id': id,
      'userId': userId,
      'cacheDate': cacheDate,
      'city': city,
      if (state != null) 'state': state,
      'mealContext': mealContext,
      'picksJson': picksJson,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TonightPicksCacheImpl extends TonightPicksCache {
  _TonightPicksCacheImpl({
    int? id,
    required String userId,
    required String cacheDate,
    required String city,
    String? state,
    required String mealContext,
    required String picksJson,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         cacheDate: cacheDate,
         city: city,
         state: state,
         mealContext: mealContext,
         picksJson: picksJson,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [TonightPicksCache]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TonightPicksCache copyWith({
    Object? id = _Undefined,
    String? userId,
    String? cacheDate,
    String? city,
    Object? state = _Undefined,
    String? mealContext,
    String? picksJson,
    DateTime? createdAt,
  }) {
    return TonightPicksCache(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      cacheDate: cacheDate ?? this.cacheDate,
      city: city ?? this.city,
      state: state is String? ? state : this.state,
      mealContext: mealContext ?? this.mealContext,
      picksJson: picksJson ?? this.picksJson,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
