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
import '../tours/transport_mode.dart' as _i2;

/// Cached Mapbox route for reducing API calls.
abstract class CachedRoute implements _i1.SerializableModel {
  CachedRoute._({
    this.id,
    required this.waypointsHash,
    required this.transportMode,
    required this.polyline,
    required this.distanceMeters,
    required this.durationSeconds,
    required this.legsJson,
    required this.expiresAt,
    required this.createdAt,
  });

  factory CachedRoute({
    int? id,
    required String waypointsHash,
    required _i2.TransportMode transportMode,
    required String polyline,
    required int distanceMeters,
    required int durationSeconds,
    required String legsJson,
    required DateTime expiresAt,
    required DateTime createdAt,
  }) = _CachedRouteImpl;

  factory CachedRoute.fromJson(Map<String, dynamic> jsonSerialization) {
    return CachedRoute(
      id: jsonSerialization['id'] as int?,
      waypointsHash: jsonSerialization['waypointsHash'] as String,
      transportMode: _i2.TransportMode.fromJson(
        (jsonSerialization['transportMode'] as String),
      ),
      polyline: jsonSerialization['polyline'] as String,
      distanceMeters: jsonSerialization['distanceMeters'] as int,
      durationSeconds: jsonSerialization['durationSeconds'] as int,
      legsJson: jsonSerialization['legsJson'] as String,
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Hash of sorted waypoints for cache lookup.
  String waypointsHash;

  /// Transport mode for this cached route.
  _i2.TransportMode transportMode;

  /// Encoded polyline string.
  String polyline;

  /// Total distance in meters.
  int distanceMeters;

  /// Total duration in seconds.
  int durationSeconds;

  /// Per-leg data as JSON string.
  String legsJson;

  /// When the cache entry expires.
  DateTime expiresAt;

  /// When the cache entry was created.
  DateTime createdAt;

  /// Returns a shallow copy of this [CachedRoute]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CachedRoute copyWith({
    int? id,
    String? waypointsHash,
    _i2.TransportMode? transportMode,
    String? polyline,
    int? distanceMeters,
    int? durationSeconds,
    String? legsJson,
    DateTime? expiresAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CachedRoute',
      if (id != null) 'id': id,
      'waypointsHash': waypointsHash,
      'transportMode': transportMode.toJson(),
      'polyline': polyline,
      'distanceMeters': distanceMeters,
      'durationSeconds': durationSeconds,
      'legsJson': legsJson,
      'expiresAt': expiresAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CachedRouteImpl extends CachedRoute {
  _CachedRouteImpl({
    int? id,
    required String waypointsHash,
    required _i2.TransportMode transportMode,
    required String polyline,
    required int distanceMeters,
    required int durationSeconds,
    required String legsJson,
    required DateTime expiresAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         waypointsHash: waypointsHash,
         transportMode: transportMode,
         polyline: polyline,
         distanceMeters: distanceMeters,
         durationSeconds: durationSeconds,
         legsJson: legsJson,
         expiresAt: expiresAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [CachedRoute]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CachedRoute copyWith({
    Object? id = _Undefined,
    String? waypointsHash,
    _i2.TransportMode? transportMode,
    String? polyline,
    int? distanceMeters,
    int? durationSeconds,
    String? legsJson,
    DateTime? expiresAt,
    DateTime? createdAt,
  }) {
    return CachedRoute(
      id: id is int? ? id : this.id,
      waypointsHash: waypointsHash ?? this.waypointsHash,
      transportMode: transportMode ?? this.transportMode,
      polyline: polyline ?? this.polyline,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      legsJson: legsJson ?? this.legsJson,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
