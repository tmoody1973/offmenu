import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../map/models/tour_stop_marker.dart';
import '../map/widgets/award_badge.dart';
import '../theme/app_theme.dart';

/// Restaurant detail screen showing full restaurant information.
///
/// Features:
/// - Full restaurant info
/// - Award badges
/// - LLM narrative description
/// - Reserve button
/// - "Log Visit" button for journal
class RestaurantDetailScreen extends StatefulWidget {
  final TourStopMarker? stop;
  final int? restaurantId;

  const RestaurantDetailScreen({
    super.key,
    this.stop,
    this.restaurantId,
  });

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  bool _isLoadingDescription = false;
  String? _description;

  @override
  void initState() {
    super.initState();
    _loadDescription();
  }

  Future<void> _loadDescription() async {
    setState(() => _isLoadingDescription = true);

    // In production, this would fetch from the narrative endpoint
    // For now, we simulate with static content
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _isLoadingDescription = false;
        _description = widget.stop != null
            ? 'A culinary gem that showcases the best of ${widget.stop!.cuisineType ?? "contemporary"} cuisine. '
                'Known for exceptional attention to detail and warm hospitality, this restaurant '
                'offers an unforgettable dining experience that celebrates fresh, seasonal ingredients.'
            : null;
      });
    }
  }

  void _navigateToJournal() {
    // Navigate to journal entry form with restaurant pre-filled
    context.push('/journal/new', extra: {
      'restaurantId': widget.restaurantId,
      'restaurantName': widget.stop?.name,
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final isTabletOrDesktop = size.width >= AppTheme.mobileBreakpoint;

    if (widget.stop == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(
          child: Text('Restaurant not found'),
        ),
      );
    }

    final stop = widget.stop!;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with hero image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(77),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(77),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share, color: Colors.white),
                ),
                onPressed: () {
                  // Share functionality
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: stop.photoUrl != null
                  ? CachedNetworkImage(
                      imageUrl: stop.photoUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => _buildPlaceholderImage(),
                    )
                  : _buildPlaceholderImage(),
            ),
          ),

          // Content
          SliverPadding(
            padding: AppTheme.responsivePadding(context),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isTabletOrDesktop ? 700 : double.infinity,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stop badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Stop ${stop.stopNumber}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Restaurant name
                      Text(
                        stop.name,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Cuisine type
                      if (stop.cuisineType != null)
                        Text(
                          stop.cuisineType!,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      const SizedBox(height: 8),

                      // Address with map link
                      InkWell(
                        onTap: () {
                          // Open in maps
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 18,
                                color: AppTheme.secondaryColor,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  stop.address,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.secondaryColor,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.open_in_new,
                                size: 16,
                                color: AppTheme.secondaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Award badges
                      if (stop.awardBadges.isNotEmpty) ...[
                        const _SectionTitle(title: 'Awards & Recognition'),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: stop.awardBadges.map((badge) {
                            return AwardBadge.fromString(
                              badge,
                              size: AwardBadgeSize.expanded,
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Description
                      const _SectionTitle(title: 'About'),
                      const SizedBox(height: 8),
                      if (_isLoadingDescription)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (_description != null)
                        Text(
                          _description!,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.6,
                          ),
                        )
                      else
                        Text(
                          'No description available.',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      const SizedBox(height: 24),

                      // Contact info section
                      const _SectionTitle(title: 'Contact & Details'),
                      const SizedBox(height: 12),
                      const _ContactInfoCard(),
                      const SizedBox(height: 24),

                      // Opening hours placeholder
                      const _SectionTitle(title: 'Hours'),
                      const SizedBox(height: 8),
                      const _HoursCard(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _ActionBar(
        onReserve: () {
          // Open reservation
        },
        onLogVisit: _navigateToJournal,
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: Icon(
          Icons.restaurant,
          size: 80,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _ContactInfoCard extends StatelessWidget {
  const _ContactInfoCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _ContactRow(
            icon: Icons.phone_outlined,
            label: 'Phone',
            value: '(555) 123-4567',
            onTap: () {
              // Call phone
            },
          ),
          const Divider(height: 1),
          _ContactRow(
            icon: Icons.language_outlined,
            label: 'Website',
            value: 'Visit website',
            onTap: () {
              // Open website
            },
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey.shade600, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.secondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}

class _HoursCard extends StatelessWidget {
  const _HoursCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Placeholder hours data
    final hours = [
      ('Monday', '5:00 PM - 10:00 PM'),
      ('Tuesday', '5:00 PM - 10:00 PM'),
      ('Wednesday', '5:00 PM - 10:00 PM'),
      ('Thursday', '5:00 PM - 10:00 PM'),
      ('Friday', '5:00 PM - 11:00 PM'),
      ('Saturday', '5:00 PM - 11:00 PM'),
      ('Sunday', '4:00 PM - 9:00 PM'),
    ];

    final today = DateTime.now().weekday - 1;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: hours.asMap().entries.map((entry) {
            final index = entry.key;
            final day = entry.value.$1;
            final time = entry.value.$2;
            final isToday = index == today;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    day,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: isToday ? FontWeight.bold : null,
                      color: isToday ? AppTheme.primaryColor : null,
                    ),
                  ),
                  Text(
                    time,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: isToday ? FontWeight.bold : null,
                      color: isToday
                          ? AppTheme.primaryColor
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  final VoidCallback onReserve;
  final VoidCallback onLogVisit;

  const _ActionBar({
    required this.onReserve,
    required this.onLogVisit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Log visit button
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onLogVisit,
                icon: const Icon(Icons.edit_note),
                label: const Text('Log Visit'),
              ),
            ),
            const SizedBox(width: 12),

            // Reserve button
            Expanded(
              flex: 2,
              child: FilledButton.icon(
                onPressed: onReserve,
                icon: const Icon(Icons.calendar_today),
                label: const Text('Make Reservation'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFDA3743),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
