import 'package:flutter/material.dart';

import '../../../../core/widgets/animated_scale_tap.dart';
import '../../../../core/widgets/toast_overlay.dart';
import '../chairs_catalog_tokens.dart';
import '../data/category_showcase_config.dart';

/// Dark showroom tile in the category showcase grid.
class ShowcaseShowroomCard extends StatelessWidget {
  const ShowcaseShowroomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedScaleTap(
      pressScale: 0.98,
      onTap: () => PlaceifyToast.show(context, 'Opening Showroom…'),
      child: Container(
        height: 148,
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
        decoration: BoxDecoration(
          color: const Color(0xFF121212),
          borderRadius: BorderRadius.circular(20),
          boxShadow: ChairsCatalogTokens.cardShadow,
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: _MapPattern()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  CategoryShowcaseConfig.showroomTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  CategoryShowcaseConfig.showroomAddress,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.45,
                    color: Colors.white.withValues(alpha: 0.72),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MapPattern extends StatelessWidget {
  const _MapPattern();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MapPatternPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _MapPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..strokeWidth = 1;

    const step = 22.0;
    for (var x = 0.0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), stroke);
    }
    for (var y = 0.0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), stroke);
    }

    final accent = Paint()
      ..color = Colors.white.withValues(alpha: 0.10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..moveTo(size.width * 0.15, size.height * 0.55)
      ..quadraticBezierTo(
        size.width * 0.45,
        size.height * 0.25,
        size.width * 0.82,
        size.height * 0.48,
      )
      ..quadraticBezierTo(
        size.width * 0.62,
        size.height * 0.78,
        size.width * 0.28,
        size.height * 0.72,
      )
      ..close();
    canvas.drawPath(path, accent);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
