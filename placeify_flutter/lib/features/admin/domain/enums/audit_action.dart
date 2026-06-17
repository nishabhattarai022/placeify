import 'package:json_annotation/json_annotation.dart';

/// Admin action on an approved vendor account lifecycle.
@JsonEnum()
enum AuditAction {
  suspended,
  reinstated,
}
