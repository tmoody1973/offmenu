import 'package:flutter/material.dart';

import '../services/directions_service.dart';
import 'directions_step_card.dart';

/// A collapsible panel for displaying turn-by-turn directions.
///
/// Features:
/// - Scrollable list of direction steps
/// - Leg summaries with total distance/time
/// - Collapsible to maximize map view
/// - Highlights current/next step
class DirectionsPanel extends StatefulWidget {
  /// The directions result to display.
  final DirectionsResult? directions;

  /// Index of the current leg being navigated.
  final int currentLegIndex;

  /// Index of the current step within the current leg.
  final int currentStepIndex;

  /// Callback when the panel is collapsed.
  final VoidCallback? onCollapse;

  /// Whether the panel is initially expanded.
  final bool initiallyExpanded;

  const DirectionsPanel({
    super.key,
    this.directions,
    this.currentLegIndex = 0,
    this.currentStepIndex = 0,
    this.onCollapse,
    this.initiallyExpanded = true,
  });

  @override
  State<DirectionsPanel> createState() => _DirectionsPanelState();
}

class _DirectionsPanelState extends State<DirectionsPanel> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.directions == null) {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _isExpanded ? 300 : 60,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with collapse/expand toggle
          _buildHeader(),

          // Scrollable content
          if (_isExpanded) Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final directions = widget.directions!;
    final currentLeg = directions.legs.isNotEmpty
        ? directions.legs[widget.currentLegIndex.clamp(0, directions.legs.length - 1)]
        : null;

    return GestureDetector(
      onTap: _toggleExpanded,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Row(
          children: [
            // Transport mode icon
            Icon(
              directions.transportMode.name == 'walking'
                  ? Icons.directions_walk_rounded
                  : Icons.directions_car_rounded,
              color: const Color(0xFF2563EB),
            ),
            const SizedBox(width: 12),

            // Summary
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (currentLeg != null)
                    Text(
                      '${currentLeg.originName} to ${currentLeg.destinationName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  Text(
                    '${currentLeg?.distanceText ?? ""} - ${currentLeg?.durationText ?? ""}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Expand/collapse button
            IconButton(
              icon: Icon(
                _isExpanded
                    ? Icons.keyboard_arrow_down_rounded
                    : Icons.keyboard_arrow_up_rounded,
              ),
              onPressed: _toggleExpanded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final directions = widget.directions!;

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: directions.legs.length,
      itemBuilder: (context, legIndex) {
        final leg = directions.legs[legIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leg header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF97316),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Leg ${legIndex + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${leg.originName} to ${leg.destinationName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Steps
            ...leg.steps.asMap().entries.map((entry) {
              final stepIndex = entry.key;
              final step = entry.value;
              final isCurrent =
                  legIndex == widget.currentLegIndex &&
                  stepIndex == widget.currentStepIndex;
              final isNext =
                  (legIndex == widget.currentLegIndex &&
                      stepIndex == widget.currentStepIndex + 1) ||
                  (legIndex == widget.currentLegIndex + 1 && stepIndex == 0);

              return DirectionsStepCard(
                step: step,
                stepNumber: stepIndex + 1,
                isCurrent: isCurrent,
                isNext: isNext,
              );
            }),

            if (legIndex < directions.legs.length - 1)
              const Divider(height: 24),
          ],
        );
      },
    );
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    if (!_isExpanded) {
      widget.onCollapse?.call();
    }
  }
}

/// Button to trigger fetching directions.
class GetDirectionsButton extends StatelessWidget {
  /// Callback when the button is tapped.
  final VoidCallback? onTap;

  /// Whether directions are currently loading.
  final bool isLoading;

  const GetDirectionsButton({
    super.key,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isLoading ? null : onTap,
      icon: isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Icon(Icons.directions_rounded),
      label: Text(isLoading ? 'Loading...' : 'Get Directions'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF22C55E),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
