/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:food_butler_client/src/protocol/analytics/reservation_click_event.dart'
    as _i3;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i4;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i5;
import 'package:food_butler_client/src/protocol/awards/import_result.dart'
    as _i6;
import 'package:food_butler_client/src/protocol/awards/import_preview_result.dart'
    as _i7;
import 'package:food_butler_client/src/protocol/awards/review_queue_item.dart'
    as _i8;
import 'package:food_butler_client/src/protocol/tours/restaurant_award_link.dart'
    as _i9;
import 'package:food_butler_client/src/protocol/tours/award_import_log.dart'
    as _i10;
import 'package:food_butler_client/src/protocol/tours/michelin_award.dart'
    as _i11;
import 'package:food_butler_client/src/protocol/tours/michelin_designation.dart'
    as _i12;
import 'package:food_butler_client/src/protocol/tours/james_beard_award.dart'
    as _i13;
import 'package:food_butler_client/src/protocol/tours/james_beard_distinction.dart'
    as _i14;
import 'package:food_butler_client/src/protocol/daily/daily_story.dart' as _i15;
import 'package:food_butler_client/src/protocol/tonight_pick.dart' as _i16;
import 'package:food_butler_client/src/protocol/discovery/food_discovery_response.dart'
    as _i17;
import 'package:food_butler_client/src/protocol/geocoding/place_prediction.dart'
    as _i18;
import 'package:food_butler_client/src/protocol/geocoding/place_details.dart'
    as _i19;
import 'package:food_butler_client/src/protocol/places/city_prediction.dart'
    as _i20;
import 'package:food_butler_client/src/protocol/greetings/greeting.dart'
    as _i21;
import 'package:food_butler_client/src/protocol/maps/curated_map.dart' as _i22;
import 'package:food_butler_client/src/protocol/maps/map_restaurant.dart'
    as _i23;
import 'package:food_butler_client/src/protocol/maps/favorite_city.dart'
    as _i24;
import 'package:food_butler_client/src/protocol/narratives/narrative_response.dart'
    as _i25;
import 'package:food_butler_client/src/protocol/saved_restaurant.dart' as _i26;
import 'package:food_butler_client/src/protocol/saved_restaurant_source.dart'
    as _i27;
import 'package:food_butler_client/src/protocol/tours/tour_result.dart' as _i28;
import 'package:food_butler_client/src/protocol/tours/tour_request.dart'
    as _i29;
import 'package:food_butler_client/src/protocol/user/user_profile.dart' as _i30;
import 'package:food_butler_client/src/protocol/user/food_philosophy.dart'
    as _i31;
import 'package:food_butler_client/src/protocol/user/adventure_level.dart'
    as _i32;
import 'protocol.dart' as _i33;

