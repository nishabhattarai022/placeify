import 'package:placeify_client/placeify_client.dart';

import '../../profile/domain/repositories/profile_repository.dart';

/// Maps wishlist API failures to user-visible messages.
abstract final class WishlistApiErrors {
  static String message(Object error, {String? fallback}) {
    if (error is ProfileException) return error.message;
    if (error is PlaceifyException) return error.message;
    if (error is StateError) return error.message;
    if (error is ArgumentError) {
      return error.message?.toString() ?? 'Invalid product.';
    }

    final haystack = error.toString().toUpperCase();
    if (haystack.contains('AUTH_REQUIRED') ||
        haystack.contains('UNAUTHENTICATED')) {
      return 'Sign in to save items to your wishlist.';
    }
    if (haystack.contains('PRODUCT_NOT_FOUND')) {
      return 'That product is not in the live catalog yet.';
    }

    return fallback ?? 'Could not update your wishlist. Try again.';
  }
}
