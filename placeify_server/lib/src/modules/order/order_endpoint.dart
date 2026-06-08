import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import 'order_service.dart';

/// Order history for authenticated customers.
class OrderEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  final _service = OrderService();

  Future<OrderPage> listMyOrders(
    Session session, {
    PaginationInput? pagination,
    OrderStatus? status,
  }) {
    return _service.listMyOrders(
      session,
      pagination: pagination,
      status: status,
    );
  }

  Future<Order?> getOrder(Session session, int orderId) {
    return _service.getOrder(session, orderId);
  }
}
