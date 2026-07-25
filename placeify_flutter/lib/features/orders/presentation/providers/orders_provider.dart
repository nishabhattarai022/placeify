import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify_client/placeify_client.dart' hide Order;
import 'package:placeify_flutter/core/config/placeify_server_client.dart';
import 'package:placeify_flutter/core/debug/agent_debug_log.dart';
import 'package:placeify_flutter/core/widgets/toast_overlay.dart';
import 'package:placeify_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify_flutter/features/cart/presentation/cart_actions.dart';
import 'package:placeify_flutter/features/orders/data/serverpod_order_repository.dart';
import 'package:placeify_flutter/features/orders/domain/constants/order_strings.dart';
import 'package:placeify_flutter/features/orders/domain/enums/consumer_order_status.dart';
import 'package:placeify_flutter/features/orders/domain/enums/order_list_filter.dart';
import 'package:placeify_flutter/features/orders/domain/models/order.dart';
import 'package:placeify_flutter/features/orders/domain/repositories/order_repository.dart';
import 'package:placeify_flutter/features/profile/presentation/providers/profile_dashboard_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

part 'orders_provider.g.dart';

@Riverpod(keepAlive: true)
OrderRepository orderRepository(Ref ref) {
  return const ServerpodOrderRepository();
}

@riverpod
Future<String> ordersUserId(Ref ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user?.id == null) {
    throw StateError('Sign in to view your orders.');
  }
  return user!.id;
}

@riverpod
class Orders extends _$Orders {
  StreamSubscription<InAppNotificationSummary>? _subscription;

  @override
  Future<List<Order>> build() {
    ref.onDispose(() => _subscription?.cancel());
    if (client.auth.isAuthenticated) {
      unawaited(_attachRealtimeListener());
    }
    return _load();
  }

  Future<void> _attachRealtimeListener() async {
    if (_subscription != null) return;
    _subscription = inAppNotificationEvents.listen((notification) {
      if (!shouldRefreshOrdersForNotification(notification)) return;
      unawaited(refresh(silent: true));
      final orderId = notification.referenceId?.toString();
      if (orderId != null) {
        ref.invalidate(orderByIdProvider(orderId));
      }
    });
  }

  Future<void> loadOrders() => refresh();

