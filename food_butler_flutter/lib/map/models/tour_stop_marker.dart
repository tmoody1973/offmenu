import 'package:food_butler_client/food_butler_client.dart';

/// Represents a tour stop with its map coordinates and marker data.
class TourStopMarker {
  /// The unique identifier for this stop.
  final String id;

  /// The stop number (1-based index in the tour).
  final int stopNumber;

  /// Latitude coordinate.
  final double latitude;

  /// Longitude coordinate.
  final double longitude;

  /// Restaurant name.
  final String name;

  /// Restaurant address.
  final String address;

  /// Cuisine type (if available).
  final String? cuisineType;

  /// Award badges for this restaurant.
  final List<String> awardBadges;

  /// Photo URL from Cloudflare R2.
  final String? photoUrl;

  /// Whether this is the current stop in navigation.
  final bool isCurrent;

  /// Whether this stop has been completed.
  final bool isCompleted;

  const TourStopMarker({
    required this.id,
    required this.stopNumber,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.address,
    this.cuisineType,
    this.awardBadges = const [],
    this.photoUrl,
    this.isCurrent = false,
    this.isCompleted = false,
  });

  /// Creates a TourStopMarker from a TourStop object.
  factory TourStopMarker.fromTourStop(
    TourStop stop, {
    required int index,
    bool isCurrent = false,
    bool isCompleted = false,
  }) {
    return TourStopMarker(
      id: '${stop.name}_$index',
      stopNumber: index + 1,
      latitude: stop.latitude,
      longitude: stop.longitude,
      name: stop.name,
      address: stop.address,
      awardBadges: stop.awardBadges,
      isCurrent: isCurrent,
      isCompleted: isCompleted,
    );
  }

  /// Returns a copy of this marker with updated current/completed state.
  TourStopMarker copyWith({
    bool? isCurrent,
    bool? isCompleted,
  }) {
    return TourStopMarker(
      id: id,
      stopNumber: stopNumber,
      latitude: latitude,
      longitude: longitude,
      name: name,
      address: address,
      cuisineType: cuisineType,
      awardBadges: awardBadges,
      photoUrl: photoUrl,
      isCurrent: isCurrent ?? this.isCurrent,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TourStopMarker && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
