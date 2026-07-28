import 'package:placeify_client/placeify_client.dart' as api;

import '../domain/enums/payment_status.dart';
import '../domain/models/payment_update.dart';

abstract final class VendorPaymentMapper {
  static PaymentUpdate toUpdate(api.PaymentUpdateSummary summary) {
    return PaymentUpdate(
      id: summary.id.toString(),
      orderId: summary.orderId.toString(),
      amount: summary.amount,
      status: _toPaymentStatus(summary.status),
      note: summary.note,
      updatedAt: summary.updatedAt,
      paymentMethodLabel: _paymentMethodLabel(summary.paymentMethod),
      customerName: summary.customerName,
      customerEmail: summary.customerEmail,
      orderNumber: summary.orderNumber,
      orderStatus: summary.orderStatus,
      transactionId: summary.transactionId,
      providerTransactionId: summary.providerTransactionId,
      deliveryFee: summary.deliveryFee,
      discount: summary.discount,
      vendorEarnings: summary.vendorEarnings,
      refundStatus: summary.refundStatus,
      refundDate: summary.refundDate,
      createdAt: summary.createdAt,
    );
  }

  static String? _paymentMethodLabel(api.PaymentMethod? method) {
    if (method == null) return null;
    return switch (method) {
      api.PaymentMethod.cashOnDelivery => 'COD',
      api.PaymentMethod.esewa => 'eSewa',
      api.PaymentMethod.khalti => 'Khalti',
      api.PaymentMethod.mockOnline => 'Online',
    };
  }

  static api.PaymentTransactionStatus toApiStatus(PaymentStatus status) {
    return switch (status) {
      PaymentStatus.pending => api.PaymentTransactionStatus.pending,
      PaymentStatus.paid => api.PaymentTransactionStatus.paid,
      PaymentStatus.partial => api.PaymentTransactionStatus.pending,
      PaymentStatus.refundPending => api.PaymentTransactionStatus.refundPending,
      PaymentStatus.refunded => api.PaymentTransactionStatus.refunded,
      PaymentStatus.failed => api.PaymentTransactionStatus.failed,
    };
  }

  static PaymentStatus fromTransactionStatus(
    api.PaymentTransactionStatus status,
  ) =>
      _toPaymentStatus(status);

  static PaymentStatus _toPaymentStatus(api.PaymentTransactionStatus status) {
    return switch (status) {
      api.PaymentTransactionStatus.pending => PaymentStatus.pending,
      api.PaymentTransactionStatus.paid => PaymentStatus.paid,
      api.PaymentTransactionStatus.refundPending => PaymentStatus.refundPending,
      api.PaymentTransactionStatus.refunded => PaymentStatus.refunded,
      api.PaymentTransactionStatus.failed => PaymentStatus.failed,
      api.PaymentTransactionStatus.cancelled => PaymentStatus.failed,
    };
  }
}
