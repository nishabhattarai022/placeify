import 'package:placeify_flutter/features/vendor/domain/enums/payment_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/payment_update.dart';

abstract interface class VendorPaymentRepository {
  /// Single overview call: totals, pending count, and completed payment history.
  Future<VendorPaymentsOverviewData> getPaymentsOverview(String vendorId);

  Future<List<PaymentUpdate>> getPaymentUpdates(String orderId);

  Future<PaymentUpdate> updatePaymentStatus({
    required String vendorId,
    required String orderId,
    required PaymentStatus status,
    required String note,
  });
}

class VendorPaymentsOverviewData {
  const VendorPaymentsOverviewData({
    required this.totalEarned,
    required this.pendingPaymentCount,
    required this.paymentHistory,
  });

  final double totalEarned;
  final int pendingPaymentCount;
  final List<PaymentUpdate> paymentHistory;
}

class VendorPaymentException implements Exception {
  VendorPaymentException(this.message);

  final String message;

  @override
  String toString() => message;
}
