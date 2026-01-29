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
import 'saved_restaurant_source.dart' as _i2;

/// A restaurant saved/bookmarked by the user.
///
/// Allows users to save restaurants from maps, Ask the Butler,
/// or stories for later reference.
abstract class SavedRestaurant implements _i1.SerializableModel {
  SavedRestaurant._({
    this.id,
    required this.userId,
    required this.name,
    this.placeId,
    this.address,
    this.cuisineType,
    this.imageUrl,
    this.rating,
    this.priceLevel,
    this.notes,
    this.userRating,
    required this.source,
    required this.savedAt,
  });

  factory SavedRestaurant({
    int? id,
    required String userId,
    required String name,
    String? placeId,
    String? address,
    String? cuisineType,
    String? imageUrl,
    double? rating,
    int? priceLevel,
    String? notes,
    int? userRating,
    required _i2.SavedRestaurantSource source,
    required DateTime savedAt,
  }) = _SavedRestaurantImpl;

  factory SavedRestaurant.fromJson(Map<String, dynamic> jsonSerialization) {
    return SavedRestaurant(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      name: jsonSerialization['name'] as String,
      placeId: jsonSerialization['placeId'] as String?,
      address: jsonSerialization['address'] as String?,
      cuisineType: jsonSerialization['cuisineType'] as String?,
      imageUrl: jsonSerialization['imageUrl'] as String?,
      rating: (jsonSerialization['rating'] as num?)?.toDouble(),
      priceLevel: jsonSerialization['priceLevel'] as int?,
      notes: jsonSerialization['notes'] as String?,
      userRating: jsonSerialization['userRating'] as int?,
      source: _i2.SavedRestaurantSource.fromJson(
        (jsonSerialization['source'] as String),
      ),
      savedAt: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['savedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The user who saved this restaurant.
  String userId;

  /// Restaurant name.
  String name;

  /// Google Place ID for looking up details.
  String? placeId;

  /// Restaurant address.
  String? address;

  /// Type of cuisine.
  String? cuisineType;

  /// Photo URL.
  String? imageUrl;

  /// Google rating (0-5).
  double? rating;

  /// Price level (1-4).
  int? priceLevel;

  /// User's personal notes about this restaurant.
  String? notes;

  /// User's personal rating (1-5 stars).
  int? userRating;

  /// Where the restaurant was saved from.
  _i2.SavedRestaurantSource source;

  /// When it was saved.
  DateTime savedAt;

  /// Returns a shallow copy of this [SavedRestaurant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SavedRestaurant copyWith({
    int? id,
    String? userId,
    String? name,
    String? placeId,
    String? address,
    String? cuisineType,
    String? imageUrl,
    double? rating,
    int? priceLevel,
    String? notes,
    int? userRating,
    _i2.SavedRestaurantSource? source,
    DateTime? savedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SavedRestaurant',
      if (id != null) 'id': id,
      'userId': userId,
      'name': name,
      if (placeId != null) 'placeId': placeId,
      if (address != null) 'address': address,
      if (cuisineType != null) 'cuisineType': cuisineType,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (rating != null) 'rating': rating,
      if (priceLevel != null) 'priceLevel': priceLevel,
      if (notes != null) 'notes': notes,
      if (userRating != null) 'userRating': userRating,
      'source': source.toJson(),
      'savedAt': savedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SavedRestaurantImpl extends SavedRestaurant {
  _SavedRestaurantImpl({
    int? id,
    required String userId,
    required String name,
    String? placeId,
    String? address,
    String? cuisineType,
    String? imageUrl,
    double? rating,
    int? priceLevel,
    String? notes,
    int? userRating,
    required _i2.SavedRestaurantSource source,
    required DateTime savedAt,
  }) : super._(
         id: id,
         userId: userId,
         name: name,
         placeId: placeId,
         address: address,
         cuisineType: cuisineType,
         imageUrl: imageUrl,
         rating: rating,
         priceLevel: priceLevel,
         notes: notes,
         userRating: userRating,
         source: source,
         savedAt: savedAt,
       );

  /// Returns a shallow copy of this [SavedRestaurant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SavedRestaurant copyWith({
    Object? id = _Undefined,
    String? userId,
    String? name,
    Object? placeId = _Undefined,
    Object? address = _Undefined,
    Object? cuisineType = _Undefined,
    Object? imageUrl = _Undefined,
    Object? rating = _Undefined,
    Object? priceLevel = _Undefined,
    Object? notes = _Undefined,
    Object? userRating = _Undefined,
    _i2.SavedRestaurantSource? source,
    DateTime? savedAt,
  }) {
    return SavedRestaurant(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      placeId: placeId is String? ? placeId : this.placeId,
      address: address is String? ? address : this.address,
      cuisineType: cuisineType is String? ? cuisineType : this.cuisineType,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      rating: rating is double? ? rating : this.rating,
      priceLevel: priceLevel is int? ? priceLevel : this.priceLevel,
      notes: notes is String? ? notes : this.notes,
      userRating: userRating is int? ? userRating : this.userRating,
      source: source ?? this.source,
      savedAt: savedAt ?? this.savedAt,
    );
  }
}
