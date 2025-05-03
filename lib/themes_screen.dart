import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemesScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const ThemesScreen({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  State<ThemesScreen> createState() => _ThemesScreenState();
}

class _ThemesScreenState extends State<ThemesScreen> {
  late bool _isDark;

  @override
  void initState() {
    super.initState();
    _isDark = widget.isDarkMode;
  }

  Future<void> _toggleTheme(bool value) async {
    setState(() {
      _isDark = value;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDark);

    widget.onThemeChanged(_isDark);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theme Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _isDark,
            onChanged: _toggleTheme,
          ),
        ],
      ),
    );
  }
}