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

  Future<UserDashboard> getDashboard(Session session) {
    return _service.getDashboard(session);
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

    final summaries = <UserOrderSummary>[];
    for (final order in orders) {
      final orderId = order.id;
      if (orderId == null) continue;

      final items = await OrderItem.db.find(
        session,
        where: (item) => item.orderId.equals(orderId),
        include: OrderItem.include(product: Product.include()),
      );

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

      summaries.add(
        UserOrderSummary(
          id: orderId,
          orderNumber: orderId.toString().padLeft(5, '0'),
          status: order.status,
          totalAmount: order.totalAmount,
          placedAt: order.placedAt,
          itemCount: totalQuantity,
          primaryProductName: displayName,
        ),
      );
    }

    return summaries;
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
