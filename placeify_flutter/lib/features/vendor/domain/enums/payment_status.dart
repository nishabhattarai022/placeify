import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum PaymentStatus {
  pending,
  paid,
  partial,
  refunded,
  failed,
}
