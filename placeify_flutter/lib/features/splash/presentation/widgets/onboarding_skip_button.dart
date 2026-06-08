import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class OnboardingSkipButton extends StatelessWidget {
  const OnboardingSkipButton({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.14),
          ),
        ),
        child: Text(
          'Skip',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.onboardingTextHead.withValues(alpha: 0.65),
          ),
        ),
      ),
    );
  }
}
