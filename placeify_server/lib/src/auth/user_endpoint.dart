import 'package:serverpod/serverpod.dart' hide Order;

import '../generated/protocol.dart';
import '../modules/user/user_service.dart';
import 'placeify_endpoint.dart';

/// Profile and dashboard APIs for authenticated customers.
class UserEndpoint extends PlaceifyAuthenticatedEndpoint {
  final _service = UserService();

  Future<User?> getCurrentUser(Session session) {
    return _service.getCurrentUser(session);
  }

  Future<User> updateProfile(
    Session session,
    String name, {
    String? phone,
    String? address,
  }) {
    return _service.updateProfile(
      session,
      name,
      phone: phone,
      address: address,
    );
  }

  Future<User> becomeVendor(Session session) {
    return _service.becomeVendor(session);
  }

  Future<User> becomeConsumer(Session session) {
    return _service.becomeConsumer(session);
  }

  Future<UserDashboard> getDashboard(Session session) {
    return _service.getDashboard(session);
  }

  Future<User> ensureDemoAdmin(Session session) {
    return _service.ensureDemoAdmin(session);
  }

  Future<List<UserOrderSummary>> listMyOrders(
    Session session, {
    int limit = 20,
    int offset = 0,
    OrderStatus? status,
  }) async {
    final user = await requirePlaceifyUser(session);

    final orders = await Order.db.find(
      session,
      where: (order) {
        var expression = order.userId.equals(user.id!);
        if (status != null) {
          expression = expression & order.status.equals(status);
        }
        return expression;
      },
      orderBy: (order) => order.placedAt,
      orderDescending: true,
      limit: limit,
      offset: offset,
    );

    if (orders.isEmpty) return [];

    final orderIds = orders.map((order) => order.id).whereType<int>().toSet();

    final allItems = await OrderItem.db.find(
      session,
      where: (item) => item.orderId.inSet(orderIds),
      include: OrderItem.include(product: Product.include()),
    );

    final itemsByOrderId = <int, List<OrderItem>>{};
    for (final item in allItems) {
      itemsByOrderId.putIfAbsent(item.orderId, () => []).add(item);
    }

    final allUpdates = await OrderDeliveryUpdate.db.find(
      session,
      where: (row) => row.orderId.inSet(orderIds),
      orderBy: (row) => row.createdAt,
      orderDescending: true,
    );

    final latestUpdateByOrderId = <int, OrderDeliveryUpdate>{};
    for (final update in allUpdates) {
      latestUpdateByOrderId.putIfAbsent(update.orderId, () => update);
    }

    final summaries = <UserOrderSummary>[];
    for (final order in orders) {
      final orderId = order.id;
      if (orderId == null) continue;

      final items = itemsByOrderId[orderId] ?? const <OrderItem>[];

      final primaryName = items.isEmpty
          ? null
          : items.first.product?.name ?? 'Order item';
      final totalQuantity =
          items.fold<int>(0, (sum, item) => sum + item.quantity);
      final displayName = primaryName == null
          ? null
          : totalQuantity > 1
              ? '$primaryName × $totalQuantity'
              : primaryName;

      final latestUpdate = latestUpdateByOrderId[orderId];

      summaries.add(
        UserOrderSummary(
          id: orderId,
          orderNumber: orderId.toString().padLeft(5, '0'),
          status: order.status,
          totalAmount: order.totalAmount,
          placedAt: order.placedAt,
          itemCount: totalQuantity,
          primaryProductName: displayName,
          latestDeliveryStage: latestUpdate?.stage,
          latestDeliveryNote: latestUpdate?.note,
        ),
      );
    }

    return summaries;
  }

  Future<UserOrderDetail> getMyOrder(Session session, int orderId) {
    return _service.getMyOrder(session, orderId);
  }

  Future<UserOrderDetail> cancelMyOrder(
    Session session,
    int orderId,
    String reason,
  ) {
    return _service.cancelMyOrder(session, orderId, reason);
  }

  Future<UserOrderPaymentSummary> getMyOrderPayment(
    Session session,
    int orderId,
  ) {
    return _service.getMyOrderPayment(session, orderId);
  }

  Future<UserOrderPaymentSummary> completePayment(
    Session session,
    int orderId,
  ) {
    return _service.completePayment(session, orderId);
  }

  Future<List<UserArSessionSummary>> listMyArSessions(
    Session session, {
    int limit = 20,
    int offset = 0,
  }) async {
    final user = await requirePlaceifyUser(session);

    final sessions = await ARSession.db.find(
      session,
      where: (row) => row.userId.equals(user.id!),
      include: ARSession.include(product: Product.include()),
      orderBy: (row) => row.startedAt,
      orderDescending: true,
      limit: limit,
      offset: offset,
    );

    return [
      for (final row in sessions)
        if (row.id != null)
          UserArSessionSummary(
            id: row.id!,
            productId: row.productId,
            productName: row.product?.name ?? 'Product',
            startedAt: row.startedAt,
            deviceInfo: row.deviceInfo,
            snapshotUrl: row.snapshotUrl,
          ),
    ];
  }
}
