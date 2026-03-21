import 'package:flutter/material.dart';
import 'dart:ui' as ui;

// A custom hand-built chart to visualize mood and completion without external packages
class MoodChart extends StatelessWidget {
  final double currentFocus;

  const MoodChart({super.key, required this.currentFocus});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF311B92).withOpacity(0.1), // Very light deep purple
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF311B92).withOpacity(0.3)),
      ),
      child: CustomPaint(
        painter: _LineChartPainter(currentFocus: currentFocus),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final double currentFocus;

  _LineChartPainter({required this.currentFocus});

  @override
  void paint(Canvas canvas, Size size) {
    // Generate some mock historical data, ending with the current real data
    final List<double> dataPoints = [40, 60, 30, 80, 50, 90, currentFocus];
    
    final paintLine = Paint()
      ..color = const Color(0xFF64FFDA) // Neon Mint
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..imageFilter = ui.ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5); // Soft glow

    final paintShadow = Paint()
      ..color = const Color(0xFF64FFDA).withOpacity(0.2)
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..imageFilter = ui.ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0);

    final path = Path();
    final double stepX = size.width / (dataPoints.length - 1);
    
    for (int i = 0; i < dataPoints.length; i++) {
      // Convert percentage (0-100) to Y coordinate (inverted because Y grows downwards)
      final double normalizedY = size.height - ((dataPoints[i] / 100) * size.height);
      final double x = i * stepX;

      if (i == 0) {
        path.moveTo(x, normalizedY);
      } else {
        // Create smooth cubic bezier curves between points
        final double prevX = (i - 1) * stepX;
        final double prevY = size.height - ((dataPoints[i - 1] / 100) * size.height);
        
        final double controlPointX = prevX + (stepX / 2);
        
        path.cubicTo(
          controlPointX, prevY, 
          controlPointX, normalizedY, 
          x, normalizedY
        );
      }
      
      // Draw points
      final pointPaint = Paint()
        ..color = i == dataPoints.length - 1 ? const Color(0xFF64FFDA) : const Color(0xFF311B92)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(Offset(x, normalizedY), i == dataPoints.length - 1 ? 6 : 4, pointPaint);
    }

    // Draw shadow first, then the actual line
    canvas.drawPath(path, paintShadow);
    canvas.drawPath(path, paintLine);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.currentFocus != currentFocus;
  }
}