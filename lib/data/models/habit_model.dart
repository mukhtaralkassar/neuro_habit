import '../../domain/entities/habit.dart';

// Data model handling JSON serialization/deserialization for Hive local storage
class HabitModel extends Habit {
  const HabitModel({
    required super.id,
    required super.title,
    required super.mood,
    required super.isCompleted,
    required super.createdAt,
  });

  factory HabitModel.fromJson(Map<String, dynamic> json) {
    return HabitModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      mood: json['mood'] ?? 'focused',
      isCompleted: json['isCompleted'] ?? false,
      // Parse the date, use current time as fallback for old data
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(), 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'mood': mood,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(), // Save date as string
    };
  }
}