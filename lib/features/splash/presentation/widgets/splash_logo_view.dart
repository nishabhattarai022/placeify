import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'onboarding/pulsing_dot.dart';

class SplashLogoView extends StatelessWidget {
  const SplashLogoView({
    required this.opacityAnim,
    required this.scaleAnim,
    super.key,
  });

  final Animation<double> opacityAnim;
  final Animation<double> scaleAnim;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.onboardingBg,
      child: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([opacityAnim, scaleAnim]),
          builder: (context, child) {
            return Opacity(
              opacity: opacityAnim.value,
              child: Transform.scale(
                scale: scaleAnim.value,
                child: child,
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Place',
                      style: TextStyle(
                        fontFamily: 'Fraunces',
                        fontSize: 52,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        color: AppColors.onboardingTextHead,
                        letterSpacing: -1.0,
                        height: 1.0,
                      ),
                    ),
                    TextSpan(
                      text: 'ify',
                      style: TextStyle(
                        fontFamily: 'Fraunces',
                        fontSize: 52,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        color: AppColors.onboardingAmber,
                        letterSpacing: -1.0,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'See it in your space.',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                  color: AppColors.onboardingTextBody,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 44),
              const PulsingDot(color: AppColors.onboardingAmber),
            ],
          ),
        ),
      ),
    );
  }
}
