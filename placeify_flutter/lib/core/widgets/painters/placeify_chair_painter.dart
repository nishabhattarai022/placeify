import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class PlaceifyChairPainter extends CustomPainter {
  const PlaceifyChairPainter({
    this.showArBrackets = false,
    this.showScanLines = false,
    this.scanLineOpacity = 0.5,
    this.upperScanOpacity,
    this.lowerScanOpacity,
  });

  final bool showArBrackets;
  final bool showScanLines;
  final double scanLineOpacity;
  final double? upperScanOpacity;
  final double? lowerScanOpacity;

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 200;
    final scaleY = size.height / 200;
    canvas.scale(scaleX, scaleY);

    void drawRoundedRect(
      double x,
      double y,
      double w,
      double h,
      double rx,
      Color color, {
      double opacity = 1,
    }) {
      final paint = Paint()..color = color.withValues(alpha: opacity);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, w - x, h - y),
          Radius.circular(rx),
        ),
        paint,
      );
    }

    drawRoundedRect(30, 28, 200, 124, 14, AppColors.accentLight, opacity: 0.88);
    drawRoundedRect(42, 36, 200, 90, 9, Colors.white, opacity: 0.14);
    drawRoundedRect(24, 92, 200, 228, 12, AppColors.accent, opacity: 0.92);
    drawRoundedRect(36, 96, 200, 207, 8, Colors.white, opacity: 0.13);
    drawRoundedRect(30, 88, 73, 228, 5, AppColors.bark);
    drawRoundedRect(157, 88, 170, 228, 5, AppColors.bark);
    drawRoundedRect(36, 132, 49, 182, 6, const Color(0xFF6B5540));
    drawRoundedRect(151, 132, 164, 182, 6, const Color(0xFF6B5540));

    if (showScanLines) {
      final upper = upperScanOpacity ?? scanLineOpacity;
      final lower = lowerScanOpacity ?? scanLineOpacity;
      drawRoundedRect(10, 82, 190, 84, 1, AppColors.arScanUpper, opacity: upper);
      drawRoundedRect(10, 116, 190, 118, 1, AppColors.arScanLower, opacity: lower);
    }

    if (showArBrackets) {
      final bracketPaint = Paint()
        ..color = AppColors.accent
        ..strokeWidth = 2.2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      void drawBracket(List<Offset> points) {
        final path = Path()..moveTo(points[0].dx, points[0].dy);
        for (var i = 1; i < points.length; i++) {
          path.lineTo(points[i].dx, points[i].dy);
        }
        canvas.drawPath(path, bracketPaint);
      }

      drawBracket([const Offset(14, 52), const Offset(14, 44), const Offset(22, 44)]);
      drawBracket([const Offset(186, 52), const Offset(186, 44), const Offset(178, 44)]);
      drawBracket([const Offset(14, 144), const Offset(14, 152), const Offset(22, 152)]);
      drawBracket([const Offset(186, 144), const Offset(186, 152), const Offset(178, 152)]);
    }
  }

  @override
  bool shouldRepaint(PlaceifyChairPainter oldDelegate) {
    return oldDelegate.scanLineOpacity != scanLineOpacity ||
        oldDelegate.upperScanOpacity != upperScanOpacity ||
        oldDelegate.lowerScanOpacity != lowerScanOpacity ||
        oldDelegate.showArBrackets != showArBrackets ||
        oldDelegate.showScanLines != showScanLines;
  }
}
