import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../ar_room_ui_tokens.dart';
import 'ar_frosted_surface.dart';

/// Ripple-grid floor scan — a wave of light sweeps outward through a grid
/// of dots, evoking the room being mapped rather than a static ring.
class ArFloorScanOverlay extends StatelessWidget {
  const ArFloorScanOverlay({required this.wave, super.key});

  /// A continuously repeating 0→1 animation (e.g. driven by a controller
  /// with `..repeat()`), representing one sweep cycle.
  final Animation<double> wave;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: wave,
        builder: (context, _) {
          return Center(
            child: SizedBox(
              width: 240,
              height: 240,
              child: CustomPaint(
                painter: _RippleGridPainter(progress: wave.value),
                isComplex: true,
                willChange: true,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GridDot {
  const _GridDot(this.offset, this.dist);

  final Offset offset;
  final double dist;
}

class _RippleGridPainter extends CustomPainter {
  _RippleGridPainter({required this.progress});

  final double progress;

  static const _canvasSize = 240.0;
  static const _maxDist = _canvasSize * 0.42;
  static const _band = 34.0;
  static const _restAlpha = 0.34;
  static const _warmWhite = AppColors.warmWhite;
  static const _accentLight = AppColors.accentLight;

  static final _dots = _buildDotCache();
  static final _dotPaint = Paint();
  static final _glowPaint = Paint();

  static int _quantizeProgress(double progress) => (progress * 100).round();

  static List<_GridDot> _buildDotCache() {
    const cols = 9;
    const rows = 9;
    const spacing = 20.0;
    final center = Offset(_canvasSize / 2, _canvasSize / 2);
    final dots = <_GridDot>[];

    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        final point = Offset(
          center.dx + (col - (cols - 1) / 2) * spacing,
          center.dy + (row - (rows - 1) / 2) * spacing,
        );
        final dist = (point - center).distance;
        if (dist <= _maxDist) {
          dots.add(_GridDot(point, dist));
        }
      }
    }
    return dots;
  }

  static Color _dotColor(double hit, double alpha) {
    return Color.lerp(_warmWhite, _accentLight, hit.clamp(0.0, 1.0))!
        .withValues(alpha: alpha);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final waveRadius = progress * _maxDist * 1.25;

    for (final dot in _dots) {
      final diff = (dot.dist - waveRadius).abs();
      final hit = (1 - (diff / _band)).clamp(0.0, 1.0);
      final alpha = _restAlpha + hit * (1.0 - _restAlpha);
      final radius = 2.0 + hit * 3.4;

      if (hit > 0.35) {
        _glowPaint.color = _accentLight.withValues(alpha: hit * 0.22);
        canvas.drawCircle(dot.offset, radius * 2.2, _glowPaint);
        _glowPaint.color = _accentLight.withValues(alpha: hit * 0.40);
        canvas.drawCircle(dot.offset, radius * 1.45, _glowPaint);
      }

      _dotPaint.color = _dotColor(hit, alpha);
      canvas.drawCircle(dot.offset, radius, _dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RippleGridPainter oldDelegate) =>
      _quantizeProgress(oldDelegate.progress) != _quantizeProgress(progress);
}

/// Premium placement reticle with soft glow and subtle pulse.
class ArPlacementReticle extends StatelessWidget {
  const ArPlacementReticle({
    required this.pulse,
    this.isValid = true,
    super.key,
  });

  final Animation<double> pulse;
  final bool isValid;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: pulse,
        builder: (context, _) {
          final t = Curves.easeInOut.transform(pulse.value);
          final scale = 0.92 + t * 0.08;
          final glowAlpha = isValid ? 0.18 + t * 0.22 : 0.08 + t * 0.08;

          return Center(
            child: Transform.scale(
              scale: scale,
              child: SizedBox(
                width: 88,
                height: 88,
                child: CustomPaint(
                  painter: _ReticlePainter(
                    glowAlpha: glowAlpha,
                    ringAlpha: isValid ? 0.75 + t * 0.2 : 0.35,
                    accentAlpha: isValid ? 0.55 + t * 0.25 : 0.2,
                  ),
                  isComplex: true,
                  willChange: true,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ReticlePainter extends CustomPainter {
  _ReticlePainter({
    required this.glowAlpha,
    required this.ringAlpha,
    required this.accentAlpha,
  });

  final double glowAlpha;
  final double ringAlpha;
  final double accentAlpha;

  static final _glowPaint = Paint();
  static final _outerRing = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;
  static final _innerRing = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  static final _dotPaint = Paint();

  static int _q(double v) => (v * 40).round();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerR = size.width * 0.42;

    _glowPaint.shader = RadialGradient(
      colors: [
        AppColors.accent.withValues(alpha: glowAlpha),
        Colors.transparent,
      ],
    ).createShader(Rect.fromCircle(center: center, radius: outerR * 1.4));
    canvas.drawCircle(center, outerR * 1.4, _glowPaint);

    _outerRing.color = AppColors.warmWhite.withValues(alpha: ringAlpha * 0.55);
    canvas.drawCircle(center, outerR, _outerRing);

    _innerRing.color = AppColors.accent.withValues(alpha: accentAlpha);
    canvas.drawCircle(center, outerR * 0.72, _innerRing);

    _dotPaint.color = AppColors.warmWhite.withValues(alpha: 0.85);
    canvas.drawCircle(center, 3, _dotPaint);
  }

  @override
  bool shouldRepaint(_ReticlePainter oldDelegate) =>
      _q(oldDelegate.glowAlpha) != _q(glowAlpha) ||
      _q(oldDelegate.ringAlpha) != _q(ringAlpha) ||
      _q(oldDelegate.accentAlpha) != _q(accentAlpha);
}

/// Frosted hint pill with fade + vertical slide.
class ArFloatingHint extends StatefulWidget {
  const ArFloatingHint({
    required this.message,
    required this.visible,
    super.key,
  });

  final String message;
  final bool visible;

  @override
  State<ArFloatingHint> createState() => _ArFloatingHintState();
}

class _ArFloatingHintState extends State<ArFloatingHint>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: ArRoomUiTokens.motionHint,
      reverseDuration: const Duration(milliseconds: 280),
    );
    _opacity = CurvedAnimation(
      parent: _controller,
      curve: ArRoomUiTokens.motionEnterCurve,
      reverseCurve: ArRoomUiTokens.motionExitCurve,
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: ArRoomUiTokens.motionEnterCurve,
      reverseCurve: ArRoomUiTokens.motionExitCurve,
    ));

    if (widget.visible) _controller.forward();
  }

  @override
  void didUpdateWidget(ArFloatingHint oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible && !oldWidget.visible) {
      _controller.forward();
    } else if (!widget.visible && oldWidget.visible) {
      _controller.reverse();
    } else if (widget.visible &&
        widget.message != oldWidget.message &&
        _controller.status != AnimationStatus.forward) {
      _controller.forward(from: 0.65);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: ArFrostedPill(
          child: Text(
            widget.message,
            textAlign: TextAlign.center,
            style: arOverlayHintStyle(),
          ),
        ),
      ),
    );
  }
}

/// Single placement indicator — spinning accent arc + one label pill.
/// Replaces the old duplicate top-hint + center-pill combo.
class ArPlacementMomentOverlay extends StatefulWidget {
  const ArPlacementMomentOverlay({
    required this.progress,
    required this.productName,
    super.key,
  });

  /// 0 → 1 over [ArRoomUiTokens.placementReveal].
  final Animation<double> progress;
  final String productName;

  @override
  State<ArPlacementMomentOverlay> createState() =>
      _ArPlacementMomentOverlayState();
}

class _ArPlacementMomentOverlayState extends State<ArPlacementMomentOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spinController;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: widget.progress,
        builder: (context, _) {
          if (widget.progress.value <= 0) return const SizedBox.shrink();

          final t = Curves.easeOutCubic.transform(widget.progress.value);
          final fadeOut = t > 0.8 ? (1 - t) / 0.2 : 1.0;

          return IgnorePointer(
            child: Center(
              child: Opacity(
                opacity: fadeOut.clamp(0.0, 1.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 76,
                      height: 76,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    AppColors.warmWhite.withValues(alpha: 0.28),
                                width: 1.5,
                              ),
                            ),
                          ),
                          RotationTransition(
                            turns: _spinController,
                            child: SizedBox(
                              width: 76,
                              height: 76,
                              child: CustomPaint(
                                painter: _SpinArcPainter(
                                  color: AppColors.accentLight,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.warmWhite.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    ArFrostedPill(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 9,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.accentLight,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Placing ${widget.productName}',
                            style: AppFonts.dmSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: ArRoomUiTokens.overlayTextPrimary,
                              letterSpacing: -0.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SpinArcPainter extends CustomPainter {
  _SpinArcPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(1, 1, size.width - 2, size.height - 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(rect, 0, 2.4, false, paint);
  }

  @override
  bool shouldRepaint(covariant _SpinArcPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Frosted capture button — saves a composited AR room snapshot.
class ArCaptureButton extends StatelessWidget {
  const ArCaptureButton({
    required this.onCapture,
    this.enabled = true,
    super.key,
  });

  final VoidCallback? onCapture;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enabled,
      child: Opacity(
        opacity: enabled ? 1 : 0.45,
        child: Material(
          color: Colors.transparent,
          child: ArGlassIconButton(
            icon: Icons.camera_alt_rounded,
            tooltip: enabled ? 'Save room shot' : 'Saving…',
            onPressed: () {
              if (enabled && onCapture != null) onCapture!();
            },
          ),
        ),
      ),
    );
  }
}

/// Subtle scan instruction below center during floor detection.
class ArScanInstruction extends StatelessWidget {
  const ArScanInstruction({required this.breath, super.key});

  final Animation<double> breath;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: breath,
        builder: (context, _) {
          final opacity =
              0.55 + Curves.easeInOut.transform(breath.value) * 0.35;
          return Opacity(
            opacity: opacity,
            child: Text(
              'Move your phone to find the floor',
              textAlign: TextAlign.center,
              style: AppFonts.dmSans(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: ArRoomUiTokens.overlayTextPrimary,
                letterSpacing: -0.2,
                height: 1.3,
              ),
            ),
          );
        },
      ),
    );
  }
}
