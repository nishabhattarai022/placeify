import 'package:placeify_client/placeify_client.dart';

/// Human-readable labels for [PaymentMethod] values.
abstract final class PaymentMethodLabels {
  static String label(PaymentMethod method) {
    return switch (method) {
      PaymentMethod.cod => 'Cash on Delivery',
      PaymentMethod.mockOnline => 'Online Payment',
      PaymentMethod.esewa => 'eSewa',
      PaymentMethod.khalti => 'Khalti',
      PaymentMethod.bankTransfer => 'Bank Transfer / QR Payment',
    };
  }
}
