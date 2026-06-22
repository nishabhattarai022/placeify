import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum VendorStatus {
  none,
  pending,
  approved,
  suspended,
}
