import '../domain/constants/cart_strings.dart';
import 'package:placeify_client/placeify_client.dart';

/// Maps cart/checkout API failures to user-visible messages.
abstract final class CartApiErrors {
  static String message(Object error, {String? fallback}) {
    if (error is PlaceifyException) return error.message;

    if (error is StateError) {
      return error.message;
    }

    if (error is ArgumentError) {
      return error.message?.toString() ?? 'Invalid product.';
    }

    final raw = error.toString();
    final haystack = raw.toUpperCase();

    if (haystack.contains('OWN_SHOP') ||
        haystack.contains('OWN PRODUCT') ||
        haystack.contains('YOUR OWN')) {
      return 'You cannot purchase your own product.';
    }
    if (haystack.contains('CART_EMPTY')) {
      return 'Your cart is empty. Add products, then try again.';
    }
    if (haystack.contains('AUTH_REQUIRED') ||
        haystack.contains('UNAUTHENTICATED')) {
      return 'Sign in to continue.';
    }
    if (haystack.contains('PRODUCT_NOT_FOUND')) {
      return 'That product is no longer available.';
    }
    if (haystack.contains('INVALID_ADDRESS')) {
      return CartStrings.deliveryAddressRequired;
    }
    if (haystack.contains('PAYMENT_NOT_VERIFIED') ||
        haystack.contains('COULD NOT BE VERIFIED')) {
      return 'eSewa payment could not be verified yet. Finish payment, then try again.';
    }
    if (haystack.contains('ESEWA') && haystack.contains('NOT CONFIGURED')) {
      return 'eSewa is not configured on the server yet.';
    }

    final colonIndex = raw.indexOf(': ');
    if (colonIndex > 0 && colonIndex < 40) {
      final message = raw.substring(colonIndex + 2).trim();
      if (message.isNotEmpty && !message.startsWith('Exception')) {
        return message.length <= 200 ? message : (fallback ?? _defaultFallback);
      }
    }

    return fallback ?? _defaultFallback;
  }

  static const _defaultFallback =
      'Something went wrong. Check your connection and try again.';
}
