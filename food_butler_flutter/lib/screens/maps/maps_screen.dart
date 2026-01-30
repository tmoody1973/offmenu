import 'package:flutter/material.dart';
import 'package:food_butler_client/food_butler_client.dart';
import 'package:go_router/go_router.dart';

import '../../main.dart';
import '../../theme/app_theme.dart';
import '../../widgets/city_picker.dart';

/// Eater-style curated maps screen.
/// Shows curated restaurant maps for the selected city.
class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  FavoriteCity? _selectedCity;
  List<CuratedMap> _maps = [];
  List<CuratedMap> _myMaps = []; // User's personal maps
  bool _isLoading = false;
  bool _isLoadingMyMaps = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMyMaps(); // Load user's maps on init
  }

  /// Load user's personal maps (all cities)
  Future<void> _loadMyMaps() async {
    try {
      final maps = await client.curatedMaps.getUserMaps();
      if (mounted) {
        setState(() {
          _myMaps = maps;
          _isLoadingMyMaps = false;
        });
      }
    } catch (e) {
      debugPrint('Failed to load my maps: $e');
      if (mounted) {
        setState(() => _isLoadingMyMaps = false);
      }
    }
  }

  Future<void> _loadMapsForCity(FavoriteCity city) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final maps = await client.curatedMaps.getMapsForCity(city.cityName);
      setState(() {
        _maps = maps;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load maps: $e';
        _isLoading = false;
      });
    }
  }

  void _onCitySelected(FavoriteCity city) {
    setState(() => _selectedCity = city);
    _loadMapsForCity(city);
  }

  void _showAddCitySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.charcoal,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _AddCitySheet(
        onCityAdded: (city) {
          Navigator.pop(context);
          _onCitySelected(city);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.charcoal,
      // FAB to create new map
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/maps/create'),
        backgroundColor: AppTheme.burntOrange,
        foregroundColor: AppTheme.cream,
        icon: const Icon(Icons.add),
        label: const Text('Create Map'),
      ),
      body: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            floating: true,
            backgroundColor: AppTheme.charcoal,
            title: Text(
              'Maps',
              style: AppTheme.headlineSerif.copyWith(fontSize: 24),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  _loadMyMaps();
                  if (_selectedCity != null) {
                    _loadMapsForCity(_selectedCity!);
                  }
                },
                tooltip: 'Refresh',
              ),
            ],
          ),

          // My Maps section (always show if user has maps)
          if (_myMaps.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: _SectionHeader(
                title: 'My Maps',
                subtitle: '${_myMaps.length} personal ${_myMaps.length == 1 ? 'map' : 'maps'}',
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _myMaps.length,
                  itemBuilder: (context, index) {
                    final map = _myMaps[index];
                    return _MyMapCard(
                      map: map,
                      onTap: () => context.push('/maps/${map.slug}'),
                      onDelete: () => _confirmDeleteMap(map),
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ] else if (_isLoadingMyMaps) ...[
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.creamMuted,
                    ),
                  ),
                ),
              ),
            ),
          ],

          // City picker
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Text(
                    'Browse by City',
                    style: AppTheme.labelSans.copyWith(
                      fontSize: 12,
                      color: AppTheme.creamMuted,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                CityPicker(
                  selectedCity: _selectedCity,
                  onCitySelected: _onCitySelected,
                  onAddCity: _showAddCitySheet,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // Content based on state
          if (_selectedCity == null)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _NoCitySelected(onAddCity: _showAddCitySheet),
            )
          else if (_isLoading)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(48),
                child: Center(
                  child: CircularProgressIndicator(color: AppTheme.burntOrange),
                ),
              ),
            )
          else if (_error != null)
            SliverToBoxAdapter(
              child: _ErrorState(
                message: _error!,
                onRetry: () => _loadMapsForCity(_selectedCity!),
              ),
            )
          else if (_maps.isEmpty)
            SliverToBoxAdapter(
              child: _EmptyMaps(
                cityName: _selectedCity!.cityName,
                onGenerate: () => _generateMapsForCity(_selectedCity!),
              ),
            )
          else ...[
            // Section: Featured Maps
            SliverToBoxAdapter(
              child: _SectionHeader(
                title: 'Maps in ${_selectedCity!.cityName}',
                subtitle: '${_maps.length} curated guides',
              ),
            ),

            // Maps grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final map = _maps[index];
                    return _MapCard(
                      map: map,
                      onTap: () => context.push('/maps/${map.slug}'),
                    );
                  },
                  childCount: _maps.length,
                ),
              ),
            ),

            // Bottom padding
            const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ],
      ),
    );
  }

  void _showCreateMapSheet() {
    if (_selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a city first')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.charcoal,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _CreateMapSheet(
        city: _selectedCity!,
        onMapCreated: (map) {
          Navigator.pop(context);
          context.push('/maps/${map.slug}');
        },
      ),
    );
  }

  /// Show delete confirmation dialog
  Future<void> _confirmDeleteMap(CuratedMap map) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.charcoalLight,
        title: Text(
          'Delete Map?',
          style: AppTheme.headlineSans.copyWith(color: AppTheme.cream),
        ),
        content: Text(
          'Are you sure you want to delete "${map.title}"? This cannot be undone.',
          style: AppTheme.bodySans.copyWith(color: AppTheme.creamMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle(color: AppTheme.creamMuted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );

    if (confirmed == true && map.id != null) {
      try {
        await client.curatedMaps.deleteUserMap(map.id!);
        _loadMyMaps(); // Refresh the list
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Deleted "${map.title}"'),
              backgroundColor: AppTheme.charcoalLight,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete: $e'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    }
  }

  Future<void> _generateMapsForCity(FavoriteCity city) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.charcoalLight,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppTheme.burntOrange),
            const SizedBox(height: 16),
            Text(
              'Discovering restaurants in ${city.cityName}...',
              style: AppTheme.bodySans.copyWith(color: AppTheme.cream),
            ),
            const SizedBox(height: 8),
            Text(
              'This may take a minute',
              style: AppTheme.bodySans.copyWith(
                color: AppTheme.creamMuted,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );

    try {
      // Generate "Best Of" map
      await client.curatedMaps.generateMap(
        cityName: city.cityName,
        stateOrRegion: city.stateOrRegion,
        country: city.country,
        mapType: 'best-of',
        maxRestaurants: 15,
      );

      if (mounted) {
        Navigator.pop(context); // Dismiss dialog
        _loadMapsForCity(city);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate maps: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}

/// Section header.
class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.headlineSerif.copyWith(
              fontSize: 22,
              color: AppTheme.cream,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTheme.bodySans.copyWith(
              fontSize: 14,
              color: AppTheme.creamMuted,
            ),
          ),
        ],
      ),
    );
  }
}

