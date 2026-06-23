import 'package:json_annotation/json_annotation.dart';

/// Consumer payment state for an order (distinct from vendor [PaymentStatus]).
@JsonEnum()
enum PaymentStatus {
  pending,
  received,
  confirmed,
  failed,
  refunded,
}

extension PaymentStatusX on PaymentStatus {
  String get label => switch (this) {
        PaymentStatus.pending => 'Pending',
        PaymentStatus.received => 'Payment received',
        PaymentStatus.confirmed => 'Payment confirmed',
        PaymentStatus.failed => 'Failed',
        PaymentStatus.refunded => 'Refunded',
      };
}
