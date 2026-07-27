/// User-facing copy for cart and checkout actions.
abstract final class CartStrings {
  static const itemAddedSuccess = 'Added to cart';
  static const signInToCheckout = 'Sign in to checkout';
  static const emptyCartCheckout = 'Add items to your cart before checkout';
  static const orderPlacedSuccess = 'Your order has been placed successfully.';
  static const orderCouldNotComplete = 'The order could not be completed.';
  static const unableToPlaceOrder = 'Unable to place your order. Please try again.';
  static const selectPaymentMethod = 'Please select a payment method.';
  static const deliveryAddressRequired =
      'Please enter your delivery address before placing your order.';
  static const deliveryAddressLabel = 'Delivery address';
  static const deliveryAddressHint = 'House/street, city, landmark';
  static const paymentSuccessful =
      'Payment successful. Your order is confirmed.';
  static const paymentFailed =
      'Payment failed. Your order is unpaid — try again from order details.';
  static const esewaOpening = 'Opening eSewa…';
  static const esewaUnavailable =
      'eSewa is temporarily unavailable. Please try again later.';
  static const esewaNotConfigured =
      'eSewa is not configured on the server yet.';
  static const esewaNotVerified =
      'eSewa payment could not be verified yet. Finish payment, then try again.';
  static const serverUnreachable =
      'Cannot reach the server. Check your connection and try again.';
  static const ownProductBlocked = 'You cannot purchase your own product.';
  static const khaltiUnavailable =
      'Khalti checkout is not available yet. Choose eSewa or Cash on Delivery.';
  static const payWithEsewa = 'Pay with eSewa';
}
