import '../../features/auth/domain/models/app_user.dart';
import '../../features/admin/domain/enums/user_role.dart';

/// Client-side mirror of server vendor self-purchase restrictions.
abstract final class VendorPurchasePolicy {
  static const blockedMessage =
      'This product is from your shop and cannot be purchased by you.';

  static const addToCartBlockedMessage =
      "You cannot add your own shop's product to cart.";

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
  /// Only active vendor accounts are blocked from buying their own shop listings.
  static bool canPurchase({
    required AppUser? user,
    String? productVendorId,
  }) {
    if (user == null) return true;
    if (user.role != UserRole.vendor) return true;
    return !isOwnShopProduct(
      buyerVendorId: user.vendorId,
      productVendorId: productVendorId,
    );
  }
}
