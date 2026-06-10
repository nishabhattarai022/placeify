import 'package:placeify/features/vendor/domain/enums/delivery_stage.dart';
import 'package:placeify/features/vendor/domain/models/delivery_update.dart';
import 'package:placeify/features/vendor/domain/models/vendor_notification.dart';
import 'package:placeify/features/vendor/domain/models/vendor_order.dart';
import 'package:placeify/features/vendor/domain/models/vendor_payout.dart';
import 'package:placeify/features/vendor/domain/models/vendor_profile.dart';
import 'package:placeify/features/vendor/domain/models/vendor_stats.dart';

abstract interface class VendorRepository {
  Future<VendorProfile?> getProfile(String vendorId);

  Future<VendorProfile> updateProfile(VendorProfile profile);

  Future<VendorStats> getStats(String vendorId);

  Future<List<VendorOrder>> getOrders(String vendorId, {int limit = 20});

  Future<VendorOrder?> getOrder(String vendorId, String orderId);

  Future<VendorOrder> acceptOrder(String vendorId, String orderId);

  Future<VendorOrder> rejectOrder(
    String vendorId,
    String orderId, {
    required String reason,
  });

  Future<List<DeliveryUpdate>> getDeliveryUpdates(String orderId);

  Future<DeliveryUpdate> submitDeliveryUpdate(
    String vendorId,
    String orderId, {
    required DeliveryStage stage,
    String? note,
    String? photoProofPath,
  });

  Future<List<VendorNotification>> getNotifications(String vendorId);

  Future<List<VendorPayout>> getPayouts(String vendorId);
}
