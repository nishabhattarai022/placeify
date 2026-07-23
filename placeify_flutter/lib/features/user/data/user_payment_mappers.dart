import 'package:placeify_client/placeify_client.dart' as api;

import '../../../core/config/resolve_media_url.dart';
import '../../vendor/data/vendor_payment_mapper.dart';
import '../../vendor/domain/enums/payment_status.dart';
import '../domain/models/user_payment_record.dart';

abstract final class UserPaymentMappers {
  static Future<UserPaymentRecord> toRecord(
    api.UserOrderPaymentSummary summary,
  ) async {
    final status = VendorPaymentMapper.fromTransactionStatus(summary.status);

    return UserPaymentRecord(
      orderId: summary.orderId.toString(),
      orderNumber: summary.orderNumber ?? summary.orderId.toString(),
      vendorName: summary.vendorName ?? 'Vendor',
      amount: summary.amount,
      paymentMethodLabel: _paymentMethodLabel(summary.paymentMethod),
      status: status,
      statusLabel: paymentStatusLabel(status, summary.refundStatus),
      thumbnailUrl: await _resolveThumbnail(summary.primaryThumbnailUrl),
      deliveryFee: summary.deliveryFee,
      discount: summary.discount,
      refundStatusLabel: refundStatusLabel(summary.refundStatus, status),
      refundAmount: summary.refundAmount,
      refundReason: summary.refundReason,
      refundDate: summary.refundDate,
      transactionId:
          summary.providerTransactionId ?? summary.provider,
      orderDate: summary.orderDate,
      paymentDate: summary.paymentDate,
      orderStatus: summary.orderStatus,
    );
  }

  static String paymentStatusLabel(
    PaymentStatus status,
    String? refundStatus,
  ) {
    if (status == PaymentStatus.failed) return 'Payment Failed';
    if (status == PaymentStatus.refundPending ||
        _isPendingRefund(refundStatus)) {
      return 'Refund Pending';
    }
    if (status == PaymentStatus.refunded || _isCompletedRefund(refundStatus)) {
      return 'Refund Completed';
    }
    return switch (status) {
      PaymentStatus.pending => 'Payment Pending',
      PaymentStatus.paid => 'Payment Received',
      PaymentStatus.partial => 'Partial Payment',
      PaymentStatus.refundPending => 'Refund Pending',
      PaymentStatus.refunded => 'Refund Completed',
      PaymentStatus.failed => 'Payment Failed',
    };
  }

  static String? refundStatusLabel(String? refundStatus, PaymentStatus status) {
    if (refundStatus == null || refundStatus.trim().isEmpty) {
      if (status == PaymentStatus.refundPending) return 'Refund Pending';
      if (status == PaymentStatus.refunded) return 'Refund Completed';
      return null;
    }
    final normalized = refundStatus.toLowerCase();
    if (normalized.contains('pending')) return 'Refund Pending';
    if (normalized.contains('completed') || normalized.contains('refunded')) {
      return 'Refund Completed';
    }
    return refundStatus;
  }

  static bool _isPendingRefund(String? refundStatus) {
    final normalized = refundStatus?.toLowerCase() ?? '';
    return normalized.contains('pending');
  }

  static bool _isCompletedRefund(String? refundStatus) {
    final normalized = refundStatus?.toLowerCase() ?? '';
    return normalized.contains('completed') || normalized.contains('refunded');
  }

  static String _paymentMethodLabel(api.PaymentMethod method) {
    return switch (method) {
      api.PaymentMethod.cashOnDelivery => 'COD',
      api.PaymentMethod.esewa => 'eSewa',
      api.PaymentMethod.khalti => 'Khalti',
      api.PaymentMethod.mockOnline => 'Online',
    };
  }

  static Future<String?> _resolveThumbnail(String? url) async {
    final trimmed = url?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    final resolved = await resolveMediaUrl(trimmed);
    return resolved.isEmpty ? null : resolved;
  }
}
