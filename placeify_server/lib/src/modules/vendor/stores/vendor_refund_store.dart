import 'package:serverpod/serverpod.dart' hide Order;

import '../../../generated/protocol.dart';
import '../../../shared/placeify_exception.dart';
import '../../../shared/session_service.dart';
import '../../notification/order_notification_service.dart';
import '../../payment/payment_sync.dart';
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
      where: (row) => row.status.equals(RequestStatus.pending),
      orderBy: (row) => row.createdAt,
      orderDescending: true,
    );

    return [
      for (final row in rows)
        if (row.id != null && orderIds.contains(row.orderId))
          RefundRequestSummary(
            id: row.id!,
            orderId: row.orderId,
            orderNumber: row.orderId.toString().padLeft(5, '0'),
            status: row.status,
            refundAmount: row.refundAmount,
            reason: row.reason,
            createdAt: row.createdAt,
          ),
    ];
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
      final resolved = await RefundRequest.db.updateRow(
        session,
        row.copyWith(
          status: approve ? RequestStatus.completed : RequestStatus.rejected,
          updatedAt: DateTime.now(),
        ),
        transaction: transaction,
      );

      if (approve) {
        await PaymentSync.markOrderRefunded(
          session,
          row.orderId,
          transaction: transaction,
          changedByUserId: user.id,
        );
      }

      return resolved;
    });

    await OrderNotificationService.notifyRefundDecision(
      session,
      refund: updated,
      approved: approve,
      reason: reason,
    );

    return RefundRequestSummary(
      id: updated.id!,
      orderId: updated.orderId,
      orderNumber: updated.orderId.toString().padLeft(5, '0'),
      status: updated.status,
      refundAmount: updated.refundAmount,
      reason: updated.reason,
      createdAt: updated.createdAt,
    );
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
