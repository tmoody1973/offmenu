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
import 'package:serverpod/serverpod.dart' as _i1;

/// A cuisine exploration suggestion for the user.
/// Based on cuisines they want to try with nearby restaurant info.
abstract class CuisineExplorationSuggestion
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  CuisineExplorationSuggestion._({
    required this.cuisine,
    this.restaurantName,
    this.restaurantAddress,
    this.placeId,
    this.rating,
    required this.hookLine,
    required this.ctaText,
  });

  factory CuisineExplorationSuggestion({
    required String cuisine,
    String? restaurantName,
    String? restaurantAddress,
    String? placeId,
    double? rating,
    required String hookLine,
    required String ctaText,
  }) = _CuisineExplorationSuggestionImpl;

  factory CuisineExplorationSuggestion.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CuisineExplorationSuggestion(
      cuisine: jsonSerialization['cuisine'] as String,
      restaurantName: jsonSerialization['restaurantName'] as String?,
      restaurantAddress: jsonSerialization['restaurantAddress'] as String?,
      placeId: jsonSerialization['placeId'] as String?,
      rating: (jsonSerialization['rating'] as num?)?.toDouble(),
      hookLine: jsonSerialization['hookLine'] as String,
      ctaText: jsonSerialization['ctaText'] as String,
    );
  }

  /// The cuisine type to explore (e.g., "Ethiopian", "Korean").
  String cuisine;

  /// Name of a nearby restaurant of this cuisine type.
  String? restaurantName;

  /// Address of the restaurant.
  String? restaurantAddress;

  /// Google Place ID for navigation/details.
  String? placeId;

  /// Restaurant rating if available.
  double? rating;

  /// The hook line to display (e.g., "Cafe Selam is 8 min away.").
  String hookLine;

  /// The CTA button text (e.g., "SHOW ME").
  String ctaText;

  /// Returns a shallow copy of this [CuisineExplorationSuggestion]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CuisineExplorationSuggestion copyWith({
    String? cuisine,
    String? restaurantName,
    String? restaurantAddress,
    String? placeId,
    double? rating,
    String? hookLine,
    String? ctaText,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CuisineExplorationSuggestion',
      'cuisine': cuisine,
      if (restaurantName != null) 'restaurantName': restaurantName,
      if (restaurantAddress != null) 'restaurantAddress': restaurantAddress,
      if (placeId != null) 'placeId': placeId,
      if (rating != null) 'rating': rating,
      'hookLine': hookLine,
      'ctaText': ctaText,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CuisineExplorationSuggestion',
      'cuisine': cuisine,
      if (restaurantName != null) 'restaurantName': restaurantName,
      if (restaurantAddress != null) 'restaurantAddress': restaurantAddress,
      if (placeId != null) 'placeId': placeId,
      if (rating != null) 'rating': rating,
      'hookLine': hookLine,
      'ctaText': ctaText,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CuisineExplorationSuggestionImpl extends CuisineExplorationSuggestion {
  _CuisineExplorationSuggestionImpl({
    required String cuisine,
    String? restaurantName,
    String? restaurantAddress,
    String? placeId,
    double? rating,
    required String hookLine,
    required String ctaText,
  }) : super._(
         cuisine: cuisine,
         restaurantName: restaurantName,
         restaurantAddress: restaurantAddress,
         placeId: placeId,
         rating: rating,
         hookLine: hookLine,
         ctaText: ctaText,
       );

  /// Returns a shallow copy of this [CuisineExplorationSuggestion]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CuisineExplorationSuggestion copyWith({
    String? cuisine,
    Object? restaurantName = _Undefined,
    Object? restaurantAddress = _Undefined,
    Object? placeId = _Undefined,
    Object? rating = _Undefined,
    String? hookLine,
    String? ctaText,
  }) {
    return CuisineExplorationSuggestion(
      cuisine: cuisine ?? this.cuisine,
      restaurantName: restaurantName is String?
          ? restaurantName
          : this.restaurantName,
      restaurantAddress: restaurantAddress is String?
          ? restaurantAddress
          : this.restaurantAddress,
      placeId: placeId is String? ? placeId : this.placeId,
      rating: rating is double? ? rating : this.rating,
      hookLine: hookLine ?? this.hookLine,
      ctaText: ctaText ?? this.ctaText,
    );
  }
}
