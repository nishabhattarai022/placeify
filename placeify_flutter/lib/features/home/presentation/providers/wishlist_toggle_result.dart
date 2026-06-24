/// Result of a wishlist add/remove action for UI feedback.
sealed class WishlistToggleResult {
  const WishlistToggleResult();

  const factory WishlistToggleResult.added() = WishlistToggleAdded;
  const factory WishlistToggleResult.removed() = WishlistToggleRemoved;
  factory WishlistToggleResult.error(String message) = WishlistToggleError;

  String? get errorMessage => switch (this) {
        WishlistToggleError(:final message) => message,
        _ => null,
      };

  String? get successMessage => switch (this) {
        WishlistToggleAdded() => 'Added to wishlist',
        WishlistToggleRemoved() => 'Removed from wishlist',
        _ => null,
      };
}

final class WishlistToggleAdded extends WishlistToggleResult {
  const WishlistToggleAdded();
}

final class WishlistToggleRemoved extends WishlistToggleResult {
  const WishlistToggleRemoved();
}

final class WishlistToggleError extends WishlistToggleResult {
  const WishlistToggleError(this.message);
  final String message;
}
