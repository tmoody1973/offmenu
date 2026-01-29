import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/photo_upload_service.dart';
import 'notes_text_field.dart';
import 'photo_picker.dart';
import 'star_rating.dart';
import 'timestamp_picker.dart';

/// Data for a journal entry form.
class JournalEntryFormData {
  final int? restaurantId;
  final String? restaurantName;
  final int? tourId;
  final int? tourStopId;
  final int rating;
  final String? notes;
  final DateTime visitedAt;
  final List<SelectedPhoto> photos;

  JournalEntryFormData({
    this.restaurantId,
    this.restaurantName,
    this.tourId,
    this.tourStopId,
    this.rating = 0,
    this.notes,
    DateTime? visitedAt,
    List<SelectedPhoto>? photos,
  })  : visitedAt = visitedAt ?? DateTime.now().toUtc(),
        photos = photos ?? [];

  bool get isValid => restaurantId != null && rating >= 1 && rating <= 5;

  JournalEntryFormData copyWith({
    int? restaurantId,
    String? restaurantName,
    int? tourId,
    int? tourStopId,
    int? rating,
    String? notes,
    DateTime? visitedAt,
    List<SelectedPhoto>? photos,
  }) {
    return JournalEntryFormData(
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      tourId: tourId ?? this.tourId,
      tourStopId: tourStopId ?? this.tourStopId,
      rating: rating ?? this.rating,
      notes: notes ?? this.notes,
      visitedAt: visitedAt ?? this.visitedAt,
      photos: photos ?? this.photos,
    );
  }
}

/// Context for creating a journal entry from a tour.
class TourContext {
  final int tourId;
  final int tourStopId;
  final int restaurantId;
  final String restaurantName;

  TourContext({
    required this.tourId,
    required this.tourStopId,
    required this.restaurantId,
    required this.restaurantName,
  });
}

/// A form widget for creating or editing journal entries.
///
/// Handles two modes:
/// - Tour context: restaurant pre-filled from tour stop
/// - Standalone: user must search and select a restaurant
class JournalEntryForm extends StatefulWidget {
  /// Initial form data (for editing).
  final JournalEntryFormData? initialData;

  /// Tour context for pre-filling restaurant.
  final TourContext? tourContext;

  /// Called when the form is submitted.
  final void Function(JournalEntryFormData data)? onSubmit;

  /// Called when the form data changes.
  final void Function(JournalEntryFormData data)? onChanged;

  /// Called when a photo needs to be uploaded.
  final Future<PhotoUploadResult> Function(XFile file, int displayOrder)?
      onPhotoUpload;

  /// Called when a photo should be removed.
  final Future<void> Function(int photoId)? onPhotoRemove;

  /// Whether the form is in loading state.
  final bool isLoading;

  /// Error message to display.
  final String? errorMessage;

