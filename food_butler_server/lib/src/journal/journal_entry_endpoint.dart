import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/r2_service.dart';

/// Request model for creating a journal entry.
class CreateJournalEntryRequest {
  final int restaurantId;
  final int rating;
  final String? notes;
  final DateTime visitedAt;
  final int? tourId;
  final int? tourStopId;

  CreateJournalEntryRequest({
    required this.restaurantId,
    required this.rating,
    this.notes,
    required this.visitedAt,
    this.tourId,
    this.tourStopId,
  });
}

/// Request model for updating a journal entry.
class UpdateJournalEntryRequest {
  final int? rating;
  final String? notes;
  final DateTime? visitedAt;

  UpdateJournalEntryRequest({
    this.rating,
    this.notes,
    this.visitedAt,
  });
}

/// Response model for paginated journal entries.
class PaginatedEntriesResponse {
  final List<Map<String, dynamic>> entries;
  final int totalCount;
  final int page;
  final int pageSize;
  final bool hasMore;

  PaginatedEntriesResponse({
    required this.entries,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.hasMore,
  });

  Map<String, dynamic> toJson() => {
        'entries': entries,
        'totalCount': totalCount,
        'page': page,
        'pageSize': pageSize,
        'hasMore': hasMore,
      };
}

/// Response model for restaurant visit summary.
class RestaurantVisitSummary {
  final int restaurantId;
  final String restaurantName;
  final String restaurantAddress;
  final int visitCount;
  final double averageRating;
  final DateTime lastVisitDate;
  final String? thumbnailUrl;

  RestaurantVisitSummary({
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantAddress,
    required this.visitCount,
    required this.averageRating,
    required this.lastVisitDate,
    this.thumbnailUrl,
  });

  Map<String, dynamic> toJson() => {
        'restaurantId': restaurantId,
        'restaurantName': restaurantName,
        'restaurantAddress': restaurantAddress,
        'visitCount': visitCount,
        'averageRating': averageRating,
        'lastVisitDate': lastVisitDate.toIso8601String(),
        if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
      };
}

/// Journal entry API endpoint.
///
/// Provides CRUD operations for journal entries with filtering and pagination.
class JournalEntryEndpoint extends Endpoint {
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  /// Create a new journal entry.
  ///
  /// POST /journal-entries
  /// Requires authentication.
  Future<Map<String, dynamic>> createEntry(
    Session session, {
    required int restaurantId,
    required int rating,
    String? notes,
    required DateTime visitedAt,
    int? tourId,
    int? tourStopId,
  }) async {
    // Verify authentication
    final userId = await _getAuthenticatedUserId(session);
    if (userId == null) {
      return {'success': false, 'error': 'Authentication required', 'statusCode': 401};
    }

    // Validate rating
    if (rating < 1 || rating > 5) {
      return {'success': false, 'error': 'Rating must be between 1 and 5', 'statusCode': 400};
    }

    // Validate visitedAt is not in the future
    if (visitedAt.isAfter(DateTime.now().add(const Duration(minutes: 5)))) {
      return {'success': false, 'error': 'Visit date cannot be in the future', 'statusCode': 400};
    }

    // Verify restaurant exists
    final restaurant = await Restaurant.db.findById(session, restaurantId);
    if (restaurant == null) {
      return {'success': false, 'error': 'Restaurant not found', 'statusCode': 404};
    }

    try {
      final now = DateTime.now().toUtc();
      final entry = await JournalEntry.db.insertRow(
        session,
        JournalEntry(
          userId: userId,
          restaurantId: restaurantId,
          tourId: tourId,
          tourStopId: tourStopId,
          rating: rating,
          notes: notes,
          visitedAt: visitedAt.toUtc(),
          createdAt: now,
          updatedAt: now,
        ),
      );

      return {
        'success': true,
        'entry': _entryToJson(entry, restaurant: restaurant),
        'statusCode': 201,
      };
    } catch (e) {
      session.log('Error creating journal entry: $e', level: LogLevel.error);
      return {'success': false, 'error': 'Failed to create entry', 'statusCode': 500};
    }
  }

