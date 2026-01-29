import 'dart:convert';
import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'award_matching_service.dart';
import 'google_places_service.dart';
import 'mapbox_service.dart';
import 'perplexity_service.dart';
import 'tour_scoring_service.dart';

/// A candidate restaurant with scoring metadata.
class _RestaurantCandidate {
  final Restaurant restaurant;
  final List<Award> awards;
  final DishWeight dishWeight;
  final double awardBoost;

  // Narrative fields from curated tour
  final String? story;
  final String? signatureDish;
  final String? dishStory;
  final String? insiderTip;
  final String? transitionToNext;
  final int? minutesToSpend;

  _RestaurantCandidate({
    required this.restaurant,
    required this.awards,
    required this.dishWeight,
    required this.awardBoost,
    this.story,
    this.signatureDish,
    this.dishStory,
    this.insiderTip,
    this.transitionToNext,
    this.minutesToSpend,
  });
}

/// Service for generating optimized food tours.
class TourGenerationService {
  // Search radius defaults
  static const int _walkingRadiusMeters = 2000; // 2km for walking
  static const int _drivingRadiusMeters = 10000; // 10km for driving

  // Candidate pool multiplier (3x requested stops)
  static const int _candidatePoolMultiplier = 3;

  // Maximum permutations to evaluate to avoid exponential complexity
  static const int _maxPermutations = 100;

  final GooglePlacesService _googlePlacesService;
  final AwardMatchingService _awardMatchingService;
  final MapboxService _mapboxService;
  final PerplexityService? _perplexityService;
  final TourScoringService _scoringService;
  final Session _session;

  // Stored curated tour for narrative data
  CuratedFoodTour? _curatedTour;

  TourGenerationService({
    required GooglePlacesService googlePlacesService,
    required AwardMatchingService awardMatchingService,
    required MapboxService mapboxService,
    PerplexityService? perplexityService,
    required Session session,
  })  : _googlePlacesService = googlePlacesService,
        _awardMatchingService = awardMatchingService,
        _mapboxService = mapboxService,
        _perplexityService = perplexityService,
        _scoringService = TourScoringService(),
        _session = session;

