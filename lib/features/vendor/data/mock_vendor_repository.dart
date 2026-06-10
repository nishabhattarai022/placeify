import 'package:placeify/features/vendor/data/config/vendor_mock_config.dart';
import 'package:placeify/features/vendor/domain/models/delivery_update.dart';
import 'package:placeify/features/vendor/domain/models/vendor_notification.dart';
import 'package:placeify/features/vendor/domain/models/vendor_order.dart';
import 'package:placeify/features/vendor/domain/models/vendor_payout.dart';
import 'package:placeify/features/vendor/domain/models/vendor_profile.dart';
import 'package:placeify/features/vendor/domain/models/vendor_stats.dart';
import 'package:placeify/features/vendor/domain/repositories/vendor_repository.dart';

class MockVendorRepository implements VendorRepository {
  const MockVendorRepository();

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