  /// Get a list of the user's journal entries.
  ///
  /// GET /journal-entries
  /// Supports pagination, sorting, and filtering.
  Future<Map<String, dynamic>> getEntries(
    Session session, {
    int page = 1,
    int pageSize = defaultPageSize,
    String sortBy = 'visitedAt',
    String sortOrder = 'desc',
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    // Verify authentication
    final userId = await _getAuthenticatedUserId(session);
    if (userId == null) {
      return {'success': false, 'error': 'Authentication required', 'statusCode': 401};
    }

    // Validate pagination
    if (page < 1) page = 1;
    if (pageSize < 1) pageSize = defaultPageSize;
    if (pageSize > maxPageSize) pageSize = maxPageSize;

    try {
      // Build where clause
      var whereClause = JournalEntry.t.userId.equals(userId);

      if (startDate != null) {
        whereClause = whereClause & (JournalEntry.t.visitedAt >= startDate.toUtc());
      }
      if (endDate != null) {
        whereClause = whereClause & (JournalEntry.t.visitedAt <= endDate.toUtc());
      }

      // Get total count
      final totalCount = await JournalEntry.db.count(
        session,
        where: (t) => whereClause,
      );

      // Determine sort order
      final orderDescending = sortOrder.toLowerCase() == 'desc';

      // Get entries with pagination
      final entries = await JournalEntry.db.find(
        session,
        where: (t) => whereClause,
        orderBy: (t) => sortBy == 'rating' ? t.rating : t.visitedAt,
        orderDescending: orderDescending,
        limit: pageSize,
        offset: (page - 1) * pageSize,
      );

      // Get restaurant details and photos for entries
      final entriesWithDetails = await Future.wait(
        entries.map((entry) => _enrichEntry(session, entry)),
      );

      final hasMore = (page * pageSize) < totalCount;

      return {
        'success': true,
        'data': PaginatedEntriesResponse(
          entries: entriesWithDetails,
          totalCount: totalCount,
          page: page,
          pageSize: pageSize,
          hasMore: hasMore,
        ).toJson(),
        'statusCode': 200,
      };
    } catch (e) {
      session.log('Error fetching journal entries: $e', level: LogLevel.error);
      return {'success': false, 'error': 'Failed to fetch entries', 'statusCode': 500};
    }
  }

  /// Get a single journal entry by ID.
  ///
  /// GET /journal-entries/{id}
  Future<Map<String, dynamic>> getEntry(
    Session session, {
    required int entryId,
  }) async {
    // Verify authentication
    final userId = await _getAuthenticatedUserId(session);
    if (userId == null) {
      return {'success': false, 'error': 'Authentication required', 'statusCode': 401};
    }

    try {
      final entry = await JournalEntry.db.findById(session, entryId);
      if (entry == null) {
        return {'success': false, 'error': 'Entry not found', 'statusCode': 404};
      }

      // Verify ownership
      if (entry.userId != userId) {
        return {'success': false, 'error': 'Not authorized', 'statusCode': 403};
      }

      final enrichedEntry = await _enrichEntry(session, entry, includeFullPhotos: true);

      return {
        'success': true,
        'entry': enrichedEntry,
        'statusCode': 200,
      };
    } catch (e) {
      session.log('Error fetching journal entry: $e', level: LogLevel.error);
      return {'success': false, 'error': 'Failed to fetch entry', 'statusCode': 500};
    }
  }

  /// Update a journal entry.
  ///
  /// PUT /journal-entries/{id}
  /// Only rating, notes, and visitedAt can be updated.
  Future<Map<String, dynamic>> updateEntry(
    Session session, {
    required int entryId,
    int? rating,
    String? notes,
    DateTime? visitedAt,
  }) async {
    // Verify authentication
    final userId = await _getAuthenticatedUserId(session);
    if (userId == null) {
      return {'success': false, 'error': 'Authentication required', 'statusCode': 401};
    }

    // Validate rating if provided
    if (rating != null && (rating < 1 || rating > 5)) {
      return {'success': false, 'error': 'Rating must be between 1 and 5', 'statusCode': 400};
    }

    // Validate visitedAt if provided
    if (visitedAt != null && visitedAt.isAfter(DateTime.now().add(const Duration(minutes: 5)))) {
      return {'success': false, 'error': 'Visit date cannot be in the future', 'statusCode': 400};
    }

    try {
      final entry = await JournalEntry.db.findById(session, entryId);
      if (entry == null) {
        return {'success': false, 'error': 'Entry not found', 'statusCode': 404};
      }

      // Verify ownership
      if (entry.userId != userId) {
        return {'success': false, 'error': 'Not authorized', 'statusCode': 403};
      }

      // Update fields
      final updatedEntry = entry.copyWith(
        rating: rating ?? entry.rating,
        notes: notes ?? entry.notes,
        visitedAt: visitedAt?.toUtc() ?? entry.visitedAt,
        updatedAt: DateTime.now().toUtc(),
      );

      await JournalEntry.db.updateRow(session, updatedEntry);

      final enrichedEntry = await _enrichEntry(session, updatedEntry);

      return {
        'success': true,
        'entry': enrichedEntry,
        'statusCode': 200,
      };
    } catch (e) {
      session.log('Error updating journal entry: $e', level: LogLevel.error);
      return {'success': false, 'error': 'Failed to update entry', 'statusCode': 500};
    }
  }

  /// Delete a journal entry and its photos.
  ///
  /// DELETE /journal-entries/{id}
  Future<Map<String, dynamic>> deleteEntry(
    Session session, {
    required int entryId,
  }) async {
    // Verify authentication
    final userId = await _getAuthenticatedUserId(session);
    if (userId == null) {
      return {'success': false, 'error': 'Authentication required', 'statusCode': 401};
    }

    try {
      final entry = await JournalEntry.db.findById(session, entryId);
      if (entry == null) {
        return {'success': false, 'error': 'Entry not found', 'statusCode': 404};
      }

      // Verify ownership
      if (entry.userId != userId) {
        return {'success': false, 'error': 'Not authorized', 'statusCode': 403};
      }

      // Delete photos from R2
      final photos = await JournalPhoto.db.find(
        session,
        where: (t) => t.journalEntryId.equals(entryId),
      );

      if (photos.isNotEmpty) {
        final r2Service = await _getR2Service(session);
        for (final photo in photos) {
          final objectKey = _extractObjectKey(photo.originalUrl);
          if (objectKey != null) {
            await r2Service.deleteObject(objectKey);
          }
        }

        // Delete photo records
        await JournalPhoto.db.deleteWhere(
          session,
          where: (t) => t.journalEntryId.equals(entryId),
        );
      }

      // Delete the entry
      await JournalEntry.db.deleteRow(session, entry);

      return {'success': true, 'statusCode': 200};
    } catch (e) {
      session.log('Error deleting journal entry: $e', level: LogLevel.error);
      return {'success': false, 'error': 'Failed to delete entry', 'statusCode': 500};
    }
  }

  /// Get entries for a specific restaurant.
  ///
  /// GET /journal-entries/by-restaurant/{restaurantId}
  Future<Map<String, dynamic>> getEntriesByRestaurant(
    Session session, {
    required int restaurantId,
    int page = 1,
    int pageSize = defaultPageSize,
  }) async {
    // Verify authentication
    final userId = await _getAuthenticatedUserId(session);
    if (userId == null) {
      return {'success': false, 'error': 'Authentication required', 'statusCode': 401};
    }

    try {
      // Build where clause
      final whereClause = JournalEntry.t.userId.equals(userId) &
          JournalEntry.t.restaurantId.equals(restaurantId);

      // Get total count and aggregate stats
      final entries = await JournalEntry.db.find(
        session,
        where: (t) => whereClause,
        orderBy: (t) => t.visitedAt,
        orderDescending: true,
      );

      final totalCount = entries.length;
      final averageRating = entries.isEmpty
          ? 0.0
          : entries.map((e) => e.rating).reduce((a, b) => a + b) / entries.length;

      // Paginate
      final startIndex = (page - 1) * pageSize;
      final endIndex = (startIndex + pageSize).clamp(0, totalCount);
      final paginatedEntries = entries.sublist(startIndex, endIndex);

      // Get restaurant details
      final restaurant = await Restaurant.db.findById(session, restaurantId);

      // Enrich entries
      final entriesWithDetails = await Future.wait(
        paginatedEntries.map((entry) => _enrichEntry(session, entry)),
      );

      return {
        'success': true,
        'data': {
          'restaurant': restaurant != null
              ? {
                  'id': restaurant.id,
                  'name': restaurant.name,
                  'address': restaurant.address,
                }
              : null,
          'stats': {
            'visitCount': totalCount,
            'averageRating': averageRating,
          },
          'entries': entriesWithDetails,
          'page': page,
          'pageSize': pageSize,
          'hasMore': endIndex < totalCount,
        },
        'statusCode': 200,
      };
    } catch (e) {
      session.log('Error fetching restaurant entries: $e', level: LogLevel.error);
      return {'success': false, 'error': 'Failed to fetch entries', 'statusCode': 500};
    }
  }

  /// Get entries linked to a specific tour.
  ///
  /// GET /journal-entries/by-tour/{tourId}
  Future<Map<String, dynamic>> getEntriesByTour(
    Session session, {
    required int tourId,
  }) async {
    // Verify authentication
    final userId = await _getAuthenticatedUserId(session);
    if (userId == null) {
      return {'success': false, 'error': 'Authentication required', 'statusCode': 401};
    }

    try {
      final entries = await JournalEntry.db.find(
        session,
        where: (t) =>
            t.userId.equals(userId) & t.tourId.equals(tourId),
        orderBy: (t) => t.tourStopId,
      );

      // Group by tour stop
      final groupedEntries = <int, List<Map<String, dynamic>>>{};
      for (final entry in entries) {
        final stopId = entry.tourStopId ?? 0;
        final enriched = await _enrichEntry(session, entry);
        groupedEntries.putIfAbsent(stopId, () => []).add(enriched);
      }

      return {
        'success': true,
        'data': {
          'tourId': tourId,
          'entriesByStop': groupedEntries,
          'totalEntries': entries.length,
        },
        'statusCode': 200,
      };
    } catch (e) {
      session.log('Error fetching tour entries: $e', level: LogLevel.error);
      return {'success': false, 'error': 'Failed to fetch entries', 'statusCode': 500};
    }
  }

  /// Get all restaurants the user has visited.
  ///
  /// GET /restaurants/visited
  Future<Map<String, dynamic>> getVisitedRestaurants(
    Session session, {
    String sortBy = 'lastVisit',
    String sortOrder = 'desc',
  }) async {
    // Verify authentication
    final userId = await _getAuthenticatedUserId(session);
    if (userId == null) {
      return {'success': false, 'error': 'Authentication required', 'statusCode': 401};
    }

    try {
      // Get all entries for the user
      final entries = await JournalEntry.db.find(
        session,
        where: (t) => t.userId.equals(userId),
      );

      // Group by restaurant
      final restaurantStats = <int, List<JournalEntry>>{};
      for (final entry in entries) {
        restaurantStats.putIfAbsent(entry.restaurantId, () => []).add(entry);
      }

      // Build summaries
      final summaries = <RestaurantVisitSummary>[];
      for (final restaurantId in restaurantStats.keys) {
        final restaurantEntries = restaurantStats[restaurantId]!;
        final restaurant = await Restaurant.db.findById(session, restaurantId);

        if (restaurant == null) continue;

        // Get thumbnail from most recent entry
        final mostRecent = restaurantEntries.reduce(
          (a, b) => a.visitedAt.isAfter(b.visitedAt) ? a : b,
        );
        final photos = await JournalPhoto.db.find(
          session,
          where: (t) => t.journalEntryId.equals(mostRecent.id!),
          limit: 1,
        );

        summaries.add(RestaurantVisitSummary(
          restaurantId: restaurantId,
          restaurantName: restaurant.name,
          restaurantAddress: restaurant.address,
          visitCount: restaurantEntries.length,
          averageRating: restaurantEntries.map((e) => e.rating).reduce((a, b) => a + b) /
              restaurantEntries.length,
          lastVisitDate: mostRecent.visitedAt,
          thumbnailUrl: photos.isNotEmpty ? photos.first.thumbnailUrl : null,
        ));
      }

      // Sort summaries
      summaries.sort((a, b) {
        int comparison;
        switch (sortBy) {
          case 'visitCount':
            comparison = a.visitCount.compareTo(b.visitCount);
            break;
          case 'rating':
            comparison = a.averageRating.compareTo(b.averageRating);
            break;
          case 'lastVisit':
          default:
            comparison = a.lastVisitDate.compareTo(b.lastVisitDate);
        }
        return sortOrder == 'desc' ? -comparison : comparison;
      });

      return {
        'success': true,
        'data': {
          'restaurants': summaries.map((s) => s.toJson()).toList(),
          'totalCount': summaries.length,
        },
        'statusCode': 200,
      };
    } catch (e) {
      session.log('Error fetching visited restaurants: $e', level: LogLevel.error);
      return {'success': false, 'error': 'Failed to fetch restaurants', 'statusCode': 500};
    }
  }

  /// Enrich a journal entry with restaurant and photo data.
  Future<Map<String, dynamic>> _enrichEntry(
    Session session,
    JournalEntry entry, {
    bool includeFullPhotos = false,
  }) async {
    final restaurant = await Restaurant.db.findById(session, entry.restaurantId);
    final photos = await JournalPhoto.db.find(
      session,
      where: (t) => t.journalEntryId.equals(entry.id!),
      orderBy: (t) => t.displayOrder,
    );

    return _entryToJson(
      entry,
      restaurant: restaurant,
      photos: photos,
      includeFullPhotos: includeFullPhotos,
    );
  }

  /// Convert a journal entry to JSON with optional related data.
  Map<String, dynamic> _entryToJson(
    JournalEntry entry, {
    Restaurant? restaurant,
    List<JournalPhoto>? photos,
    bool includeFullPhotos = false,
  }) {
    return {
      'id': entry.id,
      'userId': entry.userId,
      'restaurantId': entry.restaurantId,
      'tourId': entry.tourId,
      'tourStopId': entry.tourStopId,
      'rating': entry.rating,
      'notes': entry.notes,
      'visitedAt': entry.visitedAt.toIso8601String(),
      'createdAt': entry.createdAt.toIso8601String(),
      'updatedAt': entry.updatedAt.toIso8601String(),
      if (restaurant != null)
        'restaurant': {
          'id': restaurant.id,
          'name': restaurant.name,
          'address': restaurant.address,
        },
      if (photos != null)
        'photos': photos
            .map((p) => {
                  'id': p.id,
                  'thumbnailUrl': p.thumbnailUrl,
                  if (includeFullPhotos) 'originalUrl': p.originalUrl,
                  'displayOrder': p.displayOrder,
                })
            .toList(),
      'hasTourAssociation': entry.tourId != null,
    };
  }

  /// Get authenticated user ID from session.
  Future<String?> _getAuthenticatedUserId(Session session) async {
    final authenticated = await session.authenticated;
    return authenticated?.userIdentifier.toString();
  }

  /// Get or create the R2 service instance.
  Future<R2Service> _getR2Service(Session session) async {
    final accessKeyId = session.serverpod.getPassword('R2_ACCESS_KEY_ID') ?? '';
    final secretAccessKey = session.serverpod.getPassword('R2_SECRET_ACCESS_KEY') ?? '';
    final bucketName = session.serverpod.getPassword('R2_BUCKET_NAME') ?? 'food-butler-photos';
    final endpoint = session.serverpod.getPassword('R2_ENDPOINT') ?? '';
    final publicUrl = session.serverpod.getPassword('R2_PUBLIC_URL') ?? endpoint;

    return R2Service(
      accessKeyId: accessKeyId,
      secretAccessKey: secretAccessKey,
      bucketName: bucketName,
      endpoint: endpoint,
      publicUrl: publicUrl,
      session: session,
    );
  }

  /// Extract object key from a public URL.
  String? _extractObjectKey(String url) {
    try {
      final uri = Uri.parse(url);
      final path = uri.path;
      if (path.startsWith('/')) {
        return path.substring(1);
      }
      return path;
    } catch (e) {
      return null;
    }
  }
}
