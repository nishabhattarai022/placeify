import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../../shared/pagination_helper.dart';
import '../../shared/session_service.dart';

class OrderStore {
  Future<OrderPage> listOrders(
    Session session, {
    PaginationInput? pagination,
    OrderStatus? status,
  }) async {
    final user = await SessionService.requireUser(session);
    final paging = PaginationHelper.resolve(pagination);

    var total = 0;
    final items = await Order.db.find(
      session,
      where: (row) {
        var expression = row.userId.equals(user.id!);
        if (status != null) {
          expression = expression & row.status.equals(status);
        }
        return expression;
      },
      orderBy: (row) => row.placedAt,
      orderDescending: true,
      limit: paging.pageSize,
      offset: paging.offset,
    );

    total = await Order.db.count(
      session,
      where: (row) {
        var expression = row.userId.equals(user.id!);
        if (status != null) {
          expression = expression & row.status.equals(status);
        }
        return expression;
      },
    );

    return OrderPage(
      items: items,
      total: total,
      page: paging.page,
      pageSize: paging.pageSize,
    );
  }

  Future<Order?> getOrder(Session session, int orderId) async {
    final user = await SessionService.requireUser(session);
    final order = await Order.db.findById(session, orderId);
    if (order == null || order.userId != user.id) return null;
    return order;
  }
}