  /// Generate an optimized food tour based on the request parameters.
  Future<TourResult> generateTour(TourRequest request) async {
    final stopwatch = Stopwatch()..start();

    try {
      // Step 1: Validate request
      final validationError = _validateRequest(request);
      if (validationError != null) {
        return _createErrorResult(request, validationError);
      }

      // Step 2: Collect restaurant candidates
      final candidates = await _collectCandidates(request);

      if (candidates.isEmpty) {
        return _createErrorResult(
          request,
          'No restaurants found matching your criteria. Try expanding your search area or relaxing filters.',
        );
      }

      // Step 3: Filter candidates based on request criteria
      final filteredCandidates = _filterCandidates(candidates, request);

      if (filteredCandidates.isEmpty) {
        return _createErrorResult(
          request,
          'No restaurants match your filters. Try removing award-only or expanding cuisine preferences.',
        );
      }

      // Step 4: Check for partial tour scenario
      final isPartial = filteredCandidates.length < request.numStops;
      final actualStops = min(filteredCandidates.length, request.numStops);

      // Step 5: Optimize tour order
      final optimizedStops = await _optimizeTour(
        candidates: filteredCandidates,
        numStops: actualStops,
        startLat: request.startLatitude,
        startLng: request.startLongitude,
        transportMode: request.transportMode,
        startTime: request.startTime,
      );

      // Step 6: Calculate route
      final waypoints = [
        LatLng(latitude: request.startLatitude, longitude: request.startLongitude),
        ...optimizedStops.map((s) => LatLng(
              latitude: s.restaurant.latitude,
              longitude: s.restaurant.longitude,
            )),
      ];

      final routeResult = await _mapboxService.calculateRoute(
        waypoints: waypoints,
        transportMode: request.transportMode,
      );

      // Step 7: Generate alternatives for each stop
      final alternatives = _generateAlternatives(
        selectedStops: optimizedStops,
        allCandidates: filteredCandidates,
      );

      // Step 8: Calculate tour score
      final tourScore = _scoringService.scoreTour(
        stops: optimizedStops,
        routeLegs: routeResult.legs,
        startTime: request.startTime,
        transportMode: request.transportMode,
      );

      // Step 9: Assemble result
      final stopsJson = _serializeStops(optimizedStops, alternatives);
      final routeLegsJson = _serializeRouteLegs(routeResult.legs);

      String? warningMessage;
      if (isPartial) {
        warningMessage = _generatePartialTourWarning(
          requested: request.numStops,
          actual: actualStops,
          request: request,
        );
      } else if (routeResult.warning != null) {
        warningMessage = routeResult.warning;
      }

      stopwatch.stop();
      _session.log(
        'Tour generation completed in ${stopwatch.elapsedMilliseconds}ms',
        level: LogLevel.info,
      );

      // Serialize the curated tour JSON for frontend consumption
      String? curatedTourJson;
      final curatedTour = _curatedTour;
      if (curatedTour != null) {
        curatedTourJson = jsonEncode(curatedTour.toJson());
      }

      return TourResult(
        requestId: request.id ?? 0, // Default to 0 if not persisted
        stopsJson: stopsJson,
        routeLegsJson: routeLegsJson,
        confidenceScore: isPartial
            ? _scoringService.calculatePartialTourConfidence(
                requestedStops: request.numStops,
                actualStops: actualStops,
                baseScore: tourScore,
              )
            : tourScore.confidenceScore,
        routePolyline: routeResult.polyline,
        totalDistanceMeters: routeResult.totalDistanceMeters,
        totalDurationSeconds: routeResult.totalDurationSeconds,
        isPartialTour: isPartial,
        warningMessage: warningMessage,
        // Narrative fields from curated tour
        tourTitle: _curatedTour?.title,
        tourIntroduction: _curatedTour?.introduction,
        tourVibe: _curatedTour?.vibe,
        tourClosing: _curatedTour?.closing,
        curatedTourJson: curatedTourJson,
        createdAt: DateTime.now(),
      );
    } catch (e, stackTrace) {
      _session.log(
        'Tour generation error: $e\n$stackTrace',
        level: LogLevel.error,
      );
      return _createErrorResult(
        request,
        'An error occurred while generating your tour. Please try again.',
      );
    }
  }

  /// Validate the tour request.
  String? _validateRequest(TourRequest request) {
    if (request.numStops < 3 || request.numStops > 6) {
      return 'Number of stops must be between 3 and 6.';
    }

    if (request.startLatitude < -90 || request.startLatitude > 90) {
      return 'Invalid start latitude.';
    }

    if (request.startLongitude < -180 || request.startLongitude > 180) {
      return 'Invalid start longitude.';
    }

    if (request.startTime.isBefore(DateTime.now().subtract(const Duration(minutes: 5)))) {
      return 'Start time cannot be in the past.';
    }

    return null;
  }

