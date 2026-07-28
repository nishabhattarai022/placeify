import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../payment/esewa_refund_service.dart';

/// Periodically checks in-progress eSewa refunds for FULL_REFUND confirmation.
class EsewaRefundStatusFutureCall extends FutureCall<EsewaRefundStatusTrigger> {
  @override
  Future<void> invoke(Session session, EsewaRefundStatusTrigger? _) async {
    final open = await RefundRequest.db.find(
      session,
      where: (row) => row.status.equals(RequestStatus.inProgress),
      limit: 50,
    );

    var checked = 0;
    var completed = 0;

    for (final refund in open) {
      if (refund.id == null) continue;
      final payment = await PaymentTransaction.db.findFirstRow(
        session,
        where: (tx) => tx.orderId.equals(refund.orderId),
      );
      if (payment == null || payment.paymentMethod != PaymentMethod.esewa) {
        continue;
      }
      if (payment.status != PaymentTransactionStatus.refundPending &&
          payment.status != PaymentTransactionStatus.paid) {
        continue;
      }

      checked++;
      try {
        final updated = await EsewaRefundService.checkAndMaybeComplete(
          session,
          refund.id!,
        );
        if (updated.status == RequestStatus.completed) {
          completed++;
        }
      } catch (error, stack) {
        session.log(
          'EsewaRefundStatusFutureCall refund=${refund.id} error=$error',
          level: LogLevel.warning,
          exception: error is Exception ? error : null,
          stackTrace: stack,
        );
      }
    }

    session.log(
      'EsewaRefundStatusFutureCall checked=$checked completed=$completed',
      level: LogLevel.info,
    );

    await session.serverpod.futureCallAtTime(
      'esewaRefundStatus',
      EsewaRefundStatusTrigger(
        scheduledAt: DateTime.now().add(const Duration(minutes: 15)),
      ),
      DateTime.now().add(const Duration(minutes: 15)),
    );
  }
}
