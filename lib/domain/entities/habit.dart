// The core entity representing a Habit, updated to store the creation date
class Habit {
  final String id;
  final String title;
  final String mood;
  final bool isCompleted;
  final DateTime createdAt; // NEW: Track the date the task was created or saved

  const Habit({
    required this.id,
    required this.title,
    required this.mood,
    this.isCompleted = false,
    required this.createdAt,
  });
}