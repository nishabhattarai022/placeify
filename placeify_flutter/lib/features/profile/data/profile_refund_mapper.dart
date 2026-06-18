import 'package:placeify_client/placeify_client.dart' as api;

import '../../../core/utils/formatters.dart';
import '../data/profile_mock_data.dart';

/// Maps refund API rows into existing profile refund UI models.
abstract final class ProfileRefundMapper {
  static ProfileRefund fromSummary(api.RefundRequestSummary summary) {
    final status = switch (summary.status) {
      api.RequestStatus.pending => RefundStatus.underReview,
      api.RequestStatus.inProgress => RefundStatus.underReview,
      api.RequestStatus.completed => RefundStatus.refunded,
      api.RequestStatus.rejected => RefundStatus.underReview,
    };

    return ProfileRefund(
      productName: 'Order #${summary.orderNumber}',
      reason: summary.reason,
      amountLabel: Formatters.currencyDecimal(summary.refundAmount),
      status: status,
      isCompleted: summary.status == api.RequestStatus.completed,
      thumbEmoji: '📦',
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
