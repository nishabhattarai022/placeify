/// Result of placing an order from the checkout payment screen.
sealed class CheckoutFlowResult {
  const CheckoutFlowResult();
}

class CheckoutFlowSuccess extends CheckoutFlowResult {
  const CheckoutFlowSuccess({
    required this.orderId,
    required this.message,
    required this.payload,
  });

  final int orderId;
  final String message;
  final Map<String, Object?> payload;
}

class CheckoutFlowFailure extends CheckoutFlowResult {
  const CheckoutFlowFailure(this.message);

  final String message;
}
