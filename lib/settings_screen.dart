import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final void Function(bool)? onThemeChanged;
  final void Function()? onBackToHomePressed;

  const SettingsScreen({
    Key? key,
    this.onThemeChanged,
    this.onBackToHomePressed,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isCelsius = true;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isCelsius = prefs.getBool('isCelsius') ?? true;
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> updateSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  void toggleTemperatureUnit(bool value) {
    setState(() {
      isCelsius = value;
    });
    updateSetting('isCelsius', value);
  }

  void toggleDarkMode(bool value) async {
    setState(() {
      isDarkMode = value;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);

    if (widget.onThemeChanged != null) {
      widget.onThemeChanged!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Use Celsius (°C)'),
            subtitle: const Text('Toggle between Celsius and Fahrenheit'),
            value: isCelsius,
            onChanged: toggleTemperatureUnit,
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Toggle app theme'),
            value: isDarkMode,
            onChanged: toggleDarkMode,
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.home),
              label: const Text('Back to Home'),
              onPressed: () {
                if (widget.onBackToHomePressed != null) {
                  widget.onBackToHomePressed!();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
