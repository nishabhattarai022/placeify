import 'package:placeify_client/placeify_client.dart' as api;

import '../domain/enums/payment_status.dart';
import '../domain/models/payment_update.dart';
import '../domain/models/vendor_payout.dart';

abstract final class VendorPaymentMapper {
  static VendorPayout toPayout(api.VendorPayoutSummary summary) {
    return VendorPayout(
      id: summary.id.toString(),
      amount: summary.amount,
      status: payoutStatusToPaymentStatus(summary.status),
      paidAt: summary.paidAt,
      reference: summary.reference,
    );
  }

  static PaymentUpdate toUpdate(api.PaymentUpdateSummary summary) {
    return PaymentUpdate(
      id: summary.id.toString(),
      orderId: summary.orderId.toString(),
      amount: summary.amount,
      status: _toPaymentStatus(summary.status),
      note: summary.note,
      updatedAt: summary.updatedAt,
    );
  }

  static api.PaymentTransactionStatus toApiStatus(PaymentStatus status) {
    return switch (status) {
      PaymentStatus.pending => api.PaymentTransactionStatus.pending,
      PaymentStatus.paid => api.PaymentTransactionStatus.succeeded,
      PaymentStatus.partial => api.PaymentTransactionStatus.pending,
      PaymentStatus.refunded => api.PaymentTransactionStatus.refunded,
      PaymentStatus.failed => api.PaymentTransactionStatus.failed,
    };
  }

  static PaymentStatus _toPaymentStatus(api.PaymentTransactionStatus status) {
    return switch (status) {
      api.PaymentTransactionStatus.pending => PaymentStatus.pending,
      api.PaymentTransactionStatus.succeeded => PaymentStatus.paid,
      api.PaymentTransactionStatus.refunded => PaymentStatus.refunded,
      api.PaymentTransactionStatus.failed => PaymentStatus.failed,
    };
  }

  static PaymentStatus payoutStatusToPaymentStatus(
    api.VendorPayoutStatus status,
  ) {
    return switch (status) {
      api.VendorPayoutStatus.pending => PaymentStatus.pending,
      api.VendorPayoutStatus.paid => PaymentStatus.paid,
      api.VendorPayoutStatus.failed => PaymentStatus.failed,
    };
  }
}
