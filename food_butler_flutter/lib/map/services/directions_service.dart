import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:food_butler_client/food_butler_client.dart';
import 'package:http/http.dart' as http;

/// A single step in turn-by-turn directions.
class DirectionStep {
  /// The maneuver instruction text.
  final String instruction;

  /// Distance in meters for this step.
  final int distanceMeters;

  /// Duration in seconds for this step.
  final int durationSeconds;

  /// Type of maneuver (turn, straight, arrive, etc.).
  final String maneuverType;

  /// Optional modifier (left, right, slight left, etc.).
  final String? modifier;

  const DirectionStep({
    required this.instruction,
    required this.distanceMeters,
    required this.durationSeconds,
    required this.maneuverType,
    this.modifier,
  });

  /// Human-readable distance string.
  String get distanceText {
    if (distanceMeters >= 1000) {
      return '${(distanceMeters / 1000).toStringAsFixed(1)} km';
    }
    return '$distanceMeters m';
  }

  /// Human-readable duration string.
  String get durationText {
    if (durationSeconds >= 3600) {
      final hours = durationSeconds ~/ 3600;
      final mins = (durationSeconds % 3600) ~/ 60;
      return '${hours}h ${mins}min';
    }
    if (durationSeconds >= 60) {
      return '${durationSeconds ~/ 60} min';
    }
    return '$durationSeconds sec';
  }
}

/// A leg of the journey between two stops.
class DirectionsLeg {
  /// Origin stop name.
  final String originName;

  /// Destination stop name.
  final String destinationName;

  /// Total distance in meters.
  final int totalDistanceMeters;

  /// Total duration in seconds.
  final int totalDurationSeconds;

  /// Individual direction steps.
  final List<DirectionStep> steps;

  const DirectionsLeg({
    required this.originName,
    required this.destinationName,
    required this.totalDistanceMeters,
    required this.totalDurationSeconds,
    required this.steps,
  });

  /// Human-readable distance string.
  String get distanceText {
    if (totalDistanceMeters >= 1000) {
      return '${(totalDistanceMeters / 1000).toStringAsFixed(1)} km';
    }
    return '$totalDistanceMeters m';
  }

  /// Human-readable duration string.
  String get durationText {
    if (totalDurationSeconds >= 3600) {
      final hours = totalDurationSeconds ~/ 3600;
      final mins = (totalDurationSeconds % 3600) ~/ 60;
      return '${hours}h ${mins}min';
    }
    if (totalDurationSeconds >= 60) {
      return '${totalDurationSeconds ~/ 60} min';
    }
    return '$totalDurationSeconds sec';
  }
}

/// Result of a directions request.
class DirectionsResult {
  /// List of direction legs.
  final List<DirectionsLeg> legs;

  /// Total distance in meters.
  final int totalDistanceMeters;

  /// Total duration in seconds.
  final int totalDurationSeconds;

  /// Transport mode used.
  final TransportMode transportMode;

  const DirectionsResult({
    required this.legs,
    required this.totalDistanceMeters,
    required this.totalDurationSeconds,
    required this.transportMode,
  });
}

/// Service for fetching turn-by-turn directions from Mapbox.
abstract class DirectionsService {
  /// Fetches turn-by-turn directions between stops.
  Future<DirectionsResult?> getDirections({
    required List<List<double>> coordinates,
    required List<String> stopNames,
    required TransportMode transportMode,
  });
}

/// Mock implementation for testing.
class MockDirectionsService implements DirectionsService {
  DirectionsResult? _mockResult;

  /// Set the mock result to return.
  set mockResult(DirectionsResult? result) => _mockResult = result;

  @override
  Future<DirectionsResult?> getDirections({
    required List<List<double>> coordinates,
    required List<String> stopNames,
    required TransportMode transportMode,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));
    return _mockResult;
  }

  /// Creates a mock directions result for testing.
  static DirectionsResult createMockResult({
    int legCount = 2,
    TransportMode transportMode = TransportMode.walking,
  }) {
    final legs = List.generate(legCount, (i) {
      return DirectionsLeg(
        originName: 'Stop ${i + 1}',
        destinationName: 'Stop ${i + 2}',
        totalDistanceMeters: 500 + (i * 100),
        totalDurationSeconds: 300 + (i * 60),
        steps: [
          DirectionStep(
            instruction: 'Head north on Main St',
            distanceMeters: 200,
            durationSeconds: 120,
            maneuverType: 'depart',
          ),
          DirectionStep(
            instruction: 'Turn right onto Oak Ave',
            distanceMeters: 150,
            durationSeconds: 90,
            maneuverType: 'turn',
            modifier: 'right',
          ),
          DirectionStep(
            instruction: 'Arrive at your destination',
            distanceMeters: 50,
            durationSeconds: 30,
            maneuverType: 'arrive',
          ),
        ],
      );
    });

    return DirectionsResult(
      legs: legs,
      totalDistanceMeters: legs.fold(0, (sum, l) => sum + l.totalDistanceMeters),
      totalDurationSeconds:
          legs.fold(0, (sum, l) => sum + l.totalDurationSeconds),
      transportMode: transportMode,
    );
  }
}
