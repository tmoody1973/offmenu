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

/// Empty data model for FutureCalls that don't need parameters.
abstract class EmptyData implements _i1.SerializableModel {
  EmptyData._();

  factory EmptyData() = _EmptyDataImpl;

  factory EmptyData.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmptyData();
  }

  /// Returns a shallow copy of this [EmptyData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmptyData copyWith();
  @override
  Map<String, dynamic> toJson() {
    return {'__className__': 'EmptyData'};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _EmptyDataImpl extends EmptyData {
  _EmptyDataImpl() : super._();

  /// Returns a shallow copy of this [EmptyData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmptyData copyWith() {
    return EmptyData();
  }
}
