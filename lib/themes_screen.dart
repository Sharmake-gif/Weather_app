import 'package:flutter/material.dart';

class ThemesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weatherly - Themes')),
      body: Center(child: Text('Choose Light, Dark, or Custom Backgrounds')),
    );
  }
}
