import 'package:placeify_client/placeify_client.dart';

import 'cart_line_item.dart';

/// UI payment methods shown at checkout before placing an order.
enum CheckoutPaymentOption {
  khalti,
  esewa,
  cashOnDelivery,
  bankTransfer,
}

extension CheckoutPaymentOptionX on CheckoutPaymentOption {
  String get label => switch (this) {
        CheckoutPaymentOption.khalti => 'Khalti',
        CheckoutPaymentOption.esewa => 'eSewa',
        CheckoutPaymentOption.cashOnDelivery => 'Cash on Delivery',
        CheckoutPaymentOption.bankTransfer => 'Bank Transfer / QR Payment',
      };

  String get subtitle => switch (this) {
        CheckoutPaymentOption.khalti => 'Pay securely with Khalti wallet',
        CheckoutPaymentOption.esewa => 'Pay with your eSewa account',
        CheckoutPaymentOption.cashOnDelivery => 'Pay when your order arrives',
        CheckoutPaymentOption.bankTransfer =>
          'Scan QR or transfer to our bank account',
      };

  PaymentMethod get apiMethod => switch (this) {
        CheckoutPaymentOption.khalti => PaymentMethod.khalti,
        CheckoutPaymentOption.esewa => PaymentMethod.esewa,
        CheckoutPaymentOption.cashOnDelivery => PaymentMethod.cod,
        CheckoutPaymentOption.bankTransfer => PaymentMethod.bankTransfer,
      };

  /// Client-side payment status sent with the order summary payload.
  String get paymentStatusLabel => switch (this) {
        CheckoutPaymentOption.cashOnDelivery => 'PENDING',
        _ => 'UNPAID',
      };
}

/// Order confirmation payload built before calling the checkout API.
class CheckoutOrderPayload {
  const CheckoutOrderPayload({
    required this.items,
    required this.subtotal,
    required this.total,
    required this.paymentMethod,
    required this.paymentStatus,
    this.orderStatus = 'PENDING',
  });

  final List<CartLineItem> items;
  final double subtotal;
  final double total;
  final CheckoutPaymentOption paymentMethod;
  final String paymentStatus;
  final String orderStatus;

  Map<String, Object?> toJson() => {
        'items': items
            .map(
              (item) => {
                'productId': item.productId,
                'quantity': item.quantity,
              },
            )
            .toList(),
        'subtotal': subtotal,
        'total': total,
        'paymentMethod': paymentMethod.name,
        'paymentStatus': paymentStatus,
        'orderStatus': orderStatus,
      };
}
