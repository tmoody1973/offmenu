import '../models/tour_stop_marker.dart';
import '../services/geolocation_service.dart';

/// Bounding box for map coordinates.
class MapBounds {
  final double north;
  final double south;
  final double east;
  final double west;

  const MapBounds({
    required this.north,
    required this.south,
    required this.east,
    required this.west,
  });

  /// Center latitude of the bounds.
  double get centerLatitude => (north + south) / 2;

  /// Center longitude of the bounds.
  double get centerLongitude => (east + west) / 2;

  /// Latitude span of the bounds.
  double get latitudeSpan => (north - south).abs();

  /// Longitude span of the bounds.
  double get longitudeSpan => (east - west).abs();

  /// Expands the bounds by the given padding factor.
  MapBounds withPadding(double paddingFactor) {
    final latPad = latitudeSpan * paddingFactor;
    final lngPad = longitudeSpan * paddingFactor;

    return MapBounds(
      north: north + latPad,
      south: south - latPad,
      east: east + lngPad,
      west: west - lngPad,
    );
  }

  @override
  String toString() =>
      'MapBounds(N: $north, S: $south, E: $east, W: $west)';
}

/// Utility for calculating map bounds to fit all tour stops.
class BoundsCalculator {
  /// Default padding factor (10% on each side).
  static const double defaultPaddingFactor = 0.1;

  /// Calculates bounding box to show all tour stops.
  ///
  /// [stops] - List of tour stop markers.
  /// [userLocation] - Optional user location to include in bounds.
  /// [paddingFactor] - Padding to apply around bounds (default 10%).
  ///
  /// Returns null if no stops are provided.
  static MapBounds? calculateTourBounds(
    List<TourStopMarker> stops, {
    UserLocation? userLocation,
    double paddingFactor = defaultPaddingFactor,
  }) {
    if (stops.isEmpty) return null;

    // Start with first stop
    var north = stops.first.latitude;
    var south = stops.first.latitude;
    var east = stops.first.longitude;
    var west = stops.first.longitude;

    // Expand bounds to include all stops
    for (final stop in stops) {
      if (stop.latitude > north) north = stop.latitude;
      if (stop.latitude < south) south = stop.latitude;
      if (stop.longitude > east) east = stop.longitude;
      if (stop.longitude < west) west = stop.longitude;
    }

    // Include user location if available
    if (userLocation != null) {
      if (userLocation.latitude > north) north = userLocation.latitude;
      if (userLocation.latitude < south) south = userLocation.latitude;
      if (userLocation.longitude > east) east = userLocation.longitude;
      if (userLocation.longitude < west) west = userLocation.longitude;
    }

    final bounds = MapBounds(
      north: north,
      south: south,
      east: east,
      west: west,
    );

    // Apply padding so markers aren't cut off at edges
    return bounds.withPadding(paddingFactor);
  }

  /// Calculates the optimal zoom level for the given bounds.
  ///
  /// [bounds] - The map bounds.
  /// [mapWidth] - Width of the map container in pixels.
  /// [mapHeight] - Height of the map container in pixels.
  ///
  /// Returns a zoom level between 1 and 18.
  static double calculateZoomForBounds(
    MapBounds bounds, {
    required double mapWidth,
    required double mapHeight,
  }) {
    const double worldWidth = 256.0; // Tile size at zoom 0
    const double maxZoom = 18.0;
    const double minZoom = 1.0;

    // Calculate the angular distance
    final latAngle = bounds.latitudeSpan;
    final lngAngle = bounds.longitudeSpan;

    // Calculate zoom for each dimension
    double latZoom = 0;
    double lngZoom = 0;

    if (latAngle > 0) {
      // Approximate: 360 degrees = world width at zoom 0
      final latRatio = mapHeight / (worldWidth * latAngle / 360);
      latZoom = _log2(latRatio);
    }

    if (lngAngle > 0) {
      final lngRatio = mapWidth / (worldWidth * lngAngle / 360);
      lngZoom = _log2(lngRatio);
    }

    // Use the smaller zoom to ensure all content fits
    final zoom = latZoom < lngZoom ? latZoom : lngZoom;

    // Clamp to valid range
    return zoom.clamp(minZoom, maxZoom);
  }

  static double _log2(double x) {
    return x > 0 ? (x).clamp(0.001, double.infinity) : 0;
  }
}
