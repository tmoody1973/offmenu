import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'star_rating.dart';

/// Data model for a journal entry to display in a card.
class JournalEntryCardData {
  final int id;
  final String restaurantName;
  final int rating;
  final DateTime visitedAt;
  final String? notes;
  final String? thumbnailUrl;
  final bool hasTourAssociation;

  JournalEntryCardData({
    required this.id,
    required this.restaurantName,
    required this.rating,
    required this.visitedAt,
    this.notes,
    this.thumbnailUrl,
    this.hasTourAssociation = false,
  });

  factory JournalEntryCardData.fromJson(Map<String, dynamic> json) {
    final photos = json['photos'] as List<dynamic>?;
    String? thumbnailUrl;
    if (photos != null && photos.isNotEmpty) {
      thumbnailUrl = photos.first['thumbnailUrl'] as String?;
    }

    final restaurant = json['restaurant'] as Map<String, dynamic>?;

    return JournalEntryCardData(
      id: json['id'] as int,
      restaurantName: restaurant?['name'] as String? ?? 'Unknown Restaurant',
      rating: json['rating'] as int,
      visitedAt: DateTime.parse(json['visitedAt'] as String),
      notes: json['notes'] as String?,
      thumbnailUrl: thumbnailUrl,
      hasTourAssociation: json['hasTourAssociation'] as bool? ?? false,
    );
  }
}

/// A card widget for displaying a journal entry in a list.
///
/// Shows thumbnail, restaurant name, rating, date, and notes preview.
class JournalEntryCard extends StatelessWidget {
  /// The entry data to display.
  final JournalEntryCardData entry;

  /// Called when the card is tapped.
  final VoidCallback? onTap;

  const JournalEntryCard({
    super.key,
    required this.entry,
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
        child: SizedBox(
          height: 120,
          child: Row(
            children: [
              // Thumbnail
              SizedBox(
                width: 120,
                height: 120,
                child: _buildThumbnail(),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Restaurant name with tour badge
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              entry.restaurantName,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (entry.hasTourAssociation) _buildTourBadge(theme),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Rating and date
                      Row(
                        children: [
                          StarRating(
                            rating: entry.rating,
                            readOnly: true,
                            starSize: 16,
                          ),
                          const Spacer(),
                          Text(
                            dateFormat.format(entry.visitedAt.toLocal()),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Notes preview
                      if (entry.notes != null && entry.notes!.isNotEmpty)
                        Expanded(
                          child: Text(
                            entry.notes!,
                            style: theme.textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    if (entry.thumbnailUrl != null) {
      return CachedNetworkImage(
        imageUrl: entry.thumbnailUrl!,
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

  Widget _buildTourBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.tour,
            size: 12,
            color: theme.colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 2),
          Text(
            'Tour',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
