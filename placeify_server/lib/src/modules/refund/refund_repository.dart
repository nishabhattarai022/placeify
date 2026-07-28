import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../../shared/order_display_number.dart';
import '../../shared/pagination_helper.dart';
import '../../shared/placeify_exception.dart';
import '../../shared/refund_destination.dart';
import '../../shared/refund_eligibility.dart';
import '../../shared/session_service.dart';
import '../notification/order_notification_service.dart';
import '../order/order_lifecycle_store.dart';
import '../payment/esewa_refund_service.dart';
import '../payment/payment_sync.dart';

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

    final summaries = <RefundRequestSummary>[];
    for (final row in rows) {
      if (row.id == null) continue;
      summaries.add(await toSummary(session, row));
    }
    return summaries;
  }

  Future<RefundRequestSummary> getForUser(Session session, int refundId) async {
    final user = await SessionService.requireUser(session);
    final row = await RefundRequest.db.findById(session, refundId);
    if (row == null || row.userId != user.id) {
      throw PlaceifyException(
        message: 'Refund request not found.',
        code: 'NOT_FOUND',
      );
    }

    return toSummary(session, row);
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
        message: 'A reason is required for refund requests.',
        code: 'INVALID_REASON',
      );
    }

    final order = await Order.db.findById(session, orderId);
    if (order == null) {
      throw PlaceifyException(
        message: 'Order not found.',
        code: 'ORDER_NOT_FOUND',
      );
    }

    final existingOpen = await RefundRequest.db.findFirstRow(
      session,
      where: (row) =>
          row.orderId.equals(orderId) &
          row.userId.equals(user.id!) &
          (row.status.equals(RequestStatus.pending) |
              row.status.equals(RequestStatus.inProgress)),
    );

    final deliveredUpdate = await OrderDeliveryUpdate.db.findFirstRow(
      session,
      where: (row) =>
          row.orderId.equals(orderId) &
          row.stage.equals(DeliveryStage.delivered),
      orderBy: (row) => row.createdAt,
      orderDescending: true,
    );

    RefundEligibility.ensureEligible(
      user: user,
      order: order,
      existingOpen: existingOpen,
      deliveredAt: deliveredUpdate?.createdAt,
    );

    final created = await session.db.transaction((transaction) async {
      final refund = await RefundRequest.db.insertRow(
        session,
        RefundRequest(
          userId: user.id!,
          orderId: orderId,
          reason: trimmedReason,
          refundAmount: order.totalAmount,
          status: RequestStatus.pending,
        ),
        transaction: transaction,
      );

      await Order.db.updateRow(
        session,
        order.copyWith(
          status: OrderStatus.returnRequested,
          updatedAt: DateTime.now(),
          version: order.version + 1,
        ),
        transaction: transaction,
      );

      await OrderLifecycleStore.appendHistory(
        session,
        orderId,
        statusType: OrderStatusHistoryType.order,
        previousStatus: order.status.name,
        newStatus: OrderStatus.returnRequested.name,
        changedByUserId: user.id,
        note: 'Refund/return requested: $trimmedReason',
        transaction: transaction,
      );

      return refund;
    });

    try {
      await OrderNotificationService.notifyRefundCreated(
        session,
        refund: created,
        order: order.copyWith(status: OrderStatus.returnRequested),
      );
    } catch (_) {}

    return toSummary(session, created);
  }

  /// Builds a customer/vendor-facing summary with destination metadata.
  static Future<RefundRequestSummary> toSummary(
    Session session,
    RefundRequest row, {
    Transaction? transaction,
  }) async {
    final payment = await PaymentTransaction.db.findFirstRow(
      session,
      where: (tx) => tx.orderId.equals(row.orderId),
      transaction: transaction,
    );
    final method = payment?.paymentMethod;
    final processing = row.status == RequestStatus.inProgress &&
        method == PaymentMethod.esewa;
    return RefundRequestSummary(
      id: row.id!,
      orderId: row.orderId,
      orderNumber: OrderDisplayNumber.format(row.orderId),
      status: row.status,
      refundAmount: row.refundAmount,
      reason: row.reason,
      createdAt: row.createdAt,
      rejectionReason: row.rejectionReason,
      paymentMethod: method,
      paymentStatus: payment?.status,
      destinationLabel: RefundDestination.labelFor(
        method,
        processing: processing,
      ),
      referenceNumber: 'RFN-${row.id}',
      gatewayStatus: row.gatewayStatus,
      gatewayReference: row.gatewayReference,
      refundCompletedAt: row.refundCompletedAt,
      settlementMode: row.settlementMode,
    );
  }

  /// Completes settlement for non-eSewa methods, or parks eSewa as pending.
  static Future<RefundRequest> applyApprovalSettlement(
    Session session, {
    required RefundRequest row,
    required UuidValue actorUserId,
    Transaction? transaction,
  }) async {
    final payment = await PaymentTransaction.db.findFirstRow(
      session,
      where: (tx) => tx.orderId.equals(row.orderId),
      transaction: transaction,
    );
    final method = payment?.paymentMethod;
    final order = await Order.db.findById(
      session,
      row.orderId,
      transaction: transaction,
    );
    if (order == null) {
      throw PlaceifyException(
        message: 'Order not found.',
        code: 'ORDER_NOT_FOUND',
      );
    }

    if (RefundDestination.settlesImmediately(method)) {
      await PaymentSync.markOrderRefunded(
        session,
        row.orderId,
        transaction: transaction,
        changedByUserId: actorUserId,
      );

      final note = method == PaymentMethod.cashOnDelivery ||
              method == PaymentMethod.mockOnline ||
              method == PaymentMethod.khalti
          ? 'Manual refund required — marked refunded in ledger.'
          : 'Refund completed.';

      if (payment != null &&
          (method == PaymentMethod.cashOnDelivery ||
              method == PaymentMethod.mockOnline ||
              method == PaymentMethod.khalti)) {
        await PaymentTransaction.db.updateRow(
          session,
          payment.copyWith(
            note: payment.note ?? note,
            updatedAt: DateTime.now(),
          ),
          transaction: transaction,
        );
      }

      await Order.db.updateRow(
        session,
        order.copyWith(
          status: OrderStatus.refunded,
          updatedAt: DateTime.now(),
          version: order.version + 1,
        ),
        transaction: transaction,
      );

      await OrderLifecycleStore.appendHistory(
        session,
        row.orderId,
        statusType: OrderStatusHistoryType.order,
        previousStatus: order.status.name,
        newStatus: OrderStatus.refunded.name,
        changedByUserId: actorUserId,
        note: note,
        transaction: transaction,
      );

      return await RefundRequest.db.updateRow(
        session,
        row.copyWith(
          status: RequestStatus.completed,
          resolvedByUserId: actorUserId,
          updatedAt: DateTime.now(),
        ),
        transaction: transaction,
      );
    }

    // eSewa Mode B — initiate seam (unavailable without official API).
    if (payment == null) {
      throw PlaceifyException(
        message: 'Payment not found for this refund.',
        code: 'PAYMENT_NOT_FOUND',
      );
    }
    if (row.status == RequestStatus.completed) {
      return row;
    }
    if (row.status == RequestStatus.inProgress &&
        payment.status == PaymentTransactionStatus.refundPending) {
      return row;
    }

    final initiate = await EsewaRefundService.initiateRefund(
      session,
      payment: payment,
      refund: row,
    );

    await PaymentSync.markOrderRefundPending(
      session,
      row.orderId,
      reason: initiate.message,
      transaction: transaction,
      changedByUserId: actorUserId,
    );

    await OrderLifecycleStore.appendHistory(
      session,
      row.orderId,
      statusType: OrderStatusHistoryType.payment,
      previousStatus: payment.status.name,
      newStatus: PaymentTransactionStatus.refundPending.name,
      changedByUserId: actorUserId,
      note: initiate.message,
      transaction: transaction,
    );

    final settlementMode = initiate.outcome == EsewaRefundInitiateOutcome.submitted
        ? EsewaRefundService.settlementModeAutoApi
        : EsewaRefundService.settlementModeManualPortal;

    return await RefundRequest.db.updateRow(
      session,
      row.copyWith(
        status: RequestStatus.inProgress,
        resolvedByUserId: actorUserId,
        settlementMode: settlementMode,
        gatewayStatus: initiate.outcome.name,
        gatewayResponse: initiate.message,
        updatedAt: DateTime.now(),
      ),
      transaction: transaction,
    );
  }

  static Future<RefundRequest> applyRejection(
    Session session, {
    required RefundRequest row,
    required UuidValue actorUserId,
    String? reason,
    Transaction? transaction,
  }) async {
    final order = await Order.db.findById(
      session,
      row.orderId,
      transaction: transaction,
    );
    if (order == null) {
      throw PlaceifyException(
        message: 'Order not found.',
        code: 'ORDER_NOT_FOUND',
      );
    }

    final rejection = (reason ?? '').trim().isEmpty
        ? 'Refund request rejected.'
        : reason!.trim();

    final updated = await RefundRequest.db.updateRow(
      session,
      row.copyWith(
        status: RequestStatus.rejected,
        rejectionReason: rejection,
        resolvedByUserId: actorUserId,
        updatedAt: DateTime.now(),
      ),
      transaction: transaction,
    );

    await Order.db.updateRow(
      session,
      order.copyWith(
        status: OrderStatus.delivered,
        updatedAt: DateTime.now(),
        version: order.version + 1,
      ),
      transaction: transaction,
    );

    await OrderLifecycleStore.appendHistory(
      session,
      row.orderId,
      statusType: OrderStatusHistoryType.order,
      previousStatus: order.status.name,
      newStatus: OrderStatus.delivered.name,
      changedByUserId: actorUserId,
      note: 'Refund rejected: $rejection',
      transaction: transaction,
    );

    return updated;
  }
}
