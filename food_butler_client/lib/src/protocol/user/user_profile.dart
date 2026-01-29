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
import '../user/food_philosophy.dart' as _i2;
import '../user/adventure_level.dart' as _i3;

/// User profile and preferences collected during onboarding.
/// Used to personalize recommendations, The Daily, and the Serendipity Engine.
abstract class UserProfile implements _i1.SerializableModel {
  UserProfile._({
    this.id,
    required this.userId,
    this.foodPhilosophy,
    this.adventureLevel,
    this.familiarCuisines,
    this.wantToTryCuisines,
    this.dietaryRestrictions,
    this.homeCity,
    this.homeState,
    this.homeCountry,
    this.homeLatitude,
    this.homeLongitude,
    this.additionalCities,
    required this.onboardingCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile({
    int? id,
    required String userId,
    _i2.FoodPhilosophy? foodPhilosophy,
    _i3.AdventureLevel? adventureLevel,
    String? familiarCuisines,
    String? wantToTryCuisines,
    String? dietaryRestrictions,
    String? homeCity,
    String? homeState,
    String? homeCountry,
    double? homeLatitude,
    double? homeLongitude,
    String? additionalCities,
    required bool onboardingCompleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserProfileImpl;

  factory UserProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserProfile(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      foodPhilosophy: jsonSerialization['foodPhilosophy'] == null
          ? null
          : _i2.FoodPhilosophy.fromJson(
              (jsonSerialization['foodPhilosophy'] as String),
            ),
      adventureLevel: jsonSerialization['adventureLevel'] == null
          ? null
          : _i3.AdventureLevel.fromJson(
              (jsonSerialization['adventureLevel'] as String),
            ),
      familiarCuisines: jsonSerialization['familiarCuisines'] as String?,
      wantToTryCuisines: jsonSerialization['wantToTryCuisines'] as String?,
      dietaryRestrictions: jsonSerialization['dietaryRestrictions'] as String?,
      homeCity: jsonSerialization['homeCity'] as String?,
      homeState: jsonSerialization['homeState'] as String?,
      homeCountry: jsonSerialization['homeCountry'] as String?,
      homeLatitude: (jsonSerialization['homeLatitude'] as num?)?.toDouble(),
      homeLongitude: (jsonSerialization['homeLongitude'] as num?)?.toDouble(),
      additionalCities: jsonSerialization['additionalCities'] as String?,
      onboardingCompleted: jsonSerialization['onboardingCompleted'] as bool,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The user ID (from Serverpod auth).
  String userId;

  /// User's food philosophy - story vs dish preference.
  _i2.FoodPhilosophy? foodPhilosophy;

  /// User's adventure/exploration style.
  _i3.AdventureLevel? adventureLevel;

  /// Cuisines the user is familiar with (comma-separated).
  String? familiarCuisines;

  /// Cuisines the user wants to explore (comma-separated).
  String? wantToTryCuisines;

  /// Dietary restrictions (comma-separated: vegetarian, vegan, gluten-free, etc).
  String? dietaryRestrictions;

  /// User's home city for local recommendations.
  String? homeCity;

  /// User's home state/region.
  String? homeState;

  /// User's home country.
  String? homeCountry;

  /// Latitude of user's home location.
  double? homeLatitude;

  /// Longitude of user's home location.
  double? homeLongitude;

  /// Additional cities for personalized content (JSON array, up to 10).
  /// Format: [{"city":"Seattle","state":"WA","country":"USA","lat":47.6,"lng":-122.3}]
  String? additionalCities;

  /// Whether onboarding has been completed.
  bool onboardingCompleted;

  /// When preferences were created.
  DateTime createdAt;

  /// When preferences were last updated.
  DateTime updatedAt;

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserProfile copyWith({
    int? id,
    String? userId,
    _i2.FoodPhilosophy? foodPhilosophy,
    _i3.AdventureLevel? adventureLevel,
    String? familiarCuisines,
    String? wantToTryCuisines,
    String? dietaryRestrictions,
    String? homeCity,
    String? homeState,
    String? homeCountry,
    double? homeLatitude,
    double? homeLongitude,
    String? additionalCities,
    bool? onboardingCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserProfile',
      if (id != null) 'id': id,
      'userId': userId,
      if (foodPhilosophy != null) 'foodPhilosophy': foodPhilosophy?.toJson(),
      if (adventureLevel != null) 'adventureLevel': adventureLevel?.toJson(),
      if (familiarCuisines != null) 'familiarCuisines': familiarCuisines,
      if (wantToTryCuisines != null) 'wantToTryCuisines': wantToTryCuisines,
      if (dietaryRestrictions != null)
        'dietaryRestrictions': dietaryRestrictions,
      if (homeCity != null) 'homeCity': homeCity,
      if (homeState != null) 'homeState': homeState,
      if (homeCountry != null) 'homeCountry': homeCountry,
      if (homeLatitude != null) 'homeLatitude': homeLatitude,
      if (homeLongitude != null) 'homeLongitude': homeLongitude,
      if (additionalCities != null) 'additionalCities': additionalCities,
      'onboardingCompleted': onboardingCompleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserProfileImpl extends UserProfile {
  _UserProfileImpl({
    int? id,
    required String userId,
    _i2.FoodPhilosophy? foodPhilosophy,
    _i3.AdventureLevel? adventureLevel,
    String? familiarCuisines,
    String? wantToTryCuisines,
    String? dietaryRestrictions,
    String? homeCity,
    String? homeState,
    String? homeCountry,
    double? homeLatitude,
    double? homeLongitude,
    String? additionalCities,
    required bool onboardingCompleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         foodPhilosophy: foodPhilosophy,
         adventureLevel: adventureLevel,
         familiarCuisines: familiarCuisines,
         wantToTryCuisines: wantToTryCuisines,
         dietaryRestrictions: dietaryRestrictions,
         homeCity: homeCity,
         homeState: homeState,
         homeCountry: homeCountry,
         homeLatitude: homeLatitude,
         homeLongitude: homeLongitude,
         additionalCities: additionalCities,
         onboardingCompleted: onboardingCompleted,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserProfile copyWith({
    Object? id = _Undefined,
    String? userId,
    Object? foodPhilosophy = _Undefined,
    Object? adventureLevel = _Undefined,
    Object? familiarCuisines = _Undefined,
    Object? wantToTryCuisines = _Undefined,
    Object? dietaryRestrictions = _Undefined,
    Object? homeCity = _Undefined,
    Object? homeState = _Undefined,
    Object? homeCountry = _Undefined,
    Object? homeLatitude = _Undefined,
    Object? homeLongitude = _Undefined,
    Object? additionalCities = _Undefined,
    bool? onboardingCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      foodPhilosophy: foodPhilosophy is _i2.FoodPhilosophy?
          ? foodPhilosophy
          : this.foodPhilosophy,
      adventureLevel: adventureLevel is _i3.AdventureLevel?
          ? adventureLevel
          : this.adventureLevel,
      familiarCuisines: familiarCuisines is String?
          ? familiarCuisines
          : this.familiarCuisines,
      wantToTryCuisines: wantToTryCuisines is String?
          ? wantToTryCuisines
          : this.wantToTryCuisines,
      dietaryRestrictions: dietaryRestrictions is String?
          ? dietaryRestrictions
          : this.dietaryRestrictions,
      homeCity: homeCity is String? ? homeCity : this.homeCity,
      homeState: homeState is String? ? homeState : this.homeState,
      homeCountry: homeCountry is String? ? homeCountry : this.homeCountry,
      homeLatitude: homeLatitude is double? ? homeLatitude : this.homeLatitude,
      homeLongitude: homeLongitude is double?
          ? homeLongitude
          : this.homeLongitude,
      additionalCities: additionalCities is String?
          ? additionalCities
          : this.additionalCities,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
