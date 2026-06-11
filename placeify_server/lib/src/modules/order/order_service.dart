import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import 'order_repository.dart';

class OrderService {
  OrderService({OrderStore? repository})
      : _repository = repository ?? OrderStore();

  final OrderStore _repository;

  Future<OrderPage> listMyOrders(
    Session session, {
    PaginationInput? pagination,
    OrderStatus? status,
  }) {
    return _repository.listOrders(
      session,
      pagination: pagination,
      status: status,
    );
  }

  Future<Order?> getOrder(Session session, int orderId) {
    return _repository.getOrder(session, orderId);
  }
}
