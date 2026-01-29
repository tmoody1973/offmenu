import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/star_rating.dart';

/// Data model for a restaurant visit summary.
class RestaurantVisitSummary {
  final int restaurantId;
  final String restaurantName;
  final String restaurantAddress;
  final int visitCount;
  final double averageRating;
  final DateTime lastVisitDate;
  final String? thumbnailUrl;

  RestaurantVisitSummary({
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantAddress,
    required this.visitCount,
    required this.averageRating,
    required this.lastVisitDate,
    this.thumbnailUrl,
  });

  factory RestaurantVisitSummary.fromJson(Map<String, dynamic> json) {
    return RestaurantVisitSummary(
      restaurantId: json['restaurantId'] as int,
      restaurantName: json['restaurantName'] as String,
      restaurantAddress: json['restaurantAddress'] as String,
      visitCount: json['visitCount'] as int,
      averageRating: (json['averageRating'] as num).toDouble(),
      lastVisitDate: DateTime.parse(json['lastVisitDate'] as String),
      thumbnailUrl: json['thumbnailUrl'] as String?,
    );
  }
}

/// Sorting options for restaurant visits.
enum RestaurantSortOption {
  lastVisit,
  visitCount,
  rating,
}

/// A page displaying restaurants grouped by visits.
///
/// Shows all restaurants the user has visited with aggregate stats.
class RestaurantVisitsPage extends StatefulWidget {
  /// Callback to fetch visited restaurants.
  final Future<Map<String, dynamic>> Function({
    String sortBy,
    String sortOrder,
  })? onFetchRestaurants;

  /// Called when a restaurant is tapped.
  final void Function(int restaurantId)? onRestaurantTapped;

  const RestaurantVisitsPage({
    super.key,
    this.onFetchRestaurants,
    this.onRestaurantTapped,
  });

  @override
  State<RestaurantVisitsPage> createState() => _RestaurantVisitsPageState();
}

class _RestaurantVisitsPageState extends State<RestaurantVisitsPage> {
  final List<RestaurantVisitSummary> _restaurants = [];
  bool _isLoading = false;
  String? _errorMessage;
  RestaurantSortOption _sortOption = RestaurantSortOption.lastVisit;

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
  }

  Future<void> _loadRestaurants() async {
    if (widget.onFetchRestaurants == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await widget.onFetchRestaurants!(
        sortBy: _getSortBy(),
        sortOrder: 'desc',
      );

      if (result['success'] == true) {
        final data = result['data'] as Map<String, dynamic>;
        final restaurantsJson = data['restaurants'] as List<dynamic>;

        setState(() {
          _restaurants.clear();
          _restaurants.addAll(
            restaurantsJson.map((r) =>
                RestaurantVisitSummary.fromJson(r as Map<String, dynamic>)),
          );
        });
      } else {
        setState(() {
          _errorMessage =
              result['error'] as String? ?? 'Failed to load restaurants';
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

  String _getSortBy() {
    switch (_sortOption) {
      case RestaurantSortOption.visitCount:
        return 'visitCount';
      case RestaurantSortOption.rating:
        return 'rating';
      default:
        return 'lastVisit';
    }
  }

  void _updateSort(RestaurantSortOption option) {
    setState(() {
      _sortOption = option;
    });
    _loadRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Restaurants'),
        actions: [
          PopupMenuButton<RestaurantSortOption>(
            icon: const Icon(Icons.sort),
            onSelected: _updateSort,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: RestaurantSortOption.lastVisit,
                child: Row(
                  children: [
                    if (_sortOption == RestaurantSortOption.lastVisit)
                      const Icon(Icons.check, size: 18)
                    else
                      const SizedBox(width: 18),
                    const SizedBox(width: 8),
                    const Text('Most Recent'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: RestaurantSortOption.visitCount,
                child: Row(
                  children: [
                    if (_sortOption == RestaurantSortOption.visitCount)
                      const Icon(Icons.check, size: 18)
                    else
                      const SizedBox(width: 18),
                    const SizedBox(width: 8),
                    const Text('Most Visits'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: RestaurantSortOption.rating,
                child: Row(
                  children: [
                    if (_sortOption == RestaurantSortOption.rating)
                      const Icon(Icons.check, size: 18)
                    else
                      const SizedBox(width: 18),
                    const SizedBox(width: 8),
                    const Text('Highest Rated'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _restaurants.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null && _restaurants.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(_errorMessage!),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: _loadRestaurants,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_restaurants.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadRestaurants,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        itemCount: _restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = _restaurants[index];
          return _RestaurantCard(
            restaurant: restaurant,
            onTap: () =>
                widget.onRestaurantTapped?.call(restaurant.restaurantId),
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
          Icon(Icons.restaurant, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No restaurants visited yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Your visited restaurants will appear here.',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

/// Card widget for displaying a restaurant visit summary.
class _RestaurantCard extends StatelessWidget {
  final RestaurantVisitSummary restaurant;
  final VoidCallback? onTap;

  const _RestaurantCard({
    required this.restaurant,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMMMd();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            // Thumbnail
            SizedBox(
              width: 100,
              height: 100,
              child: _buildThumbnail(),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Restaurant name
                    Text(
                      restaurant.restaurantName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Address
                    Text(
                      restaurant.restaurantAddress,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Stats row
                    Row(
                      children: [
                        // Average rating
                        StarRating(
                          rating: restaurant.averageRating.round(),
                          readOnly: true,
                          starSize: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${restaurant.averageRating.toStringAsFixed(1)})',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Visit count and last visit
                    Row(
                      children: [
                        Icon(Icons.event_repeat,
                            size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          '${restaurant.visitCount} visit${restaurant.visitCount == 1 ? '' : 's'}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Last: ${dateFormat.format(restaurant.lastVisitDate.toLocal())}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Chevron
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.chevron_right, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    if (restaurant.thumbnailUrl != null) {
      return CachedNetworkImage(
        imageUrl: restaurant.thumbnailUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey.shade200,
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey.shade200,
          child: const Icon(Icons.restaurant, size: 40),
        ),
      );
    }

    return Container(
      color: Colors.grey.shade200,
      child: Icon(
        Icons.restaurant,
        size: 40,
        color: Colors.grey.shade400,
      ),
    );
  }
}
