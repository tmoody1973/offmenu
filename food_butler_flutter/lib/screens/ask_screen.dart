import 'package:flutter/material.dart';
import 'package:food_butler_client/food_butler_client.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import '../theme/app_theme.dart';
import '../widgets/save_button.dart';

/// Conversational AI screen - "Ask the Butler".
///
/// A free-form input where users can ask any food-related question
/// and get curated results with photos and a map.
class AskScreen extends StatefulWidget {
  final String? initialPrompt;

  const AskScreen({super.key, this.initialPrompt});

  @override
  State<AskScreen> createState() => _AskScreenState();
}

class _AskScreenState extends State<AskScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLoading = false;
  FoodDiscoveryResponse? _response;
  GoogleMapController? _mapController;
  int? _selectedIndex;

  // Example prompts for inspiration
  static const List<String> _examplePrompts = [
    'Hidden gems in Capitol Hill only locals know',
    'Best late night eats after a Mariners game',
    'Hole-in-the-wall taquerias tourists miss',
    'Romantic dinner spots with a view',
    'Best brunch with bottomless mimosas',
    'Authentic dim sum in the International District',
    'Food trucks worth tracking down',
    'Chef-driven restaurants under \$30',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialPrompt != null) {
      _controller.text = widget.initialPrompt!;
      // Auto-submit if there's an initial prompt
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _submitQuery();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _submitQuery() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _response = null;
      _selectedIndex = null;
    });

    try {
      final response = await client.foodDiscovery.ask(query);
      setState(() {
        _response = response;
        _isLoading = false;
      });

      // Fit map to show all markers
      if (response.places.isNotEmpty && _mapController != null) {
        _fitMapToMarkers();
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Oops! Something went wrong: $e'),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  /// Check if coordinates are valid (not Null Island at 0,0)
  bool _hasValidCoordinates(DiscoveredPlace place) {
    return place.latitude != 0 || place.longitude != 0;
  }

  void _fitMapToMarkers() {
    if (_response == null || _response!.places.isEmpty) return;

    // Only consider places with valid coordinates
    final validPlaces = _response!.places.where(_hasValidCoordinates).toList();
    if (validPlaces.isEmpty) return;

    final bounds = validPlaces.fold<LatLngBounds?>(
      null,
      (bounds, place) {
        final latLng = LatLng(place.latitude, place.longitude);
        if (bounds == null) {
          return LatLngBounds(southwest: latLng, northeast: latLng);
        }
        return LatLngBounds(
          southwest: LatLng(
            bounds.southwest.latitude < latLng.latitude
                ? bounds.southwest.latitude
                : latLng.latitude,
            bounds.southwest.longitude < latLng.longitude
                ? bounds.southwest.longitude
                : latLng.longitude,
          ),
          northeast: LatLng(
            bounds.northeast.latitude > latLng.latitude
                ? bounds.northeast.latitude
                : latLng.latitude,
            bounds.northeast.longitude > latLng.longitude
                ? bounds.northeast.longitude
                : latLng.longitude,
          ),
        );
      },
    );

    if (bounds != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 60),
      );
    }
  }

  void _selectPlace(int index) {
    setState(() => _selectedIndex = index);
    final place = _response!.places[index];
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(place.latitude, place.longitude),
        15,
      ),
    );
  }

  Future<void> _openInMaps(DiscoveredPlace place) async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(place.name)}&query_place_id=${place.placeId}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width >= 800;

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome, color: Colors.amber.shade400, size: 20),
            const SizedBox(width: 8),
            const Text('Ask the Butler'),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
      ),
      body: Column(
        children: [
          // Search input
          _SearchInputSection(
            controller: _controller,
            isLoading: _isLoading,
            onSubmit: _submitQuery,
          ),

          // Results area
          Expanded(
            child: _isLoading
                ? _LoadingState()
                : _response == null
                    ? _EmptyState(
                        prompts: _examplePrompts,
                        onPromptTap: (prompt) {
                          _controller.text = prompt;
                          _submitQuery();
                        },
                      )
                    : isWide
                        ? _WideResultsLayout(
                            response: _response!,
                            mapController: _mapController,
                            onMapCreated: (controller) {
                              _mapController = controller;
                              _fitMapToMarkers();
                            },
                            selectedIndex: _selectedIndex,
                            onSelectPlace: _selectPlace,
                            onOpenInMaps: _openInMaps,
                          )
                        : _MobileResultsLayout(
                            response: _response!,
                            mapController: _mapController,
                            onMapCreated: (controller) {
                              _mapController = controller;
                              _fitMapToMarkers();
                            },
                            selectedIndex: _selectedIndex,
                            onSelectPlace: _selectPlace,
                            onOpenInMaps: _openInMaps,
                          ),
          ),
        ],
      ),
    );
  }
}

