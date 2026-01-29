import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/star_rating.dart';

/// Detailed data model for a journal entry.
class JournalEntryDetail {
  final int id;
  final String restaurantName;
  final String restaurantAddress;
  final int rating;
  final DateTime visitedAt;
  final String? notes;
  final List<EntryPhoto> photos;
  final bool hasTourAssociation;
  final int? tourId;

  JournalEntryDetail({
    required this.id,
    required this.restaurantName,
    required this.restaurantAddress,
    required this.rating,
    required this.visitedAt,
    this.notes,
    this.photos = const [],
    this.hasTourAssociation = false,
    this.tourId,
  });

  factory JournalEntryDetail.fromJson(Map<String, dynamic> json) {
    final restaurant = json['restaurant'] as Map<String, dynamic>?;
    final photosJson = json['photos'] as List<dynamic>? ?? [];

    return JournalEntryDetail(
      id: json['id'] as int,
      restaurantName: restaurant?['name'] as String? ?? 'Unknown Restaurant',
      restaurantAddress: restaurant?['address'] as String? ?? '',
      rating: json['rating'] as int,
      visitedAt: DateTime.parse(json['visitedAt'] as String),
      notes: json['notes'] as String?,
      photos: photosJson
          .map((p) => EntryPhoto.fromJson(p as Map<String, dynamic>))
          .toList(),
      hasTourAssociation: json['hasTourAssociation'] as bool? ?? false,
      tourId: json['tourId'] as int?,
    );
  }
}

/// Photo data model.
class EntryPhoto {
  final int id;
  final String originalUrl;
  final String thumbnailUrl;
  final int displayOrder;

  EntryPhoto({
    required this.id,
    required this.originalUrl,
    required this.thumbnailUrl,
    required this.displayOrder,
  });

  factory EntryPhoto.fromJson(Map<String, dynamic> json) {
    return EntryPhoto(
      id: json['id'] as int,
      originalUrl: json['originalUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      displayOrder: json['displayOrder'] as int,
    );
  }
}

/// A page displaying the details of a single journal entry.
///
/// Shows full-size photos, all entry details, and provides edit/delete actions.
class EntryDetailPage extends StatefulWidget {
  /// The entry ID to display.
  final int entryId;

  /// Callback to fetch entry details.
  final Future<Map<String, dynamic>> Function(int entryId)? onFetchEntry;

  /// Called when edit is requested.
  final void Function(JournalEntryDetail entry)? onEdit;

  /// Called when delete is requested.
  final Future<bool> Function(int entryId)? onDelete;

  const EntryDetailPage({
    super.key,
    required this.entryId,
    this.onFetchEntry,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<EntryDetailPage> createState() => _EntryDetailPageState();
}

class _EntryDetailPageState extends State<EntryDetailPage> {
  JournalEntryDetail? _entry;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadEntry();
  }

  Future<void> _loadEntry() async {
    if (widget.onFetchEntry == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await widget.onFetchEntry!(widget.entryId);

      if (result['success'] == true) {
        final entryJson = result['entry'] as Map<String, dynamic>;
        setState(() {
          _entry = JournalEntryDetail.fromJson(entryJson);
        });
      } else {
        setState(() {
          _errorMessage = result['error'] as String? ?? 'Failed to load entry';
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

  Future<void> _handleDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry'),
        content: const Text(
            'Are you sure you want to delete this entry? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && widget.onDelete != null) {
      final success = await widget.onDelete!(widget.entryId);
      if (success && mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entry Details'),
        actions: [
          if (_entry != null) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => widget.onEdit?.call(_entry!),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _handleDelete,
            ),
          ],
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(_errorMessage!),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: _loadEntry,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_entry == null) {
      return const Center(child: Text('Entry not found'));
    }

    return _buildEntryContent();
  }

  Widget _buildEntryContent() {
    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMMMd();
    final timeFormat = DateFormat.jm();
    final entry = _entry!;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Photo gallery
          if (entry.photos.isNotEmpty)
            _PhotoGallery(photos: entry.photos),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restaurant name
                Text(
                  entry.restaurantName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                // Address
                if (entry.restaurantAddress.isNotEmpty)
                  Text(
                    entry.restaurantAddress,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                const SizedBox(height: 16),
                // Rating
                Row(
                  children: [
                    StarRating(rating: entry.rating, readOnly: true),
                    const SizedBox(width: 8),
                    Text(
                      '${entry.rating}/5',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Date and time
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Text(
                      dateFormat.format(entry.visitedAt.toLocal()),
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.access_time,
                        size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Text(
                      timeFormat.format(entry.visitedAt.toLocal()),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                // Tour badge
                if (entry.hasTourAssociation) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.tour,
                          size: 16,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'From Food Tour',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                // Notes
                if (entry.notes != null && entry.notes!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    'Notes',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    entry.notes!,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Horizontal scrolling photo gallery with full-screen view.
class _PhotoGallery extends StatelessWidget {
  final List<EntryPhoto> photos;

  const _PhotoGallery({required this.photos});

  @override
  Widget build(BuildContext context) {
    if (photos.length == 1) {
      return _buildSinglePhoto(context, photos.first);
    }

    return SizedBox(
      height: 250,
      child: PageView.builder(
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return _buildPhoto(context, photos[index]);
        },
      ),
    );
  }

  Widget _buildSinglePhoto(BuildContext context, EntryPhoto photo) {
    return GestureDetector(
      onTap: () => _showFullScreenPhoto(context, photo),
      child: SizedBox(
        height: 250,
        child: CachedNetworkImage(
          imageUrl: photo.originalUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey.shade200,
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey.shade200,
            child: const Icon(Icons.broken_image, size: 64),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoto(BuildContext context, EntryPhoto photo) {
    return GestureDetector(
      onTap: () => _showFullScreenPhoto(context, photo),
      child: CachedNetworkImage(
        imageUrl: photo.originalUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey.shade200,
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey.shade200,
          child: const Icon(Icons.broken_image, size: 64),
        ),
      ),
    );
  }

  void _showFullScreenPhoto(BuildContext context, EntryPhoto photo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _FullScreenPhoto(photo: photo),
      ),
    );
  }
}

/// Full-screen photo view with pinch-to-zoom.
class _FullScreenPhoto extends StatelessWidget {
  final EntryPhoto photo;

  const _FullScreenPhoto({required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: CachedNetworkImage(
            imageUrl: photo.originalUrl,
            fit: BoxFit.contain,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            errorWidget: (context, url, error) => const Icon(
              Icons.broken_image,
              color: Colors.white,
              size: 64,
            ),
          ),
        ),
      ),
    );
  }
}
