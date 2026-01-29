import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../narratives/prompt_builders.dart';
import 'groq_client.dart';

/// User preferences for narrative personalization.
class UserPreferences {
  final String? userId;
  final List<String> cuisinePreferences;
  final List<String> dietaryRestrictions;
  final List<String> visitHistory;

  UserPreferences({
    this.userId,
    this.cuisinePreferences = const [],
    this.dietaryRestrictions = const [],
    this.visitHistory = const [],
  });

  /// Creates anonymous user preferences.
  factory UserPreferences.anonymous() => UserPreferences();

  bool get isAuthenticated => userId != null;
}

/// Tour data input for narrative generation.
class TourData {
  final int tourId;
  final String neighborhood;
  final String transportMode;
  final String timeOfDay;
  final List<TourStopData> stops;
  final List<RouteLegData> routeLegs;

  TourData({
    required this.tourId,
    required this.neighborhood,
    required this.transportMode,
    required this.timeOfDay,
    required this.stops,
    required this.routeLegs,
  });
}

/// Individual stop data for narrative generation.
class TourStopData {
  final String name;
  final String cuisineType;
  final List<String> signatureDishes;
  final List<String> awards;
  final String neighborhood;

  TourStopData({
    required this.name,
    required this.cuisineType,
    required this.signatureDishes,
    required this.awards,
    required this.neighborhood,
  });
}

/// Route leg data for transitions.
class RouteLegData {
  final int durationMinutes;
  final String? distanceDescription;

  RouteLegData({
    required this.durationMinutes,
    this.distanceDescription,
  });
}

/// Service for generating and caching tour narratives.
class NarrativeService {
  static const Duration _cacheTtl = Duration(days: 30);
  static const int _maxRegenerationsPerDay = 3;

  final GroqClient _groqClient;
  final Session _session;

  NarrativeService({
    required GroqClient groqClient,
    required Session session,
  })  : _groqClient = groqClient,
        _session = session;

  /// Generate narratives for a complete tour.
  ///
  /// Checks cache first for each narrative type. Generates fresh content
  /// for any cache misses and stores them with 30-day TTL.
  Future<NarrativeResponse> generateTourNarratives({
    required TourData tourData,
    UserPreferences? userPreferences,
    bool regenerate = false,
  }) async {
    final prefs = userPreferences ?? UserPreferences.anonymous();
    final userId = prefs.userId ?? 'anonymous';

    // If regenerating, invalidate all existing cache entries first
    if (regenerate) {
      await _invalidateTourCache(tourData.tourId, userId);
    }

    final now = DateTime.now();
    var allCached = true;
    var fallbackUsed = false;
    final failedTypes = <String>[];

    // Generate intro
    String intro;
    final cachedIntro = await _getCachedNarrative(
      tourId: tourData.tourId,
      userId: userId,
      narrativeType: 'intro',
      stopIndex: null,
    );

    if (cachedIntro != null && !regenerate) {
      intro = cachedIntro;
    } else {
      allCached = false;
      try {
        intro = await _generateIntro(tourData, prefs);
        await _cacheNarrative(
          tourId: tourData.tourId,
          userId: userId,
          narrativeType: 'intro',
          stopIndex: null,
          content: intro,
        );
      } catch (e) {
        _session.log(
          'Failed to generate intro for tour ${tourData.tourId}: $e',
          level: LogLevel.error,
        );
        intro = _getFallbackIntro(tourData);
        fallbackUsed = true;
        failedTypes.add('intro');
      }
    }

    // Generate descriptions for each stop
    final descriptions = <String>[];
    for (var i = 0; i < tourData.stops.length; i++) {
      final cachedDesc = await _getCachedNarrative(
        tourId: tourData.tourId,
        userId: userId,
        narrativeType: 'description',
        stopIndex: i,
      );

      if (cachedDesc != null && !regenerate) {
        descriptions.add(cachedDesc);
      } else {
        allCached = false;
        try {
          final desc = await _generateDescription(tourData, i, prefs);
          descriptions.add(desc);
          await _cacheNarrative(
            tourId: tourData.tourId,
            userId: userId,
            narrativeType: 'description',
            stopIndex: i,
            content: desc,
          );
        } catch (e) {
          _session.log(
            'Failed to generate description for stop $i of tour ${tourData.tourId}: $e',
            level: LogLevel.error,
          );
          descriptions.add(_getFallbackDescription(tourData.stops[i]));
          fallbackUsed = true;
          failedTypes.add('description_$i');
        }
      }
    }

    // Generate transitions between stops
    final transitions = <String>[];
    for (var i = 0; i < tourData.stops.length - 1; i++) {
      final cachedTrans = await _getCachedNarrative(
        tourId: tourData.tourId,
        userId: userId,
        narrativeType: 'transition',
        stopIndex: i,
      );

      if (cachedTrans != null && !regenerate) {
        transitions.add(cachedTrans);
      } else {
        allCached = false;
        try {
          final trans = await _generateTransition(tourData, i, prefs);
          transitions.add(trans);
          await _cacheNarrative(
            tourId: tourData.tourId,
            userId: userId,
            narrativeType: 'transition',
            stopIndex: i,
            content: trans,
          );
        } catch (e) {
          _session.log(
            'Failed to generate transition $i for tour ${tourData.tourId}: $e',
            level: LogLevel.error,
          );
          transitions.add(_getFallbackTransition(tourData, i));
          fallbackUsed = true;
          failedTypes.add('transition_$i');
        }
      }
    }

    // Calculate TTL remaining
    final ttlRemaining = allCached
        ? (_cacheTtl.inSeconds -
            DateTime.now().difference(now).inSeconds)
        : _cacheTtl.inSeconds;

    return NarrativeResponse(
      intro: intro,
      descriptions: descriptions,
      transitions: transitions,
      generatedAt: now,
      cached: allCached,
      ttlRemainingSeconds: ttlRemaining,
      fallbackUsed: fallbackUsed,
      failedTypes: failedTypes,
    );
  }

