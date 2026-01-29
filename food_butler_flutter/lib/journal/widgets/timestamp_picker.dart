import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A widget for picking a date and time for a journal entry.
///
/// Displays the selected timestamp in the user's local timezone.
/// Stores the value as UTC internally.
class TimestampPicker extends StatelessWidget {
  /// The currently selected timestamp (in UTC).
  final DateTime timestamp;

  /// Called when the timestamp changes.
  final void Function(DateTime timestamp)? onTimestampChanged;

  /// Label text displayed above the picker.
  final String label;

  /// Whether the picker is enabled.
  final bool enabled;

  /// The earliest selectable date.
  final DateTime? firstDate;

  /// The latest selectable date.
  final DateTime? lastDate;

  const TimestampPicker({
    super.key,
    required this.timestamp,
    this.onTimestampChanged,
    this.label = 'Visit Date & Time',
    this.enabled = true,
    this.firstDate,
    this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localTime = timestamp.toLocal();
    final dateFormat = DateFormat.yMMMd();
    final timeFormat = DateFormat.jm();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Date picker button
            Expanded(
              child: _PickerButton(
                icon: Icons.calendar_today,
                text: dateFormat.format(localTime),
                enabled: enabled,
                onTap: () => _showDatePicker(context),
              ),
            ),
            const SizedBox(width: 12),
            // Time picker button
            Expanded(
              child: _PickerButton(
                icon: Icons.access_time,
                text: timeFormat.format(localTime),
                enabled: enabled,
                onTap: () => _showTimePicker(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final localTime = timestamp.toLocal();
    final now = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: localTime,
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? now.add(const Duration(minutes: 5)),
    );

    if (selectedDate != null) {
      final newTimestamp = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        localTime.hour,
        localTime.minute,
      ).toUtc();
      onTimestampChanged?.call(newTimestamp);
    }
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final localTime = timestamp.toLocal();

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(localTime),
    );

    if (selectedTime != null) {
      final newTimestamp = DateTime(
        localTime.year,
        localTime.month,
        localTime.day,
        selectedTime.hour,
        selectedTime.minute,
      ).toUtc();
      onTimestampChanged?.call(newTimestamp);
    }
  }
}

/// A button styled for date/time picking.
class _PickerButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool enabled;
  final VoidCallback? onTap;

  const _PickerButton({
    required this.icon,
    required this.text,
    required this.enabled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: enabled ? Colors.grey.shade400 : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: enabled ? theme.colorScheme.primary : Colors.grey.shade400,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: enabled ? null : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
