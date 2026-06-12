import 'package:flutter/material.dart';
import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/constants/app_typography.dart';

class AdminEmptyState extends StatelessWidget {
  const AdminEmptyState({
    required this.message,
    super.key,
    this.icon = Icons.inbox_outlined,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(icon, size: 36, color: AppColors.textMuted),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.metricLabel.copyWith(
              color: AppColors.textMuted,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
