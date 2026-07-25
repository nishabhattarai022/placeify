import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../../shared/refund_destination.dart';
import '../../shared/session_service.dart';
import '../notification/order_notification_service.dart';
import '../payment/esewa_refund_service.dart';
import '../refund/refund_repository.dart';
import 'admin_action_audit_log.dart';
import 'admin_repository.dart';

/// Admin finance operations: payout approval and refund resolution.
class AdminFinanceStore {
  AdminFinanceStore({AdminStore? adminStore})
    : _adminStore = adminStore ?? AdminStore();

  final AdminStore _adminStore;

  Future<Admin> _requireAdmin(Session session) {
    return _adminStore.requireAdminProfile(session);
  }

  Future<List<AdminVendorPayoutSummary>> listVendorPayouts(
    Session session, {
    VendorPayoutStatus? status,
    PaginationInput? pagination,
  }) async {
    await _requireAdmin(session);
    final paging = _resolvePagination(pagination);

    final payouts = await VendorPayout.db.find(
      session,
      where: status == null ? null : (row) => row.status.equals(status),
      include: VendorPayout.include(vendor: Vendor.include()),
      orderBy: (row) => row.createdAt,
      orderDescending: true,
      limit: paging.limit,
      offset: paging.offset,
    );

    return [
      for (final payout in payouts)
        if (payout.id != null)
          AdminVendorPayoutSummary(
            id: payout.id!,
            vendorId: payout.vendorId,
            businessName: payout.vendor?.shopName ?? 'Vendor',
            amount: payout.amount,
            status: payout.status,
            reference: payout.reference,
            payoutMethod: payout.payoutMethod,
            scheduledAt: payout.scheduledAt,
            paidAt: payout.paidAt,
            createdAt: payout.createdAt,
          ),
    ];
  }

  Future<AdminVendorPayoutSummary> approveVendorPayout(
    Session session,
    int payoutId,
  ) async {
    final admin = await _requireAdmin(session);

    final payout = await VendorPayout.db.findById(
      session,
      payoutId,
      include: VendorPayout.include(vendor: Vendor.include()),
    );
    if (payout == null) {
      throw PlaceifyException(message: 'Payout not found.', code: 'NOT_FOUND');
    }
    if (payout.status != VendorPayoutStatus.pending) {
      throw PlaceifyException(
        message: 'Only pending payouts can be approved.',
        code: 'INVALID_STATUS',
      );
    }

    final previousStatus = payout.status.name;

    final updated = await session.db.transaction((transaction) async {
      final row = await VendorPayout.db.updateRow(
        session,
        payout.copyWith(
          status: VendorPayoutStatus.paid,
          paidAt: DateTime.now(),
        ),
        transaction: transaction,
      );

      await AdminActionAuditLog.record(
        session,
        actorAdminId: admin.id!,
        actionType: AdminActionType.approvePayout,
        targetPayoutId: payoutId,
        targetVendorId: payout.vendorId,
        previousStatus: previousStatus,
        newStatus: VendorPayoutStatus.paid.name,
        transaction: transaction,
      );

      return row;
    });

    return AdminVendorPayoutSummary(
      id: updated.id!,
      vendorId: updated.vendorId,
      businessName:
          updated.vendor?.shopName ?? payout.vendor?.shopName ?? 'Vendor',
      amount: updated.amount,
      status: updated.status,
      reference: updated.reference,
      payoutMethod: updated.payoutMethod,
      scheduledAt: updated.scheduledAt,
      paidAt: updated.paidAt,
      createdAt: updated.createdAt,
    );
  }

