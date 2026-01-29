import 'package:flutter/material.dart';
import 'package:food_butler_client/food_butler_client.dart';

import '../main.dart';
import '../theme/app_theme.dart';

/// Weather app-style city picker.
/// Users can have their home city + up to 10 favorite cities.
class CityPicker extends StatefulWidget {
  final FavoriteCity? selectedCity;
  final ValueChanged<FavoriteCity> onCitySelected;
  final VoidCallback? onAddCity;

  const CityPicker({
    super.key,
    this.selectedCity,
    required this.onCitySelected,
    this.onAddCity,
  });

  @override
  State<CityPicker> createState() => _CityPickerState();
}

class _CityPickerState extends State<CityPicker> {
  List<FavoriteCity> _cities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  Future<void> _loadCities() async {
    try {
      final cities = await client.curatedMaps.getFavoriteCities();
      setState(() {
        _cities = cities;
        _isLoading = false;
      });

      // Auto-select first city if none selected
      if (widget.selectedCity == null && cities.isNotEmpty) {
        widget.onCitySelected(cities.first);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 60,
        child: Center(
          child: CircularProgressIndicator(color: AppTheme.burntOrange),
        ),
      );
    }

    if (_cities.isEmpty) {
      return _EmptyCityState(onAddCity: widget.onAddCity);
    }

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _cities.length + 1, // +1 for add button
        itemBuilder: (context, index) {
          if (index == _cities.length) {
            // Add city button
            return _AddCityButton(onTap: widget.onAddCity);
          }

          final city = _cities[index];
          final isSelected = widget.selectedCity?.id == city.id;

          return _CityChip(
            city: city,
            isSelected: isSelected,
            onTap: () => widget.onCitySelected(city),
          );
        },
      ),
    );
  }
}

/// Individual city chip in the picker.
class _CityChip extends StatelessWidget {
  final FavoriteCity city;
  final bool isSelected;
  final VoidCallback onTap;

  const _CityChip({
    required this.city,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.burntOrange
                : AppTheme.charcoalLight,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: isSelected
                  ? AppTheme.burntOrange
                  : AppTheme.cream.withAlpha(20),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (city.isHomeCity) ...[
                Icon(
                  Icons.home,
                  size: 16,
                  color: isSelected ? AppTheme.cream : AppTheme.creamMuted,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                city.stateOrRegion != null
                    ? '${city.cityName}, ${city.stateOrRegion}'
                    : city.cityName,
                style: AppTheme.labelSans.copyWith(
                  fontSize: 14,
                  color: isSelected ? AppTheme.cream : AppTheme.creamMuted,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Add city button.
class _AddCityButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _AddCityButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.charcoalLight,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: AppTheme.burntOrange.withAlpha(50),
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.add,
              size: 16,
              color: AppTheme.burntOrange,
            ),
            const SizedBox(width: 6),
            Text(
              'Add City',
              style: AppTheme.labelSans.copyWith(
                fontSize: 14,
                color: AppTheme.burntOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty state when no cities are added.
class _EmptyCityState extends StatelessWidget {
  final VoidCallback? onAddCity;

  const _EmptyCityState({this.onAddCity});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.charcoalLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.cream.withAlpha(10)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.location_city,
            size: 32,
            color: AppTheme.creamMuted,
          ),
          const SizedBox(height: 12),
          Text(
            'Add your favorite cities',
            style: AppTheme.bodySans.copyWith(
              fontSize: 16,
              color: AppTheme.cream,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Like a weather app, but for food',
            style: AppTheme.bodySans.copyWith(
              fontSize: 13,
              color: AppTheme.creamMuted,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onAddCity,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Your First City'),
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.burntOrange,
              foregroundColor: AppTheme.cream,
            ),
          ),
        ],
      ),
    );
  }
}
