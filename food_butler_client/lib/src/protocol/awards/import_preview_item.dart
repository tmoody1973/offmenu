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

/// Single item in import preview.
abstract class ImportPreviewItem implements _i1.SerializableModel {
  ImportPreviewItem._({
    required this.recordName,
    required this.recordCity,
    required this.recordYear,
    this.matchedRestaurantName,
    this.confidence,
    required this.status,
  });

  factory ImportPreviewItem({
    required String recordName,
    required String recordCity,
    required int recordYear,
    String? matchedRestaurantName,
    double? confidence,
    required String status,
  }) = _ImportPreviewItemImpl;

  factory ImportPreviewItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return ImportPreviewItem(
      recordName: jsonSerialization['recordName'] as String,
      recordCity: jsonSerialization['recordCity'] as String,
      recordYear: jsonSerialization['recordYear'] as int,
      matchedRestaurantName:
          jsonSerialization['matchedRestaurantName'] as String?,
      confidence: (jsonSerialization['confidence'] as num?)?.toDouble(),
      status: jsonSerialization['status'] as String,
    );
  }

  /// Name from the record.
  String recordName;

  /// City from the record.
  String recordCity;

  /// Year from the record.
  int recordYear;

  /// Matched restaurant name if found.
  String? matchedRestaurantName;

  /// Match confidence score.
  double? confidence;

  /// Match status (auto_match, pending_review, no_match).
  String status;

  /// Returns a shallow copy of this [ImportPreviewItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ImportPreviewItem copyWith({
    String? recordName,
    String? recordCity,
    int? recordYear,
    String? matchedRestaurantName,
    double? confidence,
    String? status,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ImportPreviewItem',
      'recordName': recordName,
      'recordCity': recordCity,
      'recordYear': recordYear,
      if (matchedRestaurantName != null)
        'matchedRestaurantName': matchedRestaurantName,
      if (confidence != null) 'confidence': confidence,
      'status': status,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ImportPreviewItemImpl extends ImportPreviewItem {
  _ImportPreviewItemImpl({
    required String recordName,
    required String recordCity,
    required int recordYear,
    String? matchedRestaurantName,
    double? confidence,
    required String status,
  }) : super._(
         recordName: recordName,
         recordCity: recordCity,
         recordYear: recordYear,
         matchedRestaurantName: matchedRestaurantName,
         confidence: confidence,
         status: status,
       );

  /// Returns a shallow copy of this [ImportPreviewItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ImportPreviewItem copyWith({
    String? recordName,
    String? recordCity,
    int? recordYear,
    Object? matchedRestaurantName = _Undefined,
    Object? confidence = _Undefined,
    String? status,
  }) {
    return ImportPreviewItem(
      recordName: recordName ?? this.recordName,
      recordCity: recordCity ?? this.recordCity,
      recordYear: recordYear ?? this.recordYear,
      matchedRestaurantName: matchedRestaurantName is String?
          ? matchedRestaurantName
          : this.matchedRestaurantName,
      confidence: confidence is double? ? confidence : this.confidence,
      status: status ?? this.status,
    );
  }
}