  Future<void> refresh({bool silent = false}) async {
    if (!client.auth.isAuthenticated) {
      state = const AsyncData([]);
      return;
    }
    if (!silent) {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(_load);
  }

  Future<List<Order>> _load() async {
    if (!client.auth.isAuthenticated) return [];
    final userId = await ref.watch(ordersUserIdProvider.future);
    final repo = ref.watch(orderRepositoryProvider);
    return repo.getOrders(userId);
  }

  Future<String?> cancelOrder(String orderId, String reason) async {
    if (reason.trim().isEmpty) {
      return 'Select a cancellation reason.';
    }

    final previous = state;
    final orders = state.value;
    if (orders == null) return 'Orders are still loading.';

    final index = orders.indexWhere((order) => order.id == orderId);
    if (index < 0) return 'Order not found.';

    final current = orders[index];
    if (!current.isCancellable) {
      return 'This order can no longer be cancelled.';
    }

    final optimistic = current.copyWith(
      status: ConsumerOrderStatus.cancelled,
      cancellationReason: reason.trim(),
    );
    state = AsyncData([
      ...orders.sublist(0, index),
      optimistic,
      ...orders.sublist(index + 1),
    ]);

    try {
      final userId = await ref.read(ordersUserIdProvider.future);
      final repo = ref.read(orderRepositoryProvider);
      final updated = await repo.cancelOrder(userId, orderId, reason.trim());

      final synced = [...state.value!];
      synced[index] = updated;
      state = AsyncData(synced);
      ref.invalidate(orderByIdProvider(orderId));
      return null;
    } on StateError catch (e) {
      state = previous;
      return e.message;
    } catch (_) {
      state = previous;
      return OrderStrings.cancelFailed;
    }
  }

  Future<String?> requestReturn(String orderId, String reason) async {
    if (reason.trim().isEmpty) {
      return 'Select a return reason.';
    }

    final previous = state;
    final orders = state.value;
    if (orders == null) return 'Orders are still loading.';

    final index = orders.indexWhere((order) => order.id == orderId);
    if (index < 0) return 'Order not found.';

    final current = orders[index];
    if (!current.isDelivered) {
      return 'Only delivered orders can be returned.';
    }

    final optimistic = current.copyWith(
      status: ConsumerOrderStatus.returnRequested,
      returnReason: reason.trim(),
    );
    state = AsyncData([
      ...orders.sublist(0, index),
      optimistic,
      ...orders.sublist(index + 1),
    ]);

    try {
      final userId = await ref.read(ordersUserIdProvider.future);
      final repo = ref.read(orderRepositoryProvider);
      final updated = await repo.requestReturn(userId, orderId, reason.trim());

      final synced = [...state.value!];
      synced[index] = updated;
      state = AsyncData(synced);
      ref.invalidate(orderByIdProvider(orderId));
      ref.invalidate(profileDashboardProvider);
      return null;
    } on StateError catch (e) {
      state = previous;
      return e.message;
    } catch (_) {
      state = previous;
      return OrderStrings.returnFailed;
    }
  }

  Future<bool> reorder(
    String orderId, {
    BuildContext? context,
    bool openCart = true,
  }) async {
    if (!client.auth.isAuthenticated) {
      if (context != null && context.mounted) {
        PlaceifyToast.show(context, 'Sign in to reorder.');
      }
      return false;
    }

    try {
      final userId = await ref.read(ordersUserIdProvider.future);
      final detail = await ref.read(orderRepositoryProvider).getOrderById(
            userId,
            orderId,
          );
      if (detail == null || detail.items.isEmpty) {
        if (context != null && context.mounted) {
          PlaceifyToast.show(context, OrderStrings.reorderNoItems);
        }
        return false;
      }

      // #region agent log
      agentDebugLog(
        location: 'orders_provider.dart:reorder',
        message: 'Reorder loaded order detail',
        hypothesisId: 'O1',
        data: {
          'orderId': orderId,
          'itemCount': detail.items.length,
          'productIds': detail.items
              .map((i) => i.productId)
              .take(8)
              .toList(),
        },
      );
      // #endregion

      final result = await reorderToCart(ref, detail.items);

      // #region agent log
      agentDebugLog(
        location: 'orders_provider.dart:reorder',
        message: 'Reorder cart result',
        hypothesisId: 'O2',
        data: {
          'addedCount': result.addedCount,
          'skippedCount': result.skipped.length,
          'skipped': result.skipped.take(5).toList(),
          'openCart': openCart,
        },
      );
      // #endregion

      if (context != null && context.mounted) {
        if (!result.hasAdditions && result.hasSkips) {
          PlaceifyToast.show(
            context,
            OrderStrings.reorderAllSkipped(result.skipped),
          );
          return false;
        }

        final message = result.hasSkips
            ? OrderStrings.reorderPartialSuccess(
                result.addedCount,
                result.skipped,
              )
            : OrderStrings.reorderSuccess;
        PlaceifyToast.show(context, message);
        if (openCart) {
          context.pushNamed('cart');
        }
      }
      return result.hasAdditions;
    } catch (_) {
      if (context != null && context.mounted) {
        PlaceifyToast.show(context, OrderStrings.reorderFailed);
      }
      return false;
    }
  }
}

@riverpod
int ordersCount(Ref ref) {
  final orders = ref.watch(ordersProvider);
  return orders.maybeWhen(
    data: (list) => list.length,
    orElse: () => 0,
  );
}

@riverpod
int inTransitOrderCount(Ref ref) {
  final orders = ref.watch(ordersProvider);
  return orders.maybeWhen(
    data: (list) =>
        list.where((o) => o.status == ConsumerOrderStatus.inTransit).length,
    orElse: () => 0,
  );
}

@riverpod
List<Order> activeOrders(Ref ref) {
  final orders = ref.watch(ordersProvider);
  return orders.maybeWhen(
    data: (list) => list.where((o) => o.isActive).toList(),
    orElse: () => const [],
  );
}

@riverpod
List<Order> deliveredOrders(Ref ref) {
  final orders = ref.watch(ordersProvider);
  return orders.maybeWhen(
    data: (list) => list.where((o) => o.isDelivered).toList(),
    orElse: () => const [],
  );
}

@riverpod
List<Order> cancelledOrders(Ref ref) {
  final orders = ref.watch(ordersProvider);
  return orders.maybeWhen(
    data: (list) => list.where((o) => o.isCancelled).toList(),
    orElse: () => const [],
  );
}

@riverpod
List<Order> returnOrders(Ref ref) {
  final orders = ref.watch(ordersProvider);
  return orders.maybeWhen(
    data: (list) => list.where((o) => o.isReturn).toList(),
    orElse: () => const [],
  );
}

@riverpod
Future<Order?> orderById(Ref ref, String orderId) async {
  if (!client.auth.isAuthenticated) return null;

  final userId = await ref.watch(ordersUserIdProvider.future);
  final repo = ref.watch(orderRepositoryProvider);
  return repo.getOrderById(userId, orderId);
}

@riverpod
List<Order> filteredOrders(Ref ref, OrderListFilter filter) {
  final orders = ref.watch(ordersProvider);
  return orders.maybeWhen(
    data: (list) => list.where((o) => o.matchesListFilter(filter)).toList(),
    orElse: () => const [],
  );
}
