import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify_flutter/core/constants/app_colors.dart';
import 'package:placeify_flutter/core/constants/app_radii.dart';
import 'package:placeify_flutter/core/services/haptic_service.dart';
import 'package:placeify_flutter/core/utils/formatters.dart';
import 'package:placeify_flutter/features/admin/domain/constants/admin_routes.dart';
import 'package:placeify_flutter/features/admin/domain/models/vendor_application.dart';
import 'package:placeify_flutter/features/admin/presentation/widgets/admin_status_chip.dart';
import 'package:placeify_flutter/features/vendor/data/config/vendor_mock_config.dart';

class AdminVendorRow extends StatefulWidget {
  const AdminVendorRow({
    required this.vendor,
    super.key,
  });

  final VendorApplication vendor;

  @override
  State<AdminVendorRow> createState() => _AdminVendorRowState();
}

class _AdminVendorRowState extends State<AdminVendorRow> {
  double _translateX = 0;

  @override
  Widget build(BuildContext context) {
    final vendor = widget.vendor;
    final productCount = VendorMockConfig.productsFor(vendor.vendorId).length;
    final orderCount = VendorMockConfig.ordersFor(vendor.vendorId).length;
    final meta =
        '${Formatters.shortDate(vendor.submittedAt)} · $productCount products · $orderCount orders';

    return GestureDetector(
      onTap: () {
        HapticService.light();
        context.push(AdminRoutes.vendorDetail(vendor.vendorId));
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
                vendor.businessName.isNotEmpty
                    ? vendor.businessName[0].toUpperCase()
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
                    vendor.businessName,
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
                  if (vendor.moderationNote != null &&
                      vendor.moderationNote!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      vendor.moderationNote!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.rust,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (vendor.appealSubmittedAt != null) ...[
                    const SizedBox(height: 4),
                    const Text(
                      'Appeal pending review',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.espresso,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            AdminStatusChip(status: vendor.status),
          ],
        ),
      ),
    );
  }
}
