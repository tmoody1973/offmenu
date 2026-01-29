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
import 'package:serverpod/serverpod.dart' as _i1;
import '../analytics/analytics_endpoint.dart' as _i2;
import '../auth/email_idp_endpoint.dart' as _i3;
import '../auth/google_idp_endpoint.dart' as _i4;
import '../auth/jwt_refresh_endpoint.dart' as _i5;
import '../awards/admin_award_endpoint.dart' as _i6;
import '../awards/award_endpoint.dart' as _i7;
import '../daily/daily_story_endpoint.dart' as _i8;
import '../daily/three_for_tonight_endpoint.dart' as _i9;
import '../discovery/cuisine_exploration_endpoint.dart' as _i10;
import '../endpoints/food_discovery_endpoint.dart' as _i11;
import '../endpoints/geocoding_endpoint.dart' as _i12;
import '../endpoints/places_endpoint.dart' as _i13;
import '../greetings/greeting_endpoint.dart' as _i14;
import '../journal/journal_entry_endpoint.dart' as _i15;
import '../journal/photo_endpoint.dart' as _i16;
import '../maps/curated_maps_endpoint.dart' as _i17;
import '../narratives/narrative_endpoint.dart' as _i18;
import '../places/google_photos_endpoint.dart' as _i19;
import '../saved/saved_restaurant_endpoint.dart' as _i20;
import '../tours/tour_endpoint.dart' as _i21;
import '../user/user_profile_endpoint.dart' as _i22;
import 'package:food_butler_server/src/generated/tours/michelin_designation.dart'
    as _i23;
import 'package:food_butler_server/src/generated/tours/james_beard_distinction.dart'
    as _i24;
import 'package:food_butler_server/src/generated/saved_restaurant_source.dart'
    as _i25;
import 'package:food_butler_server/src/generated/tours/tour_request.dart'
    as _i26;
import 'package:food_butler_server/src/generated/user/food_philosophy.dart'
    as _i27;
import 'package:food_butler_server/src/generated/user/adventure_level.dart'
    as _i28;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i29;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i30;