  /// Collect restaurant candidates using Perplexity AI + Google Places.
  ///
  /// Flow:
  /// 1. Try createCuratedTour() for documentary-style storytelling (PREFERRED)
  /// 2. Fall back to discoverRestaurants() for simpler recommendations
  /// 3. Use Google Places to enrich with coordinates
  /// 4. Fall back to direct Google Places search if Perplexity unavailable
  Future<List<_RestaurantCandidate>> _collectCandidates(TourRequest request) async {
    final radiusMeters = request.transportMode == TransportMode.walking
        ? _walkingRadiusMeters
        : _drivingRadiusMeters;

    final limit = request.numStops * _candidatePoolMultiplier;
    final candidates = <_RestaurantCandidate>[];

    // Reset curated tour
    _curatedTour = null;

    // Step 1: Try createCuratedTour for full documentary-style experience
    if (_perplexityService != null) {
      _session.log('Creating documentary-style curated tour with Perplexity AI...');

      final curatedCandidates = await _collectFromCuratedTour(
        request: request,
      );

      if (curatedCandidates.isNotEmpty) {
        candidates.addAll(curatedCandidates);
        _session.log('Curated tour created with ${curatedCandidates.length} stops');
      } else {
        // Step 2: Fall back to simpler discovery if curated tour fails
        _session.log('Falling back to restaurant discovery...');
        final perplexityCandidates = await _collectFromPerplexity(
          request: request,
          limit: limit,
        );
        candidates.addAll(perplexityCandidates);
        _session.log('Perplexity found ${perplexityCandidates.length} restaurants');
      }
    }

    // Step 3: If we don't have enough, supplement with Google Places
    if (candidates.length < request.numStops) {
      _session.log('Supplementing with Google Places search...');

      final googleCandidates = await _collectFromGooglePlaces(
        request: request,
        radiusMeters: radiusMeters,
        limit: limit - candidates.length,
        excludeNames: candidates.map((c) => c.restaurant.name.toLowerCase()).toSet(),
      );

      candidates.addAll(googleCandidates);
      _session.log('Google Places added ${googleCandidates.length} more restaurants');
    }

    return candidates;
  }

  /// Collect candidates from a fully curated Perplexity tour with storytelling.
  Future<List<_RestaurantCandidate>> _collectFromCuratedTour({
    required TourRequest request,
  }) async {
    final perplexityService = _perplexityService;
    if (perplexityService == null) return [];

    try {
      // Build location string for Perplexity
      final locationStr = request.startAddress ??
          '${request.startLatitude}, ${request.startLongitude}';

      // Get budget level string
      final budgetLevel = switch (request.budgetTier) {
        BudgetTier.budget => 'budget',
        BudgetTier.moderate => 'moderate',
        BudgetTier.upscale => 'upscale',
        BudgetTier.luxury => 'luxury',
      };

      // Create the curated tour with full storytelling
      final curatedTour = await perplexityService.createCuratedTour(
        location: locationStr,
        numberOfStops: request.numStops,
        cuisinePreferences: request.cuisinePreferences,
        budgetLevel: budgetLevel,
        awardWinningOnly: request.awardOnly,
        specificDish: request.specificDish,
      );

      if (curatedTour == null || curatedTour.stops.isEmpty) {
        _session.log('Curated tour returned no stops');
        return [];
      }

      // Store the curated tour for later use in result assembly
      _curatedTour = curatedTour;
      _session.log('Curated tour: "${curatedTour.title}" with ${curatedTour.stops.length} stops');

      // Enrich each stop with Google Places coordinates
      final candidates = <_RestaurantCandidate>[];

      for (final stop in curatedTour.stops) {
        // Search Google Places for this restaurant
        final searchQuery = '${stop.name} ${stop.neighborhood} near $locationStr';

        final searchResult = await _googlePlacesService.searchByName(
          query: searchQuery,
          latitude: request.startLatitude,
          longitude: request.startLongitude,
          radiusMeters: request.transportMode == TransportMode.walking
              ? _walkingRadiusMeters
              : _drivingRadiusMeters,
        );

        if (searchResult != null) {
          // Enrich restaurant with the curated story
          final enrichedRestaurant = searchResult.copyWith(
            description: stop.story,
          );

          // Match awards
          final awardResult = await _awardMatchingService.matchRestaurantToAwards(enrichedRestaurant);

          // Classify dish weight based on cuisine
          final dishWeight = _scoringService.classifyDishWeight(enrichedRestaurant);

          // Calculate award boost
          final awardBoost = _scoringService.applyAwardBoost(awardResult.awards);

          candidates.add(_RestaurantCandidate(
            restaurant: enrichedRestaurant,
            awards: awardResult.awards,
            dishWeight: dishWeight,
            awardBoost: awardBoost,
            story: stop.story,
            signatureDish: stop.signatureDish,
            dishStory: stop.dishStory,
            insiderTip: stop.insiderTip,
            transitionToNext: stop.transitionToNext,
            minutesToSpend: stop.minutesToSpend,
          ));

          _session.log('Found "${stop.name}" via Google Places: ${enrichedRestaurant.name}');
        } else {
          _session.log('Could not find "${stop.name}" in Google Places', level: LogLevel.warning);
        }
      }

      return candidates;
    } catch (e) {
      _session.log('Error creating curated tour: $e', level: LogLevel.error);
      return [];
    }
  }

