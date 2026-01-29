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
import '../analytics/reservation_link_type.dart' as _i2;

/// Analytics event for tracking reservation link clicks.
abstract class ReservationClickEvent implements _i1.SerializableModel {
  ReservationClickEvent._({
    this.id,
    required this.restaurantId,
    required this.linkType,
    this.userId,
    required this.launchSuccess,
    required this.timestamp,
    required this.createdAt,
  });

  factory ReservationClickEvent({
    int? id,
    required int restaurantId,
    required _i2.ReservationLinkType linkType,
    String? userId,
    required bool launchSuccess,
    required DateTime timestamp,
    required DateTime createdAt,
  }) = _ReservationClickEventImpl;

  factory ReservationClickEvent.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ReservationClickEvent(
      id: jsonSerialization['id'] as int?,
      restaurantId: jsonSerialization['restaurantId'] as int,
      linkType: _i2.ReservationLinkType.fromJson(
        (jsonSerialization['linkType'] as String),
      ),
      userId: jsonSerialization['userId'] as String?,
      launchSuccess: jsonSerialization['launchSuccess'] as bool,
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Restaurant ID (foreign key to restaurants table).
  int restaurantId;

  /// Type of link clicked.
  _i2.ReservationLinkType linkType;

  /// User ID if authenticated (nullable).
  String? userId;

  /// Whether the URL launch was successful.
  bool launchSuccess;

  /// When the click occurred.
  DateTime timestamp;

  /// When the record was created.
  DateTime createdAt;

  /// Returns a shallow copy of this [ReservationClickEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ReservationClickEvent copyWith({
    int? id,
    int? restaurantId,
    _i2.ReservationLinkType? linkType,
    String? userId,
    bool? launchSuccess,
    DateTime? timestamp,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReservationClickEvent',
      if (id != null) 'id': id,
      'restaurantId': restaurantId,
      'linkType': linkType.toJson(),
      if (userId != null) 'userId': userId,
      'launchSuccess': launchSuccess,
      'timestamp': timestamp.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReservationClickEventImpl extends ReservationClickEvent {
  _ReservationClickEventImpl({
    int? id,
    required int restaurantId,
    required _i2.ReservationLinkType linkType,
    String? userId,
    required bool launchSuccess,
    required DateTime timestamp,
    required DateTime createdAt,
  }) : super._(
         id: id,
         restaurantId: restaurantId,
         linkType: linkType,
         userId: userId,
         launchSuccess: launchSuccess,
         timestamp: timestamp,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ReservationClickEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ReservationClickEvent copyWith({
    Object? id = _Undefined,
    int? restaurantId,
    _i2.ReservationLinkType? linkType,
    Object? userId = _Undefined,
    bool? launchSuccess,
    DateTime? timestamp,
    DateTime? createdAt,
  }) {
    return ReservationClickEvent(
      id: id is int? ? id : this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      linkType: linkType ?? this.linkType,
      userId: userId is String? ? userId : this.userId,
      launchSuccess: launchSuccess ?? this.launchSuccess,
      timestamp: timestamp ?? this.timestamp,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
