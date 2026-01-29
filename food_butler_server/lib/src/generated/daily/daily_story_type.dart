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

/// Type of daily story to generate.
/// Determines the narrative style and focus.
enum DailyStoryType implements _i1.SerializableModel {
  /// "The spot locals won't tell you about"
  hiddenGem,

  /// "22 years in a strip mall" - history/founder stories
  legacyStory,

  /// "Why this city's pho is different"
  cuisineDeepDive,

  /// "The chef who trained under..."
  chefSpotlight,

  /// "The block that's quietly becoming..."
  neighborhoodGuide,

  /// "What to eat right now"
  seasonalFeature;

  static DailyStoryType fromJson(String name) {
    switch (name) {
      case 'hiddenGem':
        return DailyStoryType.hiddenGem;
      case 'legacyStory':
        return DailyStoryType.legacyStory;
      case 'cuisineDeepDive':
        return DailyStoryType.cuisineDeepDive;
      case 'chefSpotlight':
        return DailyStoryType.chefSpotlight;
      case 'neighborhoodGuide':
        return DailyStoryType.neighborhoodGuide;
      case 'seasonalFeature':
        return DailyStoryType.seasonalFeature;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "DailyStoryType"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
