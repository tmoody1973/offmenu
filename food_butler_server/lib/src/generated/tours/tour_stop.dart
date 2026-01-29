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
import '../tours/tour_stop_alternative.dart' as _i2;
import 'package:food_butler_server/src/generated/protocol.dart' as _i3;

/// A single stop in a generated tour.
abstract class TourStop
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  TourStop._({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.priceTier,
    this.rating,
    required this.awardBadges,
    required this.recommendedDishes,
    required this.visitDurationMinutes,
    required this.alternatives,
  });

  factory TourStop({
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required int priceTier,
    double? rating,
    required List<String> awardBadges,
    required List<String> recommendedDishes,
    required int visitDurationMinutes,
    required List<_i2.TourStopAlternative> alternatives,
  }) = _TourStopImpl;

  factory TourStop.fromJson(Map<String, dynamic> jsonSerialization) {
    return TourStop(
      name: jsonSerialization['name'] as String,
      address: jsonSerialization['address'] as String,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      priceTier: jsonSerialization['priceTier'] as int,
      rating: (jsonSerialization['rating'] as num?)?.toDouble(),
      awardBadges: _i3.Protocol().deserialize<List<String>>(
        jsonSerialization['awardBadges'],
      ),
      recommendedDishes: _i3.Protocol().deserialize<List<String>>(
        jsonSerialization['recommendedDishes'],
      ),
      visitDurationMinutes: jsonSerialization['visitDurationMinutes'] as int,
      alternatives: _i3.Protocol().deserialize<List<_i2.TourStopAlternative>>(
        jsonSerialization['alternatives'],
      ),
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

  /// Award badges for this restaurant.
  List<String> awardBadges;

  /// Recommended dishes to try.
  List<String> recommendedDishes;

  /// Estimated visit duration in minutes.
  int visitDurationMinutes;

  /// Alternative restaurant suggestions for this stop.
  List<_i2.TourStopAlternative> alternatives;

  /// Returns a shallow copy of this [TourStop]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TourStop copyWith({
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    int? priceTier,
    double? rating,
    List<String>? awardBadges,
    List<String>? recommendedDishes,
    int? visitDurationMinutes,
    List<_i2.TourStopAlternative>? alternatives,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TourStop',
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'priceTier': priceTier,
      if (rating != null) 'rating': rating,
      'awardBadges': awardBadges.toJson(),
      'recommendedDishes': recommendedDishes.toJson(),
      'visitDurationMinutes': visitDurationMinutes,
      'alternatives': alternatives.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TourStop',
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'priceTier': priceTier,
      if (rating != null) 'rating': rating,
      'awardBadges': awardBadges.toJson(),
      'recommendedDishes': recommendedDishes.toJson(),
      'visitDurationMinutes': visitDurationMinutes,
      'alternatives': alternatives.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TourStopImpl extends TourStop {
  _TourStopImpl({
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required int priceTier,
    double? rating,
    required List<String> awardBadges,
    required List<String> recommendedDishes,
    required int visitDurationMinutes,
    required List<_i2.TourStopAlternative> alternatives,
  }) : super._(
         name: name,
         address: address,
         latitude: latitude,
         longitude: longitude,
         priceTier: priceTier,
         rating: rating,
         awardBadges: awardBadges,
         recommendedDishes: recommendedDishes,
         visitDurationMinutes: visitDurationMinutes,
         alternatives: alternatives,
       );

  /// Returns a shallow copy of this [TourStop]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TourStop copyWith({
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    int? priceTier,
    Object? rating = _Undefined,
    List<String>? awardBadges,
    List<String>? recommendedDishes,
    int? visitDurationMinutes,
    List<_i2.TourStopAlternative>? alternatives,
  }) {
    return TourStop(
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      priceTier: priceTier ?? this.priceTier,
      rating: rating is double? ? rating : this.rating,
      awardBadges: awardBadges ?? this.awardBadges.map((e0) => e0).toList(),
      recommendedDishes:
          recommendedDishes ?? this.recommendedDishes.map((e0) => e0).toList(),
      visitDurationMinutes: visitDurationMinutes ?? this.visitDurationMinutes,
      alternatives:
          alternatives ?? this.alternatives.map((e0) => e0.copyWith()).toList(),
    );
  }
}
