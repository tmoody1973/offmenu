import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_butler_client/food_butler_client.dart';

import '../services/geocoding_service.dart';
import '../services/geolocation_service.dart';

/// Callback for when an address is selected.
typedef OnAddressSelectedCallback = void Function(AddressResult address);

/// A text input with autocomplete dropdown for address search.
///
/// Uses server-side geocoding proxy to avoid CORS issues on web.
class AddressSearchInput extends StatefulWidget {
  /// Callback when an address is selected.
  final OnAddressSelectedCallback? onAddressSelect;

  /// Placeholder text for the input.
  final String placeholder;

  /// Initial value for the input.
  final String? initialValue;

  /// The geocoding service to use.
  final ServerpodGeocodingService geocodingService;

  /// The geolocation service for "use my location" feature.
  final GeolocationService? geolocationService;

  const AddressSearchInput({
    super.key,
    this.onAddressSelect,
    this.placeholder = 'Enter starting address...',
    this.initialValue,
    required this.geocodingService,
    this.geolocationService,
  });

  @override
  State<AddressSearchInput> createState() => _AddressSearchInputState();
}

class _AddressSearchInputState extends State<AddressSearchInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();

  List<PlacePrediction> _predictions = [];
  bool _isLoading = false;
  bool _isUsingCurrentLocation = false;
  bool _showDropdown = false;
  Timer? _debounceTimer;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      // Delay hiding to allow tap on dropdown items
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted && !_focusNode.hasFocus) {
          _hideDropdown();
        }
      });
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();

    if (query.length < 2) {
      setState(() {
        _predictions = [];
        _isLoading = false;
      });
      _hideDropdown();
      return;
    }

    setState(() => _isLoading = true);

    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      if (!mounted) return;

      try {
        final predictions = await widget.geocodingService.searchPlaces(query);
        if (mounted) {
          setState(() {
            _predictions = predictions;
            _isLoading = false;
          });
          if (predictions.isNotEmpty) {
            _showDropdownOverlay();
          } else {
            _hideDropdown();
          }
        }
      } catch (e) {
        debugPrint('Search error: $e');
        if (mounted) {
          setState(() {
            _predictions = [];
            _isLoading = false;
          });
          _hideDropdown();
        }
      }
    });
  }

  void _showDropdownOverlay() {
    _removeOverlay();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: _getTextFieldWidth(),
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 56),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 250),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: _predictions.length,
                itemBuilder: (context, index) {
                  final prediction = _predictions[index];
                  return ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text(
                      prediction.mainText ?? prediction.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: prediction.secondaryText != null
                        ? Text(
                            prediction.secondaryText!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          )
                        : null,
                    onTap: () => _onPredictionSelected(prediction),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _showDropdown = true);
  }

  double _getTextFieldWidth() {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    return renderBox?.size.width ?? 300;
  }

  void _hideDropdown() {
    _removeOverlay();
    setState(() => _showDropdown = false);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Future<void> _onPredictionSelected(PlacePrediction prediction) async {
    _hideDropdown();
    _controller.text = prediction.mainText ?? prediction.description;

    // Get full details with coordinates
    setState(() => _isLoading = true);

    try {
      final details =
          await widget.geocodingService.getPlaceDetails(prediction.placeId);
      if (details != null && mounted) {
        widget.onAddressSelect?.call(details);
      }
    } catch (e) {
      debugPrint('Error getting place details: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _useCurrentLocation() async {
    if (widget.geolocationService == null) return;

    setState(() {
      _isUsingCurrentLocation = true;
      _isLoading = true;
    });

    try {
      final location = await widget.geolocationService!.requestLocation();
      if (location != null && mounted) {
        _controller.text = 'Current Location';
        final address = AddressResult(
          id: 'current_location',
          displayText: 'Current Location',
          formattedAddress: 'Your current location',
          latitude: location.latitude,
          longitude: location.longitude,
        );
        widget.onAddressSelect?.call(address);
      }
    } catch (e) {
      debugPrint('Error getting current location: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isUsingCurrentLocation = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Search field with overlay link
        CompositedTransformTarget(
          link: _layerLink,
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: widget.placeholder,
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _controller.clear();
                            _hideDropdown();
                            setState(() => _predictions = []);
                          },
                        )
                      : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),

        // Use my location button
        if (widget.geolocationService != null) ...[
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _isLoading ? null : _useCurrentLocation,
            icon: _isUsingCurrentLocation
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.my_location_rounded, size: 18),
            label: const Text('Use my current location'),
          ),
        ],
      ],
    );
  }
}

/// A list of address suggestions (kept for backwards compatibility).
class AddressSuggestionList extends StatelessWidget {
  final List<AddressResult> suggestions;
  final bool isLoading;
  final void Function(AddressResult)? onSuggestionTap;

  const AddressSuggestionList({
    super.key,
    required this.suggestions,
    this.isLoading = false,
    this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && suggestions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (suggestions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No results found', style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      itemCount: suggestions.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          leading: const Icon(Icons.location_on_outlined),
          title: Text(
            suggestion.displayText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: suggestion.city != null
              ? Text(
                  '${suggestion.city}, ${suggestion.state ?? suggestion.country}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                )
              : null,
          onTap: () => onSuggestionTap?.call(suggestion),
        );
      },
    );
  }
}
