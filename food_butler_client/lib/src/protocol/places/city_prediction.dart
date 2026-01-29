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

/// City prediction from Google Places Autocomplete.
abstract class CityPrediction implements _i1.SerializableModel {
  CityPrediction._({
    required this.city,
    this.state,
    this.country,
    required this.placeId,
    required this.displayName,
  });

  factory CityPrediction({
    required String city,
    String? state,
    String? country,
    required String placeId,
    required String displayName,
  }) = _CityPredictionImpl;

  factory CityPrediction.fromJson(Map<String, dynamic> jsonSerialization) {
    return CityPrediction(
      city: jsonSerialization['city'] as String,
      state: jsonSerialization['state'] as String?,
      country: jsonSerialization['country'] as String?,
      placeId: jsonSerialization['placeId'] as String,
      displayName: jsonSerialization['displayName'] as String,
    );
  }

  /// City name.
  String city;

  /// State/region name.
  String? state;

  /// Country name.
  String? country;

  /// Google Place ID for fetching details.
  String placeId;

  /// Full display name (e.g., "Los Angeles, CA, USA").
  String displayName;

  /// Returns a shallow copy of this [CityPrediction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CityPrediction copyWith({
    String? city,
    String? state,
    String? country,
    String? placeId,
    String? displayName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CityPrediction',
      'city': city,
      if (state != null) 'state': state,
      if (country != null) 'country': country,
      'placeId': placeId,
      'displayName': displayName,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CityPredictionImpl extends CityPrediction {
  _CityPredictionImpl({
    required String city,
    String? state,
    String? country,
    required String placeId,
    required String displayName,
  }) : super._(
         city: city,
         state: state,
         country: country,
         placeId: placeId,
         displayName: displayName,
       );

  /// Returns a shallow copy of this [CityPrediction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CityPrediction copyWith({
    String? city,
    Object? state = _Undefined,
    Object? country = _Undefined,
    String? placeId,
    String? displayName,
  }) {
    return CityPrediction(
      city: city ?? this.city,
      state: state is String? ? state : this.state,
      country: country is String? ? country : this.country,
      placeId: placeId ?? this.placeId,
      displayName: displayName ?? this.displayName,
    );
  }
}
