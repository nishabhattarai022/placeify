import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/models/order.dart';

class OrderRow extends StatefulWidget {
  const OrderRow({required this.order, super.key});

  final Order order;

  @override
  State<OrderRow> createState() => _OrderRowState();
}

class _OrderRowState extends State<OrderRow> {
  double _translateX = 0;
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final meta = order.status == OrderStatus.customRequest
        ? order.requestMeta ?? 'Custom request'
        : Formatters.orderMeta(order.orderNumber, order.date);

    return GestureDetector(
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
          border: Border.all(
            color: _hovered ? AppColors.sand : AppColors.creamDark,
            width: 1.5,
          ),
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
                  order.productSvgIconPath,
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
            _StatusPill(status: order.status, label: order.statusLabel),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status, required this.label});
  final OrderStatus status;
  final String label;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      OrderStatus.pending => (
          AppColors.accent.withValues(alpha: 0.14),
          AppColors.accent,
        ),
      OrderStatus.shipped => (
          AppColors.sage.withValues(alpha: 0.14),
          AppColors.sage,
        ),
      OrderStatus.customRequest => (
          AppColors.rust.withValues(alpha: 0.12),
          AppColors.rust,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadii.pill,
      ),
      child: Text(
        label,
        style: AppTypography.statusPill.copyWith(color: fg),
      ),
    );
  }
}
