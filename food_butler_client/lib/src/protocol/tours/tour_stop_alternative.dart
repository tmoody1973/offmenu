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

/// Alternative restaurant suggestion for a tour stop.
abstract class TourStopAlternative implements _i1.SerializableModel {
  TourStopAlternative._({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.priceTier,
    this.rating,
  });

  factory TourStopAlternative({
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required int priceTier,
    double? rating,
  }) = _TourStopAlternativeImpl;

  factory TourStopAlternative.fromJson(Map<String, dynamic> jsonSerialization) {
    return TourStopAlternative(
      name: jsonSerialization['name'] as String,
      address: jsonSerialization['address'] as String,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      priceTier: jsonSerialization['priceTier'] as int,
      rating: (jsonSerialization['rating'] as num?)?.toDouble(),
    );
  }

  /// Restaurant name.
  String name;

  /// Full address.
  String address;

  /// Latitude coordinate.
  double latitude;

  /// Longitude coordinate.
  double longitude;

  /// Price tier (1-4).
  int priceTier;

  /// Rating from 0-10.
  double? rating;

  /// Returns a shallow copy of this [TourStopAlternative]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TourStopAlternative copyWith({
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    int? priceTier,
    double? rating,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TourStopAlternative',
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'priceTier': priceTier,
      if (rating != null) 'rating': rating,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TourStopAlternativeImpl extends TourStopAlternative {
  _TourStopAlternativeImpl({
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required int priceTier,
    double? rating,
  }) : super._(
         name: name,
         address: address,
         latitude: latitude,
         longitude: longitude,
         priceTier: priceTier,
         rating: rating,
       );

  /// Returns a shallow copy of this [TourStopAlternative]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TourStopAlternative copyWith({
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    int? priceTier,
    Object? rating = _Undefined,
  }) {
    return TourStopAlternative(
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      priceTier: priceTier ?? this.priceTier,
      rating: rating is double? ? rating : this.rating,
    );
  }
}
