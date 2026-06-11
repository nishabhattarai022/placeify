import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum OrderStatus {
  pending,
  accepted,
  rejected,
  processing,
  shipped,
  delivered,
  cancelled,
}
