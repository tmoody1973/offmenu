import 'package:flutter/material.dart';

/// An auto-expanding text field for journal entry notes.
///
/// Mobile-optimized with multiline input.
/// No character limit.
class NotesTextField extends StatelessWidget {
  /// The current notes text.
  final String? notes;

  /// Called when the notes change.
  final void Function(String notes)? onNotesChanged;

  /// Optional text editing controller.
  final TextEditingController? controller;

  /// Label text displayed above the field.
  final String label;

  /// Hint text displayed when empty.
  final String hintText;

  /// Whether the field is enabled.
  final bool enabled;

  /// Minimum number of lines.
  final int minLines;

  /// Maximum number of lines before scrolling.
  final int? maxLines;

  const NotesTextField({
    super.key,
    this.notes,
    this.onNotesChanged,
    this.controller,
    this.label = 'Notes',
    this.hintText = 'What did you enjoy? Any memorable dishes or experiences?',
    this.enabled = true,
    this.minLines = 3,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(width: 4),
            Text(
              '(optional)',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onNotesChanged,
          enabled: enabled,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          minLines: minLines,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }
}
