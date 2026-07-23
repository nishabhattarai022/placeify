import 'dart:convert';

import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../marketplace/marketplace_events.dart';
import '../order/order_lifecycle_store.dart';
import '../payment/esewa_gateway.dart';
import '../payment/payment_sync.dart';

/// Customer payment reads and gateway completion for placed orders.
class UserPaymentStore {
  Future<UserOrderPaymentSummary> getPaymentSummary(
    Session session,
    UuidValue userId,
    int orderId,
  ) async {
    final order = await _requireOwnedOrder(session, userId, orderId);
    final payment = await _requirePayment(session, orderId);
    final items = await OrderItem.db.find(
      session,
      where: (row) => row.orderId.equals(orderId),
      include: OrderItem.include(
        product: Product.include(vendor: Vendor.include()),
      ),
      limit: 1,
    );
    final refund = await RefundRequest.db.findFirstRow(
      session,
      where: (row) => row.orderId.equals(orderId),
      orderBy: (row) => row.updatedAt,
      orderDescending: true,
    );
    return _toSummary(
      payment,
      order: order,
      vendorName: items.firstOrNull?.product?.vendor?.shopName,
      primaryThumbnailUrl: items.firstOrNull?.product?.thumbnailUrl,
      refund: refund,
    );
  }

  /// Signed eSewa ePay v2 form fields for an unpaid esewa order.
  ///
  /// Returned as JSON to avoid a DB schema change; Flutter posts this form.
  Future<String> getEsewaPaymentForm(
    Session session,
    UuidValue userId,
    int orderId,
  ) async {
    final order = await _requireOwnedOrder(session, userId, orderId);
    if (order.status == OrderStatus.cancelled ||
        order.status == OrderStatus.rejected ||
        order.status == OrderStatus.autoCancelled) {
      throw PlaceifyException(
        message: 'This order can no longer be paid.',
        code: 'ORDER_NOT_PAYABLE',
      );
    }

    final payment = await _requirePayment(session, orderId);
    if (payment.paymentMethod != PaymentMethod.esewa) {
      throw PlaceifyException(
        message: 'This order was not placed with eSewa.',
        code: 'INVALID_PAYMENT_METHOD',
      );
    }
    if (payment.status == PaymentTransactionStatus.paid) {
      throw PlaceifyException(
        message: 'This order is already paid.',
        code: 'ALREADY_PAID',
      );
    }
    if (payment.status == PaymentTransactionStatus.refunded) {
      throw PlaceifyException(
        message: 'This payment was refunded.',
        code: 'PAYMENT_REFUNDED',
      );
    }

    final credentials = EsewaGateway.requireCredentials(session);
    final transactionUuid = _esewaTransactionUuid(orderId, payment);

    if (payment.providerTransactionId != transactionUuid) {
      await PaymentTransaction.db.updateRow(
        session,
        payment.copyWith(
          providerTransactionId: transactionUuid,
          updatedAt: DateTime.now(),
        ),
      );
    }

    final fields = EsewaGateway.buildFormFields(
      amount: payment.amount,
      transactionUuid: transactionUuid,
      productCode: credentials.productCode,
      secretKey: credentials.secretKey,
    );

    return jsonEncode({
      'orderId': orderId,
      ...fields,
    });
  }

