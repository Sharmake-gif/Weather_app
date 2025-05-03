import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'weather_service.dart';
import 'location_service.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  List<Map<String, dynamic>> forecastData = [];
  bool isLoading = true;
  String error = '';
  bool isCelsius = true;

  @override
  void initState() {
    super.initState();
    loadForecast();
  }

  Future<void> loadForecast() async {
    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      isCelsius = prefs.getBool('isCelsius') ?? true;

      final location = await LocationService.getCurrentLocation();
      final data = await WeatherService.fetch5DayForecast(
        location.latitude,
        location.longitude,
      );

      if (data != null && data.isNotEmpty) {
        setState(() {
          forecastData = data;
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Forecast data is empty or missing.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Failed to load forecast.';
        isLoading = false;
      });
    }
  }

  String formatTemp(num kelvin) {
    return isCelsius
        ? '${(kelvin - 273.15).toStringAsFixed(1)} °C'
        : '${((kelvin - 273.15) * 9 / 5 + 32).toStringAsFixed(1)} °F';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('6-Day Forecast')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : error.isNotEmpty
              ? Center(child: Text(error))
              : ListView.builder(
                itemCount: forecastData.length,
                itemBuilder: (context, index) {
                  final day = forecastData[index];
                  return ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: Text(day['date']),
                    subtitle: Text(day['description']),
                    trailing: Text(formatTemp(day['avg_temp'])),
                  );
                },
              ),
    );
  }
}