  /// Collect candidates from Perplexity AI recommendations.
  Future<List<_RestaurantCandidate>> _collectFromPerplexity({
    required TourRequest request,
    required int limit,
  }) async {
    final perplexityService = _perplexityService;
    if (perplexityService == null) return [];

    try {
      // Build location string for Perplexity
      final locationStr = request.startAddress ??
          '${request.startLatitude}, ${request.startLongitude}';

      // Get budget level string
      final budgetLevel = switch (request.budgetTier) {
        BudgetTier.budget => 'budget',
        BudgetTier.moderate => 'moderate',
        BudgetTier.upscale => 'upscale',
        BudgetTier.luxury => 'luxury',
      };

      // Ask Perplexity for recommendations
      final recommendations = await perplexityService.discoverRestaurants(
        location: locationStr,
        count: limit,
        cuisinePreferences: request.cuisinePreferences,
        budgetLevel: budgetLevel,
        awardWinningOnly: request.awardOnly,
        specificDish: request.specificDish,
      );

      if (recommendations.isEmpty) {
        _session.log('Perplexity returned no recommendations');
        return [];
      }

      // Use Google Places to find each recommended restaurant
      final candidates = <_RestaurantCandidate>[];

      for (final rec in recommendations) {
        // Search Google Places for this specific restaurant
        final searchQuery = '${rec.name} ${rec.neighborhood ?? ''} near $locationStr';

        final searchResult = await _googlePlacesService.searchByName(
          query: searchQuery,
          latitude: request.startLatitude,
          longitude: request.startLongitude,
          radiusMeters: request.transportMode == TransportMode.walking
              ? _walkingRadiusMeters
              : _drivingRadiusMeters,
        );

        if (searchResult != null) {
          // Enrich restaurant with Perplexity's "why special" description
          final enrichedRestaurant = searchResult.copyWith(
            description: rec.whySpecial ?? rec.description,
          );

          // Match awards
          final awardResult = await _awardMatchingService.matchRestaurantToAwards(enrichedRestaurant);

          // Classify dish weight
          final dishWeight = _scoringService.classifyDishWeight(enrichedRestaurant);

          // Calculate award boost
          final awardBoost = _scoringService.applyAwardBoost(awardResult.awards);

          candidates.add(_RestaurantCandidate(
            restaurant: enrichedRestaurant,
            awards: awardResult.awards,
            dishWeight: dishWeight,
            awardBoost: awardBoost,
          ));

          _session.log('Found "${rec.name}" via Google Places: ${enrichedRestaurant.name}');
        } else {
          _session.log('Could not find "${rec.name}" in Google Places', level: LogLevel.warning);
        }
      }

      return candidates;
    } catch (e) {
      _session.log('Error collecting from Perplexity: $e', level: LogLevel.error);
      return [];
    }
  }

