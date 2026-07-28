import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../order/order_lifecycle_store.dart';

/// Keeps order-level payment status aligned with per-vendor allocations.
abstract final class PaymentSync {
  static Future<void> ensureAllocationsForOrder(
    Session session,
    int orderId, {
    Transaction? transaction,
  }) async {
    final existing = await OrderVendorPayment.db.count(
      session,
      where: (row) => row.orderId.equals(orderId),
      transaction: transaction,
    );
    if (existing > 0) return;

    final items = await OrderItem.db.find(
      session,
      where: (row) => row.orderId.equals(orderId),
      transaction: transaction,
    );
    if (items.isEmpty) return;

    final totalsByVendor = <UuidValue, double>{};
    for (final item in items) {
      totalsByVendor.update(
        item.vendorId,
        (total) => total + item.unitPrice * item.quantity,
        ifAbsent: () => item.unitPrice * item.quantity,
      );
    }

    for (final entry in totalsByVendor.entries) {
      await OrderVendorPayment.db.insertRow(
        session,
        OrderVendorPayment(
          orderId: orderId,
          vendorId: entry.key,
          amount: entry.value,
        ),
        transaction: transaction,
      );
    }
  }

  static Future<void> syncOrderPaymentStatus(
    Session session,
    int orderId, {
    Transaction? transaction,
  }) async {
    final allocations = await OrderVendorPayment.db.find(
      session,
      where: (row) => row.orderId.equals(orderId),
      transaction: transaction,
    );
    if (allocations.isEmpty) return;

    final status = _aggregateStatus(allocations.map((row) => row.status));
    final payment = await PaymentTransaction.db.findFirstRow(
      session,
      where: (row) => row.orderId.equals(orderId),
      transaction: transaction,
    );
    if (payment == null) return;

    if (payment.status == status) return;

    await PaymentTransaction.db.updateRow(
      session,
      payment.copyWith(status: status, updatedAt: DateTime.now()),
      transaction: transaction,
    );
  }

  static Future<void> markOrderRefunded(
    Session session,
    int orderId, {
    Transaction? transaction,
    UuidValue? changedByUserId,
  }) async {
    await ensureAllocationsForOrder(
      session,
      orderId,
      transaction: transaction,
    );

    final order = await Order.db.findById(
      session,
      orderId,
      transaction: transaction,
    );
    if (order == null) return;

    final allocations = await OrderVendorPayment.db.find(
      session,
      where: (row) => row.orderId.equals(orderId),
      transaction: transaction,
    );
    for (final allocation in allocations) {
      if (allocation.status == PaymentTransactionStatus.refunded) continue;
      await OrderVendorPayment.db.updateRow(
        session,
        allocation.copyWith(
          status: PaymentTransactionStatus.refunded,
          note: allocation.note ?? 'Payment refunded.',
          updatedAt: DateTime.now(),
        ),
        transaction: transaction,
      );
    }

    final payment = await PaymentTransaction.db.findFirstRow(
      session,
      where: (row) => row.orderId.equals(orderId),
      transaction: transaction,
    );
    if (payment != null &&
        payment.status != PaymentTransactionStatus.refunded) {
      await PaymentTransaction.db.updateRow(
        session,
        payment.copyWith(
          status: PaymentTransactionStatus.refunded,
          note: payment.note ?? 'Refund completed via merchant portal.',
          updatedAt: DateTime.now(),
        ),
        transaction: transaction,
      );
    }

    await OrderLifecycleStore.appendHistory(
      session,
      orderId,
      statusType: OrderStatusHistoryType.payment,
      previousStatus: order.paymentStatus.name,
      newStatus: PaymentTransactionStatus.refunded.name,
      changedByUserId: changedByUserId,
      note: 'Payment refunded.',
      transaction: transaction,
    );
  }

  /// Marks a paid order as refund-pending (manual eSewa merchant portal settlement).
  /// Idempotent: safe if already refundPending or refunded.
  static Future<bool> markOrderRefundPending(
    Session session,
    int orderId, {
    required String reason,
    Transaction? transaction,
    UuidValue? changedByUserId,
  }) async {
    await ensureAllocationsForOrder(
      session,
      orderId,
      transaction: transaction,
    );

    final payment = await PaymentTransaction.db.findFirstRow(
      session,
      where: (row) => row.orderId.equals(orderId),
      transaction: transaction,
    );
    if (payment == null) return false;
    if (payment.status == PaymentTransactionStatus.refunded ||
        payment.status == PaymentTransactionStatus.refundPending) {
      return false;
    }
    if (payment.status != PaymentTransactionStatus.paid) {
      return false;
    }

    final order = await Order.db.findById(
      session,
      orderId,
      transaction: transaction,
    );
    if (order == null) return false;

    final allocations = await OrderVendorPayment.db.find(
      session,
      where: (row) => row.orderId.equals(orderId),
      transaction: transaction,
    );
    for (final allocation in allocations) {
      if (allocation.status == PaymentTransactionStatus.refunded ||
          allocation.status == PaymentTransactionStatus.refundPending) {
        continue;
      }
      await OrderVendorPayment.db.updateRow(
        session,
        allocation.copyWith(
          status: PaymentTransactionStatus.refundPending,
          note: reason,
          updatedAt: DateTime.now(),
        ),
        transaction: transaction,
      );
    }

    await PaymentTransaction.db.updateRow(
      session,
      payment.copyWith(
        status: PaymentTransactionStatus.refundPending,
        note: reason,
        updatedAt: DateTime.now(),
      ),
      transaction: transaction,
    );

    await OrderLifecycleStore.appendHistory(
      session,
      orderId,
      statusType: OrderStatusHistoryType.payment,
      previousStatus: PaymentTransactionStatus.paid.name,
      newStatus: PaymentTransactionStatus.refundPending.name,
      changedByUserId: changedByUserId,
      note: reason,
      transaction: transaction,
    );
    return true;
  }

  static PaymentTransactionStatus _aggregateStatus(
    Iterable<PaymentTransactionStatus> statuses,
  ) {
    final values = statuses.toList();
    if (values.isEmpty) return PaymentTransactionStatus.pending;
    if (values.every((status) => status == PaymentTransactionStatus.refunded)) {
      return PaymentTransactionStatus.refunded;
    }
    if (values.any((status) => status == PaymentTransactionStatus.refunded)) {
      return PaymentTransactionStatus.refunded;
    }
    if (values.any(
      (status) => status == PaymentTransactionStatus.refundPending,
    )) {
      return PaymentTransactionStatus.refundPending;
    }
    if (values.every((status) => status == PaymentTransactionStatus.failed)) {
      return PaymentTransactionStatus.failed;
    }
    if (values.any((status) => status == PaymentTransactionStatus.failed)) {
      return PaymentTransactionStatus.failed;
    }
    if (values.every((status) => status == PaymentTransactionStatus.paid)) {
      return PaymentTransactionStatus.paid;
    }
    return PaymentTransactionStatus.pending;
  }
}
