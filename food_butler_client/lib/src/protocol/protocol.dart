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
import 'analytics/reservation_click_event.dart' as _i2;
import 'analytics/reservation_link_type.dart' as _i3;
import 'awards/import_preview_item.dart' as _i4;
import 'awards/import_preview_result.dart' as _i5;
import 'awards/import_result.dart' as _i6;
import 'awards/review_queue_item.dart' as _i7;
import 'daily/daily_story.dart' as _i8;
import 'daily/daily_story_type.dart' as _i9;
import 'daily/tonight_picks_cache.dart' as _i10;
import 'discovery/discovered_place.dart' as _i11;
import 'discovery/food_discovery_response.dart' as _i12;
import 'geocoding/place_details.dart' as _i13;
import 'geocoding/place_prediction.dart' as _i14;
import 'greetings/greeting.dart' as _i15;
import 'journal/journal_entry.dart' as _i16;
import 'journal/journal_photo.dart' as _i17;
import 'maps/curated_map.dart' as _i18;
import 'maps/favorite_city.dart' as _i19;
import 'maps/map_category.dart' as _i20;
import 'maps/map_restaurant.dart' as _i21;
import 'narratives/narrative_cache.dart' as _i22;
import 'narratives/narrative_regenerate_limit.dart' as _i23;
import 'narratives/narrative_response.dart' as _i24;
import 'narratives/narrative_type.dart' as _i25;
import 'places/city_prediction.dart' as _i26;
import 'places/restaurant_photo.dart' as _i27;
import 'saved_restaurant.dart' as _i28;
import 'saved_restaurant_source.dart' as _i29;
import 'tonight_pick.dart' as _i30;
import 'tours/award.dart' as _i31;
import 'tours/award_import_log.dart' as _i32;
import 'tours/award_type.dart' as _i33;
import 'tours/budget_tier.dart' as _i34;
import 'tours/cached_foursquare_response.dart' as _i35;
import 'tours/cached_route.dart' as _i36;
import 'tours/james_beard_award.dart' as _i37;
import 'tours/james_beard_distinction.dart' as _i38;
import 'tours/match_status.dart' as _i39;
import 'tours/michelin_award.dart' as _i40;
import 'tours/michelin_designation.dart' as _i41;
import 'tours/restaurant.dart' as _i42;
import 'tours/restaurant_award_link.dart' as _i43;
import 'tours/route_leg.dart' as _i44;
import 'tours/tour_request.dart' as _i45;
import 'tours/tour_result.dart' as _i46;
import 'tours/tour_stop.dart' as _i47;
import 'tours/tour_stop_alternative.dart' as _i48;
import 'tours/transport_mode.dart' as _i49;
import 'user/adventure_level.dart' as _i50;
import 'user/food_philosophy.dart' as _i51;
import 'user/user_profile.dart' as _i52;
import 'package:food_butler_client/src/protocol/analytics/reservation_click_event.dart'
    as _i53;
import 'package:food_butler_client/src/protocol/awards/review_queue_item.dart'
    as _i54;
import 'package:food_butler_client/src/protocol/tours/award_import_log.dart'
    as _i55;
import 'package:food_butler_client/src/protocol/tours/michelin_award.dart'
    as _i56;
import 'package:food_butler_client/src/protocol/tours/james_beard_award.dart'
    as _i57;
import 'package:food_butler_client/src/protocol/daily/daily_story.dart' as _i58;
import 'package:food_butler_client/src/protocol/tonight_pick.dart' as _i59;
import 'package:food_butler_client/src/protocol/geocoding/place_prediction.dart'
    as _i60;
import 'package:food_butler_client/src/protocol/places/city_prediction.dart'
    as _i61;
import 'package:food_butler_client/src/protocol/maps/curated_map.dart' as _i62;
import 'package:food_butler_client/src/protocol/maps/map_restaurant.dart'
    as _i63;