  /// Collect candidates directly from Google Places.
  Future<List<_RestaurantCandidate>> _collectFromGooglePlaces({
    required TourRequest request,
    required int radiusMeters,
    required int limit,
    Set<String>? excludeNames,
  }) async {
    final searchResult = await _googlePlacesService.searchRestaurants(
      latitude: request.startLatitude,
      longitude: request.startLongitude,
      radiusMeters: radiusMeters,
      cuisineTypes: request.cuisinePreferences,
      limit: limit + (excludeNames?.length ?? 0), // Request extra to account for exclusions
    );

    if (searchResult.warning != null) {
      _session.log(
        'Google Places search warning: ${searchResult.warning}',
        level: LogLevel.warning,
      );
    }

    // Process each restaurant
    final candidates = <_RestaurantCandidate>[];

    for (final restaurant in searchResult.restaurants) {
      // Skip if already found via Perplexity
      if (excludeNames != null &&
          excludeNames.contains(restaurant.name.toLowerCase())) {
        continue;
      }

      // Match awards
      final awardResult =
          await _awardMatchingService.matchRestaurantToAwards(restaurant);

      // Classify dish weight
      final dishWeight = _scoringService.classifyDishWeight(restaurant);

      // Calculate award boost
      final awardBoost = _scoringService.applyAwardBoost(awardResult.awards);

      candidates.add(_RestaurantCandidate(
        restaurant: restaurant,
        awards: awardResult.awards,
        dishWeight: dishWeight,
        awardBoost: awardBoost,
      ));

      if (candidates.length >= limit) break;
    }

    return candidates;
  }

