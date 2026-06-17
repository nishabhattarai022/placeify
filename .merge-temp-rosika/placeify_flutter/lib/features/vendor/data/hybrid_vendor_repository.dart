import '../domain/enums/delivery_stage.dart';
import '../domain/models/delivery_update.dart';
import '../domain/models/vendor_notification.dart';
import '../domain/models/vendor_order.dart';
import '../domain/models/vendor_payout.dart';
import '../domain/models/vendor_profile.dart';
import '../domain/models/vendor_stats.dart';
import '../domain/repositories/vendor_repository.dart';
import 'mock_vendor_repository.dart';
import 'serverpod_vendor_order_repository.dart';

/// Uses Serverpod for order actions and mock data for profile/payouts until wired.
class HybridVendorRepository implements VendorRepository {
  HybridVendorRepository({
    MockVendorRepository? mockRepository,
    ServerpodVendorOrderRepository? orderRepository,
  })  : _mock = mockRepository ?? MockVendorRepository(),
        _orders = orderRepository ?? const ServerpodVendorOrderRepository();

  final MockVendorRepository _mock;
  final ServerpodVendorOrderRepository _orders;

  @override
  Future<VendorProfile?> getProfile(String vendorId) =>
      _mock.getProfile(vendorId);

  @override
  Future<VendorProfile> updateProfile(VendorProfile profile) =>
      _mock.updateProfile(profile);

  @override
  Future<VendorStats> getStats(String vendorId) => _mock.getStats(vendorId);

  @override
  Future<List<VendorOrder>> getOrders(String vendorId, {int limit = 20}) =>
      _orders.getOrders(vendorId, limit: limit);

  @override
  Future<VendorOrder?> getOrder(String vendorId, String orderId) =>
      _orders.getOrder(vendorId, orderId);

  @override
  Future<VendorOrder> acceptOrder(String vendorId, String orderId) =>
      _orders.acceptOrder(vendorId, orderId);

  @override
  Future<VendorOrder> rejectOrder(
    String vendorId,
    String orderId, {
    required String reason,
  }) =>
      _orders.rejectOrder(vendorId, orderId, reason: reason);

  @override
  Future<List<DeliveryUpdate>> getDeliveryUpdates(String orderId) =>
      _orders.getDeliveryUpdates(orderId);

  @override
  Future<DeliveryUpdate> submitDeliveryUpdate(
    String vendorId,
    String orderId, {
    required DeliveryStage stage,
    String? note,
    String? photoProofPath,
  }) =>
      _orders.submitDeliveryUpdate(
        vendorId,
        orderId,
        stage: stage,
        note: note,
        photoProofPath: photoProofPath,
      );

  @override
  Future<List<VendorNotification>> getNotifications(String vendorId) =>
      _mock.getNotifications(vendorId);

  @override
  Future<List<VendorPayout>> getPayouts(String vendorId) =>
      _mock.getPayouts(vendorId);
}
