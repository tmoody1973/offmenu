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

/// Categories for curated restaurant maps.
enum MapCategory implements _i1.SerializableModel {
  /// "The 38 Best Restaurants in [City] 2026" style lists
  bestOf,

  /// Cuisine-specific maps ("Best Tacos", "Best Sushi")
  cuisine,

  /// Occasion-based maps ("Date Night", "Business Lunch")
  occasion,

  /// Neighborhood guides ("Best of Williamsburg")
  neighborhood,

  /// Hidden gems and underrated spots
  hiddenGems,

  /// New openings and trending spots
  newAndTrending,

  /// Budget-friendly options
  budget,

  /// Late night eats
  lateNight;

  static MapCategory fromJson(String name) {
    switch (name) {
      case 'bestOf':
        return MapCategory.bestOf;
      case 'cuisine':
        return MapCategory.cuisine;
      case 'occasion':
        return MapCategory.occasion;
      case 'neighborhood':
        return MapCategory.neighborhood;
      case 'hiddenGems':
        return MapCategory.hiddenGems;
      case 'newAndTrending':
        return MapCategory.newAndTrending;
      case 'budget':
        return MapCategory.budget;
      case 'lateNight':
        return MapCategory.lateNight;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "MapCategory"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
