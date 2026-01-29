import 'package:flutter/material.dart';

/// Data model for import preview items.
class ImportPreviewItem {
  final String recordName;
  final String recordCity;
  final int recordYear;
  final String? matchedRestaurantName;
  final double? confidence;
  final String status; // 'auto_match', 'pending_review', 'no_match'

  ImportPreviewItem({
    required this.recordName,
    required this.recordCity,
    required this.recordYear,
    this.matchedRestaurantName,
    this.confidence,
    required this.status,
  });
}

/// Section displaying import preview results.
///
/// Shows a table of records to be imported with their matching status:
/// - Green: auto-match (high confidence)
/// - Yellow: pending review (medium confidence)
/// - Red: no match found
class ImportPreviewSection extends StatelessWidget {
  final List<ImportPreviewItem> items;
  final String awardType;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ImportPreviewSection({
    super.key,
    required this.items,
    required this.awardType,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final autoMatchCount = items.where((i) => i.status == 'auto_match').length;
    final reviewCount = items.where((i) => i.status == 'pending_review').length;
    final noMatchCount = items.where((i) => i.status == 'no_match').length;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          _buildSummary(autoMatchCount, reviewCount, noMatchCount),
          const Divider(height: 1),
          _buildTable(context),
          const Divider(height: 1),
          _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            awardType == 'michelin' ? Icons.star_rounded : Icons.workspace_premium,
            color: awardType == 'michelin' ? Colors.amber : Colors.blue,
          ),
          const SizedBox(width: 12),
          Text(
            'Import Preview',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const Spacer(),
          Text(
            '${items.length} records',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(int autoMatch, int review, int noMatch) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildStatusChip('Auto Match', autoMatch, Colors.green),
          const SizedBox(width: 12),
          _buildStatusChip('Needs Review', review, Colors.amber),
          const SizedBox(width: 12),
          _buildStatusChip('No Match', noMatch, Colors.red),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$label: $count',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
        columns: const [
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Record Name')),
          DataColumn(label: Text('City')),
          DataColumn(label: Text('Year')),
          DataColumn(label: Text('Matched Restaurant')),
          DataColumn(label: Text('Confidence')),
        ],
        rows: items.map((item) => _buildDataRow(item)).toList(),
      ),
    );
  }

  DataRow _buildDataRow(ImportPreviewItem item) {
    final statusColor = _getStatusColor(item.status);
    final statusIcon = _getStatusIcon(item.status);

    return DataRow(
      cells: [
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(statusIcon, color: statusColor, size: 18),
              const SizedBox(width: 8),
              Text(
                _getStatusLabel(item.status),
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        DataCell(Text(item.recordName)),
        DataCell(Text(item.recordCity)),
        DataCell(Text(item.recordYear.toString())),
        DataCell(Text(item.matchedRestaurantName ?? '-')),
        DataCell(
          item.confidence != null
              ? Text(
                  '${(item.confidence! * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: _getConfidenceColor(item.confidence!),
                    fontWeight: FontWeight.w500,
                  ),
                )
              : const Text('-'),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: onCancel,
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: onConfirm,
            icon: const Icon(Icons.check),
            label: const Text('Confirm Import'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'auto_match':
        return Colors.green;
      case 'pending_review':
        return Colors.amber.shade700;
      case 'no_match':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'auto_match':
        return Icons.check_circle;
      case 'pending_review':
        return Icons.help;
      case 'no_match':
        return Icons.cancel;
      default:
        return Icons.circle;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'auto_match':
        return 'Auto Match';
      case 'pending_review':
        return 'Review';
      case 'no_match':
        return 'No Match';
      default:
        return status;
    }
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.9) return Colors.green;
    if (confidence >= 0.7) return Colors.amber.shade700;
    return Colors.red;
  }
}