import 'package:food_butler_client/src/protocol/maps/favorite_city.dart'
    as _i64;
import 'package:food_butler_client/src/protocol/saved_restaurant.dart' as _i65;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i66;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i67;
export 'analytics/reservation_click_event.dart';
export 'analytics/reservation_link_type.dart';
export 'awards/import_preview_item.dart';
export 'awards/import_preview_result.dart';
export 'awards/import_result.dart';
export 'awards/review_queue_item.dart';
export 'daily/daily_story.dart';
export 'daily/daily_story_type.dart';
export 'daily/tonight_picks_cache.dart';
export 'discovery/discovered_place.dart';
export 'discovery/food_discovery_response.dart';
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
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

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

    if (t == _i2.ReservationClickEvent) {
      return _i2.ReservationClickEvent.fromJson(data) as T;
    }
    if (t == _i3.ReservationLinkType) {
      return _i3.ReservationLinkType.fromJson(data) as T;
    }
    if (t == _i4.ImportPreviewItem) {
      return _i4.ImportPreviewItem.fromJson(data) as T;
    }
    if (t == _i5.ImportPreviewResult) {
      return _i5.ImportPreviewResult.fromJson(data) as T;
    }
    if (t == _i6.ImportResult) {
      return _i6.ImportResult.fromJson(data) as T;
    }
    if (t == _i7.ReviewQueueItem) {
      return _i7.ReviewQueueItem.fromJson(data) as T;
    }
    if (t == _i8.DailyStory) {
      return _i8.DailyStory.fromJson(data) as T;
    }
    if (t == _i9.DailyStoryType) {
      return _i9.DailyStoryType.fromJson(data) as T;
    }
    if (t == _i10.TonightPicksCache) {
      return _i10.TonightPicksCache.fromJson(data) as T;
    }
    if (t == _i11.DiscoveredPlace) {
      return _i11.DiscoveredPlace.fromJson(data) as T;
    }
    if (t == _i12.FoodDiscoveryResponse) {
      return _i12.FoodDiscoveryResponse.fromJson(data) as T;
    }
    if (t == _i13.PlaceDetails) {
      return _i13.PlaceDetails.fromJson(data) as T;
    }
    if (t == _i14.PlacePrediction) {
      return _i14.PlacePrediction.fromJson(data) as T;
    }
    if (t == _i15.Greeting) {
      return _i15.Greeting.fromJson(data) as T;
    }
    if (t == _i16.JournalEntry) {
      return _i16.JournalEntry.fromJson(data) as T;
    }
    if (t == _i17.JournalPhoto) {
      return _i17.JournalPhoto.fromJson(data) as T;
    }
    if (t == _i18.CuratedMap) {
      return _i18.CuratedMap.fromJson(data) as T;
    }
    if (t == _i19.FavoriteCity) {
      return _i19.FavoriteCity.fromJson(data) as T;
    }
    if (t == _i20.MapCategory) {
      return _i20.MapCategory.fromJson(data) as T;
    }
    if (t == _i21.MapRestaurant) {
      return _i21.MapRestaurant.fromJson(data) as T;
    }
    if (t == _i22.NarrativeCache) {
      return _i22.NarrativeCache.fromJson(data) as T;
    }
    if (t == _i23.NarrativeRegenerateLimit) {
      return _i23.NarrativeRegenerateLimit.fromJson(data) as T;
    }
    if (t == _i24.NarrativeResponse) {
      return _i24.NarrativeResponse.fromJson(data) as T;
    }
    if (t == _i25.NarrativeType) {
      return _i25.NarrativeType.fromJson(data) as T;
    }
    if (t == _i26.CityPrediction) {
      return _i26.CityPrediction.fromJson(data) as T;
    }
    if (t == _i27.RestaurantPhoto) {
      return _i27.RestaurantPhoto.fromJson(data) as T;
    }
    if (t == _i28.SavedRestaurant) {
      return _i28.SavedRestaurant.fromJson(data) as T;
    }
    if (t == _i29.SavedRestaurantSource) {
      return _i29.SavedRestaurantSource.fromJson(data) as T;
    }
    if (t == _i30.TonightPick) {
      return _i30.TonightPick.fromJson(data) as T;
    }
    if (t == _i31.Award) {
      return _i31.Award.fromJson(data) as T;
    }
    if (t == _i32.AwardImportLog) {
      return _i32.AwardImportLog.fromJson(data) as T;
    }
    if (t == _i33.AwardType) {
      return _i33.AwardType.fromJson(data) as T;
    }
    if (t == _i34.BudgetTier) {
      return _i34.BudgetTier.fromJson(data) as T;
    }
    if (t == _i35.CachedFoursquareResponse) {
      return _i35.CachedFoursquareResponse.fromJson(data) as T;
    }
    if (t == _i36.CachedRoute) {
      return _i36.CachedRoute.fromJson(data) as T;
    }
    if (t == _i37.JamesBeardAward) {
      return _i37.JamesBeardAward.fromJson(data) as T;
    }
    if (t == _i38.JamesBeardDistinction) {
      return _i38.JamesBeardDistinction.fromJson(data) as T;
    }
    if (t == _i39.MatchStatus) {
      return _i39.MatchStatus.fromJson(data) as T;
    }
    if (t == _i40.MichelinAward) {
      return _i40.MichelinAward.fromJson(data) as T;
    }
    if (t == _i41.MichelinDesignation) {
      return _i41.MichelinDesignation.fromJson(data) as T;
    }
    if (t == _i42.Restaurant) {
      return _i42.Restaurant.fromJson(data) as T;
    }
    if (t == _i43.RestaurantAwardLink) {
      return _i43.RestaurantAwardLink.fromJson(data) as T;
    }
    if (t == _i44.RouteLeg) {
      return _i44.RouteLeg.fromJson(data) as T;
    }
    if (t == _i45.TourRequest) {
      return _i45.TourRequest.fromJson(data) as T;
    }
    if (t == _i46.TourResult) {
      return _i46.TourResult.fromJson(data) as T;
    }
    if (t == _i47.TourStop) {
      return _i47.TourStop.fromJson(data) as T;
    }
    if (t == _i48.TourStopAlternative) {
      return _i48.TourStopAlternative.fromJson(data) as T;
    }
    if (t == _i49.TransportMode) {
      return _i49.TransportMode.fromJson(data) as T;
    }
    if (t == _i50.AdventureLevel) {
      return _i50.AdventureLevel.fromJson(data) as T;
    }
    if (t == _i51.FoodPhilosophy) {
      return _i51.FoodPhilosophy.fromJson(data) as T;
    }
    if (t == _i52.UserProfile) {
      return _i52.UserProfile.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.ReservationClickEvent?>()) {
      return (data != null ? _i2.ReservationClickEvent.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i3.ReservationLinkType?>()) {
      return (data != null ? _i3.ReservationLinkType.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i4.ImportPreviewItem?>()) {
      return (data != null ? _i4.ImportPreviewItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.ImportPreviewResult?>()) {
      return (data != null ? _i5.ImportPreviewResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i6.ImportResult?>()) {
      return (data != null ? _i6.ImportResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.ReviewQueueItem?>()) {
      return (data != null ? _i7.ReviewQueueItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.DailyStory?>()) {
      return (data != null ? _i8.DailyStory.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.DailyStoryType?>()) {
      return (data != null ? _i9.DailyStoryType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.TonightPicksCache?>()) {
      return (data != null ? _i10.TonightPicksCache.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.DiscoveredPlace?>()) {
      return (data != null ? _i11.DiscoveredPlace.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.FoodDiscoveryResponse?>()) {
      return (data != null ? _i12.FoodDiscoveryResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i13.PlaceDetails?>()) {
      return (data != null ? _i13.PlaceDetails.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.PlacePrediction?>()) {
      return (data != null ? _i14.PlacePrediction.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.Greeting?>()) {
      return (data != null ? _i15.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.JournalEntry?>()) {
      return (data != null ? _i16.JournalEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.JournalPhoto?>()) {
      return (data != null ? _i17.JournalPhoto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.CuratedMap?>()) {
      return (data != null ? _i18.CuratedMap.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.FavoriteCity?>()) {
      return (data != null ? _i19.FavoriteCity.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.MapCategory?>()) {
      return (data != null ? _i20.MapCategory.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.MapRestaurant?>()) {
      return (data != null ? _i21.MapRestaurant.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.NarrativeCache?>()) {
      return (data != null ? _i22.NarrativeCache.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.NarrativeRegenerateLimit?>()) {
      return (data != null
              ? _i23.NarrativeRegenerateLimit.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i24.NarrativeResponse?>()) {
      return (data != null ? _i24.NarrativeResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.NarrativeType?>()) {
      return (data != null ? _i25.NarrativeType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.CityPrediction?>()) {
      return (data != null ? _i26.CityPrediction.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.RestaurantPhoto?>()) {
      return (data != null ? _i27.RestaurantPhoto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.SavedRestaurant?>()) {
      return (data != null ? _i28.SavedRestaurant.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.SavedRestaurantSource?>()) {
      return (data != null ? _i29.SavedRestaurantSource.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i30.TonightPick?>()) {
      return (data != null ? _i30.TonightPick.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.Award?>()) {
      return (data != null ? _i31.Award.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.AwardImportLog?>()) {
      return (data != null ? _i32.AwardImportLog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.AwardType?>()) {
      return (data != null ? _i33.AwardType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.BudgetTier?>()) {
      return (data != null ? _i34.BudgetTier.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.CachedFoursquareResponse?>()) {
      return (data != null
              ? _i35.CachedFoursquareResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i36.CachedRoute?>()) {
      return (data != null ? _i36.CachedRoute.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i37.JamesBeardAward?>()) {
      return (data != null ? _i37.JamesBeardAward.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i38.JamesBeardDistinction?>()) {
      return (data != null ? _i38.JamesBeardDistinction.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i39.MatchStatus?>()) {
      return (data != null ? _i39.MatchStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.MichelinAward?>()) {
      return (data != null ? _i40.MichelinAward.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i41.MichelinDesignation?>()) {
      return (data != null ? _i41.MichelinDesignation.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i42.Restaurant?>()) {
      return (data != null ? _i42.Restaurant.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i43.RestaurantAwardLink?>()) {
      return (data != null ? _i43.RestaurantAwardLink.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i44.RouteLeg?>()) {
      return (data != null ? _i44.RouteLeg.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i45.TourRequest?>()) {
      return (data != null ? _i45.TourRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i46.TourResult?>()) {
      return (data != null ? _i46.TourResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i47.TourStop?>()) {
      return (data != null ? _i47.TourStop.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i48.TourStopAlternative?>()) {
      return (data != null ? _i48.TourStopAlternative.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i49.TransportMode?>()) {
      return (data != null ? _i49.TransportMode.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i50.AdventureLevel?>()) {
      return (data != null ? _i50.AdventureLevel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i51.FoodPhilosophy?>()) {
      return (data != null ? _i51.FoodPhilosophy.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i52.UserProfile?>()) {
      return (data != null ? _i52.UserProfile.fromJson(data) : null) as T;
    }
    if (t == List<_i4.ImportPreviewItem>) {
      return (data as List)
              .map((e) => deserialize<_i4.ImportPreviewItem>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i11.DiscoveredPlace>) {
      return (data as List)
              .map((e) => deserialize<_i11.DiscoveredPlace>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i48.TourStopAlternative>) {
      return (data as List)
              .map((e) => deserialize<_i48.TourStopAlternative>(e))
              .toList()
          as T;
    }
    if (t == List<_i53.ReservationClickEvent>) {
      return (data as List)
              .map((e) => deserialize<_i53.ReservationClickEvent>(e))
              .toList()
          as T;
    }
    if (t == Map<String, int>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)),
          )
          as T;
    }
    if (t == List<_i54.ReviewQueueItem>) {
      return (data as List)
              .map((e) => deserialize<_i54.ReviewQueueItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i55.AwardImportLog>) {
      return (data as List)
              .map((e) => deserialize<_i55.AwardImportLog>(e))
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
    if (t == List<_i56.MichelinAward>) {
      return (data as List)
              .map((e) => deserialize<_i56.MichelinAward>(e))
              .toList()
          as T;
    }
    if (t == List<_i57.JamesBeardAward>) {
      return (data as List)
              .map((e) => deserialize<_i57.JamesBeardAward>(e))
              .toList()
          as T;
    }
    if (t == List<_i58.DailyStory>) {
      return (data as List).map((e) => deserialize<_i58.DailyStory>(e)).toList()
          as T;
    }
    if (t == List<_i59.TonightPick>) {
      return (data as List)
              .map((e) => deserialize<_i59.TonightPick>(e))
              .toList()
          as T;
    }
    if (t == List<_i60.PlacePrediction>) {
      return (data as List)
              .map((e) => deserialize<_i60.PlacePrediction>(e))
              .toList()
          as T;
    }
    if (t == List<_i61.CityPrediction>) {
      return (data as List)
              .map((e) => deserialize<_i61.CityPrediction>(e))
              .toList()
          as T;
    }
    if (t == List<_i62.CuratedMap>) {
      return (data as List).map((e) => deserialize<_i62.CuratedMap>(e)).toList()
          as T;
    }
    if (t == List<_i63.MapRestaurant>) {
      return (data as List)
              .map((e) => deserialize<_i63.MapRestaurant>(e))
              .toList()
          as T;
    }
    if (t == List<_i64.FavoriteCity>) {
      return (data as List)
              .map((e) => deserialize<_i64.FavoriteCity>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i65.SavedRestaurant>) {
      return (data as List)
              .map((e) => deserialize<_i65.SavedRestaurant>(e))
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
      return _i66.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i67.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.ReservationClickEvent => 'ReservationClickEvent',
      _i3.ReservationLinkType => 'ReservationLinkType',
      _i4.ImportPreviewItem => 'ImportPreviewItem',
      _i5.ImportPreviewResult => 'ImportPreviewResult',
      _i6.ImportResult => 'ImportResult',
      _i7.ReviewQueueItem => 'ReviewQueueItem',
      _i8.DailyStory => 'DailyStory',
      _i9.DailyStoryType => 'DailyStoryType',
      _i10.TonightPicksCache => 'TonightPicksCache',
      _i11.DiscoveredPlace => 'DiscoveredPlace',
      _i12.FoodDiscoveryResponse => 'FoodDiscoveryResponse',
      _i13.PlaceDetails => 'PlaceDetails',
      _i14.PlacePrediction => 'PlacePrediction',
      _i15.Greeting => 'Greeting',
      _i16.JournalEntry => 'JournalEntry',
      _i17.JournalPhoto => 'JournalPhoto',
      _i18.CuratedMap => 'CuratedMap',
      _i19.FavoriteCity => 'FavoriteCity',
      _i20.MapCategory => 'MapCategory',
      _i21.MapRestaurant => 'MapRestaurant',
      _i22.NarrativeCache => 'NarrativeCache',
      _i23.NarrativeRegenerateLimit => 'NarrativeRegenerateLimit',
      _i24.NarrativeResponse => 'NarrativeResponse',
      _i25.NarrativeType => 'NarrativeType',
      _i26.CityPrediction => 'CityPrediction',
      _i27.RestaurantPhoto => 'RestaurantPhoto',
      _i28.SavedRestaurant => 'SavedRestaurant',
      _i29.SavedRestaurantSource => 'SavedRestaurantSource',
      _i30.TonightPick => 'TonightPick',
      _i31.Award => 'Award',
      _i32.AwardImportLog => 'AwardImportLog',
      _i33.AwardType => 'AwardType',
      _i34.BudgetTier => 'BudgetTier',
      _i35.CachedFoursquareResponse => 'CachedFoursquareResponse',
      _i36.CachedRoute => 'CachedRoute',
      _i37.JamesBeardAward => 'JamesBeardAward',
      _i38.JamesBeardDistinction => 'JamesBeardDistinction',
      _i39.MatchStatus => 'MatchStatus',
      _i40.MichelinAward => 'MichelinAward',
      _i41.MichelinDesignation => 'MichelinDesignation',
      _i42.Restaurant => 'Restaurant',
      _i43.RestaurantAwardLink => 'RestaurantAwardLink',
      _i44.RouteLeg => 'RouteLeg',
      _i45.TourRequest => 'TourRequest',
      _i46.TourResult => 'TourResult',
      _i47.TourStop => 'TourStop',
      _i48.TourStopAlternative => 'TourStopAlternative',
      _i49.TransportMode => 'TransportMode',
      _i50.AdventureLevel => 'AdventureLevel',
      _i51.FoodPhilosophy => 'FoodPhilosophy',
      _i52.UserProfile => 'UserProfile',
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
      case _i2.ReservationClickEvent():
        return 'ReservationClickEvent';
      case _i3.ReservationLinkType():
        return 'ReservationLinkType';
      case _i4.ImportPreviewItem():
        return 'ImportPreviewItem';
      case _i5.ImportPreviewResult():
        return 'ImportPreviewResult';
      case _i6.ImportResult():
        return 'ImportResult';
      case _i7.ReviewQueueItem():
        return 'ReviewQueueItem';
      case _i8.DailyStory():
        return 'DailyStory';
      case _i9.DailyStoryType():
        return 'DailyStoryType';
      case _i10.TonightPicksCache():
        return 'TonightPicksCache';
      case _i11.DiscoveredPlace():
        return 'DiscoveredPlace';
      case _i12.FoodDiscoveryResponse():
        return 'FoodDiscoveryResponse';
      case _i13.PlaceDetails():
        return 'PlaceDetails';
      case _i14.PlacePrediction():
        return 'PlacePrediction';
      case _i15.Greeting():
        return 'Greeting';
      case _i16.JournalEntry():
        return 'JournalEntry';
      case _i17.JournalPhoto():
        return 'JournalPhoto';
      case _i18.CuratedMap():
        return 'CuratedMap';
      case _i19.FavoriteCity():
        return 'FavoriteCity';
      case _i20.MapCategory():
        return 'MapCategory';
      case _i21.MapRestaurant():
        return 'MapRestaurant';
      case _i22.NarrativeCache():
        return 'NarrativeCache';
      case _i23.NarrativeRegenerateLimit():
        return 'NarrativeRegenerateLimit';
      case _i24.NarrativeResponse():
        return 'NarrativeResponse';
      case _i25.NarrativeType():
        return 'NarrativeType';
      case _i26.CityPrediction():
        return 'CityPrediction';
      case _i27.RestaurantPhoto():
        return 'RestaurantPhoto';
      case _i28.SavedRestaurant():
        return 'SavedRestaurant';
      case _i29.SavedRestaurantSource():
        return 'SavedRestaurantSource';
      case _i30.TonightPick():
        return 'TonightPick';
      case _i31.Award():
        return 'Award';
      case _i32.AwardImportLog():
        return 'AwardImportLog';
      case _i33.AwardType():
        return 'AwardType';
      case _i34.BudgetTier():
        return 'BudgetTier';
      case _i35.CachedFoursquareResponse():
        return 'CachedFoursquareResponse';
      case _i36.CachedRoute():
        return 'CachedRoute';
      case _i37.JamesBeardAward():
        return 'JamesBeardAward';
      case _i38.JamesBeardDistinction():
        return 'JamesBeardDistinction';
      case _i39.MatchStatus():
        return 'MatchStatus';
      case _i40.MichelinAward():
        return 'MichelinAward';
      case _i41.MichelinDesignation():
        return 'MichelinDesignation';
      case _i42.Restaurant():
        return 'Restaurant';
      case _i43.RestaurantAwardLink():
        return 'RestaurantAwardLink';
      case _i44.RouteLeg():
        return 'RouteLeg';
      case _i45.TourRequest():
        return 'TourRequest';
      case _i46.TourResult():
        return 'TourResult';
      case _i47.TourStop():
        return 'TourStop';
      case _i48.TourStopAlternative():
        return 'TourStopAlternative';
      case _i49.TransportMode():
        return 'TransportMode';
      case _i50.AdventureLevel():
        return 'AdventureLevel';
      case _i51.FoodPhilosophy():
        return 'FoodPhilosophy';
      case _i52.UserProfile():
        return 'UserProfile';
    }
    className = _i66.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i67.Protocol().getClassNameForObject(data);
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
      return deserialize<_i2.ReservationClickEvent>(data['data']);
    }
    if (dataClassName == 'ReservationLinkType') {
      return deserialize<_i3.ReservationLinkType>(data['data']);
    }
    if (dataClassName == 'ImportPreviewItem') {
      return deserialize<_i4.ImportPreviewItem>(data['data']);
    }
    if (dataClassName == 'ImportPreviewResult') {
      return deserialize<_i5.ImportPreviewResult>(data['data']);
    }
    if (dataClassName == 'ImportResult') {
      return deserialize<_i6.ImportResult>(data['data']);
    }
    if (dataClassName == 'ReviewQueueItem') {
      return deserialize<_i7.ReviewQueueItem>(data['data']);
    }
    if (dataClassName == 'DailyStory') {
      return deserialize<_i8.DailyStory>(data['data']);
    }
    if (dataClassName == 'DailyStoryType') {
      return deserialize<_i9.DailyStoryType>(data['data']);
    }
    if (dataClassName == 'TonightPicksCache') {
      return deserialize<_i10.TonightPicksCache>(data['data']);
    }
    if (dataClassName == 'DiscoveredPlace') {
      return deserialize<_i11.DiscoveredPlace>(data['data']);
    }
    if (dataClassName == 'FoodDiscoveryResponse') {
      return deserialize<_i12.FoodDiscoveryResponse>(data['data']);
    }
    if (dataClassName == 'PlaceDetails') {
      return deserialize<_i13.PlaceDetails>(data['data']);
    }
    if (dataClassName == 'PlacePrediction') {
      return deserialize<_i14.PlacePrediction>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i15.Greeting>(data['data']);
    }
    if (dataClassName == 'JournalEntry') {
      return deserialize<_i16.JournalEntry>(data['data']);
    }
    if (dataClassName == 'JournalPhoto') {
      return deserialize<_i17.JournalPhoto>(data['data']);
    }
    if (dataClassName == 'CuratedMap') {
      return deserialize<_i18.CuratedMap>(data['data']);
    }
    if (dataClassName == 'FavoriteCity') {
      return deserialize<_i19.FavoriteCity>(data['data']);
    }
    if (dataClassName == 'MapCategory') {
      return deserialize<_i20.MapCategory>(data['data']);
    }
    if (dataClassName == 'MapRestaurant') {
      return deserialize<_i21.MapRestaurant>(data['data']);
    }
    if (dataClassName == 'NarrativeCache') {
      return deserialize<_i22.NarrativeCache>(data['data']);
    }
    if (dataClassName == 'NarrativeRegenerateLimit') {
      return deserialize<_i23.NarrativeRegenerateLimit>(data['data']);
    }
    if (dataClassName == 'NarrativeResponse') {
      return deserialize<_i24.NarrativeResponse>(data['data']);
    }
    if (dataClassName == 'NarrativeType') {
      return deserialize<_i25.NarrativeType>(data['data']);
    }
    if (dataClassName == 'CityPrediction') {
      return deserialize<_i26.CityPrediction>(data['data']);
    }
    if (dataClassName == 'RestaurantPhoto') {
      return deserialize<_i27.RestaurantPhoto>(data['data']);
    }
    if (dataClassName == 'SavedRestaurant') {
      return deserialize<_i28.SavedRestaurant>(data['data']);
    }
    if (dataClassName == 'SavedRestaurantSource') {
      return deserialize<_i29.SavedRestaurantSource>(data['data']);
    }
    if (dataClassName == 'TonightPick') {
      return deserialize<_i30.TonightPick>(data['data']);
    }
    if (dataClassName == 'Award') {
      return deserialize<_i31.Award>(data['data']);
    }
    if (dataClassName == 'AwardImportLog') {
      return deserialize<_i32.AwardImportLog>(data['data']);
    }
    if (dataClassName == 'AwardType') {
      return deserialize<_i33.AwardType>(data['data']);
    }
    if (dataClassName == 'BudgetTier') {
      return deserialize<_i34.BudgetTier>(data['data']);
    }
    if (dataClassName == 'CachedFoursquareResponse') {
      return deserialize<_i35.CachedFoursquareResponse>(data['data']);
    }
    if (dataClassName == 'CachedRoute') {
      return deserialize<_i36.CachedRoute>(data['data']);
    }
    if (dataClassName == 'JamesBeardAward') {
      return deserialize<_i37.JamesBeardAward>(data['data']);
    }
    if (dataClassName == 'JamesBeardDistinction') {
      return deserialize<_i38.JamesBeardDistinction>(data['data']);
    }
    if (dataClassName == 'MatchStatus') {
      return deserialize<_i39.MatchStatus>(data['data']);
    }
    if (dataClassName == 'MichelinAward') {
      return deserialize<_i40.MichelinAward>(data['data']);
    }
    if (dataClassName == 'MichelinDesignation') {
      return deserialize<_i41.MichelinDesignation>(data['data']);
    }
    if (dataClassName == 'Restaurant') {
      return deserialize<_i42.Restaurant>(data['data']);
    }
    if (dataClassName == 'RestaurantAwardLink') {
      return deserialize<_i43.RestaurantAwardLink>(data['data']);
    }
    if (dataClassName == 'RouteLeg') {
      return deserialize<_i44.RouteLeg>(data['data']);
    }
    if (dataClassName == 'TourRequest') {
      return deserialize<_i45.TourRequest>(data['data']);
    }
    if (dataClassName == 'TourResult') {
      return deserialize<_i46.TourResult>(data['data']);
    }
    if (dataClassName == 'TourStop') {
      return deserialize<_i47.TourStop>(data['data']);
    }
    if (dataClassName == 'TourStopAlternative') {
      return deserialize<_i48.TourStopAlternative>(data['data']);
    }
    if (dataClassName == 'TransportMode') {
      return deserialize<_i49.TransportMode>(data['data']);
    }
    if (dataClassName == 'AdventureLevel') {
      return deserialize<_i50.AdventureLevel>(data['data']);
    }
    if (dataClassName == 'FoodPhilosophy') {
      return deserialize<_i51.FoodPhilosophy>(data['data']);
    }
    if (dataClassName == 'UserProfile') {
      return deserialize<_i52.UserProfile>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i66.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i67.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

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
      return _i66.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i67.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
