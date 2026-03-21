import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/habit.dart';
import '../../domain/repositories/habit_repository.dart';
import 'habit_state.dart';

// Cubit managing the state and business logic of the habits dashboard
class HabitCubit extends Cubit<HabitState> {
  final HabitRepository repository;
  final Uuid _uuid = const Uuid();

  HabitCubit({required this.repository}) : super(HabitInitial());

  // Fetch habits, check for new day, and calculate focus percentage
  Future<void> loadHabits() async {
    emit(HabitLoading());
    try {
      // Open settings box to check the last time the app was opened
      final settingsBox = await Hive.openBox('settings_box');
      final lastOpenedDate = settingsBox.get('last_opened_date') as String?;
      final todayStr = DateTime.now().toIso8601String().split('T')[0]; // Format: YYYY-MM-DD

      List<Habit> habits = await repository.getHabits();

      // If it's a new day, reset all tasks so it looks like the first time today
      if (lastOpenedDate != todayStr) {
        for (var habit in habits) {
          if (habit.isCompleted) {
            // Revert completion status to false for the new day
            await repository.toggleHabitCompletion(habit);
          }
        }
        // Update the last opened date to today
        await settingsBox.put('last_opened_date', todayStr);
        // Reload habits after resetting
        habits = await repository.getHabits();
      }

      // Seed initial mock data if database is completely empty for demonstration
      if (habits.isEmpty) {
        final dateNow = DateTime.now();
        await repository.addHabit(Habit(id: _uuid.v4(), title: 'Drink 2L Water', mood: 'calm', createdAt: dateNow));
        await repository.addHabit(Habit(id: _uuid.v4(), title: 'Read 10 Pages', mood: 'focused', createdAt: dateNow));
        await repository.addHabit(Habit(id: _uuid.v4(), title: 'Morning Workout', mood: 'energetic', createdAt: dateNow));
        habits = await repository.getHabits();
      }

      emit(HabitLoaded(habits: habits, focusPercentage: _calculateFocus(habits)));
    } catch (e) {
      emit(HabitError(message: e.toString()));
    }
  }

  // Add a new habit from user input with the current date
  Future<void> addNewHabit(String title, String mood) async {
    try {
      final newHabit = Habit(
        id: _uuid.v4(), // Generate unique ID for local storage
        title: title,
        mood: mood,
        isCompleted: false,
        createdAt: DateTime.now(), // Saving the specific date with the task
      );
      await repository.addHabit(newHabit);
      // Reload habits to update the UI and charts
      final habits = await repository.getHabits();
      emit(HabitLoaded(habits: habits, focusPercentage: _calculateFocus(habits)));
    } catch (e) {
      emit(HabitError(message: e.toString()));
    }
  }

  // Toggle habit completion status and refresh state
  Future<void> toggleHabit(Habit habit) async {
    try {
      await repository.toggleHabitCompletion(habit);
      final habits = await repository.getHabits();
      emit(HabitLoaded(habits: habits, focusPercentage: _calculateFocus(habits)));
    } catch (e) {
      emit(HabitError(message: e.toString()));
    }
  }

  // Private helper to calculate completion percentage for the dashboard chart/card
  double _calculateFocus(List<Habit> habits) {
    if (habits.isEmpty) return 0.0;
    final completed = habits.where((h) => h.isCompleted).length;
    return (completed / habits.length) * 100;
  }
}