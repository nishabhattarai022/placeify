import 'package:flutter/foundation.dart';
import 'package:placeify_client/placeify_client.dart';

/// Maps cart/checkout API failures to user-visible messages.
abstract final class CartApiErrors {
  static String message(Object error, {String? fallback}) {
    debugPrint('CartApiErrors raw=${error.runtimeType}: $error');

    if (error is PlaceifyException) return error.message;

    if (error is ServerpodClientException) {
      final parsed = _extractMessage(error.message);
      if (parsed != null) return parsed;
    }

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
    if (haystack.contains('SOCKETEXCEPTION') ||
        haystack.contains('FAILED HOST LOOKUP') ||
        haystack.contains('CONNECTION REFUSED') ||
        haystack.contains('NETWORK IS UNREACHABLE')) {
      return 'Cannot reach the server. Check your Wi‑Fi and that the backend is running.';
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

  static String? _extractMessage(String raw) {
    if (raw.trim().isEmpty) return null;

    final upper = raw.toUpperCase();
    if (upper.contains('UNAUTHENTICATED') || upper.contains('AUTH_REQUIRED')) {
      return 'Sign in to continue.';
    }

    final colonIndex = raw.indexOf(': ');
    if (colonIndex > 0 && colonIndex < 40) {
      final message = raw.substring(colonIndex + 2).trim();
      if (message.isNotEmpty && !message.startsWith('Exception')) {
        return message.length <= 200 ? message : null;
      }
    }

    if (!raw.startsWith('Exception') && raw.length <= 200) {
      return raw;
    }

    return null;
  }

  static const _defaultFallback =
      'Something went wrong. Check your connection and try again.';
}
