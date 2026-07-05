import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';

/// Persists immutable admin action audit records.
abstract final class AdminActionAuditLog {
  static Future<AdminAuditLog> record(
    Session session, {
    required UuidValue actorAdminId,
    required AdminActionType actionType,
    UuidValue? targetUserId,
    UuidValue? targetVendorId,
    int? targetProductId,
    UuidValue? targetComplaintId,
    int? targetPayoutId,
    int? targetRefundId,
    String? previousStatus,
    String? newStatus,
    String? reason,
    String? note,
    Transaction? transaction,
  }) {
    return AdminAuditLog.db.insertRow(
      session,
      AdminAuditLog(
        actorAdminId: actorAdminId,
        actionType: actionType,
        targetUserId: targetUserId,
        targetVendorId: targetVendorId,
        targetProductId: targetProductId,
        targetComplaintId: targetComplaintId,
        targetPayoutId: targetPayoutId,
        targetRefundId: targetRefundId,
        previousStatus: previousStatus,
        newStatus: newStatus,
        reason: reason,
        note: note,
      ),
      transaction: transaction,
    );
  }

  static AdminAuditLogSummary toSummary(AdminAuditLog entry) {
    return AdminAuditLogSummary(
      id: entry.id!.toString(),
      actionType: entry.actionType.name,
      actorAdminId: entry.actorAdminId!,
      targetUserId: entry.targetUserId ?? entry.actorAdminId!,
      timestamp: entry.createdAt,
      note: entry.note ?? entry.reason,
    );
  }
}
