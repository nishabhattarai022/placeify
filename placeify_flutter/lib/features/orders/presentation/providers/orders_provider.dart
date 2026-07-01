import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify_flutter/core/widgets/toast_overlay.dart';
import 'package:placeify_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify_flutter/features/cart/presentation/cart_actions.dart';
import 'package:placeify_flutter/features/orders/data/mock_order_repository.dart';
import 'package:placeify_flutter/features/orders/data/serverpod_order_repository.dart';
import 'package:placeify_flutter/features/orders/domain/constants/order_strings.dart';
import 'package:placeify_flutter/features/orders/domain/enums/consumer_order_status.dart';
import 'package:placeify_flutter/features/orders/domain/enums/order_list_filter.dart';
import 'package:placeify_flutter/features/orders/domain/models/order.dart';
import 'package:placeify_flutter/features/orders/domain/order_count_display.dart';
import 'package:placeify_flutter/features/orders/domain/repositories/order_repository.dart';
import 'package:placeify_client/placeify_client.dart' hide Order;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../../core/config/placeify_server_client.dart';
import '../../../profile/presentation/providers/profile_dashboard_provider.dart';

part 'orders_provider.g.dart';

@Riverpod(keepAlive: true)
OrderRepository orderRepository(Ref ref) {
  ref.watch(currentUserProvider);
  if (client.auth.isAuthenticated) {
    return const ServerpodOrderRepository();
  }
  return MockOrderRepository();
}

@riverpod
Future<String> ordersUserId(Ref ref) async {
  final user = await ref.watch(currentUserProvider.future);
  return user?.id ?? MockOrderRepository.demoUserId;
}

@riverpod
class Orders extends _$Orders {
  @override
  Future<List<Order>> build() => _load();

  Future<void> loadOrders() => refresh();

  Future<void> refresh() async {
    state = await AsyncValue.guard(_load);
  }

  Future<List<Order>> _load() async {
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
      ref.invalidate(profileDashboardProvider);
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
    bool openCart = false,
  }) async {
    final orders = state.value;
    if (orders == null) return false;

    Order? order;
    for (final candidate in orders) {
      if (candidate.id == orderId) {
        order = candidate;
        break;
      }
    }
    if (order == null) return false;

    reorderToCart(ref, order.items);

    if (context != null && context.mounted) {
      PlaceifyToast.show(context, OrderStrings.reorderSuccess);
      if (openCart) {
        context.pushNamed('cart');
      }
    }
    return true;
  }
}

@riverpod
UserOrderCounts? userOrderCounts(Ref ref) {
  return ref.watch(profileDashboardProvider).maybeWhen(
    data: (dashboard) => dashboard?.orderCounts,
    orElse: () => null,
  );
}

@riverpod
int ordersCount(Ref ref) {
  final counts = ref.watch(userOrderCountsProvider);
  if (counts != null) return counts.activeOrders;

  final orders = ref.watch(ordersProvider);
  return orders.maybeWhen(
    data: (list) => list.where((order) => !order.isCancelled).length,
    orElse: () => 0,
  );
}

@riverpod
int orderListTitleCount(Ref ref, OrderListFilter filter) {
  final counts = ref.watch(userOrderCountsProvider);
  if (counts != null) {
    return orderListTitleCountFor(filter: filter, counts: counts);
  }

  final orders = ref.watch(ordersProvider);
  return orders.maybeWhen(
    data: (list) => list.where((order) => order.matchesListFilter(filter)).length,
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
  final orders = await ref.watch(ordersProvider.future);
  for (final order in orders) {
    if (order.id == orderId) return order;
  }

  final userId = await ref.watch(ordersUserIdProvider.future);
  final repo = ref.watch(orderRepositoryProvider);
  return repo.getOrderById(userId, orderId);
}

@riverpod
List<Order> filteredOrders(Ref ref, OrderListFilter filter) {
  final orders = ref.watch(ordersProvider);
  return orders.maybeWhen(
    data: (list) =>
        list.where((o) => o.matchesListFilter(filter)).toList(growable: false),
    orElse: () => const <Order>[],
  );
}
