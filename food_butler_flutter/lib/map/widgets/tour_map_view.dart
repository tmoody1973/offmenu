import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_butler_client/food_butler_client.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/map_config.dart';
import '../models/tour_stop_marker.dart';
import '../services/directions_service.dart';
import '../services/geolocation_service.dart';
import '../utils/bounds_calculator.dart';
import 'center_on_location_button.dart';
import 'directions_panel.dart';
import 'restaurant_info_bottom_sheet.dart';
import 'route_polyline_layer.dart';

/// Container component that composes all map layers and controls.
///
/// Features:
/// - Google Map with markers and polylines
/// - Tour markers with numbered stops
/// - User location marker
/// - Center on location button
/// - Directions panel
/// - Restaurant info bottom sheet
class TourMapView extends StatefulWidget {
  /// Tour result data from the backend.
  final TourResult? tourData;

  /// Transport mode for routing.
  final TransportMode transportMode;

  /// Callback when a restaurant is selected.
  final void Function(TourStopMarker stop)? onRestaurantSelect;

  /// Optional geolocation service (for testing).
  final GeolocationService? geolocationService;

  /// Optional directions service (for testing).
  final DirectionsService? directionsService;

  const TourMapView({
    super.key,
    this.tourData,
    this.transportMode = TransportMode.walking,
    this.onRestaurantSelect,
    this.geolocationService,
    this.directionsService,
  });

  @override
  State<TourMapView> createState() => _TourMapViewState();
}

class _TourMapViewState extends State<TourMapView> {
  GoogleMapController? _mapController;
  List<TourStopMarker> _stops = [];
  List<LatLng> _routeCoordinates = [];

  // State
  int? _selectedMarkerIndex;
  int _currentStopIndex = 0;
  UserLocation? _userLocation;
  LocationPermissionState _locationPermissionState =
      LocationPermissionState.unknown;
  bool _isLoadingLocation = false;
  DirectionsResult? _directions;
  bool _isLoadingDirections = false;
  bool _showDirectionsPanel = false;

  late final GeolocationService _geolocationService;
  late final DirectionsService _directionsService;

  @override
  void initState() {
    super.initState();
    _geolocationService =
        widget.geolocationService ?? MockGeolocationService();
    _directionsService = widget.directionsService ?? MockDirectionsService();
    _parseTourData();
  }

