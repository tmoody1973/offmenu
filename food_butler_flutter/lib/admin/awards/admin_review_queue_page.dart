import 'package:flutter/material.dart';

import 'match_detail_modal.dart';

/// Data model for review queue items.
class ReviewQueueItem {
  final int linkId;
  final String restaurantName;
  final String restaurantAddress;
  final String awardName;
  final String awardDetails;
  final String awardType;
  final double confidenceScore;
  bool isSelected;

  ReviewQueueItem({
    required this.linkId,
    required this.restaurantName,
    required this.restaurantAddress,
    required this.awardName,
    required this.awardDetails,
    required this.awardType,
    required this.confidenceScore,
    this.isSelected = false,
  });
}

/// Admin page for reviewing pending award matches.
///
/// Features:
/// - Table of pending matches sorted by confidence (lowest first)
/// - Pagination for large queues
/// - Bulk confirm/reject actions
/// - Individual match detail modal
class AdminReviewQueuePage extends StatefulWidget {
  const AdminReviewQueuePage({super.key});

  @override
  State<AdminReviewQueuePage> createState() => _AdminReviewQueuePageState();
}

class _AdminReviewQueuePageState extends State<AdminReviewQueuePage> {
  List<ReviewQueueItem> _items = [];
  bool _isLoading = true;
  int _currentPage = 0;
  static const int _itemsPerPage = 20;

  @override
  void initState() {
    super.initState();
    _loadReviewQueue();
  }

  Future<void> _loadReviewQueue() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock data for demonstration
    setState(() {
      _items = _generateMockItems();
      _isLoading = false;
    });
  }

  List<ReviewQueueItem> _generateMockItems() {
    return [
      ReviewQueueItem(
        linkId: 1,
        restaurantName: 'French Laundry',
        restaurantAddress: '6640 Washington St, Yountville, CA',
        awardName: 'The French Laundry',
        awardDetails: 'Michelin 3 Stars (2024)',
        awardType: 'michelin',
        confidenceScore: 0.72,
      ),
      ReviewQueueItem(
        linkId: 2,
        restaurantName: 'Eleven Madison Park',
        restaurantAddress: '11 Madison Ave, New York, NY',
        awardName: 'Eleven Madison Pk',
        awardDetails: 'James Beard Winner (2024)',
        awardType: 'james_beard',
        confidenceScore: 0.78,
      ),
      ReviewQueueItem(
        linkId: 3,
        restaurantName: "Joe's Stone Crab",
        restaurantAddress: '11 Washington Ave, Miami, FL',
        awardName: 'Joes Stone Crab',
        awardDetails: 'James Beard Semifinalist (2023)',
        awardType: 'james_beard',
        confidenceScore: 0.85,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount = _items.where((i) => i.isSelected).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Queue'),
        actions: [
          if (selectedCount > 0) ...[
            TextButton.icon(
              onPressed: _handleBulkReject,
              icon: const Icon(Icons.close, color: Colors.red),
              label: Text(
                'Reject ($selectedCount)',
                style: const TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: _handleBulkConfirm,
              icon: const Icon(Icons.check),
              label: Text('Confirm ($selectedCount)'),
            ),
            const SizedBox(width: 16),
          ],
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? _buildEmptyState()
              : _buildReviewTable(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 64,
            color: Colors.green.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'All caught up!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'No pending matches to review',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewTable() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildInfoBanner(),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
                columns: [
                  DataColumn(
                    label: Checkbox(
                      value: _items.every((i) => i.isSelected),
                      onChanged: (value) => _toggleSelectAll(value ?? false),
                    ),
                  ),
                  const DataColumn(label: Text('Confidence')),
                  const DataColumn(label: Text('Restaurant')),
                  const DataColumn(label: Text('Award')),
                  const DataColumn(label: Text('Type')),
                  const DataColumn(label: Text('Actions')),
                ],
                rows: _items.map((item) => _buildDataRow(item)).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Review matches sorted by confidence score (lowest first). '
              'Click on a row to see match details.',
              style: TextStyle(color: Colors.blue.shade700),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildDataRow(ReviewQueueItem item) {
    final confidenceColor = _getConfidenceColor(item.confidenceScore);

    return DataRow(
      selected: item.isSelected,
      onSelectChanged: (_) => _showMatchDetail(item),
      cells: [
        DataCell(
          Checkbox(
            value: item.isSelected,
            onChanged: (value) => _toggleItemSelection(item, value ?? false),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: confidenceColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${(item.confidenceScore * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                color: confidenceColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.restaurantName,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                item.restaurantAddress,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.awardName,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                item.awardDetails,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        DataCell(
          _buildAwardTypeChip(item.awardType),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.check, color: Colors.green),
                onPressed: () => _confirmMatch(item),
                tooltip: 'Confirm match',
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () => _rejectMatch(item),
                tooltip: 'Reject match',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAwardTypeChip(String type) {
    final isMichelin = type == 'michelin';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isMichelin ? Colors.amber.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMichelin ? Colors.amber.shade200 : Colors.blue.shade200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isMichelin ? Icons.star_rounded : Icons.workspace_premium,
            size: 14,
            color: isMichelin ? Colors.amber.shade700 : Colors.blue.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            isMichelin ? 'Michelin' : 'J. Beard',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isMichelin ? Colors.amber.shade700 : Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    final totalPages = (_items.length / _itemsPerPage).ceil();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _currentPage > 0
              ? () => setState(() => _currentPage--)
              : null,
        ),
        Text('Page ${_currentPage + 1} of $totalPages'),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: _currentPage < totalPages - 1
              ? () => setState(() => _currentPage++)
              : null,
        ),
      ],
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.85) return Colors.green;
    if (confidence >= 0.75) return Colors.amber.shade700;
    return Colors.orange;
  }

  void _toggleSelectAll(bool value) {
    setState(() {
      for (final item in _items) {
        item.isSelected = value;
      }
    });
  }

  void _toggleItemSelection(ReviewQueueItem item, bool value) {
    setState(() {
      item.isSelected = value;
    });
  }

  void _showMatchDetail(ReviewQueueItem item) {
    showDialog(
      context: context,
      builder: (context) => MatchDetailModal(
        item: item,
        onConfirm: () {
          Navigator.pop(context);
          _confirmMatch(item);
        },
        onReject: () {
          Navigator.pop(context);
          _rejectMatch(item);
        },
      ),
    );
  }

  Future<void> _confirmMatch(ReviewQueueItem item) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _items.remove(item);
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Match confirmed'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _rejectMatch(ReviewQueueItem item) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _items.remove(item);
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Match rejected'),
          backgroundColor: Colors.red.shade400,
        ),
      );
    }
  }

  Future<void> _handleBulkConfirm() async {
    final selected = _items.where((i) => i.isSelected).toList();
    for (final item in selected) {
      await _confirmMatch(item);
    }
  }

  Future<void> _handleBulkReject() async {
    final selected = _items.where((i) => i.isSelected).toList();
    for (final item in selected) {
      await _rejectMatch(item);
    }
  }
}
