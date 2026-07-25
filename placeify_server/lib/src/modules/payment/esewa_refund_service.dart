import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../notification/order_notification_service.dart';
import '../order/order_lifecycle_store.dart';
import 'esewa_status_api.dart';
import 'payment_sync.dart';

/// Outcome of attempting to *initiate* an eSewa refund (Mode A future).
enum EsewaRefundInitiateOutcome {
  /// Official create-refund API not configured or not implemented.
  unavailable,

  /// Reserved for future Mode A success (never used until API docs exist).
  submitted,

  /// Reserved for future Mode A hard failure from gateway.
  failed,
}

class EsewaRefundInitiateResult {
  const EsewaRefundInitiateResult({
    required this.outcome,
    required this.message,
  });

  final EsewaRefundInitiateOutcome outcome;
  final String message;

  bool get isUnavailable => outcome == EsewaRefundInitiateOutcome.unavailable;
}

/// eSewa refund architecture: Mode B settlement + future Mode A initiate seam.
///
/// Mode B (production today): never invents a create-refund HTTP call. Approve
/// parks payment as refundPending; completion happens only when the existing
/// transaction status API reports FULL_REFUND (poller or admin check).
abstract final class EsewaRefundService {
  static const settlementModeManualPortal = 'manual_portal';
  static const settlementModeAutoApi = 'auto_api';

  static const unavailableMessage =
      'Automatic eSewa refund is unavailable. Complete the refund through the '
      'eSewa merchant portal.';

  /// True only when a future Mode A endpoint key is present.
  /// Does **not** imply a working initiate implementation exists.
  static bool isInitiateConfigured(Session session) {
    final endpoint = session.passwords['esewaRefundEndpoint']?.trim();
    return endpoint != null && endpoint.isNotEmpty;
  }

  /// Mode A placeholder — returns unavailable until official API is wired.
  static Future<EsewaRefundInitiateResult> initiateRefund(
    Session session, {
    required PaymentTransaction payment,
    required RefundRequest refund,
  }) async {
    if (!isInitiateConfigured(session)) {
      return const EsewaRefundInitiateResult(
        outcome: EsewaRefundInitiateOutcome.unavailable,
        message: unavailableMessage,
      );
    }

    // Intentionally unimplemented: do not invent request/response formats.
    // When eSewa provides official merchant refund API docs, implement the
    // HTTP call here and return submitted/failed based on the real response.
    return const EsewaRefundInitiateResult(
      outcome: EsewaRefundInitiateOutcome.unavailable,
      message:
          'eSewa merchant refund API endpoint is configured but not '
          'implemented. Using manual portal settlement until official docs '
          'are wired.',
    );
  }

  /// Calls the existing eSewa ePay transaction status enquiry.
  static Future<EsewaTransactionStatusResult> fetchTransactionStatus({
    required Session session,
    required double amount,
    required String transactionUuid,
    http.Client? httpClient,
  }) {
    return EsewaStatusApi.fetchTransactionStatus(
      session: session,
      amount: amount,
      transactionUuid: transactionUuid,
      httpClient: httpClient,
    );
  }