/// Search input section.
class _SearchInputSection extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSubmit;

  const _SearchInputSection({
    required this.controller,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade700),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Ask me anything about food...',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                filled: true,
                fillColor: Colors.grey.shade900,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => onSubmit(),
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: isLoading ? null : onSubmit,
            icon: isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.send, size: 18),
            label: const Text('Ask'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.amber.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}

/// Loading state with fun messages.
class _LoadingState extends StatelessWidget {
  static const _loadingMessages = [
    'Consulting the culinary council...',
    'Asking the locals...',
    'Discovering hidden gems...',
    'Checking insider sources...',
    'Finding the good stuff...',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final message = _loadingMessages[
        DateTime.now().millisecond % _loadingMessages.length];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.amber),
          const SizedBox(height: 24),
          Text(
            message,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.grey.shade400,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty state with example prompts.
class _EmptyState extends StatelessWidget {
  final List<String> prompts;
  final ValueChanged<String> onPromptTap;

  const _EmptyState({
    required this.prompts,
    required this.onPromptTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Center(
            child: Icon(
              Icons.restaurant_menu,
              size: 64,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'What are you in the mood for?',
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Ask anything! I know all the hidden spots.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade500,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            'Try these:',
            style: theme.textTheme.titleSmall?.copyWith(
              color: Colors.grey.shade400,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: prompts.map((prompt) {
              return InkWell(
                onTap: () => onPromptTap(prompt),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade700),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 16,
                        color: Colors.amber.shade400,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          prompt,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// Wide layout with map on left, list on right.
/// Map is only shown if response.showMap is true.
class _WideResultsLayout extends StatelessWidget {
  final FoodDiscoveryResponse response;
  final GoogleMapController? mapController;
  final ValueChanged<GoogleMapController> onMapCreated;
  final int? selectedIndex;
  final ValueChanged<int> onSelectPlace;
  final ValueChanged<DiscoveredPlace> onOpenInMaps;

  const _WideResultsLayout({
    required this.response,
    required this.mapController,
    required this.onMapCreated,
    required this.selectedIndex,
    required this.onSelectPlace,
    required this.onOpenInMaps,
  });

  @override
  Widget build(BuildContext context) {
    // Only show map for discovery queries, not for menu/info queries
    if (!response.showMap) {
      return _ResultsList(
        response: response,
        selectedIndex: selectedIndex,
        onSelectPlace: onSelectPlace,
        onOpenInMaps: onOpenInMaps,
        isMobile: false,
      );
    }

    return Row(
      children: [
        // Map
        Expanded(
          flex: 3,
          child: _MapView(
            places: response.places,
            onMapCreated: onMapCreated,
            selectedIndex: selectedIndex,
            onMarkerTap: onSelectPlace,
          ),
        ),
        // Results list
        Expanded(
          flex: 2,
          child: _ResultsList(
            response: response,
            selectedIndex: selectedIndex,
            onSelectPlace: onSelectPlace,
            onOpenInMaps: onOpenInMaps,
            isMobile: false,
          ),
        ),
      ],
    );
  }
}

/// Mobile layout with stacked map and list.
/// Map is only shown if response.showMap is true.
class _MobileResultsLayout extends StatelessWidget {
  final FoodDiscoveryResponse response;
  final GoogleMapController? mapController;
  final ValueChanged<GoogleMapController> onMapCreated;
  final int? selectedIndex;
  final ValueChanged<int> onSelectPlace;
  final ValueChanged<DiscoveredPlace> onOpenInMaps;

  const _MobileResultsLayout({
    required this.response,
    required this.mapController,
    required this.onMapCreated,
    required this.selectedIndex,
    required this.onSelectPlace,
    required this.onOpenInMaps,
  });

  @override
  Widget build(BuildContext context) {
    // Only show map for discovery queries, not for menu/info queries
    if (!response.showMap) {
      return _ResultsList(
        response: response,
        selectedIndex: selectedIndex,
        onSelectPlace: onSelectPlace,
        onOpenInMaps: onOpenInMaps,
        isMobile: true,
      );
    }

    return Column(
      children: [
        // Map (smaller on mobile)
        SizedBox(
          height: 200,
          child: _MapView(
            places: response.places,
            onMapCreated: onMapCreated,
            selectedIndex: selectedIndex,
            onMarkerTap: onSelectPlace,
          ),
        ),
        // Results list
        Expanded(
          child: _ResultsList(
            response: response,
            selectedIndex: selectedIndex,
            onSelectPlace: onSelectPlace,
            onOpenInMaps: onOpenInMaps,
            isMobile: true,
          ),
        ),
      ],
    );
  }
}

/// Map view with markers.
class _MapView extends StatelessWidget {
  final List<DiscoveredPlace> places;
  final ValueChanged<GoogleMapController> onMapCreated;
  final int? selectedIndex;
  final ValueChanged<int> onMarkerTap;

  const _MapView({
    required this.places,
    required this.onMapCreated,
    required this.selectedIndex,
    required this.onMarkerTap,
  });

  /// Check if coordinates are valid (not Null Island at 0,0)
  bool _hasValidCoordinates(DiscoveredPlace place) {
    return place.latitude != 0 || place.longitude != 0;
  }

  @override
  Widget build(BuildContext context) {
    // Filter to only places with valid coordinates
    final validPlaces = places.where(_hasValidCoordinates).toList();

    if (validPlaces.isEmpty) {
      return Container(
        color: Colors.grey.shade800,
        child: const Center(
          child: Text('No map locations available', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    final center = LatLng(
      validPlaces.map((p) => p.latitude).reduce((a, b) => a + b) / validPlaces.length,
      validPlaces.map((p) => p.longitude).reduce((a, b) => a + b) / validPlaces.length,
    );

    return GoogleMap(
      initialCameraPosition: CameraPosition(target: center, zoom: 13),
      onMapCreated: onMapCreated,
      markers: places.asMap().entries
          .where((entry) => _hasValidCoordinates(entry.value))
          .map((entry) {
        final index = entry.key;
        final place = entry.value;
        final isSelected = index == selectedIndex;
        return Marker(
          markerId: MarkerId(place.placeId),
          position: LatLng(place.latitude, place.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            isSelected ? BitmapDescriptor.hueOrange : BitmapDescriptor.hueAzure,
          ),
          infoWindow: InfoWindow(
            title: place.name,
            snippet: '${place.rating} - ${place.priceLevel}',
          ),
          onTap: () => onMarkerTap(index),
        );
      }).toSet(),
      mapType: MapType.normal,
      myLocationEnabled: false,
      zoomControlsEnabled: true,
    );
  }
}

/// Results list.
class _ResultsList extends StatefulWidget {
  final FoodDiscoveryResponse response;
  final int? selectedIndex;
  final ValueChanged<int> onSelectPlace;
  final ValueChanged<DiscoveredPlace> onOpenInMaps;
  final bool isMobile;

  const _ResultsList({
    required this.response,
    required this.selectedIndex,
    required this.onSelectPlace,
    required this.onOpenInMaps,
    this.isMobile = false,
  });

  @override
  State<_ResultsList> createState() => _ResultsListState();
}

class _ResultsListState extends State<_ResultsList> {
  bool _summaryExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: Colors.grey.shade900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI response summary - collapsible on mobile
          if (widget.response.summary.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.grey.shade800,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: widget.isMobile ? () => setState(() => _summaryExpanded = !_summaryExpanded) : null,
                    child: Row(
                      children: [
                        Icon(Icons.auto_awesome,
                            size: 16, color: Colors.amber.shade400),
                        const SizedBox(width: 8),
                        Text(
                          'Butler\'s Take',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: Colors.amber.shade400,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.isMobile) ...[
                          const Spacer(),
                          Icon(
                            _summaryExpanded ? Icons.expand_less : Icons.expand_more,
                            size: 20,
                            color: Colors.grey.shade400,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (widget.isMobile && !_summaryExpanded)
                    // Collapsed: show only first line with ellipsis
                    Text(
                      widget.response.summary,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade400,
                        height: 1.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  else
                    // Expanded or desktop: show full text
                    Text(
                      widget.response.summary,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade300,
                        height: 1.4,
                      ),
                    ),
                ],
              ),
            ),
          // Places count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '${widget.response.places.length} places found',
              style: theme.textTheme.titleSmall?.copyWith(
                color: Colors.grey.shade400,
              ),
            ),
          ),
          // Places list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: widget.response.places.length,
              itemBuilder: (context, index) {
                final place = widget.response.places[index];
                final isSelected = index == widget.selectedIndex;
                return _PlaceCard(
                  place: place,
                  index: index + 1,
                  isSelected: isSelected,
                  onTap: () => widget.onSelectPlace(index),
                  onNavigate: () => widget.onOpenInMaps(place),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual place card.
class _PlaceCard extends StatelessWidget {
  final DiscoveredPlace place;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onNavigate;

  const _PlaceCard({
    required this.place,
    required this.index,
    required this.isSelected,
    required this.onTap,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isSelected ? Colors.grey.shade700 : Colors.grey.shade800,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: Colors.amber.shade400, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: place.photoUrl != null
                    ? Image.network(
                        place.photoUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) => _PlaceholderImage(),
                      )
                    : _PlaceholderImage(),
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      place.address,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.amber.shade400),
                        const SizedBox(width: 4),
                        Text(
                          place.rating.toStringAsFixed(1),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (place.reviewCount > 0) ...[
                          Text(
                            ' (${place.reviewCount})',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                        const SizedBox(width: 12),
                        Text(
                          place.priceLevel,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                    if (place.whyRecommended.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        place.whyRecommended,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.amber.shade200,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                    // Must-order dishes
                    if (place.mustOrder != null && place.mustOrder!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        'MUST ORDER',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.amber.shade400,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ...place.mustOrder!.take(3).map((dish) => Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('• ', style: TextStyle(color: Colors.amber.shade300)),
                            Expanded(
                              child: Text(
                                dish,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                    // Pro tips
                    if (place.proTips != null && place.proTips!.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade900.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.lightbulb_outline, size: 14, color: Colors.amber.shade300),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                place.proTips!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.amber.shade200,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Action buttons (save, website, phone, navigate)
              Column(
                children: [
                  SaveButtonCompact(
                    name: place.name,
                    placeId: place.placeId,
                    address: place.address,
                    cuisineType: place.categories.isNotEmpty ? place.categories.first : null,
                    imageUrl: place.photoUrl,
                    rating: place.rating,
                    priceLevel: _parsePriceLevel(place.priceLevel),
                    source: SavedRestaurantSource.askButler,
                  ),
                  if (place.websiteUrl != null)
                    IconButton(
                      icon: Icon(Icons.language, color: Colors.grey.shade400, size: 20),
                      onPressed: () => _launchUrl(place.websiteUrl!),
                      tooltip: 'Website',
                      visualDensity: VisualDensity.compact,
                    ),
                  if (place.phoneNumber != null)
                    IconButton(
                      icon: Icon(Icons.phone, color: Colors.grey.shade400, size: 20),
                      onPressed: () => _launchUrl('tel:${place.phoneNumber}'),
                      tooltip: place.phoneNumber,
                      visualDensity: VisualDensity.compact,
                    ),
                  IconButton(
                    icon: const Icon(Icons.directions, color: Colors.amber),
                    onPressed: onNavigate,
                    tooltip: 'Get directions',
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Parse price level string (e.g., "$$") to int (e.g., 2)
  int? _parsePriceLevel(String priceLevel) {
    if (priceLevel.isEmpty) return null;
    final dollarCount = priceLevel.split('\$').length - 1;
    return dollarCount > 0 ? dollarCount : null;
  }

  /// Launch a URL (website or phone)
  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}

/// Placeholder for missing images.
class _PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      color: Colors.grey.shade700,
      child: Icon(
        Icons.restaurant,
        color: Colors.grey.shade500,
        size: 32,
      ),
    );
  }
}
