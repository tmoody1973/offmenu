import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_butler_client/food_butler_client.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../map/models/tour_stop_marker.dart';
import '../map/widgets/award_badge.dart';
import '../map/widgets/tour_map_view.dart';
import '../theme/app_theme.dart';

/// Documentary-style tour results screen displaying the generated tour.
///
/// Features:
/// - Hero section with tour title, vibe, and introduction
/// - Expandable story cards for each stop
/// - Narrative transitions between stops
/// - Closing narrative wrap-up
/// - Navigation integration
class TourResultsScreen extends StatefulWidget {
  final TourResult tourResult;
  final TransportMode transportMode;

  const TourResultsScreen({
    super.key,
    required this.tourResult,
    required this.transportMode,
  });

  @override
  State<TourResultsScreen> createState() => _TourResultsScreenState();
}

class _TourResultsScreenState extends State<TourResultsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<_EnrichedStop> _stops = [];
  final Set<int> _expandedStops = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _parseStops();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _parseStops() {
    try {
      final stopsJson =
          jsonDecode(widget.tourResult.stopsJson) as List<dynamic>;
      _stops = stopsJson.asMap().entries.map((entry) {
        final index = entry.key;
        final stopData = entry.value as Map<String, dynamic>;
        return _EnrichedStop(
          marker: TourStopMarker(
            id: '${stopData['name']}_$index',
            stopNumber: index + 1,
            latitude: (stopData['latitude'] as num).toDouble(),
            longitude: (stopData['longitude'] as num).toDouble(),
            name: stopData['name'] as String,
            address: stopData['address'] as String,
            cuisineType: (stopData['cuisineTypes'] as List<dynamic>?)?.isNotEmpty == true
                ? (stopData['cuisineTypes'] as List<dynamic>).first as String
                : null,
            awardBadges: List<String>.from(stopData['awardBadges'] ?? []),
            isCurrent: index == 0,
          ),
          priceTier: stopData['priceTier'] as int? ?? 2,
          story: stopData['story'] as String?,
          signatureDish: stopData['signatureDish'] as String?,
          dishStory: stopData['dishStory'] as String?,
          insiderTip: stopData['insiderTip'] as String?,
          transitionToNext: stopData['transitionToNext'] as String?,
          minutesToSpend: stopData['minutesToSpend'] as int? ?? 45,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error parsing stops: $e');
    }
  }

  void _onRestaurantSelect(TourStopMarker stop) {
    context.push('/restaurant/${stop.id}', extra: {'stop': stop});
  }

  Future<void> _navigateToStop(_EnrichedStop stop) async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=${stop.marker.latitude},${stop.marker.longitude}'
      '&travelmode=${widget.transportMode == TransportMode.walking ? 'walking' : 'driving'}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _startTour() async {
    if (_stops.isEmpty) return;
    await _navigateToStop(_stops.first);
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String _formatDistance(int meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
    return '$meters m';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isTabletOrDesktop = size.width >= AppTheme.mobileBreakpoint;

    // Use tour title from curated tour, or fallback
    final tourTitle = widget.tourResult.tourTitle ?? 'Your Food Tour';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tourTitle,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share tour',
            onPressed: () {
              // Share functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            tooltip: 'Save tour',
            onPressed: () {
              // Save functionality
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.map_outlined), text: 'Map'),
            Tab(icon: Icon(Icons.auto_stories), text: 'Journey'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Map view
          _MapTab(
            tourResult: widget.tourResult,
            transportMode: widget.transportMode,
            onRestaurantSelect: _onRestaurantSelect,
          ),

          // Documentary-style stops view
          _JourneyTab(
            stops: _stops,
            tourResult: widget.tourResult,
            expandedStops: _expandedStops,
            onToggleExpand: (index) {
              setState(() {
                if (_expandedStops.contains(index)) {
                  _expandedStops.remove(index);
                } else {
                  _expandedStops.add(index);
                }
              });
            },
            onNavigate: _navigateToStop,
            formatDuration: _formatDuration,
            formatDistance: _formatDistance,
            onRestaurantTap: (stop) => _onRestaurantSelect(stop.marker),
          ),
        ],
      ),
      bottomNavigationBar: isTabletOrDesktop
          ? null
          : _TourSummaryBar(
              tourResult: widget.tourResult,
              formatDuration: _formatDuration,
              formatDistance: _formatDistance,
              onStartTour: _startTour,
            ),
    );
  }
}

/// Enriched stop data with narrative fields.
class _EnrichedStop {
  final TourStopMarker marker;
  final int priceTier;
  final String? story;
  final String? signatureDish;
  final String? dishStory;
  final String? insiderTip;
  final String? transitionToNext;
  final int minutesToSpend;

  _EnrichedStop({
    required this.marker,
    required this.priceTier,
    this.story,
    this.signatureDish,
    this.dishStory,
    this.insiderTip,
    this.transitionToNext,
    required this.minutesToSpend,
  });

  bool get hasNarrative =>
      story != null || signatureDish != null || dishStory != null || insiderTip != null;
}

