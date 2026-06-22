import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

/// Compact order progress indicator for user order cards.
class OrderProgressTracker extends StatelessWidget {
  const OrderProgressTracker({required this.activeStep, super.key});

  final int activeStep;

  static const _labels = ['Confirmed', 'Packed', 'Delivered'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          for (var i = 0; i < _labels.length; i++) ...[
            if (i > 0)
              Expanded(
                child: Container(
                  height: 2,
                  color: i <= activeStep
                      ? AppColors.accent
                      : AppColors.creamDark,
                ),
              ),
            _StepDot(
              label: _labels[i],
              isActive: i <= activeStep,
            ),
          ],
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({required this.label, required this.isActive});

  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.accent : AppColors.creamDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? AppColors.accent : AppColors.textMuted,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
