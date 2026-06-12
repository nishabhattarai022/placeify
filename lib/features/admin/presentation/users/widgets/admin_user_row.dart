import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/services/haptic_service.dart';
import 'package:placeify/features/admin/domain/constants/admin_routes.dart';
import 'package:placeify/core/constants/app_radii.dart';
import 'package:placeify/core/utils/formatters.dart';
import 'package:placeify/features/admin/domain/models/platform_user.dart';
import 'package:placeify/features/admin/presentation/widgets/admin_role_chip.dart';
import 'package:placeify/features/admin/presentation/widgets/admin_status_chip.dart';
import 'package:placeify/features/vendor/domain/enums/vendor_status.dart';

class AdminUserRow extends StatelessWidget {
  const AdminUserRow({
    required this.user,
    super.key,
  });

  final PlatformUser user;

  @override
  Widget build(BuildContext context) {
    final meta = '${user.email} · ${Formatters.shortDate(user.createdAt)}';
    final showVendorStatus = user.vendorStatus != VendorStatus.none;

    return GestureDetector(
      onTap: () {
        HapticService.light();
        context.push(AdminRoutes.userDetail(user.id));
      },
      child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: AppRadii.md,
        border: Border.all(color: AppColors.creamDark, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.bark,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  meta,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AdminRoleChip(role: user.role),
              if (showVendorStatus) ...[
                const SizedBox(height: 6),
                AdminStatusChip(status: user.vendorStatus),
              ],
            ],
          ),
        ],
      ),
    ),
    );
  }
}
