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

/// Controls how [VendorOrderRow] renders order information.
enum VendorOrderRowStyle {
  /// Full workflow row for the Orders page (status chip + pending actions).
  workflow,

  /// Summary row for the dashboard (order, customer, total, date only).
  recentSummary,
}

class VendorOrderRow extends ConsumerStatefulWidget {
  const VendorOrderRow({
    required this.order,
    this.style = VendorOrderRowStyle.workflow,
    super.key,
  });

  final VendorOrder order;
  final VendorOrderRowStyle style;

  @override
  ConsumerState<VendorOrderRow> createState() => _VendorOrderRowState();

  static String iconForProduct(String productName) {
    final lower = productName.toLowerCase();
    if (lower.contains('sofa')) return 'assets/icons/ic_sofa.svg';
    if (lower.contains('table') || lower.contains('desk')) {
      return 'assets/icons/ic_table.svg';
    }
    return 'assets/icons/ic_chair.svg';
  }
}

class _VendorOrderRowState extends ConsumerState<VendorOrderRow> {
  double _translateX = 0;

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    return GestureDetector(
      onTap: () {
        HapticService.light();
        context.push(VendorRoutes.orderDetail(order.id));
      },
      onTapDown: widget.style == VendorOrderRowStyle.workflow
          ? (_) => setState(() => _translateX = 5)
          : null,
      onTapUp: widget.style == VendorOrderRowStyle.workflow
          ? (_) => setState(() => _translateX = 0)
          : null,
      onTapCancel: widget.style == VendorOrderRowStyle.workflow
          ? () => setState(() => _translateX = 0)
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.only(bottom: 10),
        transform: widget.style == VendorOrderRowStyle.workflow
            ? Matrix4.translationValues(_translateX, 0, 0)
            : Matrix4.identity(),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        decoration: BoxDecoration(
          color: AppColors.warmWhite,
          borderRadius: AppRadii.md,
          border: Border.all(color: AppColors.creamDark, width: 1.5),
        ),
        child: widget.style == VendorOrderRowStyle.recentSummary
            ? _RecentSummaryContent(order: order)
            : _WorkflowContent(order: order),
      ),
    );
  }
}

class _RecentSummaryContent extends ConsumerWidget {
  const _RecentSummaryContent({required this.order});

  final VendorOrder order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = ref.watch(vendorProductImageUrlProvider(order.productId));

    return Row(
      children: [
        VendorListThumbnail(
          label: order.productName,
          imageUrl: imageUrl,
          fallbackIconPath: VendorOrderRow.iconForProduct(order.productName),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order #${order.orderNumber}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                order.customerName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                Formatters.currencyFull(order.totalAmount),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                Formatters.shortDate(order.orderedAt),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WorkflowContent extends ConsumerWidget {
  const _WorkflowContent({required this.order});

  final VendorOrder order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meta = Formatters.orderMeta(order.orderNumber, order.orderedAt);
    final imageUrl = ref.watch(vendorProductImageUrlProvider(order.productId));

    return Row(
      children: [
        VendorListThumbnail(
          label: order.productName,
          imageUrl: imageUrl,
          fallbackIconPath: VendorOrderRow.iconForProduct(order.productName),
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
    );
  }
}
