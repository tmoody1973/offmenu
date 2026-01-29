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
import '../tours/transport_mode.dart' as _i2;

/// A leg of the route between two tour stops.
abstract class RouteLeg
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  RouteLeg._({
    required this.distanceMeters,
    required this.durationSeconds,
    required this.transportMode,
  });

  factory RouteLeg({
    required int distanceMeters,
    required int durationSeconds,
    required _i2.TransportMode transportMode,
  }) = _RouteLegImpl;

  factory RouteLeg.fromJson(Map<String, dynamic> jsonSerialization) {
    return RouteLeg(
      distanceMeters: jsonSerialization['distanceMeters'] as int,
      durationSeconds: jsonSerialization['durationSeconds'] as int,
      transportMode: _i2.TransportMode.fromJson(
        (jsonSerialization['transportMode'] as String),
      ),
    );
  }

  /// Distance in meters.
  int distanceMeters;

  /// Duration in seconds.
  int durationSeconds;

  /// Transport mode for this leg.
  _i2.TransportMode transportMode;

  /// Returns a shallow copy of this [RouteLeg]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RouteLeg copyWith({
    int? distanceMeters,
    int? durationSeconds,
    _i2.TransportMode? transportMode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RouteLeg',
      'distanceMeters': distanceMeters,
      'durationSeconds': durationSeconds,
      'transportMode': transportMode.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RouteLeg',
      'distanceMeters': distanceMeters,
      'durationSeconds': durationSeconds,
      'transportMode': transportMode.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _RouteLegImpl extends RouteLeg {
  _RouteLegImpl({
    required int distanceMeters,
    required int durationSeconds,
    required _i2.TransportMode transportMode,
  }) : super._(
         distanceMeters: distanceMeters,
         durationSeconds: durationSeconds,
         transportMode: transportMode,
       );

  /// Returns a shallow copy of this [RouteLeg]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RouteLeg copyWith({
    int? distanceMeters,
    int? durationSeconds,
    _i2.TransportMode? transportMode,
  }) {
    return RouteLeg(
      distanceMeters: distanceMeters ?? this.distanceMeters,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      transportMode: transportMode ?? this.transportMode,
    );
  }
}
