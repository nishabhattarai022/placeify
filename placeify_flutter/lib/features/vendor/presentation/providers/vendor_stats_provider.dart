import 'package:placeify_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify_flutter/features/vendor/data/vendor_dashboard_mapper.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_dashboard_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/placeify_server_client.dart';

part 'vendor_stats_provider.g.dart';

@riverpod
class VendorStats extends _$VendorStats {
  @override
  Future<VendorDashboardData> build() => _load();

  Future<void> refresh() async {
    state = await AsyncValue.guard(_load);
  }

  Future<VendorDashboardData> _load() async {
    final user = await ref.watch(currentUserProvider.future);
    if (user?.vendorStatus != VendorStatus.approved || user?.vendorId == null) {
      return VendorDashboardData.empty;
    }

    final vendorId = user!.vendorId!;
    final dashboard = await client.vendor.getDashboard();

    return VendorDashboardData(
      stats: VendorDashboardMapper.statsFromDashboard(dashboard),
      revenueSeries: VendorDashboardMapper.revenueSeriesFromDashboard(dashboard),
      recentOrders: VendorDashboardMapper.recentOrdersFromDashboard(
        dashboard,
        vendorId: vendorId,
      ),
      topProducts: VendorDashboardMapper.topProductsFromDashboard(dashboard),
    );
  }
}
