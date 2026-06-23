import 'package:flutter/material.dart';

import '../../data/ar_furniture_gesture_config.dart';

/// Two-finger pinch (scale) and twist (rotate) over the AR view.
///
/// Uses [GestureDetector.onScale] so single-finger touches are not claimed and
/// can pass through to the native AR view for drag-to-move.
class ArFurnitureGestureOverlay extends StatefulWidget {
  const ArFurnitureGestureOverlay({
    required this.enabled,
    required this.initialMultiplier,
    required this.currentRotationY,
    required this.minMultiplier,
    required this.maxMultiplier,
    required this.onMultiplierChanged,
    required this.onRotationChanged,
    this.onGestureEnd,
    super.key,
  });

  final bool enabled;
  final double initialMultiplier;
  final double currentRotationY;
  final double minMultiplier;
  final double maxMultiplier;
  final ValueChanged<double> onMultiplierChanged;

  /// Absolute Y-axis rotation in radians for the model.
  final ValueChanged<double> onRotationChanged;
  final VoidCallback? onGestureEnd;

  @override
  State<ArFurnitureGestureOverlay> createState() =>
      _ArFurnitureGestureOverlayState();
}

class _ArFurnitureGestureOverlayState extends State<ArFurnitureGestureOverlay> {
  double? _multiplierAtStart;
  double? _rotationAtStart;
  bool _gestureActive = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onScaleEnd: _onScaleEnd,
      child: const SizedBox.expand(),
    );
  }

  void _onScaleStart(ScaleStartDetails details) {
    _gestureActive = false;
    _multiplierAtStart = null;
    _rotationAtStart = null;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (details.pointerCount < 2) return;

    _gestureActive = true;
    _multiplierAtStart ??= widget.initialMultiplier;
    _rotationAtStart ??= widget.currentRotationY;

    final startMultiplier = _multiplierAtStart!;
    final startRotation = _rotationAtStart!;

    if (details.scale != 1.0) {
      final next = (startMultiplier * details.scale)
          .clamp(widget.minMultiplier, widget.maxMultiplier);
      widget.onMultiplierChanged(next);
    }

    final twist = details.rotation;
    if (twist.abs() >= ArFurnitureGestureConfig.rotationDeadZoneRadians) {
      widget.onRotationChanged(
        startRotation + twist * ArFurnitureGestureConfig.rotationSensitivity,
      );
    }
  }

  void _onScaleEnd(ScaleEndDetails details) {
    _gestureActive = false;
    _multiplierAtStart = null;
    _rotationAtStart = null;
    widget.onGestureEnd?.call();
  }
}
