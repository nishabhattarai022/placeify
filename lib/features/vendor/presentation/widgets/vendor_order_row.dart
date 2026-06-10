import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/haptic_service.dart';
import '../../domain/constants/vendor_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/models/vendor_order.dart';
import 'order_status_chip.dart';

class VendorOrderRow extends StatefulWidget {
  const VendorOrderRow({required this.order, super.key});

  final VendorOrder order;

  @override
  State<VendorOrderRow> createState() => _VendorOrderRowState();
}

class _VendorOrderRowState extends State<VendorOrderRow> {
  double _translateX = 0;

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final meta = Formatters.orderMeta(order.orderNumber, order.orderedAt);

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
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: SvgPicture.asset(
                  _iconForProduct(order.productName),
                  width: 24,
                  colorFilter: const ColorFilter.mode(
                    AppColors.bark,
                    BlendMode.srcIn,
                  ),
                ),
              ),
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
