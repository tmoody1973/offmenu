import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_butler_client/food_butler_client.dart';
import 'package:go_router/go_router.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../main.dart';
import '../theme/app_theme.dart';
import '../widgets/city_search.dart';

/// Profile settings screen with multi-city support.
class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  CityResult? _homeCity;
  List<CityResult> _additionalCities = [];
  bool _isLoading = true;
  bool _isSaving = false;

  // Food preferences for display
  FoodPhilosophy? _foodPhilosophy;
  AdventureLevel? _adventureLevel;
  List<String> _familiarCuisines = [];
  List<String> _wantToTryCuisines = [];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await client.userProfile.getProfile();
      if (mounted && profile != null) {
        setState(() {
          // Load home city
          if (profile.homeCity != null) {
            _homeCity = CityResult(
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
            );
          }

          // Load additional cities from JSON
          if (profile.additionalCities != null &&
              profile.additionalCities!.isNotEmpty) {
            try {
              final List<dynamic> citiesJson =
                  jsonDecode(profile.additionalCities!);
              _additionalCities = citiesJson
                  .map((c) => CityResult.fromJson(c as Map<String, dynamic>))
                  .toList();
            } catch (e) {
              debugPrint('Error parsing additional cities: $e');
            }
          }

          // Load food preferences
          _foodPhilosophy = profile.foodPhilosophy;
          _adventureLevel = profile.adventureLevel;
          if (profile.familiarCuisines != null &&
              profile.familiarCuisines!.isNotEmpty) {
            _familiarCuisines = profile.familiarCuisines!.split(',');
          }
          if (profile.wantToTryCuisines != null &&
              profile.wantToTryCuisines!.isNotEmpty) {
            _wantToTryCuisines = profile.wantToTryCuisines!.split(',');
          }

          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _buildDisplayName(String city, String? state, String? country) {
    final parts = <String>[city];
    if (state != null) parts.add(state);
    if (country != null && country != 'USA' && country != 'United States') {
      parts.add(country);
    }
    return parts.join(', ');
  }

  String get _locationDisplay {
    if (_homeCity != null) {
      return _homeCity.toString();
    }
    return 'Location not set';
  }

  String get _foodPreferencesDisplay {
    final parts = <String>[];

    // Add cuisines count
    final totalCuisines = _familiarCuisines.length + _wantToTryCuisines.length;
    if (totalCuisines > 0) {
      parts.add('$totalCuisines cuisines');
    }

    // Add philosophy if set
    if (_foodPhilosophy != null) {
      switch (_foodPhilosophy!) {
        case FoodPhilosophy.storyFirst:
          parts.add('Story lover');
          break;
        case FoodPhilosophy.dishFirst:
          parts.add('Dish focused');
          break;
        case FoodPhilosophy.balanced:
          parts.add('Balanced');
          break;
      }
    }

    if (parts.isEmpty) {
      return 'Not set yet';
    }
    return parts.join(' \u2022 ');
  }

  Future<void> _saveAdditionalCities() async {
    setState(() => _isSaving = true);
    try {
      final citiesJson =
          jsonEncode(_additionalCities.map((c) => c.toJson()).toList());
      await client.userProfile.updateAdditionalCities(citiesJson);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cities saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving cities: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _onHomeCityChanged(CityResult city) async {
    setState(() => _homeCity = city);
    try {
      await client.userProfile.updateLocation(
        city: city.city,
        state: city.state,
        country: city.country,
        latitude: city.latitude,
        longitude: city.longitude,
      );
    } catch (e) {
      debugPrint('Error updating home city: $e');
    }
  }

  void _onAdditionalCitiesChanged(List<CityResult> cities) {
    setState(() => _additionalCities = cities);
    // Auto-save when cities change
    _saveAdditionalCities();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await client.auth.signOutDevice();
              if (mounted) {
                context.go('/sign-in');
              }
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppTheme.charcoal,
      appBar: AppBar(
        title: const Text('Profile Settings'),
        backgroundColor: AppTheme.charcoal,
        foregroundColor: AppTheme.cream,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Profile header
                Card(
                  color: AppTheme.charcoalLight,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: AppTheme.burntOrange.withAlpha(50),
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: AppTheme.burntOrange,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Food Explorer',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.cream,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: AppTheme.creamMuted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _locationDisplay,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.creamMuted,
                              ),
                            ),
                          ],
                        ),
                        if (_additionalCities.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            '+${_additionalCities.length} more ${_additionalCities.length == 1 ? 'city' : 'cities'}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppTheme.burntOrange,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // My Cities Section
                Text(
                  'My Cities',
                  style: AppTheme.headlineSerif.copyWith(
                    fontSize: 20,
                    color: AppTheme.cream,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add cities to get personalized restaurant recommendations, local favorites, and curated food content.',
                  style: AppTheme.bodySans.copyWith(
                    color: AppTheme.creamMuted,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),

                Card(
                  color: AppTheme.charcoalLight,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: MultiCitySelector(
                      homeCity: _homeCity,
                      additionalCities: _additionalCities,
                      onHomeCityChanged: _onHomeCityChanged,
                      onAdditionalCitiesChanged: _onAdditionalCitiesChanged,
                      maxCities: 10,
                    ),
                  ),
                ),

                if (_isSaving)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                // Settings options
                Card(
                  color: AppTheme.charcoalLight,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.favorite,
                          color: AppTheme.burntOrange,
                        ),
                        title: const Text(
                          'Saved Restaurants',
                          style: TextStyle(color: AppTheme.cream),
                        ),
                        subtitle: Text(
                          'Your favorite spots',
                          style: TextStyle(color: AppTheme.creamMuted.withAlpha(150)),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: AppTheme.creamMuted,
                        ),
                        onTap: () => context.push('/saved'),
                      ),
                      Divider(height: 1, color: AppTheme.cream.withAlpha(20)),
                      ListTile(
                        leading: const Icon(
                          Icons.restaurant_menu,
                          color: AppTheme.cream,
                        ),
                        title: const Text(
                          'Food Preferences',
                          style: TextStyle(color: AppTheme.cream),
                        ),
                        subtitle: Text(
                          _foodPreferencesDisplay,
                          style: TextStyle(color: AppTheme.creamMuted.withAlpha(150)),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: AppTheme.creamMuted,
                        ),
                        onTap: () async {
                          await context.push('/onboarding');
                          // Reload profile after returning from preferences
                          if (mounted) {
                            _loadProfile();
                          }
                        },
                      ),
                      Divider(height: 1, color: AppTheme.cream.withAlpha(20)),
                      ListTile(
                        leading: const Icon(
                          Icons.notifications_outlined,
                          color: AppTheme.cream,
                        ),
                        title: const Text(
                          'Notifications',
                          style: TextStyle(color: AppTheme.cream),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: AppTheme.creamMuted,
                        ),
                        onTap: () {
                          // TODO: Navigate to notifications settings
                        },
                      ),
                      Divider(height: 1, color: AppTheme.cream.withAlpha(20)),
                      ListTile(
                        leading: const Icon(
                          Icons.privacy_tip_outlined,
                          color: AppTheme.cream,
                        ),
                        title: const Text(
                          'Privacy',
                          style: TextStyle(color: AppTheme.cream),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: AppTheme.creamMuted,
                        ),
                        onTap: () {
                          // TODO: Navigate to privacy settings
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Logout button
                Card(
                  color: AppTheme.charcoalLight,
                  child: ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: _showLogoutDialog,
                  ),
                ),
                const SizedBox(height: 32),

                // App version
                Center(
                  child: Text(
                    'Off Menu v1.0.0',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.creamMuted,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
    );
  }
}
