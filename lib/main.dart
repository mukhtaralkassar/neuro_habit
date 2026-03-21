import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data/data_sources/local/habit_local_data_source.dart';
import 'data/repositories/habit_repository_impl.dart';
import 'presentation/cubit/habit_cubit.dart';
import 'presentation/screens/dashboard/habit_dashboard_screen.dart';

void main() async {
  // Ensure Flutter bindings are initialized before Hive
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for offline local storage
  await Hive.initFlutter();
  
  // Open the box for storing habits
  final box = await Hive.openBox('habits_box');

  // Setup Dependency Injection manually
  final localDataSource = HabitLocalDataSourceImpl(box);
  final repository = HabitRepositoryImpl(localDataSource: localDataSource);

  runApp(NeuroHabitApp(repository: repository));
}

class NeuroHabitApp extends StatelessWidget {
  final HabitRepositoryImpl repository;

  const NeuroHabitApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HabitCubit(repository: repository)..loadHabits(),
      child: MaterialApp(
        title: 'NeuroHabit',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFF121212), // Dark Surface
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF64FFDA), // Neon Mint
            secondary: Color(0xFF311B92), // Deep Purple
            surface: Color(0xFF121212),
          ),
          fontFamily: 'Roboto', // Default clean font
          useMaterial3: true,
        ),
        home: const HabitDashboardScreen(),
      ),
    );
  }
}