  /// Filter candidates based on request criteria.
  List<_RestaurantCandidate> _filterCandidates(
    List<_RestaurantCandidate> candidates,
    TourRequest request,
  ) {
    return candidates.where((c) {
      // Budget tier filter (map to price tier)
      final minPrice = _getMinPriceForBudget(request.budgetTier);
      final maxPrice = _getMaxPriceForBudget(request.budgetTier);
      if (c.restaurant.priceTier < minPrice || c.restaurant.priceTier > maxPrice) {
        return false;
      }

      // Award-only filter
      if (request.awardOnly && c.awards.isEmpty) {
        return false;
      }

      // Cuisine preference filter (if Foursquare didn't filter for us)
      if (request.cuisinePreferences != null &&
          request.cuisinePreferences!.isNotEmpty) {
        final hasMatchingCuisine = c.restaurant.cuisineTypes.any(
          (cuisine) => request.cuisinePreferences!.any(
            (pref) => cuisine.toLowerCase().contains(pref.toLowerCase()),
          ),
        );
        if (!hasMatchingCuisine) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  /// Get minimum price tier for budget.
  int _getMinPriceForBudget(BudgetTier budget) {
    switch (budget) {
      case BudgetTier.budget:
        return 1;
      case BudgetTier.moderate:
        return 1;
      case BudgetTier.upscale:
        return 2;
      case BudgetTier.luxury:
        return 3;
    }
  }

  /// Get maximum price tier for budget.
  int _getMaxPriceForBudget(BudgetTier budget) {
    switch (budget) {
      case BudgetTier.budget:
        return 2;
      case BudgetTier.moderate:
        return 3;
      case BudgetTier.upscale:
        return 4;
      case BudgetTier.luxury:
        return 4;
    }
  }

  /// Optimize tour order using scoring algorithm.
  Future<List<ScoredRestaurant>> _optimizeTour({
    required List<_RestaurantCandidate> candidates,
    required int numStops,
    required double startLat,
    required double startLng,
    required TransportMode transportMode,
    required DateTime startTime,
  }) async {
    if (candidates.length <= numStops) {
      // Not enough candidates - use all of them sorted by digestion weight
      final sorted = List<_RestaurantCandidate>.from(candidates)
        ..sort((a, b) => a.dishWeight.index.compareTo(b.dishWeight.index));

      return sorted.map((c) => ScoredRestaurant(
            restaurant: c.restaurant,
            awards: c.awards,
            dishWeight: c.dishWeight,
            baseScore: 1.0,
            awardBoost: c.awardBoost,
            story: c.story,
            signatureDish: c.signatureDish,
            dishStory: c.dishStory,
            insiderTip: c.insiderTip,
            transitionToNext: c.transitionToNext,
            minutesToSpend: c.minutesToSpend,
          )).toList();
    }

    // Generate combinations of candidates
    final combinations = _generateCombinations(candidates, numStops);

    // Limit combinations to avoid exponential complexity
    final limitedCombinations = combinations.take(_maxPermutations).toList();

    List<ScoredRestaurant>? bestStops;
    double bestScore = -1;

    for (final combination in limitedCombinations) {
      // Generate permutations of this combination for optimal ordering
      final permutations = _generatePermutations(combination);

      for (final permutation in permutations.take(10)) {
        // Convert to ScoredRestaurants
        final stops = permutation.map((c) => ScoredRestaurant(
              restaurant: c.restaurant,
              awards: c.awards,
              dishWeight: c.dishWeight,
              baseScore: 1.0,
              awardBoost: c.awardBoost,
              story: c.story,
              signatureDish: c.signatureDish,
              dishStory: c.dishStory,
              insiderTip: c.insiderTip,
              transitionToNext: c.transitionToNext,
              minutesToSpend: c.minutesToSpend,
            )).toList();

        // Calculate waypoints for route scoring
        final waypoints = [
          LatLng(latitude: startLat, longitude: startLng),
          ...stops.map((s) => LatLng(
                latitude: s.restaurant.latitude,
                longitude: s.restaurant.longitude,
              )),
        ];

        // Get route estimate (use fallback to avoid API spam)
        final routeResult = RouteResult.fallback(
          waypoints: waypoints,
          transportMode: transportMode,
          warning: 'Estimated route',
        );

        // Score this permutation
        final tourScore = _scoringService.scoreTour(
          stops: stops,
          routeLegs: routeResult.legs,
          startTime: startTime,
          transportMode: transportMode,
        );

        // Apply award boost to score
        final boostedScore = tourScore.confidenceScore *
            stops.fold(1.0, (prev, s) => prev * s.awardBoost) /
            pow(1.0, stops.length);

        if (boostedScore > bestScore) {
          bestScore = boostedScore;
          bestStops = stops;
        }
      }
    }

    return bestStops ?? [];
  }

  /// Generate combinations of n items from candidates.
  Iterable<List<_RestaurantCandidate>> _generateCombinations(
    List<_RestaurantCandidate> candidates,
    int n,
  ) sync* {
    if (n == 0) {
      yield [];
      return;
    }

    if (candidates.isEmpty) {
      return;
    }

    if (n == candidates.length) {
      yield List.from(candidates);
      return;
    }

    for (var i = 0; i <= candidates.length - n; i++) {
      final first = candidates[i];
      final rest = candidates.sublist(i + 1);

      for (final combo in _generateCombinations(rest, n - 1)) {
        yield [first, ...combo];
      }
    }
  }

  /// Generate permutations of a list.
  List<List<_RestaurantCandidate>> _generatePermutations(
    List<_RestaurantCandidate> items,
  ) {
    if (items.length <= 1) {
      return [items];
    }

    final result = <List<_RestaurantCandidate>>[];

    for (var i = 0; i < items.length; i++) {
      final first = items[i];
      final rest = [...items.sublist(0, i), ...items.sublist(i + 1)];

      for (final perm in _generatePermutations(rest)) {
        result.add([first, ...perm]);
      }
    }

    return result;
  }

  /// Generate alternative suggestions for each stop.
  Map<String, List<Restaurant>> _generateAlternatives({
    required List<ScoredRestaurant> selectedStops,
    required List<_RestaurantCandidate> allCandidates,
  }) {
    final selectedIds = selectedStops.map((s) => s.restaurant.fsqId).toSet();
    final alternatives = <String, List<Restaurant>>{};

    for (final stop in selectedStops) {
      // Find similar restaurants not already selected
      final similar = allCandidates
          .where((c) =>
              !selectedIds.contains(c.restaurant.fsqId) &&
              _isSimilar(stop.restaurant, c.restaurant))
          .take(2)
          .map((c) => c.restaurant)
          .toList();

      alternatives[stop.restaurant.fsqId] = similar;
    }

    return alternatives;
  }

  /// Check if two restaurants are similar (nearby, similar cuisine/price).
  bool _isSimilar(Restaurant a, Restaurant b) {
    // Similar price tier (within 1)
    if ((a.priceTier - b.priceTier).abs() > 1) {
      return false;
    }

    // Similar cuisine (at least one match)
    final hasCommonCuisine = a.cuisineTypes.any(
      (c1) => b.cuisineTypes.any(
        (c2) => c1.toLowerCase() == c2.toLowerCase(),
      ),
    );
    if (!hasCommonCuisine) {
      return false;
    }

    return true;
  }

  /// Serialize stops to JSON string including narrative fields.
  String _serializeStops(
    List<ScoredRestaurant> stops,
    Map<String, List<Restaurant>> alternatives,
  ) {
    final stopsData = stops.map((stop) {
      // Use curated minutes to spend if available, otherwise estimate
      final visitDuration = stop.minutesToSpend ??
          _scoringService.estimateVisitDuration(
            stop.restaurant,
            stop.dishWeight,
          );

      final awardBadges = _awardMatchingService.getAwardBadges(stop.awards);

      return {
        'fsqId': stop.restaurant.fsqId,
        'name': stop.restaurant.name,
        'address': stop.restaurant.address,
        'latitude': stop.restaurant.latitude,
        'longitude': stop.restaurant.longitude,
        'priceTier': stop.restaurant.priceTier,
        'rating': stop.restaurant.rating,
        'cuisineTypes': stop.restaurant.cuisineTypes,
        'dishWeight': stop.dishWeight.name,
        'visitDurationMinutes': visitDuration,
        'awards': stop.awards.map((a) => {
              'type': a.awardType.name,
              'level': a.awardLevel,
              'year': a.year,
            }).toList(),
        'awardBadges': awardBadges,
        'alternatives': alternatives[stop.restaurant.fsqId]?.map((r) => {
              'fsqId': r.fsqId,
              'name': r.name,
              'address': r.address,
            }).toList() ?? [],
        // Narrative fields from curated tour
        'story': stop.story,
        'signatureDish': stop.signatureDish,
        'dishStory': stop.dishStory,
        'insiderTip': stop.insiderTip,
        'transitionToNext': stop.transitionToNext,
        'minutesToSpend': stop.minutesToSpend,
      };
    }).toList();

    return jsonEncode(stopsData);
  }

  /// Serialize route legs to JSON string.
  String _serializeRouteLegs(List<RouteLeg> legs) {
    final legsData = legs.map((leg) => {
          'distanceMeters': leg.distanceMeters,
          'durationSeconds': leg.durationSeconds,
          'transportMode': leg.transportMode.name,
        }).toList();

    return jsonEncode(legsData);
  }

  /// Generate warning message for partial tour.
  String _generatePartialTourWarning({
    required int requested,
    required int actual,
    required TourRequest request,
  }) {
    final suggestions = <String>[];

    if (request.awardOnly) {
      suggestions.add('remove the award-only filter');
    }

    if (request.cuisinePreferences != null &&
        request.cuisinePreferences!.isNotEmpty) {
      suggestions.add('broaden your cuisine preferences');
    }

    if (request.transportMode == TransportMode.walking) {
      suggestions.add('try driving mode for a larger search area');
    }

    final suggestionText = suggestions.isNotEmpty
        ? ' Try: ${suggestions.join(', ')}.'
        : '';

    return 'Only $actual of $requested stops could be found in your area. '
        'This is a partial tour.$suggestionText';
  }

  /// Create an error result with a warning message.
  TourResult _createErrorResult(TourRequest request, String message) {
    return TourResult(
      requestId: request.id ?? 0, // Default to 0 if not persisted
      stopsJson: '[]',
      routeLegsJson: '[]',
      confidenceScore: 0,
      routePolyline: '',
      totalDistanceMeters: 0,
      totalDurationSeconds: 0,
      isPartialTour: true,
      warningMessage: message,
      createdAt: DateTime.now(),
    );
  }
}
