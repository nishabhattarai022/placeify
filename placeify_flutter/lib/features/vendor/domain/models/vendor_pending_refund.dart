/// Pending refund request shown on the vendor dashboard.
class VendorPendingRefund {
  const VendorPendingRefund({
    required this.id,
    required this.orderId,
    required this.orderNumber,
    required this.refundAmount,
    required this.reason,
    required this.createdAt,
  });

  final int id;
  final int orderId;
  final String orderNumber;
  final double refundAmount;
  final String reason;
  final DateTime createdAt;
}
