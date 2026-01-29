import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/city_search.dart';

/// Location step - collects user's home city with Google Places autocomplete.
class LocationStep extends StatefulWidget {
  final String? initialCity;
  final void Function(
    String city,
    String? state,
    String? country,
    double? latitude,
    double? longitude,
  ) onLocationSelected;
  final VoidCallback onContinue;

  const LocationStep({
    super.key,
    this.initialCity,
    required this.onLocationSelected,
    required this.onContinue,
  });

  @override
  State<LocationStep> createState() => _LocationStepState();
}

class _LocationStepState extends State<LocationStep> {
  bool _isDetecting = false;
  String? _error;
  CityResult? _selectedCity;

  @override
  void initState() {
    super.initState();
    if (widget.initialCity != null) {
      _selectedCity = CityResult(
        city: widget.initialCity!,
        placeId: '',
        displayName: widget.initialCity!,
      );
    }
  }

  Future<void> _detectLocation() async {
    setState(() {
      _isDetecting = true;
      _error = null;
    });

    try {
      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _error = 'Location permission denied';
            _isDetecting = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _error = 'Location permission permanently denied. Please enable in settings.';
          _isDetecting = false;
        });
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      // Reverse geocode to get city name
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final city = place.locality ?? place.subAdministrativeArea ?? 'Unknown';
        final state = place.administrativeArea;
        final country = place.country;

        final result = CityResult(
          city: city,
          state: state,
          country: country,
          latitude: position.latitude,
          longitude: position.longitude,
          placeId: '',
          displayName: state != null ? '$city, $state' : city,
        );

        setState(() => _selectedCity = result);

        widget.onLocationSelected(
          city,
          state,
          country,
          position.latitude,
          position.longitude,
        );
      }
    } catch (e) {
      setState(() {
        _error = 'Could not detect location. Please search for your city.';
      });
    } finally {
      setState(() => _isDetecting = false);
    }
  }

  void _onCitySelected(CityResult city) {
    setState(() {
      _selectedCity = city;
      _error = null;
    });
    widget.onLocationSelected(
      city.city,
      city.state,
      city.country,
      city.latitude,
      city.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    final canContinue = _selectedCity != null;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(flex: 1),

          // Header
          Text(
            'Where are you based?',
            style: AppTheme.headlineSerif.copyWith(
              fontSize: 32,
              color: AppTheme.cream,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'We\'ll show you local favorites and hidden gems nearby.',
            style: AppTheme.bodySans.copyWith(
              fontSize: 16,
              color: AppTheme.creamMuted,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 40),

          // Auto-detect button
          OutlinedButton.icon(
            onPressed: _isDetecting ? null : _detectLocation,
            icon: _isDetecting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.cream,
                    ),
                  )
                : const Icon(Icons.my_location),
            label: Text(_isDetecting ? 'Detecting...' : 'Use my current location'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.cream,
              side: const BorderSide(color: AppTheme.creamMuted),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Divider with "or"
          Row(
            children: [
              const Expanded(child: Divider(color: AppTheme.creamMuted)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'or search',
                  style: AppTheme.labelSans.copyWith(color: AppTheme.creamMuted),
                ),
              ),
              const Expanded(child: Divider(color: AppTheme.creamMuted)),
            ],
          ),

          const SizedBox(height: 24),

          // City search with autocomplete
          CitySearchField(
            initialValue: _selectedCity?.toString(),
            hintText: 'Search for your city...',
            onCitySelected: _onCitySelected,
          ),

          // Selected city confirmation
          if (_selectedCity != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.burntOrange.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.burntOrange.withAlpha(50)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppTheme.burntOrange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selected',
                          style: AppTheme.labelSans.copyWith(
                            color: AppTheme.burntOrange,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          _selectedCity!.toString(),
                          style: AppTheme.bodySans.copyWith(
                            color: AppTheme.cream,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Error message
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: AppTheme.bodySans.copyWith(
                color: AppTheme.errorColor,
                fontSize: 14,
              ),
            ),
          ],

          const Spacer(flex: 2),

          // Continue button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: canContinue ? widget.onContinue : null,
              style: FilledButton.styleFrom(
                backgroundColor: canContinue ? AppTheme.burntOrange : AppTheme.charcoalLight,
                foregroundColor: AppTheme.cream,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Continue',
                style: AppTheme.labelSans.copyWith(
                  fontSize: 16,
                  color: AppTheme.cream,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
