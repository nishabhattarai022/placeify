import 'package:placeify_server/src/generated/checkout_request.dart';
import 'package:placeify_server/src/generated/delivery_stage.dart';
import 'package:placeify_server/src/generated/order_status.dart';
import 'package:placeify_server/src/generated/payment_transaction_status.dart';
import 'package:placeify_server/src/generated/placeify_exception.dart';
import 'package:placeify_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart' hide Order;
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_tools/user_test_helpers.dart';

void main() {
  withServerpod('Vendor payment update eligibility', (sessionBuilder, endpoints) {
    Future<void> approveVendorUser(Session setup, User user) async {
      await User.db.updateRow(
        setup,
        user.copyWith(
          role: UserRole.vendor,
          status: UserAccountStatus.approved,
        ),
      );
    }

    test(
      'updateOrderPaymentStatus rejects rejected orders',
      () async {
        final vendorAuth = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'Pay Guard Vendor',
        );
        final customerAuth = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'Pay Guard Customer',
        );

        final setupSession = sessionBuilder.build();
        final seeded = await seedProductForUser(
          setupSession,
          vendorAuth.profile,
        );
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

        await endpoints.vendor.rejectShopOrder(
          vendorAuth.session,
          orderId,
          'Out of stock',
        );

        await expectLater(
          endpoints.payment.updateOrderPaymentStatus(
            vendorAuth.session,
            orderId,
            PaymentTransactionStatus.paid,
            note: 'Should fail',
          ),
          throwsA(
            predicate<PlaceifyException>(
              (e) => e.code == 'ORDER_NOT_ELIGIBLE_FOR_PAYMENT_UPDATE',
            ),
          ),
        );
      },
    );

    test(
      'updateOrderPaymentStatus allows accepted then delivered COD',
      () async {
        final vendorAuth = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'Pay Allow Vendor',
        );
        final customerAuth = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'Pay Allow Customer',
        );

        final setupSession = sessionBuilder.build();
        final seeded = await seedProductForUser(
          setupSession,
          vendorAuth.profile,
        );
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

        await endpoints.vendor.acceptShopOrder(vendorAuth.session, orderId);
        for (final stage in [
          DeliveryStage.packed,
          DeliveryStage.shipped,
          DeliveryStage.outForDelivery,
          DeliveryStage.delivered,
        ]) {
          await endpoints.vendor.submitDeliveryUpdate(
            vendorAuth.session,
            orderId,
            stage,
          );
        }

        final update = await endpoints.payment.updateOrderPaymentStatus(
          vendorAuth.session,
          orderId,
          PaymentTransactionStatus.paid,
          note: 'Cash received',
        );
        expect(update.status, PaymentTransactionStatus.paid);

        final order = await Order.db.findById(
          sessionBuilder.build(),
          orderId,
        );
        expect(order?.status, OrderStatus.delivered);
      },
    );
  });
}
