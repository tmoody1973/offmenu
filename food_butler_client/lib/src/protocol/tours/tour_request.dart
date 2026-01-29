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
import '../tours/budget_tier.dart' as _i3;
import 'package:food_butler_client/src/protocol/protocol.dart' as _i4;

/// Input parameters for tour generation request.
abstract class TourRequest implements _i1.SerializableModel {
  TourRequest._({
    this.id,
    required this.startLatitude,
    required this.startLongitude,
    this.startAddress,
    required this.numStops,
    required this.transportMode,
    this.cuisinePreferences,
    required this.awardOnly,
    required this.startTime,
    this.endTime,
    required this.budgetTier,
    this.specificDish,
    required this.createdAt,
  });

  factory TourRequest({
    int? id,
    required double startLatitude,
    required double startLongitude,
    String? startAddress,
    required int numStops,
    required _i2.TransportMode transportMode,
    List<String>? cuisinePreferences,
    required bool awardOnly,
    required DateTime startTime,
    DateTime? endTime,
    required _i3.BudgetTier budgetTier,
    String? specificDish,
    required DateTime createdAt,
  }) = _TourRequestImpl;

  factory TourRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return TourRequest(
      id: jsonSerialization['id'] as int?,
      startLatitude: (jsonSerialization['startLatitude'] as num).toDouble(),
      startLongitude: (jsonSerialization['startLongitude'] as num).toDouble(),
      startAddress: jsonSerialization['startAddress'] as String?,
      numStops: jsonSerialization['numStops'] as int,
      transportMode: _i2.TransportMode.fromJson(
        (jsonSerialization['transportMode'] as String),
      ),
      cuisinePreferences: jsonSerialization['cuisinePreferences'] == null
          ? null
          : _i4.Protocol().deserialize<List<String>>(
              jsonSerialization['cuisinePreferences'],
            ),
      awardOnly: jsonSerialization['awardOnly'] as bool,
      startTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startTime'],
      ),
      endTime: jsonSerialization['endTime'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endTime']),
      budgetTier: _i3.BudgetTier.fromJson(
        (jsonSerialization['budgetTier'] as String),
      ),
      specificDish: jsonSerialization['specificDish'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Starting point latitude.
  double startLatitude;

  /// Starting point longitude.
  double startLongitude;

  /// Optional starting address string for display.
  String? startAddress;

  /// Number of stops (3-6 inclusive).
  int numStops;

  /// Transport mode for navigation.
  _i2.TransportMode transportMode;

  /// Optional cuisine type preferences.
  List<String>? cuisinePreferences;

  /// Filter for award-winning restaurants only.
  bool awardOnly;

  /// Tour start time.
  DateTime startTime;

  /// Optional preferred end time.
  DateTime? endTime;

  /// Budget tier preference.
  _i3.BudgetTier budgetTier;

  /// Optional specific dish to search for (e.g., "tonkotsu ramen", "tacos al pastor").
  String? specificDish;

  /// When the request was created.
  DateTime createdAt;

  /// Returns a shallow copy of this [TourRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TourRequest copyWith({
    int? id,
    double? startLatitude,
    double? startLongitude,
    String? startAddress,
    int? numStops,
    _i2.TransportMode? transportMode,
    List<String>? cuisinePreferences,
    bool? awardOnly,
    DateTime? startTime,
    DateTime? endTime,
    _i3.BudgetTier? budgetTier,
    String? specificDish,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TourRequest',
      if (id != null) 'id': id,
      'startLatitude': startLatitude,
      'startLongitude': startLongitude,
      if (startAddress != null) 'startAddress': startAddress,
      'numStops': numStops,
      'transportMode': transportMode.toJson(),
      if (cuisinePreferences != null)
        'cuisinePreferences': cuisinePreferences?.toJson(),
      'awardOnly': awardOnly,
      'startTime': startTime.toJson(),
      if (endTime != null) 'endTime': endTime?.toJson(),
      'budgetTier': budgetTier.toJson(),
      if (specificDish != null) 'specificDish': specificDish,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TourRequestImpl extends TourRequest {
  _TourRequestImpl({
    int? id,
    required double startLatitude,
    required double startLongitude,
    String? startAddress,
    required int numStops,
    required _i2.TransportMode transportMode,
    List<String>? cuisinePreferences,
    required bool awardOnly,
    required DateTime startTime,
    DateTime? endTime,
    required _i3.BudgetTier budgetTier,
    String? specificDish,
    required DateTime createdAt,
  }) : super._(
         id: id,
         startLatitude: startLatitude,
         startLongitude: startLongitude,
         startAddress: startAddress,
         numStops: numStops,
         transportMode: transportMode,
         cuisinePreferences: cuisinePreferences,
         awardOnly: awardOnly,
         startTime: startTime,
         endTime: endTime,
         budgetTier: budgetTier,
         specificDish: specificDish,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [TourRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TourRequest copyWith({
    Object? id = _Undefined,
    double? startLatitude,
    double? startLongitude,
    Object? startAddress = _Undefined,
    int? numStops,
    _i2.TransportMode? transportMode,
    Object? cuisinePreferences = _Undefined,
    bool? awardOnly,
    DateTime? startTime,
    Object? endTime = _Undefined,
    _i3.BudgetTier? budgetTier,
    Object? specificDish = _Undefined,
    DateTime? createdAt,
  }) {
    return TourRequest(
      id: id is int? ? id : this.id,
      startLatitude: startLatitude ?? this.startLatitude,
      startLongitude: startLongitude ?? this.startLongitude,
      startAddress: startAddress is String? ? startAddress : this.startAddress,
      numStops: numStops ?? this.numStops,
      transportMode: transportMode ?? this.transportMode,
      cuisinePreferences: cuisinePreferences is List<String>?
          ? cuisinePreferences
          : this.cuisinePreferences?.map((e0) => e0).toList(),
      awardOnly: awardOnly ?? this.awardOnly,
      startTime: startTime ?? this.startTime,
      endTime: endTime is DateTime? ? endTime : this.endTime,
      budgetTier: budgetTier ?? this.budgetTier,
      specificDish: specificDish is String? ? specificDish : this.specificDish,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
