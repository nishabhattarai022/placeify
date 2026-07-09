import 'package:flutter/material.dart';
import 'package:placeify_flutter/core/constants/app_colors.dart';
import 'package:placeify_flutter/core/constants/app_radii.dart';
import 'package:placeify_flutter/core/constants/app_typography.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';

/// Semantic status pill for vendor applications and platform users.
class AdminStatusChip extends StatelessWidget {
  const AdminStatusChip({
    required this.status,
    super.key,
  });

  final VendorStatus status;

  String get _label => switch (status) {
        VendorStatus.pending => 'Pending',
        VendorStatus.approved => 'Approved',
        VendorStatus.suspended => 'Suspended',
        VendorStatus.none => 'Declined',
      };

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      VendorStatus.pending => (
          AppColors.accent.withValues(alpha: 0.14),
          AppColors.accent,
        ),
      VendorStatus.approved => (
          AppColors.sage.withValues(alpha: 0.14),
          AppColors.sage,
        ),
      VendorStatus.suspended => (
          AppColors.coral.withValues(alpha: 0.14),
          AppColors.coral,
        ),
      VendorStatus.none => (
          AppColors.coral.withValues(alpha: 0.14),
          AppColors.coral,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadii.pill,
      ),
      child: Text(
        _label,
        style: AppTypography.statusPill.copyWith(color: fg),
      ),
    );
  }
}
