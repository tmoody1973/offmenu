import 'package:flutter/material.dart';

import '../models/tour_stop_marker.dart';
import 'award_badge.dart';

/// Callback for when "View Details" is tapped.
typedef OnViewDetailsCallback = void Function(TourStopMarker stop);

/// A bottom sheet that displays restaurant information when a marker is tapped.
///
/// Features:
/// - Restaurant name, stop number, cuisine type
/// - Award badges (James Beard, Michelin)
/// - Mini-photo thumbnail from Cloudflare R2
/// - "View Details" button
/// - Dismissible via swipe-down or tap-outside
class RestaurantInfoBottomSheet extends StatelessWidget {
  /// The tour stop data to display.
  final TourStopMarker stop;

  /// Callback when "View Details" is tapped.
  final OnViewDetailsCallback? onViewDetails;

  /// Callback when the sheet is dismissed.
  final VoidCallback? onDismiss;

  const RestaurantInfoBottomSheet({
    super.key,
    required this.stop,
    this.onViewDetails,
    this.onDismiss,
  });

  /// Shows the bottom sheet as a modal.
  static Future<void> show(
    BuildContext context, {
    required TourStopMarker stop,
    OnViewDetailsCallback? onViewDetails,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RestaurantInfoBottomSheet(
        stop: stop,
        onViewDetails: onViewDetails,
        onDismiss: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {}, // Prevent dismissal when tapping the sheet
          child: DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.2,
            maxChildSize: 0.5,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Drag handle
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Main content row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Thumbnail image
                            _buildThumbnail(),
                            const SizedBox(width: 12),

                            // Text content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Stop number badge
                                  _buildStopBadge(),
                                  const SizedBox(height: 4),

                                  // Restaurant name
                                  Text(
                                    stop.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),

                                  // Cuisine type
                                  if (stop.cuisineType != null)
                                    Text(
                                      stop.cuisineType!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),

                                  // Address
                                  Text(
                                    stop.address,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Award badges
                        if (stop.awardBadges.isNotEmpty) ...[
                          _buildAwardBadges(),
                          const SizedBox(height: 16),
                        ],

                        // View Details button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => onViewDetails?.call(stop),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'View Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    const size = 80.0;

    if (stop.photoUrl != null && stop.photoUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          stop.photoUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _buildPlaceholder(size);
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder(size);
          },
        ),
      );
    }

    return _buildPlaceholder(size);
  }

  Widget _buildPlaceholder(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.restaurant_rounded,
        size: 32,
        color: Colors.grey[400],
      ),
    );
  }

  Widget _buildStopBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF97316),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Stop ${stop.stopNumber}',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildAwardBadges() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: stop.awardBadges.map((badge) {
        return AwardBadge.fromString(badge);
      }).toList(),
    );
  }
}
