import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

class OrderProgressTracker extends StatelessWidget {
  const OrderProgressTracker({required this.activeStep, super.key});

  final int activeStep;

  static const _labels = ['Confirmed', 'Packed', 'Shipped', 'Delivered'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          for (var i = 0; i < _labels.length; i++) ...[
            if (i > 0)
              Expanded(
                child: Container(
                  height: 2,
                  margin: const EdgeInsets.only(bottom: 24),
                  color: i <= activeStep ? AppColors.teal : AppColors.creamDark,
                ),
              ),
            Expanded(
              child: Column(
                children: [
                  _ProgDot(
                    done: i < activeStep,
                    active: i == activeStep,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _labels[i],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProgDot extends StatelessWidget {
  const _ProgDot({required this.done, required this.active});

  final bool done;
  final bool active;

  @override
  Widget build(BuildContext context) {
    Color fill = AppColors.creamDark;
    Color border = AppColors.sand;
    if (done) {
      fill = AppColors.teal;
      border = AppColors.teal;
    } else if (active) {
      fill = AppColors.accent;
      border = AppColors.accent;
    }

    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
        border: Border.all(color: border, width: 2),
        boxShadow: active
            ? [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.2),
                  blurRadius: 0,
                  spreadRadius: 4,
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: done
          ? const Icon(Icons.check, size: 9, color: Colors.white)
          : null,
    );
  }
}
