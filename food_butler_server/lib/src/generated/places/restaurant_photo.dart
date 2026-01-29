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

/// Photo data for a restaurant from Google Places.
/// Stored as JSON array in MapRestaurant.additionalPhotosJson.
abstract class RestaurantPhoto
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  RestaurantPhoto._({
    required this.photoReference,
    required this.width,
    required this.height,
    required this.url,
    required this.thumbnailUrl,
    this.attribution,
  });

  factory RestaurantPhoto({
    required String photoReference,
    required int width,
    required int height,
    required String url,
    required String thumbnailUrl,
    String? attribution,
  }) = _RestaurantPhotoImpl;

  factory RestaurantPhoto.fromJson(Map<String, dynamic> jsonSerialization) {
    return RestaurantPhoto(
      photoReference: jsonSerialization['photoReference'] as String,
      width: jsonSerialization['width'] as int,
      height: jsonSerialization['height'] as int,
      url: jsonSerialization['url'] as String,
      thumbnailUrl: jsonSerialization['thumbnailUrl'] as String,
      attribution: jsonSerialization['attribution'] as String?,
    );
  }

  /// Google Places photo reference (used to fetch the actual image).
  String photoReference;

  /// Photo width in pixels.
  int width;

  /// Photo height in pixels.
  int height;

  /// Proxied URL for full-size image.
  String url;

  /// Proxied URL for thumbnail image.
  String thumbnailUrl;

  /// Attribution text (required by Google).
  String? attribution;

  /// Returns a shallow copy of this [RestaurantPhoto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RestaurantPhoto copyWith({
    String? photoReference,
    int? width,
    int? height,
    String? url,
    String? thumbnailUrl,
    String? attribution,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RestaurantPhoto',
      'photoReference': photoReference,
      'width': width,
      'height': height,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
      if (attribution != null) 'attribution': attribution,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RestaurantPhoto',
      'photoReference': photoReference,
      'width': width,
      'height': height,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
      if (attribution != null) 'attribution': attribution,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RestaurantPhotoImpl extends RestaurantPhoto {
  _RestaurantPhotoImpl({
    required String photoReference,
    required int width,
    required int height,
    required String url,
    required String thumbnailUrl,
    String? attribution,
  }) : super._(
         photoReference: photoReference,
         width: width,
         height: height,
         url: url,
         thumbnailUrl: thumbnailUrl,
         attribution: attribution,
       );

  /// Returns a shallow copy of this [RestaurantPhoto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RestaurantPhoto copyWith({
    String? photoReference,
    int? width,
    int? height,
    String? url,
    String? thumbnailUrl,
    Object? attribution = _Undefined,
  }) {
    return RestaurantPhoto(
      photoReference: photoReference ?? this.photoReference,
      width: width ?? this.width,
      height: height ?? this.height,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      attribution: attribution is String? ? attribution : this.attribution,
    );
  }
}
