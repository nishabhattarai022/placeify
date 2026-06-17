import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/cover_fit_box.dart';

class FoggyImageBackground extends StatelessWidget {
  const FoggyImageBackground({
    required this.imageAsset,
    super.key,
  });

  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CoverAssetImage(
          asset: imageAsset,
          errorBuilder: (_, __, ___) => const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A1410),
                  AppColors.onboardingBg,
                ],
              ),
            ),
          ),
        ),
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.45, 1.0],
              colors: [
                AppColors.onboardingBg.withValues(alpha: 0.28),
                AppColors.onboardingBg.withValues(alpha: 0.42),
                AppColors.onboardingBg.withValues(alpha: 0.58),
              ],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0, -0.2),
              radius: 1.1,
              colors: [
                Colors.white.withValues(alpha: 0.04),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
