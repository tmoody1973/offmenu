import 'package:flutter/material.dart';
import 'package:food_butler_client/food_butler_client.dart';
import '../../services/opentable/reservation_launcher.dart';
import '../../services/opentable/reservation_link_service.dart';

/// Callback for when a reservation action is completed.
typedef OnReservationCallback = void Function(LaunchResult result);

/// A button widget for making restaurant reservations.
///
/// Features:
/// - OpenTable integration with app/web fallback
/// - Phone and website fallback options
/// - Loading state during launch
/// - Error feedback via snackbar
class ReserveButton extends StatefulWidget {
  /// The restaurant to make a reservation for.
  final Restaurant restaurant;

  /// Party size for the reservation.
  final int partySize;

  /// Scheduled time for the reservation (optional).
  final DateTime? scheduledTime;

  /// Callback when reservation action completes.
  final OnReservationCallback? onReservation;

  /// Whether to show compact variant.
  final bool compact;

  /// Custom launcher for testing.
  final ReservationLauncher? launcher;

  const ReserveButton({
    super.key,
    required this.restaurant,
    this.partySize = 2,
    this.scheduledTime,
    this.onReservation,
    this.compact = false,
    this.launcher,
  });

  @override
  State<ReserveButton> createState() => _ReserveButtonState();
}

class _ReserveButtonState extends State<ReserveButton> {
  late ReservationLauncher _launcher;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _launcher = widget.launcher ?? ReservationLauncher();
  }

  @override
  Widget build(BuildContext context) {
    final hasOpenTable = ReservationLinkService.hasOpenTableSupport(widget.restaurant);
    final hasPhone = ReservationLinkService.hasPhoneContact(widget.restaurant);
    final hasWebsite = ReservationLinkService.hasWebsiteContact(widget.restaurant);

    // If OpenTable is available, show the primary Reserve button
    if (hasOpenTable) {
      return _buildPrimaryButton(context);
    }

    // If no OpenTable but has fallback options, show them
    if (hasPhone || hasWebsite) {
      return _buildFallbackButtons(context, hasPhone, hasWebsite);
    }

    // No contact options available
    return const SizedBox.shrink();
  }

  Widget _buildPrimaryButton(BuildContext context) {
    if (widget.compact) {
      return IconButton(
        onPressed: _isLoading ? null : _launchReservation,
        icon: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                ),
              )
            : const Icon(Icons.calendar_today_rounded),
        color: const Color(0xFF2563EB),
        tooltip: 'Make Reservation',
        style: IconButton.styleFrom(
          backgroundColor: const Color(0xFFEFF6FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: _isLoading ? null : _launchReservation,
      icon: _isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Icon(Icons.calendar_today_rounded, size: 18),
      label: Text(_isLoading ? 'Opening...' : 'Reserve'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFDA3743), // OpenTable red
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildFallbackButtons(BuildContext context, bool hasPhone, bool hasWebsite) {
    if (widget.compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasPhone)
            IconButton(
              onPressed: _launchPhone,
              icon: const Icon(Icons.phone_rounded),
              color: Colors.green,
              tooltip: 'Call Restaurant',
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFFDCFCE7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          if (hasWebsite) ...[
            if (hasPhone) const SizedBox(width: 8),
            IconButton(
              onPressed: _launchWebsite,
              icon: const Icon(Icons.language_rounded),
              color: const Color(0xFF2563EB),
              tooltip: 'Visit Website',
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFFEFF6FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasPhone)
          OutlinedButton.icon(
            onPressed: _launchPhone,
            icon: const Icon(Icons.phone_rounded, size: 18),
            label: const Text('Call'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.green,
              side: const BorderSide(color: Colors.green),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        if (hasWebsite) ...[
          if (hasPhone) const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: _launchWebsite,
            icon: const Icon(Icons.language_rounded, size: 18),
            label: const Text('Website'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF2563EB),
              side: const BorderSide(color: Color(0xFF2563EB)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _launchReservation() async {
    setState(() => _isLoading = true);

    try {
      final result = await _launcher.launchReservation(
        restaurant: widget.restaurant,
        partySize: widget.partySize,
        scheduledTime: widget.scheduledTime,
      );

      widget.onReservation?.call(result);

      if (!result.success && mounted) {
        _showErrorSnackbar(result.errorMessage ?? 'Could not open reservation page');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _launchPhone() async {
    final result = await _launcher.launchPhone(widget.restaurant);
    widget.onReservation?.call(result);

    if (!result.success && mounted) {
      _showErrorSnackbar(result.errorMessage ?? 'Could not open phone dialer');
    }
  }

  Future<void> _launchWebsite() async {
    final result = await _launcher.launchWebsite(widget.restaurant);
    widget.onReservation?.call(result);

    if (!result.success && mounted) {
      _showErrorSnackbar(result.errorMessage ?? 'Could not open website');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
