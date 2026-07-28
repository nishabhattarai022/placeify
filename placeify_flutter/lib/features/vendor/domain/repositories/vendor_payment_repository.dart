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
    this.todayRevenue = 0,
    this.monthlyRevenue = 0,
    this.refundAmount = 0,
    this.refundCount = 0,
    this.successfulPaymentCount = 0,
    this.codPaymentCount = 0,
    this.esewaPaymentCount = 0,
    this.averageOrderValue = 0,
    this.pendingRefundCount = 0,
  });

  final double totalEarned;
  final int pendingPaymentCount;
  final List<PaymentUpdate> paymentHistory;
  final double todayRevenue;
  final double monthlyRevenue;
  final double refundAmount;
  final int refundCount;
  final int successfulPaymentCount;
  final int codPaymentCount;
  final int esewaPaymentCount;
  final double averageOrderValue;
  final int pendingRefundCount;

  double get netEarnings => totalEarned - refundAmount;
}

class VendorPaymentException implements Exception {
  VendorPaymentException(this.message);

  final String message;

  @override
  String toString() => message;
}
