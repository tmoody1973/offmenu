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

/// A restaurant entry in a curated map with Eater-style editorial description.
abstract class MapRestaurant implements _i1.SerializableModel {
  MapRestaurant._({
    this.id,
    required this.mapId,
    required this.name,
    this.googlePlaceId,
    required this.editorialDescription,
    this.whyNotable,
    this.mustOrderDishes,
    this.priceLevel,
    this.cuisineTypes,
    required this.address,
    required this.city,
    this.stateOrRegion,
    this.postalCode,
    this.phoneNumber,
    this.websiteUrl,
    this.reservationUrl,
    required this.latitude,
    required this.longitude,
    this.primaryPhotoUrl,
    this.additionalPhotosJson,
    this.googleRating,
    this.googleReviewCount,
    required this.displayOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MapRestaurant({
    int? id,
    required int mapId,
    required String name,
    String? googlePlaceId,
    required String editorialDescription,
    String? whyNotable,
    String? mustOrderDishes,
    int? priceLevel,
    String? cuisineTypes,
    required String address,
    required String city,
    String? stateOrRegion,
    String? postalCode,
    String? phoneNumber,
    String? websiteUrl,
    String? reservationUrl,
    required double latitude,
    required double longitude,
    String? primaryPhotoUrl,
    String? additionalPhotosJson,
    double? googleRating,
    int? googleReviewCount,
    required int displayOrder,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MapRestaurantImpl;

  factory MapRestaurant.fromJson(Map<String, dynamic> jsonSerialization) {
    return MapRestaurant(
      id: jsonSerialization['id'] as int?,
      mapId: jsonSerialization['mapId'] as int,
      name: jsonSerialization['name'] as String,
      googlePlaceId: jsonSerialization['googlePlaceId'] as String?,
      editorialDescription: jsonSerialization['editorialDescription'] as String,
      whyNotable: jsonSerialization['whyNotable'] as String?,
      mustOrderDishes: jsonSerialization['mustOrderDishes'] as String?,
      priceLevel: jsonSerialization['priceLevel'] as int?,
      cuisineTypes: jsonSerialization['cuisineTypes'] as String?,
      address: jsonSerialization['address'] as String,
      city: jsonSerialization['city'] as String,
      stateOrRegion: jsonSerialization['stateOrRegion'] as String?,
      postalCode: jsonSerialization['postalCode'] as String?,
      phoneNumber: jsonSerialization['phoneNumber'] as String?,
      websiteUrl: jsonSerialization['websiteUrl'] as String?,
      reservationUrl: jsonSerialization['reservationUrl'] as String?,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      primaryPhotoUrl: jsonSerialization['primaryPhotoUrl'] as String?,
      additionalPhotosJson:
          jsonSerialization['additionalPhotosJson'] as String?,
      googleRating: (jsonSerialization['googleRating'] as num?)?.toDouble(),
      googleReviewCount: jsonSerialization['googleReviewCount'] as int?,
      displayOrder: jsonSerialization['displayOrder'] as int,
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

  /// The curated map this restaurant belongs to.
  int mapId;

  /// Restaurant name.
  String name;

  /// Google Places ID for fetching photos and details.
  String? googlePlaceId;

  /// Editorial description written by Perplexity (Eater-style storytelling).
  String editorialDescription;

  /// Why this restaurant is notable (awards, chef, specialty).
  String? whyNotable;

  /// Signature dishes to order.
  String? mustOrderDishes;

  /// Price range (1-4 dollar signs).
  int? priceLevel;

  /// Cuisine types (comma-separated).
  String? cuisineTypes;

  /// Full street address.
  String address;

  /// City name.
  String city;

  /// State/region.
  String? stateOrRegion;

  /// Postal/ZIP code.
  String? postalCode;

  /// Phone number.
  String? phoneNumber;

  /// Website URL.
  String? websiteUrl;

  /// Reservation link (OpenTable, Resy, etc).
  String? reservationUrl;

  /// Latitude.
  double latitude;

  /// Longitude.
  double longitude;

  /// Primary photo URL from Google Places.
  String? primaryPhotoUrl;

  /// Additional photo URLs (JSON array).
  String? additionalPhotosJson;

  /// Google rating (1-5).
  double? googleRating;

  /// Google review count.
  int? googleReviewCount;

  /// Display order within the map.
  int displayOrder;

  /// When this entry was created.
  DateTime createdAt;

  /// When this entry was last updated.
  DateTime updatedAt;

  /// Returns a shallow copy of this [MapRestaurant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MapRestaurant copyWith({
    int? id,
    int? mapId,
    String? name,
    String? googlePlaceId,
    String? editorialDescription,
    String? whyNotable,
    String? mustOrderDishes,
    int? priceLevel,
    String? cuisineTypes,
    String? address,
    String? city,
    String? stateOrRegion,
    String? postalCode,
    String? phoneNumber,
    String? websiteUrl,
    String? reservationUrl,
    double? latitude,
    double? longitude,
    String? primaryPhotoUrl,
    String? additionalPhotosJson,
    double? googleRating,
    int? googleReviewCount,
    int? displayOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MapRestaurant',
      if (id != null) 'id': id,
      'mapId': mapId,
      'name': name,
      if (googlePlaceId != null) 'googlePlaceId': googlePlaceId,
      'editorialDescription': editorialDescription,
      if (whyNotable != null) 'whyNotable': whyNotable,
      if (mustOrderDishes != null) 'mustOrderDishes': mustOrderDishes,
      if (priceLevel != null) 'priceLevel': priceLevel,
      if (cuisineTypes != null) 'cuisineTypes': cuisineTypes,
      'address': address,
      'city': city,
      if (stateOrRegion != null) 'stateOrRegion': stateOrRegion,
      if (postalCode != null) 'postalCode': postalCode,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (websiteUrl != null) 'websiteUrl': websiteUrl,
      if (reservationUrl != null) 'reservationUrl': reservationUrl,
      'latitude': latitude,
      'longitude': longitude,
      if (primaryPhotoUrl != null) 'primaryPhotoUrl': primaryPhotoUrl,
      if (additionalPhotosJson != null)
        'additionalPhotosJson': additionalPhotosJson,
      if (googleRating != null) 'googleRating': googleRating,
      if (googleReviewCount != null) 'googleReviewCount': googleReviewCount,
      'displayOrder': displayOrder,
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

class _MapRestaurantImpl extends MapRestaurant {
  _MapRestaurantImpl({
    int? id,
    required int mapId,
    required String name,
    String? googlePlaceId,
    required String editorialDescription,
    String? whyNotable,
    String? mustOrderDishes,
    int? priceLevel,
    String? cuisineTypes,
    required String address,
    required String city,
    String? stateOrRegion,
    String? postalCode,
    String? phoneNumber,
    String? websiteUrl,
    String? reservationUrl,
    required double latitude,
    required double longitude,
    String? primaryPhotoUrl,
    String? additionalPhotosJson,
    double? googleRating,
    int? googleReviewCount,
    required int displayOrder,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         mapId: mapId,
         name: name,
         googlePlaceId: googlePlaceId,
         editorialDescription: editorialDescription,
         whyNotable: whyNotable,
         mustOrderDishes: mustOrderDishes,
         priceLevel: priceLevel,
         cuisineTypes: cuisineTypes,
         address: address,
         city: city,
         stateOrRegion: stateOrRegion,
         postalCode: postalCode,
         phoneNumber: phoneNumber,
         websiteUrl: websiteUrl,
         reservationUrl: reservationUrl,
         latitude: latitude,
         longitude: longitude,
         primaryPhotoUrl: primaryPhotoUrl,
         additionalPhotosJson: additionalPhotosJson,
         googleRating: googleRating,
         googleReviewCount: googleReviewCount,
         displayOrder: displayOrder,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [MapRestaurant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MapRestaurant copyWith({
    Object? id = _Undefined,
    int? mapId,
    String? name,
    Object? googlePlaceId = _Undefined,
    String? editorialDescription,
    Object? whyNotable = _Undefined,
    Object? mustOrderDishes = _Undefined,
    Object? priceLevel = _Undefined,
    Object? cuisineTypes = _Undefined,
    String? address,
    String? city,
    Object? stateOrRegion = _Undefined,
    Object? postalCode = _Undefined,
    Object? phoneNumber = _Undefined,
    Object? websiteUrl = _Undefined,
    Object? reservationUrl = _Undefined,
    double? latitude,
    double? longitude,
    Object? primaryPhotoUrl = _Undefined,
    Object? additionalPhotosJson = _Undefined,
    Object? googleRating = _Undefined,
    Object? googleReviewCount = _Undefined,
    int? displayOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MapRestaurant(
      id: id is int? ? id : this.id,
      mapId: mapId ?? this.mapId,
      name: name ?? this.name,
      googlePlaceId: googlePlaceId is String?
          ? googlePlaceId
          : this.googlePlaceId,
      editorialDescription: editorialDescription ?? this.editorialDescription,
      whyNotable: whyNotable is String? ? whyNotable : this.whyNotable,
      mustOrderDishes: mustOrderDishes is String?
          ? mustOrderDishes
          : this.mustOrderDishes,
      priceLevel: priceLevel is int? ? priceLevel : this.priceLevel,
      cuisineTypes: cuisineTypes is String? ? cuisineTypes : this.cuisineTypes,
      address: address ?? this.address,
      city: city ?? this.city,
      stateOrRegion: stateOrRegion is String?
          ? stateOrRegion
          : this.stateOrRegion,
      postalCode: postalCode is String? ? postalCode : this.postalCode,
      phoneNumber: phoneNumber is String? ? phoneNumber : this.phoneNumber,
      websiteUrl: websiteUrl is String? ? websiteUrl : this.websiteUrl,
      reservationUrl: reservationUrl is String?
          ? reservationUrl
          : this.reservationUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      primaryPhotoUrl: primaryPhotoUrl is String?
          ? primaryPhotoUrl
          : this.primaryPhotoUrl,
      additionalPhotosJson: additionalPhotosJson is String?
          ? additionalPhotosJson
          : this.additionalPhotosJson,
      googleRating: googleRating is double? ? googleRating : this.googleRating,
      googleReviewCount: googleReviewCount is int?
          ? googleReviewCount
          : this.googleReviewCount,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
