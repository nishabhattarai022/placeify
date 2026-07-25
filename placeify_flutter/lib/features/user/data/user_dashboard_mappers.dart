import 'package:flutter/material.dart';
import 'package:placeify_client/placeify_client.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../domain/models/user_overview_metric.dart';

abstract final class UserDashboardMappers {
  static int countPendingOrders(List<UserOrderSummary> orders) {
    return orders
        .where(
          (order) =>
              order.status != OrderStatus.delivered &&
              order.status != OrderStatus.cancelled,
        )
        .length;
  }

  static String firstName(UserDashboard dashboard) {
    final name = dashboard.profile.name.trim();
    if (name.isEmpty) return 'there';
    return name.split(' ').first;
  }

  static List<UserOverviewMetric> overviewMetrics(
    UserDashboard dashboard, {
    int? pendingOrders,
    int? deliveredOrders,
    int? notificationCount,
  }) {
    final pendingLabel = pendingOrders == null ? '...' : '$pendingOrders';
    final deliveredLabel =
        deliveredOrders == null ? '...' : '$deliveredOrders';
    final notificationsLabel =
        notificationCount == null ? '...' : '$notificationCount';

    return [
      UserOverviewMetric(
        label: 'Total Orders',
        value: '${dashboard.orderCount}',
        icon: Icons.inventory_2_outlined,
        accentColor: AppColors.sage,
        backgroundColor: AppColors.sageBg,
      ),
      UserOverviewMetric(
        label: 'Pending Orders',
        value: pendingLabel,
        icon: Icons.local_shipping_outlined,
        accentColor: AppColors.accent,
        backgroundColor: AppColors.accentBg,
      ),
      UserOverviewMetric(
        label: 'Delivered Orders',
        value: deliveredLabel,
        icon: Icons.check_circle_outline,
        accentColor: AppColors.forest,
        backgroundColor: AppColors.sageBg,
      ),
      UserOverviewMetric(
        label: 'Wishlist Count',
        value: '${dashboard.wishlistCount}',
        icon: Icons.favorite_border_rounded,
        accentColor: AppColors.coral,
        backgroundColor: AppColors.coralBg,
      ),
      UserOverviewMetric(
        label: 'Notifications',
        value: notificationsLabel,
        icon: Icons.notifications_outlined,
        accentColor: AppColors.lavender,
        backgroundColor: AppColors.lavenderBg,
      ),
      UserOverviewMetric(
        label: 'Total Spend',
        value: Formatters.currencyFull(dashboard.totalSpend),
        icon: Icons.payments_outlined,
        accentColor: AppColors.forest,
        backgroundColor: AppColors.sageBg,
      ),
      UserOverviewMetric(
        label: 'Cart Items',
        value: '${dashboard.cartItemCount}',
        icon: Icons.shopping_cart_outlined,
        accentColor: AppColors.forest,
        backgroundColor: AppColors.sageBg,
      ),
      UserOverviewMetric(
        label: 'Refund Amount',
        value: Formatters.currencyFull(dashboard.refundAmount),
        icon: Icons.replay_outlined,
        accentColor: AppColors.coral,
        backgroundColor: AppColors.coralBg,
      ),
      UserOverviewMetric(
        label: 'Pending Refunds',
        value: '${dashboard.pendingRefundCount}',
        icon: Icons.hourglass_empty_outlined,
        accentColor: AppColors.lavender,
        backgroundColor: AppColors.lavenderBg,
      ),
    ];
  }
}
