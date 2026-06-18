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

    if (haystack.contains('CART_EMPTY')) {
      return 'Your cart is empty. Sign in, add products from the catalog, then checkout.';
    }
    if (haystack.contains('AUTH_REQUIRED') ||
        haystack.contains('UNAUTHENTICATED')) {
      return 'Sign in to continue.';
    }
    if (haystack.contains('PRODUCT_NOT_FOUND')) {
      return 'That product is no longer available.';
    }
    if (haystack.contains('INVALID_ADDRESS')) {
      return 'Add a shipping address in your profile before checkout.';
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
