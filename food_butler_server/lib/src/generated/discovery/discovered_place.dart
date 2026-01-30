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
import 'package:food_butler_server/src/generated/protocol.dart' as _i2;

/// A discovered place from the AI food concierge.
abstract class DiscoveredPlace
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  DiscoveredPlace._({
    required this.placeId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.reviewCount,
    required this.priceLevel,
    this.photoUrl,
    required this.whyRecommended,
    required this.categories,
    this.isOpen,
    this.mustOrder,
    this.proTips,
    this.websiteUrl,
    this.phoneNumber,
    this.googleMapsUrl,
  });

  factory DiscoveredPlace({
    required String placeId,
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required double rating,
    required int reviewCount,
    required String priceLevel,
    String? photoUrl,
    required String whyRecommended,
    required List<String> categories,
    bool? isOpen,
    List<String>? mustOrder,
    String? proTips,
    String? websiteUrl,
    String? phoneNumber,
    String? googleMapsUrl,
  }) = _DiscoveredPlaceImpl;

  factory DiscoveredPlace.fromJson(Map<String, dynamic> jsonSerialization) {
    return DiscoveredPlace(
      placeId: jsonSerialization['placeId'] as String,
      name: jsonSerialization['name'] as String,
      address: jsonSerialization['address'] as String,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      rating: (jsonSerialization['rating'] as num).toDouble(),
      reviewCount: jsonSerialization['reviewCount'] as int,
      priceLevel: jsonSerialization['priceLevel'] as String,
      photoUrl: jsonSerialization['photoUrl'] as String?,
      whyRecommended: jsonSerialization['whyRecommended'] as String,
      categories: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['categories'],
      ),
      isOpen: jsonSerialization['isOpen'] as bool?,
      mustOrder: jsonSerialization['mustOrder'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['mustOrder'],
            ),
      proTips: jsonSerialization['proTips'] as String?,
      websiteUrl: jsonSerialization['websiteUrl'] as String?,
      phoneNumber: jsonSerialization['phoneNumber'] as String?,
      googleMapsUrl: jsonSerialization['googleMapsUrl'] as String?,
    );
  }

  /// The Google Place ID.
  String placeId;

  /// Name of the restaurant.
  String name;

  /// Full address.
  String address;

  /// Latitude coordinate.
  double latitude;

  /// Longitude coordinate.
  double longitude;

  /// Rating (0-5).
  double rating;

  /// Number of reviews.
  int reviewCount;

  /// Price level display (e.g., "$", "$$", "$$$").
  String priceLevel;

  /// URL to a photo (from Google Places).
  String? photoUrl;

  /// Why the Butler recommends this place (rich, editorial description).
  String whyRecommended;

  /// Types/categories (e.g., "Japanese", "Ramen").
  List<String> categories;

  /// Is it currently open?
  bool? isOpen;

  /// Must-order dishes with descriptions.
  List<String>? mustOrder;

  /// Pro tips (best seats, when to go, insider knowledge).
  String? proTips;

  /// Restaurant website URL.
  String? websiteUrl;

  /// Phone number.
  String? phoneNumber;

  /// Google Maps URL for directions.
  String? googleMapsUrl;

  /// Returns a shallow copy of this [DiscoveredPlace]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DiscoveredPlace copyWith({
    String? placeId,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    double? rating,
    int? reviewCount,
    String? priceLevel,
    String? photoUrl,
    String? whyRecommended,
    List<String>? categories,
    bool? isOpen,
    List<String>? mustOrder,
    String? proTips,
    String? websiteUrl,
    String? phoneNumber,
    String? googleMapsUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DiscoveredPlace',
      'placeId': placeId,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'reviewCount': reviewCount,
      'priceLevel': priceLevel,
      if (photoUrl != null) 'photoUrl': photoUrl,
      'whyRecommended': whyRecommended,
      'categories': categories.toJson(),
      if (isOpen != null) 'isOpen': isOpen,
      if (mustOrder != null) 'mustOrder': mustOrder?.toJson(),
      if (proTips != null) 'proTips': proTips,
      if (websiteUrl != null) 'websiteUrl': websiteUrl,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (googleMapsUrl != null) 'googleMapsUrl': googleMapsUrl,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DiscoveredPlace',
      'placeId': placeId,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'reviewCount': reviewCount,
      'priceLevel': priceLevel,
      if (photoUrl != null) 'photoUrl': photoUrl,
      'whyRecommended': whyRecommended,
      'categories': categories.toJson(),
      if (isOpen != null) 'isOpen': isOpen,
      if (mustOrder != null) 'mustOrder': mustOrder?.toJson(),
      if (proTips != null) 'proTips': proTips,
      if (websiteUrl != null) 'websiteUrl': websiteUrl,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (googleMapsUrl != null) 'googleMapsUrl': googleMapsUrl,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DiscoveredPlaceImpl extends DiscoveredPlace {
  _DiscoveredPlaceImpl({
    required String placeId,
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required double rating,
    required int reviewCount,
    required String priceLevel,
    String? photoUrl,
    required String whyRecommended,
    required List<String> categories,
    bool? isOpen,
    List<String>? mustOrder,
    String? proTips,
    String? websiteUrl,
    String? phoneNumber,
    String? googleMapsUrl,
  }) : super._(
         placeId: placeId,
         name: name,
         address: address,
         latitude: latitude,
         longitude: longitude,
         rating: rating,
         reviewCount: reviewCount,
         priceLevel: priceLevel,
         photoUrl: photoUrl,
         whyRecommended: whyRecommended,
         categories: categories,
         isOpen: isOpen,
         mustOrder: mustOrder,
         proTips: proTips,
         websiteUrl: websiteUrl,
         phoneNumber: phoneNumber,
         googleMapsUrl: googleMapsUrl,
       );

  /// Returns a shallow copy of this [DiscoveredPlace]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DiscoveredPlace copyWith({
    String? placeId,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    double? rating,
    int? reviewCount,
    String? priceLevel,
    Object? photoUrl = _Undefined,
    String? whyRecommended,
    List<String>? categories,
    Object? isOpen = _Undefined,
    Object? mustOrder = _Undefined,
    Object? proTips = _Undefined,
    Object? websiteUrl = _Undefined,
    Object? phoneNumber = _Undefined,
    Object? googleMapsUrl = _Undefined,
  }) {
    return DiscoveredPlace(
      placeId: placeId ?? this.placeId,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      priceLevel: priceLevel ?? this.priceLevel,
      photoUrl: photoUrl is String? ? photoUrl : this.photoUrl,
      whyRecommended: whyRecommended ?? this.whyRecommended,
      categories: categories ?? this.categories.map((e0) => e0).toList(),
      isOpen: isOpen is bool? ? isOpen : this.isOpen,
      mustOrder: mustOrder is List<String>?
          ? mustOrder
          : this.mustOrder?.map((e0) => e0).toList(),
      proTips: proTips is String? ? proTips : this.proTips,
      websiteUrl: websiteUrl is String? ? websiteUrl : this.websiteUrl,
      phoneNumber: phoneNumber is String? ? phoneNumber : this.phoneNumber,
      googleMapsUrl: googleMapsUrl is String?
          ? googleMapsUrl
          : this.googleMapsUrl,
    );
  }
}
