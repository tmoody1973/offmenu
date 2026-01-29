import 'package:flutter/material.dart';

import '../services/directions_service.dart';

/// A card displaying a single direction step.
///
/// Features:
/// - Maneuver instruction text
/// - Distance and estimated time
/// - Visual indicator for maneuver type
/// - Highlight style for current/next step
class DirectionsStepCard extends StatelessWidget {
  /// The direction step to display.
  final DirectionStep step;

  /// The step number (1-based).
  final int stepNumber;

  /// Whether this is the current step.
  final bool isCurrent;

  /// Whether this is the next step.
  final bool isNext;

  const DirectionsStepCard({
    super.key,
    required this.step,
    required this.stepNumber,
    this.isCurrent = false,
    this.isNext = false,
  });

  @override
  Widget build(BuildContext context) {
    final isHighlighted = isCurrent || isNext;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrent
            ? const Color(0xFF2563EB).withAlpha(20)
            : isNext
                ? const Color(0xFF22C55E).withAlpha(20)
                : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCurrent
              ? const Color(0xFF2563EB)
              : isNext
                  ? const Color(0xFF22C55E)
                  : Colors.grey[200]!,
          width: isHighlighted ? 2 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Maneuver icon
          _buildManeuverIcon(),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Instruction
                Text(
                  step.instruction,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.normal,
                    color: Colors.grey[900],
                  ),
                ),
                const SizedBox(height: 4),

                // Distance and time
                Row(
                  children: [
                    Icon(
                      Icons.straighten_rounded,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      step.distanceText,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.schedule_rounded,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      step.durationText,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManeuverIcon() {
    IconData icon;
    Color color;

    switch (step.maneuverType) {
      case 'depart':
        icon = Icons.play_circle_outline_rounded;
        color = const Color(0xFF22C55E);
        break;
      case 'arrive':
        icon = Icons.flag_circle_rounded;
        color = const Color(0xFF2563EB);
        break;
      case 'turn':
        if (step.modifier?.contains('left') ?? false) {
          icon = Icons.turn_left_rounded;
        } else if (step.modifier?.contains('right') ?? false) {
          icon = Icons.turn_right_rounded;
        } else {
          icon = Icons.turn_slight_right_rounded;
        }
        color = const Color(0xFFF97316);
        break;
      default:
        icon = Icons.arrow_upward_rounded;
        color = Colors.grey[600]!;
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 20, color: color),
    );
  }
}
