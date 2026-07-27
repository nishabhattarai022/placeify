import 'package:placeify_client/placeify_client.dart';

import '../domain/constants/cart_strings.dart';

/// Maps cart/checkout/eSewa API failures to user-visible messages.
abstract final class CartApiErrors {
  static String message(Object error, {String? fallback}) {
    if (error is PlaceifyException) {
      return _messageFor(code: error.code, raw: error.message, fallback: fallback);
    }

    if (error is StateError) {
      return _messageFor(code: null, raw: error.message, fallback: fallback);
    }

    if (error is ArgumentError) {
      return _messageFor(
        code: null,
        raw: error.message?.toString() ?? 'Invalid product.',
        fallback: fallback,
      );
    }

    final raw = error is ServerpodClientException
        ? error.message
        : error.toString();
    return _messageFor(
      code: _extractCode(raw),
      raw: raw,
      fallback: fallback,
    );
  }

  static String _messageFor({
    required String? code,
    required String raw,
    String? fallback,
  }) {
    final haystack = '${code ?? ''} $raw'.toUpperCase();

    // Prefer eSewa gateway outages over generic connectivity text so users see
    // the payment-provider message when rc-epay / epay hosts fail.
    if (_looksLikeEsewaOutage(haystack)) {
      return CartStrings.esewaUnavailable;
    }
    if (_looksLikeConnectionError(haystack)) {
      return CartStrings.serverUnreachable;
    }
    if (haystack.contains('ESEWA_NOT_CONFIGURED') ||
        (haystack.contains('ESEWA') && haystack.contains('NOT CONFIGURED'))) {
      return CartStrings.esewaNotConfigured;
    }
    if (haystack.contains('PAYMENT_NOT_VERIFIED') ||
        haystack.contains('COULD NOT BE VERIFIED')) {
      return CartStrings.esewaNotVerified;
    }

    // Own-shop blocks: match stable codes only (avoid broad "YOUR OWN" matches
    // that can misfire on unrelated gateway/network error text).
    if (haystack.contains('OWN_SHOP_PURCHASE_FORBIDDEN') ||
        haystack.contains('OWN_SHOP_ORDER_FORBIDDEN') ||
        haystack.contains('OWN_SHOP')) {
      if (raw.contains('own shop')) {
        return _messageAfterCode(raw) ?? CartStrings.ownProductBlocked;
      }
      return CartStrings.ownProductBlocked;
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

    final afterCode = _messageAfterCode(raw);
    if (afterCode != null) {
      return afterCode.length <= 200
          ? afterCode
          : (fallback ?? _defaultFallback);
    }

    return fallback ?? _defaultFallback;
  }

  static bool _looksLikeConnectionError(String haystack) {
    return haystack.contains('SOCKETEXCEPTION') ||
        haystack.contains('CONNECTION REFUSED') ||
        haystack.contains('FAILED HOST LOOKUP') ||
        haystack.contains('NETWORK IS UNREACHABLE') ||
        haystack.contains('CLIENTEXCEPTION') ||
        haystack.contains('CONNECTION CLOSED') ||
        haystack.contains('XMLHTTPREQUEST') ||
        (haystack.contains('TIMED OUT') && !haystack.contains('ESEWA')) ||
        haystack.contains('TIMEOUTEXCEPTION') ||
        haystack.contains('FUTURE NOT COMPLETED');
  }

  static bool _looksLikeEsewaOutage(String haystack) {
    if (haystack.contains('ESEWA_UNAVAILABLE')) return true;
    if (!haystack.contains('ESEWA') &&
        !haystack.contains('RC-EPAY') &&
        !haystack.contains('RC.ESEWA') &&
        !haystack.contains('EPAY.ESEWA')) {
      return false;
    }
    return haystack.contains('UNREACHABLE') ||
        haystack.contains('TIMED OUT') ||
        haystack.contains('TIMEOUT') ||
        haystack.contains('SOCKETEXCEPTION') ||
        haystack.contains('FAILED HOST LOOKUP') ||
        haystack.contains('CONNECTION REFUSED') ||
        haystack.contains('HTTP 502') ||
        haystack.contains('HTTP 503') ||
        haystack.contains('HTTP 504') ||
        haystack.contains('STATUS HTTP 5');
  }

  /// Parses `CODE: message` prefixes used by Serverpod exception transport.
  static String? _extractCode(String raw) {
    final match = RegExp(r'\b([A-Z][A-Z0-9_]{2,})\s*:').firstMatch(raw);
    return match?.group(1);
  }

  static String? _messageAfterCode(String raw) {
    final colonIndex = raw.indexOf(': ');
    if (colonIndex <= 0 || colonIndex >= 40) return null;
    final message = raw.substring(colonIndex + 2).trim();
    if (message.isEmpty || message.startsWith('Exception')) return null;
    return message;
  }

  static const _defaultFallback =
      'Something went wrong. Check your connection and try again.';
}
