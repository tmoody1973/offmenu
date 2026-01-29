import 'dart:async';

import 'package:flutter/foundation.dart';

/// Permission state for geolocation.
enum LocationPermissionState {
  /// Permission not yet requested.
  unknown,

  /// Permission granted.
  granted,

  /// Permission denied by user.
  denied,

  /// Location services unavailable.
  unavailable,
}

/// User location data.
class UserLocation {
  final double latitude;
  final double longitude;
  final double? accuracy;
  final DateTime timestamp;

  const UserLocation({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    required this.timestamp,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserLocation &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => Object.hash(latitude, longitude);
}

/// Abstract interface for geolocation services.
abstract class GeolocationService {
  /// Current permission state.
  LocationPermissionState get permissionState;

  /// Last known user location.
  UserLocation? get lastLocation;

  /// Stream of location updates.
  Stream<UserLocation> get locationStream;

  /// Returns true if permission has been granted.
  bool get hasPermission;

  /// Requests location permission and gets current position.
  Future<UserLocation?> requestLocation();

  /// Starts watching location updates.
  void startWatching({Duration interval = const Duration(seconds: 5)});

  /// Stops watching location updates.
  void stopWatching();

  /// Disposes the service.
  void dispose();
}

/// Mock implementation for testing.
class MockGeolocationService implements GeolocationService {
  LocationPermissionState _permissionState = LocationPermissionState.unknown;
  UserLocation? _lastLocation;
  final _locationController = StreamController<UserLocation>.broadcast();

  /// Set the mock permission state.
  set mockPermissionState(LocationPermissionState state) =>
      _permissionState = state;

  /// Set the mock location.
  set mockLocation(UserLocation? location) {
    _lastLocation = location;
    if (location != null) {
      _locationController.add(location);
    }
  }

  @override
  LocationPermissionState get permissionState => _permissionState;

  @override
  UserLocation? get lastLocation => _lastLocation;

  @override
  Stream<UserLocation> get locationStream => _locationController.stream;

  @override
  bool get hasPermission => _permissionState == LocationPermissionState.granted;

  @override
  Future<UserLocation?> requestLocation() async {
    if (_permissionState == LocationPermissionState.denied) {
      return null;
    }
    if (_permissionState == LocationPermissionState.unknown) {
      _permissionState = LocationPermissionState.granted;
    }
    return _lastLocation;
  }

  @override
  void startWatching({Duration interval = const Duration(seconds: 5)}) {}

  @override
  void stopWatching() {}

  @override
  void dispose() {
    _locationController.close();
  }

  /// Simulates receiving a location update.
  void simulateLocationUpdate(UserLocation location) {
    _lastLocation = location;
    _locationController.add(location);
  }
}
