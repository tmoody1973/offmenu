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

/// Culinary award record for James Beard and Michelin designations.
abstract class Award implements _i1.SerializableModel {
  Award._({
    this.id,
    required this.restaurantFsqId,
    required this.awardType,
    required this.awardLevel,
    required this.year,
    required this.createdAt,
  });

  factory Award({
    int? id,
    required String restaurantFsqId,
    required _i2.AwardType awardType,
    required String awardLevel,
    required int year,
    required DateTime createdAt,
  }) = _AwardImpl;

  factory Award.fromJson(Map<String, dynamic> jsonSerialization) {
    return Award(
      id: jsonSerialization['id'] as int?,
      restaurantFsqId: jsonSerialization['restaurantFsqId'] as String,
      awardType: _i2.AwardType.fromJson(
        (jsonSerialization['awardType'] as String),
      ),
      awardLevel: jsonSerialization['awardLevel'] as String,
      year: jsonSerialization['year'] as int,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Reference to the restaurant's Foursquare ID.
  String restaurantFsqId;

  /// Type of award (James Beard or Michelin).
  _i2.AwardType awardType;

  /// Award level (winner, nominee, semifinalist, oneStar, twoStar, threeStar, bibGourmand).
  String awardLevel;

  /// Year the award was given.
  int year;

  /// When the record was created.
  DateTime createdAt;

  /// Returns a shallow copy of this [Award]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Award copyWith({
    int? id,
    String? restaurantFsqId,
    _i2.AwardType? awardType,
    String? awardLevel,
    int? year,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Award',
      if (id != null) 'id': id,
      'restaurantFsqId': restaurantFsqId,
      'awardType': awardType.toJson(),
      'awardLevel': awardLevel,
      'year': year,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AwardImpl extends Award {
  _AwardImpl({
    int? id,
    required String restaurantFsqId,
    required _i2.AwardType awardType,
    required String awardLevel,
    required int year,
    required DateTime createdAt,
  }) : super._(
         id: id,
         restaurantFsqId: restaurantFsqId,
         awardType: awardType,
         awardLevel: awardLevel,
         year: year,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Award]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Award copyWith({
    Object? id = _Undefined,
    String? restaurantFsqId,
    _i2.AwardType? awardType,
    String? awardLevel,
    int? year,
    DateTime? createdAt,
  }) {
    return Award(
      id: id is int? ? id : this.id,
      restaurantFsqId: restaurantFsqId ?? this.restaurantFsqId,
      awardType: awardType ?? this.awardType,
      awardLevel: awardLevel ?? this.awardLevel,
      year: year ?? this.year,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
