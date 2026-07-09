import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radii.dart';
import '../../../../../core/services/haptic_service.dart';
import '../../../../../core/theme/app_fonts.dart';

/// Pill action button aligned with order cards — black primary, white secondary.
class RefundActionButton extends StatelessWidget {
  const RefundActionButton({
    required this.label,
    required this.onTap,
    this.icon,
    this.primary = true,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticService.light();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: primary ? Colors.black : Colors.white,
          borderRadius: AppRadii.pill,
          border: primary
              ? null
              : Border.all(color: Colors.black.withValues(alpha: 0.08)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: primary ? Colors.white : Colors.black87,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: AppFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: primary ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