  const JournalEntryForm({
    super.key,
    this.initialData,
    this.tourContext,
    this.onSubmit,
    this.onChanged,
    this.onPhotoUpload,
    this.onPhotoRemove,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  State<JournalEntryForm> createState() => _JournalEntryFormState();
}

class _JournalEntryFormState extends State<JournalEntryForm> {
  late JournalEntryFormData _formData;
  late TextEditingController _notesController;
  bool _hasAttemptedSubmit = false;

  @override
  void initState() {
    super.initState();
    _formData = widget.initialData ??
        JournalEntryFormData(
          restaurantId: widget.tourContext?.restaurantId,
          restaurantName: widget.tourContext?.restaurantName,
          tourId: widget.tourContext?.tourId,
          tourStopId: widget.tourContext?.tourStopId,
        );
    _notesController = TextEditingController(text: _formData.notes);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _updateFormData(JournalEntryFormData data) {
    setState(() {
      _formData = data;
    });
    widget.onChanged?.call(data);
  }

  Future<void> _handlePhotoSelected(XFile file) async {
    if (_formData.photos.length >= 3) return;

    // Read file bytes for preview
    final bytes = await file.readAsBytes();
    final displayOrder = _formData.photos.length;

    // Add photo to list with local preview
    final newPhoto = SelectedPhoto(
      file: file,
      localBytes: bytes,
      uploadState: UploadState.idle,
    );

    final updatedPhotos = [..._formData.photos, newPhoto];
    _updateFormData(_formData.copyWith(photos: updatedPhotos));

    // Start upload if callback is provided
    if (widget.onPhotoUpload != null) {
      // Update state to uploading
      _updatePhotoState(displayOrder, UploadState.compressing, 0);

      final result = await widget.onPhotoUpload!(file, displayOrder);

      if (result.success) {
        // Update with uploaded photo data
        final uploadedPhoto = SelectedPhoto(
          url: result.originalUrl,
          thumbnailUrl: result.thumbnailUrl,
          photoId: result.photoId,
          localBytes: bytes,
          uploadState: UploadState.complete,
          uploadProgress: 1.0,
        );
        _updatePhotoAt(displayOrder, uploadedPhoto);
      } else {
        // Mark as error
        _updatePhotoState(displayOrder, UploadState.error, 0);
      }
    }
  }

  void _updatePhotoState(int index, UploadState state, double progress) {
    if (index >= _formData.photos.length) return;

    final updatedPhotos = List<SelectedPhoto>.from(_formData.photos);
    updatedPhotos[index] = updatedPhotos[index].copyWith(
      uploadState: state,
      uploadProgress: progress,
    );
    _updateFormData(_formData.copyWith(photos: updatedPhotos));
  }

  void _updatePhotoAt(int index, SelectedPhoto photo) {
    if (index >= _formData.photos.length) return;

    final updatedPhotos = List<SelectedPhoto>.from(_formData.photos);
    updatedPhotos[index] = photo;
    _updateFormData(_formData.copyWith(photos: updatedPhotos));
  }

  Future<void> _handlePhotoRemoved(int index) async {
    if (index >= _formData.photos.length) return;

    final photo = _formData.photos[index];

    // Remove from server if uploaded
    if (photo.photoId != null && widget.onPhotoRemove != null) {
      await widget.onPhotoRemove!(photo.photoId!);
    }

    final updatedPhotos = List<SelectedPhoto>.from(_formData.photos);
    updatedPhotos.removeAt(index);
    _updateFormData(_formData.copyWith(photos: updatedPhotos));
  }

  void _handleSubmit() {
    setState(() {
      _hasAttemptedSubmit = true;
    });

    if (_formData.isValid) {
      widget.onSubmit?.call(_formData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isStandalone = widget.tourContext == null;
    final hasRatingError = _hasAttemptedSubmit && _formData.rating == 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Restaurant info (pre-filled or selector)
          if (_formData.restaurantName != null)
            _buildRestaurantInfo(theme)
          else if (isStandalone)
            _buildRestaurantSelector(theme),

          const SizedBox(height: 24),

          // Star rating
          LabeledStarRating(
            label: 'Rating',
            rating: _formData.rating,
            required: true,
            errorText: hasRatingError ? 'Rating is required' : null,
            readOnly: widget.isLoading,
            onRatingChanged: (rating) {
              _updateFormData(_formData.copyWith(rating: rating));
            },
          ),

          const SizedBox(height: 24),

          // Notes
          NotesTextField(
            controller: _notesController,
            enabled: !widget.isLoading,
            onNotesChanged: (notes) {
              _updateFormData(_formData.copyWith(notes: notes));
            },
          ),

          const SizedBox(height: 24),

          // Timestamp picker
          TimestampPicker(
            timestamp: _formData.visitedAt,
            enabled: !widget.isLoading,
            onTimestampChanged: (timestamp) {
              _updateFormData(_formData.copyWith(visitedAt: timestamp));
            },
          ),

          const SizedBox(height: 24),

          // Photos
          PhotoPicker(
            photos: _formData.photos,
            enabled: !widget.isLoading,
            onPhotoSelected: _handlePhotoSelected,
            onPhotoRemoved: _handlePhotoRemoved,
          ),

          // Error message
          if (widget.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                widget.errorMessage!,
                style: TextStyle(color: theme.colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ),

          const SizedBox(height: 32),

          // Submit button
          FilledButton(
            onPressed: widget.isLoading ? null : _handleSubmit,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: widget.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Save Entry'),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildRestaurantInfo(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.restaurant,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formData.restaurantName ?? '',
                  style: theme.textTheme.titleMedium,
                ),
                if (widget.tourContext != null)
                  Text(
                    'From your food tour',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantSelector(ThemeData theme) {
    // TODO: Implement restaurant search selector
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.search),
          const SizedBox(width: 12),
          Text(
            'Search for a restaurant...',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
