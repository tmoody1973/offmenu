import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/photo_upload_service.dart';
import '../widgets/journal_entry_form.dart';

/// A full-page form for creating or editing journal entries.
///
/// Supports two modes:
/// - Tour context: pre-fills restaurant from tour stop
/// - Standalone: requires restaurant selection
class JournalEntryFormPage extends StatefulWidget {
  /// Tour context for creating entry from a tour stop.
  final TourContext? tourContext;

  /// Existing entry ID for editing.
  final int? entryId;

  /// Initial data when editing an existing entry.
  final JournalEntryFormData? initialData;

  /// Callback to create a new entry.
  final Future<Map<String, dynamic>> Function(JournalEntryFormData data)?
      onCreateEntry;

  /// Callback to update an existing entry.
  final Future<Map<String, dynamic>> Function(int id, JournalEntryFormData data)?
      onUpdateEntry;

  /// Callback to get upload URL for a photo.
  final Future<Map<String, dynamic>> Function(int entryId, String filename)?
      onGetUploadUrl;

  /// Callback to confirm photo upload.
  final Future<Map<String, dynamic>> Function(
          int entryId, String objectKey, int displayOrder)?
      onConfirmUpload;

  /// Callback to delete a photo.
  final Future<void> Function(int photoId)? onDeletePhoto;

  const JournalEntryFormPage({
    super.key,
    this.tourContext,
    this.entryId,
    this.initialData,
    this.onCreateEntry,
    this.onUpdateEntry,
    this.onGetUploadUrl,
    this.onConfirmUpload,
    this.onDeletePhoto,
  });

  @override
  State<JournalEntryFormPage> createState() => _JournalEntryFormPageState();
}

class _JournalEntryFormPageState extends State<JournalEntryFormPage> {
  JournalEntryFormData? _currentFormData;
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasUnsavedChanges = false;
  int? _createdEntryId;

  bool get _isEditing => widget.entryId != null;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _showUnsavedChangesDialog();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? 'Edit Entry' : 'Log Visit'),
          actions: [
            if (_hasUnsavedChanges)
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: _isLoading ? null : () => _handleSubmit(_currentFormData),
              ),
          ],
        ),
        body: JournalEntryForm(
          initialData: widget.initialData,
          tourContext: widget.tourContext,
          isLoading: _isLoading,
          errorMessage: _errorMessage,
          onChanged: (data) {
            setState(() {
              _currentFormData = data;
              _hasUnsavedChanges = true;
            });
          },
          onSubmit: _handleSubmit,
          onPhotoUpload: _handlePhotoUpload,
          onPhotoRemove: _handlePhotoRemove,
        ),
      ),
    );
  }

  Future<void> _handleSubmit(JournalEntryFormData? data) async {
    if (data == null) return;

    if (!data.isValid) {
      setState(() {
        _errorMessage = 'Please fill in all required fields';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      Map<String, dynamic> result;

      if (_isEditing) {
        if (widget.onUpdateEntry == null) {
          throw Exception('Update callback not provided');
        }
        result = await widget.onUpdateEntry!(widget.entryId!, data);
      } else {
        if (widget.onCreateEntry == null) {
          throw Exception('Create callback not provided');
        }
        result = await widget.onCreateEntry!(data);
      }

      if (result['success'] == true) {
        // Store created entry ID for photo uploads
        if (result['entry'] != null && result['entry']['id'] != null) {
          _createdEntryId = result['entry']['id'] as int;
        }

        setState(() {
          _hasUnsavedChanges = false;
        });

        if (mounted) {
          Navigator.of(context).pop(result['entry']);
        }
      } else {
        setState(() {
          _errorMessage = result['error'] as String? ?? 'Failed to save entry';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<PhotoUploadResult> _handlePhotoUpload(
      XFile file, int displayOrder) async {
    // Need an entry ID to upload photos
    final entryId = _createdEntryId ?? widget.entryId;

    if (entryId == null) {
      // For new entries, we need to save the entry first
      // Return a placeholder result - photos will be uploaded after entry creation
      return PhotoUploadResult.failure(
          'Entry must be saved before uploading photos');
    }

    if (widget.onGetUploadUrl == null || widget.onConfirmUpload == null) {
      return PhotoUploadResult.failure('Upload not configured');
    }

    final uploadService = PhotoUploadService();
    try {
      return await uploadService.uploadPhoto(
        file: file,
        journalEntryId: entryId,
        displayOrder: displayOrder,
        getUploadUrl: widget.onGetUploadUrl!,
        confirmUpload: widget.onConfirmUpload!,
      );
    } finally {
      uploadService.dispose();
    }
  }

  Future<void> _handlePhotoRemove(int photoId) async {
    if (widget.onDeletePhoto != null) {
      await widget.onDeletePhoto!(photoId);
    }
  }

  Future<bool> _showUnsavedChangesDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text(
            'You have unsaved changes. Are you sure you want to leave?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
