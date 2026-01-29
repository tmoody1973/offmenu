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
import '../tours/michelin_designation.dart' as _i2;

/// Michelin Guide award record for restaurant designations.
abstract class MichelinAward implements _i1.SerializableModel {
  MichelinAward._({
    this.id,
    required this.restaurantName,
    required this.city,
    this.address,
    this.latitude,
    this.longitude,
    required this.designation,
    required this.awardYear,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MichelinAward({
    int? id,
    required String restaurantName,
    required String city,
    String? address,
    double? latitude,
    double? longitude,
    required _i2.MichelinDesignation designation,
    required int awardYear,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MichelinAwardImpl;

  factory MichelinAward.fromJson(Map<String, dynamic> jsonSerialization) {
    return MichelinAward(
      id: jsonSerialization['id'] as int?,
      restaurantName: jsonSerialization['restaurantName'] as String,
      city: jsonSerialization['city'] as String,
      address: jsonSerialization['address'] as String?,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      designation: _i2.MichelinDesignation.fromJson(
        (jsonSerialization['designation'] as String),
      ),
      awardYear: jsonSerialization['awardYear'] as int,
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

  /// Restaurant name as it appears in Michelin Guide.
  String restaurantName;

  /// City where the restaurant is located.
  String city;

  /// Full street address.
  String? address;

  /// Latitude coordinate for location matching.
  double? latitude;

  /// Longitude coordinate for location matching.
  double? longitude;

  /// Michelin designation type.
  _i2.MichelinDesignation designation;

  /// Year the award was given.
  int awardYear;

  /// When the record was created.
  DateTime createdAt;

  /// When the record was last updated.
  DateTime updatedAt;

  /// Returns a shallow copy of this [MichelinAward]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MichelinAward copyWith({
    int? id,
    String? restaurantName,
    String? city,
    String? address,
    double? latitude,
    double? longitude,
    _i2.MichelinDesignation? designation,
    int? awardYear,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MichelinAward',
      if (id != null) 'id': id,
      'restaurantName': restaurantName,
      'city': city,
      if (address != null) 'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'designation': designation.toJson(),
      'awardYear': awardYear,
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

class _MichelinAwardImpl extends MichelinAward {
  _MichelinAwardImpl({
    int? id,
    required String restaurantName,
    required String city,
    String? address,
    double? latitude,
    double? longitude,
    required _i2.MichelinDesignation designation,
    required int awardYear,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         restaurantName: restaurantName,
         city: city,
         address: address,
         latitude: latitude,
         longitude: longitude,
         designation: designation,
         awardYear: awardYear,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [MichelinAward]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MichelinAward copyWith({
    Object? id = _Undefined,
    String? restaurantName,
    String? city,
    Object? address = _Undefined,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    _i2.MichelinDesignation? designation,
    int? awardYear,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MichelinAward(
      id: id is int? ? id : this.id,
      restaurantName: restaurantName ?? this.restaurantName,
      city: city ?? this.city,
      address: address is String? ? address : this.address,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      designation: designation ?? this.designation,
      awardYear: awardYear ?? this.awardYear,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
