import 'package:flutter/material.dart';

import '../models/map_config.dart';
import '../services/geolocation_service.dart';

/// A floating action button to center the map on the user's location.
///
/// Features:
/// - Position: bottom-right of map
/// - Shows loading state while fetching location
/// - Disabled when location permission denied
/// - Minimum 44x44px tap target for accessibility
class CenterOnLocationButton extends StatelessWidget {
  /// Callback when the button is tapped.
  final VoidCallback? onTap;

  /// Whether the button is currently loading.
  final bool isLoading;

  /// Current permission state for the button's enabled state.
  final LocationPermissionState permissionState;

  /// Size of the button.
  final double size;

  const CenterOnLocationButton({
    super.key,
    this.onTap,
    this.isLoading = false,
    this.permissionState = LocationPermissionState.unknown,
    this.size = MapConfig.zoomButtonSize,
  });

  bool get _isDisabled =>
      permissionState == LocationPermissionState.denied ||
      permissionState == LocationPermissionState.unavailable;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Material(
        elevation: 2,
        color: _isDisabled ? Colors.grey[200] : Colors.white,
        borderRadius: BorderRadius.circular(size / 2),
        child: InkWell(
          onTap: _isDisabled || isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(size / 2),
          child: Center(
            child: _buildIcon(),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (isLoading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
        ),
      );
    }

    if (_isDisabled) {
      return Icon(
        Icons.location_disabled_rounded,
        size: 24,
        color: Colors.grey[400],
        semanticLabel: 'Location unavailable',
      );
    }

    return const Icon(
      Icons.my_location_rounded,
      size: 24,
      color: Color(0xFF2563EB),
      semanticLabel: 'Center on my location',
    );
  }
}

/// A widget that shows a message when location permission is denied.
class LocationPermissionDeniedMessage extends StatelessWidget {
  /// Callback when the "Try Again" button is tapped.
  final VoidCallback? onRetry;

  const LocationPermissionDeniedMessage({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.location_off_rounded, color: Colors.amber[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Location Access Denied',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[900],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Enable location access in your browser settings to see your position on the map.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.amber[800],
                  ),
                ),
              ],
            ),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: const Text('Try Again'),
            ),
        ],
      ),
    );
  }
}
