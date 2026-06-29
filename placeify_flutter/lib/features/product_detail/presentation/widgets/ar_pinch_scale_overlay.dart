import 'package:flutter/material.dart';

/// Detects two-finger pinch and reports an updated user scale multiplier.
///
/// Single-finger touches pass through to the native AR view for drag gestures.
class ArPinchScaleOverlay extends StatefulWidget {
  const ArPinchScaleOverlay({
    required this.enabled,
    required this.initialMultiplier,
    required this.minMultiplier,
    required this.maxMultiplier,
    required this.onMultiplierChanged,
    super.key,
  });

  final bool enabled;
  final double initialMultiplier;
  final double minMultiplier;
  final double maxMultiplier;
  final ValueChanged<double> onMultiplierChanged;

  @override
  State<ArPinchScaleOverlay> createState() => _ArPinchScaleOverlayState();
}

class _ArPinchScaleOverlayState extends State<ArPinchScaleOverlay> {
  final Map<int, Offset> _pointers = {};
  double? _spanAtStart;
  double? _multiplierAtStart;

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return const SizedBox.shrink();
    }

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerUp,
      child: const SizedBox.expand(),
    );
  }

  void _onPointerDown(PointerDownEvent event) {
    _pointers[event.pointer] = event.position;
    if (_pointers.length == 2) {
      _spanAtStart = _currentSpan();
      _multiplierAtStart = widget.initialMultiplier;
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (_pointers.length < 2) return;
    _pointers[event.pointer] = event.position;

    final startSpan = _spanAtStart;
    final startMultiplier = _multiplierAtStart;
    if (startSpan == null || startMultiplier == null || startSpan <= 0) return;

    final ratio = _currentSpan() / startSpan;
    final next = (startMultiplier * ratio).clamp(
      widget.minMultiplier,
      widget.maxMultiplier,
    );
    widget.onMultiplierChanged(next);
  }

  void _onPointerUp(PointerEvent event) {
    _pointers.remove(event.pointer);
    if (_pointers.length < 2) {
      _spanAtStart = null;
      _multiplierAtStart = null;
    }
  }

  double _currentSpan() {
    final values = _pointers.values.toList(growable: false);
    if (values.length < 2) return 0;
    return (values[0] - values[1]).distance;
  }
}

/// Scale controls with +/- buttons and pinch on the control strip.
class ArScaleControls extends StatefulWidget {
  const ArScaleControls({
    required this.multiplier,
    required this.minMultiplier,
    required this.maxMultiplier,
    required this.onChanged,
    super.key,
  });

  final double multiplier;
  final double minMultiplier;
  final double maxMultiplier;
  final ValueChanged<double> onChanged;

  @override
  State<ArScaleControls> createState() => _ArScaleControlsState();
}

class _ArScaleControlsState extends State<ArScaleControls> {
  double? _pinchBase;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onScaleStart: (_) => _pinchBase = widget.multiplier,
      onScaleUpdate: (details) {
        final base = _pinchBase;
        if (base == null || details.scale == 1.0) return;
        widget.onChanged(
          (base * details.scale).clamp(
            widget.minMultiplier,
            widget.maxMultiplier,
          ),
        );
      },
      onScaleEnd: (_) => _pinchBase = null,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: widget.multiplier <= widget.minMultiplier
                  ? null
                  : () => widget.onChanged(
                      (widget.multiplier - 0.1).clamp(
                        widget.minMultiplier,
                        widget.maxMultiplier,
                      ),
                    ),
              icon: const Icon(Icons.remove, color: Colors.white, size: 20),
            ),
            Text(
              '${widget.multiplier.toStringAsFixed(1)}×',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: widget.multiplier >= widget.maxMultiplier
                  ? null
                  : () => widget.onChanged(
                      (widget.multiplier + 0.1).clamp(
                        widget.minMultiplier,
                        widget.maxMultiplier,
                      ),
                    ),
              icon: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

/// Rotate controls with left/right buttons (15° steps).
class ArRotationControls extends StatelessWidget {
  const ArRotationControls({
    required this.onRotateLeft,
    required this.onRotateRight,
    super.key,
  });

  final VoidCallback onRotateLeft;
  final VoidCallback onRotateRight;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            tooltip: 'Rotate left',
            onPressed: onRotateLeft,
            icon: const Icon(Icons.rotate_left, color: Colors.white, size: 20),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Rotate',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            tooltip: 'Rotate right',
            onPressed: onRotateRight,
            icon: const Icon(Icons.rotate_right, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}
