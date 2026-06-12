import 'package:flutter/material.dart';
import 'package:placeify_flutter/core/constants/app_colors.dart';
import 'package:placeify_flutter/core/constants/app_radii.dart';
import 'package:placeify_flutter/core/constants/app_typography.dart';
import 'package:placeify_flutter/features/admin/domain/enums/user_role.dart';

/// Role pill for platform user rows in admin views.
class AdminRoleChip extends StatelessWidget {
  const AdminRoleChip({
    required this.role,
    super.key,
  });

  final UserRole role;

  String get _label => switch (role) {
        UserRole.customer => 'Customer',
        UserRole.vendor => 'Vendor',
        UserRole.admin => 'Admin',
      };

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (role) {
      UserRole.customer => (
          AppColors.creamDark,
          AppColors.textMuted,
        ),
      UserRole.vendor => (
          AppColors.sage.withValues(alpha: 0.14),
          AppColors.sage,
        ),
      UserRole.admin => (
          AppColors.adminSlateBg,
          AppColors.adminSlate,
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
