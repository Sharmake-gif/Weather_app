import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  static const String apiKey = '977a17ce9e71f6d93568dca1337573a3';

  /// Fetch current weather (no auth issue)
  static Future<Map<String, dynamic>?> fetchCurrentWeather(
    double lat,
    double lon,
  ) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Error fetching current weather: ${response.statusCode}');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> fetch5DayForecast(
    double lat,
    double lon,
  ) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List list = data['list'];

      Map<String, List<Map<String, dynamic>>> grouped = {};

      for (var entry in list) {
        final dtTxt = entry['dt_txt'] as String;
        final date = dtTxt.split(' ')[0]; // e.g. "2025-05-03"
        grouped.putIfAbsent(date, () => []).add(entry);
      }

      final result =
          grouped.entries.map((e) {
            final temps =
                e.value.map((item) => item['main']['temp'] as num).toList();
            final avgTemp = temps.reduce((a, b) => a + b) / temps.length;
            final description = e.value.first['weather'][0]['description'];

            return {
              'date': e.key,
              'avg_temp': avgTemp,
              'description': description,
            };
          }).toList();

      return result;
    } else {
      print('Error fetching 6-day forecast: ${response.statusCode}');
      return null;
    }
  }
}
