import 'package:placeify/features/vendor/domain/models/vendor_notification.dart';
import 'package:placeify/features/vendor/domain/models/vendor_order.dart';
import 'package:placeify/features/vendor/domain/models/vendor_payout.dart';
import 'package:placeify/features/vendor/domain/models/vendor_profile.dart';
import 'package:placeify/features/vendor/domain/models/vendor_stats.dart';

abstract interface class VendorRepository {
  Future<VendorProfile?> getProfile(String vendorId);

  Future<VendorStats> getStats(String vendorId);

  Future<List<VendorOrder>> getOrders(String vendorId, {int limit = 20});

  Future<List<VendorNotification>> getNotifications(String vendorId);

  Future<List<VendorPayout>> getPayouts(String vendorId);
}
