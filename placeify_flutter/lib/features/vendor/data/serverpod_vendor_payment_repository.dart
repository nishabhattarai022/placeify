import 'package:placeify_flutter/features/vendor/domain/enums/payment_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/payment_update.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_payout.dart';
import 'package:placeify_flutter/features/vendor/domain/repositories/vendor_payment_repository.dart';

/// Placeholder until payout APIs exist on the server.
class ServerpodVendorPaymentRepository implements VendorPaymentRepository {
  const ServerpodVendorPaymentRepository();

  @override
  Future<List<VendorPayout>> getPayouts(String vendorId) async => const [];

  @override
  Future<double> getPendingBalance(String vendorId) async => 0;

  @override
  Future<double> getTotalEarned(String vendorId) async => 0;

  @override
  Future<List<PaymentUpdate>> getPaymentUpdates(String orderId) async =>
      const [];

  @override
  Future<PaymentUpdate> updatePaymentStatus({
    required String vendorId,
    required String orderId,
    required PaymentStatus status,
    required String note,
  }) {
    throw VendorPaymentException('Vendor payouts are not available yet.');
  }

  @override
  Future<VendorPayout> requestPayout(String vendorId) {
    throw VendorPaymentException('Vendor payouts are not available yet.');
  }
}
