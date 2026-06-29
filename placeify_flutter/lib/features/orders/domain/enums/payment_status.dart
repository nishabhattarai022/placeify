import 'package:json_annotation/json_annotation.dart';

/// Consumer payment state for an order (distinct from vendor [PaymentStatus]).
@JsonEnum()
enum PaymentStatus {
  pending,
  paid,
  failed,
  refunded,
}

extension PaymentStatusX on PaymentStatus {
  String get label => switch (this) {
    PaymentStatus.pending => 'Pending',
    PaymentStatus.paid => 'Paid',
    PaymentStatus.failed => 'Failed',
    PaymentStatus.refunded => 'Refunded',
  };
}
