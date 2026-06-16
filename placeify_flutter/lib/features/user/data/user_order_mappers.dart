import 'package:flutter/material.dart';
import 'package:placeify_client/placeify_client.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';

abstract final class UserOrderMappers {
  static const orderFilters = [
    'All',
    'Pending',
    'Shipped',
    'Delivered',
    'Cancelled',
  ];

  static List<UserOrderSummary> filterOrders(
    List<UserOrderSummary> orders,
    int filterIndex,
  ) {
    if (filterIndex == 0) return orders;

    final status = switch (filterIndex) {
      1 => _pendingStatuses,
      2 => [OrderStatus.shipped],
      3 => [OrderStatus.delivered],
      _ => [OrderStatus.cancelled, OrderStatus.rejected],
    };

    return orders.where((order) => status.contains(order.status)).toList();
  }

  static const _pendingStatuses = [
    OrderStatus.pending,
    OrderStatus.confirmed,
    OrderStatus.accepted,
    OrderStatus.processing,
  ];

  static String productTitle(UserOrderSummary order) {
    final name = order.primaryProductName?.trim();
    if (name != null && name.isNotEmpty) {
      if (order.itemCount > 1) {
        return '$name + ${order.itemCount - 1} more';
      }
      return name;
    }
    if (order.itemCount == 1) return '1 item';
    return '${order.itemCount} items';
  }

  static String orderMeta(UserOrderSummary order) {
    return Formatters.orderMeta(order.orderNumber, order.placedAt);
  }

  static String totalLabel(UserOrderSummary order) {
    return Formatters.currencyDecimal(order.totalAmount);
  }

  static String placedLabel(UserOrderSummary order) {
    return 'Placed ${Formatters.shortDate(order.placedAt)}';
  }

  static String statusLabel(OrderStatus status) {
    return switch (status) {
      OrderStatus.pending => 'Pending',
      OrderStatus.confirmed => 'Confirmed',
      OrderStatus.accepted => 'Accepted',
      OrderStatus.rejected => 'Rejected',
      OrderStatus.processing => 'Processing',
      OrderStatus.shipped => 'Shipped',
      OrderStatus.delivered => 'Delivered',
      OrderStatus.cancelled => 'Cancelled',
    };
  }

  static ({Color background, Color foreground}) statusColors(
    OrderStatus status,
  ) {
    return switch (status) {
      OrderStatus.pending ||
      OrderStatus.confirmed ||
      OrderStatus.accepted ||
      OrderStatus.processing =>
        (
          background: AppColors.accentBg,
          foreground: AppColors.accent,
        ),
      OrderStatus.shipped => (
          background: AppColors.sageBg,
          foreground: AppColors.sage,
        ),
      OrderStatus.delivered => (
          background: AppColors.tealBg,
          foreground: AppColors.teal,
        ),
      OrderStatus.cancelled || OrderStatus.rejected => (
          background: const Color(0x1A9B4A2A),
          foreground: AppColors.rust,
        ),
    };
  }

  static int progressStep(OrderStatus status) {
    return switch (status) {
      OrderStatus.pending => 0,
      OrderStatus.confirmed || OrderStatus.accepted || OrderStatus.processing =>
        1,
      OrderStatus.shipped => 2,
      OrderStatus.delivered => 3,
      OrderStatus.cancelled || OrderStatus.rejected => 0,
    };
  }
}