  Future<UserOrderPaymentSummary> completePayment(
    Session session,
    UuidValue userId,
    int orderId,
  ) async {
    final order = await _requireOwnedOrder(session, userId, orderId);
    final payment = await _requirePayment(session, orderId);

    // COD / bank transfer: vendor confirms funds (existing business rule).
    if (payment.paymentMethod == PaymentMethod.cashOnDelivery ||
        payment.paymentMethod == PaymentMethod.mockOnline) {
      throw PlaceifyException(
        message: 'Payment status is updated by the vendor after checkout.',
        code: 'FORBIDDEN',
      );
    }

    if (order.status == OrderStatus.cancelled ||
        order.status == OrderStatus.rejected ||
        order.status == OrderStatus.autoCancelled) {
      throw PlaceifyException(
        message: 'Cancelled orders cannot be paid.',
        code: 'ORDER_NOT_PAYABLE',
      );
    }

    if (payment.status == PaymentTransactionStatus.paid) {
      return _toSummary(payment);
    }
    if (payment.status == PaymentTransactionStatus.refunded) {
      throw PlaceifyException(
        message: 'This payment was refunded.',
        code: 'PAYMENT_REFUNDED',
      );
    }

    if (payment.paymentMethod == PaymentMethod.esewa) {
      final verified = await EsewaGateway.isPaymentComplete(
        session: session,
        amount: payment.amount,
        transactionUuid: payment.providerTransactionId,
      );
      if (!verified) {
        throw PlaceifyException(
          message:
              'eSewa payment could not be verified yet. '
              'Finish payment in eSewa, then try again.',
          code: 'PAYMENT_NOT_VERIFIED',
        );
      }
    } else if (payment.paymentMethod == PaymentMethod.khalti) {
      throw PlaceifyException(
        message: 'Khalti payment verification is not available yet.',
        code: 'FORBIDDEN',
      );
    }

    Order? updatedOrder;
    await session.db.transaction((transaction) async {
      await PaymentTransaction.db.updateRow(
        session,
        payment.copyWith(
          status: PaymentTransactionStatus.paid,
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
        if (allocation.status == PaymentTransactionStatus.paid) continue;
        await OrderVendorPayment.db.updateRow(
          session,
          allocation.copyWith(
            status: PaymentTransactionStatus.paid,
            note: allocation.note ?? 'Payment received via eSewa.',
            updatedAt: DateTime.now(),
          ),
          transaction: transaction,
        );
      }

      await PaymentSync.syncOrderPaymentStatus(
        session,
        orderId,
        transaction: transaction,
      );

      final currentPaymentStatus = order.paymentStatus;
      updatedOrder = await OrderLifecycleStore.updateOrderWithVersion(
        session,
        order,
        (current) => current.copyWith(
          paymentStatus: OrderPaymentStatus.paymentReceived,
          status: current.status == OrderStatus.pending
              ? OrderStatus.confirmed
              : current.status,
        ),
        transaction: transaction,
      );

      await OrderLifecycleStore.appendHistory(
        session,
        orderId,
        statusType: OrderStatusHistoryType.payment,
        previousStatus: currentPaymentStatus.name,
        newStatus: OrderPaymentStatus.paymentReceived.name,
        changedByUserId: userId,
        note: 'Payment verified via eSewa.',
        transaction: transaction,
      );
    });

    final finalOrder = updatedOrder ?? order;
    final vendorIds = await OrderItem.db.find(
      session,
      where: (row) => row.orderId.equals(orderId),
    );
    final uniqueVendorIds = {
      for (final row in vendorIds) row.vendorId,
    };
    // Notifications are best-effort after the payment transaction committed.
    for (final item in uniqueVendorIds) {
      try {
        await marketplaceEventDispatcher.dispatch(
          session,
          PaymentStatusChangedEvent(
            order: finalOrder,
            status: OrderPaymentStatus.paymentReceived,
            vendorId: item,
          ),
        );
      } catch (error, stackTrace) {
        session.log(
          'PaymentStatusChangedEvent dispatch failed orderId=$orderId '
          'vendorId=$item error=$error',
          level: LogLevel.warning,
          exception: error,
          stackTrace: stackTrace,
        );
      }
    }

    final refreshed = await _requirePayment(session, orderId);
    return _toSummary(refreshed);
  }

  String _esewaTransactionUuid(int orderId, PaymentTransaction payment) {
    final existing = payment.providerTransactionId.trim();
    if (existing.isNotEmpty &&
        !existing.startsWith('mock') &&
        !existing.startsWith('cod') &&
        existing.length >= 8) {
      // Prefer a stable uuid already bound to this payment row.
      if (existing.startsWith('esewa-')) {
        return existing;
      }
    }
    return 'esewa-$orderId-${DateTime.now().microsecondsSinceEpoch}';
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

  UserOrderPaymentSummary _toSummary(
    PaymentTransaction payment, {
    Order? order,
    String? vendorName,
    String? primaryThumbnailUrl,
    RefundRequest? refund,
  }) {
    return UserOrderPaymentSummary(
      orderId: payment.orderId,
      status: payment.status,
      paymentMethod: payment.paymentMethod,
      amount: payment.amount,
      provider: payment.provider,
      providerTransactionId: payment.providerTransactionId,
      orderNumber: payment.orderId.toString().padLeft(5, '0'),
      vendorName: vendorName,
      deliveryFee: null,
      discount: null,
      refundStatus: refund?.status.name ??
          (payment.status == PaymentTransactionStatus.refundPending
              ? 'pending'
              : payment.status == PaymentTransactionStatus.refunded
                  ? 'completed'
                  : null),
      refundAmount: refund?.refundAmount,
      refundReason: refund?.reason,
      refundDate: refund?.status == RequestStatus.completed
          ? refund?.updatedAt
          : null,
      orderDate: order?.placedAt,
      paymentDate: payment.status == PaymentTransactionStatus.paid ||
              payment.status == PaymentTransactionStatus.refundPending ||
              payment.status == PaymentTransactionStatus.refunded
          ? payment.updatedAt
          : null,
      primaryThumbnailUrl: primaryThumbnailUrl,
      orderStatus: order?.status.name,
    );
  }

  Future<List<UserOrderPaymentSummary>> listMyPayments(
    Session session,
    UuidValue userId, {
    int limit = 50,
    int offset = 0,
  }) async {
    final payments = await PaymentTransaction.db.find(
      session,
      where: (row) => row.userId.equals(userId),
      orderBy: (row) => row.createdAt,
      orderDescending: true,
      limit: limit.clamp(1, 100),
      offset: offset < 0 ? 0 : offset,
    );
    if (payments.isEmpty) return const [];

    final orderIds = {for (final p in payments) p.orderId};
    final orders = await Order.db.find(
      session,
      where: (row) => row.id.inSet(orderIds),
    );
    final orderById = {for (final o in orders) o.id!: o};

    final items = await OrderItem.db.find(
      session,
      where: (row) => row.orderId.inSet(orderIds),
      include: OrderItem.include(
        product: Product.include(vendor: Vendor.include()),
      ),
    );
    final vendorNameByOrder = <int, String>{};
    final thumbByOrder = <int, String?>{};
    for (final item in items) {
      vendorNameByOrder.putIfAbsent(
        item.orderId,
        () => item.product?.vendor?.shopName ?? 'Vendor',
      );
      thumbByOrder.putIfAbsent(
        item.orderId,
        () => item.product?.thumbnailUrl,
      );
    }

    final refunds = await RefundRequest.db.find(
      session,
      where: (row) => row.orderId.inSet(orderIds),
      orderBy: (row) => row.updatedAt,
      orderDescending: true,
    );
    final refundByOrder = <int, RefundRequest>{};
    for (final refund in refunds) {
      refundByOrder.putIfAbsent(refund.orderId, () => refund);
    }

    return [
      for (final payment in payments)
        _toSummary(
          payment,
          order: orderById[payment.orderId],
          vendorName: vendorNameByOrder[payment.orderId],
          primaryThumbnailUrl: thumbByOrder[payment.orderId],
          refund: refundByOrder[payment.orderId],
        ),
    ];
  }
}
