import '../../domain/entities/habit.dart';
import '../../domain/repositories/habit_repository.dart';
import '../data_sources/local/habit_local_data_source.dart';
import '../models/habit_model.dart';

class HabitRepositoryImpl implements HabitRepository {
  final HabitLocalDataSource localDataSource;

  HabitRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Habit>> getHabits() async {
    return await localDataSource.getHabits();
  }

  @override
  Future<void> addHabit(Habit habit) async {
    // FIX: Added 'createdAt' argument that was missing
    final habitModel = HabitModel(
      id: habit.id,
      title: habit.title,
      mood: habit.mood,
      isCompleted: habit.isCompleted,
      createdAt: habit.createdAt, 
    );
    await localDataSource.addHabit(habitModel);
  }

  @override
  Future<void> toggleHabitCompletion(Habit habit) async {
    // FIX: Added 'createdAt' argument that was missing
    final updatedModel = HabitModel(
      id: habit.id,
      title: habit.title,
      mood: habit.mood,
      isCompleted: !habit.isCompleted,
      createdAt: habit.createdAt, 
    );
    await localDataSource.updateHabit(updatedModel);
  }
}