class _MapTab extends StatelessWidget {
  final TourResult tourResult;
  final TransportMode transportMode;
  final void Function(TourStopMarker) onRestaurantSelect;

  const _MapTab({
    required this.tourResult,
    required this.transportMode,
    required this.onRestaurantSelect,
  });

  @override
  Widget build(BuildContext context) {
    return TourMapView(
      tourData: tourResult,
      transportMode: transportMode,
      onRestaurantSelect: onRestaurantSelect,
    );
  }
}

class _JourneyTab extends StatelessWidget {
  final List<_EnrichedStop> stops;
  final TourResult tourResult;
  final Set<int> expandedStops;
  final void Function(int) onToggleExpand;
  final void Function(_EnrichedStop) onNavigate;
  final String Function(int) formatDuration;
  final String Function(int) formatDistance;
  final void Function(_EnrichedStop) onRestaurantTap;

  const _JourneyTab({
    required this.stops,
    required this.tourResult,
    required this.expandedStops,
    required this.onToggleExpand,
    required this.onNavigate,
    required this.formatDuration,
    required this.formatDistance,
    required this.onRestaurantTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isTabletOrDesktop = size.width >= AppTheme.mobileBreakpoint;

    return CustomScrollView(
      slivers: [
        // Tour summary card (on tablet/desktop)
        if (isTabletOrDesktop)
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: _TourSummaryCard(
                tourResult: tourResult,
                formatDuration: formatDuration,
                formatDistance: formatDistance,
              ),
            ),
          ),

        // Hero section with tour title, vibe, and introduction
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          sliver: SliverToBoxAdapter(
            child: _TourHeroSection(tourResult: tourResult),
          ),
        ),

        // Warning message if partial tour
        if (tourResult.isPartialTour && tourResult.warningMessage != null)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            sliver: SliverToBoxAdapter(
              child: Card(
                color: Colors.orange.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          color: Colors.orange.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          tourResult.warningMessage!,
                          style: TextStyle(color: Colors.orange.shade900),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        // Stops list with expandable story cards
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                // Interleave stops with transition text
                final stopIndex = index ~/ 2;
                final isTransition = index.isOdd;

                if (isTransition) {
                  // Transition text between stops
                  if (stopIndex < stops.length) {
                    final stop = stops[stopIndex];
                    if (stop.transitionToNext != null &&
                        stopIndex < stops.length - 1) {
                      return _TransitionText(
                        text: stop.transitionToNext!,
                        transportMode: TransportMode.walking,
                      );
                    }
                  }
                  return const SizedBox(height: 8);
                }

                // Stop card
                if (stopIndex >= stops.length) return null;
                final stop = stops[stopIndex];
                return _ExpandableStopCard(
                  stop: stop,
                  isExpanded: expandedStops.contains(stopIndex),
                  onToggleExpand: () => onToggleExpand(stopIndex),
                  onNavigate: () => onNavigate(stop),
                  onTap: () => onRestaurantTap(stop),
                );
              },
              childCount: stops.length * 2 - 1,
            ),
          ),
        ),

        // Tour closing section
        if (tourResult.tourClosing != null)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            sliver: SliverToBoxAdapter(
              child: _TourClosingSection(closing: tourResult.tourClosing!),
            ),
          ),

        // Bottom padding
        const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
      ],
    );
  }
}

/// Hero section displaying tour title, vibe, and opening narrative.
class _TourHeroSection extends StatelessWidget {
  final TourResult tourResult;

