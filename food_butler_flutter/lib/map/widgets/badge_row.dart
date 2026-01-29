import 'package:flutter/material.dart';

import 'award_badge.dart';

/// Award data model for BadgeRow.
class AwardData {
  /// The type of award (michelin or jamesBeard).
  final AwardBadgeType type;

  /// The label for the award (e.g., "3 Stars", "Winner").
  final String label;

  /// The year the award was given.
  final int? year;

  /// Optional category for James Beard awards.
  final String? category;

  const AwardData({
    required this.type,
    required this.label,
    this.year,
    this.category,
  });

  /// Creates an AwardData from a map (typically from API response).
  factory AwardData.fromMap(Map<String, dynamic> map) {
    final type = map['type'] == 'michelin'
        ? AwardBadgeType.michelin
        : AwardBadgeType.jamesBeard;

    String label;
    if (type == AwardBadgeType.michelin) {
      final designation = map['designation'] as String? ?? 'oneStar';
      switch (designation) {
        case 'threeStar':
          label = '3 Stars';
          break;
        case 'twoStar':
          label = '2 Stars';
          break;
        case 'bibGourmand':
          label = 'Bib Gourmand';
          break;
        case 'oneStar':
        default:
          label = '1 Star';
      }
    } else {
      final distinction = map['distinctionLevel'] as String? ?? 'semifinalist';
      switch (distinction) {
        case 'winner':
          label = 'Winner';
          break;
        case 'nominee':
          label = 'Nominee';
          break;
        case 'semifinalist':
        default:
          label = 'Semifinalist';
      }
    }

    return AwardData(
      type: type,
      label: label,
      year: map['year'] as int?,
      category: map['category'] as String?,
    );
  }
}

/// A row of award badges with overflow handling.
///
/// Displays multiple award badges horizontally with:
/// - Consistent spacing between badges
/// - Overflow handling with "+N more" chip when exceeding maxVisible
/// - Optional tap callback for the overflow chip
class BadgeRow extends StatelessWidget {
  /// List of awards to display.
  final List<AwardData> awards;

  /// Maximum number of badges to display before showing overflow.
  final int maxVisible;

  /// Size variant for the badges.
  final AwardBadgeSize size;

  /// Spacing between badges.
  final double spacing;

  /// Callback when the overflow chip is tapped.
  final VoidCallback? onOverflowTap;

  /// Callback when a badge is tapped.
  final void Function(AwardData award)? onBadgeTap;

  const BadgeRow({
    super.key,
    required this.awards,
    this.maxVisible = 3,
    this.size = AwardBadgeSize.standard,
    this.spacing = 6.0,
    this.onOverflowTap,
    this.onBadgeTap,
  });

