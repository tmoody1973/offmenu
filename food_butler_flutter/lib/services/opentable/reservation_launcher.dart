import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:food_butler_client/food_butler_client.dart';
import 'reservation_link_service.dart';
import 'url_launcher_wrapper.dart';

/// Result of a URL launch attempt.
class LaunchResult {
  /// Whether the launch was successful.
  final bool success;

  /// The type of link that was launched.
  final ReservationLinkType linkType;

  /// The URL that was launched (or attempted).
  final String? url;

  /// Error message if launch failed.
  final String? errorMessage;

  const LaunchResult({
    required this.success,
    required this.linkType,
    this.url,
    this.errorMessage,
  });

  factory LaunchResult.failure({
    required ReservationLinkType linkType,
    String? url,
    String? errorMessage,
  }) {
    return LaunchResult(
      success: false,
      linkType: linkType,
      url: url,
      errorMessage: errorMessage ?? 'Failed to launch URL',
    );
  }
}

/// Service for launching reservation URLs with fallback logic.
class ReservationLauncher {
  final UrlLauncherWrapper _urlLauncher;

  ReservationLauncher({
    UrlLauncherWrapper? urlLauncher,
  }) : _urlLauncher = urlLauncher ?? defaultUrlLauncher;

  /// Launch reservation link for a restaurant.
  ///
  /// Attempts app scheme first, falls back to web URL if app not available.
  Future<LaunchResult> launchReservation({
    required Restaurant restaurant,
    int partySize = 2,
    DateTime? scheduledTime,
  }) async {
    // Try app scheme first if OpenTable ID is available
    if (restaurant.opentableId != null && restaurant.opentableId!.isNotEmpty) {
      final appResult = ReservationLinkService.getPreferredUrl(
        restaurant: restaurant,
        partySize: partySize,
        scheduledTime: scheduledTime,
      );

      if (appResult != null && appResult.linkType == ReservationLinkType.opentableApp) {
        final canLaunchApp = await _urlLauncher.canLaunch(appResult.url);

        if (canLaunchApp) {
          try {
            final launched = await _urlLauncher.launch(
              appResult.url,
              mode: url_launcher.LaunchMode.externalApplication,
            );

            if (launched) {
              return LaunchResult(
                success: true,
                linkType: ReservationLinkType.opentableApp,
                url: appResult.url,
              );
            }
          } catch (e) {
            // Fall through to web fallback
          }
        }

        // Fall back to web URL
        final webResult = ReservationLinkService.getWebFallbackUrl(
          restaurant: restaurant,
          partySize: partySize,
          scheduledTime: scheduledTime,
        );

        if (webResult != null) {
          return _launchWebUrl(webResult.url, webResult.linkType);
        }
      }
    }

    // Try web URL or search URL
    final urlResult = ReservationLinkService.getPreferredUrl(
      restaurant: restaurant,
      partySize: partySize,
      scheduledTime: scheduledTime,
    );

    if (urlResult == null) {
      return LaunchResult.failure(
        linkType: ReservationLinkType.opentableSearch,
        errorMessage: 'No reservation URL available for this restaurant',
      );
    }

    // If it's an app URL (but we couldn't launch app), get web fallback
    if (urlResult.linkType == ReservationLinkType.opentableApp) {
      final webResult = ReservationLinkService.getWebFallbackUrl(
        restaurant: restaurant,
        partySize: partySize,
        scheduledTime: scheduledTime,
      );

      if (webResult != null) {
        return _launchWebUrl(webResult.url, webResult.linkType);
      }
    }

    return _launchWebUrl(urlResult.url, urlResult.linkType);
  }

  /// Launch phone dialer for restaurant.
  Future<LaunchResult> launchPhone(Restaurant restaurant) async {
    final phoneUrl = ReservationLinkService.getPhoneUrl(restaurant);

    if (phoneUrl == null) {
      return LaunchResult.failure(
        linkType: ReservationLinkType.phone,
        errorMessage: 'No phone number available for this restaurant',
      );
    }

    try {
      final canLaunch = await _urlLauncher.canLaunch(phoneUrl);

      if (!canLaunch) {
        return LaunchResult.failure(
          linkType: ReservationLinkType.phone,
          url: phoneUrl,
          errorMessage: 'Unable to make phone calls on this device',
        );
      }

      final launched = await _urlLauncher.launch(
        phoneUrl,
        mode: url_launcher.LaunchMode.externalApplication,
      );

      return LaunchResult(
        success: launched,
        linkType: ReservationLinkType.phone,
        url: phoneUrl,
        errorMessage: launched ? null : 'Failed to open phone dialer',
      );
    } catch (e) {
      return LaunchResult.failure(
        linkType: ReservationLinkType.phone,
        url: phoneUrl,
        errorMessage: 'Error launching phone: $e',
      );
    }
  }

  /// Launch website for restaurant.
  Future<LaunchResult> launchWebsite(Restaurant restaurant) async {
    final websiteUrl = ReservationLinkService.getWebsiteUrl(restaurant);

    if (websiteUrl == null) {
      return LaunchResult.failure(
        linkType: ReservationLinkType.website,
        errorMessage: 'No website available for this restaurant',
      );
    }

    try {
      final canLaunch = await _urlLauncher.canLaunch(websiteUrl);

      if (!canLaunch) {
        return LaunchResult.failure(
          linkType: ReservationLinkType.website,
          url: websiteUrl,
          errorMessage: 'Unable to open web browser',
        );
      }

      final launched = await _urlLauncher.launch(
        websiteUrl,
        mode: url_launcher.LaunchMode.platformDefault,
      );

      return LaunchResult(
        success: launched,
        linkType: ReservationLinkType.website,
        url: websiteUrl,
        errorMessage: launched ? null : 'Failed to open website',
      );
    } catch (e) {
      return LaunchResult.failure(
        linkType: ReservationLinkType.website,
        url: websiteUrl,
        errorMessage: 'Error launching website: $e',
      );
    }
  }

  /// Launch a web URL with platform default mode.
  Future<LaunchResult> _launchWebUrl(String url, ReservationLinkType linkType) async {
    try {
      final canLaunch = await _urlLauncher.canLaunch(url);

      if (!canLaunch) {
        return LaunchResult.failure(
          linkType: linkType,
          url: url,
          errorMessage: 'Unable to open web browser',
        );
      }

      final launched = await _urlLauncher.launch(
        url,
        mode: url_launcher.LaunchMode.platformDefault,
      );

      return LaunchResult(
        success: launched,
        linkType: linkType,
        url: url,
        errorMessage: launched ? null : 'Failed to open reservation page',
      );
    } catch (e) {
      return LaunchResult.failure(
        linkType: linkType,
        url: url,
        errorMessage: 'Error launching URL: $e',
      );
    }
  }
}
