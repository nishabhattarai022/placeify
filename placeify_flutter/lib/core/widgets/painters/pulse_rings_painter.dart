import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class PulseRingsPainter extends CustomPainter {
  const PulseRingsPainter({
    required this.outerOpacity,
    required this.innerOpacity,
    required this.outerScale,
    required this.innerScale,
  });

  final double outerOpacity;
  final double innerOpacity;
  final double outerScale;
  final double innerScale;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    void drawRing(double radius, double opacity, double scale) {
      final paint = Paint()
        ..color = AppColors.accent.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawCircle(center, radius * scale, paint);
    }

    drawRing(138, outerOpacity * 0.22, outerScale);
    drawRing(108, innerOpacity * 0.32, innerScale);
  }

  @override
  bool shouldRepaint(PulseRingsPainter oldDelegate) {
    return oldDelegate.outerOpacity != outerOpacity ||
        oldDelegate.innerOpacity != innerOpacity ||
        oldDelegate.outerScale != outerScale ||
        oldDelegate.innerScale != innerScale;
  }
}
