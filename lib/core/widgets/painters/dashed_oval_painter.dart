import 'dart:math' as math;
import 'package:flutter/material.dart';

class DashedOvalPainter extends CustomPainter {
  const DashedOvalPainter({
    required this.color,
    this.strokeWidth = 2.0,
    this.dashLength = 8,
    this.gapLength = 5,
  });

  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final path = Path()..addOval(rect);
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;

    final metric = metrics.first;
    final totalLength = metric.length;
    final dashCycle = dashLength + gapLength;
    var distance = 0.0;

    while (distance < totalLength) {
      final end = math.min(distance + dashLength, totalLength);
      final extractPath = metric.extractPath(distance, end);
      canvas.drawPath(extractPath, paint);
      distance += dashCycle;
    }
  }

  @override
  bool shouldRepaint(DashedOvalPainter oldDelegate) =>
      oldDelegate.color != color;
}
