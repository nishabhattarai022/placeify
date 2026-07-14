import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/haptic_service.dart';
import '../../domain/constants/vendor_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/enums/order_status.dart';
import '../../domain/models/vendor_order.dart';
import '../providers/vendor_product_image_provider.dart';
import 'order_action_sheet.dart';
import 'order_status_chip.dart';
import 'vendor_list_thumbnail.dart';

class VendorOrderRow extends ConsumerStatefulWidget {
  const VendorOrderRow({required this.order, super.key});

  final VendorOrder order;

  @override
  ConsumerState<VendorOrderRow> createState() => _VendorOrderRowState();
}

class _VendorOrderRowState extends ConsumerState<VendorOrderRow> {
  double _translateX = 0;

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final meta = Formatters.orderMeta(order.orderNumber, order.orderedAt);
    final imageUrl = ref.watch(vendorProductImageUrlProvider(order.productId));

    return GestureDetector(
      onTap: () {
        HapticService.light();
        context.push(VendorRoutes.orderDetail(order.id));
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
            VendorListThumbnail(
              label: order.productName,
              imageUrl: imageUrl,
              fallbackIconPath: _iconForProduct(order.productName),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.quantity > 1
                        ? '${order.productName} × ${order.quantity}'
                        : order.productName,
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
                  ),
                ],
              ),
            ),
            OrderStatusChip(status: order.status, label: order.statusLabel),
            if (order.status == OrderStatus.pending) ...[
              const SizedBox(width: 4),
              IconButton(
                onPressed: () {
                  HapticService.light();
                  OrderActionSheet.show(context, ref, order);
                },
                icon: const Icon(
                  Icons.more_horiz_rounded,
                  size: 22,
                  color: AppColors.textSecondary,
                ),
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ],
        ),
      ),
    );
  }

  static String _iconForProduct(String productName) {
    final lower = productName.toLowerCase();
    if (lower.contains('sofa')) return 'assets/icons/ic_sofa.svg';
    if (lower.contains('table') || lower.contains('desk')) {
      return 'assets/icons/ic_table.svg';
    }
    return 'assets/icons/ic_chair.svg';
  }
}
