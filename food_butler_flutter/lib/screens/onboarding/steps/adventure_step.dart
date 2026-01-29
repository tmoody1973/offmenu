import 'package:flutter/material.dart';
import 'package:food_butler_client/food_butler_client.dart';

import '../../../theme/app_theme.dart';

/// Adventure step - how the user explores food.
///
/// From the UX spec:
/// "When you travel, you tend to:"
/// - Find the places locals love
/// - Hit the landmarks, then explore
/// - Let serendipity guide you
/// - Research obsessively beforehand
class AdventureStep extends StatelessWidget {
  final AdventureLevel? selected;
  final ValueChanged<AdventureLevel> onSelected;
  final VoidCallback onContinue;

  const AdventureStep({
    super.key,
    this.selected,
    required this.onSelected,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    // Get safe area padding for notched devices
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 32,
        bottom: safeAreaBottom + 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'When you travel, you tend to:',
            style: AppTheme.headlineSerif.copyWith(
              fontSize: 28,
              color: AppTheme.cream,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This helps our Serendipity Engine know how adventurous to get.',
            style: AppTheme.bodySans.copyWith(
              fontSize: 14,
              color: AppTheme.creamMuted,
              fontStyle: FontStyle.italic,
            ),
          ),

          const SizedBox(height: 32),

          // Options
          _AdventureOption(
            emoji: '🗺️',
            title: 'Find the places locals love',
            description: 'Skip the tourist traps, go where the kitchen workers eat',
            isSelected: selected == AdventureLevel.localExplorer,
            onTap: () => onSelected(AdventureLevel.localExplorer),
          ),

          const SizedBox(height: 12),

          _AdventureOption(
            emoji: '🏛️',
            title: 'Hit the landmarks, then explore',
            description: 'See the famous spots, but leave room for discovery',
            isSelected: selected == AdventureLevel.landmarkFirst,
            onTap: () => onSelected(AdventureLevel.landmarkFirst),
          ),

          const SizedBox(height: 12),

          _AdventureOption(
            emoji: '🎲',
            title: 'Let serendipity guide you',
            description: 'Wander, get lost, see what happens',
            isSelected: selected == AdventureLevel.serendipitous,
            onTap: () => onSelected(AdventureLevel.serendipitous),
          ),

          const SizedBox(height: 12),

          _AdventureOption(
            emoji: '📚',
            title: 'Research obsessively beforehand',
            description: 'Read every review, watch every video, make spreadsheets',
            isSelected: selected == AdventureLevel.researcher,
            onTap: () => onSelected(AdventureLevel.researcher),
          ),

          const SizedBox(height: 32),

          // Continue button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: selected != null ? onContinue : null,
              style: FilledButton.styleFrom(
                backgroundColor: selected != null ? AppTheme.burntOrange : AppTheme.charcoalLight,
                foregroundColor: AppTheme.cream,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Continue',
                style: AppTheme.labelSans.copyWith(
                  fontSize: 16,
                  color: AppTheme.cream,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// Individual adventure option.
class _AdventureOption extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _AdventureOption({
    required this.emoji,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.burntOrange.withAlpha(20)
              : AppTheme.charcoalLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.burntOrange : AppTheme.cream.withAlpha(10),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Emoji
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.burntOrange.withAlpha(30)
                    : AppTheme.charcoal,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(width: 16),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.bodySans.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.cream,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: AppTheme.bodySans.copyWith(
                      fontSize: 12,
                      color: AppTheme.creamMuted,
                    ),
                  ),
                ],
              ),
            ),
            // Check
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppTheme.burntOrange,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 16,
                  color: AppTheme.cream,
                ),
              )
            else
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.creamMuted, width: 1.5),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
