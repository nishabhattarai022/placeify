import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum BracketCorner { topLeft, topRight, bottomLeft, bottomRight }

class ArCornerBracket extends StatelessWidget {
  const ArCornerBracket({
    super.key,
    required this.corner,
    this.color = AppColors.accent,
    this.size = 16,
    this.strokeWidth = 2.2,
  });

  final BracketCorner corner;
  final Color color;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _BracketPainter(
        corner: corner,
        color: color,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  const _BracketPainter({
    required this.corner,
    required this.color,
    required this.strokeWidth,
  });

  final BracketCorner corner;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final s = size.width;

    switch (corner) {
      case BracketCorner.topLeft:
        path.moveTo(0, s * 0.5);
        path.lineTo(0, 0);
        path.lineTo(s * 0.5, 0);
      case BracketCorner.topRight:
        path.moveTo(s * 0.5, 0);
        path.lineTo(s, 0);
        path.lineTo(s, s * 0.5);
      case BracketCorner.bottomLeft:
        path.moveTo(0, s * 0.5);
        path.lineTo(0, s);
        path.lineTo(s * 0.5, s);
      case BracketCorner.bottomRight:
        path.moveTo(s * 0.5, s);
        path.lineTo(s, s);
        path.lineTo(s, s * 0.5);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BracketPainter oldDelegate) => false;
}
