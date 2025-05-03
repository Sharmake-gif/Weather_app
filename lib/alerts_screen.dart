import 'package:flutter/material.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key}); 
  @override
  _AlertsScreenState createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  List<Map<String, dynamic>> alerts = [];
  bool isLoading = true;

  final List<Map<String, dynamic>> demoAlerts = [
    {
      "event": "⚠️ Severe Thunderstorm Warning",
      "description":
          "Heavy thunderstorms with lightning and strong winds expected this afternoon. Seek shelter and avoid open areas.",
    },
    {
      "event": "⚠️ Heat Advisory",
      "description":
          "Temperatures expected to reach 92°F (33°C) with high humidity. Stay hydrated and avoid prolonged outdoor activities.",
    },
    {
      "event": "⚠️ High Pollen Alert",
      "description":
          "Tree and grass pollen levels are high. Those with allergies should limit outdoor exposure and take medications as prescribed.",
    },
    {
      "event": "⚠️ Flood Watch",
      "description":
          "Heavy rain could lead to flash flooding in low-lying areas. Avoid driving through standing water.",
    },
    {
      "event": "☀️ Sunny Weekend Ahead",
      "description":
          "Expect clear skies and sunshine through the weekend. Great weather for outdoor plans!",
    },
    {
      "event": "⚠️ Air Quality Advisory",
      "description":
          "Smog and ozone levels may be elevated due to stagnant air. Sensitive groups should avoid outdoor exertion.",
    },
  ];

  @override
  void initState() {
    super.initState();
    loadAlerts();
  }

  Future<void> loadAlerts() async {
    await Future.delayed(const Duration(seconds: 1)); 
    setState(() {
      alerts = demoAlerts;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather Alerts')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : alerts.isEmpty
              ? const Center(child: Text('No active alerts.'))
              : ListView.builder(
                itemCount: alerts.length,
                itemBuilder: (context, index) {
                  final alert = alerts[index];
                  return ListTile(
                    title: Text(alert['event'] ?? 'Alert'),
                    subtitle: Text(alert['description'] ?? 'No details'),
                  );
                },
              ),
    );
  }
}
