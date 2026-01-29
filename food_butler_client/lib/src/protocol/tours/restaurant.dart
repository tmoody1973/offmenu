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
import 'package:food_butler_client/src/protocol/protocol.dart' as _i2;

/// Restaurant data from Foursquare Places API.
abstract class Restaurant implements _i1.SerializableModel {
  Restaurant._({
    this.id,
    required this.fsqId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.priceTier,
    this.rating,
    required this.cuisineTypes,
    this.description,
    this.hours,
    this.dishData,
    this.opentableId,
    this.opentableSlug,
    this.phone,
    this.websiteUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Restaurant({
    int? id,
    required String fsqId,
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required int priceTier,
    double? rating,
    required List<String> cuisineTypes,
    String? description,
    String? hours,
    String? dishData,
    String? opentableId,
    String? opentableSlug,
    String? phone,
    String? websiteUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RestaurantImpl;

  factory Restaurant.fromJson(Map<String, dynamic> jsonSerialization) {
    return Restaurant(
      id: jsonSerialization['id'] as int?,
      fsqId: jsonSerialization['fsqId'] as String,
      name: jsonSerialization['name'] as String,
      address: jsonSerialization['address'] as String,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      priceTier: jsonSerialization['priceTier'] as int,
      rating: (jsonSerialization['rating'] as num?)?.toDouble(),
      cuisineTypes: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['cuisineTypes'],
      ),
      description: jsonSerialization['description'] as String?,
      hours: jsonSerialization['hours'] as String?,
      dishData: jsonSerialization['dishData'] as String?,
      opentableId: jsonSerialization['opentableId'] as String?,
      opentableSlug: jsonSerialization['opentableSlug'] as String?,
      phone: jsonSerialization['phone'] as String?,
      websiteUrl: jsonSerialization['websiteUrl'] as String?,
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

  /// Foursquare unique identifier.
  String fsqId;

  /// Restaurant name.
  String name;

  /// Full address string.
  String address;

  /// Latitude coordinate.
  double latitude;

  /// Longitude coordinate.
  double longitude;

  /// Price tier (1-4, where 1 is cheapest).
  int priceTier;

  /// Rating from 0-10 scale.
  double? rating;

  /// List of cuisine types.
  List<String> cuisineTypes;

  /// Description of what makes this restaurant special (from AI discovery).
  String? description;

  /// Operating hours as JSON structure.
  String? hours;

  /// Dish-level data for digestion optimization.
  String? dishData;

  /// OpenTable restaurant ID for exact matching.
  String? opentableId;

  /// OpenTable URL slug for web deep links.
  String? opentableSlug;

  /// Phone number for fallback contact.
  String? phone;

  /// Website URL for fallback contact.
  String? websiteUrl;

  /// When the record was created.
  DateTime createdAt;

  /// When the record was last updated.
  DateTime updatedAt;

  /// Returns a shallow copy of this [Restaurant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Restaurant copyWith({
    int? id,
    String? fsqId,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    int? priceTier,
    double? rating,
    List<String>? cuisineTypes,
    String? description,
    String? hours,
    String? dishData,
    String? opentableId,
    String? opentableSlug,
    String? phone,
    String? websiteUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Restaurant',
      if (id != null) 'id': id,
      'fsqId': fsqId,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'priceTier': priceTier,
      if (rating != null) 'rating': rating,
      'cuisineTypes': cuisineTypes.toJson(),
      if (description != null) 'description': description,
      if (hours != null) 'hours': hours,
      if (dishData != null) 'dishData': dishData,
      if (opentableId != null) 'opentableId': opentableId,
      if (opentableSlug != null) 'opentableSlug': opentableSlug,
      if (phone != null) 'phone': phone,
      if (websiteUrl != null) 'websiteUrl': websiteUrl,
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

class _RestaurantImpl extends Restaurant {
  _RestaurantImpl({
    int? id,
    required String fsqId,
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required int priceTier,
    double? rating,
    required List<String> cuisineTypes,
    String? description,
    String? hours,
    String? dishData,
    String? opentableId,
    String? opentableSlug,
    String? phone,
    String? websiteUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         fsqId: fsqId,
         name: name,
         address: address,
         latitude: latitude,
         longitude: longitude,
         priceTier: priceTier,
         rating: rating,
         cuisineTypes: cuisineTypes,
         description: description,
         hours: hours,
         dishData: dishData,
         opentableId: opentableId,
         opentableSlug: opentableSlug,
         phone: phone,
         websiteUrl: websiteUrl,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Restaurant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Restaurant copyWith({
    Object? id = _Undefined,
    String? fsqId,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    int? priceTier,
    Object? rating = _Undefined,
    List<String>? cuisineTypes,
    Object? description = _Undefined,
    Object? hours = _Undefined,
    Object? dishData = _Undefined,
    Object? opentableId = _Undefined,
    Object? opentableSlug = _Undefined,
    Object? phone = _Undefined,
    Object? websiteUrl = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Restaurant(
      id: id is int? ? id : this.id,
      fsqId: fsqId ?? this.fsqId,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      priceTier: priceTier ?? this.priceTier,
      rating: rating is double? ? rating : this.rating,
      cuisineTypes: cuisineTypes ?? this.cuisineTypes.map((e0) => e0).toList(),
      description: description is String? ? description : this.description,
      hours: hours is String? ? hours : this.hours,
      dishData: dishData is String? ? dishData : this.dishData,
      opentableId: opentableId is String? ? opentableId : this.opentableId,
      opentableSlug: opentableSlug is String?
          ? opentableSlug
          : this.opentableSlug,
      phone: phone is String? ? phone : this.phone,
      websiteUrl: websiteUrl is String? ? websiteUrl : this.websiteUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
