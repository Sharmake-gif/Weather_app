class ReportModel {
  final String user;
  final String location;
  final String condition;
  final DateTime timestamp;

  ReportModel({
    required this.user,
    required this.location,
    required this.condition,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'location': location,
      'condition': condition,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  static ReportModel fromMap(Map<String, dynamic> map) {
    return ReportModel(
      user: map['user'] ?? 'Anonymous',
      location: map['location'] ?? 'Unknown',
      condition: map['condition'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
