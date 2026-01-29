import 'package:flutter/material.dart';

/// A touch-friendly star rating widget.
///
/// Displays 5 tappable stars with minimum 44x44px tap targets.
/// Shows filled stars for the current rating and outlined stars for the rest.
class StarRating extends StatelessWidget {
  /// The current rating (1-5).
  final int rating;

  /// Called when the rating changes.
  final void Function(int rating)? onRatingChanged;

  /// The size of each star icon.
  final double starSize;

  /// The color of filled stars.
  final Color? filledColor;

  /// The color of empty stars.
  final Color? emptyColor;

  /// Whether the widget is read-only.
  final bool readOnly;

  /// Whether to show an error state (e.g., when validation fails).
  final bool showError;

  const StarRating({
    super.key,
    required this.rating,
    this.onRatingChanged,
    this.starSize = 32,
    this.filledColor,
    this.emptyColor,
    this.readOnly = false,
    this.showError = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveFilledColor = filledColor ?? Colors.amber;
    final effectiveEmptyColor = emptyColor ?? Colors.grey.shade300;
    final errorColor = theme.colorScheme.error;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starNumber = index + 1;
        final isFilled = starNumber <= rating;

        return InkWell(
          onTap: readOnly ? null : () => onRatingChanged?.call(starNumber),
          customBorder: const CircleBorder(),
          child: Container(
            // Minimum 44x44px tap target for accessibility
            width: 44,
            height: 44,
            alignment: Alignment.center,
            child: Icon(
              isFilled ? Icons.star : Icons.star_border,
              size: starSize,
              color: showError && rating == 0
                  ? errorColor
                  : (isFilled ? effectiveFilledColor : effectiveEmptyColor),
            ),
          ),
        );
      }),
    );
  }
}

/// A labeled star rating widget with optional validation error message.
class LabeledStarRating extends StatelessWidget {
  /// Label text displayed above the rating.
  final String label;

  /// The current rating (1-5).
  final int rating;

  /// Called when the rating changes.
  final void Function(int rating)? onRatingChanged;

  /// Whether the field is required.
  final bool required;

  /// Error message to display (e.g., "Rating is required").
  final String? errorText;

  /// Whether the widget is read-only.
  final bool readOnly;

  const LabeledStarRating({
    super.key,
    required this.label,
    required this.rating,
    this.onRatingChanged,
    this.required = false,
    this.errorText,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: theme.textTheme.titleMedium,
            ),
            if (required)
              Text(
                ' *',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        StarRating(
          rating: rating,
          onRatingChanged: onRatingChanged,
          readOnly: readOnly,
          showError: errorText != null,
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              errorText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}
