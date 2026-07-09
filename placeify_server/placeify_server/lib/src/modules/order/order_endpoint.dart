import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';

/// Legacy order history endpoint.
///
/// **Deprecated for consumer apps.** Use [UserEndpoint.listMyOrders],
/// [UserEndpoint.getMyOrder], and delivery data on [UserOrderDetail] instead.
/// See `docs/CONSUMER_API_CONTRACT.md`.
class OrderEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Never _deprecated(String method) {
    throw PlaceifyException(
      message:
          'order.$method is deprecated for consumer apps. '
          'Use user.listMyOrders / user.getMyOrder instead. '
          'See docs/CONSUMER_API_CONTRACT.md.',
      code: 'DEPRECATED_ENDPOINT',
    );
  }

  Future<OrderPage> listMyOrders(
    Session session, {
    PaginationInput? pagination,
    OrderStatus? status,
  }) {
    _deprecated('listMyOrders');
  }

  Future<Order?> getOrder(Session session, int orderId) {
    _deprecated('getOrder');
  }

  Future<List<OrderDeliveryUpdate>> listDeliveryUpdates(
    Session session,
    int orderId,
  ) {
    _deprecated('listDeliveryUpdates');
  }
}
