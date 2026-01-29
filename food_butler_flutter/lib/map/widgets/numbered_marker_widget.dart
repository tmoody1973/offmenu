import 'package:flutter/material.dart';

import '../models/map_config.dart';

/// Visual state of a tour stop marker.
enum MarkerState {
  /// Standard state for upcoming stops.
  upcoming,

  /// Emphasized state for the current stop.
  current,

  /// Muted state for completed stops.
  completed,

  /// Selected state when user taps the marker.
  selected,
}

/// A numbered circular marker for tour stops.
///
/// Features:
/// - Circular design with centered stop number
/// - Visual hierarchy based on stop state (current, upcoming, completed)
/// - Minimum 44x44px tap target for accessibility
/// - Distinct styling that stands out against map backgrounds
class NumberedMarkerWidget extends StatelessWidget {
  /// The stop number to display (1-based).
  final int stopNumber;

  /// The current state of this marker.
  final MarkerState state;

  /// Whether this marker is currently selected.
  final bool isSelected;

  /// Callback when the marker is tapped.
  final VoidCallback? onTap;

  /// Size of the marker (defaults to minimum tap target size).
  final double size;

  const NumberedMarkerWidget({
    super.key,
    required this.stopNumber,
    this.state = MarkerState.upcoming,
    this.isSelected = false,
    this.onTap,
    this.size = MapConfig.minTapTargetSize,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveState = isSelected ? MarkerState.selected : state;
    final colors = _getColors(effectiveState);
    final markerSize = _getMarkerSize(effectiveState);
    final fontSize = _getFontSize(effectiveState);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        // Ensure minimum tap target size for accessibility
        width: size,
        height: size,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: markerSize,
            height: markerSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.backgroundColor,
              border: Border.all(
                color: colors.borderColor,
                width: colors.borderWidth,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(40),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                stopNumber.toString(),
                style: TextStyle(
                  color: colors.textColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _getMarkerSize(MarkerState state) {
    switch (state) {
      case MarkerState.current:
      case MarkerState.selected:
        return 40.0; // Larger for emphasis
      case MarkerState.upcoming:
        return 32.0;
      case MarkerState.completed:
        return 28.0;
    }
  }

  double _getFontSize(MarkerState state) {
    switch (state) {
      case MarkerState.current:
      case MarkerState.selected:
        return 16.0;
      case MarkerState.upcoming:
        return 14.0;
      case MarkerState.completed:
        return 12.0;
    }
  }

  _MarkerColors _getColors(MarkerState state) {
    switch (state) {
      case MarkerState.current:
        return _MarkerColors(
          backgroundColor: const Color(0xFF2563EB), // Blue
          borderColor: Colors.white,
          borderWidth: 3.0,
          textColor: Colors.white,
        );
      case MarkerState.selected:
        return _MarkerColors(
          backgroundColor: const Color(0xFF7C3AED), // Purple
          borderColor: Colors.white,
          borderWidth: 3.0,
          textColor: Colors.white,
        );
      case MarkerState.upcoming:
        return _MarkerColors(
          backgroundColor: const Color(0xFFF97316), // Orange
          borderColor: Colors.white,
          borderWidth: 2.0,
          textColor: Colors.white,
        );
      case MarkerState.completed:
        return _MarkerColors(
          backgroundColor: const Color(0xFF9CA3AF), // Gray
          borderColor: Colors.white,
          borderWidth: 2.0,
          textColor: Colors.white,
        );
    }
  }
}

class _MarkerColors {
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final Color textColor;

  _MarkerColors({
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
    required this.textColor,
  });
}