  /// Check if regeneration is allowed (rate limit check).
  Future<bool> canRegenerate(int tourId, String userId) async {
    final count = await _getRegenerateCount(tourId, userId);
    return count < _maxRegenerationsPerDay;
  }

  /// Increment regenerate count for rate limiting.
  Future<void> incrementRegenerateCount(int tourId, String userId) async {
    final today = DateTime.now();
    final truncatedDate = DateTime(today.year, today.month, today.day);

    try {
      final existing = await NarrativeRegenerateLimit.db.findFirstRow(
        _session,
        where: (t) =>
            t.tourId.equals(tourId) &
            t.userId.equals(userId) &
            t.limitDate.equals(truncatedDate),
      );

      if (existing != null) {
        await NarrativeRegenerateLimit.db.updateRow(
          _session,
          existing.copyWith(
            attemptCount: existing.attemptCount + 1,
            updatedAt: DateTime.now(),
          ),
        );
      } else {
        await NarrativeRegenerateLimit.db.insertRow(
          _session,
          NarrativeRegenerateLimit(
            tourId: tourId,
            userId: userId,
            limitDate: truncatedDate,
            attemptCount: 1,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
      }
    } catch (e) {
      _session.log(
        'Error updating regenerate count: $e',
        level: LogLevel.warning,
      );
    }
  }

  /// Get current regenerate count for a tour/user.
  Future<int> _getRegenerateCount(int tourId, String userId) async {
    final today = DateTime.now();
    final truncatedDate = DateTime(today.year, today.month, today.day);

    try {
      final record = await NarrativeRegenerateLimit.db.findFirstRow(
        _session,
        where: (t) =>
            t.tourId.equals(tourId) &
            t.userId.equals(userId) &
            t.limitDate.equals(truncatedDate),
      );
      return record?.attemptCount ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Generate tour introduction narrative.
  Future<String> _generateIntro(
    TourData tourData,
    UserPreferences prefs,
  ) async {
    final cuisineTypes = tourData.stops.map((s) => s.cuisineType).toSet().toList();

    final input = TourIntroInput(
      neighborhood: tourData.neighborhood,
      cuisineTypes: cuisineTypes,
      restaurantCount: tourData.stops.length,
      timeOfDay: tourData.timeOfDay,
      transportMode: tourData.transportMode,
      userCuisinePreferences:
          prefs.isAuthenticated ? prefs.cuisinePreferences : null,
    );

    final prompt = TourIntroPromptBuilder.buildPrompt(input);
    final response = await _groqClient.chatCompletion(
      systemPrompt: narrativeSystemPrompt,
      userPrompt: prompt,
      tourId: tourData.tourId,
      narrativeType: 'intro',
    );

    return response.content;
  }

  /// Generate restaurant description narrative.
  Future<String> _generateDescription(
    TourData tourData,
    int stopIndex,
    UserPreferences prefs,
  ) async {
    final stop = tourData.stops[stopIndex];

    String? safeDish;
    if (prefs.isAuthenticated && prefs.dietaryRestrictions.isNotEmpty) {
      // Simple logic to find a potentially safe dish
      // In production, this would use more sophisticated matching
      safeDish = stop.signatureDishes.isNotEmpty
          ? stop.signatureDishes.first
          : null;
    }

    final input = RestaurantDescriptionInput(
      restaurantName: stop.name,
      cuisineType: stop.cuisineType,
      signatureDishes: stop.signatureDishes,
      awards: stop.awards,
      neighborhood: stop.neighborhood,
      stopNumber: stopIndex + 1,
      totalStops: tourData.stops.length,
      userDietaryRestrictions:
          prefs.isAuthenticated ? prefs.dietaryRestrictions : null,
      safeDishRecommendation: safeDish,
    );

    final prompt = RestaurantDescriptionPromptBuilder.buildPrompt(input);
    final response = await _groqClient.chatCompletion(
      systemPrompt: narrativeSystemPrompt,
      userPrompt: prompt,
      tourId: tourData.tourId,
      narrativeType: 'description',
    );

    return response.content;
  }

  /// Generate transition narrative.
  Future<String> _generateTransition(
    TourData tourData,
    int transitionIndex,
    UserPreferences prefs,
  ) async {
    final fromStop = tourData.stops[transitionIndex];
    final toStop = tourData.stops[transitionIndex + 1];
    final leg = tourData.routeLegs[transitionIndex];

    final input = TransitionInput(
      fromRestaurant: fromStop.name,
      fromCuisine: fromStop.cuisineType,
      toRestaurant: toStop.name,
      toCuisine: toStop.cuisineType,
      travelMode: tourData.transportMode,
      durationMinutes: leg.durationMinutes,
      distanceDescription: leg.distanceDescription,
    );

    final prompt = TransitionPromptBuilder.buildPrompt(input);
    final response = await _groqClient.chatCompletion(
      systemPrompt: narrativeSystemPrompt,
      userPrompt: prompt,
      tourId: tourData.tourId,
      narrativeType: 'transition',
    );

    return response.content;
  }

  /// Get cached narrative from database.
  Future<String?> _getCachedNarrative({
    required int tourId,
    required String userId,
    required String narrativeType,
    required int? stopIndex,
  }) async {
    try {
      final cache = await NarrativeCache.db.findFirstRow(
        _session,
        where: (t) {
          var condition = t.tourId.equals(tourId) &
              t.narrativeType.equals(narrativeType) &
              (t.expiresAt > DateTime.now());

          // Handle nullable userId and stopIndex comparisons
          if (userId == 'anonymous') {
            condition = condition & t.userId.equals(null);
          } else {
            condition = condition & t.userId.equals(userId);
          }

          if (stopIndex == null) {
            condition = condition & t.stopIndex.equals(null);
          } else {
            condition = condition & t.stopIndex.equals(stopIndex);
          }

          return condition;
        },
      );

      if (cache != null) {
        // Increment cache hit count
        await NarrativeCache.db.updateRow(
          _session,
          cache.copyWith(
            cacheHitCount: cache.cacheHitCount + 1,
            updatedAt: DateTime.now(),
          ),
        );
        return cache.content;
      }
      return null;
    } catch (e) {
      _session.log(
        'Cache read error: $e',
        level: LogLevel.warning,
      );
      return null;
    }
  }

  /// Cache a generated narrative.
  Future<void> _cacheNarrative({
    required int tourId,
    required String userId,
    required String narrativeType,
    required int? stopIndex,
    required String content,
  }) async {
    try {
      final now = DateTime.now();
      await NarrativeCache.db.insertRow(
        _session,
        NarrativeCache(
          tourId: tourId,
          userId: userId == 'anonymous' ? null : userId,
          narrativeType: narrativeType,
          stopIndex: stopIndex,
          content: content,
          generatedAt: now,
          expiresAt: now.add(_cacheTtl),
          cacheHitCount: 0,
          createdAt: now,
          updatedAt: now,
        ),
      );
    } catch (e) {
      _session.log(
        'Cache write error: $e',
        level: LogLevel.warning,
      );
    }
  }

  /// Invalidate all cache entries for a tour/user combination.
  Future<void> _invalidateTourCache(int tourId, String userId) async {
    try {
      if (userId == 'anonymous') {
        await NarrativeCache.db.deleteWhere(
          _session,
          where: (t) => t.tourId.equals(tourId) & t.userId.equals(null),
        );
      } else {
        await NarrativeCache.db.deleteWhere(
          _session,
          where: (t) => t.tourId.equals(tourId) & t.userId.equals(userId),
        );
      }
    } catch (e) {
      _session.log(
        'Cache invalidation error: $e',
        level: LogLevel.warning,
      );
    }
  }

  /// Get fallback intro text.
  String _getFallbackIntro(TourData tourData) {
    return 'Welcome to your culinary tour through ${tourData.neighborhood}. '
        'Over the next ${tourData.stops.length} stops, you will discover '
        'the diverse flavors that define this neighborhood. '
        'Each restaurant has been selected to showcase the best of local cuisine.';
  }

  /// Get fallback description text.
  String _getFallbackDescription(TourStopData stop) {
    final awardsNote = stop.awards.isNotEmpty
        ? ' This establishment has been recognized with ${stop.awards.first}.'
        : '';
    return '${stop.name} offers an authentic ${stop.cuisineType} dining experience '
        'in the heart of ${stop.neighborhood}.$awardsNote '
        'Their menu features carefully crafted dishes that highlight '
        'traditional flavors with contemporary presentation.';
  }

  /// Get fallback transition text.
  String _getFallbackTransition(TourData tourData, int transitionIndex) {
    final leg = tourData.routeLegs[transitionIndex];
    final nextStop = tourData.stops[transitionIndex + 1];
    return 'A ${leg.durationMinutes}-minute ${tourData.transportMode.toLowerCase()} '
        'journey brings us to ${nextStop.name}, our next culinary destination.';
  }
}
