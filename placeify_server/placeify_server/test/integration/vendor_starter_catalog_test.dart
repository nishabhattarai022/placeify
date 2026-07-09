import 'package:placeify_server/src/generated/checkout_request.dart';
import 'package:placeify_server/src/generated/order_status.dart';
import 'package:placeify_server/src/generated/payment_method.dart';
import 'package:placeify_server/src/generated/product_status.dart';
import 'package:placeify_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_tools/user_test_helpers.dart';

void main() {
  withServerpod('Given vendor shop orders', (sessionBuilder, endpoints) {
    test(
      'when vendor lists a product then consumer checkout appears in shop orders',
      () async {
        final vendorAuth = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'Starter Vendor',
        );

        final setupSession = sessionBuilder.build();
        final vendor = await Vendor.db.insertRow(
          setupSession,
          Vendor(
            userId: vendorAuth.profile.id!,
            shopName: 'Starter Shop',
            description: 'Awaiting first product',
          ),
        );
        final product = await Product.db.insertRow(
          setupSession,
          Product(
            vendorId: vendor.id!,
            name: 'Starter Chair',
            description: 'Vendor-listed product',
            price: 199,
            status: ProductStatus.active,
          ),
        );
        await setupSession.close();

        await endpoints.user.becomeVendor(vendorAuth.session);

        final dashboard = await endpoints.vendor.getDashboard(vendorAuth.session);
        expect(dashboard.productCount, greaterThan(0));

        final vendorProducts = await endpoints.vendor.listMyProducts(
          vendorAuth.session,
        );
        expect(vendorProducts, isNotEmpty);
        expect(
          vendorProducts.every(
            (row) => row.status == ProductStatus.active,
          ),
          isTrue,
        );

        final consumerAuth = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'Starter Buyer',
        );
        final productId = product.id!;

        await endpoints.cart.addToCart(
          consumerAuth.session,
          productId,
          quantity: 1,
        );
        final checkout = await endpoints.checkout.checkout(
          consumerAuth.session,
          CheckoutRequest(
            shippingAddress: 'Kathmandu, Nepal',
            paymentMethod: PaymentMethod.mockOnline,
          ),
        );
        final orderId = checkout.order.id!;

        final vendorOrders = await endpoints.vendor.listShopOrders(
          vendorAuth.session,
          status: OrderStatus.pending,
          limit: 20,
          offset: 0,
        );
        expect(
          vendorOrders.any((order) => order.orderId == orderId),
          isTrue,
        );
      },
    );
  });
}
