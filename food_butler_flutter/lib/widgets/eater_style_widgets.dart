import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Eater.com-inspired bordered content box.
///
/// Creates a structured box with visible borders, commonly used for
/// content sections, cards, and list items in editorial layouts.
class BorderedBox extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final bool strongBorder;
  final bool accentBorder;
  final double borderRadius;
  final VoidCallback? onTap;

  const BorderedBox({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.strongBorder = false,
    this.accentBorder = false,
    this.borderRadius = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      decoration: AppTheme.boxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        strongBorder: strongBorder,
        accentBorder: accentBorder,
      ),
      child: child,
    );

    if (onTap != null) {
      content = GestureDetector(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }
}

/// Section with Eater-style header and optional border.
///
/// Features an all-caps label with strong typography,
/// followed by content in a bordered container.
class EaterSection extends StatelessWidget {
  final String label;
  final String? subtitle;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool showBorder;
  final Widget? trailing;

  const EaterSection({
    super.key,
    required this.label,
    this.subtitle,
    required this.child,
    this.padding,
    this.showBorder = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: padding ?? const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label.toUpperCase(),
                      style: AppTheme.labelCaps.copyWith(
                        fontSize: 12,
                        color: AppTheme.burntOrange,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: AppTheme.bodySans.copyWith(
                          fontSize: 14,
                          color: AppTheme.creamMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
        // Content with optional border
        if (showBorder)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: AppTheme.boxDecoration(),
            child: child,
          )
        else
          child,
      ],
    );
  }
}

/// Eater-style list item with border separator.
///
/// Used for lists of content where each item is separated
/// by a border line (top or bottom).
class BorderedListItem extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool showTopBorder;
  final bool showBottomBorder;
  final VoidCallback? onTap;

  const BorderedListItem({
    super.key,
    required this.child,
    this.padding,
    this.showTopBorder = false,
    this.showBottomBorder = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          top: showTopBorder
              ? BorderSide(color: AppTheme.borderColor, width: 1)
              : BorderSide.none,
          bottom: showBottomBorder
              ? BorderSide(color: AppTheme.borderColor, width: 1)
              : BorderSide.none,
        ),
      ),
      child: child,
    );

    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }
}

/// Eater-style headline with optional number/rank prefix.
///
/// Common pattern: "01  Restaurant Name" with a visual number prefix.
class RankedHeadline extends StatelessWidget {
  final int rank;
  final String title;
  final String? subtitle;
  final TextStyle? titleStyle;
  final VoidCallback? onTap;

  const RankedHeadline({
    super.key,
    required this.rank,
    required this.title,
    this.subtitle,
    this.titleStyle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rank number
        SizedBox(
          width: 40,
          child: Text(
            rank.toString().padLeft(2, '0'),
            style: AppTheme.displaySans.copyWith(
              fontSize: 24,
              color: AppTheme.burntOrange,
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Title and subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: titleStyle ??
                    AppTheme.headlineSans.copyWith(
                      fontSize: 20,
                    ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: AppTheme.bodySerif.copyWith(
                    fontSize: 14,
                    color: AppTheme.creamMuted,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: content);
    }
    return content;
  }
}

/// Eater-style tag/label chip with border.
class EaterTag extends StatelessWidget {
  final String label;
  final Color? color;
  final bool filled;
  final VoidCallback? onTap;

  const EaterTag({
    super.key,
    required this.label,
    this.color,
    this.filled = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tagColor = color ?? AppTheme.burntOrange;

    Widget tag = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: filled ? tagColor : Colors.transparent,
        border: Border.all(color: tagColor, width: 1),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTheme.labelCaps.copyWith(
          fontSize: 10,
          color: filled ? AppTheme.cream : tagColor,
          letterSpacing: 1.0,
        ),
      ),
    );

    if (onTap != null) {
      tag = GestureDetector(onTap: onTap, child: tag);
    }

    return tag;
  }
}

/// Eater-style featured content card with strong visual hierarchy.
///
/// Used for hero sections and featured stories.
class FeaturedCard extends StatelessWidget {
  final String? label;
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final VoidCallback? onTap;
  final double height;
  final bool showBorder;

  const FeaturedCard({
    super.key,
    this.label,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.onTap,
    this.height = 400,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: AppTheme.charcoalLight,
          border: showBorder ? AppTheme.boxBorder : null,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            if (imageUrl != null)
              Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppTheme.charcoalLight,
                ),
              ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppTheme.charcoal.withAlpha(200),
                    AppTheme.charcoal.withAlpha(250),
                  ],
                  stops: const [0.3, 0.7, 1.0],
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label
                  if (label != null)
                    EaterTag(label: label!, filled: true),
                  if (label != null) const SizedBox(height: 16),
                  // Title
                  Text(
                    title,
                    style: AppTheme.headlineSans.copyWith(
                      fontSize: 28,
                      height: 1.2,
                    ),
                  ),
                  // Subtitle
                  if (subtitle != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      subtitle!,
                      style: AppTheme.bodySerif.copyWith(
                        fontSize: 16,
                        color: AppTheme.creamMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal divider with Eater-style
class EaterDivider extends StatelessWidget {
  final double? indent;
  final double? endIndent;
  final double thickness;
  final Color? color;

  const EaterDivider({
    super.key,
    this.indent,
    this.endIndent,
    this.thickness = 1,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: thickness,
      indent: indent ?? 16,
      endIndent: endIndent ?? 16,
      color: color ?? AppTheme.borderColor,
    );
  }
}

/// Quote block with Eater-style formatting
class EaterQuote extends StatelessWidget {
  final String quote;
  final String? attribution;

  const EaterQuote({
    super.key,
    required this.quote,
    this.attribution,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: AppTheme.burntOrange, width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '"$quote"',
            style: AppTheme.bodySerif.copyWith(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
          if (attribution != null) ...[
            const SizedBox(height: 12),
            Text(
              '— $attribution',
              style: AppTheme.labelSans.copyWith(
                fontSize: 14,
                color: AppTheme.creamMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
