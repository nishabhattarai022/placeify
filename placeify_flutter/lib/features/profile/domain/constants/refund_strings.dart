/// User-facing copy for the Refund & Returns screen.
abstract final class RefundStrings {
  static const title = 'Refund & Returns';
  static const italicLine = 'requests & destinations';

  static const totalPendingLabel = 'Total Pending Refund';
  static const noActiveRefunds = 'No active refunds';
  static const completedCreditLabel = 'Approved Refunds';
  static const completedCreditHint = 'Completed total';
  static const destinationHint = 'Refund destination is shown on each request.';

  static const activeRequests = 'Active Requests';
  static const completed = 'Completed';
  static const requestNewRefund = 'Request New Refund';

  static const submitRequest = 'Submit Refund Request';

  static const noEligibleOrders =
      'No eligible delivered orders are available for refund.';
  static const noEligibleOrdersHint =
      'Orders must be delivered and within 14 days of delivery.';

  static String activeRequestsCount(int count) =>
      count == 1 ? '1 active request' : '$count active requests';

  static const requestSubmittedToast = 'Refund request submitted ✓';
}
