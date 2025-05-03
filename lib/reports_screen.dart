import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'report_model.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();

  Future<void> submitReport() async {
    final report = ReportModel(
      user: 'Weatherly User',
      location: _locationController.text.trim(),
      condition: _conditionController.text.trim(),
      timestamp: DateTime.now(),
    );

    await FirebaseFirestore.instance
        .collection('weather_reports')
        .add(report.toMap());

    _locationController.clear();
    _conditionController.clear();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Report submitted!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community Reports')),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Your Location'),
                ),
                TextField(
                  controller: _conditionController,
                  decoration: const InputDecoration(
                    labelText: 'Weather Condition',
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: submitReport,
                  child: const Text('Submit Report'),
                ),
              ],
            ),
          ),
          const Divider(),
          const Text('Live Reports', style: TextStyle(fontSize: 18)),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('weather_reports')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                return ListView(
                  children:
                      docs.map((doc) {
                        final data = ReportModel.fromMap(
                          doc.data() as Map<String, dynamic>,
                        );
                        return ListTile(
                          title: Text(data.condition),
                          subtitle: Text('${data.location} - ${data.user}'),
                          trailing: Text(
                            '${data.timestamp.hour}:${data.timestamp.minute.toString().padLeft(2, '0')}',
                          ),
                        );
                      }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
