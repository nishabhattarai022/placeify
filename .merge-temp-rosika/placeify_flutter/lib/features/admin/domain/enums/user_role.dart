import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum UserRole {
  customer,
  vendor,
  admin,
}