import 'package:food_butler_server/src/generated/future_calls.dart' as _i31;
export 'future_calls.dart' show ServerpodFutureCallsGetter;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'analytics': _i2.AnalyticsEndpoint()
        ..initialize(
          server,
          'analytics',
          null,
        ),
      'emailIdp': _i3.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'googleIdp': _i4.GoogleIdpEndpoint()
        ..initialize(
          server,
          'googleIdp',
          null,
        ),
      'jwtRefresh': _i5.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'adminAward': _i6.AdminAwardEndpoint()
        ..initialize(
          server,
          'adminAward',
          null,
        ),
      'award': _i7.AwardEndpoint()
        ..initialize(
          server,
          'award',
          null,
        ),
      'dailyStory': _i8.DailyStoryEndpoint()
        ..initialize(
          server,
          'dailyStory',
          null,
        ),
      'threeForTonight': _i9.ThreeForTonightEndpoint()
        ..initialize(
          server,
          'threeForTonight',
          null,
        ),
      'cuisineExploration': _i10.CuisineExplorationEndpoint()
        ..initialize(
          server,
          'cuisineExploration',
          null,
        ),
      'foodDiscovery': _i11.FoodDiscoveryEndpoint()
        ..initialize(
          server,
          'foodDiscovery',
          null,
        ),
      'geocoding': _i12.GeocodingEndpoint()
        ..initialize(
          server,
          'geocoding',
          null,
        ),
      'places': _i13.PlacesEndpoint()
        ..initialize(
          server,
          'places',
          null,
        ),
      'greeting': _i14.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
      'journalEntry': _i15.JournalEntryEndpoint()
        ..initialize(
          server,
          'journalEntry',
          null,
        ),
      'photo': _i16.PhotoEndpoint()
        ..initialize(
          server,
          'photo',
          null,
        ),
      'curatedMaps': _i17.CuratedMapsEndpoint()
        ..initialize(
          server,
          'curatedMaps',
          null,
        ),
      'narrative': _i18.NarrativeEndpoint()
        ..initialize(
          server,
          'narrative',
          null,
        ),
      'googlePhotos': _i19.GooglePhotosEndpoint()
        ..initialize(
          server,
          'googlePhotos',
          null,
        ),
      'savedRestaurant': _i20.SavedRestaurantEndpoint()
        ..initialize(
          server,
          'savedRestaurant',
          null,
        ),
      'tour': _i21.TourEndpoint()
        ..initialize(
          server,
          'tour',
          null,
        ),
      'userProfile': _i22.UserProfileEndpoint()
        ..initialize(
          server,
          'userProfile',
          null,
        ),
    };
    connectors['analytics'] = _i1.EndpointConnector(
      name: 'analytics',
      endpoint: endpoints['analytics']!,
      methodConnectors: {
        'recordReservationClick': _i1.MethodConnector(
          name: 'recordReservationClick',
          params: {
            'restaurantId': _i1.ParameterDescription(
              name: 'restaurantId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'linkType': _i1.ParameterDescription(
              name: 'linkType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'launchSuccess': _i1.ParameterDescription(
              name: 'launchSuccess',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['analytics'] as _i2.AnalyticsEndpoint)
                  .recordReservationClick(
                    session,
                    params['restaurantId'],
                    params['linkType'],
                    params['launchSuccess'],
                    userId: params['userId'],
                  ),
        ),
        'getClicksByRestaurant': _i1.MethodConnector(
          name: 'getClicksByRestaurant',
          params: {
            'restaurantId': _i1.ParameterDescription(
              name: 'restaurantId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['analytics'] as _i2.AnalyticsEndpoint)
                  .getClicksByRestaurant(
                    session,
                    params['restaurantId'],
                    limit: params['limit'],
                  ),
        ),
        'getClickCountsByType': _i1.MethodConnector(
          name: 'getClickCountsByType',
          params: {
            'restaurantId': _i1.ParameterDescription(
              name: 'restaurantId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['analytics'] as _i2.AnalyticsEndpoint)
                  .getClickCountsByType(
                    session,
                    restaurantId: params['restaurantId'],
                  ),
        ),
      },
    );
    connectors['emailIdp'] = _i1.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i3.EmailIdpEndpoint).login(
                session,
                email: params['email'],
                password: params['password'],
              ),
        ),
        'startRegistration': _i1.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i3.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _i1.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _i1.ParameterDescription(
              name: 'accountRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i3.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _i1.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _i1.ParameterDescription(
              name: 'registrationToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i3.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _i1.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i3.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _i1.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _i1.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i3.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _i1.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _i1.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i3.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
      },
    );
    connectors['googleIdp'] = _i1.EndpointConnector(
      name: 'googleIdp',
      endpoint: endpoints['googleIdp']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'accessToken': _i1.ParameterDescription(
              name: 'accessToken',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['googleIdp'] as _i4.GoogleIdpEndpoint).login(
                    session,
                    idToken: params['idToken'],
                    accessToken: params['accessToken'],
                  ),
        ),
      },
    );
    connectors['jwtRefresh'] = _i1.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _i1.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _i1.ParameterDescription(
              name: 'refreshToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['jwtRefresh'] as _i5.JwtRefreshEndpoint)
                  .refreshAccessToken(
                    session,
                    refreshToken: params['refreshToken'],
                  ),
        ),
      },
    );
    connectors['adminAward'] = _i1.EndpointConnector(
      name: 'adminAward',
      endpoint: endpoints['adminAward']!,
      methodConnectors: {
        'importAwards': _i1.MethodConnector(
          name: 'importAwards',
          params: {
            'csvContent': _i1.ParameterDescription(
              name: 'csvContent',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'awardType': _i1.ParameterDescription(
              name: 'awardType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'fileName': _i1.ParameterDescription(
              name: 'fileName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminAward'] as _i6.AdminAwardEndpoint)
                  .importAwards(
                    session,
                    csvContent: params['csvContent'],
                    awardType: params['awardType'],
                    fileName: params['fileName'],
                  ),
        ),
        'previewImport': _i1.MethodConnector(
          name: 'previewImport',
          params: {
            'csvContent': _i1.ParameterDescription(
              name: 'csvContent',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'awardType': _i1.ParameterDescription(
              name: 'awardType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminAward'] as _i6.AdminAwardEndpoint)
                  .previewImport(
                    session,
                    csvContent: params['csvContent'],
                    awardType: params['awardType'],
                  ),
        ),
        'getReviewQueue': _i1.MethodConnector(
          name: 'getReviewQueue',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminAward'] as _i6.AdminAwardEndpoint)
                  .getReviewQueue(
                    session,
                    limit: params['limit'],
                    offset: params['offset'],
                  ),
        ),
        'confirmMatch': _i1.MethodConnector(
          name: 'confirmMatch',
          params: {
            'linkId': _i1.ParameterDescription(
              name: 'linkId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminAward'] as _i6.AdminAwardEndpoint)
                  .confirmMatch(
                    session,
                    params['linkId'],
                  ),
        ),
        'rejectMatch': _i1.MethodConnector(
          name: 'rejectMatch',
          params: {
            'linkId': _i1.ParameterDescription(
              name: 'linkId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminAward'] as _i6.AdminAwardEndpoint)
                  .rejectMatch(
                    session,
                    params['linkId'],
                  ),
        ),
        'createLink': _i1.MethodConnector(
          name: 'createLink',
          params: {
            'restaurantId': _i1.ParameterDescription(
              name: 'restaurantId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'awardType': _i1.ParameterDescription(
              name: 'awardType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'awardId': _i1.ParameterDescription(
              name: 'awardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminAward'] as _i6.AdminAwardEndpoint)
                  .createLink(
                    session,
                    restaurantId: params['restaurantId'],
                    awardType: params['awardType'],
                    awardId: params['awardId'],
                  ),
        ),
        'deleteLink': _i1.MethodConnector(
          name: 'deleteLink',
          params: {
            'linkId': _i1.ParameterDescription(
              name: 'linkId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminAward'] as _i6.AdminAwardEndpoint)
                  .deleteLink(
                    session,
                    params['linkId'],
                  ),
        ),
        'getImportLogs': _i1.MethodConnector(
          name: 'getImportLogs',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminAward'] as _i6.AdminAwardEndpoint)
                  .getImportLogs(
                    session,
                    limit: params['limit'],
                    offset: params['offset'],
                  ),
        ),
      },
    );
    connectors['award'] = _i1.EndpointConnector(
      name: 'award',
      endpoint: endpoints['award']!,
      methodConnectors: {
        'getRestaurantAwards': _i1.MethodConnector(
          name: 'getRestaurantAwards',
          params: {
            'restaurantId': _i1.ParameterDescription(
              name: 'restaurantId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['award'] as _i7.AwardEndpoint).getRestaurantAwards(
                    session,
                    params['restaurantId'],
                  ),
        ),
        'getMichelinAwards': _i1.MethodConnector(
          name: 'getMichelinAwards',
          params: {
            'city': _i1.ParameterDescription(
              name: 'city',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'designation': _i1.ParameterDescription(
              name: 'designation',
              type: _i1.getType<_i23.MichelinDesignation?>(),
              nullable: true,
            ),
            'year': _i1.ParameterDescription(
              name: 'year',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['award'] as _i7.AwardEndpoint).getMichelinAwards(
                    session,
                    city: params['city'],
                    designation: params['designation'],
                    year: params['year'],
                    limit: params['limit'],
                    offset: params['offset'],
                  ),
        ),
        'getJamesBeardAwards': _i1.MethodConnector(
          name: 'getJamesBeardAwards',
          params: {
            'city': _i1.ParameterDescription(
              name: 'city',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'distinctionLevel': _i1.ParameterDescription(
              name: 'distinctionLevel',
              type: _i1.getType<_i24.JamesBeardDistinction?>(),
              nullable: true,
            ),
            'year': _i1.ParameterDescription(
              name: 'year',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['award'] as _i7.AwardEndpoint).getJamesBeardAwards(
                    session,
                    city: params['city'],
                    category: params['category'],
                    distinctionLevel: params['distinctionLevel'],
                    year: params['year'],
                    limit: params['limit'],
                    offset: params['offset'],
                  ),
        ),
        'calculateRestaurantAwardScore': _i1.MethodConnector(
          name: 'calculateRestaurantAwardScore',
          params: {
            'restaurantId': _i1.ParameterDescription(
              name: 'restaurantId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['award'] as _i7.AwardEndpoint)
                  .calculateRestaurantAwardScore(
                    session,
                    params['restaurantId'],
                  ),
        ),
      },
    );
    connectors['dailyStory'] = _i1.EndpointConnector(
      name: 'dailyStory',
      endpoint: endpoints['dailyStory']!,
      methodConnectors: {
        'getDailyStory': _i1.MethodConnector(
          name: 'getDailyStory',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['dailyStory'] as _i8.DailyStoryEndpoint)
                  .getDailyStory(session),
        ),
        'getStoryHistory': _i1.MethodConnector(
          name: 'getStoryHistory',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['dailyStory'] as _i8.DailyStoryEndpoint)
                  .getStoryHistory(
                    session,
                    limit: params['limit'],
                    offset: params['offset'],
                  ),
        ),
        'getStoryById': _i1.MethodConnector(
          name: 'getStoryById',
          params: {
            'storyId': _i1.ParameterDescription(
              name: 'storyId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['dailyStory'] as _i8.DailyStoryEndpoint)
                  .getStoryById(
                    session,
                    params['storyId'],
                  ),
        ),
        'getStoryCount': _i1.MethodConnector(
          name: 'getStoryCount',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['dailyStory'] as _i8.DailyStoryEndpoint)
                  .getStoryCount(session),
        ),
        'refreshDailyStory': _i1.MethodConnector(
          name: 'refreshDailyStory',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['dailyStory'] as _i8.DailyStoryEndpoint)
                  .refreshDailyStory(session),
        ),
      },
    );
    connectors['threeForTonight'] = _i1.EndpointConnector(
      name: 'threeForTonight',
      endpoint: endpoints['threeForTonight']!,
      methodConnectors: {
        'getThreeForTonight': _i1.MethodConnector(
          name: 'getThreeForTonight',
          params: {
            'cityName': _i1.ParameterDescription(
              name: 'cityName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'stateOrRegion': _i1.ParameterDescription(
              name: 'stateOrRegion',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'latitude': _i1.ParameterDescription(
              name: 'latitude',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'longitude': _i1.ParameterDescription(
              name: 'longitude',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'forceRefresh': _i1.ParameterDescription(
              name: 'forceRefresh',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['threeForTonight'] as _i9.ThreeForTonightEndpoint)
                      .getThreeForTonight(
                        session,
                        cityName: params['cityName'],
                        stateOrRegion: params['stateOrRegion'],
                        latitude: params['latitude'],
                        longitude: params['longitude'],
                        forceRefresh: params['forceRefresh'],
                      ),
        ),
      },
    );
    connectors['cuisineExploration'] = _i1.EndpointConnector(
      name: 'cuisineExploration',
      endpoint: endpoints['cuisineExploration']!,
      methodConnectors: {
        'getExplorationSuggestion': _i1.MethodConnector(
          name: 'getExplorationSuggestion',
          params: {
            'cityName': _i1.ParameterDescription(
              name: 'cityName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'stateOrRegion': _i1.ParameterDescription(
              name: 'stateOrRegion',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'latitude': _i1.ParameterDescription(
              name: 'latitude',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'longitude': _i1.ParameterDescription(
              name: 'longitude',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['cuisineExploration']
                          as _i10.CuisineExplorationEndpoint)
                      .getExplorationSuggestion(
                        session,
                        cityName: params['cityName'],
                        stateOrRegion: params['stateOrRegion'],
                        latitude: params['latitude'],
                        longitude: params['longitude'],
                      ),
        ),
      },
    );
    connectors['foodDiscovery'] = _i1.EndpointConnector(
      name: 'foodDiscovery',
      endpoint: endpoints['foodDiscovery']!,
      methodConnectors: {
        'ask': _i1.MethodConnector(
          name: 'ask',
          params: {
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['foodDiscovery'] as _i11.FoodDiscoveryEndpoint)
                      .ask(
                        session,
                        params['query'],
                      ),
        ),
      },
    );
    connectors['geocoding'] = _i1.EndpointConnector(
      name: 'geocoding',
      endpoint: endpoints['geocoding']!,
      methodConnectors: {
        'searchPlaces': _i1.MethodConnector(
          name: 'searchPlaces',
          params: {
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['geocoding'] as _i12.GeocodingEndpoint)
                  .searchPlaces(
                    session,
                    params['query'],
                  ),
        ),
        'getPlaceDetails': _i1.MethodConnector(
          name: 'getPlaceDetails',
          params: {
            'placeId': _i1.ParameterDescription(
              name: 'placeId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['geocoding'] as _i12.GeocodingEndpoint)
                  .getPlaceDetails(
                    session,
                    params['placeId'],
                  ),
        ),
      },
    );
    connectors['places'] = _i1.EndpointConnector(
      name: 'places',
      endpoint: endpoints['places']!,
      methodConnectors: {
        'searchCities': _i1.MethodConnector(
          name: 'searchCities',
          params: {
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['places'] as _i13.PlacesEndpoint).searchCities(
                    session,
                    params['query'],
                  ),
        ),
        'getPlaceDetails': _i1.MethodConnector(
          name: 'getPlaceDetails',
          params: {
            'placeId': _i1.ParameterDescription(
              name: 'placeId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['places'] as _i13.PlacesEndpoint).getPlaceDetails(
                    session,
                    params['placeId'],
                  ),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greeting'] as _i14.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
        ),
      },
    );
    connectors['journalEntry'] = _i1.EndpointConnector(
      name: 'journalEntry',
      endpoint: endpoints['journalEntry']!,
      methodConnectors: {
        'createEntry': _i1.MethodConnector(
          name: 'createEntry',
          params: {
            'restaurantId': _i1.ParameterDescription(
              name: 'restaurantId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'rating': _i1.ParameterDescription(
              name: 'rating',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'notes': _i1.ParameterDescription(
              name: 'notes',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'visitedAt': _i1.ParameterDescription(
              name: 'visitedAt',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'tourId': _i1.ParameterDescription(
              name: 'tourId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'tourStopId': _i1.ParameterDescription(
              name: 'tourStopId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['journalEntry'] as _i15.JournalEntryEndpoint)
                      .createEntry(
                        session,
                        restaurantId: params['restaurantId'],
                        rating: params['rating'],
                        notes: params['notes'],
                        visitedAt: params['visitedAt'],
                        tourId: params['tourId'],
                        tourStopId: params['tourStopId'],
                      ),
        ),
        'getEntries': _i1.MethodConnector(
          name: 'getEntries',
          params: {
            'page': _i1.ParameterDescription(
              name: 'page',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'pageSize': _i1.ParameterDescription(
              name: 'pageSize',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'sortBy': _i1.ParameterDescription(
              name: 'sortBy',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'sortOrder': _i1.ParameterDescription(
              name: 'sortOrder',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'startDate': _i1.ParameterDescription(
              name: 'startDate',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'endDate': _i1.ParameterDescription(
              name: 'endDate',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['journalEntry'] as _i15.JournalEntryEndpoint)
                      .getEntries(
                        session,
                        page: params['page'],
                        pageSize: params['pageSize'],
                        sortBy: params['sortBy'],
                        sortOrder: params['sortOrder'],
                        startDate: params['startDate'],
                        endDate: params['endDate'],
                      ),
        ),
        'getEntry': _i1.MethodConnector(
          name: 'getEntry',
          params: {
            'entryId': _i1.ParameterDescription(
              name: 'entryId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['journalEntry'] as _i15.JournalEntryEndpoint)
                      .getEntry(
                        session,
                        entryId: params['entryId'],
                      ),
        ),
        'updateEntry': _i1.MethodConnector(
          name: 'updateEntry',
          params: {
            'entryId': _i1.ParameterDescription(
              name: 'entryId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'rating': _i1.ParameterDescription(
              name: 'rating',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'notes': _i1.ParameterDescription(
              name: 'notes',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'visitedAt': _i1.ParameterDescription(
              name: 'visitedAt',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['journalEntry'] as _i15.JournalEntryEndpoint)
                      .updateEntry(
                        session,
                        entryId: params['entryId'],
                        rating: params['rating'],
                        notes: params['notes'],
                        visitedAt: params['visitedAt'],
                      ),
        ),
        'deleteEntry': _i1.MethodConnector(
          name: 'deleteEntry',
          params: {
            'entryId': _i1.ParameterDescription(
              name: 'entryId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['journalEntry'] as _i15.JournalEntryEndpoint)
                      .deleteEntry(
                        session,
                        entryId: params['entryId'],
                      ),
        ),
        'getEntriesByRestaurant': _i1.MethodConnector(
          name: 'getEntriesByRestaurant',
          params: {
            'restaurantId': _i1.ParameterDescription(
              name: 'restaurantId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'page': _i1.ParameterDescription(
              name: 'page',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'pageSize': _i1.ParameterDescription(
              name: 'pageSize',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['journalEntry'] as _i15.JournalEntryEndpoint)
                      .getEntriesByRestaurant(
                        session,
                        restaurantId: params['restaurantId'],
                        page: params['page'],
                        pageSize: params['pageSize'],
                      ),
        ),
        'getEntriesByTour': _i1.MethodConnector(
          name: 'getEntriesByTour',
          params: {
            'tourId': _i1.ParameterDescription(
              name: 'tourId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['journalEntry'] as _i15.JournalEntryEndpoint)
                      .getEntriesByTour(
                        session,
                        tourId: params['tourId'],
                      ),
        ),
        'getVisitedRestaurants': _i1.MethodConnector(
          name: 'getVisitedRestaurants',
          params: {
            'sortBy': _i1.ParameterDescription(
              name: 'sortBy',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'sortOrder': _i1.ParameterDescription(
              name: 'sortOrder',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['journalEntry'] as _i15.JournalEntryEndpoint)
                      .getVisitedRestaurants(
                        session,
                        sortBy: params['sortBy'],
                        sortOrder: params['sortOrder'],
                      ),
        ),
      },
    );
    connectors['photo'] = _i1.EndpointConnector(
      name: 'photo',
      endpoint: endpoints['photo']!,
      methodConnectors: {
        'getUploadUrl': _i1.MethodConnector(
          name: 'getUploadUrl',
          params: {
            'journalEntryId': _i1.ParameterDescription(
              name: 'journalEntryId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'filename': _i1.ParameterDescription(
              name: 'filename',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['photo'] as _i16.PhotoEndpoint).getUploadUrl(
                    session,
                    journalEntryId: params['journalEntryId'],
                    filename: params['filename'],
                  ),
        ),
        'confirmUpload': _i1.MethodConnector(
          name: 'confirmUpload',
          params: {
            'journalEntryId': _i1.ParameterDescription(
              name: 'journalEntryId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'objectKey': _i1.ParameterDescription(
              name: 'objectKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'displayOrder': _i1.ParameterDescription(
              name: 'displayOrder',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['photo'] as _i16.PhotoEndpoint).confirmUpload(
                    session,
                    journalEntryId: params['journalEntryId'],
                    objectKey: params['objectKey'],
                    displayOrder: params['displayOrder'],
                  ),
        ),
        'deletePhoto': _i1.MethodConnector(
          name: 'deletePhoto',
          params: {
            'photoId': _i1.ParameterDescription(
              name: 'photoId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['photo'] as _i16.PhotoEndpoint).deletePhoto(
                session,
                photoId: params['photoId'],
              ),
        ),
      },
    );
    connectors['curatedMaps'] = _i1.EndpointConnector(
      name: 'curatedMaps',
      endpoint: endpoints['curatedMaps']!,
      methodConnectors: {
        'getMapsForCity': _i1.MethodConnector(
          name: 'getMapsForCity',
          params: {
            'cityName': _i1.ParameterDescription(
              name: 'cityName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['curatedMaps'] as _i17.CuratedMapsEndpoint)
                  .getMapsForCity(
                    session,
                    params['cityName'],
                  ),
        ),
        'getMapsByCategory': _i1.MethodConnector(
          name: 'getMapsByCategory',
          params: {
            'cityName': _i1.ParameterDescription(
              name: 'cityName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['curatedMaps'] as _i17.CuratedMapsEndpoint)
                  .getMapsByCategory(
                    session,
                    params['cityName'],
                    params['category'],
                  ),
        ),
        'getMapBySlug': _i1.MethodConnector(
          name: 'getMapBySlug',
          params: {
            'slug': _i1.ParameterDescription(
              name: 'slug',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['curatedMaps'] as _i17.CuratedMapsEndpoint)
                  .getMapBySlug(
                    session,
                    params['slug'],
                  ),
        ),
        'getMapRestaurants': _i1.MethodConnector(
          name: 'getMapRestaurants',
          params: {
            'mapId': _i1.ParameterDescription(
              name: 'mapId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['curatedMaps'] as _i17.CuratedMapsEndpoint)
                  .getMapRestaurants(
                    session,
                    params['mapId'],
                  ),
        ),
        'getFavoriteCities': _i1.MethodConnector(
          name: 'getFavoriteCities',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['curatedMaps'] as _i17.CuratedMapsEndpoint)
                  .getFavoriteCities(session),
        ),
        'addFavoriteCity': _i1.MethodConnector(
          name: 'addFavoriteCity',
          params: {
            'cityName': _i1.ParameterDescription(
              name: 'cityName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'stateOrRegion': _i1.ParameterDescription(
              name: 'stateOrRegion',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'country': _i1.ParameterDescription(
              name: 'country',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'latitude': _i1.ParameterDescription(
              name: 'latitude',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'longitude': _i1.ParameterDescription(
              name: 'longitude',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'isHomeCity': _i1.ParameterDescription(
              name: 'isHomeCity',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['curatedMaps'] as _i17.CuratedMapsEndpoint)
                  .addFavoriteCity(
                    session,
                    cityName: params['cityName'],
                    stateOrRegion: params['stateOrRegion'],
                    country: params['country'],
                    latitude: params['latitude'],
                    longitude: params['longitude'],
                    isHomeCity: params['isHomeCity'],
                  ),
        ),
        'removeFavoriteCity': _i1.MethodConnector(
          name: 'removeFavoriteCity',
          params: {
            'cityId': _i1.ParameterDescription(
              name: 'cityId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['curatedMaps'] as _i17.CuratedMapsEndpoint)
                  .removeFavoriteCity(
                    session,
                    params['cityId'],
                  ),
        ),
        'getUserMaps': _i1.MethodConnector(
          name: 'getUserMaps',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['curatedMaps'] as _i17.CuratedMapsEndpoint)
                  .getUserMaps(session),
        ),
        'createUserMap': _i1.MethodConnector(
          name: 'createUserMap',
          params: {
            'cityName': _i1.ParameterDescription(
              name: 'cityName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'stateOrRegion': _i1.ParameterDescription(
              name: 'stateOrRegion',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'country': _i1.ParameterDescription(
              name: 'country',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'shortDescription': _i1.ParameterDescription(
              name: 'shortDescription',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['curatedMaps'] as _i17.CuratedMapsEndpoint)
                  .createUserMap(
                    session,
                    cityName: params['cityName'],
                    stateOrRegion: params['stateOrRegion'],
                    country: params['country'],
                    title: params['title'],
                    shortDescription: params['shortDescription'],
                  ),
        ),
        'addRestaurantToMap': _i1.MethodConnector(
          name: 'addRestaurantToMap',
          params: {
            'mapId': _i1.ParameterDescription(
              name: 'mapId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'googlePlaceId': _i1.ParameterDescription(
              name: 'googlePlaceId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'editorialDescription': _i1.ParameterDescription(
              name: 'editorialDescription',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'address': _i1.ParameterDescription(
              name: 'address',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'city': _i1.ParameterDescription(
              name: 'city',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'stateOrRegion': _i1.ParameterDescription(
              name: 'stateOrRegion',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'latitude': _i1.ParameterDescription(
              name: 'latitude',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'longitude': _i1.ParameterDescription(
              name: 'longitude',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'phoneNumber': _i1.ParameterDescription(
              name: 'phoneNumber',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'websiteUrl': _i1.ParameterDescription(
              name: 'websiteUrl',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'reservationUrl': _i1.ParameterDescription(
              name: 'reservationUrl',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'primaryPhotoUrl': _i1.ParameterDescription(
              name: 'primaryPhotoUrl',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['curatedMaps'] as _i17.CuratedMapsEndpoint)
                  .addRestaurantToMap(
                    session,
                    mapId: params['mapId'],
                    name: params['name'],
                    googlePlaceId: params['googlePlaceId'],
                    editorialDescription: params['editorialDescription'],
                    address: params['address'],
                    city: params['city'],
                    stateOrRegion: params['stateOrRegion'],
                    latitude: params['latitude'],
                    longitude: params['longitude'],
                    phoneNumber: params['phoneNumber'],
                    websiteUrl: params['websiteUrl'],
                    reservationUrl: params['reservationUrl'],
                    primaryPhotoUrl: params['primaryPhotoUrl'],
                  ),
        ),
        'generateMap': _i1.MethodConnector(
          name: 'generateMap',
          params: {
            'cityName': _i1.ParameterDescription(
              name: 'cityName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'stateOrRegion': _i1.ParameterDescription(
              name: 'stateOrRegion',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'country': _i1.ParameterDescription(
              name: 'country',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'mapType': _i1.ParameterDescription(
              name: 'mapType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'customPrompt': _i1.ParameterDescription(
              name: 'customPrompt',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'maxRestaurants': _i1.ParameterDescription(
              name: 'maxRestaurants',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['curatedMaps'] as _i17.CuratedMapsEndpoint)
                  .generateMap(
                    session,
                    cityName: params['cityName'],
                    stateOrRegion: params['stateOrRegion'],
                    country: params['country'],
                    mapType: params['mapType'],
                    customPrompt: params['customPrompt'],
                    maxRestaurants: params['maxRestaurants'],
                  ),
        ),
      },
    );
    connectors['narrative'] = _i1.EndpointConnector(
      name: 'narrative',
      endpoint: endpoints['narrative']!,
      methodConnectors: {
        'generate': _i1.MethodConnector(
          name: 'generate',
          params: {
            'tourId': _i1.ParameterDescription(
              name: 'tourId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'regenerate': _i1.ParameterDescription(
              name: 'regenerate',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['narrative'] as _i18.NarrativeEndpoint).generate(
                    session,
                    params['tourId'],
                    regenerate: params['regenerate'],
                  ),
        ),
      },
    );
    connectors['googlePhotos'] = _i1.EndpointConnector(
      name: 'googlePhotos',
      endpoint: endpoints['googlePhotos']!,
      methodConnectors: {
        'getPhoto': _i1.MethodConnector(
          name: 'getPhoto',
          params: {
            'photoReference': _i1.ParameterDescription(
              name: 'photoReference',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'thumbnail': _i1.ParameterDescription(
              name: 'thumbnail',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['googlePhotos'] as _i19.GooglePhotosEndpoint)
                      .getPhoto(
                        session,
                        params['photoReference'],
                        thumbnail: params['thumbnail'],
                      ),
        ),
        'getPhotoUrl': _i1.MethodConnector(
          name: 'getPhotoUrl',
          params: {
            'photoReference': _i1.ParameterDescription(
              name: 'photoReference',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'thumbnail': _i1.ParameterDescription(
              name: 'thumbnail',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['googlePhotos'] as _i19.GooglePhotosEndpoint)
                      .getPhotoUrl(
                        session,
                        params['photoReference'],
                        thumbnail: params['thumbnail'],
                      ),
        ),
        'streamPhoto': _i1.MethodConnector(
          name: 'streamPhoto',
          params: {
            'ref': _i1.ParameterDescription(
              name: 'ref',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'thumbnail': _i1.ParameterDescription(
              name: 'thumbnail',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['googlePhotos'] as _i19.GooglePhotosEndpoint)
                      .streamPhoto(
                        session,
                        params['ref'],
                        thumbnail: params['thumbnail'],
                      ),
        ),
        'getPhotoReferences': _i1.MethodConnector(
          name: 'getPhotoReferences',
          params: {
            'placeId': _i1.ParameterDescription(
              name: 'placeId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'maxPhotos': _i1.ParameterDescription(
              name: 'maxPhotos',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['googlePhotos'] as _i19.GooglePhotosEndpoint)
                      .getPhotoReferences(
                        session,
                        params['placeId'],
                        maxPhotos: params['maxPhotos'],
                      ),
        ),
        'getRestaurantPhotos': _i1.MethodConnector(
          name: 'getRestaurantPhotos',
          params: {
            'placeId': _i1.ParameterDescription(
              name: 'placeId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'maxPhotos': _i1.ParameterDescription(
              name: 'maxPhotos',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['googlePhotos'] as _i19.GooglePhotosEndpoint)
                      .getRestaurantPhotos(
                        session,
                        params['placeId'],
                        maxPhotos: params['maxPhotos'],
                      ),
        ),
      },
    );
    connectors['savedRestaurant'] = _i1.EndpointConnector(
      name: 'savedRestaurant',
      endpoint: endpoints['savedRestaurant']!,
      methodConnectors: {
        'saveRestaurant': _i1.MethodConnector(
          name: 'saveRestaurant',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'placeId': _i1.ParameterDescription(
              name: 'placeId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'address': _i1.ParameterDescription(
              name: 'address',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'cuisineType': _i1.ParameterDescription(
              name: 'cuisineType',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'imageUrl': _i1.ParameterDescription(
              name: 'imageUrl',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'rating': _i1.ParameterDescription(
              name: 'rating',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'priceLevel': _i1.ParameterDescription(
              name: 'priceLevel',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'notes': _i1.ParameterDescription(
              name: 'notes',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'userRating': _i1.ParameterDescription(
              name: 'userRating',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'source': _i1.ParameterDescription(
              name: 'source',
              type: _i1.getType<_i25.SavedRestaurantSource>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['savedRestaurant'] as _i20.SavedRestaurantEndpoint)
                      .saveRestaurant(
                        session,
                        name: params['name'],
                        placeId: params['placeId'],
                        address: params['address'],
                        cuisineType: params['cuisineType'],
                        imageUrl: params['imageUrl'],
                        rating: params['rating'],
                        priceLevel: params['priceLevel'],
                        notes: params['notes'],
                        userRating: params['userRating'],
                        source: params['source'],
                      ),
        ),
        'unsaveRestaurant': _i1.MethodConnector(
          name: 'unsaveRestaurant',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'placeId': _i1.ParameterDescription(
              name: 'placeId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['savedRestaurant'] as _i20.SavedRestaurantEndpoint)
                      .unsaveRestaurant(
                        session,
                        id: params['id'],
                        placeId: params['placeId'],
                      ),
        ),
        'isRestaurantSaved': _i1.MethodConnector(
          name: 'isRestaurantSaved',
          params: {
            'placeId': _i1.ParameterDescription(
              name: 'placeId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['savedRestaurant'] as _i20.SavedRestaurantEndpoint)
                      .isRestaurantSaved(
                        session,
                        placeId: params['placeId'],
                      ),
        ),
        'getSavedRestaurants': _i1.MethodConnector(
          name: 'getSavedRestaurants',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['savedRestaurant'] as _i20.SavedRestaurantEndpoint)
                      .getSavedRestaurants(session),
        ),
        'updateSavedRestaurant': _i1.MethodConnector(
          name: 'updateSavedRestaurant',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'notes': _i1.ParameterDescription(
              name: 'notes',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'userRating': _i1.ParameterDescription(
              name: 'userRating',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['savedRestaurant'] as _i20.SavedRestaurantEndpoint)
                      .updateSavedRestaurant(
                        session,
                        id: params['id'],
                        notes: params['notes'],
                        userRating: params['userRating'],
                      ),
        ),
        'getSavedRestaurant': _i1.MethodConnector(
          name: 'getSavedRestaurant',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['savedRestaurant'] as _i20.SavedRestaurantEndpoint)
                      .getSavedRestaurant(
                        session,
                        id: params['id'],
                      ),
        ),
      },
    );
    connectors['tour'] = _i1.EndpointConnector(
      name: 'tour',
      endpoint: endpoints['tour']!,
      methodConnectors: {
        'generate': _i1.MethodConnector(
          name: 'generate',
          params: {
            'request': _i1.ParameterDescription(
              name: 'request',
              type: _i1.getType<_i26.TourRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['tour'] as _i21.TourEndpoint).generate(
                session,
                params['request'],
              ),
        ),
      },
    );
    connectors['userProfile'] = _i1.EndpointConnector(
      name: 'userProfile',
      endpoint: endpoints['userProfile']!,
      methodConnectors: {
        'getProfile': _i1.MethodConnector(
          name: 'getProfile',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i22.UserProfileEndpoint)
                  .getProfile(session),
        ),
        'hasCompletedOnboarding': _i1.MethodConnector(
          name: 'hasCompletedOnboarding',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i22.UserProfileEndpoint)
                  .hasCompletedOnboarding(session),
        ),
        'saveProfile': _i1.MethodConnector(
          name: 'saveProfile',
          params: {
            'foodPhilosophy': _i1.ParameterDescription(
              name: 'foodPhilosophy',
              type: _i1.getType<_i27.FoodPhilosophy?>(),
              nullable: true,
            ),
            'adventureLevel': _i1.ParameterDescription(
              name: 'adventureLevel',
              type: _i1.getType<_i28.AdventureLevel?>(),
              nullable: true,
            ),
            'familiarCuisines': _i1.ParameterDescription(
              name: 'familiarCuisines',
              type: _i1.getType<List<String>?>(),
              nullable: true,
            ),
            'wantToTryCuisines': _i1.ParameterDescription(
              name: 'wantToTryCuisines',
              type: _i1.getType<List<String>?>(),
              nullable: true,
            ),
            'dietaryRestrictions': _i1.ParameterDescription(
              name: 'dietaryRestrictions',
              type: _i1.getType<List<String>?>(),
              nullable: true,
            ),
            'homeCity': _i1.ParameterDescription(
              name: 'homeCity',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'homeState': _i1.ParameterDescription(
              name: 'homeState',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'homeCountry': _i1.ParameterDescription(
              name: 'homeCountry',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'homeLatitude': _i1.ParameterDescription(
              name: 'homeLatitude',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'homeLongitude': _i1.ParameterDescription(
              name: 'homeLongitude',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'additionalCities': _i1.ParameterDescription(
              name: 'additionalCities',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'onboardingCompleted': _i1.ParameterDescription(
              name: 'onboardingCompleted',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i22.UserProfileEndpoint)
                  .saveProfile(
                    session,
                    foodPhilosophy: params['foodPhilosophy'],
                    adventureLevel: params['adventureLevel'],
                    familiarCuisines: params['familiarCuisines'],
                    wantToTryCuisines: params['wantToTryCuisines'],
                    dietaryRestrictions: params['dietaryRestrictions'],
                    homeCity: params['homeCity'],
                    homeState: params['homeState'],
                    homeCountry: params['homeCountry'],
                    homeLatitude: params['homeLatitude'],
                    homeLongitude: params['homeLongitude'],
                    additionalCities: params['additionalCities'],
                    onboardingCompleted: params['onboardingCompleted'],
                  ),
        ),
        'completeOnboarding': _i1.MethodConnector(
          name: 'completeOnboarding',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i22.UserProfileEndpoint)
                  .completeOnboarding(session),
        ),
        'updateLocation': _i1.MethodConnector(
          name: 'updateLocation',
          params: {
            'city': _i1.ParameterDescription(
              name: 'city',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'state': _i1.ParameterDescription(
              name: 'state',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'country': _i1.ParameterDescription(
              name: 'country',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'latitude': _i1.ParameterDescription(
              name: 'latitude',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'longitude': _i1.ParameterDescription(
              name: 'longitude',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i22.UserProfileEndpoint)
                  .updateLocation(
                    session,
                    city: params['city'],
                    state: params['state'],
                    country: params['country'],
                    latitude: params['latitude'],
                    longitude: params['longitude'],
                  ),
        ),
        'updateFoodPhilosophy': _i1.MethodConnector(
          name: 'updateFoodPhilosophy',
          params: {
            'philosophy': _i1.ParameterDescription(
              name: 'philosophy',
              type: _i1.getType<_i27.FoodPhilosophy>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i22.UserProfileEndpoint)
                  .updateFoodPhilosophy(
                    session,
                    params['philosophy'],
                  ),
        ),
        'updateAdventureLevel': _i1.MethodConnector(
          name: 'updateAdventureLevel',
          params: {
            'level': _i1.ParameterDescription(
              name: 'level',
              type: _i1.getType<_i28.AdventureLevel>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i22.UserProfileEndpoint)
                  .updateAdventureLevel(
                    session,
                    params['level'],
                  ),
        ),
        'updateCuisinePreferences': _i1.MethodConnector(
          name: 'updateCuisinePreferences',
          params: {
            'familiar': _i1.ParameterDescription(
              name: 'familiar',
              type: _i1.getType<List<String>?>(),
              nullable: true,
            ),
            'wantToTry': _i1.ParameterDescription(
              name: 'wantToTry',
              type: _i1.getType<List<String>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i22.UserProfileEndpoint)
                  .updateCuisinePreferences(
                    session,
                    familiar: params['familiar'],
                    wantToTry: params['wantToTry'],
                  ),
        ),
        'updateDietaryRestrictions': _i1.MethodConnector(
          name: 'updateDietaryRestrictions',
          params: {
            'restrictions': _i1.ParameterDescription(
              name: 'restrictions',
              type: _i1.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i22.UserProfileEndpoint)
                  .updateDietaryRestrictions(
                    session,
                    params['restrictions'],
                  ),
        ),
        'updateAdditionalCities': _i1.MethodConnector(
          name: 'updateAdditionalCities',
          params: {
            'citiesJson': _i1.ParameterDescription(
              name: 'citiesJson',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i22.UserProfileEndpoint)
                  .updateAdditionalCities(
                    session,
                    params['citiesJson'],
                  ),
        ),
        'debugProfileStatus': _i1.MethodConnector(
          name: 'debugProfileStatus',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i22.UserProfileEndpoint)
                  .debugProfileStatus(session),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i29.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i30.Endpoints()
      ..initializeEndpoints(server);
  }

  @override
  _i1.FutureCallDispatch? get futureCalls {
    return _i31.FutureCalls();
  }
}
