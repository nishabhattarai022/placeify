import '../../../vendor/domain/enums/payment_status.dart';

/// One row in customer payment transaction history.
class UserPaymentRecord {
  const UserPaymentRecord({
    required this.orderNumber,
    required this.amount,
    required this.paymentMethodLabel,
    required this.status,
    required this.createdAt,
  });

  final String orderNumber;
  final double amount;
  final String paymentMethodLabel;
  final PaymentStatus status;
  final DateTime createdAt;
}
