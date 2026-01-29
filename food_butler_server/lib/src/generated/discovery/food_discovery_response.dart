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
import '../discovery/discovered_place.dart' as _i2;
import 'package:food_butler_server/src/generated/protocol.dart' as _i3;

/// Response from the AI food discovery/concierge.
abstract class FoodDiscoveryResponse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  FoodDiscoveryResponse._({
    required this.summary,
    required this.places,
    required this.query,
    this.detectedLocation,
    required this.showMap,
  });

  factory FoodDiscoveryResponse({
    required String summary,
    required List<_i2.DiscoveredPlace> places,
    required String query,
    String? detectedLocation,
    required bool showMap,
  }) = _FoodDiscoveryResponseImpl;

  factory FoodDiscoveryResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return FoodDiscoveryResponse(
      summary: jsonSerialization['summary'] as String,
      places: _i3.Protocol().deserialize<List<_i2.DiscoveredPlace>>(
        jsonSerialization['places'],
      ),
      query: jsonSerialization['query'] as String,
      detectedLocation: jsonSerialization['detectedLocation'] as String?,
      showMap: jsonSerialization['showMap'] as bool,
    );
  }

  /// AI-generated summary/response to the query.
  String summary;

  /// List of discovered places.
  List<_i2.DiscoveredPlace> places;

  /// The original query.
  String query;

  /// Detected location from the query (if any).
  String? detectedLocation;

  /// Whether to show the map (true for discovery queries, false for menu/dish questions).
  bool showMap;

  /// Returns a shallow copy of this [FoodDiscoveryResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FoodDiscoveryResponse copyWith({
    String? summary,
    List<_i2.DiscoveredPlace>? places,
    String? query,
    String? detectedLocation,
    bool? showMap,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FoodDiscoveryResponse',
      'summary': summary,
      'places': places.toJson(valueToJson: (v) => v.toJson()),
      'query': query,
      if (detectedLocation != null) 'detectedLocation': detectedLocation,
      'showMap': showMap,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FoodDiscoveryResponse',
      'summary': summary,
      'places': places.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'query': query,
      if (detectedLocation != null) 'detectedLocation': detectedLocation,
      'showMap': showMap,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FoodDiscoveryResponseImpl extends FoodDiscoveryResponse {
  _FoodDiscoveryResponseImpl({
    required String summary,
    required List<_i2.DiscoveredPlace> places,
    required String query,
    String? detectedLocation,
    required bool showMap,
  }) : super._(
         summary: summary,
         places: places,
         query: query,
         detectedLocation: detectedLocation,
         showMap: showMap,
       );

  /// Returns a shallow copy of this [FoodDiscoveryResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FoodDiscoveryResponse copyWith({
    String? summary,
    List<_i2.DiscoveredPlace>? places,
    String? query,
    Object? detectedLocation = _Undefined,
    bool? showMap,
  }) {
    return FoodDiscoveryResponse(
      summary: summary ?? this.summary,
      places: places ?? this.places.map((e0) => e0.copyWith()).toList(),
      query: query ?? this.query,
      detectedLocation: detectedLocation is String?
          ? detectedLocation
          : this.detectedLocation,
      showMap: showMap ?? this.showMap,
    );
  }
}
