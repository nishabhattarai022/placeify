import 'package:placeify_server/src/generated/checkout_request.dart';
import 'package:placeify_server/src/generated/delivery_stage.dart';
import 'package:placeify_server/src/generated/placeify_exception.dart';
import 'package:placeify_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart' hide Order;
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_tools/user_test_helpers.dart';

void main() {
  withServerpod('Product reviews', (sessionBuilder, endpoints) {
    Future<void> approveVendorUser(Session setup, User user) async {
      await User.db.updateRow(
        setup,
        user.copyWith(
          role: UserRole.vendor,
          status: UserAccountStatus.approved,
        ),
      );
    }

    Future<({int orderId, int productId, double price})> placeAndDeliver({
      required dynamic customerSession,
      required dynamic vendorSession,
      required int productId,
    }) async {
      await endpoints.cart.addToCart(customerSession, productId, quantity: 1);
      final checkout = await endpoints.checkout.checkout(
        customerSession,
        CheckoutRequest(shippingAddress: 'Kathmandu, Nepal'),
      );
      final orderId = checkout.order.id!;
      await endpoints.vendor.acceptShopOrder(vendorSession, orderId);
      for (final stage in [
        DeliveryStage.packed,
        DeliveryStage.shipped,
        DeliveryStage.outForDelivery,
        DeliveryStage.delivered,
      ]) {
        await endpoints.vendor.submitDeliveryUpdate(
          vendorSession,
          orderId,
          stage,
        );
      }
      return (orderId: orderId, productId: productId, price: checkout.order.totalAmount);
    }

    test('submitReview rejects non-delivered orders', () async {
      final vendorAuth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'Review Vendor',
      );
      final customerAuth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'Review Customer',
      );

      final setupSession = sessionBuilder.build();
      final seeded = await seedProductForUser(setupSession, vendorAuth.profile);
      await approveVendorUser(setupSession, vendorAuth.profile);
      await setupSession.close();

      await endpoints.cart.addToCart(
        customerAuth.session,
        seeded.product.id!,
        quantity: 1,
      );
      final checkout = await endpoints.checkout.checkout(
        customerAuth.session,
        CheckoutRequest(shippingAddress: 'Kathmandu, Nepal'),
      );
      final orderId = checkout.order.id!;

      await expectLater(
        endpoints.review.submitReview(
          customerAuth.session,
          seeded.product.id!,
          orderId,
          5,
          comment: 'Too early',
        ),
        throwsA(
          predicate<PlaceifyException>(
            (e) => e.code == 'ORDER_NOT_DELIVERED',
          ),
        ),
      );
    });

    test('submitReview rejects duplicates for same order/product/user', () async {
      final vendorAuth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'Dup Review Vendor',
      );
      final customerAuth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'Dup Review Customer',
      );

      final setupSession = sessionBuilder.build();
      final seeded = await seedProductForUser(setupSession, vendorAuth.profile);
      await approveVendorUser(setupSession, vendorAuth.profile);
      await setupSession.close();

      final placed = await placeAndDeliver(
        customerSession: customerAuth.session,
        vendorSession: vendorAuth.session,
        productId: seeded.product.id!,
      );

      await endpoints.review.submitReview(
        customerAuth.session,
        placed.productId,
        placed.orderId,
        5,
        comment: 'Great',
      );

      await expectLater(
        endpoints.review.submitReview(
          customerAuth.session,
          placed.productId,
          placed.orderId,
          4,
          comment: 'Again',
        ),
        throwsA(
          predicate<PlaceifyException>((e) => e.code == 'REVIEW_EXISTS'),
        ),
      );
    });

    test('listProductReviews returns empty then real submitted reviews', () async {
      final vendorAuth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'List Review Vendor',
      );
      final customerAuth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'List Review Customer',
      );

      final setupSession = sessionBuilder.build();
      final seeded = await seedProductForUser(setupSession, vendorAuth.profile);
      await approveVendorUser(setupSession, vendorAuth.profile);
      await setupSession.close();

      final before = await endpoints.review.listProductReviews(
        sessionBuilder,
        seeded.product.id!,
        limit: 20,
        offset: 0,
      );
      expect(before, isEmpty);

      final placed = await placeAndDeliver(
        customerSession: customerAuth.session,
        vendorSession: vendorAuth.session,
        productId: seeded.product.id!,
      );

      await endpoints.review.submitReview(
        customerAuth.session,
        placed.productId,
        placed.orderId,
        4,
        comment: 'Solid chair',
      );

      final after = await endpoints.review.listProductReviews(
        sessionBuilder,
        seeded.product.id!,
        limit: 20,
        offset: 0,
      );
      expect(after, hasLength(1));
      expect(after.single.rating, 4);
      expect(after.single.comment, 'Solid chair');
      expect(after.single.user?.name, 'List Review Customer');
    });

    test('submitReview rejects product not on the order', () async {
      final vendorAuth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'Wrong Product Vendor',
      );
      final customerAuth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'Wrong Product Customer',
      );

      final setupSession = sessionBuilder.build();
      final seededA = await seedProductForUser(setupSession, vendorAuth.profile);
      final otherProduct = await Product.db.insertRow(
        setupSession,
        Product(
          vendorId: seededA.vendor.id!,
          categoryId: seededA.product.categoryId,
          name: 'Other Chair',
          description: 'Not on the order',
          price: 99,
          status: ProductStatus.active,
        ),
      );
      await approveVendorUser(setupSession, vendorAuth.profile);
      await setupSession.close();

      final placed = await placeAndDeliver(
        customerSession: customerAuth.session,
        vendorSession: vendorAuth.session,
        productId: seededA.product.id!,
      );

      await expectLater(
        endpoints.review.submitReview(
          customerAuth.session,
          otherProduct.id!,
          placed.orderId,
          5,
        ),
        throwsA(
          predicate<PlaceifyException>(
            (e) => e.code == 'PRODUCT_NOT_IN_ORDER',
          ),
        ),
      );
    });
  });
}
