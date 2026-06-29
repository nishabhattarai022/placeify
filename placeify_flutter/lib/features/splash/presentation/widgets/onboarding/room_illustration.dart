import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class RoomIllustration extends StatelessWidget {
  const RoomIllustration({required this.slideIndex, super.key});

  final int slideIndex;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: RoomPainter(slideIndex: slideIndex),
        size: const Size(260, 300),
      ),
    );
  }
}

class RoomPainter extends CustomPainter {
  const RoomPainter({required this.slideIndex});

  final int slideIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final floorPaint = Paint()
      ..shader =
          const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A1F1A), Color(0xFF061410)],
          ).createShader(
            Rect.fromLTWH(0, size.height * 0.5, size.width, size.height * 0.5),
          );
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.5, size.width, size.height * 0.5),
      floorPaint,
    );

    final wallPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF0D2820), Color(0xFF0A1F1A)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.55));
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height * 0.55),
      wallPaint,
    );

    switch (slideIndex) {
      case 0:
        _drawSofa(canvas, size);
      case 1:
        _drawBed(canvas, size);
      case 2:
        _drawTable(canvas, size);
    }

    final glowPaint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              AppColors.onboardingAmber.withValues(alpha: 0.12),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCenter(
              center: Offset(size.width * 0.5, size.height * 0.7),
              width: 200,
              height: 60,
            ),
          );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.72),
        width: 180,
        height: 40,
      ),
      glowPaint,
    );
  }

  void _drawSofa(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final by = size.height * 0.62;
    _roundRect(
      canvas,
      Rect.fromLTWH(cx - 80, by - 50, 160, 50),
      10,
      Paint()..color = const Color(0xFF1A3D35),
    );
    _roundRect(
      canvas,
      Rect.fromLTWH(cx - 85, by - 10, 170, 38),
      8,
      Paint()..color = const Color(0xFF1F4A3E),
    );
    _roundRect(
      canvas,
      Rect.fromLTWH(cx - 78, by - 46, 70, 38),
      7,
      Paint()..color = const Color(0xFF2A5E50),
    );
    _roundRect(
      canvas,
      Rect.fromLTWH(cx + 8, by - 46, 70, 38),
      7,
      Paint()..color = const Color(0xFF2A5E50),
    );
    _roundRect(
      canvas,
      Rect.fromLTWH(cx - 14, by - 44, 28, 32),
      5,
      Paint()..color = AppColors.onboardingAmber.withValues(alpha: 0.6),
    );
  }

  void _drawBed(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final by = size.height * 0.65;
    _roundRect(
      canvas,
      Rect.fromLTWH(cx - 90, by - 65, 180, 72),
      10,
      Paint()..color = const Color(0xFF1A2E28),
    );
    _roundRect(
      canvas,
      Rect.fromLTWH(cx - 88, by - 90, 176, 30),
      8,
      Paint()..color = const Color(0xFF1F3D34),
    );
    _roundRect(
      canvas,
      Rect.fromLTWH(cx - 80, by - 60, 75, 35),
      8,
      Paint()..color = AppColors.onboardingTextHead.withValues(alpha: 0.12),
    );
    _roundRect(
      canvas,
      Rect.fromLTWH(cx + 5, by - 60, 75, 35),
      8,
      Paint()..color = AppColors.onboardingTextHead.withValues(alpha: 0.12),
    );
    _roundRect(
      canvas,
      Rect.fromLTWH(cx - 88, by - 25, 176, 30),
      5,
      Paint()..color = AppColors.onboardingTeal.withValues(alpha: 0.20),
    );
  }

  void _drawTable(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final by = size.height * 0.62;
    _roundRect(
      canvas,
      Rect.fromLTWH(cx - 85, by - 18, 170, 22),
      5,
      Paint()..color = const Color(0xFF1E3D32),
    );
    canvas.drawRect(
      Rect.fromLTWH(cx - 78, by + 4, 10, 30),
      Paint()..color = const Color(0xFF152E25),
    );
    canvas.drawRect(
      Rect.fromLTWH(cx + 68, by + 4, 10, 30),
      Paint()..color = const Color(0xFF152E25),
    );
    _roundRect(
      canvas,
      Rect.fromLTWH(cx - 7, by - 36, 14, 20),
      4,
      Paint()..color = AppColors.onboardingAmber.withValues(alpha: 0.55),
    );
  }

  void _roundRect(Canvas canvas, Rect rect, double radius, Paint paint) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      paint,
    );
  }

  @override
  bool shouldRepaint(RoomPainter oldDelegate) =>
      oldDelegate.slideIndex != slideIndex;
}
