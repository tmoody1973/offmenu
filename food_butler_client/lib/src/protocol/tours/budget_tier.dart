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

/// Budget tier for restaurant filtering.
enum BudgetTier implements _i1.SerializableModel {
  budget,
  moderate,
  upscale,
  luxury;

  static BudgetTier fromJson(String name) {
    switch (name) {
      case 'budget':
        return BudgetTier.budget;
      case 'moderate':
        return BudgetTier.moderate;
      case 'upscale':
        return BudgetTier.upscale;
      case 'luxury':
        return BudgetTier.luxury;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "BudgetTier"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
