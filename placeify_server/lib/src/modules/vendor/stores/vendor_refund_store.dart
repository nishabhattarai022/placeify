import 'package:serverpod/serverpod.dart' hide Order;

import '../../../generated/protocol.dart';
import '../../../shared/placeify_exception.dart';
import '../../../shared/session_service.dart';
import '../../notification/order_notification_service.dart';
import '../../refund/refund_repository.dart';
import 'vendor_access_guard.dart';

/// Vendor-scoped refund review for orders containing the seller's items.
class VendorRefundStore {
  VendorRefundStore({VendorAccessGuard? access})
    : _access = access ?? VendorAccessGuard();

  final VendorAccessGuard _access;

  Future<List<RefundRequestSummary>> listPending(Session session) async {
    final vendor = await _access.requireOwnedVendor(session);
    return _listPendingForVendor(session, vendor.id!);
  }

  Future<int> countPending(Session session, UuidValue vendorId) async {
    final pending = await _listPendingForVendor(session, vendorId);
    return pending.length;
  }

  Future<RefundRequestSummary> approve(Session session, int refundId) async {
    final vendor = await _access.requireOwnedVendor(session);
    return _resolve(
      session,
      refundId: refundId,
      vendorId: vendor.id!,
      approve: true,
    );
  }

  Future<RefundRequestSummary> reject(
    Session session,
    int refundId, {
    String? reason,
  }) async {
    final vendor = await _access.requireOwnedVendor(session);
    return _resolve(
      session,
      refundId: refundId,
      vendorId: vendor.id!,
      approve: false,
      reason: reason,
    );
  }

  Future<List<RefundRequestSummary>> _listPendingForVendor(
    Session session,
    UuidValue vendorId,
  ) async {
    final orderIds = await _orderIdsForVendor(session, vendorId);
    if (orderIds.isEmpty) return const [];

    final rows = await RefundRequest.db.find(
      session,
      where: (row) =>
          row.status.equals(RequestStatus.pending) |
          row.status.equals(RequestStatus.inProgress),
      orderBy: (row) => row.createdAt,
      orderDescending: true,
    );

    final summaries = <RefundRequestSummary>[];
    for (final row in rows) {
      if (row.id == null || !orderIds.contains(row.orderId)) continue;
      summaries.add(await RefundStore.toSummary(session, row));
    }
    return summaries;
  }

  Future<RefundRequestSummary> _resolve(
    Session session, {
    required int refundId,
    required UuidValue vendorId,
    required bool approve,
    String? reason,
  }) async {
    final user = await SessionService.requireUser(session);
    final row = await RefundRequest.db.findById(session, refundId);
    if (row == null) {
      throw PlaceifyException(
        message: 'Refund request not found.',
        code: 'NOT_FOUND',
      );
    }

    final orderIds = await _orderIdsForVendor(session, vendorId);
    if (!orderIds.contains(row.orderId)) {
      throw PlaceifyException(
        message: 'Refund request not found.',
        code: 'NOT_FOUND',
      );
    }

    if (row.status != RequestStatus.pending &&
        row.status != RequestStatus.inProgress) {
      throw PlaceifyException(
        message: 'This refund request has already been resolved.',
        code: 'INVALID_STATUS',
      );
    }

    final updated = await session.db.transaction((transaction) async {
      if (approve) {
        return RefundStore.applyApprovalSettlement(
          session,
          row: row,
          actorUserId: user.id!,
          transaction: transaction,
        );
      }
      return RefundStore.applyRejection(
        session,
        row: row,
        actorUserId: user.id!,
        reason: reason,
        transaction: transaction,
      );
    });

    await OrderNotificationService.notifyRefundDecision(
      session,
      refund: updated,
      approved: approve,
      reason: reason ?? updated.rejectionReason,
      completed: approve && updated.status == RequestStatus.completed,
    );

    return RefundStore.toSummary(session, updated);
  }

  Future<Set<int>> _orderIdsForVendor(
    Session session,
    UuidValue vendorId,
  ) async {
    final items = await OrderItem.db.find(
      session,
      where: (row) => row.vendorId.equals(vendorId),
    );
    return items.map((item) => item.orderId).toSet();
  }
}
