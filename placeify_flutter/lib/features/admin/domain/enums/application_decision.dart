import 'package:json_annotation/json_annotation.dart';

/// Admin decision on a vendor registration application.
@JsonEnum()
enum ApplicationDecision {
  approved,
  declined,
}
