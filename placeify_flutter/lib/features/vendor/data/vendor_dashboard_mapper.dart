import 'package:placeify_client/placeify_client.dart' as api;
import 'package:placeify_flutter/core/constants/app_colors.dart';
import 'package:placeify_flutter/core/utils/formatters.dart';
import 'package:placeify_flutter/features/vendor/data/vendor_order_mapper.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_dashboard_data.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_metric.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_order.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_stats.dart';

/// Maps Serverpod [api.VendorDashboard] into the portal UI model.
abstract final class VendorDashboardMapper {
  static VendorDashboardData fromServer(
    api.VendorDashboard dashboard, {
    required String vendorId,
  }) {
    final topProducts = _topProducts(dashboard.topProducts);
    final recentOrders = _recentOrders(dashboard.recentOrders, vendorId);

    return VendorDashboardData(
      stats: VendorStats(
        revenue: dashboard.revenue,
        orderCount: dashboard.orderCount,
        productCount: dashboard.productCount,
        viewCount: 0,
        conversionRate: 0,
        periodLabel: 'Last 30 days',
        averageRating: dashboard.shop.rating,
      ),
      revenueSeries: _revenueSeries(dashboard.revenue),
      recentOrders: recentOrders,
      topProducts: topProducts,
    );
  }

  static List<VendorOrder> _recentOrders(
    List<api.VendorOrderSummary> summaries,
    String vendorId,
  ) {
    return [
      for (final summary in summaries.take(5))
        VendorOrder(
          id: summary.orderId.toString(),
          orderNumber: summary.orderNumber.isEmpty
              ? summary.orderId.toString()
              : summary.orderNumber,
          vendorId: vendorId,
          productId: summary.orderItemId.toString(),
          productName: summary.productName,
          quantity: summary.quantity,
          totalAmount: summary.lineTotal,
          status: VendorOrderMapper.mapOrderStatus(summary.status),
          customerName: summary.customerName ?? 'Customer',
          orderedAt: summary.placedAt,
        ),
    ];
  }

  static List<TopProductStat> _topProducts(List<api.VendorProductStat> stats) {
    if (stats.isEmpty) return const [];

    final maxRevenue = stats
        .map((entry) => entry.revenue)
        .reduce((a, b) => a > b ? a : b);

    const barColors = [
      AppColors.accent,
      AppColors.sage,
      AppColors.bark,
    ];

    return [
      for (var i = 0; i < stats.length && i < 3; i++)
        TopProductStat(
          name: stats[i].name,
          iconPath: 'assets/icons/ic_sofa.svg',
          revenue: Formatters.currency(stats[i].revenue),
          progressFraction:
              maxRevenue > 0 ? stats[i].revenue / maxRevenue : 0,
          barColor: barColors[i % barColors.length],
        ),
    ];
  }

  static List<double> _revenueSeries(double revenue) {
    if (revenue <= 0) {
      return List<double>.filled(7, 0);
    }

    // Simple placeholder sparkline when historical series is not available yet.
    return const [0.38, 0.52, 0.33, 0.68, 0.58, 0.75, 1.0];
  }
}
