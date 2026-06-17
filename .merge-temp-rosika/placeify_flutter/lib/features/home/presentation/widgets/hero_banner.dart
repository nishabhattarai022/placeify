import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/animated_scale_tap.dart';
import '../../../../core/widgets/painters/placeify_chair_painter.dart';

class HeroBanner extends StatefulWidget {
  const HeroBanner({super.key});

  @override
  State<HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<HeroBanner> {
  double _scale = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _scale = 0.98),
        onTapUp: (_) {
          setState(() => _scale = 1);
          context.push('/product/p4');
        },
        onTapCancel: () => setState(() => _scale = 1),
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Container(
            constraints: const BoxConstraints(minHeight: 168),
            decoration: BoxDecoration(
              color: AppColors.espresso,
              borderRadius: AppRadii.lg,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: CustomPaint(painter: _BannerTexturePainter()),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 26, 0, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'NEW COLLECTION',
                        style: AppTypography.newCollectionTag,
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          style: AppTypography.bannerHeadline,
                          children: const [
                            TextSpan(text: 'Try in '),
                            TextSpan(
                              text: 'your room',
                              style: TextStyle(
                                fontFamily: 'Fraunces',
                                fontSize: 28,
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.italic,
                                color: AppColors.accentLight,
                              ),
                            ),
                            TextSpan(text: ' first.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      AnimatedScaleTap(
                        onTap: () => context.push('/product/p4'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: AppRadii.pill,
                          ),
                          child: const Text(
                            'View in AR',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.warmWhite,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Positioned(
                  right: -8,
                  bottom: 0,
                  child: RepaintBoundary(
                    child: CustomPaint(
                      size: Size(148, 148),
                      painter: PlaceifyChairPainter(
                        showArBrackets: false,
                        showScanLines: false,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BannerTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 1;
    for (var i = 0.0; i < size.width; i += 24) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
