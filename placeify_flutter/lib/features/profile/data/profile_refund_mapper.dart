import 'package:placeify_client/placeify_client.dart' as api;

import '../../../core/utils/formatters.dart';
import '../domain/models/profile_ui_models.dart';

/// Maps refund API rows into existing profile refund UI models.
abstract final class ProfileRefundMapper {
  static ProfileRefund fromSummary(api.RefundRequestSummary summary) {
    final (status, statusLabel) = switch (summary.status) {
      api.RequestStatus.pending => (
          RefundStatus.underReview,
          'Pending review',
        ),
      api.RequestStatus.inProgress => (
          RefundStatus.underReview,
          'Refund Processing',
        ),
      api.RequestStatus.completed => (
          RefundStatus.refunded,
          'Refunded',
        ),
      api.RequestStatus.rejected => (
          RefundStatus.rejected,
          'Rejected',
        ),
    };

    return ProfileRefund(
      id: summary.id,
      productName: summary.orderNumber,
      reason: summary.reason,
      amountLabel: Formatters.currencyDecimal(summary.refundAmount),
      status: status,
      statusLabel: statusLabel,
      requestedDateLabel: Formatters.shortDate(summary.createdAt),
      isCompleted: summary.status == api.RequestStatus.completed,
      thumbEmoji: '📦',
      destinationLabel:
          summary.destinationLabel?.trim().isNotEmpty == true
              ? summary.destinationLabel
              : null,
      referenceNumber:
          summary.referenceNumber?.trim().isNotEmpty == true
              ? summary.referenceNumber
              : 'RFN-${summary.id}',
      rejectionReason: summary.rejectionReason,
      gatewayReference:
          summary.gatewayReference?.trim().isNotEmpty == true
              ? summary.gatewayReference
              : null,
      completedDateLabel: summary.refundCompletedAt != null
          ? Formatters.shortDate(summary.refundCompletedAt!)
          : null,
    );
  }

  static List<ProfileRefund> active(List<api.RefundRequestSummary> refunds) {
    return refunds
        .where(
          (refund) =>
              refund.status == api.RequestStatus.pending ||
              refund.status == api.RequestStatus.inProgress,
        )
        .map(fromSummary)
        .toList();
  }

  static List<ProfileRefund> completed(List<api.RefundRequestSummary> refunds) {
    return refunds
        .where(
          (refund) =>
              refund.status == api.RequestStatus.completed ||
              refund.status == api.RequestStatus.rejected,
        )
        .map(fromSummary)
        .toList();
  }
}
