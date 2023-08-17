import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 0)
class Medicine {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final DateTime reminderTime;

  @HiveField(2)
  final int dayInterval;

  @HiveField(3)
  DateTime? lastTaken;

  Medicine({required this.name, required this.reminderTime, required this.dayInterval, this.lastTaken});

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      name: json['name'],
      reminderTime: DateTime.parse(json['reminderTime']),
      dayInterval: json['dayInterval'],
      lastTaken: json['lastTaken'] != null ? DateTime.parse(json['lastTaken']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'reminderTime': reminderTime.toIso8601String(),
      'dayInterval': dayInterval,
      'lastTaken': lastTaken?.toIso8601String(),
    };
  }
}
