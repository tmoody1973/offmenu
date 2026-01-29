import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_butler_client/food_butler_client.dart';

import '../main.dart';
import '../theme/app_theme.dart';

/// City data model for search results.
class CityResult {
  final String city;
  final String? state;
  final String? country;
  final double? latitude;
  final double? longitude;
  final String placeId;
  final String displayName;

  CityResult({
    required this.city,
    this.state,
    this.country,
    this.latitude,
    this.longitude,
    required this.placeId,
    required this.displayName,
  });

  Map<String, dynamic> toJson() => {
        'city': city,
        'state': state,
        'country': country,
        'lat': latitude,
        'lng': longitude,
      };

  factory CityResult.fromJson(Map<String, dynamic> json) => CityResult(
        city: json['city'] ?? '',
        state: json['state'],
        country: json['country'],
        latitude: json['lat']?.toDouble(),
        longitude: json['lng']?.toDouble(),
        placeId: json['placeId'] ?? '',
        displayName: json['displayName'] ?? json['city'] ?? '',
      );

  /// Create from server CityPrediction.
  factory CityResult.fromPrediction(CityPrediction prediction) => CityResult(
        city: prediction.city,
        state: prediction.state,
        country: prediction.country,
        placeId: prediction.placeId,
        displayName: prediction.displayName,
      );

  @override
  String toString() {
    final parts = <String>[city];
    if (state != null) parts.add(state!);
    if (country != null && country != 'USA' && country != 'United States') {
      parts.add(country!);
    }
    return parts.join(', ');
  }
}

/// City search widget with Google Places Autocomplete via server proxy.
class CitySearchField extends StatefulWidget {
  final String? initialValue;
  final void Function(CityResult city) onCitySelected;
  final String hintText;
  final bool autofocus;

  const CitySearchField({
    super.key,
    this.initialValue,
    required this.onCitySelected,
    this.hintText = 'Search for a city...',
    this.autofocus = false,
  });

  @override
  State<CitySearchField> createState() => _CitySearchFieldState();
}

