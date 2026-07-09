import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';

/// Customer payment reads for placed orders.
class UserPaymentStore {
  Future<UserOrderPaymentSummary> getPaymentSummary(
    Session session,
    UuidValue userId,
    int orderId,
  ) async {
    await _requireOwnedOrder(session, userId, orderId);
    final payment = await _requirePayment(session, orderId);
    return _toSummary(payment);
  }

  Future<UserOrderPaymentSummary> completePayment(
    Session session,
    UuidValue userId,
    int orderId,
  ) async {
    await _requireOwnedOrder(session, userId, orderId);
    throw PlaceifyException(
      message: 'Payment status is updated by the vendor after checkout.',
      code: 'FORBIDDEN',
    );
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
