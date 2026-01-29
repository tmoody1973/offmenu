import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_butler_client/food_butler_client.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../../theme/app_theme.dart';
import '../../widgets/save_button.dart';

/// Map detail screen showing restaurants in an Eater-style layout.
/// Editorial descriptions + map + photos.
class MapDetailScreen extends StatefulWidget {
  final String slug;

  const MapDetailScreen({super.key, required this.slug});

  @override
  State<MapDetailScreen> createState() => _MapDetailScreenState();
}

class _MapDetailScreenState extends State<MapDetailScreen> {
  CuratedMap? _map;
  List<MapRestaurant> _restaurants = [];
  bool _isLoading = true;
  String? _error;
  GoogleMapController? _mapController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadMap();
  }

  Future<void> _loadMap() async {
    try {
      final map = await client.curatedMaps.getMapBySlug(widget.slug);
      if (map == null) {
        setState(() {
          _error = 'Map not found';
          _isLoading = false;
        });
        return;
      }

      final restaurants = await client.curatedMaps.getMapRestaurants(map.id!);

      setState(() {
        _map = map;
        _restaurants = restaurants;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load map: $e';
        _isLoading = false;
      });
    }
  }

  void _onRestaurantTapped(int index) {
    setState(() => _selectedIndex = index);

    // Animate map to restaurant
    final restaurant = _restaurants[index];
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(restaurant.latitude, restaurant.longitude),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.charcoal,
        appBar: AppBar(backgroundColor: AppTheme.charcoal),
        body: const Center(
          child: CircularProgressIndicator(color: AppTheme.burntOrange),
        ),
      );
    }

    if (_error != null || _map == null) {
      return Scaffold(
        backgroundColor: AppTheme.charcoal,
        appBar: AppBar(backgroundColor: AppTheme.charcoal),
        body: Center(
          child: Text(
            _error ?? 'Something went wrong',
            style: AppTheme.bodySans.copyWith(color: AppTheme.creamMuted),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.charcoal,
      body: Column(
        children: [
          // Fixed header with title and map
          Container(
            color: AppTheme.charcoal,
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title bar with back button
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: AppTheme.cream),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: Text(
                          _map!.title,
                          style: AppTheme.headlineSerif.copyWith(fontSize: 20),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  // Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      _map!.shortDescription,
                      style: AppTheme.bodySans.copyWith(
                        fontSize: 14,
                        color: AppTheme.creamMuted,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                    child: Text(
                      '${_restaurants.length} restaurants',
                      style: AppTheme.labelSans.copyWith(
                        fontSize: 13,
                        color: AppTheme.creamMuted,
                      ),
                    ),
                  ),
                  // Sticky map
                  Container(
                    height: 220,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.cream.withAlpha(20)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _restaurants.isNotEmpty
                        ? GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                _restaurants.first.latitude,
                                _restaurants.first.longitude,
                              ),
                              zoom: 12,
                            ),
                            markers: _buildMarkers(),
                            onMapCreated: (controller) {
                              _mapController = controller;
                              _fitBounds();
                            },
                            mapType: MapType.normal,
                            myLocationEnabled: false,
                            zoomControlsEnabled: false,
                          )
                        : Container(
                            color: AppTheme.charcoalLight,
                            child: const Center(
                              child: Icon(Icons.map, color: AppTheme.creamMuted),
                            ),
                          ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          // Scrollable restaurant list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 100),
              itemCount: _restaurants.length + 1, // +1 for header
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Header
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Text(
                      'The Restaurants',
                      style: AppTheme.headlineSerif.copyWith(
                        fontSize: 22,
                        color: AppTheme.cream,
                      ),
                    ),
                  );
                }
                final restaurant = _restaurants[index - 1];
                return _RestaurantCard(
                  restaurant: restaurant,
                  index: index,
                  isSelected: index - 1 == _selectedIndex,
                  onTap: () => _onRestaurantTapped(index - 1),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Check if coordinates are valid (not Null Island at 0,0)
  bool _hasValidCoordinates(MapRestaurant r) {
    return r.latitude != 0 || r.longitude != 0;
  }

  Set<Marker> _buildMarkers() {
    return _restaurants.asMap().entries
        .where((entry) => _hasValidCoordinates(entry.value))
        .map((entry) {
      final index = entry.key;
      final restaurant = entry.value;

      return Marker(
        markerId: MarkerId(restaurant.id.toString()),
        position: LatLng(restaurant.latitude, restaurant.longitude),
        infoWindow: InfoWindow(title: restaurant.name),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          index == _selectedIndex
              ? BitmapDescriptor.hueOrange
              : BitmapDescriptor.hueRed,
        ),
        onTap: () => _onRestaurantTapped(index),
      );
    }).toSet();
  }

  void _fitBounds() {
    if (_restaurants.isEmpty || _mapController == null) return;

    // Only consider restaurants with valid coordinates
    final validRestaurants =
        _restaurants.where(_hasValidCoordinates).toList();

    if (validRestaurants.isEmpty) return;

    double minLat = validRestaurants.first.latitude;
    double maxLat = validRestaurants.first.latitude;
    double minLng = validRestaurants.first.longitude;
    double maxLng = validRestaurants.first.longitude;

    for (final r in validRestaurants) {
      if (r.latitude < minLat) minLat = r.latitude;
      if (r.latitude > maxLat) maxLat = r.latitude;
      if (r.longitude < minLng) minLng = r.longitude;
      if (r.longitude > maxLng) maxLng = r.longitude;
    }

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        50,
      ),
    );
  }
}

/// Eater-style restaurant card with editorial description and photo gallery.
class _RestaurantCard extends StatelessWidget {
  final MapRestaurant restaurant;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const _RestaurantCard({
    required this.restaurant,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  /// Parse additional photos from JSON.
  List<Map<String, dynamic>> _getPhotos() {
    final photos = <Map<String, dynamic>>[];

    // Add primary photo first
    if (restaurant.primaryPhotoUrl != null) {
      photos.add({'url': restaurant.primaryPhotoUrl});
    }

    // Add additional photos from JSON
    if (restaurant.additionalPhotosJson != null) {
      try {
        final List<dynamic> additionalPhotos =
            jsonDecode(restaurant.additionalPhotosJson!);
        for (final photo in additionalPhotos.skip(1)) { // Skip first since it's the primary
          if (photo is Map<String, dynamic>) {
            photos.add(photo);
          }
        }
      } catch (e) {
        // Ignore parsing errors
      }
    }

    return photos;
  }

  @override
  Widget build(BuildContext context) {
    final photos = _getPhotos();
    final hasMultiplePhotos = photos.length > 1;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        decoration: BoxDecoration(
          color: AppTheme.charcoalLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppTheme.burntOrange
                : AppTheme.cream.withAlpha(10),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo gallery at TOP for visual impact
            if (photos.isNotEmpty)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(14)),
                    child: hasMultiplePhotos
                        ? _PhotoGallery(photos: photos)
                        : Image.network(
                            photos.first['url'] as String,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 200,
                              color: AppTheme.charcoal,
                              child: const Center(
                                child: Icon(Icons.restaurant,
                                    color: AppTheme.creamMuted, size: 48),
                              ),
                            ),
                          ),
                  ),
                  // Save button in top-right corner
                  Positioned(
                    top: 12,
                    right: 12,
                    child: SaveButton(
                      name: restaurant.name,
                      placeId: restaurant.googlePlaceId,
                      address: restaurant.address,
                      cuisineType: restaurant.cuisineTypes,
                      imageUrl: restaurant.primaryPhotoUrl,
                      rating: restaurant.googleRating,
                      priceLevel: restaurant.priceLevel,
                      source: SavedRestaurantSource.map,
                      showBackground: true,
                    ),
                  ),
                ],
              ),

            // Number badge overlay on photo
            if (photos.isNotEmpty)
              Transform.translate(
                offset: const Offset(16, -20),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.burntOrange,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(100),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$index',
                    style: AppTheme.headlineSerif.copyWith(
                      fontSize: 20,
                      color: AppTheme.cream,
                    ),
                  ),
                ),
              ),

            // Content
            Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                photos.isNotEmpty ? 0 : 20,
                20,
                20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant name
                  if (photos.isEmpty) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: AppTheme.burntOrange,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$index',
                            style: AppTheme.labelSans.copyWith(
                              fontSize: 14,
                              color: AppTheme.cream,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            restaurant.name,
                            style: AppTheme.headlineSerif.copyWith(
                              fontSize: 22,
                              color: AppTheme.cream,
                            ),
                          ),
                        ),
                        // Save button when no photo
                        SaveButton(
                          name: restaurant.name,
                          placeId: restaurant.googlePlaceId,
                          address: restaurant.address,
                          cuisineType: restaurant.cuisineTypes,
                          imageUrl: restaurant.primaryPhotoUrl,
                          rating: restaurant.googleRating,
                          priceLevel: restaurant.priceLevel,
                          source: SavedRestaurantSource.map,
                          size: 22,
                        ),
                      ],
                    ),
                  ] else ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            restaurant.name,
                            style: AppTheme.headlineSerif.copyWith(
                              fontSize: 22,
                              color: AppTheme.cream,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  // Cuisine and price inline
                  if (restaurant.cuisineTypes != null ||
                      restaurant.priceLevel != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (restaurant.cuisineTypes != null) ...[
                          Text(
                            restaurant.cuisineTypes!,
                            style: AppTheme.labelSans.copyWith(
                              fontSize: 12,
                              color: AppTheme.creamMuted,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                        if (restaurant.cuisineTypes != null &&
                            restaurant.priceLevel != null)
                          Text(
                            '  •  ',
                            style: TextStyle(color: AppTheme.creamMuted.withAlpha(100)),
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
                        if (restaurant.googleRating != null) ...[
                          Text(
                            '  •  ',
                            style: TextStyle(color: AppTheme.creamMuted.withAlpha(100)),
                          ),
                          const Icon(Icons.star, size: 14, color: AppTheme.agedBrass),
                          const SizedBox(width: 4),
                          Text(
                            restaurant.googleRating!.toStringAsFixed(1),
                            style: AppTheme.labelSans.copyWith(
                              fontSize: 12,
                              color: AppTheme.creamMuted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Editorial description (the soul of the card)
                  Text(
                    restaurant.editorialDescription,
                    style: AppTheme.bodySans.copyWith(
                      fontSize: 15,
                      color: AppTheme.cream,
                      height: 1.6,
                    ),
                  ),

                  // Must-order dishes
                  if (restaurant.mustOrderDishes != null &&
                      restaurant.mustOrderDishes!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.burntOrange.withAlpha(20),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.burntOrange.withAlpha(50),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.restaurant_menu,
                            size: 16,
                            color: AppTheme.burntOrange,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'MUST ORDER',
                                  style: AppTheme.labelSans.copyWith(
                                    fontSize: 10,
                                    color: AppTheme.burntOrange,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  restaurant.mustOrderDishes!,
                                  style: AppTheme.bodySans.copyWith(
                                    fontSize: 14,
                                    color: AppTheme.cream,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Address and directions
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppTheme.creamMuted,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          restaurant.address,
                          style: AppTheme.bodySans.copyWith(
                            fontSize: 13,
                            color: AppTheme.creamMuted,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _launchUrl(
                          'https://www.google.com/maps/dir/?api=1&destination=${Uri.encodeComponent(restaurant.address)}',
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.burntOrange.withAlpha(30),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Directions',
                            style: AppTheme.labelSans.copyWith(
                              fontSize: 12,
                              color: AppTheme.burntOrange,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Action buttons
                  if (restaurant.reservationUrl != null ||
                      restaurant.phoneNumber != null ||
                      restaurant.websiteUrl != null) ...[
                    const SizedBox(height: 16),
                    const Divider(color: AppTheme.charcoal, height: 1),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        if (restaurant.reservationUrl != null)
                          Expanded(
                            child: _ActionButton(
                              icon: Icons.calendar_today,
                              label: 'Reserve',
                              color: AppTheme.burntOrange,
                              filled: true,
                              onTap: () => _launchUrl(restaurant.reservationUrl!),
                            ),
                          ),
                        if (restaurant.reservationUrl != null &&
                            (restaurant.phoneNumber != null ||
                                restaurant.websiteUrl != null))
                          const SizedBox(width: 12),
                        if (restaurant.phoneNumber != null)
                          _ActionButton(
                            icon: Icons.phone,
                            label: 'Call',
                            onTap: () =>
                                _launchUrl('tel:${restaurant.phoneNumber}'),
                          ),
                        if (restaurant.phoneNumber != null &&
                            restaurant.websiteUrl != null)
                          const SizedBox(width: 12),
                        if (restaurant.websiteUrl != null)
                          _ActionButton(
                            icon: Icons.language,
                            label: 'Website',
                            onTap: () => _launchUrl(restaurant.websiteUrl!),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

/// Horizontal scrolling photo gallery.
class _PhotoGallery extends StatelessWidget {
  final List<Map<String, dynamic>> photos;

  const _PhotoGallery({required this.photos});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: photos.length,
        itemBuilder: (context, index) {
          final photo = photos[index];
          final url = photo['url'] as String? ??
                      photo['thumbnailUrl'] as String? ?? '';

          return Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppTheme.charcoal,
                  child: const Center(
                    child: Icon(Icons.broken_image,
                        color: AppTheme.creamMuted, size: 48),
                  ),
                ),
              ),
              // Photo counter indicator
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(150),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${index + 1}/${photos.length}',
                    style: AppTheme.labelSans.copyWith(
                      fontSize: 12,
                      color: AppTheme.cream,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Small action button with optional filled style.
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final bool filled;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.color,
    this.filled = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? AppTheme.creamMuted;

    if (filled) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: AppTheme.cream),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTheme.labelSans.copyWith(
                  fontSize: 14,
                  color: AppTheme.cream,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: buttonColor.withAlpha(100)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: buttonColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTheme.labelSans.copyWith(
                fontSize: 13,
                color: buttonColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
