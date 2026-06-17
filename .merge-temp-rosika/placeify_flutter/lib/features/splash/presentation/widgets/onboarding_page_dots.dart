import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class OnboardingPageDots extends StatelessWidget {
  const OnboardingPageDots({
    required this.count,
    required this.active,
    super.key,
  });

  final int count;
  final int active;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final isActive = i == active;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.only(right: 7),
          width: isActive ? 26 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.onboardingAmber
                : AppColors.onboardingTextBody.withValues(alpha: 0.40),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}
