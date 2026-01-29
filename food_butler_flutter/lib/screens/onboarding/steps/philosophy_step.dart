import 'package:flutter/material.dart';
import 'package:food_butler_client/food_butler_client.dart';

import '../../../theme/app_theme.dart';

/// Philosophy step - story vs dish preference.
///
/// From the UX spec:
/// "Which matters more to you?"
/// - The story behind the dish
/// - The dish itself
/// (Both answers are welcome here)
class PhilosophyStep extends StatelessWidget {
  final FoodPhilosophy? selected;
  final ValueChanged<FoodPhilosophy> onSelected;
  final VoidCallback onContinue;

  const PhilosophyStep({
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
            'Before we begin —',
            style: AppTheme.bodySans.copyWith(
              fontSize: 16,
              color: AppTheme.creamMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Which matters more to you?',
            style: AppTheme.headlineSerif.copyWith(
              fontSize: 32,
              color: AppTheme.cream,
            ),
          ),

          const SizedBox(height: 40),

          // Options
          _PhilosophyOption(
            icon: Icons.auto_stories,
            title: 'The story behind the dish',
            description: 'Who made it, why it matters, the history and soul',
            isSelected: selected == FoodPhilosophy.storyFirst,
            onTap: () => onSelected(FoodPhilosophy.storyFirst),
          ),

          const SizedBox(height: 16),

          _PhilosophyOption(
            icon: Icons.restaurant,
            title: 'The dish itself',
            description: 'Flavors, technique, quality, and presentation',
            isSelected: selected == FoodPhilosophy.dishFirst,
            onTap: () => onSelected(FoodPhilosophy.dishFirst),
          ),

          const SizedBox(height: 16),

          _PhilosophyOption(
            icon: Icons.balance,
            title: 'Both equally',
            description: 'Story and substance in perfect harmony',
            isSelected: selected == FoodPhilosophy.balanced,
            onTap: () => onSelected(FoodPhilosophy.balanced),
          ),

          const SizedBox(height: 24),

          // Note
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.charcoalLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.cream.withAlpha(10)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 20,
                  color: AppTheme.creamMuted,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'All answers are welcome here. This helps us personalize your experience.',
                    style: AppTheme.bodySans.copyWith(
                      fontSize: 13,
                      color: AppTheme.creamMuted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

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

/// Individual philosophy option card.
class _PhilosophyOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _PhilosophyOption({
    required this.icon,
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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.burntOrange.withAlpha(20)
              : AppTheme.charcoalLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.burntOrange : AppTheme.cream.withAlpha(10),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.burntOrange.withAlpha(30)
                    : AppTheme.charcoal,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 28,
                color: isSelected ? AppTheme.burntOrange : AppTheme.creamMuted,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.bodySans.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppTheme.cream : AppTheme.cream,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTheme.bodySans.copyWith(
                      fontSize: 13,
                      color: AppTheme.creamMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppTheme.burntOrange,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
