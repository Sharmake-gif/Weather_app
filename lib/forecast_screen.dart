import 'package:flutter/material.dart';

class ForecastScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weatherly - Forecast')),
      body: Center(child: Text('Hourly and 7-Day Forecast')),
    );
  }
}
