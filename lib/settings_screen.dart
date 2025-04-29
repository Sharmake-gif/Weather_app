import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weatherly - Settings')),
      body: Center(child: Text('Units, Notification Settings, Preferences')),
    );
  }
}
