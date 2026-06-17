import 'package:flutter/material.dart';

/// Geometric shapes matching the HTML profile hero SVG.
class ProfileHeroPattern extends StatelessWidget {
  const ProfileHeroPattern({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ProfileHeroPatternPainter(),
      size: Size.infinite,
    );
  }
}

class _ProfileHeroPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.14)
      ..style = PaintingStyle.fill;

    void triangle(List<Offset> pts) {
      canvas.drawPath(
        Path()
          ..moveTo(pts[0].dx, pts[0].dy)
          ..lineTo(pts[1].dx, pts[1].dy)
          ..lineTo(pts[2].dx, pts[2].dy)
          ..close(),
        paint..color = Colors.white.withValues(alpha: 0.12),
      );
    }

    triangle([
      Offset(size.width * 0.18, size.height * 0.21),
      Offset(size.width * 0.26, size.height * 0.39),
      Offset(size.width * 0.10, size.height * 0.39),
    ]);
    triangle([
      Offset(size.width * 0.79, size.height * 0.18),
      Offset(size.width * 0.88, size.height * 0.37),
      Offset(size.width * 0.70, size.height * 0.37),
    ]);
    triangle([
      Offset(size.width * 0.14, size.height * 0.57),
      Offset(size.width * 0.20, size.height * 0.71),
      Offset(size.width * 0.08, size.height * 0.71),
    ]);

    canvas.drawCircle(
      Offset(size.width * 0.87, size.height * 0.64),
      28,
      paint..color = Colors.white.withValues(alpha: 0.09),
    );
    canvas.drawCircle(
      Offset(size.width * 0.41, size.height * 0.21),
      16,
      paint..color = Colors.white.withValues(alpha: 0.08),
    );
    canvas.drawCircle(
      Offset(size.width * 0.08, size.height * 0.86),
      40,
      paint..color = Colors.white.withValues(alpha: 0.06),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
