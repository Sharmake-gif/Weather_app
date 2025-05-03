import 'package:flutter/material.dart';
import 'location_service.dart';
import 'weather_service.dart';
import 'postcard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Map<String, dynamic>? weatherData;
  bool isLoading = true;
  String error = '';
  bool isCelsius = true;

  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  Future<void> loadWeather() async {
    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      isCelsius = prefs.getBool('isCelsius') ?? true;

      final location = await LocationService.getCurrentLocation();
      final data = await WeatherService.fetchCurrentWeather(
        location.latitude,
        location.longitude,
      );

      if (data != null) {
        setState(() {
          weatherData = data;
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load weather.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Something went wrong.';
        isLoading = false;
      });
    }
  }

  String formatTemp(num kelvin) {
    if (isCelsius) {
      return '${(kelvin - 273.15).toStringAsFixed(1)} °C';
    } else {
      return '${((kelvin - 273.15) * 9 / 5 + 32).toStringAsFixed(1)} °F';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weatherly'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: loadWeather),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : error.isNotEmpty
              ? Center(child: Text(error))
              : weatherData == null
              ? const Center(child: Text('No weather data'))
              : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      weatherData!['name'] ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Icon(Icons.wb_sunny, size: 48, color: Colors.amber),
                    const SizedBox(height: 16),
                    Text(
                      formatTemp(weatherData!['main']['temp']),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      weatherData!['weather'][0]['description']
                          .toString()
                          .toLowerCase(),
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.post_add),
                      label: const Text('Share Weather Postcard'),
                      onPressed: () {
                        if (weatherData != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => PostcardScreen(
                                    location: weatherData!['name'] ?? 'Unknown',
                                    description:
                                        weatherData!['weather'][0]['description'] ??
                                        '',
                                    temperature:
                                        double.tryParse(
                                          formatTemp(
                                            weatherData!['main']['temp'],
                                          ).split(' ').first,
                                        ) ??
                                        0.0,
                                  ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Weather data not available'),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
    );
  }
}
