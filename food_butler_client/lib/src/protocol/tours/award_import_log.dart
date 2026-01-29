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

/// Audit log for award data imports.
abstract class AwardImportLog implements _i1.SerializableModel {
  AwardImportLog._({
    this.id,
    required this.importType,
    required this.fileName,
    required this.recordsImported,
    required this.recordsMatched,
    required this.recordsPendingReview,
    required this.importedByUserId,
    required this.createdAt,
  });

  factory AwardImportLog({
    int? id,
    required _i2.AwardType importType,
    required String fileName,
    required int recordsImported,
    required int recordsMatched,
    required int recordsPendingReview,
    required int importedByUserId,
    required DateTime createdAt,
  }) = _AwardImportLogImpl;

  factory AwardImportLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return AwardImportLog(
      id: jsonSerialization['id'] as int?,
      importType: _i2.AwardType.fromJson(
        (jsonSerialization['importType'] as String),
      ),
      fileName: jsonSerialization['fileName'] as String,
      recordsImported: jsonSerialization['recordsImported'] as int,
      recordsMatched: jsonSerialization['recordsMatched'] as int,
      recordsPendingReview: jsonSerialization['recordsPendingReview'] as int,
      importedByUserId: jsonSerialization['importedByUserId'] as int,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Type of awards imported.
  _i2.AwardType importType;

  /// Name of the uploaded file.
  String fileName;

  /// Number of records imported.
  int recordsImported;

  /// Number of records successfully matched.
  int recordsMatched;

  /// Number of records pending manual review.
  int recordsPendingReview;

  /// User who performed the import.
  int importedByUserId;

  /// When the import was performed.
  DateTime createdAt;

  /// Returns a shallow copy of this [AwardImportLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AwardImportLog copyWith({
    int? id,
    _i2.AwardType? importType,
    String? fileName,
    int? recordsImported,
    int? recordsMatched,
    int? recordsPendingReview,
    int? importedByUserId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AwardImportLog',
      if (id != null) 'id': id,
      'importType': importType.toJson(),
      'fileName': fileName,
      'recordsImported': recordsImported,
      'recordsMatched': recordsMatched,
      'recordsPendingReview': recordsPendingReview,
      'importedByUserId': importedByUserId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AwardImportLogImpl extends AwardImportLog {
  _AwardImportLogImpl({
    int? id,
    required _i2.AwardType importType,
    required String fileName,
    required int recordsImported,
    required int recordsMatched,
    required int recordsPendingReview,
    required int importedByUserId,
    required DateTime createdAt,
  }) : super._(
         id: id,
         importType: importType,
         fileName: fileName,
         recordsImported: recordsImported,
         recordsMatched: recordsMatched,
         recordsPendingReview: recordsPendingReview,
         importedByUserId: importedByUserId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AwardImportLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AwardImportLog copyWith({
    Object? id = _Undefined,
    _i2.AwardType? importType,
    String? fileName,
    int? recordsImported,
    int? recordsMatched,
    int? recordsPendingReview,
    int? importedByUserId,
    DateTime? createdAt,
  }) {
    return AwardImportLog(
      id: id is int? ? id : this.id,
      importType: importType ?? this.importType,
      fileName: fileName ?? this.fileName,
      recordsImported: recordsImported ?? this.recordsImported,
      recordsMatched: recordsMatched ?? this.recordsMatched,
      recordsPendingReview: recordsPendingReview ?? this.recordsPendingReview,
      importedByUserId: importedByUserId ?? this.importedByUserId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
