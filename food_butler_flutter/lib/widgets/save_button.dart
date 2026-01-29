import 'package:flutter/material.dart';
import 'package:food_butler_client/food_butler_client.dart';

import '../main.dart';
import '../theme/app_theme.dart';

/// A heart/bookmark button for saving restaurants to favorites.
///
/// Handles the save/unsave logic and displays appropriate state.
/// Can be used on map restaurant cards, Ask the Butler responses, etc.
class SaveButton extends StatefulWidget {
  /// The restaurant name (required for saving).
  final String name;

  /// Google Place ID for the restaurant (used for deduplication).
  final String? placeId;

  /// Restaurant address.
  final String? address;

  /// Type of cuisine.
  final String? cuisineType;

  /// Photo URL.
  final String? imageUrl;

  /// Google rating (0-5).
  final double? rating;

  /// Price level (1-4).
  final int? priceLevel;

  /// Where the restaurant is being saved from.
  final SavedRestaurantSource source;

  /// Size of the icon.
  final double size;

  /// Whether to show a filled background.
  final bool showBackground;

  /// Callback when save state changes.
  final void Function(bool isSaved)? onSaveChanged;

  const SaveButton({
    super.key,
    required this.name,
    this.placeId,
    this.address,
    this.cuisineType,
    this.imageUrl,
    this.rating,
    this.priceLevel,
    required this.source,
    this.size = 24,
    this.showBackground = false,
    this.onSaveChanged,
  });

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton>
    with SingleTickerProviderStateMixin {
  bool _isSaved = false;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _checkSavedStatus();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkSavedStatus() async {
    if (widget.placeId == null) return;

    try {
      final isSaved = await client.savedRestaurant.isRestaurantSaved(
        placeId: widget.placeId!,
      );
      if (mounted) {
        setState(() => _isSaved = isSaved);
      }
    } catch (e) {
      // Silently fail - button will show as not saved
      debugPrint('Failed to check saved status: $e');
    }
  }

  Future<void> _toggleSave() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    // Play animation
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    try {
      if (_isSaved) {
        // Unsave
        final success = await client.savedRestaurant.unsaveRestaurant(
          placeId: widget.placeId,
        );
        if (success && mounted) {
          setState(() => _isSaved = false);
          widget.onSaveChanged?.call(false);
          _showFeedback('Removed from saved');
        }
      } else {
        // Save
        await client.savedRestaurant.saveRestaurant(
          name: widget.name,
          placeId: widget.placeId,
          address: widget.address,
          cuisineType: widget.cuisineType,
          imageUrl: widget.imageUrl,
          rating: widget.rating,
          priceLevel: widget.priceLevel,
          source: widget.source,
        );
        if (mounted) {
          setState(() => _isSaved = true);
          widget.onSaveChanged?.call(true);
          _showFeedback('Saved to favorites');
        }
      }
    } catch (e) {
      if (mounted) {
        _showFeedback('Failed to save: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showFeedback(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? AppTheme.errorColor : null,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final icon = _isSaved ? Icons.favorite : Icons.favorite_border;
    final color = _isSaved ? AppTheme.burntOrange : AppTheme.creamMuted;

    Widget button = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: Icon(
        icon,
        size: widget.size,
        color: _isLoading ? color.withAlpha(100) : color,
      ),
    );

    if (widget.showBackground) {
      button = Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.charcoal.withAlpha(180),
          shape: BoxShape.circle,
        ),
        child: button,
      );
    }

    return GestureDetector(
      onTap: _toggleSave,
      child: button,
    );
  }
}

/// A compact save button for use in tight spaces (like list items).
class SaveButtonCompact extends StatefulWidget {
  final String name;
  final String? placeId;
  final String? address;
  final String? cuisineType;
  final String? imageUrl;
  final double? rating;
  final int? priceLevel;
  final SavedRestaurantSource source;

  const SaveButtonCompact({
    super.key,
    required this.name,
    this.placeId,
    this.address,
    this.cuisineType,
    this.imageUrl,
    this.rating,
    this.priceLevel,
    required this.source,
  });

  @override
  State<SaveButtonCompact> createState() => _SaveButtonCompactState();
}

class _SaveButtonCompactState extends State<SaveButtonCompact> {
  bool _isSaved = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkSavedStatus();
  }

  Future<void> _checkSavedStatus() async {
    if (widget.placeId == null) return;

    try {
      final isSaved = await client.savedRestaurant.isRestaurantSaved(
        placeId: widget.placeId!,
      );
      if (mounted) {
        setState(() => _isSaved = isSaved);
      }
    } catch (e) {
      debugPrint('Failed to check saved status: $e');
    }
  }

  Future<void> _toggleSave() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      if (_isSaved) {
        final success = await client.savedRestaurant.unsaveRestaurant(
          placeId: widget.placeId,
        );
        if (success && mounted) {
          setState(() => _isSaved = false);
        }
      } else {
        await client.savedRestaurant.saveRestaurant(
          name: widget.name,
          placeId: widget.placeId,
          address: widget.address,
          cuisineType: widget.cuisineType,
          imageUrl: widget.imageUrl,
          rating: widget.rating,
          priceLevel: widget.priceLevel,
          source: widget.source,
        );
        if (mounted) {
          setState(() => _isSaved = true);
        }
      }
    } catch (e) {
      debugPrint('Failed to toggle save: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isSaved ? Icons.favorite : Icons.favorite_border,
        color: _isSaved ? AppTheme.burntOrange : AppTheme.creamMuted,
        size: 20,
      ),
      onPressed: _isLoading ? null : _toggleSave,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
    );
  }
}
