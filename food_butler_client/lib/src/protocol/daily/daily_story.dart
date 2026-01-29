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
import '../daily/daily_story_type.dart' as _i2;

/// Personalized daily story for a user.
/// Generated once per day based on user profile and preferences.
abstract class DailyStory implements _i1.SerializableModel {
  DailyStory._({
    this.id,
    required this.userId,
    required this.storyDate,
    required this.city,
    this.state,
    this.country,
    required this.headline,
    required this.subheadline,
    this.bodyText,
    required this.restaurantName,
    this.restaurantAddress,
    this.restaurantPlaceId,
    required this.heroImageUrl,
    this.thumbnailUrl,
    required this.storyType,
    this.cuisineType,
    this.sourceUrl,
    required this.createdAt,
  });

  factory DailyStory({
    int? id,
    required String userId,
    required String storyDate,
    required String city,
    String? state,
    String? country,
    required String headline,
    required String subheadline,
    String? bodyText,
    required String restaurantName,
    String? restaurantAddress,
    String? restaurantPlaceId,
    required String heroImageUrl,
    String? thumbnailUrl,
    required _i2.DailyStoryType storyType,
    String? cuisineType,
    String? sourceUrl,
    required DateTime createdAt,
  }) = _DailyStoryImpl;

  factory DailyStory.fromJson(Map<String, dynamic> jsonSerialization) {
    return DailyStory(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      storyDate: jsonSerialization['storyDate'] as String,
      city: jsonSerialization['city'] as String,
      state: jsonSerialization['state'] as String?,
      country: jsonSerialization['country'] as String?,
      headline: jsonSerialization['headline'] as String,
      subheadline: jsonSerialization['subheadline'] as String,
      bodyText: jsonSerialization['bodyText'] as String?,
      restaurantName: jsonSerialization['restaurantName'] as String,
      restaurantAddress: jsonSerialization['restaurantAddress'] as String?,
      restaurantPlaceId: jsonSerialization['restaurantPlaceId'] as String?,
      heroImageUrl: jsonSerialization['heroImageUrl'] as String,
      thumbnailUrl: jsonSerialization['thumbnailUrl'] as String?,
      storyType: _i2.DailyStoryType.fromJson(
        (jsonSerialization['storyType'] as String),
      ),
      cuisineType: jsonSerialization['cuisineType'] as String?,
      sourceUrl: jsonSerialization['sourceUrl'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// User ID this story is for.
  String userId;

  /// Date this story is for (YYYY-MM-DD format).
  String storyDate;

  /// City the story is about.
  String city;

  /// State/region of the city.
  String? state;

  /// Country of the city.
  String? country;

  /// Compelling headline (magazine style, 8-15 words).
  String headline;

  /// 1-2 sentence teaser that hooks the reader.
  String subheadline;

  /// Full story text (2-3 paragraphs, optional).
  String? bodyText;

  /// Name of the featured restaurant.
  String restaurantName;

  /// Restaurant street address.
  String? restaurantAddress;

  /// Google Places ID for the restaurant.
  String? restaurantPlaceId;

  /// Hero image URL (proxied through our server).
  String heroImageUrl;

  /// Thumbnail image URL.
  String? thumbnailUrl;

  /// Type of story (hidden gem, legacy, etc).
  _i2.DailyStoryType storyType;

  /// Cuisine type featured in the story.
  String? cuisineType;

  /// Source URL for attribution/citation.
  String? sourceUrl;

  /// When this story was generated.
  DateTime createdAt;

  /// Returns a shallow copy of this [DailyStory]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DailyStory copyWith({
    int? id,
    String? userId,
    String? storyDate,
    String? city,
    String? state,
    String? country,
    String? headline,
    String? subheadline,
    String? bodyText,
    String? restaurantName,
    String? restaurantAddress,
    String? restaurantPlaceId,
    String? heroImageUrl,
    String? thumbnailUrl,
    _i2.DailyStoryType? storyType,
    String? cuisineType,
    String? sourceUrl,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DailyStory',
      if (id != null) 'id': id,
      'userId': userId,
      'storyDate': storyDate,
      'city': city,
      if (state != null) 'state': state,
      if (country != null) 'country': country,
      'headline': headline,
      'subheadline': subheadline,
      if (bodyText != null) 'bodyText': bodyText,
      'restaurantName': restaurantName,
      if (restaurantAddress != null) 'restaurantAddress': restaurantAddress,
      if (restaurantPlaceId != null) 'restaurantPlaceId': restaurantPlaceId,
      'heroImageUrl': heroImageUrl,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
      'storyType': storyType.toJson(),
      if (cuisineType != null) 'cuisineType': cuisineType,
      if (sourceUrl != null) 'sourceUrl': sourceUrl,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DailyStoryImpl extends DailyStory {
  _DailyStoryImpl({
    int? id,
    required String userId,
    required String storyDate,
    required String city,
    String? state,
    String? country,
    required String headline,
    required String subheadline,
    String? bodyText,
    required String restaurantName,
    String? restaurantAddress,
    String? restaurantPlaceId,
    required String heroImageUrl,
    String? thumbnailUrl,
    required _i2.DailyStoryType storyType,
    String? cuisineType,
    String? sourceUrl,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         storyDate: storyDate,
         city: city,
         state: state,
         country: country,
         headline: headline,
         subheadline: subheadline,
         bodyText: bodyText,
         restaurantName: restaurantName,
         restaurantAddress: restaurantAddress,
         restaurantPlaceId: restaurantPlaceId,
         heroImageUrl: heroImageUrl,
         thumbnailUrl: thumbnailUrl,
         storyType: storyType,
         cuisineType: cuisineType,
         sourceUrl: sourceUrl,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [DailyStory]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DailyStory copyWith({
    Object? id = _Undefined,
    String? userId,
    String? storyDate,
    String? city,
    Object? state = _Undefined,
    Object? country = _Undefined,
    String? headline,
    String? subheadline,
    Object? bodyText = _Undefined,
    String? restaurantName,
    Object? restaurantAddress = _Undefined,
    Object? restaurantPlaceId = _Undefined,
    String? heroImageUrl,
    Object? thumbnailUrl = _Undefined,
    _i2.DailyStoryType? storyType,
    Object? cuisineType = _Undefined,
    Object? sourceUrl = _Undefined,
    DateTime? createdAt,
  }) {
    return DailyStory(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      storyDate: storyDate ?? this.storyDate,
      city: city ?? this.city,
      state: state is String? ? state : this.state,
      country: country is String? ? country : this.country,
      headline: headline ?? this.headline,
      subheadline: subheadline ?? this.subheadline,
      bodyText: bodyText is String? ? bodyText : this.bodyText,
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantAddress: restaurantAddress is String?
          ? restaurantAddress
          : this.restaurantAddress,
      restaurantPlaceId: restaurantPlaceId is String?
          ? restaurantPlaceId
          : this.restaurantPlaceId,
      heroImageUrl: heroImageUrl ?? this.heroImageUrl,
      thumbnailUrl: thumbnailUrl is String? ? thumbnailUrl : this.thumbnailUrl,
      storyType: storyType ?? this.storyType,
      cuisineType: cuisineType is String? ? cuisineType : this.cuisineType,
      sourceUrl: sourceUrl is String? ? sourceUrl : this.sourceUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
