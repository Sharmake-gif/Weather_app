import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'home_view.dart';
import 'forecast_screen.dart';
import 'alerts_screen.dart';
import 'map_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';
import 'themes_screen.dart';
import 'splash_screen.dart';
import 'firebase_options.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;

  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(android: androidSettings),
  );

  runApp(WeatherlyApp(isDarkMode: isDarkMode));
}

class WeatherlyApp extends StatefulWidget {
  final bool isDarkMode;
  const WeatherlyApp({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  State<WeatherlyApp> createState() => _WeatherlyAppState();
}

class _WeatherlyAppState extends State<WeatherlyApp> {
  late bool _isDarkMode;
  bool showSplash = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
    _setupFirebaseMessaging();
  }

  void _setupFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        final notification = message.notification!;
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'weather_channel',
              'Weather Alerts',
              importance: Importance.high,
              priority: Priority.high,
            ),
          ),
        );
      }
    });
  }

  List<Widget> get _screens => [
    HomeView(),
    ForecastScreen(),
    AlertsScreen(),
    MapScreen(),
    ReportsScreen(),
    SettingsScreen(
      onThemeChanged: (bool value) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isDarkMode', value);
        setState(() {
          _isDarkMode = value;
        });
      },
      onBackToHomePressed: () {
        setState(() {
          _currentIndex = 0;
        });
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weatherly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        useMaterial3: true,
        primarySwatch: Colors.lightBlue,
      ),
      home:
          showSplash
              ? SplashScreen(
                onComplete: () {
                  setState(() {
                    showSplash = false;
                  });
                },
              )
              : Scaffold(
                body: _screens[_currentIndex],
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: _currentIndex,
                  selectedItemColor: Colors.lightBlue,
                  unselectedItemColor: Colors.grey,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_today),
                      label: 'Forecast',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.warning),
                      label: 'Alerts',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.map),
                      label: 'Map',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.message),
                      label: 'Reports',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: 'Settings',
                    ),
                  ],
                ),
              ),
    );
  }
}
