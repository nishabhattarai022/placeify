import 'package:placeify_client/placeify_client.dart' as api;

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../domain/models/vendor_metric.dart';
import '../domain/models/vendor_order.dart';
import '../domain/models/vendor_stats.dart';
import 'vendor_order_mapper.dart';

/// Maps [api.VendorDashboard] into vendor dashboard UI models.
abstract final class VendorDashboardMapper {
  static VendorStats statsFromDashboard(api.VendorDashboard dashboard) {
    return VendorStats(
      revenue: dashboard.revenue,
      orderCount: dashboard.orderCount,
      productCount: dashboard.productCount,
      viewCount: 0,
      conversionRate: dashboard.productCount == 0
          ? 0
          : dashboard.orderCount / dashboard.productCount,
      periodLabel: 'All time',
      averageRating: dashboard.shop.rating,
    );
  }

  static List<VendorOrder> recentOrdersFromDashboard(
    api.VendorDashboard dashboard, {
    required String vendorId,
  }) {
    return [
      for (final summary in dashboard.recentOrders)
        if (!summary.isCustomizationRequest)
          VendorOrder(
            id: summary.orderId.toString(),
            orderNumber: summary.orderNumber,
            vendorId: vendorId,
            productId: 'p${summary.orderItemId}',
            productName: summary.productName,
            quantity: summary.quantity,
            totalAmount: summary.lineTotal,
            status: VendorOrderMapper.mapOrderStatus(summary.status),
            customerName: summary.customerName ?? 'Customer',
            orderedAt: summary.placedAt,
          ),
    ];
  }

  static List<TopProductStat> topProductsFromDashboard(
    api.VendorDashboard dashboard,
  ) {
    if (dashboard.topProducts.isEmpty) return const [];

    final maxRevenue = dashboard.topProducts
        .map((product) => product.revenue)
        .reduce((a, b) => a > b ? a : b);

    const colors = [
      AppColors.sage,
      AppColors.accent,
      AppColors.coral,
    ];

    return [
      for (var i = 0; i < dashboard.topProducts.length; i++)
        TopProductStat(
          name: dashboard.topProducts[i].name,
          iconPath: 'assets/icons/ic_chair.svg',
          revenue: Formatters.currencyDecimal(dashboard.topProducts[i].revenue),
          progressFraction: maxRevenue == 0
              ? 0
              : dashboard.topProducts[i].revenue / maxRevenue,
          barColor: colors[i % colors.length],
        ),
    ];
  }

  /// Builds a six-month revenue trend from order line totals when the API
  /// does not expose a dedicated time-series field.
  static List<double> revenueSeriesFromDashboard(api.VendorDashboard dashboard) {
    final now = DateTime.now();
    final buckets = List<double>.filled(6, 0);

    for (final summary in dashboard.recentOrders) {
      if (summary.isCustomizationRequest) continue;
      final monthsAgo = _monthsBetween(summary.placedAt, now);
      if (monthsAgo < 0 || monthsAgo >= buckets.length) continue;
      buckets[buckets.length - 1 - monthsAgo] += summary.lineTotal;
    }

    if (buckets.every((value) => value == 0) && dashboard.revenue > 0) {
      // Spread total revenue across recent months for chart visibility.
      final share = dashboard.revenue / buckets.length;
      return List<double>.filled(buckets.length, share);
    }

    return buckets;
  }

  static int _monthsBetween(DateTime from, DateTime to) {
    return (to.year - from.year) * 12 + (to.month - from.month);
  }
}
