import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../providers/vendor_registration_provider.dart';

class VendorRegistrationStepIndicator extends StatelessWidget {
  const VendorRegistrationStepIndicator({
    required this.currentStep,
    super.key,
  });

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step ${currentStep + 1} of ${VendorRegistrationUiState.stepCount}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.75),
            letterSpacing: 0.06 * 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          VendorRegistrationUiState.stepTitles[currentStep],
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(VendorRegistrationUiState.stepCount, (i) {
            final isActive = i == currentStep;
            final isComplete = i < currentStep;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                margin: EdgeInsets.only(
                  right: i < VendorRegistrationUiState.stepCount - 1 ? 6 : 0,
                ),
                height: 4,
                decoration: BoxDecoration(
                  color: isActive || isComplete
                      ? AppColors.accent
                      : Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
