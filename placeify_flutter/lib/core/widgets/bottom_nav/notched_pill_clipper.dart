import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Clips the black pill with a concave left notch that wraps the home circle.
class NotchedPillClipper extends CustomClipper<Path> {
  const NotchedPillClipper({
    required this.circleCenter,
    required this.circleRadius,
    this.circleBorderWidth = 0,
    this.endRadius,
  });

  /// Circle center in this clipper's coordinate space.
  final Offset circleCenter;
  final double circleRadius;
  final double circleBorderWidth;

  /// Right-end cap radius (defaults to half height).
  final double? endRadius;

  double get _outerRadius => circleRadius + circleBorderWidth / 2;

  @override
  Path getClip(Size size) {
    final capR = endRadius ?? size.height / 2;
    final r = _outerRadius;
    final cx = circleCenter.dx;
    final cy = circleCenter.dy;

    final topDy = cy;
    final bottomDy = size.height - cy;
    final topDx = math.sqrt(math.max(0, r * r - topDy * topDy));
    final bottomDx = math.sqrt(math.max(0, r * r - bottomDy * bottomDy));

    final topJoin = Offset(cx + topDx, 0);
    final bottomJoin = Offset(cx + bottomDx, size.height);

    final startAngle = math.atan2(topJoin.dy - cy, topJoin.dx - cx);
    final sweepAngle = math.atan2(bottomJoin.dy - cy, bottomJoin.dx - cx) -
        startAngle;

    return Path()
      ..moveTo(topJoin.dx, topJoin.dy)
      ..lineTo(size.width - capR, 0)
      ..arcToPoint(
        Offset(size.width - capR, size.height),
        radius: Radius.circular(capR),
        clockwise: true,
      )
      ..lineTo(bottomJoin.dx, bottomJoin.dy)
      ..arcTo(
        Rect.fromCircle(center: circleCenter, radius: r),
        startAngle,
        sweepAngle,
        false,
      )
      ..close();
  }

  @override
  bool shouldReclip(covariant NotchedPillClipper oldClipper) =>
      oldClipper.circleCenter != circleCenter ||
      oldClipper.circleRadius != circleRadius ||
      oldClipper.circleBorderWidth != circleBorderWidth ||
      oldClipper.endRadius != endRadius;
}
