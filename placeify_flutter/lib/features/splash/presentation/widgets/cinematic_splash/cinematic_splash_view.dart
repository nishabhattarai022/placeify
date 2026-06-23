import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../onboarding/pulsing_dot.dart';
import 'cinematic_phone_mockup.dart';
import 'cinematic_splash_tokens.dart';

/// Cinematic intro splash — layered stage, typography, device mockup, brand lockup.
class CinematicSplashView extends StatefulWidget {
  const CinematicSplashView({
    required this.opacityAnim,
    required this.scaleAnim,
    super.key,
  });

  final Animation<double> opacityAnim;
  final Animation<double> scaleAnim;

  @override
  State<CinematicSplashView> createState() => _CinematicSplashViewState();
}

class _CinematicSplashViewState extends State<CinematicSplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _timeline;

  late final Animation<double> _heroOpacity;
  late final Animation<Offset> _heroSlide;
  late final Animation<double> _line2Reveal;
  late final Animation<double> _heroDim;
  late final Animation<double> _stageProgress;
  late final Animation<double> _stageOpacity;
  late final Animation<double> _deviceOpacity;
  late final Animation<double> _deviceScale;
  late final Animation<double> _deviceLift;
  late final Animation<double> _badgeOpacity;
  late final Animation<double> _brandOpacity;
  late final Animation<Offset> _brandSlide;
  late final Animation<double> _deviceTilt;

  @override
  void initState() {
    super.initState();
    _timeline = AnimationController(
      vsync: this,
      duration: CinematicSplashTokens.introDuration,
    );

    _heroOpacity = _interval(0.06, 0.38);
    _heroSlide = _slideInterval(0.06, 0.42, dy: 28);
    _line2Reveal = _interval(0.22, 0.52, curve: Curves.easeInOutCubic);
    _heroDim = _interval(0.48, 0.72);
    _stageOpacity = _interval(0.12, 0.36);
    _stageProgress = _interval(0.18, 0.58, curve: CinematicSplashTokens.stageEase);
    _deviceOpacity = _interval(0.44, 0.68);
    _deviceScale = Tween<double>(begin: 0.88, end: 1).animate(
      _interval(0.44, 0.72, curve: CinematicSplashTokens.deviceEase),
    );
    _deviceLift = Tween<double>(begin: 48, end: 0).animate(
      _interval(0.44, 0.72, curve: CinematicSplashTokens.stageEase),
    );
    _badgeOpacity = _interval(0.58, 0.82);
    _brandOpacity = _interval(0.62, 0.9);
    _brandSlide = _slideInterval(0.62, 0.92, dy: 12);
    _deviceTilt = _interval(0.44, 0.78, curve: CinematicSplashTokens.deviceEase);

    _timeline.forward();
  }

  Animation<double> _interval(
    double start,
    double end, {
    Curve curve = CinematicSplashTokens.heroEase,
  }) {
    return CurvedAnimation(
      parent: _timeline,
      curve: Interval(start, end, curve: curve),
    );
  }

  Animation<Offset> _slideInterval(
    double start,
    double end, {
    double dy = 24,
    Curve curve = CinematicSplashTokens.heroEase,
  }) {
    return Tween<Offset>(
      begin: Offset(0, dy / 400),
      end: Offset.zero,
    ).animate(_interval(start, end, curve: curve));
  }

  @override
  void dispose() {
    _timeline.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return ColoredBox(
      color: CinematicSplashTokens.background,
      child: AnimatedBuilder(
        animation: Listenable.merge([widget.opacityAnim, widget.scaleAnim]),
        builder: (context, child) {
          return Opacity(
            opacity: widget.opacityAnim.value,
            child: Transform.scale(
              scale: ui.lerpDouble(0.98, 1, widget.scaleAnim.value) ?? 1,
              child: child,
            ),
          );
        },
        child: AnimatedBuilder(
          animation: _timeline,
          builder: (context, _) {
            return Stack(
              fit: StackFit.expand,
              children: [
                const RepaintBoundary(child: _AmbienceLayer()),
                _StageCardLayer(
                  screenSize: size,
                  progress: _stageProgress,
                  opacity: _stageOpacity,
                ),
                SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final maxH = constraints.maxHeight;
                      final tight = maxH < 780;
                      final compact = maxH < 720 || size.height < 720;
                      final heroSize = tight ? 32.0 : (compact ? 34.0 : 40.0);
                      final heroLarge = tight ? 36.0 : (compact ? 38.0 : 46.0);

                      return MediaQuery.withClampedTextScaling(
                        maxScaleFactor: 1.05,
                        child: Column(
                          children: [
                            SizedBox(height: tight ? 24 : (compact ? 32 : 44)),
                            AnimatedBuilder(
                              animation:
                                  Listenable.merge([_heroOpacity, _heroDim]),
                              builder: (context, child) {
                                return Opacity(
                                  opacity: (_heroOpacity.value *
                                          (1 - _heroDim.value * 0.35))
                                      .clamp(0.0, 1.0),
                                  child: child,
                                );
                              },
                              child: SlideTransition(
                                position: _heroSlide,
                                child: _HeroHeadline(
                                  line1Size: heroSize,
                                  line2Size: heroLarge,
                                  line2Reveal: _line2Reveal.value,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Transform.translate(
                                  offset: Offset(
                                    0,
                                    _deviceLift.value * (tight ? 0.35 : 1),
                                  ),
                                  child: ScaleTransition(
                                    scale: _deviceScale,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: CinematicPhoneMockup(
                                        tiltProgress: _deviceTilt.value,
                                        contentOpacity: _deviceOpacity,
                                        badgeOpacity: _badgeOpacity,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: tight ? 8 : 14),
                            FadeTransition(
                              opacity: _brandOpacity,
                              child: SlideTransition(
                                position: _brandSlide,
                                child: _BrandLockup(compact: compact || tight),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AmbienceLayer extends StatelessWidget {
  const _AmbienceLayer();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(
          painter: _GridPainter(
            lineColor: CinematicSplashTokens.foreground.withValues(alpha: 0.045),
          ),
          size: Size.infinite,
        ),
        Positioned(
          top: -80,
          left: -60,
          child: _GlowOrb(
            size: 220,
            color: CinematicSplashTokens.accent.withValues(alpha: 0.14),
          ),
        ),
        Positioned(
          bottom: 120,
          right: -40,
          child: _GlowOrb(
            size: 180,
            color: CinematicSplashTokens.accentGlow.withValues(alpha: 0.1),
          ),
        ),
        const IgnorePointer(child: _FilmGrain()),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.1,
              colors: [
                Colors.transparent,
                CinematicSplashTokens.background.withValues(alpha: 0.5),
                CinematicSplashTokens.background.withValues(alpha: 0.92),
              ],
              stops: const [0.55, 0.85, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ui.ImageFilter.blur(sigmaX: 48, sigmaY: 48),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}

class _FilmGrain extends StatelessWidget {
  const _FilmGrain();

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.04,
      child: CustomPaint(
        painter: _NoisePainter(),
        size: Size.infinite,
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter({required this.lineColor});

  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    const step = 60.0;
    final center = Offset(size.width / 2, size.height * 0.38);
    final fadeR = size.shortestSide * 0.7;

    for (var x = 0.0; x <= size.width; x += step) {
      _line(canvas, Offset(x, 0), Offset(x, size.height), center, fadeR);
    }
    for (var y = 0.0; y <= size.height; y += step) {
      _line(canvas, Offset(0, y), Offset(size.width, y), center, fadeR);
    }
  }

  void _line(Canvas canvas, Offset a, Offset b, Offset c, double r) {
    final mid = Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);
    final t = 1 - (mid.distance / r).clamp(0.0, 1.0);
    if (t < 0.03) return;
    canvas.drawLine(
      a,
      b,
      Paint()
        ..color = lineColor.withValues(alpha: lineColor.a * t)
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant _GridPainter old) => false;
}

class _NoisePainter extends CustomPainter {
  static final _rng = math.Random(7);

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.white;
    final count = (size.width * size.height / 900).round().clamp(1200, 4000);
    for (var i = 0; i < count; i++) {
      canvas.drawCircle(
        Offset(_rng.nextDouble() * size.width, _rng.nextDouble() * size.height),
        0.55,
        p,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StageCardLayer extends StatelessWidget {
  const _StageCardLayer({
    required this.screenSize,
    required this.progress,
    required this.opacity,
  });

  final Size screenSize;
  final Animation<double> progress;
  final Animation<double> opacity;

  @override
  Widget build(BuildContext context) {
    final topEnd = screenSize.height * (screenSize.height < 720 ? 0.26 : 0.3);
    final topStart = screenSize.height + 120;
    final top = ui.lerpDouble(topStart, topEnd, progress.value)!;
    final scale = ui.lerpDouble(0.94, 1, progress.value)!;

    return Positioned(
      left: screenSize.width * 0.06,
      right: screenSize.width * 0.06,
      top: top,
      bottom: -48,
      child: Opacity(
        opacity: opacity.value,
        child: Transform.scale(
          scale: scale,
          alignment: Alignment.topCenter,
          child: const _PremiumStageCard(),
        ),
      ),
    );
  }
}

class _PremiumStageCard extends StatelessWidget {
  const _PremiumStageCard();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(CinematicSplashTokens.cardRadius),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CinematicSplashTokens.cardGradientStart,
            CinematicSplashTokens.cardGradientEnd,
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.88),
            blurRadius: 56,
            offset: const Offset(0, 32),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -40,
            left: 0,
            right: 0,
            child: Center(
              child: ImageFiltered(
                imageFilter: ui.ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: Container(
                  width: 280,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.07),
                  ),
                ),
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(CinematicSplashTokens.cardRadius),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.04),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.25),
                ],
                stops: const [0.0, 0.35, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroHeadline extends StatelessWidget {
  const _HeroHeadline({
    required this.line1Size,
    required this.line2Size,
    required this.line2Reveal,
  });

  final double line1Size;
  final double line2Size;
  final double line2Reveal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            CinematicSplashTokens.heroLine1,
            textAlign: TextAlign.center,
            style: _matteStyle(line1Size),
          ),
          const SizedBox(height: 6),
          ClipPath(
            clipper: _CenterRevealClipper(line2Reveal),
            child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFFFFFF), Color(0xFFB4B4BC)],
              ).createShader(bounds),
              child: Text(
                CinematicSplashTokens.heroLine2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Fraunces',
                  fontSize: line2Size,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -1.1,
                  height: 1.02,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static TextStyle _matteStyle(double size) {
    return TextStyle(
      fontFamily: 'Fraunces',
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: CinematicSplashTokens.foreground,
      letterSpacing: -0.9,
      height: 1.04,
      shadows: [
        Shadow(
          color: CinematicSplashTokens.foreground.withValues(alpha: 0.18),
          blurRadius: 28,
          offset: const Offset(0, 12),
        ),
        Shadow(
          color: Colors.black.withValues(alpha: 0.4),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}

class _CenterRevealClipper extends CustomClipper<Path> {
  _CenterRevealClipper(this.progress);

  final double progress;

  @override
  Path getClip(Size size) {
    final w = size.width * progress.clamp(0, 1);
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: w,
      height: size.height,
    );
    return Path()..addRect(rect);
  }

  @override
  bool shouldReclip(covariant _CenterRevealClipper old) =>
      old.progress != progress;
}

class _BrandLockup extends StatelessWidget {
  const _BrandLockup({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Place',
                style: TextStyle(
                  fontFamily: 'Fraunces',
                  fontSize: compact ? 36 : 42,
                  fontWeight: FontWeight.w700,
                  color: CinematicSplashTokens.foreground,
                  letterSpacing: -0.8,
                  height: 1,
                ),
              ),
              TextSpan(
                text: 'ify',
                style: TextStyle(
                  fontFamily: 'Fraunces',
                  fontSize: compact ? 36 : 42,
                  fontWeight: FontWeight.w700,
                  color: CinematicSplashTokens.accent,
                  letterSpacing: -0.8,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          CinematicSplashTokens.brandSubline,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.6,
            color: CinematicSplashTokens.foregroundMuted,
          ),
        ),
        SizedBox(height: compact ? 14 : 20),
        const PulsingDot(color: AppColors.onboardingAmber),
        SizedBox(height: compact ? 8 : 12),
      ],
    );
  }
}
