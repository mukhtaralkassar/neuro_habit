import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:neuro_habit/main.dart';
import 'package:neuro_habit/data/models/habit_model.dart';
import 'package:neuro_habit/data/data_sources/local/habit_local_data_source.dart';
import 'package:neuro_habit/data/repositories/habit_repository_impl.dart';

// Fake Local Data Source for testing without initializing Hive
// This ensures tests run quickly and without storage dependencies
class FakeHabitLocalDataSource implements HabitLocalDataSource {
  List<HabitModel> habits = [];

  @override
  Future<List<HabitModel>> getHabits() async {
    return habits;
  }

  @override
  Future<void> updateHabit(HabitModel habit) async {
    final index = habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      habits[index] = habit;
    }
  }
  
  @override
  Future<void> addHabit(HabitModel habit) async{
    habits.add(habit);

  }
}

void main() {
  testWidgets('NeuroHabit app smoke test', (WidgetTester tester) async {
    // Arrange: Setup the fake data source and repository
    final fakeDataSource = FakeHabitLocalDataSource();
    final repository = HabitRepositoryImpl(localDataSource: fakeDataSource);

    // Act: Build our app and trigger a frame
    await tester.pumpWidget(NeuroHabitApp(repository: repository));
    
    // Wait for the Cubit to finish its initial loading state
    await tester.pumpAndSettle();

    // Assert: Verify that the main dashboard UI elements are present
    expect(find.text('Good Morning, Alex'), findsOneWidget);
    expect(find.text('Today\'s Focus'), findsOneWidget);
    
    // Assert: Verify that our floating action button exists
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}