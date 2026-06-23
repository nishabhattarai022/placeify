import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'placeify_exception.dart';

/// Rules for vendors buying from the marketplace as customers.
abstract final class VendorPurchasePolicy {
  static const addToCartBlockedMessage =
      "You cannot add your own shop's product to cart.";

  static const checkoutBlockedMessage =
      'Your order contains a product from your own shop. '
      'Remove it before proceeding.';

  /// True when [buyerShopVendorId] owns the product's vendor shop.
  static bool isOwnShopProduct({
    required UuidValue productVendorId,
    UuidValue? buyerShopVendorId,
  }) {
    if (buyerShopVendorId == null) return false;
    return buyerShopVendorId == productVendorId;
  }

  static Future<UuidValue?> resolveBuyerShopVendorId(
    Session session,
    UuidValue userId,
  ) async {
    final vendor = await Vendor.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(userId),
    );
    return vendor?.id;
  }

  static void assertCanAddProductToCart({
    required UuidValue productVendorId,
    UuidValue? buyerShopVendorId,
  }) {
    if (!isOwnShopProduct(
      productVendorId: productVendorId,
      buyerShopVendorId: buyerShopVendorId,
    )) {
      return;
    }

    throw PlaceifyException(
      message: addToCartBlockedMessage,
      code: 'OWN_SHOP_PURCHASE_FORBIDDEN',
    );
  }

  static void assertCanCheckoutProducts({
    required Iterable<Product> products,
    UuidValue? buyerShopVendorId,
  }) {
    if (buyerShopVendorId == null) return;

    for (final product in products) {
      if (isOwnShopProduct(
        productVendorId: product.vendorId,
        buyerShopVendorId: buyerShopVendorId,
      )) {
        throw PlaceifyException(
          message: checkoutBlockedMessage,
          code: 'OWN_SHOP_ORDER_FORBIDDEN',
        );
      }
    }
  }
}
