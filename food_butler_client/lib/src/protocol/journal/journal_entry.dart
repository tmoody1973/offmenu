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

/// A food journal entry capturing a user's restaurant visit experience.
abstract class JournalEntry implements _i1.SerializableModel {
  JournalEntry._({
    this.id,
    required this.userId,
    required this.restaurantId,
    this.tourId,
    this.tourStopId,
    required this.rating,
    this.notes,
    required this.visitedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JournalEntry({
    int? id,
    required String userId,
    required int restaurantId,
    int? tourId,
    int? tourStopId,
    required int rating,
    String? notes,
    required DateTime visitedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _JournalEntryImpl;

  factory JournalEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return JournalEntry(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      restaurantId: jsonSerialization['restaurantId'] as int,
      tourId: jsonSerialization['tourId'] as int?,
      tourStopId: jsonSerialization['tourStopId'] as int?,
      rating: jsonSerialization['rating'] as int,
      notes: jsonSerialization['notes'] as String?,
      visitedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['visitedAt'],
      ),
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

  /// The user who created this entry.
  String userId;

  /// The restaurant associated with this entry.
  int restaurantId;

  /// The tour this entry is associated with (optional).
  int? tourId;

  /// The specific tour stop this entry is associated with (optional).
  int? tourStopId;

  /// Rating from 1-5 stars.
  int rating;

  /// Free-text notes about the visit.
  String? notes;

  /// When the visit occurred (stored as UTC).
  DateTime visitedAt;

  /// When the entry was created.
  DateTime createdAt;

  /// When the entry was last updated.
  DateTime updatedAt;

  /// Returns a shallow copy of this [JournalEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  JournalEntry copyWith({
    int? id,
    String? userId,
    int? restaurantId,
    int? tourId,
    int? tourStopId,
    int? rating,
    String? notes,
    DateTime? visitedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'JournalEntry',
      if (id != null) 'id': id,
      'userId': userId,
      'restaurantId': restaurantId,
      if (tourId != null) 'tourId': tourId,
      if (tourStopId != null) 'tourStopId': tourStopId,
      'rating': rating,
      if (notes != null) 'notes': notes,
      'visitedAt': visitedAt.toJson(),
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

class _JournalEntryImpl extends JournalEntry {
  _JournalEntryImpl({
    int? id,
    required String userId,
    required int restaurantId,
    int? tourId,
    int? tourStopId,
    required int rating,
    String? notes,
    required DateTime visitedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         restaurantId: restaurantId,
         tourId: tourId,
         tourStopId: tourStopId,
         rating: rating,
         notes: notes,
         visitedAt: visitedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [JournalEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  JournalEntry copyWith({
    Object? id = _Undefined,
    String? userId,
    int? restaurantId,
    Object? tourId = _Undefined,
    Object? tourStopId = _Undefined,
    int? rating,
    Object? notes = _Undefined,
    DateTime? visitedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JournalEntry(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      tourId: tourId is int? ? tourId : this.tourId,
      tourStopId: tourStopId is int? ? tourStopId : this.tourStopId,
      rating: rating ?? this.rating,
      notes: notes is String? ? notes : this.notes,
      visitedAt: visitedAt ?? this.visitedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
