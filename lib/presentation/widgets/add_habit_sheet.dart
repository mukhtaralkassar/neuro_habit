import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/habit_cubit.dart';

// Bottom sheet to add a new habit with mood selection
class AddHabitSheet extends StatefulWidget {
  const AddHabitSheet({super.key});

  @override
  State<AddHabitSheet> createState() => _AddHabitSheetState();
}

class _AddHabitSheetState extends State<AddHabitSheet> {
  final TextEditingController _titleController = TextEditingController();
  String _selectedMood = 'focused'; // Default mood

  final List<Map<String, dynamic>> _moods = [
    {'name': 'focused', 'icon': Icons.local_fire_department, 'color': const Color(0xFF64FFDA)}, // Mint
    {'name': 'calm', 'icon': Icons.water_drop, 'color': Colors.blueAccent},
    {'name': 'energetic', 'icon': Icons.bolt, 'color': Colors.amberAccent},
  ];

  void _submit() {
    if (_titleController.text.trim().isNotEmpty) {
      context.read<HabitCubit>().addNewHabit(
        _titleController.text.trim(),
        _selectedMood,
      );
      Navigator.pop(context); // Close sheet after adding
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E), // Slightly lighter than background
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)), // Human touch smooth radius
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'New NeuroHabit',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          // Habit Title Input
          TextField(
            controller: _titleController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'E.g. 10 minutes meditation...',
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: const Color(0xFF121212),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(color: Color(0xFF64FFDA), width: 1), // Neon Mint focus
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Select Mood State',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 16),
          // Mood Selectors
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _moods.map((mood) {
              final isSelected = _selectedMood == mood['name'];
              return GestureDetector(
                onTap: () => setState(() => _selectedMood = mood['name']),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF311B92) : const Color(0xFF121212), // Deep purple if selected
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected ? mood['color'] : Colors.transparent,
                      width: 1.5,
                    ),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: mood['color'].withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 1,
                        )
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(mood['icon'], color: mood['color'], size: 20),
                      if (isSelected) const SizedBox(width: 8),
                      if (isSelected)
                        Text(
                          mood['name'].toString().capitalize(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        )
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF64FFDA), // Neon Mint
                foregroundColor: const Color(0xFF311B92), // Deep Purple text
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 10,
                shadowColor: const Color(0xFF64FFDA).withOpacity(0.5),
              ),
              onPressed: _submit,
              child: const Text(
                'Create Habit',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// Extension to capitalize first letter
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}