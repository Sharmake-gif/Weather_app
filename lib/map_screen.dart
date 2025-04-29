import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weatherly - Radar Map')),
      body: Center(child: Text('Real-time Radar/Satellite Map')),
    );
  }
}
