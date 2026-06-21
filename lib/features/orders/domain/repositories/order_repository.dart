import 'package:placeify/features/orders/domain/models/order.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrders(String userId);

  Future<Order?> getOrderById(String userId, String orderId);

  Future<Order> cancelOrder(String userId, String orderId, String reason);

  Future<Order> requestReturn(String userId, String orderId, String reason);
}
