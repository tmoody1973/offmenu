import 'package:flutter/material.dart';
import 'package:food_butler_client/food_butler_client.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';
import '../map/services/geocoding_service.dart';
import '../map/services/geolocation_service.dart';
import '../map/widgets/address_search_input.dart';
import '../theme/app_theme.dart';

/// Tour form screen for configuring a new food tour.
///
/// Features:
/// - Location input with address search
/// - Cuisine multi-select
/// - Dietary restrictions checkboxes
/// - Budget tier selector
/// - Number of stops slider
/// - Transport mode toggle
/// - Award-only filter checkbox
/// - Generate Tour button
class TourFormScreen extends StatefulWidget {
  const TourFormScreen({super.key});

  @override
  State<TourFormScreen> createState() => _TourFormScreenState();
}

class _TourFormScreenState extends State<TourFormScreen> {
  final _formKey = GlobalKey<FormState>();
  // Use server-side geocoding service to avoid CORS issues
  late final ServerpodGeocodingService _geocodingService;
  final _geolocationService = MockGeolocationService();

  // Mode: 'single' for single restaurant, 'tour' for multi-stop
  bool _isSingleMode = false;
  bool _didInitFromExtras = false;

  @override
  void initState() {
    super.initState();
    _geocodingService = ServerpodGeocodingService(
      clientProvider: () => client,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInitFromExtras) {
      _didInitFromExtras = true;
      final extra = GoRouterState.of(context).extra;
      if (extra is Map<String, dynamic>) {
        final mode = extra['mode'] as String?;
        final prefilledDish = extra['prefilledDish'] as String?;

        if (mode == 'single') {
          _isSingleMode = true;
          _numStops = 1;
        }

        if (prefilledDish != null) {
          _dishController.text = prefilledDish;
          _specificDish = prefilledDish;
        }
      }
    }
  }

  // Form state
  AddressResult? _selectedAddress;
  final Set<String> _selectedCuisines = {};
  BudgetTier _budgetTier = BudgetTier.moderate;
  int _numStops = 4;
  TransportMode _transportMode = TransportMode.walking;
  bool _awardOnly = false;
  bool _isLoading = false;
  String? _specificDish;
  final _dishController = TextEditingController();

  @override
  void dispose() {
    _dishController.dispose();
    super.dispose();
  }

  // Cuisine options
  static const List<String> _cuisineOptions = [
    'Italian',
    'Japanese',
    'Mexican',
    'French',
    'Chinese',
    'Thai',
    'Indian',
    'Mediterranean',
    'American',
    'Korean',
    'Vietnamese',
    'Spanish',
  ];

  // Example dish suggestions for quick selection
  static const List<String> _exampleDishes = [
    'tonkotsu ramen',
    'tacos al pastor',
    'Neapolitan pizza',
    'Nashville hot chicken',
    'pho',
    'birria',
  ];

  Future<void> _generateTour() async {
    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a starting location'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final request = TourRequest(
        startLatitude: _selectedAddress!.latitude,
        startLongitude: _selectedAddress!.longitude,
        startAddress: _selectedAddress!.formattedAddress,
        numStops: _numStops,
        transportMode: _transportMode,
        cuisinePreferences:
            _selectedCuisines.isNotEmpty ? _selectedCuisines.toList() : null,
        awardOnly: _awardOnly,
        startTime: DateTime.now(),
        budgetTier: _budgetTier,
        specificDish: _specificDish?.isNotEmpty == true ? _specificDish : null,
        createdAt: DateTime.now(),
      );

      final result = await client.tour.generate(request);