/// Analytics API endpoint for tracking user interactions.
///
/// Provides endpoints for recording analytics events like reservation clicks.
/// {@category Endpoint}
class EndpointAnalytics extends _i1.EndpointRef {
  EndpointAnalytics(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'analytics';

  /// Record a reservation link click event.
  ///
  /// Accepts click data and stores it in the database for analytics purposes.
  /// Returns the created event ID on success.
  _i2.Future<int> recordReservationClick(
    int restaurantId,
    String linkType,
    bool launchSuccess, {
    String? userId,
  }) => caller.callServerEndpoint<int>(
    'analytics',
    'recordReservationClick',
    {
      'restaurantId': restaurantId,
      'linkType': linkType,
      'launchSuccess': launchSuccess,
      'userId': userId,
    },
  );

  /// Get reservation click analytics for a restaurant.
  ///
  /// Returns the most recent click events for the specified restaurant.
  _i2.Future<List<_i3.ReservationClickEvent>> getClicksByRestaurant(
    int restaurantId, {
    required int limit,
  }) => caller.callServerEndpoint<List<_i3.ReservationClickEvent>>(
    'analytics',
    'getClicksByRestaurant',
    {
      'restaurantId': restaurantId,
      'limit': limit,
    },
  );

  /// Get aggregated click counts for analytics dashboard.
  ///
  /// Returns click counts grouped by link type for a restaurant.
  _i2.Future<Map<String, int>> getClickCountsByType({int? restaurantId}) =>
      caller.callServerEndpoint<Map<String, int>>(
        'analytics',
        'getClickCountsByType',
        {'restaurantId': restaurantId},
      );
}

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _i4.EndpointEmailIdpBase {
  EndpointEmailIdp(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i2.Future<_i5.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i5.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _i2.Future<_i1.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_i1.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _i2.Future<String> verifyRegistrationCode({
    required _i1.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _i2.Future<_i5.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_i5.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _i2.Future<_i1.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i1.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _i2.Future<String> verifyPasswordResetCode({
    required _i1.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i2.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );
}

/// By extending [GoogleIdpBaseEndpoint], the Google identity provider endpoints
/// are made available on the server and enable Google sign-in on the client.
/// {@category Endpoint}
class EndpointGoogleIdp extends _i4.EndpointGoogleIdpBase {
  EndpointGoogleIdp(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'googleIdp';

  /// Validates a Google ID token and either logs in the associated user or
  /// creates a new user account if the Google account ID is not yet known.
  ///
  /// If a new user is created an associated [UserProfile] is also created.
  @override
  _i2.Future<_i5.AuthSuccess> login({
    required String idToken,
    required String? accessToken,
  }) => caller.callServerEndpoint<_i5.AuthSuccess>(
    'googleIdp',
    'login',
    {
      'idToken': idToken,
      'accessToken': accessToken,
    },
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _i5.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _i2.Future<_i5.AuthSuccess> refreshAccessToken({
    required String refreshToken,
  }) => caller.callServerEndpoint<_i5.AuthSuccess>(
    'jwtRefresh',
    'refreshAccessToken',
    {'refreshToken': refreshToken},
    authenticated: false,
  );
}

/// Admin API endpoint for award management.
///
/// Provides import, review, and management capabilities for award data.
/// All endpoints require admin authorization.
/// {@category Endpoint}
class EndpointAdminAward extends _i1.EndpointRef {
  EndpointAdminAward(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminAward';

  /// Import awards from CSV data.
  ///
  /// Parses the CSV content, matches awards to restaurants, and creates
  /// the appropriate database records.
  _i2.Future<_i6.ImportResult> importAwards({
    required String csvContent,
    required String awardType,
    required String fileName,
  }) => caller.callServerEndpoint<_i6.ImportResult>(
    'adminAward',
    'importAwards',
    {
      'csvContent': csvContent,
      'awardType': awardType,
      'fileName': fileName,
    },
  );

  /// Preview import results without committing to database.
  _i2.Future<_i7.ImportPreviewResult> previewImport({
    required String csvContent,
    required String awardType,
  }) => caller.callServerEndpoint<_i7.ImportPreviewResult>(
    'adminAward',
    'previewImport',
    {
      'csvContent': csvContent,
      'awardType': awardType,
    },
  );

  /// Get the review queue of pending matches.
  _i2.Future<List<_i8.ReviewQueueItem>> getReviewQueue({
    required int limit,
    required int offset,
  }) => caller.callServerEndpoint<List<_i8.ReviewQueueItem>>(
    'adminAward',
    'getReviewQueue',
    {
      'limit': limit,
      'offset': offset,
    },
  );

  /// Confirm a pending match.
  _i2.Future<bool> confirmMatch(int linkId) => caller.callServerEndpoint<bool>(
    'adminAward',
    'confirmMatch',
    {'linkId': linkId},
  );

  /// Reject a pending match.
  _i2.Future<bool> rejectMatch(int linkId) => caller.callServerEndpoint<bool>(
    'adminAward',
    'rejectMatch',
    {'linkId': linkId},
  );

  /// Manually create a new award-restaurant link.
  _i2.Future<_i9.RestaurantAwardLink> createLink({
    required int restaurantId,
    required String awardType,
    required int awardId,
  }) => caller.callServerEndpoint<_i9.RestaurantAwardLink>(
    'adminAward',
    'createLink',
    {
      'restaurantId': restaurantId,
      'awardType': awardType,
      'awardId': awardId,
    },
  );

  /// Delete an award-restaurant link.
  _i2.Future<bool> deleteLink(int linkId) => caller.callServerEndpoint<bool>(
    'adminAward',
    'deleteLink',
    {'linkId': linkId},
  );

  /// Get import audit logs.
  _i2.Future<List<_i10.AwardImportLog>> getImportLogs({
    required int limit,
    required int offset,
  }) => caller.callServerEndpoint<List<_i10.AwardImportLog>>(
    'adminAward',
    'getImportLogs',
    {
      'limit': limit,
      'offset': offset,
    },
  );
}

/// Public API endpoint for querying award data.
///
/// Provides read-only access to award information for restaurants.
/// {@category Endpoint}
class EndpointAward extends _i1.EndpointRef {
  EndpointAward(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'award';

  /// Get all linked awards for a restaurant.
  ///
  /// Returns a list of awards associated with the restaurant identified by [restaurantId].
  _i2.Future<List<Map<String, dynamic>>> getRestaurantAwards(
    int restaurantId,
  ) => caller.callServerEndpoint<List<Map<String, dynamic>>>(
    'award',
    'getRestaurantAwards',
    {'restaurantId': restaurantId},
  );

  /// List Michelin awards with optional filters.
  ///
  /// Filters:
  /// - [city]: Filter by city name (case-insensitive partial match)
  /// - [designation]: Filter by designation type
  /// - [year]: Filter by award year
  /// - [limit]: Maximum number of results (default 50)
  /// - [offset]: Number of results to skip for pagination
  _i2.Future<List<_i11.MichelinAward>> getMichelinAwards({
    String? city,
    _i12.MichelinDesignation? designation,
    int? year,
    required int limit,
    required int offset,
  }) => caller.callServerEndpoint<List<_i11.MichelinAward>>(
    'award',
    'getMichelinAwards',
    {
      'city': city,
      'designation': designation,
      'year': year,
      'limit': limit,
      'offset': offset,
    },
  );

  /// List James Beard awards with optional filters.
  ///
  /// Filters:
  /// - [city]: Filter by city name (case-insensitive partial match)
  /// - [category]: Filter by award category
  /// - [distinctionLevel]: Filter by distinction level (winner, nominee, semifinalist)
  /// - [year]: Filter by award year
  /// - [limit]: Maximum number of results (default 50)
  /// - [offset]: Number of results to skip for pagination
  _i2.Future<List<_i13.JamesBeardAward>> getJamesBeardAwards({
    String? city,
    String? category,
    _i14.JamesBeardDistinction? distinctionLevel,
    int? year,
    required int limit,
    required int offset,
  }) => caller.callServerEndpoint<List<_i13.JamesBeardAward>>(
    'award',
    'getJamesBeardAwards',
    {
      'city': city,
      'category': category,
      'distinctionLevel': distinctionLevel,
      'year': year,
      'limit': limit,
      'offset': offset,
    },
  );

  /// Calculate award score for a restaurant.
  ///
  /// Scoring:
  /// - Michelin: 3-star=100, 2-star=70, 1-star=50, Bib Gourmand=30
  /// - James Beard: Winner=50, Nominee=30, Semifinalist=15
  /// - Recent awards (last 2 years) get 1.5x multiplier
  /// - Multiple awards compound with diminishing returns (sqrt scaling)
  _i2.Future<double> calculateRestaurantAwardScore(int restaurantId) =>
      caller.callServerEndpoint<double>(
        'award',
        'calculateRestaurantAwardScore',
        {'restaurantId': restaurantId},
      );
}

/// Endpoint for personalized daily food stories.
///
/// Generates unique, editorial-quality stories daily based on
/// user profile, preferences, and cities.
/// {@category Endpoint}
class EndpointDailyStory extends _i1.EndpointRef {
  EndpointDailyStory(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'dailyStory';

  /// Get today's personalized story for the current user.
  ///
  /// Returns cached story if already generated today, otherwise generates new.
  _i2.Future<_i15.DailyStory?> getDailyStory() =>
      caller.callServerEndpoint<_i15.DailyStory?>(
        'dailyStory',
        'getDailyStory',
        {},
      );

  /// Force refresh today's story (for testing/admin).
  _i2.Future<_i15.DailyStory?> refreshDailyStory() =>
      caller.callServerEndpoint<_i15.DailyStory?>(
        'dailyStory',
        'refreshDailyStory',
        {},
      );
}

/// Endpoint for "Three for Tonight" - context-aware quick picks.
///
/// Returns 3 restaurant recommendations based on:
/// - Time of day (breakfast/lunch/dinner/late-night)
/// - Current weather conditions
/// - User's cuisine preferences
/// - User's selected city
/// {@category Endpoint}
class EndpointThreeForTonight extends _i1.EndpointRef {
  EndpointThreeForTonight(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'threeForTonight';

  /// Get three contextual restaurant picks for tonight.
  ///
  /// [cityName] - The city to search in
  /// [stateOrRegion] - Optional state/region for more accurate results
  /// [latitude] - Optional latitude for weather data
  /// [longitude] - Optional longitude for weather data
  _i2.Future<List<_i16.TonightPick>> getThreeForTonight({
    required String cityName,
    String? stateOrRegion,
    double? latitude,
    double? longitude,
  }) => caller.callServerEndpoint<List<_i16.TonightPick>>(
    'threeForTonight',
    'getThreeForTonight',
    {
      'cityName': cityName,
      'stateOrRegion': stateOrRegion,
      'latitude': latitude,
      'longitude': longitude,
    },
  );
}

/// Endpoint for the AI food concierge - "Ask the Butler".
///
/// Handles free-form natural language food queries like:
/// - "Hidden gems in Capitol Hill for locals"
/// - "Best late night eats after a Mariners game"
/// - "Hole-in-the-wall taquerias tourists miss"
/// {@category Endpoint}
class EndpointFoodDiscovery extends _i1.EndpointRef {
  EndpointFoodDiscovery(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'foodDiscovery';

  /// Ask the Butler any food-related question.
  ///
  /// The AI will understand natural language queries and return
  /// curated restaurant recommendations with photos and map data.
  _i2.Future<_i17.FoodDiscoveryResponse> ask(String query) =>
      caller.callServerEndpoint<_i17.FoodDiscoveryResponse>(
        'foodDiscovery',
        'ask',
        {'query': query},
      );
}

/// Geocoding API endpoint.
///
/// Proxies Google Places API requests to avoid CORS issues on web.
/// {@category Endpoint}
class EndpointGeocoding extends _i1.EndpointRef {
  EndpointGeocoding(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'geocoding';

  /// Search for places matching the query.
  ///
  /// Returns a list of place predictions with their IDs and descriptions.
  _i2.Future<List<_i18.PlacePrediction>> searchPlaces(String query) =>
      caller.callServerEndpoint<List<_i18.PlacePrediction>>(
        'geocoding',
        'searchPlaces',
        {'query': query},
      );

  /// Get details for a place by its ID.
  ///
  /// Returns the place's coordinates and address components.
  _i2.Future<_i19.PlaceDetails?> getPlaceDetails(String placeId) =>
      caller.callServerEndpoint<_i19.PlaceDetails?>(
        'geocoding',
        'getPlaceDetails',
        {'placeId': placeId},
      );
}

/// Endpoint for Google Places API proxy.
/// Handles city autocomplete and place details to avoid CORS issues in web.
/// {@category Endpoint}
class EndpointPlaces extends _i1.EndpointRef {
  EndpointPlaces(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'places';

  /// Search for cities using Google Places Autocomplete.
  /// Returns a list of city predictions.
  _i2.Future<List<_i20.CityPrediction>> searchCities(String query) =>
      caller.callServerEndpoint<List<_i20.CityPrediction>>(
        'places',
        'searchCities',
        {'query': query},
      );

  /// Get place details including coordinates.
  _i2.Future<_i19.PlaceDetails?> getPlaceDetails(String placeId) =>
      caller.callServerEndpoint<_i19.PlaceDetails?>(
        'places',
        'getPlaceDetails',
        {'placeId': placeId},
      );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i1.EndpointRef {
  EndpointGreeting(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i2.Future<_i21.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i21.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

/// Journal entry API endpoint.
///
/// Provides CRUD operations for journal entries with filtering and pagination.
/// {@category Endpoint}
class EndpointJournalEntry extends _i1.EndpointRef {
  EndpointJournalEntry(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'journalEntry';

  /// Create a new journal entry.
  ///
  /// POST /journal-entries
  /// Requires authentication.
  _i2.Future<Map<String, dynamic>> createEntry({
    required int restaurantId,
    required int rating,
    String? notes,
    required DateTime visitedAt,
    int? tourId,
    int? tourStopId,
  }) => caller.callServerEndpoint<Map<String, dynamic>>(
    'journalEntry',
    'createEntry',
    {
      'restaurantId': restaurantId,
      'rating': rating,
      'notes': notes,
      'visitedAt': visitedAt,
      'tourId': tourId,
      'tourStopId': tourStopId,
    },
  );

  /// Get a list of the user's journal entries.
  ///
  /// GET /journal-entries
  /// Supports pagination, sorting, and filtering.
  _i2.Future<Map<String, dynamic>> getEntries({
    required int page,
    required int pageSize,
    required String sortBy,
    required String sortOrder,
    DateTime? startDate,
    DateTime? endDate,
  }) => caller.callServerEndpoint<Map<String, dynamic>>(
    'journalEntry',
    'getEntries',
    {
      'page': page,
      'pageSize': pageSize,
      'sortBy': sortBy,
      'sortOrder': sortOrder,
      'startDate': startDate,
      'endDate': endDate,
    },
  );

  /// Get a single journal entry by ID.
  ///
  /// GET /journal-entries/{id}
  _i2.Future<Map<String, dynamic>> getEntry({required int entryId}) =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'journalEntry',
        'getEntry',
        {'entryId': entryId},
      );

  /// Update a journal entry.
  ///
  /// PUT /journal-entries/{id}
  /// Only rating, notes, and visitedAt can be updated.
  _i2.Future<Map<String, dynamic>> updateEntry({
    required int entryId,
    int? rating,
    String? notes,
    DateTime? visitedAt,
  }) => caller.callServerEndpoint<Map<String, dynamic>>(
    'journalEntry',
    'updateEntry',
    {
      'entryId': entryId,
      'rating': rating,
      'notes': notes,
      'visitedAt': visitedAt,
    },
  );

  /// Delete a journal entry and its photos.
  ///
  /// DELETE /journal-entries/{id}
  _i2.Future<Map<String, dynamic>> deleteEntry({required int entryId}) =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'journalEntry',
        'deleteEntry',
        {'entryId': entryId},
      );

  /// Get entries for a specific restaurant.
  ///
  /// GET /journal-entries/by-restaurant/{restaurantId}
  _i2.Future<Map<String, dynamic>> getEntriesByRestaurant({
    required int restaurantId,
    required int page,
    required int pageSize,
  }) => caller.callServerEndpoint<Map<String, dynamic>>(
    'journalEntry',
    'getEntriesByRestaurant',
    {
      'restaurantId': restaurantId,
      'page': page,
      'pageSize': pageSize,
    },
  );

  /// Get entries linked to a specific tour.
  ///
  /// GET /journal-entries/by-tour/{tourId}
  _i2.Future<Map<String, dynamic>> getEntriesByTour({required int tourId}) =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'journalEntry',
        'getEntriesByTour',
        {'tourId': tourId},
      );

  /// Get all restaurants the user has visited.
  ///
  /// GET /restaurants/visited
  _i2.Future<Map<String, dynamic>> getVisitedRestaurants({
    required String sortBy,
    required String sortOrder,
  }) => caller.callServerEndpoint<Map<String, dynamic>>(
    'journalEntry',
    'getVisitedRestaurants',
    {
      'sortBy': sortBy,
      'sortOrder': sortOrder,
    },
  );
}

/// Photo upload API endpoint for journal entries.
///
/// Handles pre-signed URL generation and upload confirmation.
/// {@category Endpoint}
class EndpointPhoto extends _i1.EndpointRef {
  EndpointPhoto(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'photo';

  /// Get a pre-signed URL for uploading a photo.
  ///
  /// Returns a signed PUT URL that the client can use to upload directly to R2.
  /// Requires authentication.
  _i2.Future<Map<String, dynamic>> getUploadUrl({
    required int journalEntryId,
    required String filename,
  }) => caller.callServerEndpoint<Map<String, dynamic>>(
    'photo',
    'getUploadUrl',
    {
      'journalEntryId': journalEntryId,
      'filename': filename,
    },
  );

  /// Confirm an upload and create the photo record.
  ///
  /// This should be called after the client successfully uploads the image.
  /// It triggers thumbnail generation and creates the database record.
  _i2.Future<Map<String, dynamic>> confirmUpload({
    required int journalEntryId,
    required String objectKey,
    required int displayOrder,
  }) => caller.callServerEndpoint<Map<String, dynamic>>(
    'photo',
    'confirmUpload',
    {
      'journalEntryId': journalEntryId,
      'objectKey': objectKey,
      'displayOrder': displayOrder,
    },
  );

  /// Delete a photo from a journal entry.
  ///
  /// Removes the photo from R2 and the database.
  _i2.Future<Map<String, dynamic>> deletePhoto({required int photoId}) =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'photo',
        'deletePhoto',
        {'photoId': photoId},
      );
}

/// Endpoint for curated restaurant maps (Eater-style).
/// {@category Endpoint}
class EndpointCuratedMaps extends _i1.EndpointRef {
  EndpointCuratedMaps(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'curatedMaps';

  /// Get all curated maps for a city.
  _i2.Future<List<_i22.CuratedMap>> getMapsForCity(String cityName) =>
      caller.callServerEndpoint<List<_i22.CuratedMap>>(
        'curatedMaps',
        'getMapsForCity',
        {'cityName': cityName},
      );

  /// Get maps for a specific category in a city.
  _i2.Future<List<_i22.CuratedMap>> getMapsByCategory(
    String cityName,
    String category,
  ) => caller.callServerEndpoint<List<_i22.CuratedMap>>(
    'curatedMaps',
    'getMapsByCategory',
    {
      'cityName': cityName,
      'category': category,
    },
  );

  /// Get a single map by slug.
  _i2.Future<_i22.CuratedMap?> getMapBySlug(String slug) =>
      caller.callServerEndpoint<_i22.CuratedMap?>(
        'curatedMaps',
        'getMapBySlug',
        {'slug': slug},
      );

  /// Get all restaurants in a map.
  _i2.Future<List<_i23.MapRestaurant>> getMapRestaurants(int mapId) =>
      caller.callServerEndpoint<List<_i23.MapRestaurant>>(
        'curatedMaps',
        'getMapRestaurants',
        {'mapId': mapId},
      );

  /// Get user's favorite cities.
  _i2.Future<List<_i24.FavoriteCity>> getFavoriteCities() =>
      caller.callServerEndpoint<List<_i24.FavoriteCity>>(
        'curatedMaps',
        'getFavoriteCities',
        {},
      );

  /// Add a favorite city.
  _i2.Future<_i24.FavoriteCity> addFavoriteCity({
    required String cityName,
    String? stateOrRegion,
    required String country,
    required double latitude,
    required double longitude,
    required bool isHomeCity,
  }) => caller.callServerEndpoint<_i24.FavoriteCity>(
    'curatedMaps',
    'addFavoriteCity',
    {
      'cityName': cityName,
      'stateOrRegion': stateOrRegion,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'isHomeCity': isHomeCity,
    },
  );

  /// Remove a favorite city.
  _i2.Future<bool> removeFavoriteCity(int cityId) =>
      caller.callServerEndpoint<bool>(
        'curatedMaps',
        'removeFavoriteCity',
        {'cityId': cityId},
      );

  /// Get user's custom maps.
  _i2.Future<List<_i22.CuratedMap>> getUserMaps() =>
      caller.callServerEndpoint<List<_i22.CuratedMap>>(
        'curatedMaps',
        'getUserMaps',
        {},
      );

  /// Create a user's custom map.
  _i2.Future<_i22.CuratedMap> createUserMap({
    required String cityName,
    String? stateOrRegion,
    required String country,
    required String title,
    required String shortDescription,
  }) => caller.callServerEndpoint<_i22.CuratedMap>(
    'curatedMaps',
    'createUserMap',
    {
      'cityName': cityName,
      'stateOrRegion': stateOrRegion,
      'country': country,
      'title': title,
      'shortDescription': shortDescription,
    },
  );

  /// Add a restaurant to a user's map with AI-generated description.
  _i2.Future<_i23.MapRestaurant> addRestaurantToMap({
    required int mapId,
    required String name,
    String? googlePlaceId,
    String? editorialDescription,
    required String address,
    required String city,
    String? stateOrRegion,
    required double latitude,
    required double longitude,
    String? phoneNumber,
    String? websiteUrl,
    String? reservationUrl,
    String? primaryPhotoUrl,
  }) => caller.callServerEndpoint<_i23.MapRestaurant>(
    'curatedMaps',
    'addRestaurantToMap',
    {
      'mapId': mapId,
      'name': name,
      'googlePlaceId': googlePlaceId,
      'editorialDescription': editorialDescription,
      'address': address,
      'city': city,
      'stateOrRegion': stateOrRegion,
      'latitude': latitude,
      'longitude': longitude,
      'phoneNumber': phoneNumber,
      'websiteUrl': websiteUrl,
      'reservationUrl': reservationUrl,
      'primaryPhotoUrl': primaryPhotoUrl,
    },
  );

  /// Generate a curated map using Perplexity AI.
  _i2.Future<_i22.CuratedMap> generateMap({
    required String cityName,
    String? stateOrRegion,
    required String country,
    required String mapType,
    String? customPrompt,
    required int maxRestaurants,
  }) => caller.callServerEndpoint<_i22.CuratedMap>(
    'curatedMaps',
    'generateMap',
    {
      'cityName': cityName,
      'stateOrRegion': stateOrRegion,
      'country': country,
      'mapType': mapType,
      'customPrompt': customPrompt,
      'maxRestaurants': maxRestaurants,
    },
  );
}

/// Narrative generation API endpoint.
///
/// Provides RESTful API for generating AI-powered tour narratives.
/// Endpoint: /api/v1/narratives/tour/{tour_id}
/// {@category Endpoint}
class EndpointNarrative extends _i1.EndpointRef {
  EndpointNarrative(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'narrative';

  /// Generate narratives for a tour.
  ///
  /// Parameters:
  /// - [tourId]: The tour result ID to generate narratives for
  /// - [regenerate]: If true, invalidates cache and generates fresh content
  ///
  /// Returns NarrativeResponse with intro, descriptions, and transitions.
  /// Rate limited to 3 regenerations per tour per day.
  _i2.Future<_i25.NarrativeResponse> generate(
    int tourId, {
    required bool regenerate,
  }) => caller.callServerEndpoint<_i25.NarrativeResponse>(
    'narrative',
    'generate',
    {
      'tourId': tourId,
      'regenerate': regenerate,
    },
  );
}

/// Endpoint for proxying Google Places photos.
/// This hides the API key from clients and enables caching.
/// {@category Endpoint}
class EndpointGooglePhotos extends _i1.EndpointRef {
  EndpointGooglePhotos(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'googlePhotos';

  /// Get a Google Places photo by reference.
  /// Returns the photo as base64-encoded data with content type.
  ///
  /// This proxies the request through the server to hide the API key.
  _i2.Future<Map<String, dynamic>> getPhoto(
    String photoReference, {
    required bool thumbnail,
  }) => caller.callServerEndpoint<Map<String, dynamic>>(
    'googlePhotos',
    'getPhoto',
    {
      'photoReference': photoReference,
      'thumbnail': thumbnail,
    },
  );

  /// Get a signed/proxied URL for a Google Places photo.
  /// Returns a URL that can be used directly in img tags.
  ///
  /// This creates a server-side URL that proxies to Google.
  _i2.Future<String?> getPhotoUrl(
    String photoReference, {
    required bool thumbnail,
  }) => caller.callServerEndpoint<String?>(
    'googlePhotos',
    'getPhotoUrl',
    {
      'photoReference': photoReference,
      'thumbnail': thumbnail,
    },
  );

  /// Stream a Google Places photo directly (for use as img src).
  /// This endpoint returns the raw image bytes.
  _i2.Future<void> streamPhoto(
    String ref, {
    required bool thumbnail,
  }) => caller.callServerEndpoint<void>(
    'googlePhotos',
    'streamPhoto',
    {
      'ref': ref,
      'thumbnail': thumbnail,
    },
  );

  /// Get multiple photos for a place by place ID.
  /// Returns up to [maxPhotos] photo references.
  _i2.Future<List<String>> getPhotoReferences(
    String placeId, {
    required int maxPhotos,
  }) => caller.callServerEndpoint<List<String>>(
    'googlePhotos',
    'getPhotoReferences',
    {
      'placeId': placeId,
      'maxPhotos': maxPhotos,
    },
  );

  /// Get photos for a restaurant with full URLs.
  /// Returns a list of photo data including URLs and dimensions.
  _i2.Future<List<Map<String, dynamic>>> getRestaurantPhotos(
    String placeId, {
    required int maxPhotos,
  }) => caller.callServerEndpoint<List<Map<String, dynamic>>>(
    'googlePhotos',
    'getRestaurantPhotos',
    {
      'placeId': placeId,
      'maxPhotos': maxPhotos,
    },
  );
}

/// Endpoint for managing saved/bookmarked restaurants.
/// {@category Endpoint}
class EndpointSavedRestaurant extends _i1.EndpointRef {
  EndpointSavedRestaurant(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'savedRestaurant';

  /// Save a restaurant to the user's favorites.
  ///
  /// If the restaurant is already saved (by placeId), updates it instead.
  _i2.Future<_i26.SavedRestaurant> saveRestaurant({
    required String name,
    String? placeId,
    String? address,
    String? cuisineType,
    String? imageUrl,
    double? rating,
    int? priceLevel,
    String? notes,
    int? userRating,
    required _i27.SavedRestaurantSource source,
  }) => caller.callServerEndpoint<_i26.SavedRestaurant>(
    'savedRestaurant',
    'saveRestaurant',
    {
      'name': name,
      'placeId': placeId,
      'address': address,
      'cuisineType': cuisineType,
      'imageUrl': imageUrl,
      'rating': rating,
      'priceLevel': priceLevel,
      'notes': notes,
      'userRating': userRating,
      'source': source,
    },
  );

  /// Remove a restaurant from favorites.
  _i2.Future<bool> unsaveRestaurant({
    int? id,
    String? placeId,
  }) => caller.callServerEndpoint<bool>(
    'savedRestaurant',
    'unsaveRestaurant',
    {
      'id': id,
      'placeId': placeId,
    },
  );

  /// Check if a restaurant is saved.
  _i2.Future<bool> isRestaurantSaved({required String placeId}) =>
      caller.callServerEndpoint<bool>(
        'savedRestaurant',
        'isRestaurantSaved',
        {'placeId': placeId},
      );

  /// Get all saved restaurants for the current user.
  _i2.Future<List<_i26.SavedRestaurant>> getSavedRestaurants() =>
      caller.callServerEndpoint<List<_i26.SavedRestaurant>>(
        'savedRestaurant',
        'getSavedRestaurants',
        {},
      );

  /// Update notes or user rating for a saved restaurant.
  _i2.Future<_i26.SavedRestaurant?> updateSavedRestaurant({
    required int id,
    String? notes,
    int? userRating,
  }) => caller.callServerEndpoint<_i26.SavedRestaurant?>(
    'savedRestaurant',
    'updateSavedRestaurant',
    {
      'id': id,
      'notes': notes,
      'userRating': userRating,
    },
  );

  /// Get a single saved restaurant by ID.
  _i2.Future<_i26.SavedRestaurant?> getSavedRestaurant({required int id}) =>
      caller.callServerEndpoint<_i26.SavedRestaurant?>(
        'savedRestaurant',
        'getSavedRestaurant',
        {'id': id},
      );
}

/// Tour generation API endpoint.
///
/// Provides RESTful API for generating optimized food tours.
/// Endpoint: POST /api/v1/tours/generate
/// {@category Endpoint}
class EndpointTour extends _i1.EndpointRef {
  EndpointTour(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'tour';

  /// Generate an optimized food tour based on request parameters.
  ///
  /// Returns HTTP 200 with TourResult for successful generation.
  /// Returns HTTP 400 equivalent (via TourResult with error) for validation errors.
  /// Includes rate limiting headers in response.
  _i2.Future<_i28.TourResult> generate(_i29.TourRequest request) =>
      caller.callServerEndpoint<_i28.TourResult>(
        'tour',
        'generate',
        {'request': request},
      );
}

/// Endpoint for managing user profile, preferences, and onboarding.
/// {@category Endpoint}
class EndpointUserProfile extends _i1.EndpointRef {
  EndpointUserProfile(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'userProfile';

  /// Get the current user's profile.
  /// Returns null if no profile exists (user hasn't onboarded).
  _i2.Future<_i30.UserProfile?> getProfile() =>
      caller.callServerEndpoint<_i30.UserProfile?>(
        'userProfile',
        'getProfile',
        {},
      );

  /// Check if the current user has completed onboarding.
  _i2.Future<bool> hasCompletedOnboarding() => caller.callServerEndpoint<bool>(
    'userProfile',
    'hasCompletedOnboarding',
    {},
  );

  /// Create or update user profile.
  /// Called during onboarding to save user's choices.
  _i2.Future<_i30.UserProfile> saveProfile({
    _i31.FoodPhilosophy? foodPhilosophy,
    _i32.AdventureLevel? adventureLevel,
    List<String>? familiarCuisines,
    List<String>? wantToTryCuisines,
    List<String>? dietaryRestrictions,
    String? homeCity,
    String? homeState,
    String? homeCountry,
    double? homeLatitude,
    double? homeLongitude,
    String? additionalCities,
    bool? onboardingCompleted,
  }) => caller.callServerEndpoint<_i30.UserProfile>(
    'userProfile',
    'saveProfile',
    {
      'foodPhilosophy': foodPhilosophy,
      'adventureLevel': adventureLevel,
      'familiarCuisines': familiarCuisines,
      'wantToTryCuisines': wantToTryCuisines,
      'dietaryRestrictions': dietaryRestrictions,
      'homeCity': homeCity,
      'homeState': homeState,
      'homeCountry': homeCountry,
      'homeLatitude': homeLatitude,
      'homeLongitude': homeLongitude,
      'additionalCities': additionalCities,
      'onboardingCompleted': onboardingCompleted,
    },
  );

  /// Complete onboarding - marks profile as complete.
  _i2.Future<_i30.UserProfile> completeOnboarding() =>
      caller.callServerEndpoint<_i30.UserProfile>(
        'userProfile',
        'completeOnboarding',
        {},
      );

  /// Update just the user's home location.
  _i2.Future<_i30.UserProfile> updateLocation({
    required String city,
    String? state,
    String? country,
    double? latitude,
    double? longitude,
  }) => caller.callServerEndpoint<_i30.UserProfile>(
    'userProfile',
    'updateLocation',
    {
      'city': city,
      'state': state,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
    },
  );

  /// Update food philosophy preference.
  _i2.Future<_i30.UserProfile> updateFoodPhilosophy(
    _i31.FoodPhilosophy philosophy,
  ) => caller.callServerEndpoint<_i30.UserProfile>(
    'userProfile',
    'updateFoodPhilosophy',
    {'philosophy': philosophy},
  );

  /// Update adventure level preference.
  _i2.Future<_i30.UserProfile> updateAdventureLevel(
    _i32.AdventureLevel level,
  ) => caller.callServerEndpoint<_i30.UserProfile>(
    'userProfile',
    'updateAdventureLevel',
    {'level': level},
  );

  /// Update cuisine preferences.
  _i2.Future<_i30.UserProfile> updateCuisinePreferences({
    List<String>? familiar,
    List<String>? wantToTry,
  }) => caller.callServerEndpoint<_i30.UserProfile>(
    'userProfile',
    'updateCuisinePreferences',
    {
      'familiar': familiar,
      'wantToTry': wantToTry,
    },
  );

  /// Update dietary restrictions.
  _i2.Future<_i30.UserProfile> updateDietaryRestrictions(
    List<String> restrictions,
  ) => caller.callServerEndpoint<_i30.UserProfile>(
    'userProfile',
    'updateDietaryRestrictions',
    {'restrictions': restrictions},
  );

  /// Update additional cities for personalized content.
  /// Cities should be a JSON string array.
  _i2.Future<_i30.UserProfile> updateAdditionalCities(String citiesJson) =>
      caller.callServerEndpoint<_i30.UserProfile>(
        'userProfile',
        'updateAdditionalCities',
        {'citiesJson': citiesJson},
      );

  /// Debug endpoint to check profile status for Daily Story.
  /// Returns a diagnostic summary of what's needed for Daily Story to work.
  _i2.Future<Map<String, dynamic>> debugProfileStatus() =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'userProfile',
        'debugProfileStatus',
        {},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _i4.Caller(client);
    serverpod_auth_core = _i5.Caller(client);
  }

  late final _i4.Caller serverpod_auth_idp;

  late final _i5.Caller serverpod_auth_core;
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i33.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    analytics = EndpointAnalytics(this);
    emailIdp = EndpointEmailIdp(this);
    googleIdp = EndpointGoogleIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    adminAward = EndpointAdminAward(this);
    award = EndpointAward(this);
    dailyStory = EndpointDailyStory(this);
    threeForTonight = EndpointThreeForTonight(this);
    foodDiscovery = EndpointFoodDiscovery(this);
    geocoding = EndpointGeocoding(this);
    places = EndpointPlaces(this);
    greeting = EndpointGreeting(this);
    journalEntry = EndpointJournalEntry(this);
    photo = EndpointPhoto(this);
    curatedMaps = EndpointCuratedMaps(this);
    narrative = EndpointNarrative(this);
    googlePhotos = EndpointGooglePhotos(this);
    savedRestaurant = EndpointSavedRestaurant(this);
    tour = EndpointTour(this);
    userProfile = EndpointUserProfile(this);
    modules = Modules(this);
  }

  late final EndpointAnalytics analytics;

  late final EndpointEmailIdp emailIdp;

  late final EndpointGoogleIdp googleIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointAdminAward adminAward;

  late final EndpointAward award;

  late final EndpointDailyStory dailyStory;

  late final EndpointThreeForTonight threeForTonight;

  late final EndpointFoodDiscovery foodDiscovery;

  late final EndpointGeocoding geocoding;

  late final EndpointPlaces places;

  late final EndpointGreeting greeting;

  late final EndpointJournalEntry journalEntry;

  late final EndpointPhoto photo;

  late final EndpointCuratedMaps curatedMaps;

  late final EndpointNarrative narrative;

  late final EndpointGooglePhotos googlePhotos;

  late final EndpointSavedRestaurant savedRestaurant;

  late final EndpointTour tour;

  late final EndpointUserProfile userProfile;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
    'analytics': analytics,
    'emailIdp': emailIdp,
    'googleIdp': googleIdp,
    'jwtRefresh': jwtRefresh,
    'adminAward': adminAward,
    'award': award,
    'dailyStory': dailyStory,
    'threeForTonight': threeForTonight,
    'foodDiscovery': foodDiscovery,
    'geocoding': geocoding,
    'places': places,
    'greeting': greeting,
    'journalEntry': journalEntry,
    'photo': photo,
    'curatedMaps': curatedMaps,
    'narrative': narrative,
    'googlePhotos': googlePhotos,
    'savedRestaurant': savedRestaurant,
    'tour': tour,
    'userProfile': userProfile,
  };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
