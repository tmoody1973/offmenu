/// Utility for rounding DateTime values to reservation-friendly intervals.
class DateTimeRounder {
  /// Round datetime to nearest 15-minute increment.
  ///
  /// Uses standard rounding: rounds down for 0-7 minutes past quarter,
  /// rounds up for 8-14 minutes past quarter.
  static DateTime roundToNearest15Minutes(DateTime dateTime) {
    final minutes = dateTime.minute;
    final remainder = minutes % 15;

    int roundedMinutes;
    int hourAdjustment = 0;

    if (remainder < 8) {
      // Round down
      roundedMinutes = minutes - remainder;
    } else {
      // Round up
      roundedMinutes = minutes + (15 - remainder);
      if (roundedMinutes >= 60) {
        roundedMinutes = 0;
        hourAdjustment = 1;
      }
    }

    final newDateTime = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour + hourAdjustment,
      roundedMinutes,
    );

    return newDateTime;
  }

  /// Round datetime to next 15-minute slot.
  ///
  /// Always rounds up to the next quarter hour unless already at a quarter hour.
  static DateTime roundToNext15Minutes(DateTime dateTime) {
    final minutes = dateTime.minute;
    final seconds = dateTime.second;
    final remainder = minutes % 15;

    // If exactly on a 15-minute mark and no seconds, return as is
    if (remainder == 0 && seconds == 0) {
      return DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        dateTime.hour,
        minutes,
      );
    }

    int roundedMinutes = minutes + (15 - remainder);
    int hourAdjustment = 0;

    if (roundedMinutes >= 60) {
      roundedMinutes = 0;
      hourAdjustment = 1;
    }

    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour + hourAdjustment,
      roundedMinutes,
    );
  }
}
