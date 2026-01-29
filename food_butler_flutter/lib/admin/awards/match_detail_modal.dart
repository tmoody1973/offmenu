import 'package:flutter/material.dart';

import 'admin_review_queue_page.dart';

/// Modal dialog showing detailed comparison between restaurant and award data.
///
/// Features:
/// - Side-by-side comparison of restaurant and award details
/// - Confidence score visualization
/// - Confirm/reject action buttons
class MatchDetailModal extends StatelessWidget {
  final ReviewQueueItem item;
  final VoidCallback onConfirm;
  final VoidCallback onReject;

  const MatchDetailModal({
    super.key,
    required this.item,
    required this.onConfirm,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildConfidenceIndicator(),
                const SizedBox(height: 24),
                _buildComparison(context),
                const SizedBox(height: 24),
                _buildActions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Match Details',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildConfidenceIndicator() {
    final confidence = item.confidenceScore;
    final confidenceColor = _getConfidenceColor(confidence);
    final confidenceLabel = _getConfidenceLabel(confidence);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: confidenceColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: confidenceColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: confidence,
                  strokeWidth: 6,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation(confidenceColor),
                ),
                Text(
                  '${(confidence * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: confidenceColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Match Confidence: $confidenceLabel',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: confidenceColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getConfidenceDescription(confidence),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparison(BuildContext context) {
    return Column(
      children: [
        _buildDetailCard(
          context,
          title: 'Restaurant (Database)',
          icon: Icons.restaurant,
          color: Colors.blue,
          details: {
            'Name': item.restaurantName,
            'Address': item.restaurantAddress,
          },
        ),
        const SizedBox(height: 16),
        _buildDetailCard(
          context,
          title: 'Award Record',
          icon: item.awardType == 'michelin'
              ? Icons.star_rounded
              : Icons.workspace_premium,
          color: item.awardType == 'michelin' ? Colors.amber : Colors.indigo,
          details: {
            'Name': item.awardName,
            'Details': item.awardDetails,
            'Type': item.awardType == 'michelin'
                ? 'Michelin Guide'
                : 'James Beard Foundation',
          },
        ),
      ],
    );
  }

  Widget _buildDetailCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Map<String, String> details,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...details.entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      entry.value,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: 12,
      runSpacing: 8,
      children: [
        OutlinedButton.icon(
          onPressed: onReject,
          icon: const Icon(Icons.close, color: Colors.red),
          label: const Text(
            'Reject Match',
            style: TextStyle(color: Colors.red),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.red),
          ),
        ),
        FilledButton.icon(
          onPressed: onConfirm,
          icon: const Icon(Icons.check),
          label: const Text('Confirm Match'),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.green,
          ),
        ),
      ],
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.85) return Colors.green;
    if (confidence >= 0.75) return Colors.amber.shade700;
    return Colors.orange;
  }

  String _getConfidenceLabel(double confidence) {
    if (confidence >= 0.85) return 'High';
    if (confidence >= 0.75) return 'Medium';
    return 'Low';
  }

  String _getConfidenceDescription(double confidence) {
    if (confidence >= 0.85) {
      return 'This appears to be a strong match based on name and location similarity.';
    }
    if (confidence >= 0.75) {
      return 'Some differences detected. Please verify the match manually.';
    }
    return 'Low confidence match. Names or locations differ significantly.';
  }
}
