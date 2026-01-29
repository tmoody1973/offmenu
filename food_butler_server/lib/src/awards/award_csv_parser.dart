/// Parser for award CSV data files.
///
/// Supports parsing of Michelin Guide and James Beard Foundation award data
/// from various CSV formats.
class AwardCsvParser {
  /// Parse Michelin CSV data.
  ///
  /// Expected columns:
  /// - name/restaurant_name: Restaurant name
  /// - city: City location
  /// - address: Street address (optional)
  /// - latitude/lat: Latitude coordinate (optional)
  /// - longitude/lng/lon: Longitude coordinate (optional)
  /// - stars/designation: Star rating (1, 2, 3, or "Bib Gourmand")
  /// - year: Award year
  List<ParsedAwardRecord> parseMichelinCsv(String csvContent) {
    final records = <ParsedAwardRecord>[];
    final lines = csvContent.split('\n');

    if (lines.isEmpty) return records;

    // Parse header row
    final headers = _parseCsvRow(lines[0])
        .map((h) => h.toLowerCase().trim())
        .toList();

    // Find column indices
    final nameIndex = _findColumnIndex(headers, ['name', 'restaurant_name', 'restaurant']);
    final cityIndex = _findColumnIndex(headers, ['city', 'location']);
    final addressIndex = _findColumnIndex(headers, ['address', 'street_address']);
    final latIndex = _findColumnIndex(headers, ['latitude', 'lat']);
    final lngIndex = _findColumnIndex(headers, ['longitude', 'lng', 'lon']);
    final designationIndex = _findColumnIndex(headers, ['stars', 'designation', 'award', 'rating']);
    final yearIndex = _findColumnIndex(headers, ['year', 'award_year']);

    if (nameIndex == -1 || cityIndex == -1) {
      throw FormatException('CSV must contain name and city columns');
    }

    // Parse data rows
    for (var i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      try {
        final values = _parseCsvRow(line);
        if (values.length <= nameIndex || values.length <= cityIndex) continue;

        final record = ParsedAwardRecord(
          name: values[nameIndex].trim(),
          city: values[cityIndex].trim(),
          address: addressIndex >= 0 && values.length > addressIndex
              ? values[addressIndex].trim()
              : null,
          latitude: latIndex >= 0 && values.length > latIndex
              ? double.tryParse(values[latIndex].trim())
              : null,
          longitude: lngIndex >= 0 && values.length > lngIndex
              ? double.tryParse(values[lngIndex].trim())
              : null,
          designation: designationIndex >= 0 && values.length > designationIndex
              ? values[designationIndex].trim()
              : '1',
          year: yearIndex >= 0 && values.length > yearIndex
              ? int.tryParse(values[yearIndex].trim()) ?? DateTime.now().year
              : DateTime.now().year,
        );

        if (record.name.isNotEmpty && record.city.isNotEmpty) {
          records.add(record);
        }
      } catch (e) {
        // Skip malformed rows
        continue;
      }
    }

    return records;
  }