  @override
  Widget build(BuildContext context) {
    if (awards.isEmpty) {
      return const SizedBox.shrink();
    }

    final visibleAwards = awards.take(maxVisible).toList();
    final overflowCount = awards.length - maxVisible;

    return Semantics(
      label: 'Award badges: ${awards.length} total',
      child: Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: [
          ...visibleAwards.map((award) => AwardBadge(
                type: award.type,
                label: award.label,
                year: award.year,
                size: size,
                onTap: onBadgeTap != null ? () => onBadgeTap!(award) : null,
              )),
          if (overflowCount > 0) _buildOverflowChip(overflowCount),
        ],
      ),
    );
  }

  Widget _buildOverflowChip(int count) {
    final dimensions = _getOverflowDimensions();

    Widget chip = Container(
      height: dimensions.height,
      padding: EdgeInsets.symmetric(
        horizontal: dimensions.horizontalPadding,
        vertical: dimensions.verticalPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
        border: Border.all(color: Colors.grey.shade400, width: 1),
      ),
      child: Center(
        child: Text(
          '+$count more',
          style: TextStyle(
            fontSize: dimensions.fontSize,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
      ),
    );

    // Wrap with Semantics
    chip = Semantics(
      label: '$count more awards',
      button: onOverflowTap != null,
      child: chip,
    );

    // Wrap with InkWell if tappable
    if (onOverflowTap != null) {
      chip = InkWell(
        onTap: onOverflowTap,
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
        child: chip,
      );
    }

    return chip;
  }

  _OverflowDimensions _getOverflowDimensions() {
    switch (size) {
      case AwardBadgeSize.compact:
        return _OverflowDimensions(
          height: 20,
          fontSize: 10,
          horizontalPadding: 6,
          verticalPadding: 2,
          borderRadius: 10,
        );
      case AwardBadgeSize.standard:
        return _OverflowDimensions(
          height: 28,
          fontSize: 12,
          horizontalPadding: 8,
          verticalPadding: 4,
          borderRadius: 14,
        );
      case AwardBadgeSize.expanded:
        return _OverflowDimensions(
          height: 36,
          fontSize: 14,
          horizontalPadding: 12,
          verticalPadding: 6,
          borderRadius: 18,
        );
    }
  }
}

class _OverflowDimensions {
  final double height;
  final double fontSize;
  final double horizontalPadding;
  final double verticalPadding;
  final double borderRadius;

  _OverflowDimensions({
    required this.height,
    required this.fontSize,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.borderRadius,
  });
}

/// A section displaying the full award history for a restaurant.
///
/// Groups awards by type (Michelin and James Beard) and displays
/// them in expanded format with years.
class AwardHistorySection extends StatelessWidget {
  /// List of all awards for the restaurant.
  final List<AwardData> awards;

  /// Callback when an award is tapped.
  final void Function(AwardData award)? onAwardTap;

  const AwardHistorySection({
    super.key,
    required this.awards,
    this.onAwardTap,
  });

  @override
  Widget build(BuildContext context) {
    if (awards.isEmpty) {
      return const SizedBox.shrink();
    }

    final michelinAwards = awards
        .where((a) => a.type == AwardBadgeType.michelin)
        .toList()
      ..sort((a, b) => (b.year ?? 0).compareTo(a.year ?? 0));

    final jamesBeardAwards = awards
        .where((a) => a.type == AwardBadgeType.jamesBeard)
        .toList()
      ..sort((a, b) => (b.year ?? 0).compareTo(a.year ?? 0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (michelinAwards.isNotEmpty) ...[
          _buildSectionHeader(context, 'Michelin Guide'),
          const SizedBox(height: 8),
          _buildAwardsList(michelinAwards),
          const SizedBox(height: 16),
        ],
        if (jamesBeardAwards.isNotEmpty) ...[
          _buildSectionHeader(context, 'James Beard Foundation'),
          const SizedBox(height: 8),
          _buildAwardsList(jamesBeardAwards),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }

  Widget _buildAwardsList(List<AwardData> awards) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: awards.map((award) {
        return AwardBadge(
          type: award.type,
          label: award.label,
          year: award.year,
          size: AwardBadgeSize.expanded,
          onTap: onAwardTap != null ? () => onAwardTap!(award) : null,
        );
      }).toList(),
    );
  }
}

/// Widget displaying aggregated award statistics for a tour.
class TourAwardSummary extends StatelessWidget {
  /// List of all awards from all stops in the tour.
  final List<AwardData> awards;

  const TourAwardSummary({
    super.key,
    required this.awards,
  });

  @override
  Widget build(BuildContext context) {
    if (awards.isEmpty) {
      return const SizedBox.shrink();
    }

    final michelinCount = awards.where((a) => a.type == AwardBadgeType.michelin).length;
    final jamesBeardCount = awards.where((a) => a.type == AwardBadgeType.jamesBeard).length;

    final threeStarCount = awards.where((a) => a.label.contains('3')).length;

    return Semantics(
      label: _buildSemanticLabel(michelinCount, jamesBeardCount, threeStarCount),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.amber.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.amber.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.star_rounded, color: Colors.amber.shade700, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Award-Winning Tour',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.amber.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (michelinCount > 0)
              Text(
                '$michelinCount Michelin-starred stop${michelinCount > 1 ? 's' : ''}',
                style: TextStyle(color: Colors.amber.shade900),
              ),
            if (jamesBeardCount > 0)
              Text(
                '$jamesBeardCount James Beard-recognized stop${jamesBeardCount > 1 ? 's' : ''}',
                style: TextStyle(color: Colors.amber.shade900),
              ),
            if (threeStarCount > 0)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Includes $threeStarCount three-star restaurant${threeStarCount > 1 ? 's' : ''}!',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.amber.shade800,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _buildSemanticLabel(int michelin, int jamesBeard, int threeStar) {
    final parts = <String>[];
    if (michelin > 0) parts.add('$michelin Michelin-starred stops');
    if (jamesBeard > 0) parts.add('$jamesBeard James Beard recognized stops');
    if (threeStar > 0) parts.add('includes $threeStar three-star restaurants');
    return 'Award-winning tour: ${parts.join(', ')}';
  }
}
