import 'package:placeify_server/src/generated/checkout_request.dart';
import 'package:placeify_server/src/generated/order_status.dart';
import 'package:placeify_server/src/generated/payment_method.dart';
import 'package:placeify_server/src/generated/payment_transaction_status.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_tools/user_test_helpers.dart';

void main() {
  withServerpod('Given user payment flow', (sessionBuilder, endpoints) {
    test(
      'when checkout then payment is pending, completePayment marks paid, vendor sees order',
      () async {
        final consumer = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'Consumer User',
        );
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

        await endpoints.user.becomeVendor(vendorAuth.session);

        final productId = seeded.product.id!;
        await endpoints.cart.addToCart(consumer.session, productId, quantity: 1);

        final checkout = await endpoints.checkout.checkout(
          consumer.session,
          CheckoutRequest(
            shippingAddress: 'Kathmandu, Nepal',
            paymentMethod: PaymentMethod.mockOnline,
          ),
        );
        final orderId = checkout.order.id!;

        final pendingPayment = await endpoints.user.getMyOrderPayment(
          consumer.session,
          orderId,
        );
        expect(pendingPayment.status, PaymentTransactionStatus.pending);
        expect(pendingPayment.paymentMethod, PaymentMethod.mockOnline);
        expect(pendingPayment.amount, seeded.product.price);

        final detailBeforePay = await endpoints.user.getMyOrder(
          consumer.session,
          orderId,
        );
        expect(detailBeforePay.payment.status, PaymentTransactionStatus.pending);
        expect(detailBeforePay.status, OrderStatus.pending);

        final vendorOrdersBeforePay = await endpoints.vendor.listShopOrders(
          vendorAuth.session,
          limit: 20,
          offset: 0,
        );
        expect(vendorOrdersBeforePay, isNotEmpty);
        expect(
          vendorOrdersBeforePay.any((order) => order.orderId == orderId),
          isTrue,
        );
        expect(vendorOrdersBeforePay.first.status, OrderStatus.pending);

        final paid = await endpoints.user.completePayment(
          consumer.session,
          orderId,
        );
        expect(paid.status, PaymentTransactionStatus.succeeded);

        final detailAfterPay = await endpoints.user.getMyOrder(
          consumer.session,
          orderId,
        );
        expect(detailAfterPay.payment.status, PaymentTransactionStatus.succeeded);
        expect(detailAfterPay.status, OrderStatus.confirmed);

        final vendorOrdersAfterPay = await endpoints.vendor.listShopOrders(
          vendorAuth.session,
          status: OrderStatus.confirmed,
          limit: 20,
          offset: 0,
        );
        expect(
          vendorOrdersAfterPay.any((order) => order.orderId == orderId),
          isTrue,
        );
      },
    );

    test(
      'when not authenticated then getMyOrderPayment throws',
      () async {
        await expectLater(
          endpoints.user.getMyOrderPayment(sessionBuilder, 1),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
      },
    );
  });
}
