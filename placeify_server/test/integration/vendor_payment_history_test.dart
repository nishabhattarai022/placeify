import 'package:placeify_server/src/generated/checkout_request.dart';
import 'package:placeify_server/src/generated/delivery_stage.dart';
import 'package:placeify_server/src/generated/payment_method.dart';
import 'package:placeify_server/src/generated/payment_transaction_status.dart';
import 'package:placeify_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart' hide Order;
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_tools/user_test_helpers.dart';

void main() {
  withServerpod('Vendor payment history listing', (sessionBuilder, endpoints) {
    Future<void> approveVendorUser(Session setup, User user) async {
      await User.db.updateRow(
        setup,
        user.copyWith(
          role: UserRole.vendor,
          status: UserAccountStatus.approved,
        ),
      );
    }

    Future<void> deliverOrder(
      dynamic vendorSession,
      int orderId,
    ) async {
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
    }

    test(
      'COD marked paid appears once in payment.getOverview paymentHistory',
      () async {
        final vendorAuth = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'COD History Vendor',
        );
        final customerAuth = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'COD History Customer',
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
          CheckoutRequest(
            shippingAddress: 'Kathmandu, Nepal',
            paymentMethod: PaymentMethod.cashOnDelivery,
          ),
        );
        final orderId = checkout.order.id!;

        await deliverOrder(vendorAuth.session, orderId);
        await endpoints.payment.updateOrderPaymentStatus(
          vendorAuth.session,
          orderId,
          PaymentTransactionStatus.paid,
          note: 'Cash received',
        );

        final overview = await endpoints.payment.getOverview(
          vendorAuth.session,
        );
        final matches = overview.paymentHistory
            .where((row) => row.orderId == orderId)
            .toList();

        expect(matches, hasLength(1));
        expect(matches.single.status, PaymentTransactionStatus.paid);
        expect(matches.single.paymentMethod, PaymentMethod.cashOnDelivery);
        expect(matches.single.customerName, 'COD History Customer');
        expect(matches.single.amount, seeded.product.price);

        // Second fetch must not invent duplicates.
        final overviewAgain = await endpoints.payment.getOverview(
          vendorAuth.session,
        );
        expect(
          overviewAgain.paymentHistory
              .where((row) => row.orderId == orderId)
              .length,
          1,
        );
      },
    );

    test(
      'eSewa paid allocation appears once in payment.getOverview paymentHistory',
      () async {
        final vendorAuth = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'eSewa History Vendor',
        );
        final customerAuth = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'eSewa History Customer',
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
          CheckoutRequest(
            shippingAddress: 'Kathmandu, Nepal',
            paymentMethod: PaymentMethod.esewa,
          ),
        );
        final orderId = checkout.order.id!;

        // Simulate completePayment write path (gateway verification skipped):
        // PaymentTransaction + OrderVendorPayment → paid.
        final markPaidSession = sessionBuilder.build();
        final payment = await PaymentTransaction.db.findFirstRow(
          markPaidSession,
          where: (row) => row.orderId.equals(orderId),
        );
        expect(payment, isNotNull);
        expect(payment!.paymentMethod, PaymentMethod.esewa);
        await PaymentTransaction.db.updateRow(
          markPaidSession,
          payment.copyWith(
            status: PaymentTransactionStatus.paid,
            updatedAt: DateTime.now(),
          ),
        );
        final allocation = await OrderVendorPayment.db.findFirstRow(
          markPaidSession,
          where: (row) => row.orderId.equals(orderId),
        );
        expect(allocation, isNotNull);
        await OrderVendorPayment.db.updateRow(
          markPaidSession,
          allocation!.copyWith(
            status: PaymentTransactionStatus.paid,
            note: 'Payment received via eSewa.',
            updatedAt: DateTime.now(),
          ),
        );
        await markPaidSession.close();

        final overview = await endpoints.payment.getOverview(
          vendorAuth.session,
        );
        final matches = overview.paymentHistory
            .where((row) => row.orderId == orderId)
            .toList();

        expect(matches, hasLength(1));
        expect(matches.single.status, PaymentTransactionStatus.paid);
        expect(matches.single.paymentMethod, PaymentMethod.esewa);
        expect(matches.single.customerName, 'eSewa History Customer');
        expect(matches.single.amount, seeded.product.price);
      },
    );

    test(
      'totalEarned sums paid COD and eSewa; pendingPaymentCount tracks unpaid',
      () async {
        final vendorAuth = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'Totals Vendor',
        );
        final customerAuth = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'Totals Customer',
        );

        final setupSession = sessionBuilder.build();
        final seeded = await seedProductForUser(
          setupSession,
          vendorAuth.profile,
        );
        await approveVendorUser(setupSession, vendorAuth.profile);
        await setupSession.close();

        // Pending COD (unpaid).
        await endpoints.cart.addToCart(
          customerAuth.session,
          seeded.product.id!,
          quantity: 1,
        );
        final pendingCheckout = await endpoints.checkout.checkout(
          customerAuth.session,
          CheckoutRequest(
            shippingAddress: 'Kathmandu, Nepal',
            paymentMethod: PaymentMethod.cashOnDelivery,
          ),
        );
        final pendingOrderId = pendingCheckout.order.id!;

        // Paid COD.
        await endpoints.cart.addToCart(
          customerAuth.session,
          seeded.product.id!,
          quantity: 1,
        );
        final codCheckout = await endpoints.checkout.checkout(
          customerAuth.session,
          CheckoutRequest(
            shippingAddress: 'Kathmandu, Nepal',
            paymentMethod: PaymentMethod.cashOnDelivery,
          ),
        );
        final codOrderId = codCheckout.order.id!;
        await deliverOrder(vendorAuth.session, codOrderId);
        await endpoints.payment.updateOrderPaymentStatus(
          vendorAuth.session,
          codOrderId,
          PaymentTransactionStatus.paid,
          note: 'Cash received',
        );

        // Paid eSewa (simulate completePayment write path).
        await endpoints.cart.addToCart(
          customerAuth.session,
          seeded.product.id!,
          quantity: 1,
        );
        final esewaCheckout = await endpoints.checkout.checkout(
          customerAuth.session,
          CheckoutRequest(
            shippingAddress: 'Kathmandu, Nepal',
            paymentMethod: PaymentMethod.esewa,
          ),
        );
        final esewaOrderId = esewaCheckout.order.id!;
        final markPaidSession = sessionBuilder.build();
        final payment = await PaymentTransaction.db.findFirstRow(
          markPaidSession,
          where: (row) => row.orderId.equals(esewaOrderId),
        );
        await PaymentTransaction.db.updateRow(
          markPaidSession,
          payment!.copyWith(
            status: PaymentTransactionStatus.paid,
            updatedAt: DateTime.now(),
          ),
        );
        final allocation = await OrderVendorPayment.db.findFirstRow(
          markPaidSession,
          where: (row) => row.orderId.equals(esewaOrderId),
        );
        await OrderVendorPayment.db.updateRow(
          markPaidSession,
          allocation!.copyWith(
            status: PaymentTransactionStatus.paid,
            note: 'Payment received via eSewa.',
            updatedAt: DateTime.now(),
          ),
        );
        await markPaidSession.close();

        final overview = await endpoints.payment.getOverview(
          vendorAuth.session,
        );

        expect(overview.totalEarned, seeded.product.price * 2);
        expect(overview.pendingPaymentCount, 1);

        // Mark remaining COD paid → pending drops, total rises.
        await deliverOrder(vendorAuth.session, pendingOrderId);
        await endpoints.payment.updateOrderPaymentStatus(
          vendorAuth.session,
          pendingOrderId,
          PaymentTransactionStatus.paid,
          note: 'Cash received',
        );
        final after = await endpoints.payment.getOverview(vendorAuth.session);
        expect(after.pendingPaymentCount, 0);
        expect(after.totalEarned, seeded.product.price * 3);
      },
    );

    test(
      'paymentHistory is newest-first by updatedAt',
      () async {
        final vendorAuth = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'Sort History Vendor',
        );
        final customerAuth = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'Sort History Customer',
        );

        final setupSession = sessionBuilder.build();
        final seeded = await seedProductForUser(
          setupSession,
          vendorAuth.profile,
        );
        await approveVendorUser(setupSession, vendorAuth.profile);
        await setupSession.close();

        Future<int> placeAndMarkPaid(String note) async {
          await endpoints.cart.addToCart(
            customerAuth.session,
            seeded.product.id!,
            quantity: 1,
          );
          final checkout = await endpoints.checkout.checkout(
            customerAuth.session,
            CheckoutRequest(
              shippingAddress: 'Kathmandu, Nepal',
              paymentMethod: PaymentMethod.cashOnDelivery,
            ),
          );
          final orderId = checkout.order.id!;
          await deliverOrder(vendorAuth.session, orderId);
          await endpoints.payment.updateOrderPaymentStatus(
            vendorAuth.session,
            orderId,
            PaymentTransactionStatus.paid,
            note: note,
          );
          return orderId;
        }

        final firstId = await placeAndMarkPaid('First');
        await Future<void>.delayed(const Duration(milliseconds: 20));
        final secondId = await placeAndMarkPaid('Second');

        final overview = await endpoints.payment.getOverview(
          vendorAuth.session,
        );
        final ids = overview.paymentHistory.map((e) => e.orderId).toList();
        expect(ids.indexOf(secondId), lessThan(ids.indexOf(firstId)));
      },
    );
  });
}
