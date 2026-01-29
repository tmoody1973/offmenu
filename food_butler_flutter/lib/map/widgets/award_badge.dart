import 'package:flutter/material.dart';

/// Award type for badge display.
enum AwardBadgeType {
  /// James Beard award (blue styling)
  jamesBeard,

  /// Michelin star (gold/red styling)
  michelin,
}

/// Badge size variants for different display contexts.
enum AwardBadgeSize {
  /// Compact: icon-only, 16-20px for map popups
  compact,

  /// Standard: icon + abbreviated text, 24-28px for restaurant cards
  standard,

  /// Expanded: full icon + text + year, 32-40px for detail pages
  expanded,
}

/// Michelin designation types.
enum MichelinDesignation {
  oneStar,
  twoStar,
  threeStar,
  bibGourmand,
}

/// James Beard distinction levels.
enum JamesBeardDistinction {
  winner,
  nominee,
  semifinalist,
}

/// A compact award badge for displaying in map popups and cards.
///
/// Features:
/// - James Beard: blue styling
/// - Michelin: gold/red styling
/// - Three size variants: compact, standard, expanded
/// - WCAG AA compliant color contrast
/// - Full accessibility support with ARIA labels
class AwardBadge extends StatelessWidget {
  /// The type of award.
  final AwardBadgeType type;

  /// The award level/detail (e.g., "Winner", "1 Star", "Bib Gourmand").
  final String label;

  /// The year the award was given.
  final int? year;

  /// The size variant of the badge.
  final AwardBadgeSize size;

  /// Optional callback for tap interactions.
  final VoidCallback? onTap;

  const AwardBadge({
    super.key,
    required this.type,
    required this.label,
    this.year,
    this.size = AwardBadgeSize.standard,
    this.onTap,
  });

  /// Creates an AwardBadge from an award string.
  /// Parses strings like "michelin_one_star", "james_beard_winner", etc.
  factory AwardBadge.fromString(String awardString, {int? year, AwardBadgeSize size = AwardBadgeSize.standard}) {
    final normalized = awardString.toLowerCase();

    if (normalized.contains('michelin')) {
      String label = 'Michelin';
      if (normalized.contains('three') || normalized.contains('3')) {
        label = '3 Stars';
      } else if (normalized.contains('two') || normalized.contains('2')) {
        label = '2 Stars';
      } else if (normalized.contains('one') || normalized.contains('1')) {
        label = '1 Star';
      } else if (normalized.contains('bib')) {
        label = 'Bib Gourmand';
      }
      return AwardBadge(type: AwardBadgeType.michelin, label: label, year: year, size: size);
    }

    if (normalized.contains('james') || normalized.contains('beard')) {
      String label = 'James Beard';
      if (normalized.contains('winner')) {
        label = 'Winner';
      } else if (normalized.contains('nominee')) {
        label = 'Nominee';
      } else if (normalized.contains('semifinalist')) {
        label = 'Semifinalist';
      }
      return AwardBadge(type: AwardBadgeType.jamesBeard, label: label, year: year, size: size);
    }

    // Default to James Beard if unrecognized
    return AwardBadge(type: AwardBadgeType.jamesBeard, label: awardString, year: year, size: size);
  }

  /// Creates a Michelin badge with the given designation.
  factory AwardBadge.michelin({
    required MichelinDesignation designation,
    int? year,
    AwardBadgeSize size = AwardBadgeSize.standard,
    VoidCallback? onTap,
  }) {
    String label;
    switch (designation) {
      case MichelinDesignation.threeStar:
        label = '3 Stars';
        break;
      case MichelinDesignation.twoStar:
        label = '2 Stars';
        break;
      case MichelinDesignation.oneStar:
        label = '1 Star';
        break;
      case MichelinDesignation.bibGourmand:
        label = 'Bib Gourmand';
        break;
    }
    return AwardBadge(
      type: AwardBadgeType.michelin,
      label: label,
      year: year,
      size: size,
      onTap: onTap,
    );
  }

