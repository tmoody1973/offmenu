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

/// A curated restaurant map like Eater's "Best Tacos in Austin" or "38 Best Restaurants in Chicago 2026".
/// Can be system-generated (Perplexity) or user-created custom maps.
abstract class CuratedMap implements _i1.SerializableModel {
  CuratedMap._({
    this.id,
    this.userId,
    required this.isUserCreated,
    required this.cityName,
    this.stateOrRegion,
    required this.country,
    required this.title,
    required this.slug,
    required this.category,
    this.cuisineType,
    required this.shortDescription,
    this.introText,
    this.coverImageUrl,
    required this.restaurantCount,
    required this.lastUpdatedAt,
    required this.createdAt,
    required this.isPublished,
  });

  factory CuratedMap({
    int? id,
    String? userId,
    required bool isUserCreated,
    required String cityName,
    String? stateOrRegion,
    required String country,
    required String title,
    required String slug,
    required String category,
    String? cuisineType,
    required String shortDescription,
    String? introText,
    String? coverImageUrl,
    required int restaurantCount,
    required DateTime lastUpdatedAt,
    required DateTime createdAt,
    required bool isPublished,
  }) = _CuratedMapImpl;

  factory CuratedMap.fromJson(Map<String, dynamic> jsonSerialization) {
    return CuratedMap(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String?,
      isUserCreated: jsonSerialization['isUserCreated'] as bool,
      cityName: jsonSerialization['cityName'] as String,
      stateOrRegion: jsonSerialization['stateOrRegion'] as String?,
      country: jsonSerialization['country'] as String,
      title: jsonSerialization['title'] as String,
      slug: jsonSerialization['slug'] as String,
      category: jsonSerialization['category'] as String,
      cuisineType: jsonSerialization['cuisineType'] as String?,
      shortDescription: jsonSerialization['shortDescription'] as String,
      introText: jsonSerialization['introText'] as String?,
      coverImageUrl: jsonSerialization['coverImageUrl'] as String?,
      restaurantCount: jsonSerialization['restaurantCount'] as int,
      lastUpdatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastUpdatedAt'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      isPublished: jsonSerialization['isPublished'] as bool,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// User ID if this is a user-created map (null for system maps).
  String? userId;

  /// Whether this is a user-created custom map.
  bool isUserCreated;

  /// City this map is for.
  String cityName;

  /// State/region.
  String? stateOrRegion;

  /// Country.
  String country;

  /// Map title (e.g., "Best Tacos in Austin", "Hidden Gems in Chicago").
  String title;

  /// Map slug for URL (e.g., "best-tacos-austin", "hidden-gems-chicago").
  String slug;

  /// Map category (e.g., "best-of", "cuisine", "occasion", "neighborhood").
  String category;

  /// Cuisine type if applicable (e.g., "Mexican", "Japanese").
  String? cuisineType;

  /// Short description for the map listing.
  String shortDescription;

  /// Full editorial intro paragraph written by Perplexity.
  String? introText;

  /// Cover image URL (from one of the restaurants).
  String? coverImageUrl;

  /// Number of restaurants in this map.
  int restaurantCount;

  /// When this map was last updated.
  DateTime lastUpdatedAt;

  /// When this map was created.
  DateTime createdAt;

  /// Whether this map is published/visible.
  bool isPublished;

  /// Returns a shallow copy of this [CuratedMap]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CuratedMap copyWith({
    int? id,
    String? userId,
    bool? isUserCreated,
    String? cityName,
    String? stateOrRegion,
    String? country,
    String? title,
    String? slug,
    String? category,
    String? cuisineType,
    String? shortDescription,
    String? introText,
    String? coverImageUrl,
    int? restaurantCount,
    DateTime? lastUpdatedAt,
    DateTime? createdAt,
    bool? isPublished,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CuratedMap',
      if (id != null) 'id': id,
      if (userId != null) 'userId': userId,
      'isUserCreated': isUserCreated,
      'cityName': cityName,
      if (stateOrRegion != null) 'stateOrRegion': stateOrRegion,
      'country': country,
      'title': title,
      'slug': slug,
      'category': category,
      if (cuisineType != null) 'cuisineType': cuisineType,
      'shortDescription': shortDescription,
      if (introText != null) 'introText': introText,
      if (coverImageUrl != null) 'coverImageUrl': coverImageUrl,
      'restaurantCount': restaurantCount,
      'lastUpdatedAt': lastUpdatedAt.toJson(),
      'createdAt': createdAt.toJson(),
      'isPublished': isPublished,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CuratedMapImpl extends CuratedMap {
  _CuratedMapImpl({
    int? id,
    String? userId,
    required bool isUserCreated,
    required String cityName,
    String? stateOrRegion,
    required String country,
    required String title,
    required String slug,
    required String category,
    String? cuisineType,
    required String shortDescription,
    String? introText,
    String? coverImageUrl,
    required int restaurantCount,
    required DateTime lastUpdatedAt,
    required DateTime createdAt,
    required bool isPublished,
  }) : super._(
         id: id,
         userId: userId,
         isUserCreated: isUserCreated,
         cityName: cityName,
         stateOrRegion: stateOrRegion,
         country: country,
         title: title,
         slug: slug,
         category: category,
         cuisineType: cuisineType,
         shortDescription: shortDescription,
         introText: introText,
         coverImageUrl: coverImageUrl,
         restaurantCount: restaurantCount,
         lastUpdatedAt: lastUpdatedAt,
         createdAt: createdAt,
         isPublished: isPublished,
       );

  /// Returns a shallow copy of this [CuratedMap]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CuratedMap copyWith({
    Object? id = _Undefined,
    Object? userId = _Undefined,
    bool? isUserCreated,
    String? cityName,
    Object? stateOrRegion = _Undefined,
    String? country,
    String? title,
    String? slug,
    String? category,
    Object? cuisineType = _Undefined,
    String? shortDescription,
    Object? introText = _Undefined,
    Object? coverImageUrl = _Undefined,
    int? restaurantCount,
    DateTime? lastUpdatedAt,
    DateTime? createdAt,
    bool? isPublished,
  }) {
    return CuratedMap(
      id: id is int? ? id : this.id,
      userId: userId is String? ? userId : this.userId,
      isUserCreated: isUserCreated ?? this.isUserCreated,
      cityName: cityName ?? this.cityName,
      stateOrRegion: stateOrRegion is String?
          ? stateOrRegion
          : this.stateOrRegion,
      country: country ?? this.country,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      category: category ?? this.category,
      cuisineType: cuisineType is String? ? cuisineType : this.cuisineType,
      shortDescription: shortDescription ?? this.shortDescription,
      introText: introText is String? ? introText : this.introText,
      coverImageUrl: coverImageUrl is String?
          ? coverImageUrl
          : this.coverImageUrl,
      restaurantCount: restaurantCount ?? this.restaurantCount,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      createdAt: createdAt ?? this.createdAt,
      isPublished: isPublished ?? this.isPublished,
    );
  }
}
