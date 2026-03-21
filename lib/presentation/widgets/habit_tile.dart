import 'package:flutter/material.dart';
import '../../domain/entities/habit.dart';

// Custom animated tile representing a single habit linked to mood
class HabitTile extends StatelessWidget {
  final Habit habit;
  final VoidCallback onTap;

  const HabitTile({super.key, required this.habit, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: habit.isCompleted 
            ? const Color(0xFF311B92).withOpacity(0.6) 
            : const Color(0xFF311B92).withOpacity(0.2), // Deep Purple tint adapting to state
          borderRadius: BorderRadius.circular(24), // Human touch smooth radius
          boxShadow: [
            if (habit.isCompleted)
              BoxShadow(
                color: const Color(0xFF64FFDA).withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
              )
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: habit.isCompleted ? const Color(0xFF64FFDA) : const Color(0xFF311B92),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check, 
                    color: habit.isCompleted ? const Color(0xFF121212) : const Color(0xFF64FFDA).withOpacity(0.3), 
                    size: 20,
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  habit.title,
                  style: TextStyle(
                    color: habit.isCompleted ? Colors.white54 : Colors.white, 
                    fontSize: 16, 
                    fontWeight: FontWeight.w500,
                    decoration: habit.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
              ],
            ),
            Icon(
              habit.mood == 'focused' ? Icons.local_fire_department : Icons.water_drop, 
              color: habit.isCompleted ? const Color(0xFF64FFDA) : Colors.white54,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}