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

/// User's adventure/exploration style when discovering food.
/// Used to calibrate the Serendipity Engine recommendations.
enum AdventureLevel implements _i1.SerializableModel {
  /// Seeks out local hidden gems, avoids tourist spots
  localExplorer,

  /// Visits landmarks first, then explores
  landmarkFirst,

  /// Lets serendipity guide them
  serendipitous,

  /// Researches obsessively before visiting
  researcher;

  static AdventureLevel fromJson(String name) {
    switch (name) {
      case 'localExplorer':
        return AdventureLevel.localExplorer;
      case 'landmarkFirst':
        return AdventureLevel.landmarkFirst;
      case 'serendipitous':
        return AdventureLevel.serendipitous;
      case 'researcher':
        return AdventureLevel.researcher;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "AdventureLevel"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
