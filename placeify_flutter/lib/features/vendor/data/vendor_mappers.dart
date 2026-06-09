import 'package:flutter/material.dart';
import 'package:placeify_client/placeify_client.dart' as api;

import '../domain/models/order.dart';
import '../domain/models/vendor_metric.dart';

abstract final class VendorMappers {
  static const _barColors = [
    Color(0xFFC17F3C),
    Color(0xFF7A8C6E),
    Color(0xFF8B7355),
  ];

  static List<VendorMetric> metrics(api.VendorDashboard dashboard) {
    return [
      VendorMetric(
        label: 'Orders',
        value: dashboard.orderCount.toString(),
        trendLabel: dashboard.orderCount > 0 ? 'All time' : 'No orders yet',
        trendColor: const Color(0xFF7A8C6E),
        iconPath: 'assets/icons/ic_trending_up.svg',
      ),
      VendorMetric(
        label: 'Products',
        value: dashboard.productCount.toString(),
        trendLabel: '${dashboard.activeProductCount} active',
        trendColor: const Color(0xFF7A8C6E),
        iconPath: 'assets/icons/ic_check_circle.svg',
      ),
    ];
  }

  static List<Order> orders(List<api.VendorOrderSummary> rows) {
    return [
      for (final row in rows)
        Order(
          id: row.orderItemId.toString(),
          shopOrderId: row.isCustomizationRequest ? 0 : row.orderId,
          orderNumber: row.orderNumber,
          productName: row.productName,
          productSvgIconPath: 'assets/icons/ic_chair.svg',
          quantity: row.quantity,
          date: row.placedAt,
          status: mapOrderStatus(row),
          customerName: row.customerName,
          requestMeta: row.requestMeta,
        ),
    ];
  }

  static OrderStatus mapOrderStatus(api.VendorOrderSummary row) {
    if (row.isCustomizationRequest) return OrderStatus.customRequest;
    return switch (row.status) {
      api.OrderStatus.pending || api.OrderStatus.confirmed => OrderStatus.pending,
      api.OrderStatus.shipped || api.OrderStatus.delivered => OrderStatus.shipped,
      api.OrderStatus.cancelled => OrderStatus.pending,
    };
  }

  static List<TopProductStat> topProducts(
    List<api.VendorProductStat> products,
    double maxRevenue,
  ) {
    if (products.isEmpty) return const [];

    final peak = maxRevenue > 0 ? maxRevenue : products.first.revenue;

    return [
      for (var i = 0; i < products.length; i++)
        TopProductStat(
          name: products[i].name,
          iconPath: 'assets/icons/ic_sofa.svg',
          revenue: _formatRevenue(products[i].revenue),
          progressFraction:
              peak > 0 ? (products[i].revenue / peak).clamp(0.0, 1.0) : 0,
          barColor: _barColors[i % _barColors.length],
        ),
    ];
  }

  static String _formatRevenue(double amount) {
    if (amount >= 1000) {
      return 'NPR ${(amount / 1000).toStringAsFixed(1)}k';
    }
    return 'NPR ${amount.toInt()}';
  }
}
