import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/widgets/placeify_bottom_sheet.dart';
import '../../../../core/widgets/toast_overlay.dart';
import '../../domain/constants/order_strings.dart';
import '../../domain/enums/consumer_order_status.dart';
import '../../domain/models/order.dart';
import '../providers/orders_provider.dart';
import '../providers/submitted_order_reviews_provider.dart';
import 'leave_review_sheet.dart';

abstract final class OrderQuickActionsSheet {
  static Future<void> show(
    BuildContext context,
    WidgetRef ref,
    Order order,
  ) {
    HapticService.medium();
    return PlaceifyBottomSheet.show<void>(
      context,
      builder: (sheetContext) => _OrderQuickActionsBody(
        parentContext: context,
        sheetContext: sheetContext,
        ref: ref,
        order: order,
      ),
    );
  }
}

class _OrderQuickActionsBody extends ConsumerWidget {
  const _OrderQuickActionsBody({
    required this.parentContext,
    required this.sheetContext,
    required this.ref,
    required this.order,
  });

  final BuildContext parentContext;
  final BuildContext sheetContext;
  final WidgetRef ref;
  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = _actionsForOrder(ref);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlaceifyBottomSheetHeader(
          title: OrderStrings.quickActionsTitle,
          subtitle: order.orderNumber,
        ),
        const SizedBox(height: AppSpacing.md),
        for (var i = 0; i < actions.length; i++) ...[
          if (i > 0) const SizedBox(height: 4),
          _QuickActionTile(
            icon: actions[i].icon,
            label: actions[i].label,
            onTap: () {
              Navigator.pop(sheetContext);
              actions[i].onTap(parentContext, this.ref);
            },
          ),
        ],
      ],
    );
  }

  List<_QuickAction> _actionsForOrder(WidgetRef ref) {
    final actions = <_QuickAction>[
      _QuickAction(
        icon: Icons.receipt_long_outlined,
        label: OrderStrings.orderDetailTitle,
        onTap: (context, ref) {
          context.pushNamed(
            'profileOrderDetail',
            pathParameters: {'orderId': order.id},
          );
        },
      ),
    ];

    if (order.hasTracking && order.isActive) {
      actions.insert(
        0,
        _QuickAction(
          icon: Icons.local_shipping_outlined,
          label: OrderStrings.trackAction,
          onTap: (context, ref) {
            context.pushNamed(
              'profileOrderTracking',
              pathParameters: {'orderId': order.id},
            );
          },
        ),
      );
    }

    if (order.isDelivered) {
      actions.add(
        _QuickAction(
          icon: Icons.refresh_rounded,
          label: OrderStrings.reorderAction,
          onTap: (context, ref) {
            ref.read(ordersProvider.notifier).reorder(
                  order.id,
                  context: context,
                );
          },
        ),
      );
      final alreadyReviewed =
          ref.watch(submittedOrderReviewsProvider).contains(order.id);
      actions.add(
        _QuickAction(
          icon: Icons.rate_review_outlined,
          label: alreadyReviewed
              ? OrderStrings.reviewSubmittedAction
              : OrderStrings.leaveReviewAction,
          onTap: (context, ref) {
            LeaveReviewSheet.show(context, ref, order: order);
          },
        ),
      );
    }

    if (order.isReturn) {
      actions.add(
        _QuickAction(
          icon: Icons.assignment_return_outlined,
          label: OrderStrings.viewReturnAction,
          onTap: (context, ref) {
            context.pushNamed(
              'profileOrderDetail',
              pathParameters: {'orderId': order.id},
            );
          },
        ),
      );
    }

    if (order.isCancellable) {
      actions.add(
        _QuickAction(
          icon: Icons.cancel_outlined,
          label: OrderStrings.cancelAction,
          onTap: (context, ref) {
            context.pushNamed(
              'profileOrderDetail',
              pathParameters: {'orderId': order.id},
            );
          },
        ),
      );
    }

    if (order.isActive &&
        order.status.index >= ConsumerOrderStatus.packed.index) {
      actions.add(
        _QuickAction(
          icon: Icons.support_agent_outlined,
          label: OrderStrings.contactSupportAction,
          onTap: (context, ref) {
            PlaceifyToast.show(
              context,
              '${OrderStrings.contactSupportAction} coming soon',
            );
          },
        ),
      );
    }

    return actions;
  }
}

class _QuickAction {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final void Function(BuildContext context, WidgetRef ref) onTap;
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticService.light();
          onTap();
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
          child: Row(
            children: [
              Icon(icon, size: 22, color: AppColors.textSecondary),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
