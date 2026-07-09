/// User-facing copy for the Refund & Returns screen.
abstract final class RefundStrings {
  static const title = 'Refund & Returns';
  static const italicLine = 'requests & wallet';

  static const totalPendingLabel = 'Total Pending Refund';
  static const walletCreditLabel = 'Wallet Credit';
  static const walletReadyLabel = 'Ready to use';

  static const activeRequests = 'Active Requests';
  static const completed = 'Completed';
  static const requestNewRefund = 'Request New Refund';

  static const toCard = 'To Card';
  static const toWallet = 'To Wallet';
  static const submitRequest = 'Submit Refund Request';

  static String activeRequestsCount(int count) =>
      count == 1 ? '1 active request' : '$count active requests';

  static const refundToCardToast = 'Refund to original payment';
  static const addedToWalletToast = 'Added to wallet!';
  static const requestSubmittedToast = 'Refund request submitted ✓';
}
