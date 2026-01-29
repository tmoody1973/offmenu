import 'package:flutter/material.dart';
import 'package:food_butler_client/food_butler_client.dart';
import '../../services/opentable/reservation_launcher.dart';
import '../../services/opentable/reservation_link_service.dart';

/// A compact reserve button designed for tour stop cards.
///
/// Features:
/// - Uses scheduled tour time for the specific stop
/// - Compact icon-only variant for card layouts
/// - Shows appropriate fallback buttons when OpenTable unavailable
class TourStopReserveButton extends StatefulWidget {
  /// The restaurant for this tour stop.
  final Restaurant restaurant;

  /// The scheduled time for this specific tour stop.
  final DateTime? stopTime;

  /// Party size (typically from tour settings).
  final int partySize;

  /// Callback when reservation action completes.
  final void Function(LaunchResult result)? onReservation;

  /// Custom launcher for testing.
  final ReservationLauncher? launcher;

  const TourStopReserveButton({
    super.key,
    required this.restaurant,
    this.stopTime,
    this.partySize = 2,
    this.onReservation,
    this.launcher,
  });

  @override
  State<TourStopReserveButton> createState() => _TourStopReserveButtonState();
}

class _TourStopReserveButtonState extends State<TourStopReserveButton> {
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

    // Build action buttons based on available options
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasOpenTable) _buildReserveButton(),
        if (hasPhone) ...[
          if (hasOpenTable) const SizedBox(width: 4),
          _buildPhoneButton(),
        ],
        if (hasWebsite) ...[
          if (hasOpenTable || hasPhone) const SizedBox(width: 4),
          _buildWebsiteButton(),
        ],
      ],
    );
  }

  Widget _buildReserveButton() {
    return Tooltip(
      message: 'Reserve via OpenTable',
      child: InkWell(
        onTap: _isLoading ? null : _launchReservation,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFFFDE8E8), // Light red background
            borderRadius: BorderRadius.circular(6),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDA3743)),
                  ),
                )
              : const Icon(
                  Icons.calendar_today_rounded,
                  size: 18,
                  color: Color(0xFFDA3743), // OpenTable red
                ),
        ),
      ),
    );
  }

  Widget _buildPhoneButton() {
    return Tooltip(
      message: 'Call Restaurant',
      child: InkWell(
        onTap: _launchPhone,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFFDCFCE7), // Light green background
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
            Icons.phone_rounded,
            size: 18,
            color: Color(0xFF16A34A), // Green
          ),
        ),
      ),
    );
  }

  Widget _buildWebsiteButton() {
    return Tooltip(
      message: 'Visit Website',
      child: InkWell(
        onTap: _launchWebsite,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF), // Light blue background
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
            Icons.language_rounded,
            size: 18,
            color: Color(0xFF2563EB), // Blue
          ),
        ),
      ),
    );
  }

  Future<void> _launchReservation() async {
    setState(() => _isLoading = true);

    try {
      final result = await _launcher.launchReservation(
        restaurant: widget.restaurant,
        partySize: widget.partySize,
        scheduledTime: widget.stopTime,
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
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
