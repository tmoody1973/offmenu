import 'package:flutter/material.dart';

import '../widgets/journal_entry_card.dart';

/// Sorting options for the timeline.
enum TimelineSortOption {
  newestFirst,
  oldestFirst,
  highestRated,
}

/// Filter state for the timeline.
class TimelineFilters {
  final DateTime? startDate;
  final DateTime? endDate;
  final TimelineSortOption sortOption;

  TimelineFilters({
    this.startDate,
    this.endDate,
    this.sortOption = TimelineSortOption.newestFirst,
  });

  TimelineFilters copyWith({
    DateTime? startDate,
    DateTime? endDate,
    TimelineSortOption? sortOption,
  }) {
    return TimelineFilters(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      sortOption: sortOption ?? this.sortOption,
    );
  }

  void clear() {}
}

/// A page displaying the user's journal entries in chronological order.
///
/// Features:
/// - Reverse chronological list of entry cards
/// - Pull-to-refresh
/// - Infinite scroll pagination
/// - Sort and filter controls
class TimelinePage extends StatefulWidget {
  /// Callback to fetch entries.
  final Future<Map<String, dynamic>> Function({
    int page,
    int pageSize,
    String sortBy,
    String sortOrder,
    DateTime? startDate,
    DateTime? endDate,
  })? onFetchEntries;

  /// Called when an entry is tapped.
  final void Function(int entryId)? onEntryTapped;

  /// Called when the add button is tapped.
  final VoidCallback? onAddEntry;

  const TimelinePage({
    super.key,
    this.onFetchEntries,
    this.onEntryTapped,
    this.onAddEntry,
  });

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  final List<JournalEntryCardData> _entries = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 1;
  String? _errorMessage;
  TimelineFilters _filters = TimelineFilters();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadEntries();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreEntries();
    }
  }

  Future<void> _loadEntries() async {
    if (widget.onFetchEntries == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await widget.onFetchEntries!(
        page: 1,
        pageSize: 20,
        sortBy: _getSortBy(),
        sortOrder: _getSortOrder(),
        startDate: _filters.startDate,
        endDate: _filters.endDate,
      );

      if (result['success'] == true) {
        final data = result['data'] as Map<String, dynamic>;
        final entriesJson = data['entries'] as List<dynamic>;

        setState(() {
          _entries.clear();
          _entries.addAll(
            entriesJson.map((e) =>
                JournalEntryCardData.fromJson(e as Map<String, dynamic>)),
          );
          _hasMore = data['hasMore'] as bool? ?? false;
          _currentPage = 1;
        });
      } else {
        setState(() {
          _errorMessage = result['error'] as String? ?? 'Failed to load entries';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreEntries() async {
    if (_isLoadingMore || !_hasMore || widget.onFetchEntries == null) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final result = await widget.onFetchEntries!(
        page: _currentPage + 1,
        pageSize: 20,
        sortBy: _getSortBy(),
        sortOrder: _getSortOrder(),
        startDate: _filters.startDate,
        endDate: _filters.endDate,
      );

      if (result['success'] == true) {
        final data = result['data'] as Map<String, dynamic>;
        final entriesJson = data['entries'] as List<dynamic>;

        setState(() {
          _entries.addAll(
            entriesJson.map((e) =>
                JournalEntryCardData.fromJson(e as Map<String, dynamic>)),
          );
          _hasMore = data['hasMore'] as bool? ?? false;
          _currentPage++;
        });
      }
    } catch (e) {
      // Silently fail for load more
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  String _getSortBy() {
    switch (_filters.sortOption) {
      case TimelineSortOption.highestRated:
        return 'rating';
      default:
        return 'visitedAt';
    }
  }

  String _getSortOrder() {
    switch (_filters.sortOption) {
      case TimelineSortOption.oldestFirst:
        return 'asc';
      default:
        return 'desc';
    }
  }

  void _updateFilters(TimelineFilters filters) {
    setState(() {
      _filters = filters;
    });
    _loadEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Journal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onAddEntry,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _entries.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null && _entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(_errorMessage!),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: _loadEntries,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_entries.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadEntries,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 8, bottom: 88),
        itemCount: _entries.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _entries.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final entry = _entries[index];
          return JournalEntryCard(
            entry: entry,
            onTap: () => widget.onEntryTapped?.call(entry.id),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No journal entries yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Start logging your culinary adventures!',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: widget.onAddEntry,
            icon: const Icon(Icons.add),
            label: const Text('Add Entry'),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _FilterSheet(
        filters: _filters,
        onFiltersChanged: _updateFilters,
      ),
    );
  }
}

/// Bottom sheet for filter and sort options.
class _FilterSheet extends StatefulWidget {
  final TimelineFilters filters;
  final void Function(TimelineFilters) onFiltersChanged;

  const _FilterSheet({
    required this.filters,
    required this.onFiltersChanged,
  });

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late TimelineFilters _filters;

  @override
  void initState() {
    super.initState();
    _filters = widget.filters;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Sort & Filter',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Sort by',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            SegmentedButton<TimelineSortOption>(
              segments: const [
                ButtonSegment(
                  value: TimelineSortOption.newestFirst,
                  label: Text('Newest'),
                ),
                ButtonSegment(
                  value: TimelineSortOption.oldestFirst,
                  label: Text('Oldest'),
                ),
                ButtonSegment(
                  value: TimelineSortOption.highestRated,
                  label: Text('Rating'),
                ),
              ],
              selected: {_filters.sortOption},
              onSelectionChanged: (selected) {
                setState(() {
                  _filters = _filters.copyWith(sortOption: selected.first);
                });
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () {
                      setState(() {
                        _filters = TimelineFilters();
                      });
                    },
                    child: const Text('Clear'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      widget.onFiltersChanged(_filters);
                      Navigator.pop(context);
                    },
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
