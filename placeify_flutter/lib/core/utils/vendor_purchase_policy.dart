import '../../features/auth/domain/models/app_user.dart';

/// Client-side mirror of server vendor self-purchase restrictions.
abstract final class VendorPurchasePolicy {
  static const blockedMessage =
      'You cannot purchase your own product.';

  static const addToCartBlockedMessage =
      'You cannot purchase your own product.';

  static const checkoutBlockedMessage =
      'Your order contains a product from your own shop. '
      'Remove it before proceeding.';

  /// True when the signed-in vendor's shop owns [productVendorId].
  static bool isOwnShopProduct({
    String? buyerVendorId,
    String? productVendorId,
  }) {
    if (buyerVendorId == null || productVendorId == null) return false;
    final buyer = buyerVendorId.trim();
    final product = productVendorId.trim();
    if (buyer.isEmpty || product.isEmpty) return false;
    return buyer == product;
  }

  /// Regular customers and guests are always allowed to purchase.
  static bool canPurchase({
    required AppUser? user,
    String? productVendorId,
  }) {
    if (user == null) return true;
    return !isOwnShopProduct(
      buyerVendorId: user.vendorId,
      productVendorId: productVendorId,
    );
  }
}
