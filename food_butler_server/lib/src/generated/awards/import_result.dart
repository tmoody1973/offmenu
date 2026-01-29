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
import 'package:serverpod/serverpod.dart' as _i1;

/// Result of an award import operation.
abstract class ImportResult
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ImportResult._({
    required this.recordsImported,
    required this.recordsMatched,
    required this.recordsPendingReview,
  });

  factory ImportResult({
    required int recordsImported,
    required int recordsMatched,
    required int recordsPendingReview,
  }) = _ImportResultImpl;

  factory ImportResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return ImportResult(
      recordsImported: jsonSerialization['recordsImported'] as int,
      recordsMatched: jsonSerialization['recordsMatched'] as int,
      recordsPendingReview: jsonSerialization['recordsPendingReview'] as int,
    );
  }

  /// Number of records successfully imported.
  int recordsImported;

  /// Number of records matched to restaurants.
  int recordsMatched;

  /// Number of records pending manual review.
  int recordsPendingReview;

  /// Returns a shallow copy of this [ImportResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ImportResult copyWith({
    int? recordsImported,
    int? recordsMatched,
    int? recordsPendingReview,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ImportResult',
      'recordsImported': recordsImported,
      'recordsMatched': recordsMatched,
      'recordsPendingReview': recordsPendingReview,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ImportResult',
      'recordsImported': recordsImported,
      'recordsMatched': recordsMatched,
      'recordsPendingReview': recordsPendingReview,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ImportResultImpl extends ImportResult {
  _ImportResultImpl({
    required int recordsImported,
    required int recordsMatched,
    required int recordsPendingReview,
  }) : super._(
         recordsImported: recordsImported,
         recordsMatched: recordsMatched,
         recordsPendingReview: recordsPendingReview,
       );

  /// Returns a shallow copy of this [ImportResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ImportResult copyWith({
    int? recordsImported,
    int? recordsMatched,
    int? recordsPendingReview,
  }) {
    return ImportResult(
      recordsImported: recordsImported ?? this.recordsImported,
      recordsMatched: recordsMatched ?? this.recordsMatched,
      recordsPendingReview: recordsPendingReview ?? this.recordsPendingReview,
    );
  }
}
