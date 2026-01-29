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
import '../tours/award_type.dart' as _i2;
import '../tours/match_status.dart' as _i3;

/// Junction table linking restaurants to their awards.
abstract class RestaurantAwardLink implements _i1.SerializableModel {
  RestaurantAwardLink._({
    this.id,
    required this.restaurantId,
    required this.awardType,
    required this.awardId,
    required this.matchConfidenceScore,
    required this.matchStatus,
    this.matchedByUserId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RestaurantAwardLink({
    int? id,
    required int restaurantId,
    required _i2.AwardType awardType,
    required int awardId,
    required double matchConfidenceScore,
    required _i3.MatchStatus matchStatus,
    int? matchedByUserId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RestaurantAwardLinkImpl;

  factory RestaurantAwardLink.fromJson(Map<String, dynamic> jsonSerialization) {
    return RestaurantAwardLink(
      id: jsonSerialization['id'] as int?,
      restaurantId: jsonSerialization['restaurantId'] as int,
      awardType: _i2.AwardType.fromJson(
        (jsonSerialization['awardType'] as String),
      ),
      awardId: jsonSerialization['awardId'] as int,
      matchConfidenceScore: (jsonSerialization['matchConfidenceScore'] as num)
          .toDouble(),
      matchStatus: _i3.MatchStatus.fromJson(
        (jsonSerialization['matchStatus'] as String),
      ),
      matchedByUserId: jsonSerialization['matchedByUserId'] as int?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Reference to the restaurant.
  int restaurantId;

  /// Type of award (michelin or james_beard).
  _i2.AwardType awardType;

  /// Reference to the award record ID.
  int awardId;

  /// Confidence score of the match (0.0 to 1.0).
  double matchConfidenceScore;

  /// Status of the match.
  _i3.MatchStatus matchStatus;

  /// User who confirmed/rejected the match (null for auto matches).
  int? matchedByUserId;

  /// When the record was created.
  DateTime createdAt;

  /// When the record was last updated.
  DateTime updatedAt;

  /// Returns a shallow copy of this [RestaurantAwardLink]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RestaurantAwardLink copyWith({
    int? id,
    int? restaurantId,
    _i2.AwardType? awardType,
    int? awardId,
    double? matchConfidenceScore,
    _i3.MatchStatus? matchStatus,
    int? matchedByUserId,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RestaurantAwardLink',
      if (id != null) 'id': id,
      'restaurantId': restaurantId,
      'awardType': awardType.toJson(),
      'awardId': awardId,
      'matchConfidenceScore': matchConfidenceScore,
      'matchStatus': matchStatus.toJson(),
      if (matchedByUserId != null) 'matchedByUserId': matchedByUserId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RestaurantAwardLinkImpl extends RestaurantAwardLink {
  _RestaurantAwardLinkImpl({
    int? id,
    required int restaurantId,
    required _i2.AwardType awardType,
    required int awardId,
    required double matchConfidenceScore,
    required _i3.MatchStatus matchStatus,
    int? matchedByUserId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         restaurantId: restaurantId,
         awardType: awardType,
         awardId: awardId,
         matchConfidenceScore: matchConfidenceScore,
         matchStatus: matchStatus,
         matchedByUserId: matchedByUserId,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [RestaurantAwardLink]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RestaurantAwardLink copyWith({
    Object? id = _Undefined,
    int? restaurantId,
    _i2.AwardType? awardType,
    int? awardId,
    double? matchConfidenceScore,
    _i3.MatchStatus? matchStatus,
    Object? matchedByUserId = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RestaurantAwardLink(
      id: id is int? ? id : this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      awardType: awardType ?? this.awardType,
      awardId: awardId ?? this.awardId,
      matchConfidenceScore: matchConfidenceScore ?? this.matchConfidenceScore,
      matchStatus: matchStatus ?? this.matchStatus,
      matchedByUserId: matchedByUserId is int?
          ? matchedByUserId
          : this.matchedByUserId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
