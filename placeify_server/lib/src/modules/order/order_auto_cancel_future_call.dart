import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import 'order_auto_cancel_service.dart';

/// Daily job: auto-cancel stale pending orders and reschedule itself.
class OrderAutoCancelFutureCall extends FutureCall<OrderAutoCancelTrigger> {
  @override
  Future<void> invoke(Session session, OrderAutoCancelTrigger? _) async {
    final result = await OrderAutoCancelService().cancelExpiredPendingOrders(
      session,
    );

    session.log(
      'OrderAutoCancelFutureCall scanned=${result.scanned} '
      'cancelled=${result.cancelled}',
      level: LogLevel.info,
    );

    await session.serverpod.futureCallAtTime(
      'orderAutoCancel',
      OrderAutoCancelTrigger(
        scheduledAt: DateTime.now().add(const Duration(days: 1)),
      ),
      DateTime.now().add(const Duration(days: 1)),
    );
  }
}
