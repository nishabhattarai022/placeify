import 'package:placeify_flutter/features/auth/domain/models/app_user.dart';
import 'package:placeify_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify_flutter/features/vendor/data/config/vendor_mock_config.dart';
import 'package:placeify_flutter/features/vendor/data/vendor_dashboard_mapper.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_dashboard_data.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_order.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_dashboard_provider.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_profile_provider.dart';
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
    try {
      final user = ref.watch(currentUserProvider).value;
      if (user == null || !user.canLoadVendorPortal) {
        return VendorDashboardData.empty;
      }

      if (user.isVendorAccount) {
        return await _loadFromServer(user);
      }

      return await _loadFromMock(user);
    } catch (_) {
      return VendorDashboardData.empty;
    }
  }

  Future<VendorDashboardData> _loadFromServer(AppUser user) async {
    try {
      final commerceRepo = ref.read(vendorCommerceRepositoryProvider);
      final dashboard = await commerceRepo.getDashboard();
      final vendorId = user.vendorId ?? user.id;
      return VendorDashboardMapper.fromServer(
        dashboard,
        vendorId: vendorId,
      );
    } catch (_) {
      return await _loadFromMock(user);
    }
  }

  Future<VendorDashboardData> _loadFromMock(AppUser user) async {
    final vendorId = user.vendorId ?? user.id;
    final repo = ref.watch(vendorRepositoryProvider);

    final stats = await repo.getStats(vendorId);
    List<VendorOrder> recentOrders = const [];
    try {
      recentOrders = await repo.getOrders(vendorId, limit: 5);
    } catch (_) {
      recentOrders = const [];
    }

    return VendorDashboardData(
      stats: stats,
      revenueSeries: VendorMockConfig.revenueSeriesFor(vendorId),
      recentOrders: recentOrders,
      topProducts: VendorMockConfig.topProductsFor(vendorId),
    );
  }
}
