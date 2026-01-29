import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/photo_upload_service.dart';

/// A photo that has been selected or uploaded.
class SelectedPhoto {
  final String? url;
  final String? thumbnailUrl;
  final Uint8List? localBytes;
  final XFile? file;
  final int? photoId;
  final UploadState uploadState;
  final double uploadProgress;

  SelectedPhoto({
    this.url,
    this.thumbnailUrl,
    this.localBytes,
    this.file,
    this.photoId,
    this.uploadState = UploadState.idle,
    this.uploadProgress = 0,
  });

  bool get isUploading => uploadState == UploadState.uploading ||
      uploadState == UploadState.compressing ||
      uploadState == UploadState.processing;

  bool get isUploaded => url != null && photoId != null;

  bool get hasError => uploadState == UploadState.error;

  SelectedPhoto copyWith({
    String? url,
    String? thumbnailUrl,
    Uint8List? localBytes,
    XFile? file,
    int? photoId,
    UploadState? uploadState,
    double? uploadProgress,
  }) {
    return SelectedPhoto(
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      localBytes: localBytes ?? this.localBytes,
      file: file ?? this.file,
      photoId: photoId ?? this.photoId,
      uploadState: uploadState ?? this.uploadState,
      uploadProgress: uploadProgress ?? this.uploadProgress,
    );
  }
}

/// Widget for picking and displaying photos.
///
/// Supports camera capture and gallery selection.
/// Displays selected photos as a row of thumbnails.
/// Maximum 3 photos for MVP.
class PhotoPicker extends StatelessWidget {
  /// Currently selected photos.
  final List<SelectedPhoto> photos;

  /// Called when a photo is selected from camera or gallery.
  final void Function(XFile file)? onPhotoSelected;

  /// Called when a photo should be removed.
  final void Function(int index)? onPhotoRemoved;

  /// Called when a photo is tapped (for full-screen view).
  final void Function(int index)? onPhotoTapped;

  /// Maximum number of photos allowed.
  final int maxPhotos;

  /// Whether the picker is enabled.
  final bool enabled;

  const PhotoPicker({
    super.key,
    required this.photos,
    this.onPhotoSelected,
    this.onPhotoRemoved,
    this.onPhotoTapped,
    this.maxPhotos = 3,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Photos (${photos.length}/$maxPhotos)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: photos.length + (photos.length < maxPhotos && enabled ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == photos.length) {
                return _buildAddButton(context);
              }
              return _buildPhotoThumbnail(context, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: enabled ? () => _showPickerOptions(context) : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_a_photo,
                size: 32,
                color: enabled ? Colors.grey.shade600 : Colors.grey.shade400,
              ),
              const SizedBox(height: 4),
              Text(
                'Add Photo',
                style: TextStyle(
                  fontSize: 12,
                  color: enabled ? Colors.grey.shade600 : Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoThumbnail(BuildContext context, int index) {
    final photo = photos[index];

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          InkWell(
            onTap: () => onPhotoTapped?.call(index),
            borderRadius: BorderRadius.circular(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 100,
                height: 100,
                child: _buildPhotoContent(photo),
              ),
            ),
          ),
          // Upload progress overlay
          if (photo.isUploading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    value: photo.uploadProgress > 0 ? photo.uploadProgress : null,
                    strokeWidth: 3,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),
          // Error overlay
          if (photo.hasError)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.error_outline, color: Colors.white, size: 32),
                ),
              ),
            ),
          // Remove button
          if (enabled && !photo.isUploading)
            Positioned(
              top: 4,
              right: 4,
              child: InkWell(
                onTap: () => onPhotoRemoved?.call(index),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPhotoContent(SelectedPhoto photo) {
    // Show local bytes if available (before upload complete)
    if (photo.localBytes != null) {
      return Image.memory(
        photo.localBytes!,
        fit: BoxFit.cover,
      );
    }

    // Show network thumbnail if available
    if (photo.thumbnailUrl != null) {
      return CachedNetworkImage(
        imageUrl: photo.thumbnailUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey.shade200,
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey.shade200,
          child: const Icon(Icons.broken_image),
        ),
      );
    }

    // Placeholder
    return Container(
      color: Colors.grey.shade200,
      child: const Icon(Icons.image, size: 32),
    );
  }

  void _showPickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              onTap: () async {
                Navigator.pop(context);
                final picker = ImagePicker();
                final file = await picker.pickImage(
                  source: ImageSource.camera,
                  preferredCameraDevice: CameraDevice.rear,
                );
                if (file != null) {
                  onPhotoSelected?.call(file);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              onTap: () async {
                Navigator.pop(context);
                final picker = ImagePicker();
                final file = await picker.pickImage(source: ImageSource.gallery);
                if (file != null) {
                  onPhotoSelected?.call(file);
                }
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
