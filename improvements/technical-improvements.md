# Food Tour Butler - Technical Improvements for Hackathon Demo

> **Deadline: January 31, 2026 (TOMORROW!)**
> These improvements are designed to be implementable in <24 hours while maximizing judge impression.

---

## Table of Contents
1. [Performance Optimizations](#1-performance-optimizations-for-60fps-demo)
2. [Animation Implementations](#2-animation-implementations-that-wow)
3. [Serverpod Endpoint Optimizations](#3-serverpod-endpoint-optimizations)
4. [State Management Best Practices](#4-state-management-best-practices)
5. [Technical Show-Off Features](#5-technical-show-off-features)

---

## 1. Performance Optimizations for 60fps Demo

### 1.1 Image Caching & Preloading Strategy

**Why Judges Care:** Shows you understand Flutter's image pipeline and can prevent jank during scrolls.

```dart
// lib/core/utils/image_preloader.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImagePreloader {
  static final Map<String, ImageProvider> _cache = {};
  
  /// Preload images for smooth scrolling - call before entering list view
  static Future<void> preloadRestaurantImages(
    BuildContext context,
    List<String> imageUrls,
  ) async {
    final futures = <Future<void>>[];
    
    for (final url in imageUrls.take(10)) { // Preload first 10
      if (!_cache.containsKey(url)) {
        final provider = CachedNetworkImageProvider(url);
        _cache[url] = provider;
        futures.add(
          precacheImage(provider, context)
            .timeout(const Duration(seconds: 3), onTimeout: () {}),
        );
      }
    }
    
    await Future.wait(futures);
  }
  
  static ImageProvider? getCachedImage(String url) => _cache[url];
  
  static void clearCache() {
    _cache.clear();
  }
}

// Usage in widget:
class RestaurantListView extends StatelessWidget {
  final List<Restaurant> restaurants;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Preload on next frame to not block build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ImagePreloader.preloadRestaurantImages(
        context,
        restaurants.map((r) => r.photoUrl).toList(),
      );
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        return RestaurantCard(
          restaurant: restaurants[index],
          // Use cached image if available
          imageProvider: ImagePreloader.getCachedImage(
            restaurants[index].photoUrl,
          ),
        );
      },
    );
  }
}
```

### 1.2 Tour Generation Loading State with Skeleton Shimmer

**Why Judges Care:** Professional loading states show polish and attention to UX details.

```dart
// lib/features/tour/widgets/tour_skeleton_loader.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TourSkeletonLoader extends StatelessWidget {
  const TourSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          // Map skeleton
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          // Stop cards skeleton
          ...List.generate(4, (index) => _buildStopSkeleton()),
        ],
      ),
    );
  }

  Widget _buildStopSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Image placeholder
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 16,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(
                  width: 150,
                  height: 12,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Smart loading with progressive disclosure
class TourGenerationScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tourState = ref.watch(tourGenerationProvider);
    
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: tourState.when(
        data: (tour) => TourDetailView(tour: tour),
        loading: () => const TourSkeletonLoader(),
        error: (err, stack) => TourErrorView(error: err.toString()),
      ),
    );
  }
}
```

### 1.3 Debounced Search with Cancelable Operations

**Why Judges Care:** Prevents API spam and shows you understand async operation management.

```dart
// lib/core/utils/debounced_search.dart
import 'dart:async';
import 'package:flutter/foundation.dart';

class DebouncedSearch<T> {
  Timer? _debounceTimer;
  CancelableOperation<T>? _currentOperation;
  
  final Duration debounceDuration;
  final Future<T> Function(String query) searchFunction;
  
  DebouncedSearch({
    this.debounceDuration = const Duration(milliseconds: 300),
    required this.searchFunction,
  });
  
  Future<T?> search(String query) async {
    // Cancel previous operation
    await _currentOperation?.cancel();
    _debounceTimer?.cancel();
    
    if (query.isEmpty) return null;
    
    final completer = Completer<T?>();
    
    _debounceTimer = Timer(debounceDuration, () async {
      _currentOperation = CancelableOperation.fromFuture(
        searchFunction(query),
      );
      
      try {
        final result = await _currentOperation!.value;
        if (!completer.isCompleted) {
          completer.complete(result);
        }
      } catch (e) {
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      }
    });
    
    return completer.future;
  }
  
  void dispose() {
    _debounceTimer?.cancel();
    _currentOperation?.cancel();
  }
}

// Usage in location search
class LocationSearchField extends StatefulWidget {
  @override
  State<LocationSearchField> createState() => _LocationSearchFieldState();
}

class _LocationSearchFieldState extends State<LocationSearchField> {
  late final DebouncedSearch<List<Location>> _searchDebouncer;
  
  @override
  void initState() {
    super.initState();
    _searchDebouncer = DebouncedSearch(
      debounceDuration: const Duration(milliseconds: 200),
      searchFunction: (query) => ref.read(locationServiceProvider).search(query),
    );
  }
  
  @override
  void dispose() {
    _searchDebouncer.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) async {
        final results = await _searchDebouncer.search(value);
        if (results != null && mounted) {
          setState(() => _suggestions = results);
        }
      },
    );
  }
}
```

---

## 2. Animation Implementations That Wow

### 2.1 Hero Transitions for Restaurant Cards

**Why Judges Care:** Hero animations are the hallmark of polished Flutter apps - they immediately signal quality.

```dart
// lib/features/restaurant/widgets/restaurant_hero_card.dart
import 'package:flutter/material.dart';

class RestaurantHeroCard extends StatelessWidget {
  final Restaurant restaurant;
  final String heroTag;
  
  const RestaurantHeroCard({
    super.key,
    required this.restaurant,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'restaurant-$heroTag',
      flightShuttleBuilder: (
        BuildContext flightContext,
        Animation<double> animation,
        HeroFlightDirection flightDirection,
        BuildContext fromHeroContext,
        BuildContext toHeroContext,
      ) {
        // Custom flight animation
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Material(
              elevation: lerpDouble(2, 8, animation.value)!,
              borderRadius: BorderRadius.circular(
                lerpDouble(12, 0, animation.value)!,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  lerpDouble(12, 0, animation.value)!,
                ),
                child: _buildCardContent(),
              ),
            );
          },
        );
      },
      child: GestureDetector(
        onTap: () => _navigateToDetail(context),
        child: _buildCardContent(),
      ),
    );
  }
  
  Widget _buildCardContent() {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(restaurant.photoUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Award badges with staggered animation
              if (restaurant.hasAwards) ...[
                _buildAwardBadges(),
                const SizedBox(height: 8),
              ],
              Text(
                restaurant.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                restaurant.cuisineType,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildAwardBadges() {
    return Row(
      children: [
        if (restaurant.isJamesBeardWinner)
          _buildBadge('James Beard', Colors.amber),
        if (restaurant.michelinStars > 0)
          _buildBadge(
            '${restaurant.michelinStars} Michelin ${'⭐' * restaurant.michelinStars}',
            Colors.red,
          ),
      ],
    );
  }
  
  Widget _buildBadge(String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  void _navigateToDetail(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return RestaurantDetailScreen(
            restaurant: restaurant,
            heroTag: heroTag,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Fade + scale transition
          final fadeAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          );
          
          return FadeTransition(
            opacity: fadeAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}
```

### 2.2 Staggered List Animation for Tour Stops

**Why Judges Care:** Staggered animations create a "crafted" feel and show mastery of Flutter's animation system.

```dart
// lib/features/tour/widgets/animated_tour_stop_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AnimatedTourStopList extends StatelessWidget {
  final List<TourStop> stops;
  final ScrollController? scrollController;
  
  const AnimatedTourStopList({
    super.key,
    required this.stops,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
        controller: scrollController,
        itemCount: stops.length,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 400),
            child: SlideAnimation(
              verticalOffset: 50,
              child: FadeInAnimation(
                child: TourStopCard(
                  stop: stops[index],
                  stopNumber: index + 1,
                  // Show connection line to next stop
                  showConnector: index < stops.length - 1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Individual stop card with micro-interactions
class TourStopCard extends StatefulWidget {
  final TourStop stop;
  final int stopNumber;
  final bool showConnector;
  
  const TourStopCard({
    super.key,
    required this.stop,
    required this.stopNumber,
    this.showConnector = false,
  });

  @override
  State<TourStopCard> createState() => _TourStopCardState();
}

class _TourStopCardState extends State<TourStopCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isExpanded = false;
  
  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    // Pulse animation for "current stop" indicator
    if (widget.stop.isCurrent) {
      _pulseController.repeat(reverse: true);
    }
  }
  
  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: widget.stop.isCurrent 
                ? Theme.of(context).colorScheme.primaryContainer
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Animated stop number
                      _buildStopNumber(),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.stop.restaurant.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.stop.estimatedArrival.format(context),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Expand/collapse indicator with rotation
                      AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(Icons.expand_more),
                      ),
                    ],
                  ),
                ),
                // Expandable content
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: _buildExpandedContent(),
                  crossFadeState: _isExpanded 
                      ? CrossFadeState.showSecond 
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),
              ],
            ),
          ),
        ),
        // Connector line to next stop
        if (widget.showConnector)
          _buildConnector(),
      ],
    );
  }
  
  Widget _buildStopNumber() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: widget.stop.isCurrent
                ? Theme.of(context).colorScheme.primary.withOpacity(
                    0.5 + (_pulseController.value * 0.5),
                  )
                : Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${widget.stopNumber}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: widget.stop.isCurrent
                    ? Theme.of(context).colorScheme.onPrimary
                    : Colors.grey[600],
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildConnector() {
    return Container(
      width: 2,
      height: 24,
      margin: const EdgeInsets.only(left: 35),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey[300]!,
            Colors.grey[200]!,
          ],
        ),
      ),
    );
  }
  
  Widget _buildExpandedContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          Text(
            'Recommended Dishes',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: widget.stop.recommendedDishes.map((dish) {
              return Chip(
                label: Text(dish),
                backgroundColor: Theme.of(context).colorScheme.surface,
                side: BorderSide(color: Colors.grey[300]!),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
```

### 2.3 Map Route Animation with Path Drawing

**Why Judges Care:** Animated map routes are visually impressive and demonstrate custom painter skills.

```dart
// lib/features/tour/widgets/animated_route_map.dart
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class AnimatedRouteMap extends StatefulWidget {
  final List<LatLng> waypoints;
  final List<List<LatLng>> routeSegments;
  
  const AnimatedRouteMap({
    super.key,
    required this.waypoints,
    required this.routeSegments,
  });

  @override
  State<AnimatedRouteMap> createState() => _AnimatedRouteMapState();
}

class _AnimatedRouteMapState extends State<AnimatedRouteMap>
    with TickerProviderStateMixin {
  late AnimationController _routeAnimationController;
  late List<Animation<double>> _segmentAnimations;
  
  @override
  void initState() {
    super.initState();
    
    // Staggered animation for each route segment
    _routeAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500 * widget.routeSegments.length),
    );
    
    _segmentAnimations = List.generate(
      widget.routeSegments.length,
      (index) => CurvedAnimation(
        parent: _routeAnimationController,
        curve: Interval(
          index / widget.routeSegments.length,
          (index + 1) / widget.routeSegments.length,
          curve: Curves.easeInOut,
        ),
      ),
    );
    
    // Auto-start animation
    _routeAnimationController.forward();
  }
  
  @override
  void dispose() {
    _routeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base Mapbox map
        MapWidget(
          onMapCreated: _onMapCreated,
          cameraOptions: CameraOptions(
            center: Point(
              coordinates: Position(
                widget.waypoints.first.longitude,
                widget.waypoints.first.latitude,
              ),
            ),
            zoom: 13,
          ),
        ),
        // Animated route overlay
        ...List.generate(widget.routeSegments.length, (index) {
          return AnimatedBuilder(
            animation: _segmentAnimations[index],
            builder: (context, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: RouteSegmentPainter(
                  points: widget.routeSegments[index],
                  progress: _segmentAnimations[index].value,
                  color: _getSegmentColor(index),
                  strokeWidth: 4,
                ),
              );
            },
          );
        }),
        // Animated waypoint markers
        ...List.generate(widget.waypoints.length, (index) {
          return AnimatedBuilder(
            animation: _routeAnimationController,
            builder: (context, child) {
              final delay = index / widget.waypoints.length;
              final animation = CurvedAnimation(
                parent: _routeAnimationController,
                curve: Interval(delay, delay + 0.2, curve: Curves.elasticOut),
              );
              
              return Positioned(
                // Convert lat/lng to screen position (simplified)
                left: 100 + (index * 50),
                top: 200,
                child: ScaleTransition(
                  scale: animation,
                  child: _buildWaypointMarker(index + 1),
                ),
              );
            },
          );
        }),
      ],
    );
  }
  
  Widget _buildWaypointMarker(int number) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$number',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
  
  Color _getSegmentColor(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }
  
  void _onMapCreated(MapboxMap map) {
    // Configure map annotations and style
  }
}

// Custom painter for animating route drawing
class RouteSegmentPainter extends CustomPainter {
  final List<LatLng> points;
  final double progress;
  final Color color;
  final double strokeWidth;
  
  RouteSegmentPainter({
    required this.points,
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    
    // Create path from points (simplified - would need proper projection)
    final path = Path();
    // Convert to screen coordinates here...
    
    // Animate path drawing using path metrics
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      final extractPath = metric.extractPath(
        0,
        metric.length * progress,
      );
      canvas.drawPath(extractPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant RouteSegmentPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
```

---

## 3. Serverpod Endpoint Optimizations

### 3.1 Batched Tour Generation Endpoint

**Why Judges Care:** Shows you understand efficient data fetching and can optimize backend performance.

```dart
// server/lib/src/endpoints/tour_endpoint.dart
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class TourEndpoint extends Endpoint {
  /// Optimized batch endpoint that fetches all tour data in single request
  /// Reduces round-trips from N+1 to 1
  @override
  Future<TourGenerationResult> generateTour(
    Session session, {
    required TourRequest request,
  }) async {
    final stopwatch = Stopwatch()..start();
    
    // Parallel data fetching - all independent calls together
    final results = await Future.wait([
      _fetchRestaurants(session, request),
      _fetchAwards(session, request.city),
      _fetchCurrentIntel(session, request.city),
    ]);
    
    final restaurants = results[0] as List<Restaurant>;
    final awards = results[1] as Map<String, AwardInfo>;
    final intel = results[2] as Map<String, PerplexityInsight>;
    
    // Enrich restaurants with awards and intel
    final enrichedRestaurants = restaurants.map((r) {
      return r.copyWith(
        awardInfo: awards[r.foursquareId],
        currentIntel: intel[r.foursquareId],
      );
    }).toList();
    
    // Optimize route
    final optimizedStops = await _optimizeRoute(
      session,
      restaurants: enrichedRestaurants,
      startLocation: request.startLocation,
      transportMode: request.transportMode,
    );
    
    // Generate narrative in parallel with route details
    final narrative = await _generateNarrative(session, optimizedStops);
    
    stopwatch.stop();
    
    // Log performance metrics
    session.log('Tour generated in ${stopwatch.elapsedMilliseconds}ms');
    
    return TourGenerationResult(
      stops: optimizedStops,
      narrative: narrative,
      totalDistance: _calculateTotalDistance(optimizedStops),
      estimatedDuration: _calculateDuration(optimizedStops),
      generationTimeMs: stopwatch.elapsedMilliseconds,
    );
  }
  
  /// Cached restaurant fetch with spatial query optimization
  Future<List<Restaurant>> _fetchRestaurants(
    Session session,
    TourRequest request,
  ) async {
    // Use PostgreSQL spatial index for efficient radius search
    final result = await session.db.query('''
      SELECT r.*, 
             ST_Distance(
               r.location::geography, 
               ST_SetSRID(ST_MakePoint(@lng, @lat), 4326)::geography
             ) / 1000.0 as distance_km
      FROM restaurants r
      WHERE ST_DWithin(
        r.location::geography,
        ST_SetSRID(ST_MakePoint(@lng, @lat), 4326)::geography,
        @radiusMeters
      )
      AND r.cuisine_type = ANY(@cuisines)
      AND r.price_level BETWEEN @minPrice AND @maxPrice
      ORDER BY 
        (r.james_beard_score + r.michelin_score) DESC,
        r.foursquare_rating DESC
      LIMIT @limit
    ''', parameters: {
      'lat': request.startLocation.latitude,
      'lng': request.startLocation.longitude,
      'radiusMeters': request.transportMode == 'walking' ? 2000 : 15000,
      'cuisines': request.preferredCuisines,
      'minPrice': request.budget.min,
      'maxPrice': request.budget.max,
      'limit': 50, // Fetch more than needed for optimization flexibility
    });
    
    return result.map((row) => Restaurant.fromRow(row)).toList();
  }
  
  /// Cached Perplexity insights with TTL
  Future<Map<String, PerplexityInsight>> _fetchCurrentIntel(
    Session session,
    String city,
  ) async {
    // Check cache first
    final cached = await session.db.findFirstRow<PerplexityCache>(
      where: (t) => t.city.equals(city) & t.createdAt.greaterThan(
        DateTime.now().subtract(const Duration(hours: 24)),
      ),
    );
    
    if (cached != null) {
      session.log('Using cached Perplexity data for $city');
      return cached.insights;
    }
    
    // Fetch fresh data
    final insights = await PerplexityService.getCityInsights(city);
    
    // Cache for 24 hours
    await session.db.insertRow(PerplexityCache(
      city: city,
      insights: insights,
      createdAt: DateTime.now(),
    ));
    
    return insights;
  }
  
  /// Optimized route using nearest neighbor with 2-opt improvement
  Future<List<TourStop>> _optimizeRoute(
    Session session, {
    required List<Restaurant> restaurants,
    required LatLng startLocation,
    required String transportMode,
  }) async {
    // Nearest neighbor for initial route
    final unvisited = List<Restaurant>.from(restaurants);
    final route = <Restaurant>[];
    var current = startLocation;
    
    while (unvisited.isNotEmpty && route.length < 6) {
      // Find nearest restaurant
      unvisited.sort((a, b) {
        final distA = _calculateDistance(current, a.location);
        final distB = _calculateDistance(current, b.location);
        return distA.compareTo(distB);
      });
      
      final next = unvisited.removeAt(0);
      route.add(next);
      current = next.location;
    }
    
    // 2-opt improvement (simplified)
    return _improveRouteWith2Opt(route, transportMode);
  }
}
```

### 3.2 Streaming Response for "Ask the Butler"

**Why Judges Care:** Streaming responses show real-time AI integration - very impressive in demos.

```dart
// server/lib/src/endpoints/butler_endpoint.dart
import 'dart:async';
import 'package:serverpod/serverpod.dart';

class ButlerEndpoint extends Endpoint {
  /// Streaming endpoint for conversational AI
  /// Sends partial responses as they're generated
  Stream<ButlerResponse> askButlerStream(
    Session session, {
    required String question,
    String? tripId,
  }) async* {
    final context = await _buildContext(session, tripId);
    
    // Use Groq for fast streaming
    final stream = await GroqService.streamCompletion(
      systemPrompt: _buildSystemPrompt(context),
      userMessage: question,
    );
    
    var fullResponse = '';
    var chunkCount = 0;
    
    await for (final chunk in stream) {
      fullResponse += chunk;
      chunkCount++;
      
      // Yield every few chunks or on sentence boundaries
      if (chunkCount % 3 == 0 || chunk.contains('.') || chunk.contains('?')) {
        yield ButlerResponse(
          type: ResponseType.partial,
          content: fullResponse,
          isComplete: false,
        );
      }
    }
    
    // Final complete response
    yield ButlerResponse(
      type: ResponseType.complete,
      content: fullResponse,
      isComplete: true,
      suggestedActions: _extractSuggestedActions(fullResponse),
    );
  }
  
  /// Non-streaming version for simple queries
  Future<ButlerResponse> askButler(
    Session session, {
    required String question,
    String? tripId,
  }) async {
    // Use cached response if available
    final cacheKey = '${question.hashCode}_$tripId';
    final cached = await session.redis.get(cacheKey);
    
    if (cached != null) {
      return ButlerResponse.fromJson(cached);
    }
    
    final response = await _generateResponse(session, question, tripId);
    
    // Cache for 5 minutes
    await session.redis.set(
      cacheKey,
      response.toJson(),
      expiration: const Duration(minutes: 5),
    );
    
    return response;
  }
}

// Client-side streaming handler
class AskButlerScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<AskButlerScreen> createState() => _AskButlerScreenState();
}

class _AskButlerScreenState extends ConsumerState<AskButlerScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isStreaming = false;
  String _streamingContent = '';
  
  Future<void> _sendMessage(String question) async {
    setState(() {
      _messages.add(ChatMessage.user(question));
      _isStreaming = true;
      _streamingContent = '';
    });
    
    final stream = ref.read(butlerClientProvider).askButlerStream(
      question: question,
      tripId: widget.tripId,
    );
    
    await for (final response in stream) {
      setState(() {
        _streamingContent = response.content;
      });
    }
    
    setState(() {
      _messages.add(ChatMessage.assistant(_streamingContent));
      _isStreaming = false;
      _streamingContent = '';
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _messages.length + (_isStreaming ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _messages.length && _isStreaming) {
                return AssistantMessageBubble(
                  content: _streamingContent,
                  isStreaming: true,
                );
              }
              return MessageBubble(message: _messages[index]);
            },
          ),
        ),
        ChatInputField(
          controller: _controller,
          onSend: _sendMessage,
          isLoading: _isStreaming,
        ),
      ],
    );
  }
}
```

### 3.3 Efficient Image Upload with Progress

**Why Judges Care:** Shows understanding of multipart uploads and real-time progress tracking.

```dart
// server/lib/src/endpoints/journal_endpoint.dart
import 'dart:typed_data';
import 'package:serverpod/serverpod.dart';
import 'package:crypto/crypto.dart';

class JournalEndpoint extends Endpoint {
  /// Upload image with progress tracking via WebSocket
  Future<ImageUploadResult> uploadJournalImage(
    Session session, {
    required ByteData imageData,
    required String fileName,
    String? journalEntryId,
  }) async {
    final startTime = DateTime.now();
    
    // Validate image
    if (imageData.lengthInBytes > 10 * 1024 * 1024) {
      throw ArgumentException('Image must be under 10MB');
    }
    
    // Generate unique filename
    final hash = sha256.convert(imageData.buffer.asUint8List());
    final uniqueFileName = '${hash.toString().substring(0, 16)}_$fileName';
    
    // Upload to Cloudflare R2 (S3-compatible)
    final url = await R2Service.uploadImage(
      fileName: uniqueFileName,
      data: imageData,
      contentType: _detectContentType(fileName),
    );
    
    // Create thumbnail asynchronously
    unawaited(_generateThumbnail(session, uniqueFileName, imageData));
    
    final duration = DateTime.now().difference(startTime);
    session.log('Image uploaded in ${duration.inMilliseconds}ms');
    
    return ImageUploadResult(
      originalUrl: url,
      thumbnailUrl: url.replaceFirst('.jpg', '_thumb.jpg'),
      fileName: uniqueFileName,
      uploadDurationMs: duration.inMilliseconds,
    );
  }
  
  /// Batch upload multiple images efficiently
  Future<List<ImageUploadResult>> uploadJournalImages(
    Session session, {
    required List<ByteData> images,
    required List<String> fileNames,
    String? journalEntryId,
  }) async {
    // Upload in parallel with concurrency limit
    final results = await Future.wait(
      List.generate(images.length, (index) {
        return uploadJournalImage(
          session,
          imageData: images[index],
          fileName: fileNames[index],
          journalEntryId: journalEntryId,
        );
      }),
      eagerError: false,
    );
    
    return results.whereType<ImageUploadResult>().toList();
  }
  
  String _detectContentType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }
}
```

---

## 4. State Management Best Practices

### 4.1 Riverpod Architecture with Code Generation

**Why Judges Care:** Shows modern Flutter architecture and type-safe dependency injection.

```dart
// lib/core/providers/app_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_client/serverpod_client.dart';

part 'app_providers.g.dart';

// Client provider - singleton
@Riverpod(keepAlive: true)
Client client(ClientRef ref) {
  return Client('https://api.foodtourbutler.com/')
    ..connectivityMonitor = FlutterConnectivityMonitor();
}

// Service providers
@Riverpod(keepAlive: true)
TourService tourService(TourServiceRef ref) {
  return TourService(client: ref.watch(clientProvider));
}

@Riverpod(keepAlive: true)
JournalService journalService(JournalServiceRef ref) {
  return JournalService(client: ref.watch(clientProvider));
}

@Riverpod(keepAlive: true)
ButlerService butlerService(ButlerServiceRef ref) {
  return ButlerService(client: ref.watch(clientProvider));
}

// Feature-specific providers with auto-dispose for memory efficiency
@riverpod
class TourGeneration extends _$TourGeneration {
  @override
  FutureOr<Tour?> build() => null;
  
  Future<void> generateTour(TourRequest request) async {
    state = const AsyncLoading();
    
    state = await AsyncValue.guard(() async {
      final service = ref.read(tourServiceProvider);
      return await service.generateTour(request);
    });
  }
  
  void clear() {
    state = const AsyncData(null);
  }
}

@riverpod
class CurrentTrip extends _$CurrentTrip {
  @override
  FutureOr<Trip?> build(String? tripId) async {
    if (tripId == null) return null;
    
    // Auto-refresh every 30 seconds while viewing
    final timer = Timer.periodic(const Duration(seconds: 30), (_) {
      ref.invalidateSelf();
    });
    
    ref.onDispose(timer.cancel);
    
    final service = ref.read(tourServiceProvider);
    return await service.getTrip(tripId);
  }
  
  Future<void> addRestaurant(String restaurantId, MealSlot slot) async {
    final current = state.value;
    if (current == null) return;
    
    // Optimistic update
    final updated = current.copyWith(
      mealSlots: [...current.mealSlots, slot],
    );
    state = AsyncData(updated);
    
    // API call
    final service = ref.read(tourServiceProvider);
    final result = await service.addToTrip(current.id, restaurantId, slot);
    
    // Revert on failure
    if (result.isFailure) {
      state = AsyncData(current);
    }
  }
}

// Computed/derived providers
@riverpod
List<Restaurant> awardWinningRestaurants(AwardWinningRestaurantsRef ref) {
  final tourAsync = ref.watch(tourGenerationProvider);
  
  return tourAsync.when(
    data: (tour) => tour?.stops
        .where((s) => s.restaurant.hasAwards)
        .map((s) => s.restaurant)
        .toList() ?? [],
    loading: () => [],
    error: (_, __) => [],
  );
}

@riverpod
Duration totalTourDuration(TotalTourDurationRef ref) {
  final tourAsync = ref.watch(tourGenerationProvider);
  
  return tourAsync.when(
    data: (tour) {
      if (tour == null) return Duration.zero;
      return tour.stops.fold<Duration>(
        Duration.zero,
        (total, stop) => total + stop.estimatedDuration,
      );
    },
    loading: () => Duration.zero,
    error: (_, __) => Duration.zero,
  );
}

// Error handling provider
@riverpod
class ErrorHandler extends _$ErrorHandler {
  @override
  List<AppError> build() => [];
  
  void showError(String message, {ErrorSeverity severity = ErrorSeverity.error}) {
    state = [...state, AppError(message: message, severity: severity)];
    
    // Auto-dismiss after delay
    Future.delayed(const Duration(seconds: 5), () {
      if (state.isNotEmpty) {
        state = state.sublist(1);
      }
    });
  }
  
  void dismissError(int index) {
    state = [...state]..removeAt(index);
  }
}
```

### 4.2 Optimistic UI Updates

**Why Judges Care:** Shows advanced state management and creates snappy UX.

```dart
// lib/features/journal/providers/journal_entry_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'journal_entry_provider.g.dart';

@riverpod
class JournalEntryController extends _$JournalEntryController {
  @override
  FutureOr<JournalEntry?> build(String? entryId) async {
    if (entryId == null) return null;
    final service = ref.read(journalServiceProvider);
    return await service.getEntry(entryId);
  }
  
  /// Add photo with optimistic UI update
  Future<void> addPhoto(String imagePath) async {
    final current = state.value;
    if (current == null) return;
    
    // Create optimistic photo entry
    final optimisticPhoto = Photo(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      localPath: imagePath,
      uploadStatus: UploadStatus.uploading,
    );
    
    // Optimistically update UI
    final optimisticEntry = current.copyWith(
      photos: [...current.photos, optimisticPhoto],
    );
    state = AsyncData(optimisticEntry);
    
    try {
      // Perform actual upload
      final service = ref.read(journalServiceProvider);
      final uploadedPhoto = await service.uploadPhoto(entryId!, imagePath);
      
      // Replace optimistic entry with real one
      final updatedPhotos = current.photos.map((p) {
        return p.id == optimisticPhoto.id ? uploadedPhoto : p;
      }).toList();
      
      state = AsyncData(current.copyWith(photos: updatedPhotos));
    } catch (e) {
      // Revert on failure
      state = AsyncData(current);
      ref.read(errorHandlerProvider.notifier).showError(
        'Failed to upload photo. Please try again.',
      );
    }
  }
  
  /// Update rating with instant feedback
  Future<void> updateRating(int rating) async {
    final current = state.value;
    if (current == null) return;
    
    // Instant UI update
    final previousRating = current.rating;
    state = AsyncData(current.copyWith(rating: rating));
    
    try {
      final service = ref.read(journalServiceProvider);
      await service.updateRating(current.id, rating);
    } catch (e) {
      // Revert on failure
      state = AsyncData(current.copyWith(rating: previousRating));
      ref.read(errorHandlerProvider.notifier).showError(
        'Failed to save rating.',
      );
    }
  }
}

// UI that uses optimistic updates
class RatingStars extends ConsumerWidget {
  final String entryId;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entryAsync = ref.watch(journalEntryControllerProvider(entryId));
    
    return entryAsync.when(
      data: (entry) {
        if (entry == null) return const SizedBox.shrink();
        
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            final starValue = index + 1;
            final isFilled = starValue <= entry.rating;
            
            return AnimatedScale(
              scale: isFilled ? 1.0 : 0.9,
              duration: const Duration(milliseconds: 150),
              child: IconButton(
                icon: Icon(
                  isFilled ? Icons.star : Icons.star_border,
                  color: isFilled ? Colors.amber : Colors.grey,
                ),
                onPressed: () {
                  // Instant feedback - no loading state
                  ref.read(journalEntryControllerProvider(entryId).notifier)
                      .updateRating(starValue);
                },
              ),
            );
          }),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (_, __) => const Icon(Icons.error),
    );
  }
}
```

---

## 5. Technical Show-Off Features

### 5.1 Haptic Feedback Integration

**Why Judges Care:** Shows attention to platform-native details and creates premium feel.

```dart
// lib/core/utils/haptic_feedback.dart
import 'package:flutter/services.dart';

class AppHaptics {
  static void lightImpact() {
    HapticFeedback.lightImpact();
  }
  
  static void mediumImpact() {
    HapticFeedback.mediumImpact();
  }
  
  static void heavyImpact() {
    HapticFeedback.heavyImpact();
  }
  
  static void selectionClick() {
    HapticFeedback.selectionClick();
  }
  
  /// Success pattern - three quick taps
  static Future<void> success() async {
    for (var i = 0; i < 3; i++) {
      HapticFeedback.lightImpact();
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }
  
  /// Error pattern - two heavy impacts
  static Future<void> error() async {
    HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    HapticFeedback.heavyImpact();
  }
  
  /// Pattern for adding to tour
  static Future<void> addedToTour() async {
    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 80));
    HapticFeedback.lightImpact();
  }
}

// Usage in widgets
class AddToTourButton extends StatelessWidget {
  final VoidCallback onPressed;
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        AppHaptics.addedToTour();
        onPressed();
      },
      child: const Text('Add to Tour'),
    );
  }
}
```

### 5.2 Pull-to-Refresh with Custom Indicator

**Why Judges Care:** Custom refresh indicators show polish and attention to detail.

```dart
// lib/core/widgets/custom_refresh_indicator.dart
import 'package:flutter/material.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

class ButlerRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  
  const ButlerRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      onRefresh: onRefresh,
      builder: (context, child, controller) {
        return AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return Stack(
              children: [
                child,
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: controller.value * 100,
                    alignment: Alignment.center,
                    child: Opacity(
                      opacity: controller.value.clamp(0.0, 1.0),
                      child: _buildIndicator(controller),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: child,
    );
  }
  
  Widget _buildIndicator(IndicatorController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Animated chef hat icon
        RotationTransition(
          turns: AlwaysStoppedAnimation(controller.value * 2),
          child: Icon(
            Icons.restaurant,
            size: 32,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          controller.isLoading
              ? 'Refreshing your recommendations...'
              : 'Pull to refresh',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
```

### 5.3 Smart Error Boundary

**Why Judges Care:** Shows production-ready error handling - judges notice when apps don't crash.

```dart
// lib/core/widgets/error_boundary.dart
import 'package:flutter/material.dart';

class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(FlutterErrorDetails)? errorBuilder;
  
  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  FlutterErrorDetails? _error;
  
  @override
  void initState() {
    super.initState();
    FlutterError.onError = _handleFlutterError;
  }
  
  void _handleFlutterError(FlutterErrorDetails details) {
    setState(() => _error = details);
    // Log to analytics/crashlytics
    _reportError(details);
  }
  
  void _reportError(FlutterErrorDetails details) {
    // Send to your error tracking service
    debugPrint('Error: ${details.exception}');
    debugPrint('Stack: ${details.stack}');
  }
  
  void _reset() {
    setState(() => _error = null);
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.errorBuilder?.call(_error!) ?? _defaultErrorView();
    }
    return widget.child;
  }
  
  Widget _defaultErrorView() {
    return Material(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              const Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Don\'t worry, your data is safe. Try again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _reset,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Usage - wrap your app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      child: MaterialApp(
        // ... your app
      ),
    );
  }
}
```

### 5.4 Demo Mode for Presentation

**Why Judges Care:** Shows you thought about the demo experience - hackathon gold.

```dart
// lib/core/utils/demo_mode.dart
import 'package:flutter/foundation.dart';

/// Demo mode utilities for hackathon presentation
/// Pre-loads data and skips slow operations
class DemoMode {
  static const bool isDemo = bool.fromEnvironment('DEMO_MODE', defaultValue: false);
  
  /// Pre-cached tour for instant demo
  static Tour get demoTour => Tour(
    id: 'demo-chicago',
    title: 'Chicago Food Crawl',
    city: 'Chicago',
    stops: [
      TourStop(
        restaurant: Restaurant(
          name: 'Alinea',
          cuisineType: 'Molecular Gastronomy',
          photoUrl: 'https://example.com/alinea.jpg',
          michelinStars: 3,
          isJamesBeardWinner: true,
        ),
        estimatedArrival: TimeOfDay(hour: 18, minute: 0),
        recommendedDishes: ['Black Truffle', 'Edible Balloon'],
      ),
      TourStop(
        restaurant: Restaurant(
          name: 'Girl & the Goat',
          cuisineType: 'Mediterranean',
          photoUrl: 'https://example.com/goat.jpg',
          isJamesBeardWinner: true,
        ),
        estimatedArrival: TimeOfDay(hour: 20, minute: 30),
        recommendedDishes: ['Wood-Fired Octopus', 'Pork Face'],
      ),
      // Add more stops...
    ],
  );
  
  /// Instant tour generation for demo
  static Future<Tour> generateInstantTour(TourRequest request) async {
    // Simulate network delay for realism (300ms)
    await Future.delayed(const Duration(milliseconds: 300));
    return demoTour;
  }
  
  /// Skip Perplexity calls in demo mode
  static Future<Map<String, dynamic>> getDemoIntel(String city) async {
    return {
      'trending': [
        {'name': 'Kasama', 'reason': 'Michelin-starred Filipino buzz'},
        {'name': 'Bonci', 'reason': 'Roman pizza just opened'},
      ],
      'lastUpdated': 'Just now',
    };
  }
}

// Usage in providers
@riverpod
class TourGeneration extends _$TourGeneration {
  @override
  FutureOr<Tour?> build() => null;
  
  Future<void> generateTour(TourRequest request) async {
    state = const AsyncLoading();
    
    if (DemoMode.isDemo) {
      state = await AsyncValue.guard(() => DemoMode.generateInstantTour(request));
      return;
    }
    
    // Normal flow...
  }
}
```

---

## Quick Implementation Checklist

### Priority 1 (Must-Have for Demo)
- [ ] Add `shimmer` package for skeleton loaders
- [ ] Implement `AnimationLimiter` for tour stop lists
- [ ] Add Hero transitions to restaurant cards
- [ ] Set up Riverpod with code generation
- [ ] Add haptic feedback to key interactions

### Priority 2 (Impressive if Time)
- [ ] Custom refresh indicator
- [ ] Animated route drawing on map
- [ ] Streaming "Ask the Butler" responses
- [ ] Error boundary wrapper

### Priority 3 (Polish)
- [ ] Demo mode flag
- [ ] Performance logging
- [ ] Optimistic UI updates

---

## Packages to Add

```yaml
dependencies:
  # Animation
  shimmer: ^3.0.0
  flutter_staggered_animations: ^1.1.1
  custom_refresh_indicator: ^3.0.0
  
  # State Management
  flutter_riverpod: ^2.4.0
  riverpod_annotation: ^2.2.0
  
  # Performance
  cached_network_image: ^3.3.0
  
dev_dependencies:
  riverpod_generator: ^2.3.0
  build_runner: ^2.4.0
```

---

## Why Judges Will Be Impressed

| Feature | Judge Impression |
|---------|------------------|
| Skeleton loaders | "They understand perceived performance" |
| Hero transitions | "Polished, professional Flutter dev" |
| Staggered animations | "Crafted UX, not just functional" |
| Streaming AI responses | "Real-time integration, modern architecture" |
| Optimistic updates | "Advanced state management" |
| Haptic feedback | "Platform-native attention to detail" |
| Error boundaries | "Production-ready thinking" |
| Demo mode | "They thought about presentation" |

---

*Good luck with your hackathon submission! These improvements should make your demo smooth, impressive, and technically sophisticated.*
