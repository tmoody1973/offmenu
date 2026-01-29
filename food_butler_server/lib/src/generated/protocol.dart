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
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i3;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i4;
import 'analytics/reservation_click_event.dart' as _i5;
import 'analytics/reservation_link_type.dart' as _i6;
import 'awards/import_preview_item.dart' as _i7;
import 'awards/import_preview_result.dart' as _i8;
import 'awards/import_result.dart' as _i9;
import 'awards/review_queue_item.dart' as _i10;
import 'daily/daily_story.dart' as _i11;
import 'daily/daily_story_type.dart' as _i12;
import 'daily/tonight_picks_cache.dart' as _i13;
import 'discovery/cuisine_exploration_suggestion.dart' as _i14;
import 'discovery/discovered_place.dart' as _i15;
import 'discovery/food_discovery_response.dart' as _i16;
import 'empty_data.dart' as _i17;
import 'geocoding/place_details.dart' as _i18;
import 'geocoding/place_prediction.dart' as _i19;
import 'greetings/greeting.dart' as _i20;
import 'journal/journal_entry.dart' as _i21;
import 'journal/journal_photo.dart' as _i22;
import 'maps/curated_map.dart' as _i23;
import 'maps/favorite_city.dart' as _i24;
import 'maps/map_category.dart' as _i25;
import 'maps/map_restaurant.dart' as _i26;
import 'narratives/narrative_cache.dart' as _i27;
import 'narratives/narrative_regenerate_limit.dart' as _i28;
import 'narratives/narrative_response.dart' as _i29;
import 'narratives/narrative_type.dart' as _i30;
import 'places/city_prediction.dart' as _i31;
import 'places/restaurant_photo.dart' as _i32;
import 'saved_restaurant.dart' as _i33;
import 'saved_restaurant_source.dart' as _i34;
import 'tonight_pick.dart' as _i35;
import 'tours/award.dart' as _i36;
import 'tours/award_import_log.dart' as _i37;
import 'tours/award_type.dart' as _i38;
import 'tours/budget_tier.dart' as _i39;
import 'tours/cached_foursquare_response.dart' as _i40;
import 'tours/cached_route.dart' as _i41;
import 'tours/james_beard_award.dart' as _i42;
import 'tours/james_beard_distinction.dart' as _i43;
import 'tours/match_status.dart' as _i44;
import 'tours/michelin_award.dart' as _i45;
import 'tours/michelin_designation.dart' as _i46;
import 'tours/restaurant.dart' as _i47;
import 'tours/restaurant_award_link.dart' as _i48;
import 'tours/route_leg.dart' as _i49;
import 'tours/tour_request.dart' as _i50;
import 'tours/tour_result.dart' as _i51;
import 'tours/tour_stop.dart' as _i52;
import 'tours/tour_stop_alternative.dart' as _i53;
import 'tours/transport_mode.dart' as _i54;
import 'user/adventure_level.dart' as _i55;
import 'user/food_philosophy.dart' as _i56;
import 'user/user_profile.dart' as _i57;
import 'package:food_butler_server/src/generated/analytics/reservation_click_event.dart'
    as _i58;
import 'package:food_butler_server/src/generated/awards/review_queue_item.dart'
    as _i59;
import 'package:food_butler_server/src/generated/tours/award_import_log.dart'
    as _i60;
import 'package:food_butler_server/src/generated/tours/michelin_award.dart'
    as _i61;
import 'package:food_butler_server/src/generated/tours/james_beard_award.dart'
    as _i62;
import 'package:food_butler_server/src/generated/daily/daily_story.dart'
    as _i63;
import 'package:food_butler_server/src/generated/tonight_pick.dart' as _i64;
import 'package:food_butler_server/src/generated/geocoding/place_prediction.dart'
    as _i65;
import 'package:food_butler_server/src/generated/places/city_prediction.dart'
    as _i66;
import 'package:food_butler_server/src/generated/maps/curated_map.dart' as _i67;
import 'package:food_butler_server/src/generated/maps/map_restaurant.dart'
    as _i68;
import 'package:food_butler_server/src/generated/maps/favorite_city.dart'
    as _i69;