  /// Persists last gateway check fields without completing the refund.
  static Future<RefundRequest> recordGatewayCheck(
    Session session,
    RefundRequest row,
    EsewaTransactionStatusResult status, {
    Transaction? transaction,
  }) {
    return RefundRequest.db.updateRow(
      session,
      row.copyWith(
        gatewayStatus:
            status.status.isEmpty ? status.errorMessage : status.status,
        gatewayReference: status.refId ?? row.gatewayReference,
        gatewayResponse: status.rawBody,
        lastGatewayCheckAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      transaction: transaction,
    );
  }

  /// Completes settlement only after FULL_REFUND confirmation (idempotent).
  static Future<RefundRequest> applyConfirmedFullRefund(
    Session session, {
    required RefundRequest row,
    required EsewaTransactionStatusResult status,
    UuidValue? actorUserId,
    Transaction? transaction,
  }) async {
    if (row.status == RequestStatus.completed) {
      return row;
    }
    if (!status.isFullRefund) {
      throw PlaceifyException(
        message:
            'eSewa has not confirmed FULL_REFUND yet '
            '(status=${status.status.isEmpty ? status.errorMessage : status.status}). '
            'Finish the refund in the merchant portal, then check status again.',
        code: 'ESEWA_REFUND_NOT_CONFIRMED',
      );
    }

    Future<RefundRequest> run(Transaction tx) async {
      await PaymentSync.markOrderRefunded(
        session,
        row.orderId,
        transaction: tx,
        changedByUserId: actorUserId,
      );

      final order = await Order.db.findById(
        session,
        row.orderId,
        transaction: tx,
      );
      if (order != null && order.status != OrderStatus.refunded) {
        await Order.db.updateRow(
          session,
          order.copyWith(
            status: OrderStatus.refunded,
            updatedAt: DateTime.now(),
            version: order.version + 1,
          ),
          transaction: tx,
        );
        await OrderLifecycleStore.appendHistory(
          session,
          row.orderId,
          statusType: OrderStatusHistoryType.order,
          previousStatus: order.status.name,
          newStatus: OrderStatus.refunded.name,
          changedByUserId: actorUserId,
          note: 'eSewa FULL_REFUND confirmed.',
          transaction: tx,
        );
      }

      final now = DateTime.now();
      return RefundRequest.db.updateRow(
        session,
        row.copyWith(
          status: RequestStatus.completed,
          gatewayStatus: status.status,
          gatewayReference: status.refId ?? row.gatewayReference,
          gatewayResponse: status.rawBody,
          lastGatewayCheckAt: now,
          refundCompletedAt: now,
          resolvedByUserId: actorUserId ?? row.resolvedByUserId,
          updatedAt: now,
        ),
        transaction: tx,
      );
    }

    final updated = transaction != null
        ? await run(transaction)
        : await session.db.transaction(run);

    try {
      await OrderNotificationService.notifyRefundDecision(
        session,
        refund: updated,
        approved: true,
        completed: true,
      );
    } catch (_) {}

    return updated;
  }

  /// Status check for an in-progress eSewa refund; completes on FULL_REFUND.
  static Future<RefundRequest> checkAndMaybeComplete(
    Session session,
    int refundId, {
    UuidValue? actorUserId,
    http.Client? httpClient,
    bool requireFullRefundToComplete = false,
    Future<EsewaTransactionStatusResult> Function({
      required Session session,
      required double amount,
      required String transactionUuid,
      http.Client? httpClient,
    })? statusFetcher,
  }) async {
    final row = await RefundRequest.db.findById(session, refundId);
    if (row == null) {
      throw PlaceifyException(
        message: 'Refund request not found.',
        code: 'NOT_FOUND',
      );
    }
    if (row.status == RequestStatus.completed) {
      return row;
    }
    if (row.status == RequestStatus.rejected) {
      throw PlaceifyException(
        message: 'This refund request was rejected.',
        code: 'INVALID_STATUS',
      );
    }

    final payment = await PaymentTransaction.db.findFirstRow(
      session,
      where: (tx) => tx.orderId.equals(row.orderId),
    );
    if (payment == null || payment.paymentMethod != PaymentMethod.esewa) {
      throw PlaceifyException(
        message: 'eSewa status check applies only to eSewa payments.',
        code: 'INVALID_PAYMENT_METHOD',
      );
    }

    final fetch = statusFetcher ?? fetchTransactionStatus;
    final status = await fetch(
      session: session,
      amount: payment.amount,
      transactionUuid: payment.providerTransactionId,
      httpClient: httpClient,
    );

    final withCheck = await recordGatewayCheck(session, row, status);

    if (status.isFullRefund) {
      return applyConfirmedFullRefund(
        session,
        row: withCheck,
        status: status,
        actorUserId: actorUserId,
      );
    }

    if (requireFullRefundToComplete) {
      throw PlaceifyException(
        message:
            'eSewa has not confirmed FULL_REFUND yet '
            '(status=${status.status.isEmpty ? status.errorMessage : status.status}). '
            'Finish the refund in the merchant portal, then try again.',
        code: 'ESEWA_REFUND_NOT_CONFIRMED',
      );
    }

    return withCheck;
  }
}
