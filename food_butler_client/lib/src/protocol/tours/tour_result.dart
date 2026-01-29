/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Generated tour result with all metadata.
abstract class TourResult implements _i1.SerializableModel {
  TourResult._({
    this.id,
    required this.requestId,
    required this.stopsJson,
    required this.confidenceScore,
    required this.routePolyline,
    required this.routeLegsJson,
    required this.totalDistanceMeters,
    required this.totalDurationSeconds,
    required this.isPartialTour,
    this.warningMessage,
    this.tourTitle,
    this.tourIntroduction,
    this.tourVibe,
    this.tourClosing,
    this.curatedTourJson,
    required this.createdAt,
  });

  factory TourResult({
    int? id,
    required int requestId,
    required String stopsJson,
    required int confidenceScore,
    required String routePolyline,
    required String routeLegsJson,
    required int totalDistanceMeters,
    required int totalDurationSeconds,
    required bool isPartialTour,
    String? warningMessage,
    String? tourTitle,
    String? tourIntroduction,
    String? tourVibe,
    String? tourClosing,
    String? curatedTourJson,
    required DateTime createdAt,
  }) = _TourResultImpl;

  factory TourResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return TourResult(
      id: jsonSerialization['id'] as int?,
      requestId: jsonSerialization['requestId'] as int,
      stopsJson: jsonSerialization['stopsJson'] as String,
      confidenceScore: jsonSerialization['confidenceScore'] as int,
      routePolyline: jsonSerialization['routePolyline'] as String,
      routeLegsJson: jsonSerialization['routeLegsJson'] as String,
      totalDistanceMeters: jsonSerialization['totalDistanceMeters'] as int,
      totalDurationSeconds: jsonSerialization['totalDurationSeconds'] as int,
      isPartialTour: jsonSerialization['isPartialTour'] as bool,
      warningMessage: jsonSerialization['warningMessage'] as String?,
      tourTitle: jsonSerialization['tourTitle'] as String?,
      tourIntroduction: jsonSerialization['tourIntroduction'] as String?,
      tourVibe: jsonSerialization['tourVibe'] as String?,
      tourClosing: jsonSerialization['tourClosing'] as String?,
      curatedTourJson: jsonSerialization['curatedTourJson'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Reference to the original request.
  int requestId;

  /// Ordered array of tour stops as JSON.
  String stopsJson;

  /// Tour confidence score (0-100).
  int confidenceScore;

  /// Encoded route polyline for map rendering.
  String routePolyline;

  /// Per-leg route summaries as JSON.
  String routeLegsJson;

  /// Total tour distance in meters.
  int totalDistanceMeters;

  /// Total tour duration in seconds.
  int totalDurationSeconds;

  /// Whether this is a partial tour (fewer stops than requested).
  bool isPartialTour;

  /// Warning message when partial tour or other issues.
  String? warningMessage;

  /// Creative title/theme for the tour (from AI curation).
  String? tourTitle;

  /// Opening narrative that sets the stage for the journey.
  String? tourIntroduction;

  /// The overall vibe/mood of the tour.
  String? tourVibe;

  /// Closing narrative wrapping up the experience.
  String? tourClosing;

  /// Full curated tour JSON from Perplexity (contains stories, dish details, tips).
  String? curatedTourJson;

  /// When the result was created.
  DateTime createdAt;

  /// Returns a shallow copy of this [TourResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TourResult copyWith({
    int? id,
    int? requestId,
    String? stopsJson,
    int? confidenceScore,
    String? routePolyline,
    String? routeLegsJson,
    int? totalDistanceMeters,
    int? totalDurationSeconds,
    bool? isPartialTour,
    String? warningMessage,
    String? tourTitle,
    String? tourIntroduction,
    String? tourVibe,
    String? tourClosing,
    String? curatedTourJson,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TourResult',
      if (id != null) 'id': id,
      'requestId': requestId,
      'stopsJson': stopsJson,
      'confidenceScore': confidenceScore,
      'routePolyline': routePolyline,
      'routeLegsJson': routeLegsJson,
      'totalDistanceMeters': totalDistanceMeters,
      'totalDurationSeconds': totalDurationSeconds,
      'isPartialTour': isPartialTour,
      if (warningMessage != null) 'warningMessage': warningMessage,
      if (tourTitle != null) 'tourTitle': tourTitle,
      if (tourIntroduction != null) 'tourIntroduction': tourIntroduction,
      if (tourVibe != null) 'tourVibe': tourVibe,
      if (tourClosing != null) 'tourClosing': tourClosing,
      if (curatedTourJson != null) 'curatedTourJson': curatedTourJson,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TourResultImpl extends TourResult {
  _TourResultImpl({
    int? id,
    required int requestId,
    required String stopsJson,
    required int confidenceScore,
    required String routePolyline,
    required String routeLegsJson,
    required int totalDistanceMeters,
    required int totalDurationSeconds,
    required bool isPartialTour,
    String? warningMessage,
    String? tourTitle,
    String? tourIntroduction,
    String? tourVibe,
    String? tourClosing,
    String? curatedTourJson,
    required DateTime createdAt,
  }) : super._(
         id: id,
         requestId: requestId,
         stopsJson: stopsJson,
         confidenceScore: confidenceScore,
         routePolyline: routePolyline,
         routeLegsJson: routeLegsJson,
         totalDistanceMeters: totalDistanceMeters,
         totalDurationSeconds: totalDurationSeconds,
         isPartialTour: isPartialTour,
         warningMessage: warningMessage,
         tourTitle: tourTitle,
         tourIntroduction: tourIntroduction,
         tourVibe: tourVibe,
         tourClosing: tourClosing,
         curatedTourJson: curatedTourJson,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [TourResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TourResult copyWith({
    Object? id = _Undefined,
    int? requestId,
    String? stopsJson,
    int? confidenceScore,
    String? routePolyline,
    String? routeLegsJson,
    int? totalDistanceMeters,
    int? totalDurationSeconds,
    bool? isPartialTour,
    Object? warningMessage = _Undefined,
    Object? tourTitle = _Undefined,
    Object? tourIntroduction = _Undefined,
    Object? tourVibe = _Undefined,
    Object? tourClosing = _Undefined,
    Object? curatedTourJson = _Undefined,
    DateTime? createdAt,
  }) {
    return TourResult(
      id: id is int? ? id : this.id,
      requestId: requestId ?? this.requestId,
      stopsJson: stopsJson ?? this.stopsJson,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      routePolyline: routePolyline ?? this.routePolyline,
      routeLegsJson: routeLegsJson ?? this.routeLegsJson,
      totalDistanceMeters: totalDistanceMeters ?? this.totalDistanceMeters,
      totalDurationSeconds: totalDurationSeconds ?? this.totalDurationSeconds,
      isPartialTour: isPartialTour ?? this.isPartialTour,
      warningMessage: warningMessage is String?
          ? warningMessage
          : this.warningMessage,
      tourTitle: tourTitle is String? ? tourTitle : this.tourTitle,
      tourIntroduction: tourIntroduction is String?
          ? tourIntroduction
          : this.tourIntroduction,
      tourVibe: tourVibe is String? ? tourVibe : this.tourVibe,
      tourClosing: tourClosing is String? ? tourClosing : this.tourClosing,
      curatedTourJson: curatedTourJson is String?
          ? curatedTourJson
          : this.curatedTourJson,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
