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

/// A single restaurant pick for "Three for Tonight".
///
/// Context-aware recommendation based on time of day and user preferences.
abstract class TonightPick implements _i1.SerializableModel {
  TonightPick._({
    required this.name,
    required this.hook,
    this.cuisineType,
    this.imageUrl,
    this.placeId,
    this.address,
    this.rating,
    this.priceLevel,
  });

  factory TonightPick({
    required String name,
    required String hook,
    String? cuisineType,
    String? imageUrl,
    String? placeId,
    String? address,
    double? rating,
    int? priceLevel,
  }) = _TonightPickImpl;

  factory TonightPick.fromJson(Map<String, dynamic> jsonSerialization) {
    return TonightPick(
      name: jsonSerialization['name'] as String,
      hook: jsonSerialization['hook'] as String,
      cuisineType: jsonSerialization['cuisineType'] as String?,
      imageUrl: jsonSerialization['imageUrl'] as String?,
      placeId: jsonSerialization['placeId'] as String?,
      address: jsonSerialization['address'] as String?,
      rating: (jsonSerialization['rating'] as num?)?.toDouble(),
      priceLevel: jsonSerialization['priceLevel'] as int?,
    );
  }

  /// Restaurant name
  String name;

  /// Punchy one-liner hook that makes you want to go
  String hook;

  /// Type of cuisine
  String? cuisineType;

  /// Photo URL (from Google Places or Perplexity)
  String? imageUrl;

  /// Google Place ID for navigation/details
  String? placeId;

  /// Restaurant address
  String? address;

  /// Google rating (0-5)
  double? rating;

  /// Price level (1-4)
  int? priceLevel;

  /// Returns a shallow copy of this [TonightPick]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TonightPick copyWith({
    String? name,
    String? hook,
    String? cuisineType,
    String? imageUrl,
    String? placeId,
    String? address,
    double? rating,
    int? priceLevel,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TonightPick',
      'name': name,
      'hook': hook,
      if (cuisineType != null) 'cuisineType': cuisineType,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (placeId != null) 'placeId': placeId,
      if (address != null) 'address': address,
      if (rating != null) 'rating': rating,
      if (priceLevel != null) 'priceLevel': priceLevel,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TonightPickImpl extends TonightPick {
  _TonightPickImpl({
    required String name,
    required String hook,
    String? cuisineType,
    String? imageUrl,
    String? placeId,
    String? address,
    double? rating,
    int? priceLevel,
  }) : super._(
         name: name,
         hook: hook,
         cuisineType: cuisineType,
         imageUrl: imageUrl,
         placeId: placeId,
         address: address,
         rating: rating,
         priceLevel: priceLevel,
       );

  /// Returns a shallow copy of this [TonightPick]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TonightPick copyWith({
    String? name,
    String? hook,
    Object? cuisineType = _Undefined,
    Object? imageUrl = _Undefined,
    Object? placeId = _Undefined,
    Object? address = _Undefined,
    Object? rating = _Undefined,
    Object? priceLevel = _Undefined,
  }) {
    return TonightPick(
      name: name ?? this.name,
      hook: hook ?? this.hook,
      cuisineType: cuisineType is String? ? cuisineType : this.cuisineType,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      placeId: placeId is String? ? placeId : this.placeId,
      address: address is String? ? address : this.address,
      rating: rating is double? ? rating : this.rating,
      priceLevel: priceLevel is int? ? priceLevel : this.priceLevel,
    );
  }
}
