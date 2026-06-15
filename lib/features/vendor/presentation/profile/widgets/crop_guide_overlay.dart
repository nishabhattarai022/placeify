import 'package:flutter/material.dart';

import 'package:placeify/core/constants/app_colors.dart';

/// Dashed crop frame overlay for logo (1:1) or banner (3:1) image previews.
class CropGuideOverlay extends StatelessWidget {
  const CropGuideOverlay({
    required this.aspectRatio,
    super.key,
  });

  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          painter: _CropGuidePainter(aspectRatio: aspectRatio),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _CropGuidePainter extends CustomPainter {
  _CropGuidePainter({required this.aspectRatio});

  final double aspectRatio;

  @override
  void paint(Canvas canvas, Size size) {
    final frameRect = _frameRect(size);
    final dimPaint = Paint()..color = Colors.black.withValues(alpha: 0.45);
    final path = Path()
      ..addRect(Offset.zero & size)
      ..addRRect(RRect.fromRectAndRadius(frameRect, const Radius.circular(8)))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, dimPaint);

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    _drawDashedRRect(canvas, frameRect, borderPaint);
  }

  Rect _frameRect(Size size) {
    const padding = 24.0;
    final maxW = size.width - padding * 2;
    final maxH = size.height - padding * 2;

    var frameW = maxW;
    var frameH = frameW / aspectRatio;
    if (frameH > maxH) {
      frameH = maxH;
      frameW = frameH * aspectRatio;
    }

    return Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: frameW,
      height: frameH,
    );
  }

  void _drawDashedRRect(Canvas canvas, Rect rect, Paint paint) {
    const dash = 8.0;
    const gap = 6.0;
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(8));
    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = (distance + dash).clamp(0.0, metric.length);
        canvas.drawPath(
          metric.extractPath(distance, end),
          paint..color = AppColors.warmWhite,
        );
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CropGuidePainter oldDelegate) =>
      oldDelegate.aspectRatio != aspectRatio;
}
