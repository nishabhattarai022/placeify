import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import 'cinematic_splash_tokens.dart';

/// Physical iPhone-style frame with AR preview and floating glass badges.
class CinematicPhoneMockup extends StatelessWidget {
  const CinematicPhoneMockup({
    required this.tiltProgress,
    required this.contentOpacity,
    required this.badgeOpacity,
    super.key,
  });

  /// 0–1 from parent [AnimationController].
  final double tiltProgress;
  final Animation<double> contentOpacity;
  final Animation<double> badgeOpacity;

  @override
  Widget build(BuildContext context) {
    // Single settle-in tilt (0 → π), not a looping wobble.
    final tiltY = math.sin(tiltProgress * math.pi) * 0.08;
    final tiltX = math.cos(tiltProgress * math.pi) * 0.045;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0012)
            ..rotateY(tiltY)
            ..rotateX(tiltX),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              _FloatingBadge(
                opacity: badgeOpacity,
                alignment: Alignment.topLeft,
                offset: const Offset(-56, 28),
                emoji: '✦',
                title: 'True-to-scale',
                subtitle: 'Dimensions in AR',
              ),
              _FloatingBadge(
                opacity: badgeOpacity,
                alignment: Alignment.bottomRight,
                offset: const Offset(52, -36),
                emoji: '🛋️',
                title: 'Style match',
                subtitle: 'Curated for your room',
              ),
              _DeviceFrame(contentOpacity: contentOpacity),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Container(
          width: CinematicSplashTokens.phoneWidth * 0.72,
          height: 14,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.55),
                blurRadius: 22,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DeviceFrame extends StatelessWidget {
  const _DeviceFrame({required this.contentOpacity});

  final Animation<double> contentOpacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: CinematicSplashTokens.phoneWidth,
      height: CinematicSplashTokens.phoneHeight,
      decoration: BoxDecoration(
        color: CinematicSplashTokens.phoneBezel,
        borderRadius: BorderRadius.circular(46),
        border: Border.all(color: CinematicSplashTokens.phoneBorder, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.75),
            blurRadius: 48,
            offset: const Offset(0, 28),
          ),
          BoxShadow(
            color: AppColors.onboardingTeal.withValues(alpha: 0.12),
            blurRadius: 40,
            spreadRadius: -8,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned(
            left: -3,
            top: 118,
            child: _HardwareButton(height: 26),
          ),
          const Positioned(
            left: -3,
            top: 158,
            child: _HardwareButton(height: 44),
          ),
          const Positioned(
            right: -3,
            top: 142,
            child: _HardwareButton(height: 62, mirrored: true),
          ),
          Padding(
            padding: const EdgeInsets.all(7),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: FadeTransition(
                opacity: contentOpacity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const ColoredBox(color: CinematicSplashTokens.phoneScreen),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: const Alignment(-0.35, -1),
                          end: const Alignment(0.8, 1.2),
                          colors: [
                            Colors.white.withValues(alpha: 0.11),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.35),
                          ],
                          stops: const [0.0, 0.45, 1.0],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 40, 18, 22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AR PREVIEW',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.4,
                              color: Colors.white.withValues(alpha: 0.45),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Living room',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            child: Hero(
                              tag: 'splash_ar_chair',
                              child: Image.asset(
                                'assets/images/ar/ar_feature_chair.png',
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.chair_outlined,
                                  size: 120,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          _GlassPill(
                            icon: Icons.view_in_ar_rounded,
                            label: 'Place in your room',
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: _DynamicIsland(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HardwareButton extends StatelessWidget {
  const _HardwareButton({
    required this.height,
    this.mirrored = false,
  });

  final double height;
  final bool mirrored;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.horizontal(
          left: mirrored ? Radius.zero : const Radius.circular(2),
          right: mirrored ? const Radius.circular(2) : Radius.zero,
        ),
        gradient: LinearGradient(
          begin: mirrored ? Alignment.centerRight : Alignment.centerLeft,
          end: mirrored ? Alignment.centerLeft : Alignment.centerRight,
          colors: const [Color(0xFF404040), Color(0xFF171717)],
        ),
      ),
    );
  }
}

class _DynamicIsland extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(
          color: const Color(0xFF22C55E),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF22C55E).withValues(alpha: 0.7),
              blurRadius: 6,
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassPill extends StatelessWidget {
  const _GlassPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.12),
            Colors.white.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: CinematicSplashTokens.accent),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.92),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingBadge extends StatelessWidget {
  const _FloatingBadge({
    required this.opacity,
    required this.alignment,
    required this.offset,
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  final Animation<double> opacity;
  final Alignment alignment;
  final Offset offset;
  final String emoji;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacity,
      child: Transform.translate(
        offset: offset,
        child: Align(
          alignment: alignment,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.1),
                  Colors.white.withValues(alpha: 0.02),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.65),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.45),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
