/// Utility for decoding encoded polyline strings.
class PolylineDecoder {
  /// Decodes a polyline6 encoded string to coordinates.
  /// Returns a list of [latitude, longitude] pairs.
  static List<List<double>> decode(String encoded, {int precision = 6}) {
    if (encoded.isEmpty) return [];

    final coordinates = <List<double>>[];
    var index = 0;
    var lat = 0;
    var lng = 0;
    final factor = _pow10(precision);

    while (index < encoded.length) {
      // Decode latitude
      var shift = 0;
      var result = 0;
      int byte;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);
      lat += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      // Decode longitude
      shift = 0;
      result = 0;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);
      lng += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      coordinates.add([lat / factor, lng / factor]);
    }

    return coordinates;
  }

  static int _pow10(int exponent) {
    var result = 1;
    for (var i = 0; i < exponent; i++) {
      result *= 10;
    }
    return result;
  }
}
