import '../../../core/config/placeify_server_client.dart';
import 'serverpod_vendor_order_repository.dart';
import 'serverpod_vendor_profile_repository.dart';
import 'vendor_notification_mapper.dart';

import '../domain/enums/delivery_stage.dart';
import '../domain/models/delivery_update.dart';
import '../domain/models/vendor_notification.dart';
import '../domain/models/vendor_order.dart';
import '../domain/models/vendor_payout.dart';
import '../domain/models/vendor_profile.dart';
import '../domain/models/vendor_stats.dart';
import '../domain/repositories/vendor_repository.dart';

/// Serverpod-only vendor operations. Payouts return empty until wired.
class ServerpodVendorRepository implements VendorRepository {
  const ServerpodVendorRepository({
    ServerpodVendorOrderRepository? orderRepository,
    ServerpodVendorProfileRepository? profileRepository,
  })  : _orders = orderRepository ?? const ServerpodVendorOrderRepository(),
        _profile = profileRepository ?? const ServerpodVendorProfileRepository();

  final ServerpodVendorOrderRepository _orders;
  final ServerpodVendorProfileRepository _profile;

  @override
  Future<VendorProfile?> getProfile(String vendorId) =>
      _profile.getProfile(vendorId);

  @override
  Future<VendorProfile> updateProfile(VendorProfile profile) =>
      _profile.updateProfile(profile);

  @override
  Future<VendorStats> getStats(String vendorId) => _profile.getStats(vendorId);

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
  Future<List<VendorNotification>> getNotifications(String vendorId) async {
    try {
      final summaries = await client.vendor.listNotifications(limit: 50);
      return [
        for (final summary in summaries)
          VendorNotificationMapper.fromSummary(summary),
      ];
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<void> markNotificationRead(String notificationId) async {
    final id = int.tryParse(notificationId);
    if (id == null) return;
    try {
      await client.vendor.markNotificationRead(id);
    } catch (_) {}
  }

  @override
  Future<void> markAllNotificationsRead() async {
    try {
      await client.vendor.markAllNotificationsRead();
    } catch (_) {}
  }

  @override
  Future<List<VendorPayout>> getPayouts(String vendorId) async => const [];
}
