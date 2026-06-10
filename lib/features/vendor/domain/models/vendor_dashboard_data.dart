import 'package:placeify/features/vendor/domain/models/vendor_metric.dart';
import 'package:placeify/features/vendor/domain/models/vendor_order.dart';
import 'package:placeify/features/vendor/domain/models/vendor_stats.dart';

/// Aggregated dashboard payload loaded by [vendorStatsProvider].
class VendorDashboardData {
  const VendorDashboardData({
    required this.stats,
    required this.revenueSeries,
    required this.recentOrders,
    required this.topProducts,
  });

  final VendorStats stats;
  final List<double> revenueSeries;
  final List<VendorOrder> recentOrders;
  final List<TopProductStat> topProducts;

  static const empty = VendorDashboardData(
    stats: VendorStats(
      revenue: 0,
      orderCount: 0,
      productCount: 0,
      viewCount: 0,
      conversionRate: 0,
      periodLabel: 'Last 30 days',
    ),
    revenueSeries: [],
    recentOrders: [],
    topProducts: [],
  );
}
