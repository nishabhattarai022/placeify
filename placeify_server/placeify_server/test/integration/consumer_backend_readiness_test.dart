import 'package:placeify_server/src/generated/checkout_request.dart';
import 'package:placeify_server/src/generated/pagination_input.dart';
import 'package:placeify_server/src/generated/payment_method.dart';
import 'package:placeify_server/src/generated/product_search_input.dart';
import 'package:placeify_server/src/generated/protocol.dart';
import 'package:placeify_server/src/modules/product/catalog_seed.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_tools/user_test_helpers.dart';

/// Single integration suite the frontend team can rely on before wiring UI.
void main() {
  withServerpod('Consumer backend readiness', (sessionBuilder, endpoints) {
    test('catalog, cart, checkout, wishlist, profile, ratings, and shops',
        () async {
      final auth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'Readiness User',
      );
      await endpoints.user.updateProfile(
        auth.session,
        'Readiness User',
        phone: '9800000001',
        address: 'Kathmandu, Nepal',
      );

      // 1. Catalog
      final categories = await endpoints.product.listCategories(auth.session);
      expect(categories.map((c) => c.name).toList(), CatalogSeed.defaultCategoryNames);

      final catalogPage = await endpoints.product.searchProducts(
        auth.session,
        ProductSearchInput(
          pagination: PaginationInput(page: 1, pageSize: 50),
        ),
      );
      expect(catalogPage.items.length, greaterThanOrEqualTo(18));

      final demoProduct = catalogPage.items.firstWhere(
        (product) => CatalogSeed.demoProductNames.contains(product.name),
      );
      expect(demoProduct.thumbnailUrl, startsWith('/uploads/catalog-seed/'));
      expect(demoProduct.viewImageUrls, isNotEmpty);
      expect(demoProduct.category, isNotNull);
      expect(demoProduct.vendor, isNotNull);
      expect(demoProduct.reviewCount, greaterThanOrEqualTo(0));
      expect(demoProduct.averageRating, greaterThanOrEqualTo(0));

      final detail = await endpoints.product.getProduct(
        auth.session,
        demoProduct.id!,
      );
      expect(detail?.vendor?.shopName, isNotEmpty);
      expect(detail?.category?.name, isNotNull);

      // 7. Approved shops
      final shops = await endpoints.product.listApprovedShops(auth.session);
      expect(shops, isNotEmpty);
      expect(shops.first.productCount, greaterThan(0));

      // 5. Profile / dashboard
      final profile = await endpoints.user.getCurrentUser(auth.session);
      expect(profile?.name, 'Readiness User');
      expect(profile?.phone, '9800000001');

      var dashboard = await endpoints.user.getDashboard(auth.session);
      expect(dashboard.profile.name, 'Readiness User');

      // 2. Cart
      await endpoints.cart.addToCart(
        auth.session,
        demoProduct.id!,
        quantity: 1,
      );
      final cartItems = await endpoints.cart.getCartItems(auth.session);
      expect(cartItems, hasLength(1));
      expect(cartItems.first.product?.vendor, isNotNull);

      dashboard = await endpoints.user.getDashboard(auth.session);
      expect(dashboard.cartItemCount, 1);

      // 4. Wishlist
      expect(
        await endpoints.wishlist.toggleWishlist(auth.session, demoProduct.id!),
        isTrue,
      );
      final wishlist = await endpoints.wishlist.listMyWishlist(auth.session);
      expect(wishlist.total, 1);
      expect(wishlist.items.first.product?.name, demoProduct.name);

      // 3. Checkout / orders
      final checkout = await endpoints.checkout.checkout(
        auth.session,
        CheckoutRequest(
          shippingAddress: 'Kathmandu, Nepal',
          paymentMethod: PaymentMethod.cod,
        ),
      );
      expect(checkout.order.id, isNotNull);

      final orders = await endpoints.user.listMyOrders(
        auth.session,
        limit: 10,
        offset: 0,
      );
      expect(orders, isNotEmpty);

      final orderDetail = await endpoints.user.getMyOrder(
        auth.session,
        checkout.order.id!,
      );
      expect(orderDetail.items, isNotEmpty);
      expect(orderDetail.payment.status.name, 'pending');
    });
  });
}
