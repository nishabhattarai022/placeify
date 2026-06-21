import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';

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
  }) async {
    await ensureAllocationsForOrder(
      session,
      orderId,
      transaction: transaction,
    );

    final allocations = await OrderVendorPayment.db.find(
      session,
      where: (row) => row.orderId.equals(orderId),
      transaction: transaction,
    );
    for (final allocation in allocations) {
      await OrderVendorPayment.db.updateRow(
        session,
        allocation.copyWith(
          status: PaymentTransactionStatus.refunded,
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
    if (payment != null) {
      await PaymentTransaction.db.updateRow(
        session,
        payment.copyWith(
          status: PaymentTransactionStatus.refunded,
          updatedAt: DateTime.now(),
        ),
        transaction: transaction,
      );
    }
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
    if (values.every((status) => status == PaymentTransactionStatus.failed)) {
      return PaymentTransactionStatus.failed;
    }
    if (values.any((status) => status == PaymentTransactionStatus.failed)) {
      return PaymentTransactionStatus.failed;
    }
    if (values.every((status) => status == PaymentTransactionStatus.succeeded)) {
      return PaymentTransactionStatus.succeeded;
    }
    return PaymentTransactionStatus.pending;
  }
}
