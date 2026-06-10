import 'package:placeify/features/vendor/data/config/vendor_mock_config.dart';
import 'package:placeify/features/vendor/domain/enums/order_status.dart';
import 'package:placeify/features/vendor/domain/models/delivery_update.dart';
import 'package:placeify/features/vendor/domain/models/vendor_notification.dart';
import 'package:placeify/features/vendor/domain/models/vendor_order.dart';
import 'package:placeify/features/vendor/domain/models/vendor_payout.dart';
import 'package:placeify/features/vendor/domain/models/vendor_profile.dart';
import 'package:placeify/features/vendor/domain/models/vendor_stats.dart';
import 'package:placeify/features/vendor/domain/repositories/vendor_repository.dart';

class VendorOrderActionException implements Exception {
  VendorOrderActionException(this.message);

  final String message;
}

class MockVendorRepository implements VendorRepository {
  MockVendorRepository();

  /// When true, [acceptOrder] and [rejectOrder] throw after the network delay.
  bool simulateOrderActionError = false;

  /// Legacy dashboard static data — retained for backward compatibility.
  static const revenue = VendorMockConfig.revenue;

  static const metrics = VendorMockConfig.metrics;

  static final orders = VendorMockConfig.legacyOrders;

  static const topProducts = VendorMockConfig.topProducts;

  static const barHeights = VendorMockConfig.revenueSeries;

  @override
  Future<VendorProfile?> getProfile(String vendorId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return VendorMockConfig.profileFor(vendorId);
  }

  @override
  Future<VendorStats> getStats(String vendorId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return VendorMockConfig.statsFor(vendorId);
  }

  @override
  Future<List<VendorOrder>> getOrders(String vendorId, {int limit = 20}) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return VendorMockConfig.ordersFor(vendorId, limit: limit);
  }

  @override
  Future<VendorOrder?> getOrder(String vendorId, String orderId) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return VendorMockConfig.orderById(vendorId, orderId);
  }

  @override
  Future<VendorOrder> acceptOrder(String vendorId, String orderId) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));

    if (simulateOrderActionError) {
      throw VendorOrderActionException(
        'Could not accept order. Check your connection and try again.',
      );
    }

    final order = VendorMockConfig.orderById(vendorId, orderId);
    if (order == null) {
      throw VendorOrderActionException('Order not found.');
    }
    if (order.status != OrderStatus.pending) {
      throw VendorOrderActionException('Only pending orders can be accepted.');
    }

    final updated =
        VendorMockConfig.updateOrderStatus(orderId, OrderStatus.accepted);
    if (updated == null) {
      throw VendorOrderActionException('Order not found.');
    }
    return updated;
  }

  @override
  Future<VendorOrder> rejectOrder(
    String vendorId,
    String orderId, {
    required String reason,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));

    if (simulateOrderActionError) {
      throw VendorOrderActionException(
        'Could not reject order. Check your connection and try again.',
      );
    }

    if (reason.trim().isEmpty) {
      throw VendorOrderActionException('A rejection reason is required.');
    }

    final order = VendorMockConfig.orderById(vendorId, orderId);
    if (order == null) {
      throw VendorOrderActionException('Order not found.');
    }
    if (order.status != OrderStatus.pending) {
      throw VendorOrderActionException('Only pending orders can be rejected.');
    }

    final updated =
        VendorMockConfig.updateOrderStatus(orderId, OrderStatus.rejected);
    if (updated == null) {
      throw VendorOrderActionException('Order not found.');
    }
    return updated;
  }

  @override
  Future<List<DeliveryUpdate>> getDeliveryUpdates(String orderId) async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    return VendorMockConfig.deliveryUpdatesFor(orderId);
  }

  @override
  Future<List<VendorNotification>> getNotifications(String vendorId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return VendorMockConfig.notificationsFor(vendorId);
  }

  @override
  Future<List<VendorPayout>> getPayouts(String vendorId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return VendorMockConfig.payoutsFor(vendorId);
  }
}