  /// Parse James Beard CSV data.
  ///
  /// Supports the GitHub cjwinchester/james-beard format with columns:
  /// - recipient_name: Chef or restaurant name
  /// - restaurant_name: Restaurant name (for chef awards)
  /// - location: "City, State" format
  /// - category: Award category (e.g., "Restaurant & Chef")
  /// - subcategory: Specific category (e.g., "Best Chefs", "America's Classics")
  /// - award_status: Winner, Nominee, or Semifinalist
  /// - year: Award year
  ///
  /// Also supports legacy columns:
  /// - name/chef_name/restaurant: Chef or restaurant name
  /// - city: City location
  /// - distinction/status: Winner, Nominee, or Semifinalist
  List<ParsedAwardRecord> parseJamesBeardCsv(String csvContent) {
    final records = <ParsedAwardRecord>[];
    final lines = csvContent.split('\n');

    if (lines.isEmpty) return records;

    // Parse header row
    final headers = _parseCsvRow(lines[0])
        .map((h) => h.toLowerCase().trim())
        .toList();

    // Find column indices - support both GitHub and legacy formats
    final recipientNameIndex = _findColumnIndex(headers, ['recipient_name']);
    final restaurantNameIndex = _findColumnIndex(headers, ['restaurant_name']);
    final legacyNameIndex = _findColumnIndex(headers, ['name', 'chef_name', 'restaurant', 'recipient']);
    final locationIndex = _findColumnIndex(headers, ['location']);
    final cityIndex = _findColumnIndex(headers, ['city']);
    final categoryIndex = _findColumnIndex(headers, ['category', 'award_category', 'award']);
    final subcategoryIndex = _findColumnIndex(headers, ['subcategory']);
    final awardStatusIndex = _findColumnIndex(headers, ['award_status']);
    final distinctionIndex = _findColumnIndex(headers, ['distinction', 'status', 'level', 'result']);
    final yearIndex = _findColumnIndex(headers, ['year', 'award_year']);

    // Determine which name column to use
    final nameIndex = recipientNameIndex >= 0 ? recipientNameIndex : legacyNameIndex;

    // Determine which city column to use
    final cityColIndex = locationIndex >= 0 ? locationIndex : cityIndex;

    if (nameIndex == -1 || cityColIndex == -1) {
      throw FormatException('CSV must contain name and city/location columns');
    }

    // Parse data rows
    for (var i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      try {
        final values = _parseCsvRow(line);
        if (values.length <= nameIndex || values.length <= cityColIndex) continue;

        // Get the name - prefer restaurant_name for chef awards, fall back to recipient_name
        var name = values[nameIndex].trim();
        if (restaurantNameIndex >= 0 && values.length > restaurantNameIndex) {
          final restaurantName = values[restaurantNameIndex].trim();
          if (restaurantName.isNotEmpty) {
            name = restaurantName; // Use restaurant name if available (for chef awards)
          }
        }

        // Parse city from location format "City, State"
        var city = values[cityColIndex].trim();
        if (city.contains(',')) {
          city = city.split(',')[0].trim(); // Extract just the city part
        }

        // Build category string - combine category and subcategory if both present
        var category = 'Unknown';
        if (categoryIndex >= 0 && values.length > categoryIndex) {
          category = values[categoryIndex].trim();
          if (subcategoryIndex >= 0 && values.length > subcategoryIndex) {
            final subcategory = values[subcategoryIndex].trim();
            if (subcategory.isNotEmpty) {
              category = '$category - $subcategory';
            }
          }
        }

        // Get distinction - support both award_status and legacy distinction columns
        String distinction = 'semifinalist';
        if (awardStatusIndex >= 0 && values.length > awardStatusIndex) {
          distinction = values[awardStatusIndex].trim().toLowerCase();
        } else if (distinctionIndex >= 0 && values.length > distinctionIndex) {
          distinction = values[distinctionIndex].trim().toLowerCase();
        }

        final record = ParsedAwardRecord(
          name: name,
          city: city,
          category: category,
          distinction: distinction,
          year: yearIndex >= 0 && values.length > yearIndex
              ? int.tryParse(values[yearIndex].trim()) ?? DateTime.now().year
              : DateTime.now().year,
        );

        if (record.name.isNotEmpty && record.city.isNotEmpty) {
          records.add(record);
        }
      } catch (e) {
        // Skip malformed rows
        continue;
      }
    }

    return records;
  }

  /// Find the index of a column by checking multiple possible header names.
  int _findColumnIndex(List<String> headers, List<String> possibleNames) {
    for (final name in possibleNames) {
      final index = headers.indexOf(name);
      if (index >= 0) return index;
    }
    return -1;
  }

  /// Parse a CSV row, handling quoted values.
  List<String> _parseCsvRow(String row) {
    final values = <String>[];
    var current = StringBuffer();
    var inQuotes = false;

    for (var i = 0; i < row.length; i++) {
      final char = row[i];

      if (char == '"') {
        // Check for escaped quote
        if (i + 1 < row.length && row[i + 1] == '"') {
          current.write('"');
          i++; // Skip next quote
        } else {
          inQuotes = !inQuotes;
        }
      } else if (char == ',' && !inQuotes) {
        values.add(current.toString());
        current = StringBuffer();
      } else {
        current.write(char);
      }
    }

    values.add(current.toString());
    return values;
  }
}

/// Parsed award record from CSV.
class ParsedAwardRecord {
  final String name;
  final String city;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? designation; // For Michelin
  final String? category; // For James Beard
  final String? distinction; // For James Beard
  final int year;

  ParsedAwardRecord({
    required this.name,
    required this.city,
    this.address,
    this.latitude,
    this.longitude,
    this.designation,
    this.category,
    this.distinction,
    required this.year,
  });
}
