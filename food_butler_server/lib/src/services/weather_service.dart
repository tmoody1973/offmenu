import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

/// Service for fetching weather data from Open-Meteo (free, no API key required).
class WeatherService {
  final Session session;

  WeatherService({required this.session});

  /// Fetch current weather for given coordinates.
  /// Returns null if the request fails.
  Future<WeatherData?> getCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      // Open-Meteo API - free, no key required
      final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
        '?latitude=$latitude'
        '&longitude=$longitude'
        '&current=temperature_2m,relative_humidity_2m,apparent_temperature,'
        'precipitation,rain,weather_code,wind_speed_10m'
        '&temperature_unit=fahrenheit'
        '&wind_speed_unit=mph'
        '&precipitation_unit=inch'
        '&timezone=auto',
      );

      session.log('Fetching weather from Open-Meteo for ($latitude, $longitude)');
      final response = await http.get(url);

      if (response.statusCode != 200) {
        session.log('Weather API error: ${response.statusCode}', level: LogLevel.warning);
        return null;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final current = data['current'] as Map<String, dynamic>?;

      if (current == null) {
        session.log('No current weather data in response');
        return null;
      }

      final weatherCode = current['weather_code'] as int? ?? 0;
      final temperature = (current['temperature_2m'] as num?)?.toDouble() ?? 70;
      final feelsLike = (current['apparent_temperature'] as num?)?.toDouble() ?? temperature;
      final humidity = (current['relative_humidity_2m'] as num?)?.toInt() ?? 50;
      final precipitation = (current['precipitation'] as num?)?.toDouble() ?? 0;
      final rain = (current['rain'] as num?)?.toDouble() ?? 0;
      final windSpeed = (current['wind_speed_10m'] as num?)?.toDouble() ?? 0;

      final weather = WeatherData(
        temperature: temperature,
        feelsLike: feelsLike,
        humidity: humidity,
        precipitation: precipitation,
        isRaining: rain > 0,
        weatherCode: weatherCode,
        condition: _getWeatherCondition(weatherCode),
        windSpeed: windSpeed,
      );

      session.log('Weather: ${weather.condition} ${weather.temperature.round()}F (feels like ${weather.feelsLike.round()}F)');
      return weather;
    } catch (e) {
      session.log('Error fetching weather: $e', level: LogLevel.warning);
      return null;
    }
  }

  /// Get human-readable weather condition from WMO weather code.
  /// https://open-meteo.com/en/docs#weathervariables
  String _getWeatherCondition(int code) {
    switch (code) {
      case 0:
        return 'clear';
      case 1:
      case 2:
      case 3:
        return 'partly cloudy';
      case 45:
      case 48:
        return 'foggy';
      case 51:
      case 53:
      case 55:
        return 'drizzling';
      case 56:
      case 57:
        return 'freezing drizzle';
      case 61:
      case 63:
      case 65:
        return 'raining';
      case 66:
      case 67:
        return 'freezing rain';
      case 71:
      case 73:
      case 75:
        return 'snowing';
      case 77:
        return 'snow grains';
      case 80:
      case 81:
      case 82:
        return 'rain showers';
      case 85:
      case 86:
        return 'snow showers';
      case 95:
        return 'thunderstorm';
      case 96:
      case 99:
        return 'thunderstorm with hail';
      default:
        return 'unknown';
    }
  }
}

/// Weather data returned from the API.
class WeatherData {
  final double temperature; // Fahrenheit
  final double feelsLike; // Fahrenheit
  final int humidity; // Percentage
  final double precipitation; // Inches
  final bool isRaining;
  final int weatherCode; // WMO code
  final String condition; // Human-readable
  final double windSpeed; // MPH

  WeatherData({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.precipitation,
    required this.isRaining,
    required this.weatherCode,
    required this.condition,
    required this.windSpeed,
  });

  /// Get food-focused weather description for the prompt.
  String getFoodContext() {
    final tempDesc = temperature < 40
        ? 'cold'
        : temperature < 60
            ? 'cool'
            : temperature < 75
                ? 'pleasant'
                : temperature < 85
                    ? 'warm'
                    : 'hot';

    final buffer = StringBuffer();
    buffer.write('Weather: $tempDesc (${temperature.round()}F');
    if ((feelsLike - temperature).abs() > 5) {
      buffer.write(', feels like ${feelsLike.round()}F');
    }
    buffer.write(')');

    if (isRaining) {
      buffer.write(', currently raining');
    } else if (condition == 'thunderstorm' || condition == 'thunderstorm with hail') {
      buffer.write(', stormy');
    } else if (condition == 'snowing' || condition == 'snow showers') {
      buffer.write(', snowing');
    } else if (condition == 'foggy') {
      buffer.write(', foggy');
    }

    if (windSpeed > 20) {
      buffer.write(', windy');
    }

    return buffer.toString();
  }

  /// Get mood-based food suggestions based on weather.
  String getFoodMoodSuggestions() {
    final suggestions = <String>[];

    // Temperature-based suggestions
    if (temperature < 50) {
      suggestions.addAll([
        'Perfect for: soup, ramen, pho, hot pot, stew, warm comfort food',
        'Weather calls for something warming and comforting',
      ]);
    } else if (temperature > 85) {
      suggestions.addAll([
        'Perfect for: cold noodles, poke, ceviche, salads, ice cream, smoothies',
        'Weather calls for something light and refreshing',
      ]);
    } else if (temperature > 75) {
      suggestions.addAll([
        'Great for: patio dining, outdoor seating, light fare',
      ]);
    }

    // Rain-based suggestions
    if (isRaining) {
      suggestions.add('Rainy day vibes: cozy spots, comfort food, places with good ambiance');
    }

    // Storm-based suggestions
    if (condition.contains('thunder') || condition.contains('storm')) {
      suggestions.add('Stormy weather: best to stay somewhere cozy with good food');
    }

    return suggestions.join('\n');
  }
}
