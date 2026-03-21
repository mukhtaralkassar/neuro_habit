import 'package:hive/hive.dart';
import '../../models/habit_model.dart';

abstract class HabitLocalDataSource {
  Future<List<HabitModel>> getHabits();
  Future<void> addHabit(HabitModel habit);
  Future<void> updateHabit(HabitModel habit);
}

class HabitLocalDataSourceImpl implements HabitLocalDataSource {
  final Box box;

  HabitLocalDataSourceImpl(this.box);

  @override
  Future<List<HabitModel>> getHabits() async {
    final habitsList = box.values.toList();
    return habitsList
        .map((e) => HabitModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  @override
  Future<void> addHabit(HabitModel habit) async {
    await box.put(habit.id, habit.toJson());
  }

  @override
  Future<void> updateHabit(HabitModel habit) async {
    await box.put(habit.id, habit.toJson());
  }
}