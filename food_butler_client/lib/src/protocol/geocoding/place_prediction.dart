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

/// A place prediction from Google Places Autocomplete.
abstract class PlacePrediction implements _i1.SerializableModel {
  PlacePrediction._({
    required this.placeId,
    required this.description,
    this.mainText,
    this.secondaryText,
  });

  factory PlacePrediction({
    required String placeId,
    required String description,
    String? mainText,
    String? secondaryText,
  }) = _PlacePredictionImpl;

  factory PlacePrediction.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlacePrediction(
      placeId: jsonSerialization['placeId'] as String,
      description: jsonSerialization['description'] as String,
      mainText: jsonSerialization['mainText'] as String?,
      secondaryText: jsonSerialization['secondaryText'] as String?,
    );
  }

  /// The place ID for use with getPlaceDetails.
  String placeId;

  /// Full description of the place.
  String description;

  /// Main text (usually the place name or street).
  String? mainText;

  /// Secondary text (usually city, state, country).
  String? secondaryText;

  /// Returns a shallow copy of this [PlacePrediction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PlacePrediction copyWith({
    String? placeId,
    String? description,
    String? mainText,
    String? secondaryText,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PlacePrediction',
      'placeId': placeId,
      'description': description,
      if (mainText != null) 'mainText': mainText,
      if (secondaryText != null) 'secondaryText': secondaryText,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PlacePredictionImpl extends PlacePrediction {
  _PlacePredictionImpl({
    required String placeId,
    required String description,
    String? mainText,
    String? secondaryText,
  }) : super._(
         placeId: placeId,
         description: description,
         mainText: mainText,
         secondaryText: secondaryText,
       );

  /// Returns a shallow copy of this [PlacePrediction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PlacePrediction copyWith({
    String? placeId,
    String? description,
    Object? mainText = _Undefined,
    Object? secondaryText = _Undefined,
  }) {
    return PlacePrediction(
      placeId: placeId ?? this.placeId,
      description: description ?? this.description,
      mainText: mainText is String? ? mainText : this.mainText,
      secondaryText: secondaryText is String?
          ? secondaryText
          : this.secondaryText,
    );
  }
}
