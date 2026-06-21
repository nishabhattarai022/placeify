import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum PaymentStatus {
  pending,
  paid,
  partial,
  refunded,
  failed,
}

extension PaymentStatusX on PaymentStatus {
  /// Vendor cannot change payment after it is marked fully received.
  bool get isFullyPaid => this == PaymentStatus.paid;
}
