import 'dart:ui';
import 'package:flutter/material.dart';

// A reusable frosted glass effect card for dashboard insights
class GlassmorphismCard extends StatelessWidget {
  final double percentage;

  const GlassmorphismCard({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24), // Smooth human-touch border
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            // Soft shadow for floating effect
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: -5,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mental Clarity',
                style: TextStyle(color: Color(0xFF64FFDA), fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                '${percentage.toInt()}%',
                style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                percentage > 50 
                  ? 'You are highly focused today. Keep it up!'
                  : 'Take a deep breath. Let\'s build momentum.',
                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}