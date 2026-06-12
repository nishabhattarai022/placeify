import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:placeify/features/admin/domain/enums/application_decision.dart';
import 'package:placeify/features/admin/domain/enums/audit_action.dart';

part 'admin_audit_log_entry.freezed.dart';
part 'admin_audit_log_entry.g.dart';

/// Discriminated audit action — application decisions or vendor lifecycle changes.
@Freezed(unionKey: 'kind', unionValueCase: FreezedUnionCase.snake)
sealed class AdminAuditAction with _$AdminAuditAction {
  const factory AdminAuditAction.application({
    required ApplicationDecision decision,
  }) = ApplicationAuditAction;

  const factory AdminAuditAction.vendor({
    required AuditAction action,
  }) = VendorAuditAction;

  factory AdminAuditAction.fromJson(Map<String, dynamic> json) =>
      _$AdminAuditActionFromJson(json);
}

/// Immutable audit trail entry for admin actions on users and applications.
@freezed
abstract class AdminAuditLogEntry with _$AdminAuditLogEntry {
  const factory AdminAuditLogEntry({
    required String id,
    required AdminAuditAction action,
    required String actorAdminId,
    required String targetUserId,
    required DateTime timestamp,
    String? note,
  }) = _AdminAuditLogEntry;

  factory AdminAuditLogEntry.fromJson(Map<String, dynamic> json) =>
      _$AdminAuditLogEntryFromJson(json);
}
