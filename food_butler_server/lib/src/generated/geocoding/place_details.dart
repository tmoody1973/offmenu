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

/// Details for a place from Google Places API.
abstract class PlaceDetails
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  PlaceDetails._({
    required this.latitude,
    required this.longitude,
    this.formattedAddress,
    this.city,
    this.state,
    this.country,
  });

  factory PlaceDetails({
    required double latitude,
    required double longitude,
    String? formattedAddress,
    String? city,
    String? state,
    String? country,
  }) = _PlaceDetailsImpl;

  factory PlaceDetails.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlaceDetails(
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      formattedAddress: jsonSerialization['formattedAddress'] as String?,
      city: jsonSerialization['city'] as String?,
      state: jsonSerialization['state'] as String?,
      country: jsonSerialization['country'] as String?,
    );
  }

  /// Latitude coordinate.
  double latitude;

  /// Longitude coordinate.
  double longitude;

  /// Full formatted address.
  String? formattedAddress;

  /// City/locality name.
  String? city;

  /// State/region name.
  String? state;

  /// Country name.
  String? country;

  /// Returns a shallow copy of this [PlaceDetails]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PlaceDetails copyWith({
    double? latitude,
    double? longitude,
    String? formattedAddress,
    String? city,
    String? state,
    String? country,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PlaceDetails',
      'latitude': latitude,
      'longitude': longitude,
      if (formattedAddress != null) 'formattedAddress': formattedAddress,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (country != null) 'country': country,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PlaceDetails',
      'latitude': latitude,
      'longitude': longitude,
      if (formattedAddress != null) 'formattedAddress': formattedAddress,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (country != null) 'country': country,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PlaceDetailsImpl extends PlaceDetails {
  _PlaceDetailsImpl({
    required double latitude,
    required double longitude,
    String? formattedAddress,
    String? city,
    String? state,
    String? country,
  }) : super._(
         latitude: latitude,
         longitude: longitude,
         formattedAddress: formattedAddress,
         city: city,
         state: state,
         country: country,
       );

  /// Returns a shallow copy of this [PlaceDetails]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PlaceDetails copyWith({
    double? latitude,
    double? longitude,
    Object? formattedAddress = _Undefined,
    Object? city = _Undefined,
    Object? state = _Undefined,
    Object? country = _Undefined,
  }) {
    return PlaceDetails(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      formattedAddress: formattedAddress is String?
          ? formattedAddress
          : this.formattedAddress,
      city: city is String? ? city : this.city,
      state: state is String? ? state : this.state,
      country: country is String? ? country : this.country,
    );
  }
}
