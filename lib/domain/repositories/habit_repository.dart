import '../entities/habit.dart';

// Abstract repository defining the contract for habit data operations
abstract class HabitRepository {
  Future<List<Habit>> getHabits();
  Future<void> addHabit(Habit habit);
  Future<void> toggleHabitCompletion(Habit habit);
}