/// Configuration for Google Maps integration.
class MapConfig {
  /// Default map center (San Francisco)
  static const double defaultLatitude = 37.7749;
  static const double defaultLongitude = -122.4194;

  /// Default zoom level
  static const double defaultZoom = 12.0;

  /// Responsive breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1024.0;

  /// Minimum tap target size for accessibility (44x44px)
  static const double minTapTargetSize = 44.0;

  /// Map padding values
  static const double mobilePadding = 16.0;
  static const double tabletPadding = 24.0;
  static const double desktopPadding = 32.0;

  /// Route polyline colors
  static const int walkingRouteColor = 0xFF22C55E; // Green
  static const int drivingRouteColor = 0xFF3B82F6; // Blue

  /// Polyline stroke width
  static const double polylineStrokeWidth = 4.0;

  /// Map style URL (Mapbox Streets)
  static const String mapStyleUri = 'mapbox://styles/mapbox/streets-v12';

  /// Zoom control button sizes
  static const double zoomButtonSize = 48.0;

  /// Animation durations
  static const Duration cameraAnimationDuration = Duration(milliseconds: 500);

  /// User location update interval
  static const Duration locationUpdateInterval = Duration(seconds: 5);

  /// Returns appropriate padding based on screen width.
  static double getPaddingForWidth(double width) {
    if (width < mobileBreakpoint) {
      return mobilePadding;
    } else if (width < tabletBreakpoint) {
      return tabletPadding;
    }
    return desktopPadding;
  }

  /// Returns true if the screen width is mobile size.
  static bool isMobile(double width) => width < mobileBreakpoint;

  /// Returns true if the screen width is tablet size.
  static bool isTablet(double width) =>
      width >= mobileBreakpoint && width < tabletBreakpoint;

  /// Returns true if the screen width is desktop size.
  static bool isDesktop(double width) => width >= tabletBreakpoint;
}
