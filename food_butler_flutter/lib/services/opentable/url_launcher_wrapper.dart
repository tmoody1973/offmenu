import 'package:url_launcher/url_launcher.dart' as url_launcher;

/// Wrapper for url_launcher package to enable testing.
class UrlLauncherWrapper {
  /// Check if a URL can be launched.
  Future<bool> canLaunch(String urlString) async {
    final uri = Uri.parse(urlString);
    return url_launcher.canLaunchUrl(uri);
  }

  /// Launch a URL with the specified mode.
  Future<bool> launch(
    String urlString, {
    url_launcher.LaunchMode mode = url_launcher.LaunchMode.platformDefault,
  }) async {
    final uri = Uri.parse(urlString);
    return url_launcher.launchUrl(uri, mode: mode);
  }
}

/// Default URL launcher wrapper instance.
final defaultUrlLauncher = UrlLauncherWrapper();
