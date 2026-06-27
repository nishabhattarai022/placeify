import 'package:placeify_server/src/generated/checkout_request.dart';
import 'package:placeify_server/src/generated/delivery_stage.dart';
import 'package:placeify_server/src/generated/order_status.dart';
import 'package:placeify_server/src/generated/payment_transaction_status.dart';
import 'package:placeify_server/src/generated/protocol.dart';
import 'package:placeify_server/src/modules/notification/in_app_notification_store.dart';
import 'package:serverpod/serverpod.dart' hide Order;
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_tools/user_test_helpers.dart';

void main() {
  withServerpod('Order lifecycle complete flow', (sessionBuilder, endpoints) {
    Future<void> approveVendorUser(
      Session setup,
      User user,
    ) async {
      await User.db.updateRow(
        setup,
        user.copyWith(
          role: UserRole.vendor,
          status: UserAccountStatus.approved,
        ),
      );
    }

    test(
      'vendor accept through delivery emits one notification per stage',
      () async {
        final vendorAuth = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'Lifecycle Vendor',
        );
        final customerAuth = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'Lifecycle Customer',
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

        var customerNotifications =
            await InAppNotification.db.find(
          customerAuth.session.build(),
          where: (row) => row.userId.equals(customerAuth.profile.id!),
        );
        final acceptedCount = customerNotifications
            .where((n) => n.type == InAppNotificationType.orderAccepted)
            .length;
        expect(acceptedCount, 1);

        var orders = await endpoints.user.listMyOrders(
          customerAuth.session,
          limit: 10,
          offset: 0,
        );
        expect(orders.first.status, OrderStatus.accepted);

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
            note: 'Stage ${stage.name}',
          );
        }

        orders = await endpoints.user.listMyOrders(
          customerAuth.session,
          limit: 10,
          offset: 0,
        );
        expect(orders.first.status, OrderStatus.delivered);
        expect(orders.first.latestDeliveryStage, DeliveryStage.delivered);

        customerNotifications = await InAppNotification.db.find(
          customerAuth.session.build(),
          where: (row) => row.userId.equals(customerAuth.profile.id!),
        );
        final deliveryNotifications = customerNotifications
            .where((n) => n.type == InAppNotificationType.deliveryUpdate)
            .toList();
        expect(deliveryNotifications.length, 4);

        final detail = await endpoints.user.getMyOrder(
          customerAuth.session,
          orderId,
        );
        expect(detail.deliveryUpdates.length, greaterThanOrEqualTo(4));
        for (var i = 1; i < detail.deliveryUpdates.length; i++) {
          expect(
            detail.deliveryUpdates[i].createdAt.isAfter(
                  detail.deliveryUpdates[i - 1].createdAt,
                ) ||
                detail.deliveryUpdates[i].createdAt.isAtSameMomentAs(
                  detail.deliveryUpdates[i - 1].createdAt,
                ),
            isTrue,
          );
        }
      },
    );

    test('vendor reject notifies customer once with reason', () async {
      final vendorAuth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'Reject Vendor',
      );
      final customerAuth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'Reject Customer',
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
        CheckoutRequest(shippingAddress: 'Pokhara, Nepal'),
      );
      final orderId = checkout.order.id!;

      await endpoints.vendor.rejectShopOrder(
        vendorAuth.session,
        orderId,
        'Out of stock',
      );

      final orders = await endpoints.user.listMyOrders(
        customerAuth.session,
        limit: 10,
        offset: 0,
      );
      expect(orders.first.status, OrderStatus.rejected);
      expect(orders.first.latestDeliveryNote, contains('Out of stock'));

      final notifications = await InAppNotification.db.find(
        customerAuth.session.build(),
        where: (row) => row.userId.equals(customerAuth.profile.id!),
      );
      expect(
        notifications.where((n) => n.type == InAppNotificationType.orderCancelled),
        hasLength(1),
      );
      final rejectNotification = notifications.firstWhere(
        (n) => n.message.contains('Out of stock'),
      );
      expect(rejectNotification.message, contains('Out of stock'));
    });

    test('payment update and refund flow notify customer', () async {
      final vendorAuth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'Pay Vendor',
      );
      final customerAuth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'Pay Customer',
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

      await endpoints.payment.updateOrderPaymentStatus(
        vendorAuth.session,
        orderId,
        PaymentTransactionStatus.succeeded,
        note: 'Cash received',
      );

      var notifications = await InAppNotification.db.find(
        customerAuth.session.build(),
        where: (row) => row.userId.equals(customerAuth.profile.id!),
      );
      expect(
        notifications.where((n) => n.type == InAppNotificationType.paymentUpdate),
        hasLength(1),
      );

      final refund = await endpoints.refund.createRefundRequest(
        customerAuth.session,
        orderId,
        'Damaged item',
      );

      notifications = await InAppNotification.db.find(
        customerAuth.session.build(),
        where: (row) => row.userId.equals(customerAuth.profile.id!),
      );
      expect(
        notifications.where(
          (n) =>
              n.type == InAppNotificationType.refundUpdate &&
              n.message.contains('refund request'),
        ),
        hasLength(1),
      );

      await endpoints.vendor.approveRefundRequest(
        vendorAuth.session,
        refund.id,
      );

      notifications = await InAppNotification.db.find(
        customerAuth.session.build(),
        where: (row) => row.userId.equals(customerAuth.profile.id!),
      );
      final refundApproved = notifications
          .where(
            (n) =>
                n.type == InAppNotificationType.refundUpdate &&
                n.message.contains('approved'),
          )
          .toList();
      expect(refundApproved, hasLength(1));

      final detail = await endpoints.user.getMyOrder(
        customerAuth.session,
        orderId,
      );
      expect(detail.paymentUpdates, isNotEmpty);
    });

    test(
      'refund approve then idempotent payment refunded does not duplicate notifications',
      () async {
        final vendorAuth = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'Refund Dup Vendor',
        );
        final customerAuth = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'Refund Dup Customer',
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

        await endpoints.payment.updateOrderPaymentStatus(
          vendorAuth.session,
          orderId,
          PaymentTransactionStatus.succeeded,
          note: 'Paid',
        );

        final refund = await endpoints.refund.createRefundRequest(
          customerAuth.session,
          orderId,
          'Wrong item',
        );

        await endpoints.vendor.approveRefundRequest(
          vendorAuth.session,
          refund.id,
        );

        await endpoints.payment.updateOrderPaymentStatus(
          vendorAuth.session,
          orderId,
          PaymentTransactionStatus.refunded,
          note: 'Already refunded via approval',
        );

        final notifications = await InAppNotification.db.find(
          customerAuth.session.build(),
          where: (row) => row.userId.equals(customerAuth.profile.id!),
        );
        expect(
          notifications.where(
            (n) => n.type == InAppNotificationType.paymentUpdate,
          ),
          hasLength(1),
        );
        expect(
          notifications.where(
            (n) =>
                n.type == InAppNotificationType.refundUpdate &&
                n.message.contains('approved'),
          ),
          hasLength(1),
        );

        final paymentHistory = await endpoints.payment.listPaymentUpdates(
          vendorAuth.session,
          orderId,
        );
        final refundedRows = paymentHistory
            .where((row) => row.status == PaymentTransactionStatus.refunded)
            .toList();
        expect(refundedRows, hasLength(1));
        expect(refundedRows.first.note, contains('refunded'));
      },
    );

    test('refund reject includes vendor reason in customer notification', () async {
      final vendorAuth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'Reject Refund Vendor',
      );
      final customerAuth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'Reject Refund Customer',
      );

      final setupSession = sessionBuilder.build();
      final seeded = await seedProductForUser(
        setupSession,
        vendorAuth.profile,
      );
      await approveVendorUser(setupSession, vendorAuth.profile);

      final order = await seedOrderForUser(
        setupSession,
        customerAuth.profile,
        seeded.product,
      );
      await setupSession.close();

      final refund = await endpoints.refund.createRefundRequest(
        customerAuth.session,
        order.id!,
        'Changed my mind',
      );

      await endpoints.vendor.rejectRefundRequest(
        vendorAuth.session,
        refund.id,
        reason: 'Return window expired',
      );

      final notifications = await InAppNotification.db.find(
        customerAuth.session.build(),
        where: (row) => row.userId.equals(customerAuth.profile.id!),
      );
      expect(
        notifications.where(
          (n) =>
              n.type == InAppNotificationType.refundUpdate &&
              n.message.contains('Return window expired'),
        ),
        hasLength(1),
      );
    });

    test('accept order increments unread count once', () async {
      final vendorAuth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'Unread Vendor',
      );
      final customerAuth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'Unread Customer',
      );

      final setupSession = sessionBuilder.build();
      final seeded = await seedProductForUser(
        setupSession,
        vendorAuth.profile,
      );
      await approveVendorUser(setupSession, vendorAuth.profile);
      await setupSession.close();

      final store = InAppNotificationStore();
      await endpoints.cart.addToCart(
        customerAuth.session,
        seeded.product.id!,
        quantity: 1,
      );
      final checkout = await endpoints.checkout.checkout(
        customerAuth.session,
        CheckoutRequest(shippingAddress: 'Kathmandu, Nepal'),
      );

      final before = await store.unreadCount(
        customerAuth.session.build(),
        customerAuth.profile.id!,
      );

      await endpoints.vendor.acceptShopOrder(
        vendorAuth.session,
        checkout.order.id!,
      );

      final after = await store.unreadCount(
        customerAuth.session.build(),
        customerAuth.profile.id!,
      );
      expect(after - before, 1);
    });
  });
}