  /// Creates a James Beard badge with the given distinction.
  factory AwardBadge.jamesBeard({
    required JamesBeardDistinction distinction,
    String? category,
    int? year,
    AwardBadgeSize size = AwardBadgeSize.standard,
    VoidCallback? onTap,
  }) {
    String label;
    switch (distinction) {
      case JamesBeardDistinction.winner:
        label = category != null ? '$category Winner' : 'Winner';
        break;
      case JamesBeardDistinction.nominee:
        label = category != null ? '$category Nominee' : 'Nominee';
        break;
      case JamesBeardDistinction.semifinalist:
        label = category != null ? '$category Semifinalist' : 'Semifinalist';
        break;
    }
    return AwardBadge(
      type: AwardBadgeType.jamesBeard,
      label: label,
      year: year,
      size: size,
      onTap: onTap,
    );
  }

  /// Get the full semantic label for accessibility.
  String get semanticLabel {
    final typeLabel = type == AwardBadgeType.michelin ? 'Michelin' : 'James Beard';
    if (year != null) {
      return '$typeLabel $label $year';
    }
    return '$typeLabel $label';
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();
    final dimensions = _getDimensions();

    Widget badge;
    switch (size) {
      case AwardBadgeSize.compact:
        badge = _buildCompactBadge(colors, dimensions);
        break;
      case AwardBadgeSize.standard:
        badge = _buildStandardBadge(colors, dimensions);
        break;
      case AwardBadgeSize.expanded:
        badge = _buildExpandedBadge(colors, dimensions);
        break;
    }

    // Wrap with Semantics for accessibility
    badge = Semantics(
      label: semanticLabel,
      button: onTap != null,
      child: badge,
    );

    // Wrap with InkWell if tappable
    if (onTap != null) {
      badge = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
        child: badge,
      );
    }