  @override
  void didUpdateWidget(TourMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tourData != oldWidget.tourData) {
      _parseTourData();
    }
  }

  void _parseTourData() {
    if (widget.tourData == null) {
      _stops = [];
      _routeCoordinates = [];
      return;
    }

    try {
      // Parse stops from JSON
      final stopsJson = jsonDecode(widget.tourData!.stopsJson) as List<dynamic>;
      _stops = stopsJson.asMap().entries.map((entry) {
        final index = entry.key;
        final stopData = entry.value as Map<String, dynamic>;
        return TourStopMarker(
          id: '${stopData['name']}_$index',
          stopNumber: index + 1,
          latitude: (stopData['latitude'] as num).toDouble(),
          longitude: (stopData['longitude'] as num).toDouble(),
          name: stopData['name'] as String,
          address: stopData['address'] as String,
          awardBadges: List<String>.from(stopData['awardBadges'] ?? []),
          isCurrent: index == _currentStopIndex,
        );
      }).toList();

      // Parse route coordinates from polyline
      if (widget.tourData!.routePolyline.isNotEmpty) {
        final decoded = PolylineDecoder.decode(widget.tourData!.routePolyline);
        _routeCoordinates = decoded
            .map((coord) => LatLng(coord[0], coord[1]))
            .toList();
      }
    } catch (e) {
      debugPrint('Error parsing tour data: $e');
      _stops = [];
      _routeCoordinates = [];
    }

    // Auto-fit bounds when tour loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fitBoundsToTour();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};

    for (var i = 0; i < _stops.length; i++) {
      final stop = _stops[i];
      markers.add(
        Marker(
          markerId: MarkerId(stop.id),
          position: LatLng(stop.latitude, stop.longitude),
          infoWindow: InfoWindow(
            title: '${i + 1}. ${stop.name}',
            snippet: stop.address,
          ),
          onTap: () => _onMarkerSelected(stop),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            i == _currentStopIndex
                ? BitmapDescriptor.hueGreen
                : BitmapDescriptor.hueOrange,
          ),
        ),
      );
    }

    // Add user location marker if available
    if (_userLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: LatLng(_userLocation!.latitude, _userLocation!.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
      );
    }

    return markers;
  }

  Set<Polyline> _buildPolylines() {
    if (_routeCoordinates.isEmpty) return {};

    final color = widget.transportMode == TransportMode.walking
        ? const Color(0xFF10B981)
        : const Color(0xFF3B82F6);

    return {
      Polyline(
        polylineId: const PolylineId('route'),
        points: _routeCoordinates,
        color: color,
        width: 4,
      ),
    };
  }

  void _fitBoundsToTour() {
    if (_mapController == null || _stops.isEmpty) return;

    final bounds = BoundsCalculator.calculateTourBounds(
      _stops,
      userLocation: _userLocation,
    );

    if (bounds != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(bounds.south, bounds.west),
            northeast: LatLng(bounds.north, bounds.east),
          ),
          50.0, // padding
        ),
      );
    }
  }

  void _onMarkerSelected(TourStopMarker marker) {
    final index = _stops.indexOf(marker);
    setState(() {
      _selectedMarkerIndex = index;
    });

    // Show bottom sheet
    RestaurantInfoBottomSheet.show(
      context,
      stop: marker,
      onViewDetails: widget.onRestaurantSelect,
    );
  }

  Future<void> _centerOnUserLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      final location = await _geolocationService.requestLocation();
      if (location != null && mounted) {
        setState(() {
          _userLocation = location;
          _locationPermissionState = LocationPermissionState.granted;
        });

        // Animate to user location
        await _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(location.latitude, location.longitude),
            15.0,
          ),
        );
      } else {
        setState(() {
          _locationPermissionState = _geolocationService.permissionState;
        });
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingLocation = false);
      }
    }
  }

  Future<void> _fetchDirections() async {
    if (_stops.length < 2) return;

    setState(() => _isLoadingDirections = true);

    try {
      final coordinates = _stops
          .map((s) => [s.latitude, s.longitude])
          .toList();
      final stopNames = _stops.map((s) => s.name).toList();

      final result = await _directionsService.getDirections(
        coordinates: coordinates,
        stopNames: stopNames,
        transportMode: widget.transportMode,
      );

      if (mounted) {
        setState(() {
          _directions = result;
          _showDirectionsPanel = result != null;
        });
      }
    } catch (e) {
      debugPrint('Error fetching directions: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingDirections = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Google Map
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _stops.isNotEmpty
                ? LatLng(_stops.first.latitude, _stops.first.longitude)
                : const LatLng(MapConfig.defaultLatitude, MapConfig.defaultLongitude),
            zoom: 13.0,
          ),
          mapType: MapType.normal,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          compassEnabled: true,
          markers: _buildMarkers(),
          polylines: _buildPolylines(),
        ),

        // Control buttons
        Positioned(
          right: 16,
          bottom: _showDirectionsPanel ? 320 : 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Fit all stops button
              _buildControlButton(
                icon: Icons.zoom_out_map_rounded,
                tooltip: 'Fit all stops',
                onTap: _fitBoundsToTour,
              ),
              const SizedBox(height: 8),

              // Get directions button
              _buildControlButton(
                icon: Icons.directions_rounded,
                tooltip: 'Get directions',
                isLoading: _isLoadingDirections,
                onTap: _fetchDirections,
              ),
              const SizedBox(height: 8),

              // Center on location button
              CenterOnLocationButton(
                onTap: _centerOnUserLocation,
                isLoading: _isLoadingLocation,
                permissionState: _locationPermissionState,
              ),
            ],
          ),
        ),

        // Directions panel
        if (_showDirectionsPanel)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: DirectionsPanel(
              directions: _directions,
              onCollapse: () {
                setState(() => _showDirectionsPanel = false);
              },
            ),
          ),

        // Location denied message
        if (_locationPermissionState == LocationPermissionState.denied)
          Positioned(
            left: 0,
            right: 0,
            bottom: _showDirectionsPanel ? 320 : 80,
            child: LocationPermissionDeniedMessage(
              onRetry: _centerOnUserLocation,
            ),
          ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Material(
        elevation: 2,
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(24),
          child: Tooltip(
            message: tooltip,
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(icon, color: const Color(0xFF2563EB)),
            ),
          ),
        ),
      ),
    );
  }
}
