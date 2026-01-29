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
import '../awards/import_preview_item.dart' as _i2;
import 'package:food_butler_server/src/generated/protocol.dart' as _i3;

/// Result of previewing an award import.
abstract class ImportPreviewResult
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ImportPreviewResult._({
    required this.totalRecords,
    required this.items,
  });

  factory ImportPreviewResult({
    required int totalRecords,
    required List<_i2.ImportPreviewItem> items,
  }) = _ImportPreviewResultImpl;

  factory ImportPreviewResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return ImportPreviewResult(
      totalRecords: jsonSerialization['totalRecords'] as int,
      items: _i3.Protocol().deserialize<List<_i2.ImportPreviewItem>>(
        jsonSerialization['items'],
      ),
    );
  }

  /// Total number of records in the file.
  int totalRecords;

  /// Preview items.
  List<_i2.ImportPreviewItem> items;

  /// Returns a shallow copy of this [ImportPreviewResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ImportPreviewResult copyWith({
    int? totalRecords,
    List<_i2.ImportPreviewItem>? items,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ImportPreviewResult',
      'totalRecords': totalRecords,
      'items': items.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ImportPreviewResult',
      'totalRecords': totalRecords,
      'items': items.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ImportPreviewResultImpl extends ImportPreviewResult {
  _ImportPreviewResultImpl({
    required int totalRecords,
    required List<_i2.ImportPreviewItem> items,
  }) : super._(
         totalRecords: totalRecords,
         items: items,
       );

  /// Returns a shallow copy of this [ImportPreviewResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ImportPreviewResult copyWith({
    int? totalRecords,
    List<_i2.ImportPreviewItem>? items,
  }) {
    return ImportPreviewResult(
      totalRecords: totalRecords ?? this.totalRecords,
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
    );
  }
}