      if (mounted) {
        // Navigate to results with the tour data
        context.push('/tour/results', extra: {
          'tourResult': result,
          'transportMode': _transportMode,
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate tour: $e'),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final isTabletOrDesktop = size.width >= AppTheme.mobileBreakpoint;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isSingleMode ? 'Quick Find' : 'Plan Your Tour'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          // Add bottom padding for keyboard and safe area on notched devices
          padding: AppTheme.responsivePadding(context).copyWith(
            bottom: MediaQuery.of(context).viewInsets.bottom +
                MediaQuery.of(context).padding.bottom +
                24,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isTabletOrDesktop ? 600 : double.infinity,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Location section
                  _SectionHeader(
                    icon: Icons.location_on_outlined,
                    title: 'Starting Location',
                  ),
                  const SizedBox(height: 8),
                  AddressSearchInput(
                    geocodingService: _geocodingService,
                    geolocationService: _geolocationService,
                    placeholder: 'Enter starting address or use location',
                    onAddressSelect: (address) {
                      setState(() => _selectedAddress = address);
                    },
                  ),
                  const SizedBox(height: 28),

                  // HERO: Dish Search Section (elevated to top)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor.withAlpha(15),
                          AppTheme.primaryColor.withAlpha(5),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.primaryColor.withAlpha(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withAlpha(25),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.restaurant,
                                color: AppTheme.primaryColor,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'What are you craving?',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                  Text(
                                    _isSingleMode
                                        ? 'Find the ONE best spot for any dish'
                                        : 'Find the BEST version of any dish',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _dishController,
                          style: theme.textTheme.titleMedium,
                          decoration: InputDecoration(
                            hintText: 'Enter a dish...',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            prefixIcon: Icon(Icons.search, color: AppTheme.primaryColor),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
                            ),
                            suffixIcon: _dishController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _dishController.clear();
                                      setState(() => _specificDish = null);
                                    },
                                  )
                                : null,
                          ),
                          onChanged: (value) {
                            setState(() => _specificDish = value);
                          },
                        ),
                        const SizedBox(height: 12),
                        // Example dish chips
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _exampleDishes.map((dish) {
                            final isSelected = _specificDish?.toLowerCase() == dish.toLowerCase();
                            return ActionChip(
                              label: Text(dish),
                              avatar: isSelected
                                  ? const Icon(Icons.check, size: 18)
                                  : null,
                              backgroundColor: isSelected
                                  ? AppTheme.primaryColor.withAlpha(30)
                                  : Colors.white,
                              side: BorderSide(
                                color: isSelected
                                    ? AppTheme.primaryColor
                                    : Colors.grey.shade300,
                              ),
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? AppTheme.primaryColor
                                    : Colors.grey.shade700,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                              onPressed: () {
                                _dishController.text = dish;
                                setState(() => _specificDish = dish);
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Cuisine preferences (now secondary)
                  _SectionHeader(
                    icon: Icons.restaurant_menu,
                    title: 'Cuisine Preferences',
                    subtitle: 'Optional: Filter by cuisine type',
                  ),
                  const SizedBox(height: 12),
                  _CuisineSelector(
                    options: _cuisineOptions,
                    selected: _selectedCuisines,
                    onChanged: (cuisines) {
                      setState(() {
                        _selectedCuisines.clear();
                        _selectedCuisines.addAll(cuisines);
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Budget tier
                  _SectionHeader(
                    icon: Icons.attach_money,
                    title: 'Budget',
                  ),
                  const SizedBox(height: 12),
                  _BudgetSelector(
                    selected: _budgetTier,
                    onChanged: (tier) => setState(() => _budgetTier = tier),
                  ),
                  const SizedBox(height: 24),

                  // Number of stops (hidden in single mode)
                  if (!_isSingleMode) ...[
                    _SectionHeader(
                      icon: Icons.pin_drop_outlined,
                      title: 'Number of Stops',
                      trailing: Text(
                        '$_numStops stops',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _StopsSlider(
                      value: _numStops,
                      onChanged: (value) => setState(() => _numStops = value),
                    ),
                    const SizedBox(height: 24),

                    // Transport mode
                    _SectionHeader(
                      icon: Icons.directions,
                      title: 'Transportation',
                    ),
                    const SizedBox(height: 12),
                    _TransportModeSelector(
                      selected: _transportMode,
                      onChanged: (mode) => setState(() => _transportMode = mode),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Award filter
                  _AwardFilterCheckbox(
                    value: _awardOnly,
                    onChanged: (value) =>
                        setState(() => _awardOnly = value ?? false),
                  ),
                  const SizedBox(height: 32),

                  // Generate button
                  FilledButton.icon(
                    onPressed: _isLoading ? null : _generateTour,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(_isSingleMode ? Icons.place : Icons.auto_awesome),
                    label: Text(
                      _isLoading
                          ? _isSingleMode
                              ? 'Finding the best spot...'
                              : 'Crafting your culinary journey...'
                          : _specificDish?.isNotEmpty == true
                              ? _isSingleMode
                                  ? 'Find Best $_specificDish'
                                  : 'Find the Best $_specificDish'
                              : _isSingleMode
                                  ? 'Find Best Restaurant'
                                  : 'Create My Food Journey',
                    ),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      textStyle: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // Extra bottom padding to ensure button is visible above keyboard
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 120 : 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const _SectionHeader({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _CuisineSelector extends StatelessWidget {
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  const _CuisineSelector({
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((cuisine) {
        final isSelected = selected.contains(cuisine);
        return FilterChip(
          label: Text(cuisine),
          selected: isSelected,
          onSelected: (value) {
            final newSet = Set<String>.from(selected);
            if (value) {
              newSet.add(cuisine);
            } else {
              newSet.remove(cuisine);
            }
            onChanged(newSet);
          },
          selectedColor: AppTheme.primaryColor.withAlpha(51),
          checkmarkColor: AppTheme.primaryColor,
        );
      }).toList(),
    );
  }
}

class _BudgetSelector extends StatelessWidget {
  final BudgetTier selected;
  final ValueChanged<BudgetTier> onChanged;

  const _BudgetSelector({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<BudgetTier>(
      segments: const [
        ButtonSegment(
          value: BudgetTier.budget,
          label: Text('\$'),
          icon: Icon(Icons.savings_outlined),
        ),
        ButtonSegment(
          value: BudgetTier.moderate,
          label: Text('\$\$'),
          icon: Icon(Icons.account_balance_wallet_outlined),
        ),
        ButtonSegment(
          value: BudgetTier.upscale,
          label: Text('\$\$\$'),
          icon: Icon(Icons.diamond_outlined),
        ),
        ButtonSegment(
          value: BudgetTier.luxury,
          label: Text('\$\$\$\$'),
          icon: Icon(Icons.auto_awesome),
        ),
      ],
      selected: {selected},
      onSelectionChanged: (selection) {
        if (selection.isNotEmpty) {
          onChanged(selection.first);
        }
      },
      style: ButtonStyle(
        visualDensity: VisualDensity.comfortable,
      ),
    );
  }
}

class _StopsSlider extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _StopsSlider({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: value.toDouble(),
          min: 3,
          max: 6,
          divisions: 3,
          label: '$value stops',
          onChanged: (v) => onChanged(v.round()),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('3', style: TextStyle(color: Colors.grey.shade600)),
              Text('4', style: TextStyle(color: Colors.grey.shade600)),
              Text('5', style: TextStyle(color: Colors.grey.shade600)),
              Text('6', style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
        ),
      ],
    );
  }
}

class _TransportModeSelector extends StatelessWidget {
  final TransportMode selected;
  final ValueChanged<TransportMode> onChanged;

  const _TransportModeSelector({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<TransportMode>(
      segments: const [
        ButtonSegment(
          value: TransportMode.walking,
          label: Text('Walking'),
          icon: Icon(Icons.directions_walk),
        ),
        ButtonSegment(
          value: TransportMode.driving,
          label: Text('Driving'),
          icon: Icon(Icons.directions_car),
        ),
      ],
      selected: {selected},
      onSelectionChanged: (selection) {
        if (selection.isNotEmpty) {
          onChanged(selection.first);
        }
      },
    );
  }
}

class _AwardFilterCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _AwardFilterCheckbox({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Color(0xFFB45309),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Award-Winning Only',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Show only Michelin and James Beard restaurants',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
