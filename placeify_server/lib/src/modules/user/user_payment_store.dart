import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';
import '../payment/payment_sync.dart';

/// Customer payment reads and mock completion for placed orders.
class UserPaymentStore {
  Future<UserOrderPaymentSummary> getPaymentSummary(
    Session session,
    UuidValue userId,
    int orderId,
  ) async {
    final order = await _requireOwnedOrder(session, userId, orderId);
    final payment = await _requirePayment(session, orderId);
    return _toSummary(payment);
  }

  Future<UserOrderPaymentSummary> completePayment(
    Session session,
    UuidValue userId,
    int orderId,
  ) async {
    final order = await _requireOwnedOrder(session, userId, orderId);
    if (order.status == OrderStatus.cancelled ||
        order.status == OrderStatus.rejected) {
      throw PlaceifyException(
        message: 'Cancelled orders cannot be paid.',
        code: 'ORDER_NOT_PAYABLE',
      );
    }

    final payment = await _requirePayment(session, orderId);
    if (payment.status == PaymentTransactionStatus.succeeded) {
      return _toSummary(payment);
    }
    if (payment.status == PaymentTransactionStatus.refunded) {
      throw PlaceifyException(
        message: 'This payment was refunded.',
        code: 'PAYMENT_REFUNDED',
      );
    }

    final updated = await session.db.transaction((transaction) async {
      final row = await PaymentTransaction.db.updateRow(
        session,
        payment.copyWith(
          status: PaymentTransactionStatus.succeeded,
          updatedAt: DateTime.now(),
        ),
        transaction: transaction,
      );

      await PaymentSync.ensureAllocationsForOrder(
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
            status: PaymentTransactionStatus.succeeded,
            note: allocation.note ?? 'Payment received',
            updatedAt: DateTime.now(),
          ),
          transaction: transaction,
        );
      }

      // Payment success must not advance order lifecycle — vendor accept is required.
      if (order.paymentStatus != OrderPaymentStatus.paymentReceived &&
          order.paymentStatus != OrderPaymentStatus.paymentConfirmed) {
        await Order.db.updateRow(
          session,
          order.copyWith(
            paymentStatus: OrderPaymentStatus.paymentReceived,
            updatedAt: DateTime.now(),
          ),
          transaction: transaction,
        );
      }

      return row;
    });

    return _toSummary(updated);
  }

  Future<Order> _requireOwnedOrder(
    Session session,
    UuidValue userId,
    int orderId,
  ) async {
    final order = await Order.db.findById(session, orderId);
    if (order == null || order.userId != userId) {
      throw PlaceifyException(
        message: 'Order not found.',
        code: 'NOT_FOUND',
      );
    }
    return order;
  }

  Future<PaymentTransaction> _requirePayment(
    Session session,
    int orderId,
  ) async {
    final payment = await PaymentTransaction.db.findFirstRow(
      session,
      where: (row) => row.orderId.equals(orderId),
    );
    if (payment == null) {
      throw PlaceifyException(
        message: 'Payment record not found for this order.',
        code: 'PAYMENT_NOT_FOUND',
      );
    }
    return payment;
  }

  UserOrderPaymentSummary _toSummary(PaymentTransaction payment) {
    return UserOrderPaymentSummary(
      orderId: payment.orderId,
      status: payment.status,
      paymentMethod: payment.paymentMethod,
      amount: payment.amount,
      provider: payment.provider,
      providerTransactionId: payment.providerTransactionId,
    );
  }
}
