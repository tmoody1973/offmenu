import 'package:flutter/material.dart';
import 'package:food_butler_client/food_butler_client.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';
import '../theme/app_theme.dart';
import '../widgets/eater_style_widgets.dart';

/// Screen displaying the user's saved/bookmarked restaurants.
///
/// Allows viewing, editing notes, and removing saved restaurants.
class SavedRestaurantsScreen extends StatefulWidget {
  const SavedRestaurantsScreen({super.key});

  @override
  State<SavedRestaurantsScreen> createState() => _SavedRestaurantsScreenState();
}

class _SavedRestaurantsScreenState extends State<SavedRestaurantsScreen> {
  List<SavedRestaurant> _restaurants = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSavedRestaurants();
  }

  Future<void> _loadSavedRestaurants() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final restaurants = await client.savedRestaurant.getSavedRestaurants();
      if (mounted) {
        setState(() {
          _restaurants = restaurants;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load saved restaurants: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _unsaveRestaurant(SavedRestaurant restaurant) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.charcoalLight,
        title: Text(
          'Remove from Saved',
          style: AppTheme.headlineSans.copyWith(fontSize: 20),
        ),
        content: Text(
          'Remove "${restaurant.name}" from your saved restaurants?',
          style: AppTheme.bodySans.copyWith(color: AppTheme.creamMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: AppTheme.labelSans.copyWith(color: AppTheme.creamMuted),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.burntOrange,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final success = await client.savedRestaurant.unsaveRestaurant(
          id: restaurant.id,
        );
        if (success && mounted) {
          setState(() {
            _restaurants.removeWhere((r) => r.id == restaurant.id);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Removed "${restaurant.name}"'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to remove: $e'),
              backgroundColor: AppTheme.errorColor,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  Future<void> _editNotes(SavedRestaurant restaurant) async {
    final notesController = TextEditingController(text: restaurant.notes);
    int rating = restaurant.userRating ?? 0;

    final result = await showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppTheme.charcoalLight,
          title: Text(
            'Edit Notes',
            style: AppTheme.headlineSans.copyWith(fontSize: 20),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name,
                  style: AppTheme.bodySans.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your Rating',
                  style: AppTheme.labelSans.copyWith(
                    fontSize: 12,
                    color: AppTheme.creamMuted,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starIndex = index + 1;
                    return IconButton(
                      icon: Icon(
                        starIndex <= rating ? Icons.star : Icons.star_border,
                        color: AppTheme.burntOrange,
                        size: 32,
                      ),
                      onPressed: () {
                        setDialogState(() {
                          rating = rating == starIndex ? 0 : starIndex;
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 16),
                Text(
                  'Notes',
                  style: AppTheme.labelSans.copyWith(
                    fontSize: 12,
                    color: AppTheme.creamMuted,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: notesController,
                  maxLines: 4,
                  style: AppTheme.bodySans,
                  decoration: InputDecoration(
                    hintText: 'Add your notes about this restaurant...',
                    hintStyle: AppTheme.bodySans.copyWith(
                      color: AppTheme.creamMuted.withAlpha(100),
                    ),
                    filled: true,
                    fillColor: AppTheme.charcoal,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppTheme.borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppTheme.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppTheme.burntOrange),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text(
                'Cancel',
                style: AppTheme.labelSans.copyWith(color: AppTheme.creamMuted),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop({
                'notes': notesController.text,
                'rating': rating,
              }),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.burntOrange,
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );

    if (result != null && mounted) {
      try {
        final updated = await client.savedRestaurant.updateSavedRestaurant(
          id: restaurant.id!,
          notes: result['notes'] as String?,
          userRating: result['rating'] as int?,
        );
        if (updated != null && mounted) {
          setState(() {
            final index = _restaurants.indexWhere((r) => r.id == restaurant.id);
            if (index != -1) {
              _restaurants[index] = updated;
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notes updated'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update: $e'),
              backgroundColor: AppTheme.errorColor,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.charcoal,
      appBar: AppBar(
        backgroundColor: AppTheme.charcoal,
        title: Text(
          'Saved Restaurants',
          style: AppTheme.headlineSans.copyWith(fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.cream),
          onPressed: () => context.pop(),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.burntOrange),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.creamMuted,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: AppTheme.bodySans.copyWith(color: AppTheme.creamMuted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: _loadSavedRestaurants,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_restaurants.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.favorite_border,
                size: 80,
                color: AppTheme.creamMuted,
              ),
              const SizedBox(height: 24),
              Text(
                'No Saved Restaurants',
                style: AppTheme.headlineSans.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 12),
              Text(
                'Tap the heart icon on any restaurant to save it for later.',
                style: AppTheme.bodySans.copyWith(
                  color: AppTheme.creamMuted,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () => context.go('/maps'),
                icon: const Icon(Icons.map),
                label: const Text('Browse Maps'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.burntOrange,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadSavedRestaurants,
      color: AppTheme.burntOrange,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        itemCount: _restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = _restaurants[index];
          return _SavedRestaurantCard(
            restaurant: restaurant,
            onEdit: () => _editNotes(restaurant),
            onRemove: () => _unsaveRestaurant(restaurant),
          );
        },
      ),
    );
  }
}

/// Card displaying a saved restaurant with actions.
class _SavedRestaurantCard extends StatelessWidget {
  final SavedRestaurant restaurant;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const _SavedRestaurantCard({
    required this.restaurant,
    required this.onEdit,
    required this.onRemove,
  });

  String _getSourceLabel(SavedRestaurantSource source) {
    switch (source) {
      case SavedRestaurantSource.map:
        return 'FROM MAP';
      case SavedRestaurantSource.askButler:
        return 'ASK THE BUTLER';
      case SavedRestaurantSource.story:
        return 'DAILY STORY';
      case SavedRestaurantSource.tonight:
        return 'THREE FOR TONIGHT';
      case SavedRestaurantSource.search:
        return 'SEARCH';
      case SavedRestaurantSource.other:
        return 'SAVED';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Today';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.charcoalLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image (if available)
          if (restaurant.imageUrl != null)
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(11)),
              child: Image.network(
                restaurant.imageUrl!,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 100,
                  color: AppTheme.charcoal,
                  child: const Center(
                    child: Icon(
                      Icons.restaurant,
                      size: 40,
                      color: AppTheme.creamMuted,
                    ),
                  ),
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Source tag and date
                Row(
                  children: [
                    EaterTag(
                      label: _getSourceLabel(restaurant.source),
                      color: AppTheme.creamMuted,
                    ),
                    const Spacer(),
                    Text(
                      _formatDate(restaurant.savedAt),
                      style: AppTheme.labelSans.copyWith(
                        fontSize: 12,
                        color: AppTheme.creamMuted,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Restaurant name
                Text(
                  restaurant.name,
                  style: AppTheme.headlineSerif.copyWith(
                    fontSize: 20,
                    color: AppTheme.cream,
                  ),
                ),

                // Cuisine and price
                if (restaurant.cuisineType != null ||
                    restaurant.priceLevel != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (restaurant.cuisineType != null)
                        Text(
                          restaurant.cuisineType!,
                          style: AppTheme.labelSans.copyWith(
                            fontSize: 12,
                            color: AppTheme.creamMuted,
                          ),
                        ),
                      if (restaurant.cuisineType != null &&
                          restaurant.priceLevel != null)
                        Text(
                          '  \u2022  ',
                          style: AppTheme.labelSans.copyWith(
                            color: AppTheme.creamMuted.withAlpha(100),
                          ),
                        ),
                      if (restaurant.priceLevel != null) ...[
                        Text(
                          '\$' * restaurant.priceLevel!,
                          style: AppTheme.labelSans.copyWith(
                            fontSize: 12,
                            color: AppTheme.agedBrass,
                          ),
                        ),
                        Text(
                          '\$' * (4 - restaurant.priceLevel!),
                          style: AppTheme.labelSans.copyWith(
                            fontSize: 12,
                            color: AppTheme.creamMuted.withAlpha(50),
                          ),
                        ),
                      ],
                      if (restaurant.rating != null) ...[
                        Text(
                          '  \u2022  ',
                          style: AppTheme.labelSans.copyWith(
                            color: AppTheme.creamMuted.withAlpha(100),
                          ),
                        ),
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: AppTheme.agedBrass,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          restaurant.rating!.toStringAsFixed(1),
                          style: AppTheme.labelSans.copyWith(
                            fontSize: 12,
                            color: AppTheme.creamMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],

                // Address
                if (restaurant.address != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppTheme.creamMuted,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          restaurant.address!,
                          style: AppTheme.bodySans.copyWith(
                            fontSize: 13,
                            color: AppTheme.creamMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],

                // User rating
                if (restaurant.userRating != null &&
                    restaurant.userRating! > 0) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'Your Rating: ',
                        style: AppTheme.labelSans.copyWith(
                          fontSize: 12,
                          color: AppTheme.creamMuted,
                        ),
                      ),
                      ...List.generate(5, (index) {
                        return Icon(
                          index < restaurant.userRating!
                              ? Icons.star
                              : Icons.star_border,
                          size: 16,
                          color: AppTheme.burntOrange,
                        );
                      }),
                    ],
                  ),
                ],

                // Notes
                if (restaurant.notes != null &&
                    restaurant.notes!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.charcoal,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.note,
                          size: 16,
                          color: AppTheme.creamMuted,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            restaurant.notes!,
                            style: AppTheme.bodySans.copyWith(
                              fontSize: 13,
                              color: AppTheme.cream,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Notes'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.cream,
                          side: BorderSide(color: AppTheme.borderColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: onRemove,
                      icon: const Icon(
                        Icons.favorite,
                        color: AppTheme.burntOrange,
                      ),
                      tooltip: 'Remove from saved',
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
}
