import 'package:placeify_flutter/features/orders/domain/enums/payment_status.dart';

/// Vendor-recorded payment status change shown on customer orders.
class OrderPaymentEvent {
  const OrderPaymentEvent({
    required this.status,
    required this.timestamp,
    this.note,
  });

  final PaymentStatus status;
  final DateTime timestamp;
  final String? note;
}