import 'package:food_butler_server/src/generated/saved_restaurant.dart' as _i70;
export 'analytics/reservation_click_event.dart';
export 'analytics/reservation_link_type.dart';
export 'awards/import_preview_item.dart';
export 'awards/import_preview_result.dart';
export 'awards/import_result.dart';
export 'awards/review_queue_item.dart';
export 'daily/daily_story.dart';
export 'daily/daily_story_type.dart';
export 'daily/tonight_picks_cache.dart';
export 'discovery/cuisine_exploration_suggestion.dart';
export 'discovery/discovered_place.dart';
export 'discovery/food_discovery_response.dart';
export 'empty_data.dart';
export 'geocoding/place_details.dart';
export 'geocoding/place_prediction.dart';
export 'greetings/greeting.dart';
export 'journal/journal_entry.dart';
export 'journal/journal_photo.dart';
export 'maps/curated_map.dart';
export 'maps/favorite_city.dart';
export 'maps/map_category.dart';
export 'maps/map_restaurant.dart';
export 'narratives/narrative_cache.dart';
export 'narratives/narrative_regenerate_limit.dart';
export 'narratives/narrative_response.dart';
export 'narratives/narrative_type.dart';
export 'places/city_prediction.dart';
export 'places/restaurant_photo.dart';
export 'saved_restaurant.dart';
export 'saved_restaurant_source.dart';
export 'tonight_pick.dart';
export 'tours/award.dart';
export 'tours/award_import_log.dart';
export 'tours/award_type.dart';
export 'tours/budget_tier.dart';
export 'tours/cached_foursquare_response.dart';
export 'tours/cached_route.dart';
export 'tours/james_beard_award.dart';
export 'tours/james_beard_distinction.dart';
export 'tours/match_status.dart';
export 'tours/michelin_award.dart';
export 'tours/michelin_designation.dart';
export 'tours/restaurant.dart';
export 'tours/restaurant_award_link.dart';
export 'tours/route_leg.dart';
export 'tours/tour_request.dart';
export 'tours/tour_result.dart';
export 'tours/tour_stop.dart';
export 'tours/tour_stop_alternative.dart';
export 'tours/transport_mode.dart';
export 'user/adventure_level.dart';
export 'user/food_philosophy.dart';
export 'user/user_profile.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'award_import_logs',
      dartName: 'AwardImportLog',
      schema: 'public',
      module: 'food_butler',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'award_import_logs_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'importType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:AwardType',
        ),
        _i2.ColumnDefinition(
          name: 'fileName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'recordsImported',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'recordsMatched',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'recordsPendingReview',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'importedByUserId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'award_import_logs_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'award_import_log_type_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'importType',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'award_import_log_created_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'award_import_log_user_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'importedByUserId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'awards',
      dartName: 'Award',
      schema: 'public',
      module: 'food_butler',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'awards_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'restaurantFsqId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'awardType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:AwardType',
        ),
        _i2.ColumnDefinition(
          name: 'awardLevel',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'year',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'awards_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'award_restaurant_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'restaurantFsqId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'award_type_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'awardType',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'award_year_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'year',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'cached_foursquare_responses',
      dartName: 'CachedFoursquareResponse',
      schema: 'public',
      module: 'food_butler',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'cached_foursquare_responses_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'cacheKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'responseData',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'expiresAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'cached_foursquare_responses_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'cached_foursquare_cache_key_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'cacheKey',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'cached_foursquare_expires_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'expiresAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'cached_routes',
      dartName: 'CachedRoute',
      schema: 'public',
      module: 'food_butler',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'cached_routes_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'waypointsHash',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'transportMode',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:TransportMode',
        ),
        _i2.ColumnDefinition(
          name: 'polyline',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'distanceMeters',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'durationSeconds',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'legsJson',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'expiresAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'cached_routes_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'cached_route_hash_mode_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'waypointsHash',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'transportMode',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'cached_route_expires_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'expiresAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'curated_maps',
      dartName: 'CuratedMap',
      schema: 'public',
      module: 'food_butler',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'curated_maps_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'isUserCreated',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'cityName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'stateOrRegion',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'country',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'slug',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'category',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'cuisineType',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'shortDescription',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'introText',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'coverImageUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'restaurantCount',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'lastUpdatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'isPublished',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'curated_maps_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'curated_map_city_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'cityName',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'curated_map_slug_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'slug',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'curated_map_category_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'category',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'curated_map_city_category_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'cityName',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'category',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'curated_map_user_id_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'daily_stories',
      dartName: 'DailyStory',
      schema: 'public',
      module: 'food_butler',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'daily_stories_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'storyDate',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'city',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'state',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'country',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'headline',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'subheadline',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'bodyText',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'restaurantName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'restaurantAddress',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'restaurantPlaceId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'heroImageUrl',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'thumbnailUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'storyType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:DailyStoryType',
        ),
        _i2.ColumnDefinition(
          name: 'cuisineType',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'sourceUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'daily_stories_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'daily_story_user_date_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'storyDate',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'favorite_cities',
      dartName: 'FavoriteCity',
      schema: 'public',
      module: 'food_butler',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'favorite_cities_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'cityName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'stateOrRegion',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'country',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'latitude',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'longitude',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'isHomeCity',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'displayOrder',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'favorite_cities_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'favorite_city_user_id_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'favorite_city_user_order_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'displayOrder',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'james_beard_awards',
      dartName: 'JamesBeardAward',
      schema: 'public',
      module: 'food_butler',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'james_beard_awards_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'city',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'category',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'distinctionLevel',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:JamesBeardDistinction',
        ),
        _i2.ColumnDefinition(
          name: 'awardYear',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'james_beard_awards_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'james_beard_name_city_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'name',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'city',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'james_beard_category_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'category',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'james_beard_distinction_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'distinctionLevel',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'james_beard_year_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'awardYear',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'journal_entries',
      dartName: 'JournalEntry',
      schema: 'public',
      module: 'food_butler',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'journal_entries_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'restaurantId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'tourId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'tourStopId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'rating',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'notes',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'visitedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'journal_entries_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'journal_entry_user_id_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'journal_entry_restaurant_id_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'restaurantId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'journal_entry_tour_id_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'tourId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'journal_entry_visited_at_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'visitedAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'journal_entry_user_visited_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'visitedAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'journal_photos',
      dartName: 'JournalPhoto',
      schema: 'public',
      module: 'food_butler',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'journal_photos_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'journalEntryId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'originalUrl',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'thumbnailUrl',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'displayOrder',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'uploadedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'journal_photos_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'journal_photo_entry_id_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'journalEntryId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'journal_photo_entry_order_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'journalEntryId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'displayOrder',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'map_restaurants',
      dartName: 'MapRestaurant',
      schema: 'public',
      module: 'food_butler',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'map_restaurants_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'mapId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'googlePlaceId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'editorialDescription',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'whyNotable',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'mustOrderDishes',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'priceLevel',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'cuisineTypes',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'address',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'city',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'stateOrRegion',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'postalCode',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'phoneNumber',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'websiteUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'reservationUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'latitude',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'longitude',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'primaryPhotoUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'additionalPhotosJson',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'googleRating',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'googleReviewCount',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'displayOrder',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'map_restaurants_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'map_restaurant_map_id_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'mapId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'map_restaurant_place_id_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'googlePlaceId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'map_restaurant_city_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'city',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'michelin_awards',
      dartName: 'MichelinAward',
      schema: 'public',
      module: 'food_butler',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'michelin_awards_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'restaurantName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'city',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'address',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'latitude',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'longitude',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'designation',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:MichelinDesignation',
        ),
        _i2.ColumnDefinition(
          name: 'awardYear',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'michelin_awards_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'michelin_name_city_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'restaurantName',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'city',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'michelin_designation_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'designation',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'michelin_year_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'awardYear',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'narrative_caches',
      dartName: 'NarrativeCache',
      schema: 'public',
      module: 'food_butler',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'narrative_caches_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'tourId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'narrativeType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'stopIndex',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'content',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'generatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'expiresAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'cacheHitCount',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'narrative_caches_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'narrative_cache_lookup_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'tourId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'narrativeType',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'stopIndex',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'narrative_cache_expires_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'expiresAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'narrative_cache_tour_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'tourId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'narrative_regenerate_limits',
      dartName: 'NarrativeRegenerateLimit',
      schema: 'public',
      module: 'food_butler',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'narrative_regenerate_limits_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'tourId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'limitDate',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'attemptCount',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'narrative_regenerate_limits_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'narrative_regenerate_lookup_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'tourId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'limitDate',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'narrative_regenerate_date_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'limitDate',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'reservation_click_events',
      dartName: 'ReservationClickEvent',
      schema: 'public',
      module: 'food_butler',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'reservation_click_events_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'restaurantId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'linkType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ReservationLinkType',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'launchSuccess',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'timestamp',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'reservation_click_events_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'reservation_click_restaurant_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'restaurantId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'reservation_click_timestamp_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'timestamp',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'reservation_click_link_type_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'linkType',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'restaurant_award_links',
      dartName: 'RestaurantAwardLink',
      schema: 'public',
      module: 'food_butler',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'restaurant_award_links_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'restaurantId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'awardType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:AwardType',
        ),
        _i2.ColumnDefinition(
          name: 'awardId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'matchConfidenceScore',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'matchStatus',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:MatchStatus',
        ),
        _i2.ColumnDefinition(
          name: 'matchedByUserId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'restaurant_award_links_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'restaurant_award_link_restaurant_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'restaurantId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'restaurant_award_link_status_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'matchStatus',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'restaurant_award_link_type_award_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'awardType',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'awardId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'restaurants',
      dartName: 'Restaurant',
      schema: 'public',
      module: 'food_butler',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'restaurants_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'fsqId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'address',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'latitude',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'longitude',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'priceTier',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'rating',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'cuisineTypes',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'hours',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'dishData',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'opentableId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'opentableSlug',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'phone',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'websiteUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'restaurants_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'restaurant_fsq_id_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'fsqId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'restaurant_coordinates_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'latitude',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'longitude',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'restaurant_price_tier_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'priceTier',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'restaurant_opentable_id_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'opentableId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'saved_restaurants',
      dartName: 'SavedRestaurant',
      schema: 'public',
      module: 'food_butler',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'saved_restaurants_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'placeId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'address',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'cuisineType',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'imageUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'rating',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'priceLevel',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'notes',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'userRating',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'source',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:SavedRestaurantSource',
        ),
        _i2.ColumnDefinition(
          name: 'savedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'saved_restaurants_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'saved_restaurant_user_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'saved_restaurant_user_place_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'placeId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'tonight_picks_cache',
      dartName: 'TonightPicksCache',
      schema: 'public',
      module: 'food_butler',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'tonight_picks_cache_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'cacheDate',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'city',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'state',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'mealContext',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'picksJson',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'tonight_picks_cache_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'tonight_cache_user_date_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'cacheDate',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'tour_requests',
      dartName: 'TourRequest',
      schema: 'public',
      module: 'food_butler',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'tour_requests_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'startLatitude',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'startLongitude',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'startAddress',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'numStops',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'transportMode',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:TransportMode',
        ),
        _i2.ColumnDefinition(
          name: 'cuisinePreferences',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'List<String>?',
        ),
        _i2.ColumnDefinition(
          name: 'awardOnly',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'startTime',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'endTime',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'budgetTier',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:BudgetTier',
        ),
        _i2.ColumnDefinition(
          name: 'specificDish',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'tour_requests_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'tour_request_created_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'tour_results',
      dartName: 'TourResult',
      schema: 'public',
      module: 'food_butler',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'tour_results_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'requestId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'stopsJson',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'confidenceScore',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'routePolyline',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'routeLegsJson',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'totalDistanceMeters',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'totalDurationSeconds',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'isPartialTour',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'warningMessage',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'tourTitle',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'tourIntroduction',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'tourVibe',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'tourClosing',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'curatedTourJson',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'tour_results_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'tour_result_request_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'requestId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'tour_result_created_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'user_profiles',
      dartName: 'UserProfile',
      schema: 'public',
      module: 'food_butler',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'user_profiles_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'foodPhilosophy',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:FoodPhilosophy?',
        ),
        _i2.ColumnDefinition(
          name: 'adventureLevel',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:AdventureLevel?',
        ),
        _i2.ColumnDefinition(
          name: 'familiarCuisines',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'wantToTryCuisines',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'dietaryRestrictions',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'homeCity',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'homeState',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'homeCountry',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'homeLatitude',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'homeLongitude',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'additionalCities',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'onboardingCompleted',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'user_profiles_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'user_profile_user_id_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'user_profile_home_city_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'homeCity',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
    ..._i4.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i5.ReservationClickEvent) {
      return _i5.ReservationClickEvent.fromJson(data) as T;
    }
    if (t == _i6.ReservationLinkType) {
      return _i6.ReservationLinkType.fromJson(data) as T;
    }
    if (t == _i7.ImportPreviewItem) {
      return _i7.ImportPreviewItem.fromJson(data) as T;
    }
    if (t == _i8.ImportPreviewResult) {
      return _i8.ImportPreviewResult.fromJson(data) as T;
    }
    if (t == _i9.ImportResult) {
      return _i9.ImportResult.fromJson(data) as T;
    }
    if (t == _i10.ReviewQueueItem) {
      return _i10.ReviewQueueItem.fromJson(data) as T;
    }
    if (t == _i11.DailyStory) {
      return _i11.DailyStory.fromJson(data) as T;
    }
    if (t == _i12.DailyStoryType) {
      return _i12.DailyStoryType.fromJson(data) as T;
    }
    if (t == _i13.TonightPicksCache) {
      return _i13.TonightPicksCache.fromJson(data) as T;
    }
    if (t == _i14.CuisineExplorationSuggestion) {
      return _i14.CuisineExplorationSuggestion.fromJson(data) as T;
    }
    if (t == _i15.DiscoveredPlace) {
      return _i15.DiscoveredPlace.fromJson(data) as T;
    }
    if (t == _i16.FoodDiscoveryResponse) {
      return _i16.FoodDiscoveryResponse.fromJson(data) as T;
    }
    if (t == _i17.EmptyData) {
      return _i17.EmptyData.fromJson(data) as T;
    }
    if (t == _i18.PlaceDetails) {
      return _i18.PlaceDetails.fromJson(data) as T;
    }
    if (t == _i19.PlacePrediction) {
      return _i19.PlacePrediction.fromJson(data) as T;
    }
    if (t == _i20.Greeting) {
      return _i20.Greeting.fromJson(data) as T;
    }
    if (t == _i21.JournalEntry) {
      return _i21.JournalEntry.fromJson(data) as T;
    }
    if (t == _i22.JournalPhoto) {
      return _i22.JournalPhoto.fromJson(data) as T;
    }
    if (t == _i23.CuratedMap) {
      return _i23.CuratedMap.fromJson(data) as T;
    }
    if (t == _i24.FavoriteCity) {
      return _i24.FavoriteCity.fromJson(data) as T;
    }
    if (t == _i25.MapCategory) {
      return _i25.MapCategory.fromJson(data) as T;
    }
    if (t == _i26.MapRestaurant) {
      return _i26.MapRestaurant.fromJson(data) as T;
    }
    if (t == _i27.NarrativeCache) {
      return _i27.NarrativeCache.fromJson(data) as T;
    }
    if (t == _i28.NarrativeRegenerateLimit) {
      return _i28.NarrativeRegenerateLimit.fromJson(data) as T;
    }
    if (t == _i29.NarrativeResponse) {
      return _i29.NarrativeResponse.fromJson(data) as T;
    }
    if (t == _i30.NarrativeType) {
      return _i30.NarrativeType.fromJson(data) as T;
    }
    if (t == _i31.CityPrediction) {
      return _i31.CityPrediction.fromJson(data) as T;
    }
    if (t == _i32.RestaurantPhoto) {
      return _i32.RestaurantPhoto.fromJson(data) as T;
    }
    if (t == _i33.SavedRestaurant) {
      return _i33.SavedRestaurant.fromJson(data) as T;
    }
    if (t == _i34.SavedRestaurantSource) {
      return _i34.SavedRestaurantSource.fromJson(data) as T;
    }
    if (t == _i35.TonightPick) {
      return _i35.TonightPick.fromJson(data) as T;
    }
    if (t == _i36.Award) {
      return _i36.Award.fromJson(data) as T;
    }
    if (t == _i37.AwardImportLog) {
      return _i37.AwardImportLog.fromJson(data) as T;
    }
    if (t == _i38.AwardType) {
      return _i38.AwardType.fromJson(data) as T;
    }
    if (t == _i39.BudgetTier) {
      return _i39.BudgetTier.fromJson(data) as T;
    }
    if (t == _i40.CachedFoursquareResponse) {
      return _i40.CachedFoursquareResponse.fromJson(data) as T;
    }
    if (t == _i41.CachedRoute) {
      return _i41.CachedRoute.fromJson(data) as T;
    }
    if (t == _i42.JamesBeardAward) {
      return _i42.JamesBeardAward.fromJson(data) as T;
    }
    if (t == _i43.JamesBeardDistinction) {
      return _i43.JamesBeardDistinction.fromJson(data) as T;
    }
    if (t == _i44.MatchStatus) {
      return _i44.MatchStatus.fromJson(data) as T;
    }
    if (t == _i45.MichelinAward) {
      return _i45.MichelinAward.fromJson(data) as T;
    }
    if (t == _i46.MichelinDesignation) {
      return _i46.MichelinDesignation.fromJson(data) as T;
    }
    if (t == _i47.Restaurant) {
      return _i47.Restaurant.fromJson(data) as T;
    }
    if (t == _i48.RestaurantAwardLink) {
      return _i48.RestaurantAwardLink.fromJson(data) as T;
    }
    if (t == _i49.RouteLeg) {
      return _i49.RouteLeg.fromJson(data) as T;
    }
    if (t == _i50.TourRequest) {
      return _i50.TourRequest.fromJson(data) as T;
    }
    if (t == _i51.TourResult) {
      return _i51.TourResult.fromJson(data) as T;
    }
    if (t == _i52.TourStop) {
      return _i52.TourStop.fromJson(data) as T;
    }
    if (t == _i53.TourStopAlternative) {
      return _i53.TourStopAlternative.fromJson(data) as T;
    }
    if (t == _i54.TransportMode) {
      return _i54.TransportMode.fromJson(data) as T;
    }
    if (t == _i55.AdventureLevel) {
      return _i55.AdventureLevel.fromJson(data) as T;
    }
    if (t == _i56.FoodPhilosophy) {
      return _i56.FoodPhilosophy.fromJson(data) as T;
    }
    if (t == _i57.UserProfile) {
      return _i57.UserProfile.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.ReservationClickEvent?>()) {
      return (data != null ? _i5.ReservationClickEvent.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i6.ReservationLinkType?>()) {
      return (data != null ? _i6.ReservationLinkType.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i7.ImportPreviewItem?>()) {
      return (data != null ? _i7.ImportPreviewItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.ImportPreviewResult?>()) {
      return (data != null ? _i8.ImportPreviewResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i9.ImportResult?>()) {
      return (data != null ? _i9.ImportResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.ReviewQueueItem?>()) {
      return (data != null ? _i10.ReviewQueueItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.DailyStory?>()) {
      return (data != null ? _i11.DailyStory.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.DailyStoryType?>()) {
      return (data != null ? _i12.DailyStoryType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.TonightPicksCache?>()) {
      return (data != null ? _i13.TonightPicksCache.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.CuisineExplorationSuggestion?>()) {
      return (data != null
              ? _i14.CuisineExplorationSuggestion.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i15.DiscoveredPlace?>()) {
      return (data != null ? _i15.DiscoveredPlace.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.FoodDiscoveryResponse?>()) {
      return (data != null ? _i16.FoodDiscoveryResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i17.EmptyData?>()) {
      return (data != null ? _i17.EmptyData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.PlaceDetails?>()) {
      return (data != null ? _i18.PlaceDetails.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.PlacePrediction?>()) {
      return (data != null ? _i19.PlacePrediction.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.Greeting?>()) {
      return (data != null ? _i20.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.JournalEntry?>()) {
      return (data != null ? _i21.JournalEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.JournalPhoto?>()) {
      return (data != null ? _i22.JournalPhoto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.CuratedMap?>()) {
      return (data != null ? _i23.CuratedMap.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.FavoriteCity?>()) {
      return (data != null ? _i24.FavoriteCity.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.MapCategory?>()) {
      return (data != null ? _i25.MapCategory.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.MapRestaurant?>()) {
      return (data != null ? _i26.MapRestaurant.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.NarrativeCache?>()) {
      return (data != null ? _i27.NarrativeCache.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.NarrativeRegenerateLimit?>()) {
      return (data != null
              ? _i28.NarrativeRegenerateLimit.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i29.NarrativeResponse?>()) {
      return (data != null ? _i29.NarrativeResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.NarrativeType?>()) {
      return (data != null ? _i30.NarrativeType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.CityPrediction?>()) {
      return (data != null ? _i31.CityPrediction.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.RestaurantPhoto?>()) {
      return (data != null ? _i32.RestaurantPhoto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.SavedRestaurant?>()) {
      return (data != null ? _i33.SavedRestaurant.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.SavedRestaurantSource?>()) {
      return (data != null ? _i34.SavedRestaurantSource.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i35.TonightPick?>()) {
      return (data != null ? _i35.TonightPick.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i36.Award?>()) {
      return (data != null ? _i36.Award.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i37.AwardImportLog?>()) {
      return (data != null ? _i37.AwardImportLog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i38.AwardType?>()) {
      return (data != null ? _i38.AwardType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i39.BudgetTier?>()) {
      return (data != null ? _i39.BudgetTier.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.CachedFoursquareResponse?>()) {
      return (data != null
              ? _i40.CachedFoursquareResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i41.CachedRoute?>()) {
      return (data != null ? _i41.CachedRoute.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i42.JamesBeardAward?>()) {
      return (data != null ? _i42.JamesBeardAward.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i43.JamesBeardDistinction?>()) {
      return (data != null ? _i43.JamesBeardDistinction.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i44.MatchStatus?>()) {
      return (data != null ? _i44.MatchStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i45.MichelinAward?>()) {
      return (data != null ? _i45.MichelinAward.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i46.MichelinDesignation?>()) {
      return (data != null ? _i46.MichelinDesignation.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i47.Restaurant?>()) {
      return (data != null ? _i47.Restaurant.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i48.RestaurantAwardLink?>()) {
      return (data != null ? _i48.RestaurantAwardLink.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i49.RouteLeg?>()) {
      return (data != null ? _i49.RouteLeg.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i50.TourRequest?>()) {
      return (data != null ? _i50.TourRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i51.TourResult?>()) {
      return (data != null ? _i51.TourResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i52.TourStop?>()) {
      return (data != null ? _i52.TourStop.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i53.TourStopAlternative?>()) {
      return (data != null ? _i53.TourStopAlternative.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i54.TransportMode?>()) {
      return (data != null ? _i54.TransportMode.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i55.AdventureLevel?>()) {
      return (data != null ? _i55.AdventureLevel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i56.FoodPhilosophy?>()) {
      return (data != null ? _i56.FoodPhilosophy.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i57.UserProfile?>()) {
      return (data != null ? _i57.UserProfile.fromJson(data) : null) as T;
    }
    if (t == List<_i7.ImportPreviewItem>) {
      return (data as List)
              .map((e) => deserialize<_i7.ImportPreviewItem>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i15.DiscoveredPlace>) {
      return (data as List)
              .map((e) => deserialize<_i15.DiscoveredPlace>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i53.TourStopAlternative>) {
      return (data as List)
              .map((e) => deserialize<_i53.TourStopAlternative>(e))
              .toList()
          as T;
    }
    if (t == List<_i58.ReservationClickEvent>) {
      return (data as List)
              .map((e) => deserialize<_i58.ReservationClickEvent>(e))
              .toList()
          as T;
    }
    if (t == Map<String, int>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)),
          )
          as T;
    }
    if (t == List<_i59.ReviewQueueItem>) {
      return (data as List)
              .map((e) => deserialize<_i59.ReviewQueueItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i60.AwardImportLog>) {
      return (data as List)
              .map((e) => deserialize<_i60.AwardImportLog>(e))
              .toList()
          as T;
    }
    if (t == List<Map<String, dynamic>>) {
      return (data as List)
              .map((e) => deserialize<Map<String, dynamic>>(e))
              .toList()
          as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
          )
          as T;
    }
    if (t == List<_i61.MichelinAward>) {
      return (data as List)
              .map((e) => deserialize<_i61.MichelinAward>(e))
              .toList()
          as T;
    }
    if (t == List<_i62.JamesBeardAward>) {
      return (data as List)
              .map((e) => deserialize<_i62.JamesBeardAward>(e))
              .toList()
          as T;
    }
    if (t == List<_i63.DailyStory>) {
      return (data as List).map((e) => deserialize<_i63.DailyStory>(e)).toList()
          as T;
    }
    if (t == List<_i64.TonightPick>) {
      return (data as List)
              .map((e) => deserialize<_i64.TonightPick>(e))
              .toList()
          as T;
    }
    if (t == List<_i65.PlacePrediction>) {
      return (data as List)
              .map((e) => deserialize<_i65.PlacePrediction>(e))
              .toList()
          as T;
    }
    if (t == List<_i66.CityPrediction>) {
      return (data as List)
              .map((e) => deserialize<_i66.CityPrediction>(e))
              .toList()
          as T;
    }
    if (t == List<_i67.CuratedMap>) {
      return (data as List).map((e) => deserialize<_i67.CuratedMap>(e)).toList()
          as T;
    }
    if (t == List<_i68.MapRestaurant>) {
      return (data as List)
              .map((e) => deserialize<_i68.MapRestaurant>(e))
              .toList()
          as T;
    }
    if (t == List<_i69.FavoriteCity>) {
      return (data as List)
              .map((e) => deserialize<_i69.FavoriteCity>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i70.SavedRestaurant>) {
      return (data as List)
              .map((e) => deserialize<_i70.SavedRestaurant>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i5.ReservationClickEvent => 'ReservationClickEvent',
      _i6.ReservationLinkType => 'ReservationLinkType',
      _i7.ImportPreviewItem => 'ImportPreviewItem',
      _i8.ImportPreviewResult => 'ImportPreviewResult',
      _i9.ImportResult => 'ImportResult',
      _i10.ReviewQueueItem => 'ReviewQueueItem',
      _i11.DailyStory => 'DailyStory',
      _i12.DailyStoryType => 'DailyStoryType',
      _i13.TonightPicksCache => 'TonightPicksCache',
      _i14.CuisineExplorationSuggestion => 'CuisineExplorationSuggestion',
      _i15.DiscoveredPlace => 'DiscoveredPlace',
      _i16.FoodDiscoveryResponse => 'FoodDiscoveryResponse',
      _i17.EmptyData => 'EmptyData',
      _i18.PlaceDetails => 'PlaceDetails',
      _i19.PlacePrediction => 'PlacePrediction',
      _i20.Greeting => 'Greeting',
      _i21.JournalEntry => 'JournalEntry',
      _i22.JournalPhoto => 'JournalPhoto',
      _i23.CuratedMap => 'CuratedMap',
      _i24.FavoriteCity => 'FavoriteCity',
      _i25.MapCategory => 'MapCategory',
      _i26.MapRestaurant => 'MapRestaurant',
      _i27.NarrativeCache => 'NarrativeCache',
      _i28.NarrativeRegenerateLimit => 'NarrativeRegenerateLimit',
      _i29.NarrativeResponse => 'NarrativeResponse',
      _i30.NarrativeType => 'NarrativeType',
      _i31.CityPrediction => 'CityPrediction',
      _i32.RestaurantPhoto => 'RestaurantPhoto',
      _i33.SavedRestaurant => 'SavedRestaurant',
      _i34.SavedRestaurantSource => 'SavedRestaurantSource',
      _i35.TonightPick => 'TonightPick',
      _i36.Award => 'Award',
      _i37.AwardImportLog => 'AwardImportLog',
      _i38.AwardType => 'AwardType',
      _i39.BudgetTier => 'BudgetTier',
      _i40.CachedFoursquareResponse => 'CachedFoursquareResponse',
      _i41.CachedRoute => 'CachedRoute',
      _i42.JamesBeardAward => 'JamesBeardAward',
      _i43.JamesBeardDistinction => 'JamesBeardDistinction',
      _i44.MatchStatus => 'MatchStatus',
      _i45.MichelinAward => 'MichelinAward',
      _i46.MichelinDesignation => 'MichelinDesignation',
      _i47.Restaurant => 'Restaurant',
      _i48.RestaurantAwardLink => 'RestaurantAwardLink',
      _i49.RouteLeg => 'RouteLeg',
      _i50.TourRequest => 'TourRequest',
      _i51.TourResult => 'TourResult',
      _i52.TourStop => 'TourStop',
      _i53.TourStopAlternative => 'TourStopAlternative',
      _i54.TransportMode => 'TransportMode',
      _i55.AdventureLevel => 'AdventureLevel',
      _i56.FoodPhilosophy => 'FoodPhilosophy',
      _i57.UserProfile => 'UserProfile',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('food_butler.', '');
    }

    switch (data) {
      case _i5.ReservationClickEvent():
        return 'ReservationClickEvent';
      case _i6.ReservationLinkType():
        return 'ReservationLinkType';
      case _i7.ImportPreviewItem():
        return 'ImportPreviewItem';
      case _i8.ImportPreviewResult():
        return 'ImportPreviewResult';
      case _i9.ImportResult():
        return 'ImportResult';
      case _i10.ReviewQueueItem():
        return 'ReviewQueueItem';
      case _i11.DailyStory():
        return 'DailyStory';
      case _i12.DailyStoryType():
        return 'DailyStoryType';
      case _i13.TonightPicksCache():
        return 'TonightPicksCache';
      case _i14.CuisineExplorationSuggestion():
        return 'CuisineExplorationSuggestion';
      case _i15.DiscoveredPlace():
        return 'DiscoveredPlace';
      case _i16.FoodDiscoveryResponse():
        return 'FoodDiscoveryResponse';
      case _i17.EmptyData():
        return 'EmptyData';
      case _i18.PlaceDetails():
        return 'PlaceDetails';
      case _i19.PlacePrediction():
        return 'PlacePrediction';
      case _i20.Greeting():
        return 'Greeting';
      case _i21.JournalEntry():
        return 'JournalEntry';
      case _i22.JournalPhoto():
        return 'JournalPhoto';
      case _i23.CuratedMap():
        return 'CuratedMap';
      case _i24.FavoriteCity():
        return 'FavoriteCity';
      case _i25.MapCategory():
        return 'MapCategory';
      case _i26.MapRestaurant():
        return 'MapRestaurant';
      case _i27.NarrativeCache():
        return 'NarrativeCache';
      case _i28.NarrativeRegenerateLimit():
        return 'NarrativeRegenerateLimit';
      case _i29.NarrativeResponse():
        return 'NarrativeResponse';
      case _i30.NarrativeType():
        return 'NarrativeType';
      case _i31.CityPrediction():
        return 'CityPrediction';
      case _i32.RestaurantPhoto():
        return 'RestaurantPhoto';
      case _i33.SavedRestaurant():
        return 'SavedRestaurant';
      case _i34.SavedRestaurantSource():
        return 'SavedRestaurantSource';
      case _i35.TonightPick():
        return 'TonightPick';
      case _i36.Award():
        return 'Award';
      case _i37.AwardImportLog():
        return 'AwardImportLog';
      case _i38.AwardType():
        return 'AwardType';
      case _i39.BudgetTier():
        return 'BudgetTier';
      case _i40.CachedFoursquareResponse():
        return 'CachedFoursquareResponse';
      case _i41.CachedRoute():
        return 'CachedRoute';
      case _i42.JamesBeardAward():
        return 'JamesBeardAward';
      case _i43.JamesBeardDistinction():
        return 'JamesBeardDistinction';
      case _i44.MatchStatus():
        return 'MatchStatus';
      case _i45.MichelinAward():
        return 'MichelinAward';
      case _i46.MichelinDesignation():
        return 'MichelinDesignation';
      case _i47.Restaurant():
        return 'Restaurant';
      case _i48.RestaurantAwardLink():
        return 'RestaurantAwardLink';
      case _i49.RouteLeg():
        return 'RouteLeg';
      case _i50.TourRequest():
        return 'TourRequest';
      case _i51.TourResult():
        return 'TourResult';
      case _i52.TourStop():
        return 'TourStop';
      case _i53.TourStopAlternative():
        return 'TourStopAlternative';
      case _i54.TransportMode():
        return 'TransportMode';
      case _i55.AdventureLevel():
        return 'AdventureLevel';
      case _i56.FoodPhilosophy():
        return 'FoodPhilosophy';
      case _i57.UserProfile():
        return 'UserProfile';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i4.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'ReservationClickEvent') {
      return deserialize<_i5.ReservationClickEvent>(data['data']);
    }
    if (dataClassName == 'ReservationLinkType') {
      return deserialize<_i6.ReservationLinkType>(data['data']);
    }
    if (dataClassName == 'ImportPreviewItem') {
      return deserialize<_i7.ImportPreviewItem>(data['data']);
    }
    if (dataClassName == 'ImportPreviewResult') {
      return deserialize<_i8.ImportPreviewResult>(data['data']);
    }
    if (dataClassName == 'ImportResult') {
      return deserialize<_i9.ImportResult>(data['data']);
    }
    if (dataClassName == 'ReviewQueueItem') {
      return deserialize<_i10.ReviewQueueItem>(data['data']);
    }
    if (dataClassName == 'DailyStory') {
      return deserialize<_i11.DailyStory>(data['data']);
    }
    if (dataClassName == 'DailyStoryType') {
      return deserialize<_i12.DailyStoryType>(data['data']);
    }
    if (dataClassName == 'TonightPicksCache') {
      return deserialize<_i13.TonightPicksCache>(data['data']);
    }
    if (dataClassName == 'CuisineExplorationSuggestion') {
      return deserialize<_i14.CuisineExplorationSuggestion>(data['data']);
    }
    if (dataClassName == 'DiscoveredPlace') {
      return deserialize<_i15.DiscoveredPlace>(data['data']);
    }
    if (dataClassName == 'FoodDiscoveryResponse') {
      return deserialize<_i16.FoodDiscoveryResponse>(data['data']);
    }
    if (dataClassName == 'EmptyData') {
      return deserialize<_i17.EmptyData>(data['data']);
    }
    if (dataClassName == 'PlaceDetails') {
      return deserialize<_i18.PlaceDetails>(data['data']);
    }
    if (dataClassName == 'PlacePrediction') {
      return deserialize<_i19.PlacePrediction>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i20.Greeting>(data['data']);
    }
    if (dataClassName == 'JournalEntry') {
      return deserialize<_i21.JournalEntry>(data['data']);
    }
    if (dataClassName == 'JournalPhoto') {
      return deserialize<_i22.JournalPhoto>(data['data']);
    }
    if (dataClassName == 'CuratedMap') {
      return deserialize<_i23.CuratedMap>(data['data']);
    }
    if (dataClassName == 'FavoriteCity') {
      return deserialize<_i24.FavoriteCity>(data['data']);
    }
    if (dataClassName == 'MapCategory') {
      return deserialize<_i25.MapCategory>(data['data']);
    }
    if (dataClassName == 'MapRestaurant') {
      return deserialize<_i26.MapRestaurant>(data['data']);
    }
    if (dataClassName == 'NarrativeCache') {
      return deserialize<_i27.NarrativeCache>(data['data']);
    }
    if (dataClassName == 'NarrativeRegenerateLimit') {
      return deserialize<_i28.NarrativeRegenerateLimit>(data['data']);
    }
    if (dataClassName == 'NarrativeResponse') {
      return deserialize<_i29.NarrativeResponse>(data['data']);
    }
    if (dataClassName == 'NarrativeType') {
      return deserialize<_i30.NarrativeType>(data['data']);
    }
    if (dataClassName == 'CityPrediction') {
      return deserialize<_i31.CityPrediction>(data['data']);
    }
    if (dataClassName == 'RestaurantPhoto') {
      return deserialize<_i32.RestaurantPhoto>(data['data']);
    }
    if (dataClassName == 'SavedRestaurant') {
      return deserialize<_i33.SavedRestaurant>(data['data']);
    }
    if (dataClassName == 'SavedRestaurantSource') {
      return deserialize<_i34.SavedRestaurantSource>(data['data']);
    }
    if (dataClassName == 'TonightPick') {
      return deserialize<_i35.TonightPick>(data['data']);
    }
    if (dataClassName == 'Award') {
      return deserialize<_i36.Award>(data['data']);
    }
    if (dataClassName == 'AwardImportLog') {
      return deserialize<_i37.AwardImportLog>(data['data']);
    }
    if (dataClassName == 'AwardType') {
      return deserialize<_i38.AwardType>(data['data']);
    }
    if (dataClassName == 'BudgetTier') {
      return deserialize<_i39.BudgetTier>(data['data']);
    }
    if (dataClassName == 'CachedFoursquareResponse') {
      return deserialize<_i40.CachedFoursquareResponse>(data['data']);
    }
    if (dataClassName == 'CachedRoute') {
      return deserialize<_i41.CachedRoute>(data['data']);
    }
    if (dataClassName == 'JamesBeardAward') {
      return deserialize<_i42.JamesBeardAward>(data['data']);
    }
    if (dataClassName == 'JamesBeardDistinction') {
      return deserialize<_i43.JamesBeardDistinction>(data['data']);
    }
    if (dataClassName == 'MatchStatus') {
      return deserialize<_i44.MatchStatus>(data['data']);
    }
    if (dataClassName == 'MichelinAward') {
      return deserialize<_i45.MichelinAward>(data['data']);
    }
    if (dataClassName == 'MichelinDesignation') {
      return deserialize<_i46.MichelinDesignation>(data['data']);
    }
    if (dataClassName == 'Restaurant') {
      return deserialize<_i47.Restaurant>(data['data']);
    }
    if (dataClassName == 'RestaurantAwardLink') {
      return deserialize<_i48.RestaurantAwardLink>(data['data']);
    }
    if (dataClassName == 'RouteLeg') {
      return deserialize<_i49.RouteLeg>(data['data']);
    }
    if (dataClassName == 'TourRequest') {
      return deserialize<_i50.TourRequest>(data['data']);
    }
    if (dataClassName == 'TourResult') {
      return deserialize<_i51.TourResult>(data['data']);
    }
    if (dataClassName == 'TourStop') {
      return deserialize<_i52.TourStop>(data['data']);
    }
    if (dataClassName == 'TourStopAlternative') {
      return deserialize<_i53.TourStopAlternative>(data['data']);
    }
    if (dataClassName == 'TransportMode') {
      return deserialize<_i54.TransportMode>(data['data']);
    }
    if (dataClassName == 'AdventureLevel') {
      return deserialize<_i55.AdventureLevel>(data['data']);
    }
    if (dataClassName == 'FoodPhilosophy') {
      return deserialize<_i56.FoodPhilosophy>(data['data']);
    }
    if (dataClassName == 'UserProfile') {
      return deserialize<_i57.UserProfile>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i4.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i4.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i5.ReservationClickEvent:
        return _i5.ReservationClickEvent.t;
      case _i11.DailyStory:
        return _i11.DailyStory.t;
      case _i13.TonightPicksCache:
        return _i13.TonightPicksCache.t;
      case _i21.JournalEntry:
        return _i21.JournalEntry.t;
      case _i22.JournalPhoto:
        return _i22.JournalPhoto.t;
      case _i23.CuratedMap:
        return _i23.CuratedMap.t;
      case _i24.FavoriteCity:
        return _i24.FavoriteCity.t;
      case _i26.MapRestaurant:
        return _i26.MapRestaurant.t;
      case _i27.NarrativeCache:
        return _i27.NarrativeCache.t;
      case _i28.NarrativeRegenerateLimit:
        return _i28.NarrativeRegenerateLimit.t;
      case _i33.SavedRestaurant:
        return _i33.SavedRestaurant.t;
      case _i36.Award:
        return _i36.Award.t;
      case _i37.AwardImportLog:
        return _i37.AwardImportLog.t;
      case _i40.CachedFoursquareResponse:
        return _i40.CachedFoursquareResponse.t;
      case _i41.CachedRoute:
        return _i41.CachedRoute.t;
      case _i42.JamesBeardAward:
        return _i42.JamesBeardAward.t;
      case _i45.MichelinAward:
        return _i45.MichelinAward.t;
      case _i47.Restaurant:
        return _i47.Restaurant.t;
      case _i48.RestaurantAwardLink:
        return _i48.RestaurantAwardLink.t;
      case _i50.TourRequest:
        return _i50.TourRequest.t;
      case _i51.TourResult:
        return _i51.TourResult.t;
      case _i57.UserProfile:
        return _i57.UserProfile.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'food_butler';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i3.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i4.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
