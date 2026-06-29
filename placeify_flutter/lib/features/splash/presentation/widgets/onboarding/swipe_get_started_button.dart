import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/haptic_service.dart';

/// Slide-to-confirm "Get Started" — amber track, white thumb masks label/hints.
class SwipeGetStartedButton extends StatefulWidget {
  const SwipeGetStartedButton({
    required this.onComplete,
    super.key,
  });

  final VoidCallback onComplete;

  static const double height = 58;
  static const double _trackPadding = 4;
  static const double _completeThreshold = 0.88;

  @override
  State<SwipeGetStartedButton> createState() => _SwipeGetStartedButtonState();
}

class _SwipeGetStartedButtonState extends State<SwipeGetStartedButton>
    with TickerProviderStateMixin {
  double _dragX = 0;
  double _maxDrag = 0;
  bool _completed = false;

  late final AnimationController _snapController;
  late final AnimationController _chevronPulseController;
  late Animation<double> _snapAnimation;

  @override
  void initState() {
    super.initState();
    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _snapController.addListener(() {
      if (mounted) setState(() => _dragX = _snapAnimation.value);
    });

    _chevronPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _snapController.dispose();
    _chevronPulseController.dispose();
    super.dispose();
  }

  void _onTrackLayout(double maxDrag) {
    if (_maxDrag != maxDrag) _maxDrag = maxDrag;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_completed) return;
    setState(() {
      _dragX = (_dragX + details.delta.dx).clamp(0, _maxDrag);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_completed) return;

    final shouldComplete =
        _dragX >= _maxDrag * SwipeGetStartedButton._completeThreshold ||
        (details.primaryVelocity != null && details.primaryVelocity! > 800);

    if (shouldComplete) {
      _finish();
    } else {
      _snapTo(0);
    }
  }

  Future<void> _finish() async {
    if (_completed) return;
    setState(() => _completed = true);
    HapticService.heavy();
    await _snapTo(_maxDrag);
    if (!mounted) return;
    widget.onComplete();
  }

  Future<void> _snapTo(double target) async {
    _snapAnimation = Tween<double>(begin: _dragX, end: target).animate(
      CurvedAnimation(parent: _snapController, curve: Curves.easeOutCubic),
    );
    _snapController.reset();
    await _snapController.forward();
  }

  @override
  Widget build(BuildContext context) {
    const thumbSize =
        SwipeGetStartedButton.height - SwipeGetStartedButton._trackPadding * 2;

    return LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth;
        final maxDrag =
            trackWidth - thumbSize - SwipeGetStartedButton._trackPadding * 2;
        _onTrackLayout(maxDrag);

        final thumbLeft = SwipeGetStartedButton._trackPadding + _dragX;
        final thumbRight = thumbLeft + thumbSize;
        // Only paint label/hints to the right of the thumb — wiped away as you slide.
        final revealFromX = thumbRight + 2;
        final showHints = !_completed && revealFromX < trackWidth - 8;

        return Semantics(
          button: true,
          label: 'Get Started. Swipe right to continue.',
          child: GestureDetector(
            onHorizontalDragUpdate: _completed ? null : _onDragUpdate,
            onHorizontalDragEnd: _completed ? null : _onDragEnd,
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: SwipeGetStartedButton.height,
              width: trackWidth,
              decoration: BoxDecoration(
                color: AppColors.onboardingAmber,
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.onboardingAmber.withValues(alpha: 0.35),
                    blurRadius: 22,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    if (showHints)
                      ClipPath(
                        clipper: _SwipeWipeClipper(revealFromX: revealFromX),
                        child: SizedBox(
                          height: SwipeGetStartedButton.height,
                          width: trackWidth,
                          child: Stack(
                            clipBehavior: Clip.hardEdge,
                            children: [
                              const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Get Started',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 18,
                                top: 0,
                                bottom: 0,
                                child: Center(
                                  child: _TrailingChevrons(
                                    pulse: _chevronPulseController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Positioned(
                      left: thumbLeft,
                      top: SwipeGetStartedButton._trackPadding,
                      child: _SwipeThumb(size: thumbSize),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Reveals hints only to the right of the thumb — everything behind the thumb is clipped away.
class _SwipeWipeClipper extends CustomClipper<Path> {
  const _SwipeWipeClipper({required this.revealFromX});

  final double revealFromX;

  @override
  Path getClip(Size size) {
    final left = revealFromX.clamp(0.0, size.width);
    final width = size.width - left;
    if (width <= 0) return Path();
    return Path()..addRect(Rect.fromLTWH(left, 0, width, size.height));
  }

  @override
  bool shouldReclip(covariant _SwipeWipeClipper oldClipper) {
    return oldClipper.revealFromX != revealFromX;
  }
}

class _SwipeThumb extends StatelessWidget {
  const _SwipeThumb({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.chevron_right_rounded,
        size: size * 0.48,
        color: AppColors.onboardingAmber,
      ),
    );
  }
}

class _TrailingChevrons extends StatelessWidget {
  const _TrailingChevrons({required this.pulse});

  final Animation<double> pulse;

  static const double _iconSize = 20;
  static const double _overlap = 7;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulse,
      builder: (context, _) {
        final t = pulse.value * 2 * math.pi;
        return SizedBox(
          width: _iconSize * 3 - _overlap * 2,
          height: _iconSize,
          child: Stack(
            clipBehavior: Clip.none,
            children: List.generate(3, (i) {
              final wave = (math.sin(t - i * 0.85) + 1) / 2;
              final opacity = 0.35 + wave * 0.65;
              return Positioned(
                left: i * (_iconSize - _overlap),
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: _iconSize,
                  color: Colors.white.withValues(alpha: opacity),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
