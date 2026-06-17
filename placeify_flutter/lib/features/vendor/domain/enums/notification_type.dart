import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum NotificationType {
  order,
  payment,
  product,
  system,
}
