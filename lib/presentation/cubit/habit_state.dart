import 'package:equatable/equatable.dart';
import '../../domain/entities/habit.dart';

// Base state for habit feature
abstract class HabitState extends Equatable {
  const HabitState();

  @override
  List<Object> get props => [];
}

// Initial state before loading
class HabitInitial extends HabitState {}

// Loading state during async operations
class HabitLoading extends HabitState {}

// Success state holding the list of habits and computed stats
class HabitLoaded extends HabitState {
  final List<Habit> habits;
  final double focusPercentage;

  const HabitLoaded({required this.habits, required this.focusPercentage});

  @override
  List<Object> get props => [habits, focusPercentage];
}

// Error state if something goes wrong
class HabitError extends HabitState {
  final String message;

  const HabitError({required this.message});

  @override
  List<Object> get props => [message];
}