    return badge;
  }

  Widget _buildCompactBadge(_BadgeColors colors, _BadgeDimensions dimensions) {
    return Container(
      width: dimensions.height,
      height: dimensions.height,
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: colors.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: _buildIcon(colors, dimensions.iconSize),
      ),
    );
  }

  Widget _buildStandardBadge(_BadgeColors colors, _BadgeDimensions dimensions) {
    return Container(
      height: dimensions.height,
      padding: EdgeInsets.symmetric(
        horizontal: dimensions.horizontalPadding,
        vertical: dimensions.verticalPadding,
      ),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
        border: Border.all(color: colors.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIcon(colors, dimensions.iconSize),
          SizedBox(width: dimensions.spacing),
          Text(
            _getAbbreviatedLabel(),
            style: TextStyle(
              fontSize: dimensions.fontSize,
              fontWeight: FontWeight.w500,
              color: colors.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedBadge(_BadgeColors colors, _BadgeDimensions dimensions) {
    return Container(
      height: dimensions.height,
      padding: EdgeInsets.symmetric(
        horizontal: dimensions.horizontalPadding,
        vertical: dimensions.verticalPadding,
      ),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
        border: Border.all(color: colors.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIcon(colors, dimensions.iconSize),
          SizedBox(width: dimensions.spacing),
          Text(
            label,
            style: TextStyle(
              fontSize: dimensions.fontSize,
              fontWeight: FontWeight.w500,
              color: colors.textColor,
            ),
          ),
          if (year != null) ...[
            SizedBox(width: dimensions.spacing),
            Text(
              year.toString(),
              style: TextStyle(
                fontSize: dimensions.fontSize - 2,
                fontWeight: FontWeight.w400,
                color: colors.textColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIcon(_BadgeColors colors, double size) {
    // Use custom icons based on award type and level
    if (type == AwardBadgeType.michelin) {
      if (label.contains('Bib')) {
        // Bib Gourmand uses restaurant utensils icon
        return Icon(
          Icons.restaurant,
          size: size,
          color: colors.iconColor,
        );
      }
      // Michelin stars
      final starCount = _getStarCount();
      if (starCount == 1) {
        return Icon(Icons.star_rounded, size: size, color: colors.iconColor);
      } else if (starCount == 2) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_rounded, size: size * 0.6, color: colors.iconColor),
            Icon(Icons.star_rounded, size: size * 0.6, color: colors.iconColor),
          ],
        );
      } else if (starCount == 3) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_rounded, size: size * 0.5, color: colors.iconColor),
            Icon(Icons.star_rounded, size: size * 0.5, color: colors.iconColor),
            Icon(Icons.star_rounded, size: size * 0.5, color: colors.iconColor),
          ],
        );
      }
      return Icon(Icons.star_rounded, size: size, color: colors.iconColor);
    }

    // James Beard uses medal icon
    return Icon(
      Icons.workspace_premium,
      size: size,
      color: colors.iconColor,
    );
  }

  int _getStarCount() {
    if (label.contains('3')) return 3;
    if (label.contains('2')) return 2;
    return 1;
  }

  String _getAbbreviatedLabel() {
    // Return abbreviated version for standard size
    if (type == AwardBadgeType.michelin) {
      if (label.contains('3')) return '3*';
      if (label.contains('2')) return '2*';
      if (label.contains('1')) return '1*';
      if (label.contains('Bib')) return 'Bib';
    }
    if (label.contains('Winner')) return 'Winner';
    if (label.contains('Nominee')) return 'Nom.';
    if (label.contains('Semi')) return 'Semi.';
    return label.length > 8 ? '${label.substring(0, 6)}...' : label;
  }

  _BadgeColors _getColors() {
    switch (type) {
      case AwardBadgeType.michelin:
        final isBibGourmand = label.contains('Bib');
        if (isBibGourmand) {
          return _BadgeColors(
            backgroundColor: const Color(0xFFFEE2E2), // Light red
            borderColor: const Color(0xFFDC2626), // Red
            iconColor: const Color(0xFFB91C1C), // Dark red
            textColor: const Color(0xFFB91C1C),
          );
        }
        return _BadgeColors(
          backgroundColor: const Color(0xFFFEF3C7), // Warm yellow
          borderColor: const Color(0xFFF59E0B), // Amber
          iconColor: const Color(0xFFB45309), // Dark amber
          textColor: const Color(0xFFB45309),
        );
      case AwardBadgeType.jamesBeard:
        return _BadgeColors(
          backgroundColor: const Color(0xFFDBEAFE), // Light blue
          borderColor: const Color(0xFF3B82F6), // Blue
          iconColor: const Color(0xFF1D4ED8), // Dark blue
          textColor: const Color(0xFF1D4ED8),
        );
    }
  }

  _BadgeDimensions _getDimensions() {
    switch (size) {
      case AwardBadgeSize.compact:
        return _BadgeDimensions(
          height: 20,
          iconSize: 12,
          fontSize: 10,
          horizontalPadding: 4,
          verticalPadding: 2,
          borderRadius: 10,
          spacing: 2,
        );
      case AwardBadgeSize.standard:
        return _BadgeDimensions(
          height: 28,
          iconSize: 14,
          fontSize: 12,
          horizontalPadding: 8,
          verticalPadding: 4,
          borderRadius: 14,
          spacing: 4,
        );
      case AwardBadgeSize.expanded:
        return _BadgeDimensions(
          height: 36,
          iconSize: 18,
          fontSize: 14,
          horizontalPadding: 12,
          verticalPadding: 6,
          borderRadius: 18,
          spacing: 6,
        );
    }
  }
}

class _BadgeColors {
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final Color textColor;

  _BadgeColors({
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.textColor,
  });
}

class _BadgeDimensions {
  final double height;
  final double iconSize;
  final double fontSize;
  final double horizontalPadding;
  final double verticalPadding;
  final double borderRadius;
  final double spacing;

  _BadgeDimensions({
    required this.height,
    required this.iconSize,
    required this.fontSize,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.borderRadius,
    required this.spacing,
  });
}