/// Curated map card (Eater-style).
class _MapCard extends StatelessWidget {
  final CuratedMap map;
  final VoidCallback onTap;

  const _MapCard({
    required this.map,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppTheme.charcoalLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.cream.withAlpha(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: map.coverImageUrl != null
                    ? Image.network(
                        map.coverImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _PlaceholderImage(),
                      )
                    : _PlaceholderImage(),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.burntOrange.withAlpha(20),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _categoryLabel(map.category),
                      style: AppTheme.labelSans.copyWith(
                        fontSize: 11,
                        color: AppTheme.burntOrange,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    map.title,
                    style: AppTheme.headlineSerif.copyWith(
                      fontSize: 20,
                      color: AppTheme.cream,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Description
                  Text(
                    map.shortDescription,
                    style: AppTheme.bodySans.copyWith(
                      fontSize: 14,
                      color: AppTheme.creamMuted,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Meta
                  Row(
                    children: [
                      const Icon(
                        Icons.restaurant,
                        size: 14,
                        color: AppTheme.creamMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${map.restaurantCount} restaurants',
                        style: AppTheme.labelSans.copyWith(
                          fontSize: 12,
                          color: AppTheme.creamMuted,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'View Map →',
                        style: AppTheme.labelSans.copyWith(
                          fontSize: 13,
                          color: AppTheme.burntOrange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _categoryLabel(String category) {
    switch (category) {
      case 'bestOf':
        return 'BEST OF';
      case 'cuisine':
        return map.cuisineType?.toUpperCase() ?? 'CUISINE';
      case 'occasion':
        return 'OCCASION';
      case 'hiddenGems':
        return 'HIDDEN GEMS';
      case 'neighborhood':
        return 'NEIGHBORHOOD';
      case 'custom':
        return 'MY MAP';
      default:
        return category.toUpperCase();
    }
  }
}

/// Placeholder image for maps without cover.
class _PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.charcoal,
      child: const Center(
        child: Icon(
          Icons.map,
          size: 48,
          color: AppTheme.creamMuted,
        ),
      ),
    );
  }
}

/// Compact card for "My Maps" horizontal scroll.
class _MyMapCard extends StatelessWidget {
  final CuratedMap map;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const _MyMapCard({
    required this.map,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onDelete,
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppTheme.charcoalLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.burntOrange.withAlpha(50)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover image with delete button
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
                  child: SizedBox(
                    height: 80,
                    width: double.infinity,
                    child: map.coverImageUrl != null
                        ? Image.network(
                            map.coverImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppTheme.charcoal,
                              child: const Center(
                                child: Icon(Icons.map, color: AppTheme.creamMuted, size: 32),
                              ),
                            ),
                          )
                        : Container(
                            color: AppTheme.charcoal,
                            child: const Center(
                              child: Icon(Icons.map, color: AppTheme.creamMuted, size: 32),
                            ),
                          ),
                  ),
                ),
                // Delete button
                if (onDelete != null)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppTheme.charcoal.withAlpha(200),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: AppTheme.creamMuted,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // My Map badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.burntOrange.withAlpha(30),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'MY MAP',
                        style: AppTheme.labelSans.copyWith(
                          fontSize: 9,
                          color: AppTheme.burntOrange,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Title
                    Text(
                      map.title,
                      style: AppTheme.bodySans.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.cream,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // City & count
                    Text(
                      '${map.cityName} \u2022 ${map.restaurantCount} spots',
                      style: AppTheme.labelSans.copyWith(
                        fontSize: 11,
                        color: AppTheme.creamMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// No city selected state.
class _NoCitySelected extends StatelessWidget {
  final VoidCallback onAddCity;

  const _NoCitySelected({required this.onAddCity});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.explore,
              size: 64,
              color: AppTheme.creamMuted,
            ),
            const SizedBox(height: 24),
            Text(
              'Pick Your Cities',
              style: AppTheme.headlineSerif.copyWith(
                fontSize: 24,
                color: AppTheme.cream,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Like a weather app for food. Add your home city and up to 10 favorites.',
              style: AppTheme.bodySans.copyWith(
                fontSize: 15,
                color: AppTheme.creamMuted,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAddCity,
              icon: const Icon(Icons.add_location_alt),
              label: const Text('Add Your First City'),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.burntOrange,
                foregroundColor: AppTheme.cream,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error state.
class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppTheme.errorColor),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTheme.bodySans.copyWith(color: AppTheme.creamMuted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty maps state - prompts to generate.
class _EmptyMaps extends StatelessWidget {
  final String cityName;
  final VoidCallback onGenerate;

  const _EmptyMaps({
    required this.cityName,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome, size: 64, color: AppTheme.agedBrass),
            const SizedBox(height: 24),
            Text(
              'No maps for $cityName yet',
              style: AppTheme.headlineSerif.copyWith(
                fontSize: 22,
                color: AppTheme.cream,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Let the Butler discover the best restaurants and create curated maps for you.',
              style: AppTheme.bodySans.copyWith(
                fontSize: 15,
                color: AppTheme.creamMuted,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onGenerate,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Discover Restaurants'),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.burntOrange,
                foregroundColor: AppTheme.cream,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Add city bottom sheet.
class _AddCitySheet extends StatefulWidget {
  final ValueChanged<FavoriteCity> onCityAdded;

  const _AddCitySheet({required this.onCityAdded});

  @override
  State<_AddCitySheet> createState() => _AddCitySheetState();
}

class _AddCitySheetState extends State<_AddCitySheet> {
  final _cityController = TextEditingController();
  bool _isHomeCity = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _addCity() async {
    final text = _cityController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      // Parse city input (e.g., "Austin, TX" or "Tokyo, Japan")
      final parts = text.split(',').map((p) => p.trim()).toList();
      final cityName = parts.first;
      final stateOrRegion = parts.length > 1 ? parts[1] : null;

      // TODO: Geocode to get lat/lng
      // For now, use placeholder coordinates
      final city = await client.curatedMaps.addFavoriteCity(
        cityName: cityName,
        stateOrRegion: stateOrRegion,
        country: 'USA', // TODO: Detect from geocoding
        latitude: 0, // TODO: From geocoding
        longitude: 0,
        isHomeCity: _isHomeCity,
      );

      widget.onCityAdded(city);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add city: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add a City',
            style: AppTheme.headlineSerif.copyWith(
              fontSize: 24,
              color: AppTheme.cream,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Like a weather app for food. Add up to 11 cities.',
            style: AppTheme.bodySans.copyWith(
              fontSize: 14,
              color: AppTheme.creamMuted,
            ),
          ),
          const SizedBox(height: 24),

          TextField(
            controller: _cityController,
            style: AppTheme.bodySans.copyWith(color: AppTheme.cream),
            decoration: InputDecoration(
              hintText: 'City name (e.g., Austin, TX)',
              hintStyle: AppTheme.bodySans.copyWith(color: AppTheme.creamMuted),
              prefixIcon: const Icon(Icons.location_city, color: AppTheme.creamMuted),
            ),
            textCapitalization: TextCapitalization.words,
            autofocus: true,
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Checkbox(
                value: _isHomeCity,
                onChanged: (value) => setState(() => _isHomeCity = value ?? false),
                activeColor: AppTheme.burntOrange,
              ),
              Text(
                'This is my home city',
                style: AppTheme.bodySans.copyWith(color: AppTheme.cream),
              ),
            ],
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _isLoading ? null : _addCity,
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.burntOrange,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.cream,
                      ),
                    )
                  : const Text('Add City'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Create custom map bottom sheet.
class _CreateMapSheet extends StatefulWidget {
  final FavoriteCity city;
  final ValueChanged<CuratedMap> onMapCreated;

  const _CreateMapSheet({
    required this.city,
    required this.onMapCreated,
  });

  @override
  State<_CreateMapSheet> createState() => _CreateMapSheetState();
}

class _CreateMapSheetState extends State<_CreateMapSheet> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _createMap() async {
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();

    if (title.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final map = await client.curatedMaps.createUserMap(
        cityName: widget.city.cityName,
        stateOrRegion: widget.city.stateOrRegion,
        country: widget.city.country,
        title: title,
        shortDescription: desc.isNotEmpty ? desc : 'My curated restaurant collection',
      );

      widget.onMapCreated(map);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create map: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create Your Map',
            style: AppTheme.headlineSerif.copyWith(
              fontSize: 24,
              color: AppTheme.cream,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Curate your own collection in ${widget.city.cityName}',
            style: AppTheme.bodySans.copyWith(
              fontSize: 14,
              color: AppTheme.creamMuted,
            ),
          ),
          const SizedBox(height: 24),

          TextField(
            controller: _titleController,
            style: AppTheme.bodySans.copyWith(color: AppTheme.cream),
            decoration: InputDecoration(
              hintText: 'Map title (e.g., My Favorite Tacos)',
              hintStyle: AppTheme.bodySans.copyWith(color: AppTheme.creamMuted),
            ),
            textCapitalization: TextCapitalization.words,
            autofocus: true,
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _descController,
            style: AppTheme.bodySans.copyWith(color: AppTheme.cream),
            decoration: InputDecoration(
              hintText: 'Description (optional)',
              hintStyle: AppTheme.bodySans.copyWith(color: AppTheme.creamMuted),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _isLoading ? null : _createMap,
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.burntOrange,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.cream,
                      ),
                    )
                  : const Text('Create Map'),
            ),
          ),
        ],
      ),
    );
  }
}