  const _TourHeroSection({required this.tourResult});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // If no curated data, show nothing
    if (tourResult.tourTitle == null && tourResult.tourIntroduction == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withAlpha(20),
            AppTheme.primaryColor.withAlpha(5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryColor.withAlpha(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vibe subtitle
          if (tourResult.tourVibe != null) ...[
            Row(
              children: [
                Icon(Icons.auto_awesome, color: AppTheme.primaryColor, size: 16),
                const SizedBox(width: 6),
                Text(
                  tourResult.tourVibe!.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],

          // Tour title
          if (tourResult.tourTitle != null)
            Text(
              tourResult.tourTitle!,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade900,
              ),
            ),

          // Introduction narrative
          if (tourResult.tourIntroduction != null) ...[
            const SizedBox(height: 16),
            Text(
              tourResult.tourIntroduction!,
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.6,
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Expandable stop card with documentary-style content.
class _ExpandableStopCard extends StatelessWidget {
  final _EnrichedStop stop;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final VoidCallback onNavigate;
  final VoidCallback onTap;

  const _ExpandableStopCard({
    required this.stop,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.onNavigate,
    required this.onTap,
  });

  String _getPriceString(int priceTier) {
    return '\$' * priceTier.clamp(1, 4);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final marker = stop.marker;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: isExpanded ? 4 : 1,
      child: Column(
        children: [
          // Collapsed header - always visible
          InkWell(
            onTap: stop.hasNarrative ? onToggleExpand : onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stop number badge
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${marker.stopNumber}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Name, cuisine, neighborhood, price
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          marker.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            if (marker.cuisineType != null) ...[
                              Text(
                                marker.cuisineType!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              Text(' • ',
                                  style: TextStyle(color: Colors.grey.shade400)),
                            ],
                            Text(
                              _getPriceString(stop.priceTier),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (stop.minutesToSpend > 0) ...[
                              Text(' • ',
                                  style: TextStyle(color: Colors.grey.shade400)),
                              Icon(Icons.schedule,
                                  size: 14, color: Colors.grey.shade500),
                              const SizedBox(width: 2),
                              Text(
                                '${stop.minutesToSpend} min',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ],
                        ),

                        // Award badges
                        if (marker.awardBadges.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: marker.awardBadges.map((badge) {
                              return AwardBadge.fromString(badge);
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Expand indicator
                  if (stop.hasNarrative)
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.expand_more,
                        color: Colors.grey.shade400,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Expanded content - narrative details
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: _ExpandedContent(
              stop: stop,
              onNavigate: onNavigate,
            ),
            crossFadeState:
                isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}

/// Expanded content showing story, dish story, and insider tip.
class _ExpandedContent extends StatelessWidget {
  final _EnrichedStop stop;
  final VoidCallback onNavigate;

  const _ExpandedContent({
    required this.stop,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant story
          if (stop.story != null) ...[
            Text(
              stop.story!,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.5,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Signature dish section
          if (stop.signatureDish != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.restaurant_menu,
                          color: AppTheme.primaryColor, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Must Order',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    stop.signatureDish!,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (stop.dishStory != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      stop.dishStory!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Insider tip
          if (stop.insiderTip != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline,
                      color: Color(0xFFB45309), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Insider Tip',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: const Color(0xFFB45309),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          stop.insiderTip!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF78350F),
                            fontStyle: FontStyle.italic,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onNavigate,
                  icon: const Icon(Icons.navigation_outlined, size: 18),
                  label: const Text('Navigate'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Mark as arrived / visited
                  },
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text("I'm Here"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Transition text between stops.
class _TransitionText extends StatelessWidget {
  final String text;
  final TransportMode transportMode;

  const _TransitionText({
    required this.text,
    required this.transportMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 2,
                height: 12,
                color: Colors.grey.shade300,
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  transportMode == TransportMode.walking
                      ? Icons.directions_walk
                      : Icons.directions_car,
                  size: 16,
                  color: Colors.grey.shade500,
                ),
              ),
              Container(
                width: 2,
                height: 12,
                color: Colors.grey.shade300,
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Closing section wrapping up the tour experience.
class _TourClosingSection extends StatelessWidget {
  final String closing;

  const _TourClosingSection({required this.closing});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.celebration_outlined, color: AppTheme.primaryColor, size: 32),
          const SizedBox(height: 12),
          Text(
            'Your Journey Awaits',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            closing,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.6,
              color: Colors.grey.shade700,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _TourSummaryCard extends StatelessWidget {
  final TourResult tourResult;
  final String Function(int) formatDuration;
  final String Function(int) formatDistance;

  const _TourSummaryCard({
    required this.tourResult,
    required this.formatDuration,
    required this.formatDistance,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _SummaryItem(
              icon: Icons.timer_outlined,
              label: 'Duration',
              value: formatDuration(tourResult.totalDurationSeconds),
            ),
            _SummaryItem(
              icon: Icons.straighten,
              label: 'Distance',
              value: formatDistance(tourResult.totalDistanceMeters),
            ),
            _SummaryItem(
              icon: Icons.restaurant,
              label: 'Stops',
              value: '${_countStops(tourResult.stopsJson)}',
            ),
            _SummaryItem(
              icon: Icons.verified,
              label: 'Match',
              value: '${tourResult.confidenceScore}%',
            ),
          ],
        ),
      ),
    );
  }

  int _countStops(String stopsJson) {
    try {
      final stops = jsonDecode(stopsJson) as List<dynamic>;
      return stops.length;
    } catch (e) {
      return 0;
    }
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.grey.shade600, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

class _TourSummaryBar extends StatelessWidget {
  final TourResult tourResult;
  final String Function(int) formatDuration;
  final String Function(int) formatDistance;
  final VoidCallback onStartTour;

  const _TourSummaryBar({
    required this.tourResult,
    required this.formatDuration,
    required this.formatDistance,
    required this.onStartTour,
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _BottomSummaryItem(
              icon: Icons.timer_outlined,
              value: formatDuration(tourResult.totalDurationSeconds),
            ),
            _BottomSummaryItem(
              icon: Icons.straighten,
              value: formatDistance(tourResult.totalDistanceMeters),
            ),
            FilledButton.icon(
              onPressed: onStartTour,
              icon: const Icon(Icons.navigation_outlined, size: 20),
              label: const Text('Start Tour'),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomSummaryItem extends StatelessWidget {
  final IconData icon;
  final String value;

  const _BottomSummaryItem({
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