class _CitySearchFieldState extends State<CitySearchField> {
  final _controller = TextEditingController();
  Timer? _debounce;
  List<CityResult> _suggestions = [];
  bool _isLoading = false;
  bool _showDropdown = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _searchCities(String query) async {
    if (query.length < 2) {
      setState(() {
        _suggestions = [];
        _showDropdown = false;
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      final results = await client.places.searchCities(query);
      final cities = results.map((p) => CityResult.fromPrediction(p)).toList();

      if (mounted) {
        setState(() {
          _suggestions = cities;
          _showDropdown = cities.isNotEmpty;
        });
      }
    } catch (e) {
      debugPrint('City search error: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _selectCity(CityResult city) async {
    _controller.text = city.toString();
    setState(() {
      _showDropdown = false;
      _suggestions = [];
    });

    // Get place details for coordinates
    try {
      if (city.placeId.isNotEmpty) {
        final details = await client.places.getPlaceDetails(city.placeId);
        if (details != null) {
          final updatedCity = CityResult(
            city: city.city,
            state: city.state,
            country: city.country,
            latitude: details.latitude,
            longitude: details.longitude,
            placeId: city.placeId,
            displayName: city.displayName,
          );
          widget.onCitySelected(updatedCity);
          return;
        }
      }
    } catch (e) {
      debugPrint('Place details error: $e');
    }

    widget.onCitySelected(city);
  }

  void _onTextChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _searchCities(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search field
        TextField(
          controller: _controller,
          autofocus: widget.autofocus,
          style: AppTheme.bodySans.copyWith(color: AppTheme.cream),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTheme.bodySans.copyWith(color: AppTheme.creamMuted),
            prefixIcon: const Icon(Icons.search, color: AppTheme.creamMuted),
            suffixIcon: _isLoading
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.burntOrange,
                      ),
                    ),
                  )
                : _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppTheme.creamMuted),
                        onPressed: () {
                          _controller.clear();
                          setState(() {
                            _suggestions = [];
                            _showDropdown = false;
                          });
                        },
                      )
                    : null,
            filled: true,
            fillColor: AppTheme.charcoalLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.burntOrange, width: 2),
            ),
          ),
          onChanged: _onTextChanged,
          onTap: () {
            if (_suggestions.isNotEmpty) {
              setState(() => _showDropdown = true);
            }
          },
        ),

        // Dropdown suggestions (inline, not overlay)
        if (_showDropdown && _suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: AppTheme.charcoalLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.cream.withAlpha(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(50),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                final city = _suggestions[index];
                return InkWell(
                  onTap: () => _selectCity(city),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: index < _suggestions.length - 1
                          ? Border(
                              bottom: BorderSide(
                                color: AppTheme.cream.withAlpha(10),
                              ),
                            )
                          : null,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_city,
                          color: AppTheme.creamMuted,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            city.displayName,
                            style: AppTheme.bodySans.copyWith(
                              color: AppTheme.cream,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

/// Multi-city selector widget.
/// Allows selecting up to maxCities cities.
class MultiCitySelector extends StatefulWidget {
  final CityResult? homeCity;
  final List<CityResult> additionalCities;
  final void Function(CityResult) onHomeCityChanged;
  final void Function(List<CityResult>) onAdditionalCitiesChanged;
  final int maxCities;

  const MultiCitySelector({
    super.key,
    this.homeCity,
    required this.additionalCities,
    required this.onHomeCityChanged,
    required this.onAdditionalCitiesChanged,
    this.maxCities = 10,
  });

  @override
  State<MultiCitySelector> createState() => _MultiCitySelectorState();
}

class _MultiCitySelectorState extends State<MultiCitySelector> {
  bool _isAddingCity = false;

  void _addCity(CityResult city) {
    if (widget.additionalCities.length < widget.maxCities) {
      final updated = [...widget.additionalCities, city];
      widget.onAdditionalCitiesChanged(updated);
    }
    setState(() => _isAddingCity = false);
  }

  void _removeCity(int index) {
    final updated = [...widget.additionalCities];
    updated.removeAt(index);
    widget.onAdditionalCitiesChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Home city
        Text(
          'Home City',
          style: AppTheme.labelSans.copyWith(
            color: AppTheme.creamMuted,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        CitySearchField(
          initialValue: widget.homeCity?.toString(),
          hintText: 'Search for your home city...',
          onCitySelected: widget.onHomeCityChanged,
        ),

        const SizedBox(height: 24),

        // Additional cities
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Additional Cities',
              style: AppTheme.labelSans.copyWith(
                color: AppTheme.creamMuted,
                fontSize: 12,
              ),
            ),
            Text(
              '${widget.additionalCities.length}/${widget.maxCities}',
              style: AppTheme.labelSans.copyWith(
                color: AppTheme.creamMuted,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Add cities you frequently visit or want to explore for personalized recommendations.',
          style: AppTheme.bodySans.copyWith(
            color: AppTheme.creamMuted,
            fontSize: 14,
          ),
        ),

        const SizedBox(height: 16),

        // City chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...widget.additionalCities.asMap().entries.map((entry) {
              return Chip(
                label: Text(
                  entry.value.toString(),
                  style: const TextStyle(color: AppTheme.cream),
                ),
                backgroundColor: AppTheme.charcoalLight,
                deleteIcon: const Icon(Icons.close, size: 18),
                deleteIconColor: AppTheme.creamMuted,
                onDeleted: () => _removeCity(entry.key),
                side: const BorderSide(color: AppTheme.creamMuted, width: 0.5),
              );
            }),
            // Add button
            if (widget.additionalCities.length < widget.maxCities && !_isAddingCity)
              ActionChip(
                label: const Text('+ Add City'),
                backgroundColor: AppTheme.burntOrange.withAlpha(30),
                labelStyle: const TextStyle(color: AppTheme.burntOrange),
                side: const BorderSide(color: AppTheme.burntOrange, width: 0.5),
                onPressed: () => setState(() => _isAddingCity = true),
              ),
          ],
        ),

        // Search field for adding new city
        if (_isAddingCity) ...[
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CitySearchField(
                  autofocus: true,
                  hintText: 'Search city to add...',
                  onCitySelected: _addCity,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.close, color: AppTheme.creamMuted),
                onPressed: () => setState(() => _isAddingCity = false),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
