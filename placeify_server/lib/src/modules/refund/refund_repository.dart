import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../../shared/pagination_helper.dart';
import '../../shared/placeify_exception.dart';
import '../../shared/session_service.dart';

class RefundStore {
  Future<int> countForUser(Session session, UuidValue userId) {
    return RefundRequest.db.count(
      session,
      where: (row) => row.userId.equals(userId),
    );
  }

  Future<List<RefundRequestSummary>> listForUser(
    Session session, {
    PaginationInput? pagination,
  }) async {
    final user = await SessionService.requireUser(session);
    final paging = PaginationHelper.resolve(pagination);

    final rows = await RefundRequest.db.find(
      session,
      where: (row) => row.userId.equals(user.id!),
      orderBy: (row) => row.createdAt,
      orderDescending: true,
      limit: paging.pageSize,
      offset: paging.offset,
    );

    return [
      for (final row in rows)
        if (row.id != null)
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

  Future<RefundRequestSummary> getForUser(Session session, int refundId) async {
    final user = await SessionService.requireUser(session);
    final row = await RefundRequest.db.findById(session, refundId);
    if (row == null || row.userId != user.id) {
      throw PlaceifyException('Refund request not found.', code: 'NOT_FOUND');
    }

    return RefundRequestSummary(
      id: row.id!,
      orderId: row.orderId,
      orderNumber: row.orderId.toString().padLeft(5, '0'),
      status: row.status,
      refundAmount: row.refundAmount,
      reason: row.reason,
      createdAt: row.createdAt,
    );
  }

  Future<RefundRequestSummary> createForUser(
    Session session,
    int orderId,
    String reason,
  ) async {
    final user = await SessionService.requireUser(session);
    final trimmedReason = reason.trim();
    if (trimmedReason.isEmpty) {
      throw PlaceifyException(
        'A reason is required for refund requests.',
        code: 'INVALID_REASON',
      );
    }

    final order = await Order.db.findById(session, orderId);
    if (order == null || order.userId != user.id) {
      throw PlaceifyException('Order not found.', code: 'ORDER_NOT_FOUND');
    }

    if (order.status == OrderStatus.cancelled) {
      throw PlaceifyException(
        'Cancelled orders cannot be refunded.',
        code: 'ORDER_CANCELLED',
      );
    }

    final existingPending = await RefundRequest.db.findFirstRow(
      session,
      where: (row) =>
          row.orderId.equals(orderId) &
          row.userId.equals(user.id!) &
          row.status.equals(RequestStatus.pending),
    );
    if (existingPending != null) {
      throw PlaceifyException(
        'A pending refund request already exists for this order.',
        code: 'REFUND_EXISTS',
      );
    }

    final created = await RefundRequest.db.insertRow(
      session,
      RefundRequest(
        userId: user.id!,
        orderId: orderId,
        reason: trimmedReason,
        refundAmount: order.totalAmount,
        status: RequestStatus.pending,
      ),
    );

    return RefundRequestSummary(
      id: created.id!,
      orderId: created.orderId,
      orderNumber: created.orderId.toString().padLeft(5, '0'),
      status: created.status,
      refundAmount: created.refundAmount,
      reason: created.reason,
      createdAt: created.createdAt,
    );
  }
}
