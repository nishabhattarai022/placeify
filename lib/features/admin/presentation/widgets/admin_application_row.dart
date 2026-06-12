import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/constants/app_radii.dart';
import 'package:placeify/core/services/haptic_service.dart';
import 'package:placeify/core/utils/formatters.dart';
import 'package:placeify/features/admin/domain/constants/admin_routes.dart';
import 'package:placeify/features/admin/domain/models/vendor_application.dart';
import 'package:placeify/features/admin/presentation/widgets/admin_status_chip.dart';

class AdminApplicationRow extends StatefulWidget {
  const AdminApplicationRow({
    required this.application,
    super.key,
  });

  final VendorApplication application;

  @override
  State<AdminApplicationRow> createState() => _AdminApplicationRowState();
}

class _AdminApplicationRowState extends State<AdminApplicationRow> {
  double _translateX = 0;

  @override
  Widget build(BuildContext context) {
    final application = widget.application;
    final meta =
        '${application.contactEmail} · ${Formatters.shortDate(application.submittedAt)}';

    return GestureDetector(
      onTap: () {
        HapticService.light();
        context.push(AdminRoutes.applicationDetail(application.vendorId));
      },
      onTapDown: (_) => setState(() => _translateX = 5),
      onTapUp: (_) => setState(() => _translateX = 0),
      onTapCancel: () => setState(() => _translateX = 0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.only(bottom: 10),
        transform: Matrix4.translationValues(_translateX, 0, 0),
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
                application.businessName.isNotEmpty
                    ? application.businessName[0].toUpperCase()
                    : '?',
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
                    application.businessName,
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
            AdminStatusChip(status: application.status),
          ],
        ),
      ),
    );
  }
}