  Future<AdminVendorPayoutSummary> failVendorPayout(
    Session session,
    int payoutId, {
    String? reason,
  }) async {
    final admin = await _requireAdmin(session);

    final payout = await VendorPayout.db.findById(
      session,
      payoutId,
      include: VendorPayout.include(vendor: Vendor.include()),
    );
    if (payout == null) {
      throw PlaceifyException(message: 'Payout not found.', code: 'NOT_FOUND');
    }
    if (payout.status != VendorPayoutStatus.pending) {
      throw PlaceifyException(
        message: 'Only pending payouts can be marked failed.',
        code: 'INVALID_STATUS',
      );
    }

    final previousStatus = payout.status.name;

    final updated = await session.db.transaction((transaction) async {
      final row = await VendorPayout.db.updateRow(
        session,
        payout.copyWith(status: VendorPayoutStatus.failed),
        transaction: transaction,
      );

      await AdminActionAuditLog.record(
        session,
        actorAdminId: admin.id!,
        actionType: AdminActionType.failPayout,
        targetPayoutId: payoutId,
        targetVendorId: payout.vendorId,
        previousStatus: previousStatus,
        newStatus: VendorPayoutStatus.failed.name,
        reason: reason,
        transaction: transaction,
      );

      return row;
    });

    return AdminVendorPayoutSummary(
      id: updated.id!,
      vendorId: updated.vendorId,
      businessName:
          updated.vendor?.shopName ?? payout.vendor?.shopName ?? 'Vendor',
      amount: updated.amount,
      status: updated.status,
      reference: updated.reference,
      payoutMethod: updated.payoutMethod,
      scheduledAt: updated.scheduledAt,
      paidAt: updated.paidAt,
      createdAt: updated.createdAt,
    );
  }

  Future<List<AdminRefundRequestSummary>> listRefundRequests(
    Session session, {
    RequestStatus? status,
    PaginationInput? pagination,
  }) async {
    await _requireAdmin(session);
    final paging = _resolvePagination(pagination);
    final autoConfigured = EsewaRefundService.isInitiateConfigured(session);

    final rows = await RefundRequest.db.find(
      session,
      where: status == null ? null : (row) => row.status.equals(status),
      include: RefundRequest.include(user: User.include()),
      orderBy: (row) => row.createdAt,
      orderDescending: true,
      limit: paging.limit,
      offset: paging.offset,
    );

    final summaries = <AdminRefundRequestSummary>[];
    for (final row in rows) {
      if (row.id == null) continue;
      final payment = await PaymentTransaction.db.findFirstRow(
        session,
        where: (tx) => tx.orderId.equals(row.orderId),
      );
      summaries.add(
        _toAdminSummary(
          row,
          customerName: row.user?.name ?? 'Customer',
          customerEmail: row.user?.email ?? '',
          payment: payment,
          automaticInitiateConfigured: autoConfigured,
        ),
      );
    }
    return summaries;
  }

  Future<AdminRefundRequestSummary> approveRefundRequest(
    Session session,
    int refundId,
  ) async {
    await _requireAdmin(session);
    return _resolveRefund(session, refundId, approve: true);
  }

  Future<AdminRefundRequestSummary> rejectRefundRequest(
    Session session,
    int refundId, {
    String? reason,
  }) async {
    await _requireAdmin(session);
    return _resolveRefund(session, refundId, approve: false, reason: reason);
  }

  /// Status check + auto-complete when eSewa reports FULL_REFUND.
  Future<AdminRefundRequestSummary> checkEsewaRefundStatus(
    Session session,
    int refundId,
  ) {
    return _runEsewaStatusAction(
      session,
      refundId,
      requireFullRefundToComplete: false,
      actionType: AdminActionType.checkEsewaRefundStatus,
    );
  }

  /// Explicit UI alias for [checkEsewaRefundStatus].
  Future<AdminRefundRequestSummary> retryEsewaRefundStatusCheck(
    Session session,
    int refundId,
  ) {
    return checkEsewaRefundStatus(session, refundId);
  }

  /// Completes only when status API returns FULL_REFUND.
  Future<AdminRefundRequestSummary> completeManualEsewaSettlement(
    Session session,
    int refundId,
  ) {
    return _runEsewaStatusAction(
      session,
      refundId,
      requireFullRefundToComplete: true,
      actionType: AdminActionType.completeManualEsewaSettlement,
    );
  }

  Future<AdminRefundRequestSummary> _runEsewaStatusAction(
    Session session,
    int refundId, {
    required bool requireFullRefundToComplete,
    required AdminActionType actionType,
  }) async {
    final admin = await _requireAdmin(session);
    final adminUser = await SessionService.requireUser(session);
    final existing = await RefundRequest.db.findById(
      session,
      refundId,
      include: RefundRequest.include(user: User.include()),
    );
    if (existing == null) {
      throw PlaceifyException(
        message: 'Refund request not found.',
        code: 'NOT_FOUND',
      );
    }
    final previousStatus = existing.status.name;

    final updated = await EsewaRefundService.checkAndMaybeComplete(
      session,
      refundId,
      actorUserId: adminUser.id,
      requireFullRefundToComplete: requireFullRefundToComplete,
    );

    await AdminActionAuditLog.record(
      session,
      actorAdminId: admin.id!,
      actionType: actionType,
      targetRefundId: refundId,
      targetUserId: updated.userId,
      previousStatus: previousStatus,
      newStatus: updated.status.name,
      note: updated.gatewayStatus,
    );

    return _summaryForRefund(session, updated, fallback: existing);
  }

