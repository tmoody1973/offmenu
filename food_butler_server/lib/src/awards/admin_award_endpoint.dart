import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/fuzzy_match_service.dart';
import 'award_csv_parser.dart';

/// Admin API endpoint for award management.
///
/// Provides import, review, and management capabilities for award data.
/// All endpoints require admin authorization.
class AdminAwardEndpoint extends Endpoint {
  final FuzzyMatchService _matchService = FuzzyMatchService();

  /// Import awards from CSV data.
  ///
  /// Parses the CSV content, matches awards to restaurants, and creates
  /// the appropriate database records.
  Future<ImportResult> importAwards(
    Session session, {
    required String csvContent,
    required String awardType,
    required String fileName,
  }) async {
    // Verify admin authorization
    final userId = await _requireAdminAuth(session);

    final parser = AwardCsvParser();
    List<ParsedAwardRecord> parsedRecords;

    // Parse the CSV based on award type
    if (awardType == 'michelin') {
      parsedRecords = parser.parseMichelinCsv(csvContent);
    } else if (awardType == 'james_beard') {
      parsedRecords = parser.parseJamesBeardCsv(csvContent);
    } else {
      throw ArgumentError('Invalid award type: $awardType');
    }

    // Get all restaurants for matching
    final restaurants = await Restaurant.db.find(session);

    var recordsImported = 0;
    var recordsMatched = 0;
    var recordsPendingReview = 0;

    for (final record in parsedRecords) {
      if (awardType == 'michelin') {
        final award = await _createMichelinAward(session, record);
        if (award != null && award.id != null) {
          recordsImported++;

          // Try to match the award to a restaurant
          final matchResult = _matchService.findBestMichelinMatch(
            award: award,
            restaurants: restaurants,
          );

          if (matchResult != null && matchResult.restaurant.id != null) {
            final link = RestaurantAwardLink(
              restaurantId: matchResult.restaurant.id!,
              awardType: AwardType.michelin,
              awardId: award.id!,
              matchConfidenceScore: matchResult.confidence,
              matchStatus: matchResult.status ?? MatchStatus.pendingReview,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
            await RestaurantAwardLink.db.insertRow(session, link);

            if (matchResult.status == MatchStatus.autoMatched) {
              recordsMatched++;
            } else if (matchResult.status == MatchStatus.pendingReview) {
              recordsPendingReview++;
            }
          }
        }
      } else {
        final award = await _createJamesBeardAward(session, record);
        if (award != null && award.id != null) {
          recordsImported++;

          // Try to match the award to a restaurant
          final matchResult = _matchService.findBestJamesBeardMatch(
            award: award,
            restaurants: restaurants,
          );

          if (matchResult != null && matchResult.restaurant.id != null) {
            final link = RestaurantAwardLink(
              restaurantId: matchResult.restaurant.id!,
              awardType: AwardType.jamesBeard,
              awardId: award.id!,
              matchConfidenceScore: matchResult.confidence,
              matchStatus: matchResult.status ?? MatchStatus.pendingReview,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
            await RestaurantAwardLink.db.insertRow(session, link);

            if (matchResult.status == MatchStatus.autoMatched) {
              recordsMatched++;
            } else if (matchResult.status == MatchStatus.pendingReview) {
              recordsPendingReview++;
            }
          }
        }
      }
    }

    // Create import log entry
    final importLog = AwardImportLog(
      importType: awardType == 'michelin' ? AwardType.michelin : AwardType.jamesBeard,
      fileName: fileName,
      recordsImported: recordsImported,
      recordsMatched: recordsMatched,
      recordsPendingReview: recordsPendingReview,
      importedByUserId: userId,
      createdAt: DateTime.now(),
    );
    await AwardImportLog.db.insertRow(session, importLog);

    return ImportResult(
      recordsImported: recordsImported,
      recordsMatched: recordsMatched,
      recordsPendingReview: recordsPendingReview,
    );
  }

  /// Preview import results without committing to database.
  Future<ImportPreviewResult> previewImport(
    Session session, {
    required String csvContent,
    required String awardType,
  }) async {
    await _requireAdminAuth(session);

    final parser = AwardCsvParser();
    List<ParsedAwardRecord> parsedRecords;

    if (awardType == 'michelin') {
      parsedRecords = parser.parseMichelinCsv(csvContent);
    } else if (awardType == 'james_beard') {
      parsedRecords = parser.parseJamesBeardCsv(csvContent);
    } else {
      throw ArgumentError('Invalid award type: $awardType');
    }

    final restaurants = await Restaurant.db.find(session);
    final previewItems = <ImportPreviewItem>[];

    for (final record in parsedRecords) {
      double? confidence;
      String? matchedRestaurantName;
      String status = 'no_match';

      if (awardType == 'michelin') {
        final tempAward = MichelinAward(
          restaurantName: record.name,
          city: record.city,
          designation: _parseMichelinDesignation(record.designation ?? ''),
          awardYear: record.year,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final matchResult = _matchService.findBestMichelinMatch(
          award: tempAward,
          restaurants: restaurants,
        );

        if (matchResult != null) {
          confidence = matchResult.confidence;
          matchedRestaurantName = matchResult.restaurant.name;
          status = matchResult.status == MatchStatus.autoMatched
              ? 'auto_match'
              : 'pending_review';
        }
      } else {
        final tempAward = JamesBeardAward(
          name: record.name,
          city: record.city,
          category: record.category ?? '',
          distinctionLevel: _parseJamesBeardDistinction(record.distinction ?? ''),
          awardYear: record.year,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final matchResult = _matchService.findBestJamesBeardMatch(
          award: tempAward,
          restaurants: restaurants,
        );

        if (matchResult != null) {
          confidence = matchResult.confidence;
          matchedRestaurantName = matchResult.restaurant.name;
          status = matchResult.status == MatchStatus.autoMatched
              ? 'auto_match'
              : 'pending_review';
        }
      }

      previewItems.add(ImportPreviewItem(
        recordName: record.name,
        recordCity: record.city,
        recordYear: record.year,
        matchedRestaurantName: matchedRestaurantName,
        confidence: confidence,
        status: status,
      ));
    }

    return ImportPreviewResult(
      totalRecords: parsedRecords.length,
      items: previewItems,
    );
  }

  /// Get the review queue of pending matches.
  Future<List<ReviewQueueItem>> getReviewQueue(
    Session session, {
    int limit = 50,
    int offset = 0,
  }) async {
    await _requireAdminAuth(session);

    final pendingLinks = await RestaurantAwardLink.db.find(
      session,
      where: (t) => t.matchStatus.equals(MatchStatus.pendingReview),
      limit: limit,
      offset: offset,
      orderBy: (t) => t.matchConfidenceScore,
      orderDescending: false, // Show lowest confidence first
    );

    final items = <ReviewQueueItem>[];

    for (final link in pendingLinks) {
      final restaurant = await Restaurant.db.findById(session, link.restaurantId);
      String awardName = '';
      String awardDetails = '';

      if (link.awardType == AwardType.michelin) {
        final award = await MichelinAward.db.findById(session, link.awardId);
        if (award != null) {
          awardName = award.restaurantName;
          awardDetails = '${award.designation.name} (${award.awardYear})';
        }
      } else {
        final award = await JamesBeardAward.db.findById(session, link.awardId);
        if (award != null) {
          awardName = award.name;
          awardDetails = '${award.category} - ${award.distinctionLevel.name} (${award.awardYear})';
        }
      }

      items.add(ReviewQueueItem(
        linkId: link.id ?? 0,
        restaurantName: restaurant?.name ?? 'Unknown',
        restaurantAddress: restaurant?.address ?? '',
        awardName: awardName,
        awardDetails: awardDetails,
        awardType: link.awardType.name,
        confidenceScore: link.matchConfidenceScore,
      ));
    }

    return items;
  }

  /// Confirm a pending match.
  Future<bool> confirmMatch(Session session, int linkId) async {
    final userId = await _requireAdminAuth(session);

    final link = await RestaurantAwardLink.db.findById(session, linkId);
    if (link == null) {
      throw ArgumentError('Link not found: $linkId');
    }

    link.matchStatus = MatchStatus.manualConfirmed;
    link.matchedByUserId = userId;
    link.updatedAt = DateTime.now();

    await RestaurantAwardLink.db.updateRow(session, link);
    return true;
  }

  /// Reject a pending match.
  Future<bool> rejectMatch(Session session, int linkId) async {
    final userId = await _requireAdminAuth(session);

    final link = await RestaurantAwardLink.db.findById(session, linkId);
    if (link == null) {
      throw ArgumentError('Link not found: $linkId');
    }

    link.matchStatus = MatchStatus.manualRejected;
    link.matchedByUserId = userId;
    link.updatedAt = DateTime.now();

    await RestaurantAwardLink.db.updateRow(session, link);
    return true;
  }

  /// Manually create a new award-restaurant link.
  Future<RestaurantAwardLink> createLink(
    Session session, {
    required int restaurantId,
    required String awardType,
    required int awardId,
  }) async {
    final userId = await _requireAdminAuth(session);

    final type = awardType == 'michelin' ? AwardType.michelin : AwardType.jamesBeard;

    final link = RestaurantAwardLink(
      restaurantId: restaurantId,
      awardType: type,
      awardId: awardId,
      matchConfidenceScore: 1.0, // Manual links are assumed to be 100% confident
      matchStatus: MatchStatus.manualConfirmed,
      matchedByUserId: userId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return await RestaurantAwardLink.db.insertRow(session, link);
  }

  /// Delete an award-restaurant link.
  Future<bool> deleteLink(Session session, int linkId) async {
    await _requireAdminAuth(session);

    final link = await RestaurantAwardLink.db.findById(session, linkId);
    if (link == null) {
      throw ArgumentError('Link not found: $linkId');
    }

    await RestaurantAwardLink.db.deleteRow(session, link);
    return true;
  }

  /// Get import audit logs.
  Future<List<AwardImportLog>> getImportLogs(
    Session session, {
    int limit = 50,
    int offset = 0,
  }) async {
    await _requireAdminAuth(session);

    return await AwardImportLog.db.find(
      session,
      limit: limit,
      offset: offset,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Require admin authentication and return user ID.
  Future<int> _requireAdminAuth(Session session) async {
    // In a real implementation, this would check the session for admin privileges
    // For now, we return a placeholder user ID
    // TODO: Implement proper admin authentication check
    return 1;
  }

  /// Create a Michelin award from a parsed record.
  Future<MichelinAward?> _createMichelinAward(
    Session session,
    ParsedAwardRecord record,
  ) async {
    try {
      final award = MichelinAward(
        restaurantName: record.name,
        city: record.city,
        address: record.address,
        latitude: record.latitude,
        longitude: record.longitude,
        designation: _parseMichelinDesignation(record.designation ?? ''),
        awardYear: record.year,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      return await MichelinAward.db.insertRow(session, award);
    } catch (e) {
      session.log('Error creating Michelin award: $e', level: LogLevel.warning);
      return null;
    }
  }

  /// Create a James Beard award from a parsed record.
  Future<JamesBeardAward?> _createJamesBeardAward(
    Session session,
    ParsedAwardRecord record,
  ) async {
    try {
      final award = JamesBeardAward(
        name: record.name,
        city: record.city,
        category: record.category ?? 'Unknown',
        distinctionLevel: _parseJamesBeardDistinction(record.distinction ?? ''),
        awardYear: record.year,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      return await JamesBeardAward.db.insertRow(session, award);
    } catch (e) {
      session.log('Error creating James Beard award: $e', level: LogLevel.warning);
      return null;
    }
  }

  /// Parse Michelin designation from string.
  MichelinDesignation _parseMichelinDesignation(String value) {
    switch (value.toLowerCase()) {
      case 'three_star':
      case 'threestar':
      case '3':
      case '3 star':
      case '3-star':
        return MichelinDesignation.threeStar;
      case 'two_star':
      case 'twostar':
      case '2':
      case '2 star':
      case '2-star':
        return MichelinDesignation.twoStar;
      case 'one_star':
      case 'onestar':
      case '1':
      case '1 star':
      case '1-star':
        return MichelinDesignation.oneStar;
      case 'bib_gourmand':
      case 'bibgourmand':
      case 'bib':
        return MichelinDesignation.bibGourmand;
      default:
        return MichelinDesignation.oneStar;
    }
  }

  /// Parse James Beard distinction from string.
  JamesBeardDistinction _parseJamesBeardDistinction(String value) {
    switch (value.toLowerCase()) {
      case 'winner':
        return JamesBeardDistinction.winner;
      case 'nominee':
      case 'finalist':
        return JamesBeardDistinction.nominee;
      case 'semifinalist':
      case 'semi-finalist':
        return JamesBeardDistinction.semifinalist;
      default:
        return JamesBeardDistinction.semifinalist;
    }
  }
}
