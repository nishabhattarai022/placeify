import 'package:placeify_client/placeify_client.dart' hide Order;
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../core/config/placeify_server_client.dart';
import '../../profile/data/serverpod_refund_repository.dart';
import '../domain/enums/consumer_order_status.dart';
import '../domain/models/order.dart';
import '../domain/repositories/order_repository.dart';
import 'order_api_mapper.dart';

class OrderRepositoryException implements Exception {
  OrderRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Live customer orders via [client.user] and refunds for return requests.
class ServerpodOrderRepository implements OrderRepository {
  const ServerpodOrderRepository({ServerpodRefundRepository? refunds})
      : _refunds = refunds ?? const ServerpodRefundRepository();

  final ServerpodRefundRepository _refunds;

  @override
  Future<List<Order>> getOrders(String userId) async {
    _requireAuthenticated();
    try {
      final summaries = await client.user.listMyOrders(limit: 100, offset: 0);
      return [
        for (final summary in summaries)
          OrderApiMapper.fromSummary(summary, userId: userId),
      ];
    } catch (error) {
      throw OrderRepositoryException(_mapError(error));
    }
  }

  @override
  Future<Order?> getOrderById(String userId, String orderId) async {
    _requireAuthenticated();
    final parsedId = int.tryParse(orderId);
    if (parsedId == null) return null;

    try {
      final detail = await client.user.getMyOrder(parsedId);
      return OrderApiMapper.fromDetail(detail, userId: userId);
    } catch (error) {
      if (error is PlaceifyException && error.code == 'NOT_FOUND') {
        return null;
      }
      throw OrderRepositoryException(_mapError(error));
    }
  }

  @override
  Future<Order> cancelOrder(
    String userId,
    String orderId,
    String reason,
  ) async {
    _requireAuthenticated();
    final parsedId = int.tryParse(orderId);
    if (parsedId == null) {
      throw OrderRepositoryException('Invalid order id.');
    }

    try {
      final detail = await client.user.cancelMyOrder(parsedId, reason.trim());
      return OrderApiMapper.fromDetail(detail, userId: userId);
    } catch (error) {
      throw OrderRepositoryException(_mapError(error));
    }
  }

  @override
  Future<Order> requestReturn(
    String userId,
    String orderId,
    String reason,
  ) async {
    _requireAuthenticated();
    final parsedId = int.tryParse(orderId);
    if (parsedId == null) {
      throw OrderRepositoryException('Invalid order id.');
    }

    try {
      await _refunds.createRefund(orderId: parsedId, reason: reason);
      final detail = await client.user.getMyOrder(parsedId);
      final order = OrderApiMapper.fromDetail(detail, userId: userId);
      return order.copyWith(
        status: ConsumerOrderStatus.returnRequested,
        returnReason: reason.trim(),
      );
    } catch (error) {
      throw OrderRepositoryException(_mapError(error));
    }
  }

  void _requireAuthenticated() {
    if (!client.auth.isAuthenticated) {
      throw OrderRepositoryException('Sign in to view your orders.');
    }
  }

  String _mapError(Object error) {
    if (error is OrderRepositoryException) return error.message;
    if (error is RefundRepositoryException) return error.message;
    if (error is PlaceifyException) return error.message;
    return error.toString();
  }
}
