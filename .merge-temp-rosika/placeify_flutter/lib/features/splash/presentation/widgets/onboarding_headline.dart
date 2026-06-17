import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../models/onboarding_slide.dart';

class OnboardingHeadline extends StatelessWidget {
  const OnboardingHeadline({required this.slide, super.key});

  final OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontFamily: 'Fraunces',
          fontSize: 40,
          fontWeight: FontWeight.w300,
          color: AppColors.onboardingTextHead,
          height: 1.12,
          letterSpacing: -0.5,
        ),
        children: [
          TextSpan(text: slide.headlinePart1),
          TextSpan(
            text: slide.headlineItalic,
            style: AppFonts.poppins(
              fontSize: 40,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.italic,
              color: AppColors.onboardingAmber,
              height: 1.12,
              letterSpacing: -0.5,
            ),
          ),
          TextSpan(text: slide.headlinePart2),
        ],
      ),
    );
  }
}
