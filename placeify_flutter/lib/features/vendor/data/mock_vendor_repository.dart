import 'package:placeify_flutter/features/vendor/data/config/vendor_mock_config.dart';
import 'package:placeify_flutter/features/vendor/data/vendor_profile_provisioner.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/delivery_stage.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/order_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/delivery_update.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_notification.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_order.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_payout.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_profile.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_stats.dart';
import 'package:placeify_flutter/features/vendor/domain/repositories/vendor_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendorOrderActionException implements Exception {
  VendorOrderActionException(this.message);

  final String message;
}

class MockVendorRepository implements VendorRepository {
  MockVendorRepository(this._prefs);

  final SharedPreferences _prefs;

  /// When true, [acceptOrder] and [rejectOrder] throw after the network delay.
  bool simulateOrderActionError = false;

  static const revenue = VendorMockConfig.revenue;

  static const metrics = VendorMockConfig.metrics;

  static final orders = VendorMockConfig.orders;

  static const topProducts = VendorMockConfig.topProducts;

  static const barHeights = VendorMockConfig.revenueSeries;

  @override
  Future<VendorProfile?> getProfile(String vendorId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    VendorProfileProvisioner.ensureFromRegistration(vendorId, _prefs);
    return VendorMockConfig.profileFor(vendorId);
  }

  /// When true, [updateProfile] throws after the network delay.
  bool simulateProfileUpdateError = false;

  @override
  Future<VendorProfile> updateProfile(VendorProfile profile) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));

    if (simulateProfileUpdateError) {
      throw Exception('Could not save profile. Check your connection and try again.');
    }

    final updated = VendorMockConfig.updateProfile(profile);
    if (updated == null) {
      throw Exception('Vendor profile not found.');
    }
    return updated;
  }

  @override
  Future<VendorStats> getStats(String vendorId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return VendorMockConfig.statsFor(vendorId);
  }

  @override
  Future<List<VendorOrder>> getOrders(String vendorId, {int limit = 20}) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    VendorMockConfig.ensureDefaultOrders();
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
  Future<DeliveryUpdate> submitDeliveryUpdate(
    String vendorId,
    String orderId, {
    required DeliveryStage stage,
    String? note,
    String? photoProofPath,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final order = VendorMockConfig.orderById(vendorId, orderId);
    if (order == null) {
      throw VendorOrderActionException('Order not found.');
    }

    if (order.status == OrderStatus.pending) {
      throw VendorOrderActionException(
        'Accept the order before posting delivery updates.',
      );
    }

    if (order.status == OrderStatus.rejected ||
        order.status == OrderStatus.cancelled) {
      throw VendorOrderActionException(
        'Delivery updates are not available for this order.',
      );
    }

    if (order.status == OrderStatus.delivered) {
      throw VendorOrderActionException('This order is already delivered.');
    }

    final expected = VendorMockConfig.nextDeliveryStage(orderId);
    if (expected == null) {
      throw VendorOrderActionException('All delivery stages are complete.');
    }

    if (stage != expected) {
      throw VendorOrderActionException(
        'Updates must advance one stage at a time. Next stage: ${_stageLabel(expected)}.',
      );
    }

    final update = VendorMockConfig.submitDeliveryUpdate(
      vendorId: vendorId,
      orderId: orderId,
      stage: stage,
      note: note,
      photoProofPath: photoProofPath,
    );

    if (update == null) {
      throw VendorOrderActionException('Could not save delivery update.');
    }

    return update;
  }

  static String _stageLabel(DeliveryStage stage) {
    return switch (stage) {
      DeliveryStage.orderPlaced => 'Order Placed',
      DeliveryStage.packed => 'Packed',
      DeliveryStage.shipped => 'Shipped',
      DeliveryStage.outForDelivery => 'Out for Delivery',
      DeliveryStage.delivered => 'Delivered',
    };
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
