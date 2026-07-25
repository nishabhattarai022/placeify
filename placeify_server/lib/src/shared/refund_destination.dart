import '../generated/protocol.dart';

/// Maps checkout payment methods to customer-facing refund destinations.
abstract final class RefundDestination {
  static const manualRequired = 'Manual refund required';
  static const esewaPending =
      'Automatic eSewa refund is unavailable. Complete the refund through the '
      'eSewa merchant portal.';
  static const esewaProcessing = 'eSewa refund (pending merchant settlement)';
  static const unknown = 'Original payment method';

  static String labelFor(PaymentMethod? method, {bool processing = false}) {
    return switch (method) {
      PaymentMethod.cashOnDelivery => manualRequired,
      PaymentMethod.mockOnline => manualRequired,
      PaymentMethod.khalti => manualRequired,
      PaymentMethod.esewa => processing ? esewaProcessing : esewaPending,
      null => unknown,
    };
  }

  static bool settlesImmediately(PaymentMethod? method) {
    return method != PaymentMethod.esewa;
  }
}
