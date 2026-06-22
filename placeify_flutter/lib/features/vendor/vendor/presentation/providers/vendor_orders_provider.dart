import 'package:placeify_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify_flutter/features/vendor/data/mock_vendor_repository.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/order_status.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_order.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_order_detail_provider.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_profile_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_orders_provider.g.dart';

@riverpod
class VendorOrders extends _$VendorOrders {
  @override
  Future<List<VendorOrder>> build() => _load();

  Future<void> refresh() async {
    state = await AsyncValue.guard(_load);
  }

  Future<List<VendorOrder>> _load() async {
    final user = await ref.watch(currentUserProvider.future);
    if (user?.vendorStatus != VendorStatus.approved || user?.vendorId == null) {
      return [];
    }

    final repo = ref.watch(vendorRepositoryProvider);
    return repo.getOrders(user!.vendorId!);
  }

  Future<String?> acceptOrder(String orderId) async {
    final previous = state;
    final orders = state.value;
    if (orders == null) return 'Orders are still loading.';

    final index = orders.indexWhere((order) => order.id == orderId);
    if (index < 0) return 'Order not found.';

    final current = orders[index];
    if (current.status != OrderStatus.pending) {
      return 'Only pending orders can be accepted.';
    }

    final optimistic = current.copyWith(status: OrderStatus.accepted);
    state = AsyncData([
      ...orders.sublist(0, index),
      optimistic,
      ...orders.sublist(index + 1),
    ]);

    try {
      final user = await ref.read(currentUserProvider.future);
      final vendorId = user?.vendorId;
      if (vendorId == null) {
        state = previous;
        return 'Vendor account not found.';
      }

      final repo = ref.read(vendorRepositoryProvider);
      final updated = await repo.acceptOrder(vendorId, orderId);

      final synced = [...state.value!];
      synced[index] = updated;
      state = AsyncData(synced);
      ref.invalidate(vendorOrderDetailProvider(orderId));
      return null;
    } on VendorOrderActionException catch (e) {
      state = previous;
      return e.message;
    } catch (_) {
      state = previous;
      return 'Could not accept order. Try again.';
    }
  }

  Future<String?> rejectOrder(String orderId, {required String reason}) async {
    if (reason.trim().isEmpty) {
      return 'Select a rejection reason.';
    }

    final previous = state;
    final orders = state.value;
    if (orders == null) return 'Orders are still loading.';

    final index = orders.indexWhere((order) => order.id == orderId);
    if (index < 0) return 'Order not found.';

    final current = orders[index];
    if (current.status != OrderStatus.pending) {
      return 'Only pending orders can be rejected.';
    }

    final optimistic = current.copyWith(status: OrderStatus.rejected);
    state = AsyncData([
      ...orders.sublist(0, index),
      optimistic,
      ...orders.sublist(index + 1),
    ]);

    try {
      final user = await ref.read(currentUserProvider.future);
      final vendorId = user?.vendorId;
      if (vendorId == null) {
        state = previous;
        return 'Vendor account not found.';
      }

      final repo = ref.read(vendorRepositoryProvider);
      final updated = await repo.rejectOrder(
        vendorId,
        orderId,
        reason: reason.trim(),
      );

      final synced = [...state.value!];
      synced[index] = updated;
      state = AsyncData(synced);
      ref.invalidate(vendorOrderDetailProvider(orderId));
      return null;
    } on VendorOrderActionException catch (e) {
      state = previous;
      return e.message;
    } catch (_) {
      state = previous;
      return 'Could not reject order. Try again.';
    }
  }
}
