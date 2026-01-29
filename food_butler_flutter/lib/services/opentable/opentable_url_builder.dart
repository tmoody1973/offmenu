/// Utility class for building OpenTable deep link URLs.
class OpenTableUrlBuilder {
  /// Default party size for reservations.
  static const int defaultPartySize = 2;

  /// Build OpenTable app scheme URL for direct app launch.
  ///
  /// Format: `opentable://restaurant/{restaurantId}?covers={n}&dateTime={iso8601}`
  static String buildAppSchemeUrl({
    required String restaurantId,
    int partySize = defaultPartySize,
    required DateTime dateTime,
  }) {
    final isoDateTime = _formatDateTime(dateTime);
    return 'opentable://restaurant/$restaurantId?covers=$partySize&dateTime=$isoDateTime';
  }

  /// Build OpenTable web URL with restaurant slug.
  ///
  /// Format: `https://www.opentable.com/r/{slug}?covers={n}&dateTime={iso8601}`
  static String buildWebUrl({
    required String slug,
    int partySize = defaultPartySize,
    required DateTime dateTime,
  }) {
    final isoDateTime = _formatDateTime(dateTime);
    return 'https://www.opentable.com/r/$slug?covers=$partySize&dateTime=$isoDateTime';
  }

  /// Build OpenTable search URL for restaurants without exact ID/slug.
  ///
  /// Format: `https://www.opentable.com/s?term={name}&geo={location}&covers={n}&dateTime={iso8601}`
  static String buildSearchUrl({
    required String name,
    required String location,
    int partySize = defaultPartySize,
    required DateTime dateTime,
  }) {
    final encodedName = _urlEncode(name);
    final encodedLocation = _urlEncode(location);
    final isoDateTime = _formatDateTime(dateTime);

    return 'https://www.opentable.com/s?term=$encodedName&geo=$encodedLocation&covers=$partySize&dateTime=$isoDateTime';
  }

  /// Build phone link for fallback contact.
  ///
  /// Format: `tel:{phoneNumber}`
  static String buildPhoneUrl(String phoneNumber) {
    // Remove spaces and special characters except +
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    return 'tel:$cleanedNumber';
  }

  /// Format DateTime as ISO 8601 string for URL parameter.
  static String _formatDateTime(DateTime dateTime) {
    return dateTime.toIso8601String();
  }

  /// URL encode a string, handling special characters.
  static String _urlEncode(String value) {
    return Uri.encodeComponent(value);
  }
}
