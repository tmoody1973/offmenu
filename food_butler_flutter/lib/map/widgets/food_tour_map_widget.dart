import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/map_config.dart';

/// Callback type for when the map is ready.
typedef OnMapReadyCallback = void Function(GoogleMapController mapController);

/// Base interactive map widget for displaying food tours.
///
/// This widget provides:
/// - Google Maps for all platforms (web, iOS, Android)
/// - Mobile-first responsive sizing
/// - Touch-friendly zoom controls (minimum 44x44px tap targets)
/// - Gesture handling for pan/pinch-zoom
class FoodTourMapWidget extends StatefulWidget {
  /// Initial center latitude for the map.
  final double initialLatitude;

  /// Initial center longitude for the map.
  final double initialLongitude;

  /// Initial zoom level for the map.
  final double initialZoom;

  /// Callback when the map is ready for interaction.
  final OnMapReadyCallback? onMapReady;

  /// Whether to show zoom controls.
  final bool showZoomControls;

  /// Optional error widget to display when map fails to load.
  final Widget? errorWidget;

  /// Markers to display on the map.
  final Set<Marker>? markers;

  /// Polylines to display on the map (routes).
  final Set<Polyline>? polylines;

  const FoodTourMapWidget({
    super.key,
    this.initialLatitude = MapConfig.defaultLatitude,
    this.initialLongitude = MapConfig.defaultLongitude,
    this.initialZoom = MapConfig.defaultZoom,
    this.onMapReady,
    this.showZoomControls = true,
    this.errorWidget,
    this.markers,
    this.polylines,
  });

  @override
  State<FoodTourMapWidget> createState() => _FoodTourMapWidgetState();
}

class _FoodTourMapWidgetState extends State<FoodTourMapWidget> {
  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? _mapController;
  bool _isMapReady = false;
  double _currentZoom = 13.0;

  @override
  void initState() {
    super.initState();
    _currentZoom = widget.initialZoom;
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    _mapController = controller;
    setState(() {
      _isMapReady = true;
    });
    widget.onMapReady?.call(controller);
  }

  Future<void> _zoomIn() async {
    if (_mapController != null) {
      _currentZoom = (_currentZoom + 1).clamp(1.0, 20.0);
      await _mapController!.animateCamera(
        CameraUpdate.zoomIn(),
      );
    }
  }

  Future<void> _zoomOut() async {
    if (_mapController != null) {
      _currentZoom = (_currentZoom - 1).clamp(1.0, 20.0);
      await _mapController!.animateCamera(
        CameraUpdate.zoomOut(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final padding = MapConfig.getPaddingForWidth(screenWidth);

        return _buildGoogleMap(padding);
      },
    );
  }

  Widget _buildGoogleMap(double padding) {
    return Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    widget.initialLatitude,
                    widget.initialLongitude,
                  ),
                  zoom: widget.initialZoom,
                ),
                mapType: MapType.normal,
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false, // We use custom controls
                compassEnabled: true,
                markers: widget.markers ?? {},
                polylines: widget.polylines ?? {},
              ),
            ),
          ),
        ),

        // Zoom controls
        if (widget.showZoomControls && _isMapReady)
          Positioned(
            right: padding + 8,
            bottom: padding + 8,
            child: _buildZoomControls(),
          ),
      ],
    );
  }

  Widget _buildZoomControls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Zoom in button (minimum 44x44px for accessibility)
        SizedBox(
          width: MapConfig.zoomButtonSize,
          height: MapConfig.zoomButtonSize,
          child: Material(
            elevation: 2,
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: InkWell(
              onTap: _zoomIn,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              child: const Center(
                child: Icon(
                  Icons.add,
                  size: 24,
                  semanticLabel: 'Zoom in',
                ),
              ),
            ),
          ),
        ),
        Container(
          width: MapConfig.zoomButtonSize,
          height: 1,
          color: Colors.grey[300],
        ),
        // Zoom out button (minimum 44x44px for accessibility)
        SizedBox(
          width: MapConfig.zoomButtonSize,
          height: MapConfig.zoomButtonSize,
          child: Material(
            elevation: 2,
            color: Colors.white,
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(8)),
            child: InkWell(
              onTap: _zoomOut,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(8)),
              child: const Center(
                child: Icon(
                  Icons.remove,
                  size: 24,
                  semanticLabel: 'Zoom out',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
