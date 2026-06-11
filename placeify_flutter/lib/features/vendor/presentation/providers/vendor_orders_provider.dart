import 'package:placeify_client/placeify_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../../main.dart' show client;
import 'vendor_dashboard_provider.dart';

part 'vendor_orders_provider.g.dart';

@Riverpod(keepAlive: true)
class VendorShopOrders extends _$VendorShopOrders {
  @override
  Future<List<VendorShopOrder>> build() async {
    if (!client.auth.isAuthenticated) return [];
    final repo = ref.read(vendorRepositoryProvider);
    return repo.listShopOrders();
  }

  Future<void> refresh() async {
    if (!client.auth.isAuthenticated) {
      state = const AsyncData([]);
      return;
    }
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(vendorRepositoryProvider);
      return repo.listShopOrders();
    });
  }
}

@riverpod
Future<VendorShopOrder> vendorShopOrderDetail(
  Ref ref,
  int orderId,
) async {
  if (!client.auth.isAuthenticated) {
    throw StateError('Authentication required');
  }
  final repo = ref.read(vendorRepositoryProvider);
  return repo.getShopOrder(orderId);
}
