import 'package:food_butler_client/food_butler_client.dart';
import 'opentable_url_builder.dart';
import 'datetime_rounder.dart';

/// Result of determining the best reservation URL for a restaurant.
class ReservationUrlResult {
  /// The generated URL.
  final String url;

  /// The type of URL generated.
  final ReservationLinkType linkType;

  const ReservationUrlResult({
    required this.url,
    required this.linkType,
  });
}

/// Service for determining and generating reservation URLs.
class ReservationLinkService {
  /// Get the preferred OpenTable URL for a restaurant.
  ///
  /// Priority: app scheme (if opentableId) > web URL (if slug) > search URL (if name/location)
  static ReservationUrlResult? getPreferredUrl({
    required Restaurant restaurant,
    int partySize = OpenTableUrlBuilder.defaultPartySize,
    DateTime? scheduledTime,
  }) {
    // Use scheduled time if provided, otherwise use current time rounded up
    final dateTime = scheduledTime != null
        ? DateTimeRounder.roundToNearest15Minutes(scheduledTime)
        : DateTimeRounder.roundToNext15Minutes(DateTime.now());

    // Priority 1: App scheme with OpenTable ID
    if (restaurant.opentableId != null && restaurant.opentableId!.isNotEmpty) {
      return ReservationUrlResult(
        url: OpenTableUrlBuilder.buildAppSchemeUrl(
          restaurantId: restaurant.opentableId!,
          partySize: partySize,
          dateTime: dateTime,
        ),
        linkType: ReservationLinkType.opentableApp,
      );
    }

    // Priority 2: Web URL with slug
    if (restaurant.opentableSlug != null && restaurant.opentableSlug!.isNotEmpty) {
      return ReservationUrlResult(
        url: OpenTableUrlBuilder.buildWebUrl(
          slug: restaurant.opentableSlug!,
          partySize: partySize,
          dateTime: dateTime,
        ),
        linkType: ReservationLinkType.opentableWeb,
      );
    }

    // Priority 3: Search URL with name and location
    if (restaurant.name.isNotEmpty && restaurant.address.isNotEmpty) {
      return ReservationUrlResult(
        url: OpenTableUrlBuilder.buildSearchUrl(
          name: restaurant.name,
          location: restaurant.address,
          partySize: partySize,
          dateTime: dateTime,
        ),
        linkType: ReservationLinkType.opentableSearch,
      );
    }

    return null;
  }

  /// Get the web fallback URL for a restaurant.
  ///
  /// Used when app scheme fails or isn't available.
  static ReservationUrlResult? getWebFallbackUrl({
    required Restaurant restaurant,
    int partySize = OpenTableUrlBuilder.defaultPartySize,
    DateTime? scheduledTime,
  }) {
    final dateTime = scheduledTime != null
        ? DateTimeRounder.roundToNearest15Minutes(scheduledTime)
        : DateTimeRounder.roundToNext15Minutes(DateTime.now());

    // Priority 1: Web URL with slug
    if (restaurant.opentableSlug != null && restaurant.opentableSlug!.isNotEmpty) {
      return ReservationUrlResult(
        url: OpenTableUrlBuilder.buildWebUrl(
          slug: restaurant.opentableSlug!,
          partySize: partySize,
          dateTime: dateTime,
        ),
        linkType: ReservationLinkType.opentableWeb,
      );
    }

    // Priority 2: Search URL with name and location
    if (restaurant.name.isNotEmpty && restaurant.address.isNotEmpty) {
      return ReservationUrlResult(
        url: OpenTableUrlBuilder.buildSearchUrl(
          name: restaurant.name,
          location: restaurant.address,
          partySize: partySize,
          dateTime: dateTime,
        ),
        linkType: ReservationLinkType.opentableSearch,
      );
    }

    return null;
  }

  /// Check if restaurant has OpenTable support.
  static bool hasOpenTableSupport(Restaurant restaurant) {
    return (restaurant.opentableId != null && restaurant.opentableId!.isNotEmpty) ||
        (restaurant.opentableSlug != null && restaurant.opentableSlug!.isNotEmpty) ||
        (restaurant.name.isNotEmpty && restaurant.address.isNotEmpty);
  }

  /// Check if restaurant has fallback contact options.
  static bool hasFallbackContact(Restaurant restaurant) {
    return (restaurant.phone != null && restaurant.phone!.isNotEmpty) ||
        (restaurant.websiteUrl != null && restaurant.websiteUrl!.isNotEmpty);
  }

  /// Check if restaurant has phone number for fallback.
  static bool hasPhoneContact(Restaurant restaurant) {
    return restaurant.phone != null && restaurant.phone!.isNotEmpty;
  }

  /// Check if restaurant has website for fallback.
  static bool hasWebsiteContact(Restaurant restaurant) {
    return restaurant.websiteUrl != null && restaurant.websiteUrl!.isNotEmpty;
  }

  /// Get phone URL for fallback contact.
  static String? getPhoneUrl(Restaurant restaurant) {
    if (restaurant.phone == null || restaurant.phone!.isEmpty) {
      return null;
    }
    return OpenTableUrlBuilder.buildPhoneUrl(restaurant.phone!);
  }

  /// Get website URL for fallback contact.
  static String? getWebsiteUrl(Restaurant restaurant) {
    return restaurant.websiteUrl;
  }
}
