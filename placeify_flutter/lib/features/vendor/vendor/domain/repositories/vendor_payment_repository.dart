import 'package:placeify_flutter/features/vendor/domain/enums/payment_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/payment_update.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_payout.dart';

abstract interface class VendorPaymentRepository {
  Future<List<VendorPayout>> getPayouts(String vendorId);

  Future<double> getPendingBalance(String vendorId);

  Future<double> getTotalEarned(String vendorId);

  Future<List<PaymentUpdate>> getPaymentUpdates(String orderId);

  Future<PaymentUpdate> updatePaymentStatus({
    required String vendorId,
    required String orderId,
    required PaymentStatus status,
    required String note,
  });

  Future<VendorPayout> requestPayout(String vendorId);
}

class VendorPaymentException implements Exception {
  VendorPaymentException(this.message);

  final String message;

  @override
  String toString() => message;
}
