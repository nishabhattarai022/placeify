import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

/// Static dashboard data until backend wiring is added.
abstract final class UserDashboardMockData {
  static const String userName = 'Anu';

  static const int totalOrders = 12;
  static const int pendingOrders = 3;
  static const int wishlistItems = 8;
  static const int refundRequests = 2;
}

class UserOverviewMetric {
  const UserOverviewMetric({
    required this.label,
    required this.value,
    required this.icon,
    required this.accentColor,
    required this.backgroundColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accentColor;
  final Color backgroundColor;
}

abstract final class UserDashboardOverviewMetrics {
  static const List<UserOverviewMetric> cards = [
    UserOverviewMetric(
      label: 'Total Orders',
      value: '${UserDashboardMockData.totalOrders}',
      icon: Icons.inventory_2_outlined,
      accentColor: AppColors.sage,
      backgroundColor: AppColors.sageBg,
    ),
    UserOverviewMetric(
      label: 'Pending Orders',
      value: '${UserDashboardMockData.pendingOrders}',
      icon: Icons.local_shipping_outlined,
      accentColor: AppColors.accent,
      backgroundColor: AppColors.accentBg,
    ),
    UserOverviewMetric(
      label: 'Wishlist Items',
      value: '${UserDashboardMockData.wishlistItems}',
      icon: Icons.favorite_border_rounded,
      accentColor: AppColors.coral,
      backgroundColor: AppColors.coralBg,
    ),
    UserOverviewMetric(
      label: 'Refund Requests',
      value: '${UserDashboardMockData.refundRequests}',
      icon: Icons.replay_outlined,
      accentColor: AppColors.lavender,
      backgroundColor: AppColors.lavenderBg,
    ),
  ];
}