  Future<AdminRefundRequestSummary> _resolveRefund(
    Session session,
    int refundId, {
    required bool approve,
    String? reason,
  }) async {
    final admin = await _requireAdmin(session);
    final row = await RefundRequest.db.findById(
      session,
      refundId,
      include: RefundRequest.include(user: User.include()),
    );
    if (row == null) {
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

    final adminUser = await SessionService.requireUser(session);
    final previousStatus = row.status.name;

    final updated = await session.db.transaction((transaction) async {
      final resolved = approve
          ? await RefundStore.applyApprovalSettlement(
              session,
              row: row,
              actorUserId: adminUser.id!,
              transaction: transaction,
            )
          : await RefundStore.applyRejection(
              session,
              row: row,
              actorUserId: adminUser.id!,
              reason: reason ?? 'Rejected by admin.',
              transaction: transaction,
            );

      await AdminActionAuditLog.record(
        session,
        actorAdminId: admin.id!,
        actionType: approve
            ? AdminActionType.approveRefund
            : AdminActionType.rejectRefund,
        targetRefundId: refundId,
        targetUserId: row.userId,
        previousStatus: previousStatus,
        newStatus: resolved.status.name,
        reason: approve ? row.reason : (reason ?? resolved.rejectionReason),
        transaction: transaction,
      );

      return resolved;
    });

    try {
      await OrderNotificationService.notifyRefundDecision(
        session,
        refund: updated,
        approved: approve,
        reason: reason ?? updated.rejectionReason,
        completed: approve && updated.status == RequestStatus.completed,
      );
    } catch (_) {}

    return _summaryForRefund(session, updated, fallback: row);
  }

  Future<AdminRefundRequestSummary> _summaryForRefund(
    Session session,
    RefundRequest updated, {
    required RefundRequest fallback,
  }) async {
    final payment = await PaymentTransaction.db.findFirstRow(
      session,
      where: (tx) => tx.orderId.equals(updated.orderId),
    );
    return _toAdminSummary(
      updated,
      customerName: updated.user?.name ?? fallback.user?.name ?? 'Customer',
      customerEmail: updated.user?.email ?? fallback.user?.email ?? '',
      payment: payment,
      automaticInitiateConfigured:
          EsewaRefundService.isInitiateConfigured(session),
    );
  }

  AdminRefundRequestSummary _toAdminSummary(
    RefundRequest row, {
    required String customerName,
    required String customerEmail,
    required PaymentTransaction? payment,
    required bool automaticInitiateConfigured,
  }) {
    final method = payment?.paymentMethod;
    final processing = row.status == RequestStatus.inProgress &&
        method == PaymentMethod.esewa;
    return AdminRefundRequestSummary(
      id: row.id!,
      orderId: row.orderId,
      userId: row.userId,
      customerName: customerName,
      customerEmail: customerEmail,
      reason: row.reason,
      refundAmount: row.refundAmount,
      status: row.status,
      createdAt: row.createdAt,
      paymentMethod: method,
      paymentStatus: payment?.status,
      destinationLabel: RefundDestination.labelFor(
        method,
        processing: processing,
      ),
      gatewayStatus: row.gatewayStatus,
      gatewayReference: row.gatewayReference,
      gatewayResponse: row.gatewayResponse,
      refundCompletedAt: row.refundCompletedAt,
      lastGatewayCheckAt: row.lastGatewayCheckAt,
      settlementMode: row.settlementMode,
      automaticInitiateConfigured: automaticInitiateConfigured,
    );
  }

  ({int limit, int offset}) _resolvePagination(PaginationInput? pagination) {
    if (pagination == null) {
      return (limit: 1000, offset: 0);
    }
    final page = pagination.page.clamp(1, 1000000);
    final pageSize = pagination.pageSize.clamp(1, 100);
    return (limit: pageSize, offset: (page - 1) * pageSize);
  }
}
