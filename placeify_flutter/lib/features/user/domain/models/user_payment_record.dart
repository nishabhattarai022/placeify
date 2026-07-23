import '../../../vendor/domain/enums/payment_status.dart';

/// UI model for a customer payment ledger row.
class UserPaymentRecord {
  const UserPaymentRecord({
    required this.orderId,
    required this.orderNumber,
    required this.vendorName,
    required this.amount,
    required this.paymentMethodLabel,
    required this.status,
    required this.statusLabel,
    this.thumbnailUrl,
    this.deliveryFee,
    this.discount,
    this.refundStatusLabel,
    this.refundAmount,
    this.refundReason,
    this.refundDate,
    this.transactionId,
    this.orderDate,
    this.paymentDate,
    this.orderStatus,
  });

  final String orderId;
  final String orderNumber;
  final String vendorName;
  final double amount;
  final String paymentMethodLabel;
  final PaymentStatus status;
  final String statusLabel;
  final String? thumbnailUrl;
  final double? deliveryFee;
  final double? discount;
  final String? refundStatusLabel;
  final double? refundAmount;
  final String? refundReason;
  final DateTime? refundDate;
  final String? transactionId;
  final DateTime? orderDate;
  final DateTime? paymentDate;
  final String? orderStatus;
}
