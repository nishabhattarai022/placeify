import 'package:placeify_server/src/generated/checkout_request.dart';
import 'package:placeify_server/src/generated/delivery_stage.dart';
import 'package:placeify_server/src/generated/order_status.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_tools/user_test_helpers.dart';

void main() {
  withServerpod('Given user order delivery tracking', (sessionBuilder, endpoints) {
    test(
      'when vendor posts delivery updates then listMyOrders includes latest stage and note',
      () async {
        final vendorAuth = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'Vendor User',
        );

        final setupSession = sessionBuilder.build();
        final seeded = await seedProductForUser(
          setupSession,
          vendorAuth.profile,
        );
        await setupSession.close();

        final consumerAuth = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'Buyer User',
        );

        await endpoints.cart.addToCart(
          consumerAuth.session,
          seeded.product.id!,
          quantity: 1,
        );

        final checkout = await endpoints.checkout.checkout(
          consumerAuth.session,
          CheckoutRequest(shippingAddress: 'Kathmandu, Nepal'),
        );
        final orderId = checkout.order.id!;

        await endpoints.vendor.acceptShopOrder(vendorAuth.session, orderId);

        var orders = await endpoints.user.listMyOrders(
          consumerAuth.session,
          limit: 20,
          offset: 0,
        );

        expect(orders, hasLength(1));
        expect(orders.first.id, orderId);
        expect(orders.first.latestDeliveryStage, DeliveryStage.orderPlaced);
        expect(
          orders.first.latestDeliveryNote,
          'Order confirmed by vendor.',
        );

        await endpoints.vendor.submitDeliveryUpdate(
          vendorAuth.session,
          orderId,
          DeliveryStage.packed,
          note: 'Packed and ready to ship.',
        );

        orders = await endpoints.user.listMyOrders(
          consumerAuth.session,
          limit: 20,
          offset: 0,
        );

        expect(orders.first.latestDeliveryStage, DeliveryStage.packed);
        expect(
          orders.first.latestDeliveryNote,
          'Packed and ready to ship.',
        );
        expect(orders.first.status, OrderStatus.processing);
      },
    );

    test(
      'when authenticated then getMyOrder returns line items and delivery timeline',
      () async {
        final vendorAuth = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'Vendor User',
        );

        final setupSession = sessionBuilder.build();
        final seeded = await seedProductForUser(
          setupSession,
          vendorAuth.profile,
        );
        await setupSession.close();

        final consumerAuth = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'Buyer User',
        );

        await endpoints.cart.addToCart(
          consumerAuth.session,
          seeded.product.id!,
          quantity: 2,
        );

        final checkout = await endpoints.checkout.checkout(
          consumerAuth.session,
          CheckoutRequest(shippingAddress: 'Pokhara, Nepal'),
        );
        final orderId = checkout.order.id!;

        await endpoints.vendor.acceptShopOrder(vendorAuth.session, orderId);
        await endpoints.vendor.submitDeliveryUpdate(
          vendorAuth.session,
          orderId,
          DeliveryStage.packed,
          note: 'Packed for shipping.',
        );

        final detail = await endpoints.user.getMyOrder(
          consumerAuth.session,
          orderId,
        );

        expect(detail.id, orderId);
        expect(detail.shippingAddress, 'Pokhara, Nepal');
        expect(detail.totalAmount, seeded.product.price * 2);
        expect(detail.itemCount, 2);
        expect(detail.items, hasLength(1));
        expect(detail.items.first.productName, 'Test Chair');
        expect(detail.items.first.quantity, 2);
        expect(detail.latestDeliveryStage, DeliveryStage.packed);
        expect(detail.latestDeliveryNote, 'Packed for shipping.');
        expect(detail.deliveryUpdates.length, greaterThanOrEqualTo(2));
        expect(
          detail.deliveryUpdates.map((event) => event.stage),
          contains(DeliveryStage.orderPlaced),
        );
        expect(
          detail.deliveryUpdates.map((event) => event.stage),
          contains(DeliveryStage.packed),
        );
      },
    );

    test(
      'when order belongs to another user then getMyOrder throws',
      () async {
        final vendorAuth = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'Vendor User',
        );

        final setupSession = sessionBuilder.build();
        final seeded = await seedProductForUser(
          setupSession,
          vendorAuth.profile,
        );
        final order = await seedOrderForUser(
          setupSession,
          vendorAuth.profile,
          seeded.product,
        );
        await setupSession.close();

        final otherUser = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'Other User',
        );

        await expectLater(
          endpoints.user.getMyOrder(otherUser.session, order.id!),
          throwsA(
            predicate<Exception>(
              (error) => error.toString().contains('NOT_FOUND'),
            ),
          ),
        );
      },
    );

    test(
      'when not authenticated then getMyOrder throws',
      () async {
        await expectLater(
          endpoints.user.getMyOrder(sessionBuilder, 1),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
      },
    );
  });
}
