class Pointage {
  final String id;
  final DateTime date;
  final String userId;
  // Add other relevant fields for a pointage entry

  Pointage({
    required this.id,
    required this.date,
    required this.userId,
    // Initialize other fields
  });

  // Factory constructor for JSON deserialization
  factory Pointage.fromJson(Map<String, dynamic> json) {
    return Pointage(
      id: json['id'],
      date: DateTime.parse(json['date']),
      userId: json['userId'],
      // Parse other fields
    );
  }

  // Method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'userId': userId,
      // Add other fields
    };
  }
}
