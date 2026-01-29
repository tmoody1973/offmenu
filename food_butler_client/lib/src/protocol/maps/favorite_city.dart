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

/// A user's favorite city for restaurant maps.
/// Users can have their home city + up to 10 additional cities (11 total).
abstract class FavoriteCity implements _i1.SerializableModel {
  FavoriteCity._({
    this.id,
    required this.userId,
    required this.cityName,
    this.stateOrRegion,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.isHomeCity,
    required this.displayOrder,
    required this.createdAt,
  });

  factory FavoriteCity({
    int? id,
    required String userId,
    required String cityName,
    String? stateOrRegion,
    required String country,
    required double latitude,
    required double longitude,
    required bool isHomeCity,
    required int displayOrder,
    required DateTime createdAt,
  }) = _FavoriteCityImpl;

  factory FavoriteCity.fromJson(Map<String, dynamic> jsonSerialization) {
    return FavoriteCity(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      cityName: jsonSerialization['cityName'] as String,
      stateOrRegion: jsonSerialization['stateOrRegion'] as String?,
      country: jsonSerialization['country'] as String,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      isHomeCity: jsonSerialization['isHomeCity'] as bool,
      displayOrder: jsonSerialization['displayOrder'] as int,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The user ID who saved this city.
  String userId;

  /// City name (e.g., "Austin", "Chicago", "Tokyo").
  String cityName;

  /// State/region (e.g., "TX", "IL", "Tokyo").
  String? stateOrRegion;

  /// Country (e.g., "USA", "Japan").
  String country;

  /// Latitude of city center.
  double latitude;

  /// Longitude of city center.
  double longitude;

  /// Whether this is the user's home city.
  bool isHomeCity;

  /// Display order (0 = home city, 1-10 = favorites).
  int displayOrder;

  /// When this city was added.
  DateTime createdAt;

  /// Returns a shallow copy of this [FavoriteCity]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FavoriteCity copyWith({
    int? id,
    String? userId,
    String? cityName,
    String? stateOrRegion,
    String? country,
    double? latitude,
    double? longitude,
    bool? isHomeCity,
    int? displayOrder,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FavoriteCity',
      if (id != null) 'id': id,
      'userId': userId,
      'cityName': cityName,
      if (stateOrRegion != null) 'stateOrRegion': stateOrRegion,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'isHomeCity': isHomeCity,
      'displayOrder': displayOrder,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FavoriteCityImpl extends FavoriteCity {
  _FavoriteCityImpl({
    int? id,
    required String userId,
    required String cityName,
    String? stateOrRegion,
    required String country,
    required double latitude,
    required double longitude,
    required bool isHomeCity,
    required int displayOrder,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         cityName: cityName,
         stateOrRegion: stateOrRegion,
         country: country,
         latitude: latitude,
         longitude: longitude,
         isHomeCity: isHomeCity,
         displayOrder: displayOrder,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [FavoriteCity]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FavoriteCity copyWith({
    Object? id = _Undefined,
    String? userId,
    String? cityName,
    Object? stateOrRegion = _Undefined,
    String? country,
    double? latitude,
    double? longitude,
    bool? isHomeCity,
    int? displayOrder,
    DateTime? createdAt,
  }) {
    return FavoriteCity(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      cityName: cityName ?? this.cityName,
      stateOrRegion: stateOrRegion is String?
          ? stateOrRegion
          : this.stateOrRegion,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isHomeCity: isHomeCity ?? this.isHomeCity,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
