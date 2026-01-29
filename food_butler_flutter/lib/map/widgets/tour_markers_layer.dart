import 'package:flutter/material.dart';

import '../models/tour_stop_marker.dart';
import 'numbered_marker_widget.dart';

/// Callback type for when a marker is selected.
typedef OnMarkerSelectedCallback = void Function(TourStopMarker marker);

/// A layer component that renders tour stop markers on the map.
///
/// Features:
/// - Renders NumberedMarkerWidget for each tour stop
/// - Manages marker selection state
/// - Supports dynamic updates when tour data changes
/// - Visual hierarchy for current vs upcoming vs completed stops
class TourMarkersLayer extends StatefulWidget {
  /// List of tour stops to display as markers.
  final List<TourStopMarker> stops;

  /// Index of the currently selected marker (or null if none selected).
  final int? selectedIndex;

  /// Callback when a marker is tapped.
  final OnMarkerSelectedCallback? onMarkerSelected;

  /// Function to convert lat/lng to screen position.
  /// This should be provided by the parent map widget.
  final Offset Function(double latitude, double longitude)? toScreenPosition;

  const TourMarkersLayer({
    super.key,
    required this.stops,
    this.selectedIndex,
    this.onMarkerSelected,
    this.toScreenPosition,
  });

  @override
  State<TourMarkersLayer> createState() => _TourMarkersLayerState();
}

class _TourMarkersLayerState extends State<TourMarkersLayer> {
  @override
  Widget build(BuildContext context) {
    // If no position converter is provided, render markers in a column for testing
    if (widget.toScreenPosition == null) {
      return _buildTestLayout();
    }

    // Build positioned markers for actual map usage
    return Stack(
      children: widget.stops.asMap().entries.map((entry) {
        final index = entry.key;
        final stop = entry.value;
        final position = widget.toScreenPosition!(stop.latitude, stop.longitude);

        return Positioned(
          left: position.dx - 22, // Center the marker (44/2)
          top: position.dy - 22,
          child: _buildMarker(stop, index),
        );
      }).toList(),
    );
  }

  /// Build a test layout for widget testing (vertical list of markers).
  Widget _buildTestLayout() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widget.stops.asMap().entries.map((entry) {
        final index = entry.key;
        final stop = entry.value;
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: _buildMarker(stop, index),
        );
      }).toList(),
    );
  }

  Widget _buildMarker(TourStopMarker stop, int index) {
    final isSelected = widget.selectedIndex == index;
    final state = _getMarkerState(stop, isSelected);

    return NumberedMarkerWidget(
      key: ValueKey(stop.id),
      stopNumber: stop.stopNumber,
      state: state,
      isSelected: isSelected,
      onTap: () => widget.onMarkerSelected?.call(stop),
    );
  }

  MarkerState _getMarkerState(TourStopMarker stop, bool isSelected) {
    if (isSelected) {
      return MarkerState.selected;
    }
    if (stop.isCurrent) {
      return MarkerState.current;
    }
    if (stop.isCompleted) {
      return MarkerState.completed;
    }
    return MarkerState.upcoming;
  }
}

/// Extension to simplify creating markers from tour data.
extension TourStopMarkerListExtension on List<TourStopMarker> {
  /// Updates the current stop index.
  List<TourStopMarker> withCurrentStop(int currentIndex) {
    return asMap().entries.map((entry) {
      final index = entry.key;
      final stop = entry.value;
      return stop.copyWith(
        isCurrent: index == currentIndex,
        isCompleted: index < currentIndex,
      );
    }).toList();
  }
}
