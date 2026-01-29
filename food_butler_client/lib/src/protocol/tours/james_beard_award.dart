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
import '../tours/james_beard_distinction.dart' as _i2;

/// James Beard Foundation award record.
abstract class JamesBeardAward implements _i1.SerializableModel {
  JamesBeardAward._({
    this.id,
    required this.name,
    required this.city,
    required this.category,
    required this.distinctionLevel,
    required this.awardYear,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JamesBeardAward({
    int? id,
    required String name,
    required String city,
    required String category,
    required _i2.JamesBeardDistinction distinctionLevel,
    required int awardYear,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _JamesBeardAwardImpl;

  factory JamesBeardAward.fromJson(Map<String, dynamic> jsonSerialization) {
    return JamesBeardAward(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      city: jsonSerialization['city'] as String,
      category: jsonSerialization['category'] as String,
      distinctionLevel: _i2.JamesBeardDistinction.fromJson(
        (jsonSerialization['distinctionLevel'] as String),
      ),
      awardYear: jsonSerialization['awardYear'] as int,
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

  /// Name of the chef or restaurant.
  String name;

  /// City where the chef/restaurant is located.
  String city;

  /// Award category (e.g., "Best Chef: Great Lakes", "Outstanding Restaurant").
  String category;

  /// Distinction level of the award.
  _i2.JamesBeardDistinction distinctionLevel;

  /// Year the award was given.
  int awardYear;

  /// When the record was created.
  DateTime createdAt;

  /// When the record was last updated.
  DateTime updatedAt;

  /// Returns a shallow copy of this [JamesBeardAward]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  JamesBeardAward copyWith({
    int? id,
    String? name,
    String? city,
    String? category,
    _i2.JamesBeardDistinction? distinctionLevel,
    int? awardYear,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'JamesBeardAward',
      if (id != null) 'id': id,
      'name': name,
      'city': city,
      'category': category,
      'distinctionLevel': distinctionLevel.toJson(),
      'awardYear': awardYear,
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

class _JamesBeardAwardImpl extends JamesBeardAward {
  _JamesBeardAwardImpl({
    int? id,
    required String name,
    required String city,
    required String category,
    required _i2.JamesBeardDistinction distinctionLevel,
    required int awardYear,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         name: name,
         city: city,
         category: category,
         distinctionLevel: distinctionLevel,
         awardYear: awardYear,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [JamesBeardAward]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  JamesBeardAward copyWith({
    Object? id = _Undefined,
    String? name,
    String? city,
    String? category,
    _i2.JamesBeardDistinction? distinctionLevel,
    int? awardYear,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JamesBeardAward(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      category: category ?? this.category,
      distinctionLevel: distinctionLevel ?? this.distinctionLevel,
      awardYear: awardYear ?? this.awardYear,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
