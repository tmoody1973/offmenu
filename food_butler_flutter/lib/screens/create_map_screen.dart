import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';
import '../theme/app_theme.dart';
import '../widgets/city_search.dart';

/// Create a Culinary Map - Eater-style curated restaurant maps.
class CreateMapScreen extends StatefulWidget {
  const CreateMapScreen({super.key});

  @override
  State<CreateMapScreen> createState() => _CreateMapScreenState();
}

class _CreateMapScreenState extends State<CreateMapScreen> {
  CityResult? _selectedCity;
  List<CityResult> _userCities = [];
  String? _selectedTheme;
  String _customPrompt = '';
  final _customPromptController = TextEditingController();
  bool _isLoading = true;
  bool _isGenerating = false;
  String _generatingStatus = '';

  static const _mapThemes = [
    {
      'id': 'best_tacos',
      'title': 'Best Tacos',
      'icon': '🌮',
      'description': 'The taco spots locals swear by',
    },
    {
      'id': 'date_night',
      'title': 'Date Night',
      'icon': '💕',
      'description': 'Romantic spots that impress',
    },
    {
      'id': 'hidden_gems',
      'title': 'Hidden Gems',
      'icon': '💎',
      'description': 'Off-radar restaurants worth finding',
    },
    {
      'id': 'late_night',
      'title': 'Late Night Eats',
      'icon': '🌙',
      'description': 'Where to go after midnight',
    },
    {
      'id': 'brunch',
      'title': 'Brunch Spots',
      'icon': '🥞',
      'description': 'Weekend brunch destinations',
    },
    {
      'id': 'budget_eats',
      'title': 'Budget Eats',
      'icon': '💰',
      'description': 'Great food under \$15',
    },
    {
      'id': 'award_winners',
      'title': 'Award Winners',
      'icon': '🏆',
      'description': 'James Beard & Michelin picks',
    },
    {
      'id': 'food_crawl',
      'title': 'Food Crawl',
      'icon': '🚶',
      'description': 'A walkable tasting tour',
    },
    {
      'id': 'custom',
      'title': 'Custom',
      'icon': '✨',
      'description': 'Create your own theme',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUserCities();
  }

  @override
  void dispose() {
    _customPromptController.dispose();
    super.dispose();
  }

  Future<void> _loadUserCities() async {
    try {
      final profile = await client.userProfile.getProfile();
      if (mounted && profile != null) {
        final cities = <CityResult>[];

        // Add home city
        if (profile.homeCity != null) {
          cities.add(CityResult(
            city: profile.homeCity!,
            state: profile.homeState,
            country: profile.homeCountry,
            latitude: profile.homeLatitude,
            longitude: profile.homeLongitude,
            placeId: '',
            displayName: _buildDisplayName(
              profile.homeCity!,
              profile.homeState,
              profile.homeCountry,
            ),
          ));
        }

        // Add additional cities
        if (profile.additionalCities != null &&
            profile.additionalCities!.isNotEmpty) {
          try {
            final List<dynamic> citiesJson =
                jsonDecode(profile.additionalCities!);
            cities.addAll(citiesJson
                .map((c) => CityResult.fromJson(c as Map<String, dynamic>)));
          } catch (e) {
            debugPrint('Error parsing additional cities: $e');
          }
        }

        setState(() {
          _userCities = cities;
          if (cities.isNotEmpty) {
            _selectedCity = cities.first;
          }
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  String _buildDisplayName(String city, String? state, String? country) {
    final parts = <String>[city];
    if (state != null) parts.add(state);
    return parts.join(', ');
  }

  bool get _canCreate {
    if (_selectedCity == null || _selectedTheme == null) return false;
    if (_selectedTheme == 'custom' && _customPrompt.trim().isEmpty) return false;
    return true;
  }

  Future<void> _createMap() async {
    if (!_canCreate || _isGenerating) return;

    setState(() {
      _isGenerating = true;
      _generatingStatus = 'Finding the best spots...';
    });

    try {
      // Call the server to generate the map
      final generatedMap = await client.curatedMaps.generateMap(
        cityName: _selectedCity!.city,
        stateOrRegion: _selectedCity!.state,
        country: _selectedCity!.country ?? 'USA',
        mapType: _selectedTheme!,
        customPrompt: _selectedTheme == 'custom' ? _customPrompt.trim() : null,
        maxRestaurants: 10,
      );

      if (!mounted) return;

      setState(() {
        _generatingStatus = 'Map created!';
      });

      // Navigate to the generated map
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        context.go('/maps/${generatedMap.slug}');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isGenerating = false;
        _generatingStatus = '';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to generate map: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show generating overlay
    if (_isGenerating) {
      return Scaffold(
        backgroundColor: AppTheme.charcoal,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated icon
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(seconds: 2),
                builder: (context, value, child) {
                  return Transform.rotate(
                    angle: value * 2 * 3.14159,
                    child: child,
                  );
                },
                onEnd: () {
                  // Restart animation
                  if (mounted && _isGenerating) {
                    setState(() {});
                  }
                },
                child: const Icon(
                  Icons.auto_awesome,
                  size: 64,
                  color: AppTheme.burntOrange,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Creating Your Map',
                style: AppTheme.headlineSerif.copyWith(
                  fontSize: 24,
                  color: AppTheme.cream,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _generatingStatus,
                style: AppTheme.bodySans.copyWith(
                  fontSize: 16,
                  color: AppTheme.creamMuted,
                ),
              ),
              const SizedBox(height: 32),
              const SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  backgroundColor: AppTheme.charcoalLight,
                  color: AppTheme.burntOrange,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Finding restaurants, writing stories,\nand gathering photos...',
                textAlign: TextAlign.center,
                style: AppTheme.bodySans.copyWith(
                  fontSize: 14,
                  color: AppTheme.creamMuted,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.charcoal,
      appBar: AppBar(
        backgroundColor: AppTheme.charcoal,
        foregroundColor: AppTheme.cream,
        title: Text(
          'Create a Map',
          style: AppTheme.headlineSerif.copyWith(
            fontSize: 20,
            color: AppTheme.cream,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    'Curate Your Food Map',
                    style: AppTheme.headlineSerif.copyWith(
                      fontSize: 28,
                      color: AppTheme.cream,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'AI-powered restaurant guides like Eater, personalized for you.',
                    style: AppTheme.bodySans.copyWith(
                      fontSize: 16,
                      color: AppTheme.creamMuted,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // City Selector
                  Text(
                    'SELECT A CITY',
                    style: AppTheme.labelSans.copyWith(
                      fontSize: 12,
                      color: AppTheme.creamMuted,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (_userCities.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.charcoalLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.cream.withAlpha(20)),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.location_off,
                              color: AppTheme.creamMuted, size: 32),
                          const SizedBox(height: 8),
                          Text(
                            'No cities saved yet',
                            style: AppTheme.bodySans.copyWith(
                              color: AppTheme.creamMuted,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () => context.go('/profile'),
                            child: const Text('Add cities in Profile'),
                          ),
                        ],
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _userCities.map((city) {
                        final isSelected = _selectedCity == city;
                        return ChoiceChip(
                          label: Text(city.toString()),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() => _selectedCity = city);
                          },
                          selectedColor: AppTheme.burntOrange,
                          backgroundColor: AppTheme.charcoalLight,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? AppTheme.cream
                                : AppTheme.creamMuted,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? AppTheme.burntOrange
                                : AppTheme.cream.withAlpha(30),
                          ),
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 32),

                  // Theme Selector
                  Text(
                    'CHOOSE A THEME',
                    style: AppTheme.labelSans.copyWith(
                      fontSize: 12,
                      color: AppTheme.creamMuted,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.4,
                    ),
                    itemCount: _mapThemes.length,
                    itemBuilder: (context, index) {
                      final theme = _mapThemes[index];
                      final isSelected = _selectedTheme == theme['id'];
                      return _ThemeCard(
                        icon: theme['icon'] as String,
                        title: theme['title'] as String,
                        description: theme['description'] as String,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() => _selectedTheme = theme['id'] as String);
                        },
                      );
                    },
                  ),

                  // Custom prompt input (shown when custom theme selected)
                  if (_selectedTheme == 'custom') ...[
                    const SizedBox(height: 24),
                    Text(
                      'DESCRIBE YOUR MAP',
                      style: AppTheme.labelSans.copyWith(
                        fontSize: 12,
                        color: AppTheme.creamMuted,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _customPromptController,
                      maxLines: 3,
                      style: AppTheme.bodySans.copyWith(color: AppTheme.cream),
                      decoration: InputDecoration(
                        hintText: 'e.g., "Best pizza spots with outdoor seating" or "Authentic Asian restaurants under \$20"',
                        hintStyle: AppTheme.bodySans.copyWith(
                          color: AppTheme.creamMuted,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: AppTheme.charcoalLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppTheme.burntOrange,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() => _customPrompt = value);
                      },
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Create Button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _canCreate ? _createMap : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.burntOrange,
                        foregroundColor: AppTheme.cream,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: AppTheme.charcoalLight,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.auto_awesome, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Generate My Map',
                            style: AppTheme.labelSans.copyWith(
                              fontSize: 16,
                              color: AppTheme.cream,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Helper text
                  Center(
                    child: Text(
                      'AI will curate 8-12 restaurants with stories',
                      style: AppTheme.bodySans.copyWith(
                        fontSize: 13,
                        color: AppTheme.creamMuted,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}

/// Theme selection card.
class _ThemeCard extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.burntOrange.withAlpha(30)
              : AppTheme.charcoalLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.burntOrange
                : AppTheme.cream.withAlpha(20),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTheme.bodySans.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppTheme.burntOrange : AppTheme.cream,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              description,
              style: AppTheme.bodySans.copyWith(
                fontSize: 11,
                color: AppTheme.creamMuted,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
