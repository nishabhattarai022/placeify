import 'package:placeify/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify/features/vendor/data/config/vendor_mock_config.dart';
import 'package:placeify/features/vendor/domain/enums/vendor_status.dart';
import 'package:placeify/features/vendor/domain/models/vendor_dashboard_data.dart';
import 'package:placeify/features/vendor/presentation/providers/vendor_profile_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
    final repo = ref.watch(vendorRepositoryProvider);

    final stats = await repo.getStats(vendorId);
    final recentOrders = await repo.getOrders(vendorId, limit: 5);

    return VendorDashboardData(
      stats: stats,
      revenueSeries: VendorMockConfig.revenueSeriesFor(vendorId),
      recentOrders: recentOrders,
      topProducts: VendorMockConfig.topProductsFor(vendorId),
    );
  }
}
