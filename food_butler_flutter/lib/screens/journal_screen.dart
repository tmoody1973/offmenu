import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../journal/screens/restaurant_visits_page.dart';
import '../journal/screens/timeline_page.dart';
import '../main.dart';
import '../theme/app_theme.dart';

/// Journal screen with tabs for timeline and restaurant-grouped views.
///
/// Features:
/// - Tab for chronological timeline view
/// - Tab for restaurant-grouped view
/// - Uses existing TimelinePage and RestaurantVisitsPage components
class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _fetchEntries({
    int page = 1,
    int pageSize = 20,
    String sortBy = 'visitedAt',
    String sortOrder = 'desc',
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final result = await client.journalEntry.getEntries(
        page: page,
        pageSize: pageSize,
        sortBy: sortBy,
        sortOrder: sortOrder,
        startDate: startDate,
        endDate: endDate,
      );
      return result;
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> _fetchRestaurants({
    String sortBy = 'lastVisit',
    String sortOrder = 'desc',
  }) async {
    try {
      final result = await client.journalEntry.getVisitedRestaurants(
        sortBy: sortBy,
        sortOrder: sortOrder,
      );
      return result;
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  void _navigateToEntryDetail(int entryId) {
    context.push('/journal/entry/$entryId');
  }

  void _navigateToRestaurantDetail(int restaurantId) {
    context.push('/journal/restaurant/$restaurantId');
  }

  void _navigateToNewEntry() {
    context.push('/journal/new');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Journal'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.timeline), text: 'Timeline'),
            Tab(icon: Icon(Icons.restaurant), text: 'Restaurants'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Timeline tab - using inline content since TimelinePage has its own AppBar
          _TimelineContent(
            onFetchEntries: _fetchEntries,
            onEntryTapped: _navigateToEntryDetail,
            onAddEntry: _navigateToNewEntry,
          ),

          // Restaurants tab - using inline content since RestaurantVisitsPage has its own AppBar
          _RestaurantsContent(
            onFetchRestaurants: _fetchRestaurants,
            onRestaurantTapped: _navigateToRestaurantDetail,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToNewEntry,
        icon: const Icon(Icons.add),
        label: const Text('New Entry'),
      ),
    );
  }
}

/// Timeline content widget that wraps TimelinePage functionality without an extra AppBar.
class _TimelineContent extends StatefulWidget {
  final Future<Map<String, dynamic>> Function({
    int page,
    int pageSize,
    String sortBy,
    String sortOrder,
    DateTime? startDate,
    DateTime? endDate,
  }) onFetchEntries;
  final void Function(int entryId) onEntryTapped;
  final VoidCallback onAddEntry;

  const _TimelineContent({
    required this.onFetchEntries,
    required this.onEntryTapped,
    required this.onAddEntry,
  });

  @override
  State<_TimelineContent> createState() => _TimelineContentState();
}

class _TimelineContentState extends State<_TimelineContent> {
  @override
  Widget build(BuildContext context) {
    // Since TimelinePage includes its own Scaffold and AppBar,
    // we use a simplified version here that just shows the body content
    return TimelinePage(
      onFetchEntries: ({
        int page = 1,
        int pageSize = 20,
        String sortBy = 'visitedAt',
        String sortOrder = 'desc',
        DateTime? startDate,
        DateTime? endDate,
      }) {
        return widget.onFetchEntries(
          page: page,
          pageSize: pageSize,
          sortBy: sortBy,
          sortOrder: sortOrder,
          startDate: startDate,
          endDate: endDate,
        );
      },
      onEntryTapped: widget.onEntryTapped,
      onAddEntry: widget.onAddEntry,
    );
  }
}

/// Restaurants content widget that wraps RestaurantVisitsPage functionality.
class _RestaurantsContent extends StatelessWidget {
  final Future<Map<String, dynamic>> Function({
    String sortBy,
    String sortOrder,
  }) onFetchRestaurants;
  final void Function(int restaurantId) onRestaurantTapped;

  const _RestaurantsContent({
    required this.onFetchRestaurants,
    required this.onRestaurantTapped,
  });

  @override
  Widget build(BuildContext context) {
    return RestaurantVisitsPage(
      onFetchRestaurants: ({
        String sortBy = 'lastVisit',
        String sortOrder = 'desc',
      }) {
        return onFetchRestaurants(
          sortBy: sortBy,
          sortOrder: sortOrder,
        );
      },
      onRestaurantTapped: onRestaurantTapped,
    );
  }
}

/// Standalone Journal Entry Detail Screen
class JournalEntryDetailScreen extends StatefulWidget {
  final int entryId;

  const JournalEntryDetailScreen({
    super.key,
    required this.entryId,
  });

  @override
  State<JournalEntryDetailScreen> createState() =>
      _JournalEntryDetailScreenState();
}

class _JournalEntryDetailScreenState extends State<JournalEntryDetailScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _entry;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEntry();
  }

  Future<void> _loadEntry() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await client.journalEntry.getEntry(entryId: widget.entryId);
      if (result['success'] == true) {
        setState(() {
          _entry = result['data'] as Map<String, dynamic>?;
        });
      } else {
        setState(() {
          _error = result['error'] as String? ?? 'Failed to load entry';
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal Entry'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              // Show delete confirmation
              _showDeleteDialog();
            },
          ),
        ],
      ),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(_error!),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: _loadEntry,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_entry == null) {
      return const Center(
        child: Text('Entry not found'),
      );
    }

    // Display entry details
    return SingleChildScrollView(
      padding: AppTheme.responsivePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Entry content would go here
          Text(
            'Entry #${widget.entryId}',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'Entry details would be displayed here.',
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry'),
        content: const Text(
          'Are you sure you want to delete this journal entry? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // Delete the entry
      try {
        await client.journalEntry.deleteEntry(entryId: widget.entryId);
        if (mounted) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Entry deleted'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete: $e'),
              backgroundColor: AppTheme.errorColor,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }
}

/// New Journal Entry Screen
class NewJournalEntryScreen extends StatefulWidget {
  final int? restaurantId;
  final String? restaurantName;

  const NewJournalEntryScreen({
    super.key,
    this.restaurantId,
    this.restaurantName,
  });

  @override
  State<NewJournalEntryScreen> createState() => _NewJournalEntryScreenState();
}

class _NewJournalEntryScreenState extends State<NewJournalEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  int _rating = 3;
  DateTime _visitedAt = DateTime.now();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (widget.restaurantId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a restaurant'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final result = await client.journalEntry.createEntry(
        restaurantId: widget.restaurantId!,
        rating: _rating,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        visitedAt: _visitedAt,
      );

      if (mounted) {
        if (result['success'] == true) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Entry saved'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['error'] as String? ?? 'Failed to save'),
              backgroundColor: AppTheme.errorColor,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final isTabletOrDesktop = size.width >= AppTheme.mobileBreakpoint;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Visit'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          FilledButton(
            onPressed: _isSubmitting ? null : _submit,
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Save'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: AppTheme.responsivePadding(context),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isTabletOrDesktop ? 600 : double.infinity,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Restaurant display
                  if (widget.restaurantName != null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withAlpha(26),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.restaurant,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Restaurant',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    widget.restaurantName!,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),

                  // Rating
                  Text(
                    'Rating',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _RatingSelector(
                    value: _rating,
                    onChanged: (value) => setState(() => _rating = value),
                  ),
                  const SizedBox(height: 24),

                  // Visit date
                  Text(
                    'Visit Date',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _DateSelector(
                    value: _visitedAt,
                    onChanged: (date) => setState(() => _visitedAt = date),
                  ),
                  const SizedBox(height: 24),

                  // Notes
                  Text(
                    'Notes (optional)',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: 'What did you enjoy? Any memorable dishes?',
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RatingSelector extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _RatingSelector({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        return IconButton(
          icon: Icon(
            starIndex <= value ? Icons.star : Icons.star_border,
            color: AppTheme.primaryColor,
            size: 36,
          ),
          onPressed: () => onChanged(starIndex),
        );
      }),
    );
  }
}

class _DateSelector extends StatelessWidget {
  final DateTime value;
  final ValueChanged<DateTime> onChanged;

  const _DateSelector({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: value,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          onChanged(date);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.grey.shade600),
            const SizedBox(width: 12),
            Text(
              '${value.month}/${value.day}/${value.year}',
              style: theme.textTheme.bodyLarge,
            ),
            const Spacer(),
            Icon(Icons.edit, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }
}
