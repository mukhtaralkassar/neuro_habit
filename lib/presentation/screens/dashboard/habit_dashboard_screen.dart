import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/habit_cubit.dart';
import '../../cubit/habit_state.dart';
import '../../widgets/glassmorphism_card.dart';
import '../../widgets/habit_tile.dart';
import '../../widgets/add_habit_sheet.dart';
import '../../widgets/mood_chart.dart';

/// Main Dashboard Screen for NeuroHabit applying state management
class HabitDashboardScreen extends StatefulWidget {
  const HabitDashboardScreen({super.key});

  @override
  State<HabitDashboardScreen> createState() => _HabitDashboardScreenState();
}

class _HabitDashboardScreenState extends State<HabitDashboardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Pulse animation for the floating action button
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _showAddHabitSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Transparent to show custom container radius
      builder: (_) => BlocProvider.value(
        value: context.read<HabitCubit>(), // Pass existing cubit to bottom sheet
        child: const AddHabitSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark Surface
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Good Morning',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.insights, color: Color(0xFF64FFDA)), // Neon Mint
            onPressed: () {},
          )
        ],
      ),
      body: BlocBuilder<HabitCubit, HabitState>(
        builder: (context, state) {
          if (state is HabitLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF64FFDA)),
            );
          } else if (state is HabitError) {
            return Center(
              child: Text(state.message, style: const TextStyle(color: Colors.redAccent)),
            );
          } else if (state is HabitLoaded) {
            // Full scrollable screen using SingleChildScrollView
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    // Glassmorphism insight card
                    GlassmorphismCard(percentage: state.focusPercentage),
                    
                    const SizedBox(height: 20),
                    const Text(
                      'Focus Trend (Last 7 Days)',
                      style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    
                    // Hand-built Custom Chart Integration
                    MoodChart(currentFocus: state.focusPercentage),

                    const SizedBox(height: 30),
                    const Text(
                      'Daily Tasks',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    
                    // List of Habits (shrinkWrap allows it to size correctly inside ScrollView)
                    if (state.habits.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40.0),
                          child: Text(
                            'No habits yet. Tap + to add one!',
                            style: TextStyle(color: Colors.white.withOpacity(0.5)),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(), // Scroll is handled by SingleChildScrollView
                        shrinkWrap: true, // Prevents layout errors inside Column
                        itemCount: state.habits.length,
                        itemBuilder: (context, index) {
                          final habit = state.habits[index];
                          return HabitTile(
                            habit: habit,
                            onTap: () {
                              context.read<HabitCubit>().toggleHabit(habit);
                            },
                          );
                        },
                      ),
                      
                    const SizedBox(height: 100), // Extra padding at bottom to prevent FAB overlap
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: ScaleTransition(
        scale: _scaleAnimation,
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF64FFDA), // Neon Mint
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24), // Human touch smooth radius
          ),
          child: const Icon(Icons.add, color: Color(0xFF311B92), size: 30), // Deep Purple
          onPressed: () => _showAddHabitSheet(context),
        ),
      ),
    );
  }
}