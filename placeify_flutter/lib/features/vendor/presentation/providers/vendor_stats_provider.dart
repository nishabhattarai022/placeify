import 'dart:async';

import 'package:placeify_client/placeify_client.dart' hide Order;
import 'package:placeify_flutter/core/config/placeify_server_client.dart';
import 'package:placeify_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify_flutter/features/vendor/data/config/vendor_mock_config.dart';
import 'package:placeify_flutter/features/vendor/data/vendor_dashboard_mapper.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_dashboard_data.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_refunds_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_stats_provider.g.dart';

@riverpod
class VendorStats extends _$VendorStats {
  StreamSubscription<InAppNotificationSummary>? _subscription;

  @override
  Future<VendorDashboardData> build() {
    ref.onDispose(() => _subscription?.cancel());
    unawaited(_attachRealtimeListener());
    return _load();
  }

  Future<void> _attachRealtimeListener() async {
    if (_subscription != null) return;
    _subscription = inAppNotificationEvents.listen((notification) {
      if (!shouldRefreshVendorDashboardForNotification(notification)) return;
      unawaited(refresh(silent: true));
    });
  }

  Future<void> refresh({bool silent = false}) async {
    if (!silent) {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(_load);
  }

  Future<VendorDashboardData> _load() async {
    final user = await ref.watch(currentUserProvider.future);
    if (user?.vendorStatus != VendorStatus.approved || user?.vendorId == null) {
      return VendorDashboardData.empty;
    }

    final vendorId = user!.vendorId!;

    final dashboard = await client.vendor.getDashboard();
    final pendingRefunds =
        await ref.read(vendorRefundRepositoryProvider).listPending();

    return VendorDashboardData(
      stats: VendorDashboardMapper.statsFromDashboard(dashboard).copyWith(
        pendingRefundCount: dashboard.pendingRefundCount,
      ),
      revenueSeries: VendorMockConfig.revenueSeriesFor(vendorId),
      recentOrders: VendorDashboardMapper.recentOrdersFromDashboard(
        dashboard,
        vendorId: vendorId,
      ),
      topProducts: VendorDashboardMapper.topProductsFromDashboard(dashboard),
      pendingRefunds: pendingRefunds,
    );
  }
}
