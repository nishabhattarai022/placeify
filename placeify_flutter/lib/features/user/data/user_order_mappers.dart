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

  static String statusLabel(
    OrderStatus status, {
    DeliveryStage? latestStage,
  }) {
    if (latestStage != null) {
      return switch (latestStage) {
        DeliveryStage.orderPlaced => 'Accepted',
        DeliveryStage.packed => 'Packed',
        DeliveryStage.shipped => 'Shipped',
        DeliveryStage.outForDelivery => 'Out for delivery',
        DeliveryStage.delivered => 'Delivered',
        DeliveryStage.rejected => 'Rejected',
      };
    }

    return switch (status) {
      OrderStatus.pending => 'Pending',
      OrderStatus.confirmed => 'Confirmed',
      OrderStatus.accepted => 'Accepted',
      OrderStatus.rejected => 'Rejected',
      OrderStatus.processing => 'Processing',
      OrderStatus.shipped => 'Shipped',
      OrderStatus.delivered => 'Delivered',
      OrderStatus.returnRequested => 'Return requested',
      OrderStatus.refunded => 'Refunded',
      OrderStatus.cancelled => 'Cancelled',
      OrderStatus.autoCancelled => 'Auto cancelled',
    };
  }

  static ({Color background, Color foreground}) statusColors(
    OrderStatus status,
  ) {
    return switch (status) {
      OrderStatus.pending ||
      OrderStatus.confirmed ||
      OrderStatus.accepted ||
      OrderStatus.processing => (
        background: AppColors.accentBg,
        foreground: AppColors.accent,
      ),
      OrderStatus.shipped || OrderStatus.returnRequested => (
        background: AppColors.sageBg,
        foreground: AppColors.sage,
      ),
      OrderStatus.delivered || OrderStatus.refunded => (
        background: AppColors.tealBg,
        foreground: AppColors.teal,
      ),
      OrderStatus.cancelled ||
      OrderStatus.rejected ||
      OrderStatus.autoCancelled => (
        background: const Color(0x1A9B4A2A),
        foreground: AppColors.rust,
      ),
    };
  }

  static int progressStep(OrderStatus status, {DeliveryStage? latestStage}) {
    if (latestStage != null) {
      return switch (latestStage) {
        DeliveryStage.orderPlaced => 0,
        DeliveryStage.packed => 1,
        DeliveryStage.shipped => 1,
        DeliveryStage.outForDelivery => 1,
        DeliveryStage.delivered => 2,
        DeliveryStage.rejected => 0,
      };
    }

    return switch (status) {
      OrderStatus.pending => 0,
      OrderStatus.confirmed || OrderStatus.accepted => 0,
      OrderStatus.processing => 1,
      OrderStatus.shipped => 1,
      OrderStatus.delivered ||
      OrderStatus.returnRequested ||
      OrderStatus.refunded =>
        2,
      OrderStatus.cancelled ||
      OrderStatus.rejected ||
      OrderStatus.autoCancelled => 0,
    };
  }

  static String paymentStatusLabel(OrderPaymentStatus status) {
    return switch (status) {
      OrderPaymentStatus.unpaid => 'Payment pending',
      OrderPaymentStatus.paymentReceived => 'Payment received',
      OrderPaymentStatus.paymentConfirmed => 'Payment confirmed',
    };
  }

  static bool showsDeliveryProgress(OrderStatus status) {
    return switch (status) {
      OrderStatus.accepted ||
      OrderStatus.processing ||
      OrderStatus.shipped ||
      OrderStatus.delivered => true,
      _ => false,
    };
  }

  static String? latestUpdateLabel(UserOrderSummary order) {
    final note = order.latestDeliveryNote?.trim();
    if (note != null && note.isNotEmpty) return note;

    final stage = order.latestDeliveryStage;
    if (stage == null) return null;

    return switch (stage) {
      DeliveryStage.orderPlaced => 'Order confirmed by the shop',
      DeliveryStage.packed => 'Your order has been packed',
      DeliveryStage.shipped => 'Your order is on the way',
      DeliveryStage.outForDelivery => 'Out for delivery',
      DeliveryStage.delivered => 'Delivered',
      DeliveryStage.rejected => 'Order rejected by the shop',
    };
  }
}
