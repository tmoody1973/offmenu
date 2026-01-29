import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

/// Cuisine step - what cuisines the user is familiar with and wants to try.
///
/// From the UX spec: "Cuisine Comfort Map"
/// A visual grid - not flags, but ingredient photographs (miso paste, olive oil,
/// corn masa, gochujang). Tap to indicate familiarity. Unfamiliar ones glow
/// slightly, inviting.
class CuisineStep extends StatefulWidget {
  final List<String> familiarCuisines;
  final List<String> wantToTryCuisines;
  final ValueChanged<List<String>> onFamiliarChanged;
  final ValueChanged<List<String>> onWantToTryChanged;
  final VoidCallback onContinue;
  final bool isSubmitting;

  const CuisineStep({
    super.key,
    required this.familiarCuisines,
    required this.wantToTryCuisines,
    required this.onFamiliarChanged,
    required this.onWantToTryChanged,
    required this.onContinue,
    this.isSubmitting = false,
  });

  @override
  State<CuisineStep> createState() => _CuisineStepState();
}

class _CuisineStepState extends State<CuisineStep> {
  // Cuisines with their signature ingredients/vibes
  static const _cuisines = [
    _CuisineData('Mexican', '🌮', 'Corn masa, lime, chiles'),
    _CuisineData('Italian', '🍝', 'Olive oil, tomato, basil'),
    _CuisineData('Japanese', '🍣', 'Miso, soy, dashi'),
    _CuisineData('Chinese', '🥡', 'Sichuan peppercorn, soy, ginger'),
    _CuisineData('Thai', '🍜', 'Fish sauce, lemongrass, coconut'),
    _CuisineData('Indian', '🍛', 'Cumin, turmeric, ghee'),
    _CuisineData('Korean', '🍲', 'Gochujang, sesame, fermented'),
    _CuisineData('Vietnamese', '🍲', 'Fish sauce, herbs, rice noodle'),
    _CuisineData('Mediterranean', '🥙', 'Olive oil, lemon, herbs'),
    _CuisineData('French', '🥐', 'Butter, cream, wine'),
    _CuisineData('Ethiopian', '🫓', 'Berbere, injera, legumes'),
    _CuisineData('Peruvian', '🐟', 'Citrus, aji, ceviche'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Your cuisine comfort zone',
            style: AppTheme.headlineSerif.copyWith(
              fontSize: 28,
              color: AppTheme.cream,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Tap cuisines you know well. Long-press ones you want to explore.',
            style: AppTheme.bodySans.copyWith(
              fontSize: 14,
              color: AppTheme.creamMuted,
            ),
          ),

          const SizedBox(height: 8),

          // Legend
          Row(
            children: [
              _LegendItem(
                color: AppTheme.successColor,
                label: 'Know it',
              ),
              const SizedBox(width: 16),
              _LegendItem(
                color: AppTheme.agedBrass,
                label: 'Want to try',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Cuisine grid
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _cuisines.map((cuisine) {
              final isFamiliar = widget.familiarCuisines.contains(cuisine.name);
              final wantsToTry = widget.wantToTryCuisines.contains(cuisine.name);

              return _CuisineChip(
                cuisine: cuisine,
                isFamiliar: isFamiliar,
                wantsToTry: wantsToTry,
                onTap: () => _toggleFamiliar(cuisine.name),
                onLongPress: () => _toggleWantToTry(cuisine.name),
              );
            }).toList(),
          ),

          const SizedBox(height: 32),

          // Summary
          if (widget.familiarCuisines.isNotEmpty || widget.wantToTryCuisines.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.charcoalLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.familiarCuisines.isNotEmpty) ...[
                    Text(
                      'You know: ${widget.familiarCuisines.join(", ")}',
                      style: AppTheme.bodySans.copyWith(
                        fontSize: 13,
                        color: AppTheme.cream,
                      ),
                    ),
                  ],
                  if (widget.wantToTryCuisines.isNotEmpty) ...[
                    if (widget.familiarCuisines.isNotEmpty) const SizedBox(height: 8),
                    Text(
                      'Want to try: ${widget.wantToTryCuisines.join(", ")}',
                      style: AppTheme.bodySans.copyWith(
                        fontSize: 13,
                        color: AppTheme.agedBrass,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],

          // Complete button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: widget.isSubmitting ? null : widget.onContinue,
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.burntOrange,
                foregroundColor: AppTheme.cream,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: widget.isSubmitting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.cream,
                      ),
                    )
                  : Text(
                      'Let\'s go',
                      style: AppTheme.labelSans.copyWith(
                        fontSize: 16,
                        color: AppTheme.cream,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 16),

          // Skip note
          Center(
            child: Text(
              'You can always update this later',
              style: AppTheme.bodySans.copyWith(
                fontSize: 12,
                color: AppTheme.creamMuted,
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _toggleFamiliar(String cuisine) {
    final newList = List<String>.from(widget.familiarCuisines);
    if (newList.contains(cuisine)) {
      newList.remove(cuisine);
    } else {
      newList.add(cuisine);
      // Remove from want to try if adding to familiar
      if (widget.wantToTryCuisines.contains(cuisine)) {
        final wantList = List<String>.from(widget.wantToTryCuisines);
        wantList.remove(cuisine);
        widget.onWantToTryChanged(wantList);
      }
    }
    widget.onFamiliarChanged(newList);
  }

  void _toggleWantToTry(String cuisine) {
    final newList = List<String>.from(widget.wantToTryCuisines);
    if (newList.contains(cuisine)) {
      newList.remove(cuisine);
    } else {
      newList.add(cuisine);
      // Remove from familiar if adding to want to try
      if (widget.familiarCuisines.contains(cuisine)) {
        final familiarList = List<String>.from(widget.familiarCuisines);
        familiarList.remove(cuisine);
        widget.onFamiliarChanged(familiarList);
      }
    }
    widget.onWantToTryChanged(newList);
  }
}

/// Cuisine data model.
class _CuisineData {
  final String name;
  final String emoji;
  final String ingredients;

  const _CuisineData(this.name, this.emoji, this.ingredients);
}

/// Individual cuisine chip.
class _CuisineChip extends StatelessWidget {
  final _CuisineData cuisine;
  final bool isFamiliar;
  final bool wantsToTry;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _CuisineChip({
    required this.cuisine,
    required this.isFamiliar,
    required this.wantsToTry,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    Color bgColor;

    if (isFamiliar) {
      borderColor = AppTheme.successColor;
      bgColor = AppTheme.successColor.withAlpha(30);
    } else if (wantsToTry) {
      borderColor = AppTheme.agedBrass;
      bgColor = AppTheme.agedBrass.withAlpha(30);
    } else {
      borderColor = AppTheme.cream.withAlpha(20);
      bgColor = AppTheme.charcoalLight;
    }

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: isFamiliar || wantsToTry ? 2 : 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              cuisine.emoji,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 8),
            Text(
              cuisine.name,
              style: AppTheme.labelSans.copyWith(
                fontSize: 14,
                color: AppTheme.cream,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Legend item.
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color.withAlpha(50),
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTheme.labelSans.copyWith(
            fontSize: 12,
            color: AppTheme.creamMuted,
          ),
        ),
      ],
    );
  }
}
