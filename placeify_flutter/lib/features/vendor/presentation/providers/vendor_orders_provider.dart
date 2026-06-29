import 'dart:async';

import 'package:placeify_client/placeify_client.dart' hide Order, OrderStatus;
import 'package:placeify_flutter/core/config/placeify_server_client.dart';
import 'package:placeify_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify_flutter/features/vendor/data/mock_vendor_repository.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/order_status.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_order.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_order_detail_provider.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_profile_provider.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_stats_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_orders_provider.g.dart';

class VendorOrderActionResult {
  const VendorOrderActionResult._({this.error, this.message});

  final String? error;
  final String? message;

  bool get isSuccess => error == null;

  static VendorOrderActionResult success(String message) =>
      VendorOrderActionResult._(message: message);

  static VendorOrderActionResult failure(String error) =>
      VendorOrderActionResult._(error: error);
}

@riverpod
class VendorOrders extends _$VendorOrders {
  StreamSubscription<InAppNotificationSummary>? _subscription;

  @override
  Future<List<VendorOrder>> build() {
    ref.onDispose(() => _subscription?.cancel());
    unawaited(_attachRealtimeListener());
    return _load();
  }

  Future<void> _attachRealtimeListener() async {
    if (_subscription != null) return;
    _subscription = inAppNotificationEvents.listen((notification) {
      if (!shouldRefreshOrdersForNotification(notification)) return;
      unawaited(refresh(silent: true));
      final orderId = notification.referenceId?.toString();
      if (orderId != null) {
        ref.invalidate(vendorOrderDetailProvider(orderId));
      }
      ref.invalidate(vendorStatsProvider);
    });
  }

  Future<void> refresh({bool silent = false}) async {
    if (!silent) {
      state = const AsyncLoading();
    }
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

  Future<VendorOrderActionResult> acceptOrder(String orderId) async {
    final previous = state;

    try {
      final user = await ref.read(currentUserProvider.future);
      final vendorId = user?.vendorId;
      if (vendorId == null) {
        return VendorOrderActionResult.failure('Vendor account not found.');
      }

      final orders = state.value;
      final index = orders?.indexWhere((order) => order.id == orderId) ?? -1;
      if (orders != null && index >= 0) {
        final current = orders[index];
        if (current.status != OrderStatus.pending) {
          return VendorOrderActionResult.failure(
            'Only pending orders can be accepted.',
          );
        }
        final optimistic = current.copyWith(status: OrderStatus.accepted);
        state = AsyncData([
          ...orders.sublist(0, index),
          optimistic,
          ...orders.sublist(index + 1),
        ]);
      }

      final repo = ref.read(vendorRepositoryProvider);
      final updated = await repo.acceptOrder(vendorId, orderId);

      final synced = state.value;
      if (synced != null && index >= 0) {
        final next = [...synced];
        next[index] = updated;
        state = AsyncData(next);
      } else if (synced != null) {
        state = AsyncData([updated, ...synced]);
      } else {
        state = AsyncData([updated]);
      }

      ref.invalidate(vendorOrderDetailProvider(orderId));
      ref.invalidate(vendorStatsProvider);
      return VendorOrderActionResult.success('Order accepted ✓');
    } on VendorOrderActionException catch (e) {
      state = previous;
      return VendorOrderActionResult.failure(e.message);
    } catch (_) {
      state = previous;
      return VendorOrderActionResult.failure('Could not accept order. Try again.');
    }
  }

  Future<VendorOrderActionResult> rejectOrder(
    String orderId, {
    required String reason,
  }) async {
    if (reason.trim().isEmpty) {
      return VendorOrderActionResult.failure('Select a rejection reason.');
    }

    final previous = state;

    try {
      final user = await ref.read(currentUserProvider.future);
      final vendorId = user?.vendorId;
      if (vendorId == null) {
        return VendorOrderActionResult.failure('Vendor account not found.');
      }

      final orders = state.value;
      final index = orders?.indexWhere((order) => order.id == orderId) ?? -1;
      if (orders != null && index >= 0) {
        final current = orders[index];
        if (current.status != OrderStatus.pending) {
          return VendorOrderActionResult.failure(
            'Only pending orders can be rejected.',
          );
        }
        final optimistic = current.copyWith(status: OrderStatus.rejected);
        state = AsyncData([
          ...orders.sublist(0, index),
          optimistic,
          ...orders.sublist(index + 1),
        ]);
      }

      final repo = ref.read(vendorRepositoryProvider);
      final updated = await repo.rejectOrder(
        vendorId,
        orderId,
        reason: reason.trim(),
      );

      final synced = state.value;
      if (synced != null && index >= 0) {
        final next = [...synced];
        next[index] = updated;
        state = AsyncData(next);
      } else if (synced != null) {
        state = AsyncData([updated, ...synced]);
      } else {
        state = AsyncData([updated]);
      }

      ref.invalidate(vendorOrderDetailProvider(orderId));
      ref.invalidate(vendorStatsProvider);
      return VendorOrderActionResult.success('Order rejected');
    } on VendorOrderActionException catch (e) {
      state = previous;
      return VendorOrderActionResult.failure(e.message);
    } catch (_) {
      state = previous;
      return VendorOrderActionResult.failure('Could not reject order. Try again.');
    }
  }
}
