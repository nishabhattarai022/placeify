import 'package:placeify_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_tools/user_test_helpers.dart';

void main() {
  withServerpod('Given vendor refund endpoints', (sessionBuilder, endpoints) {
    test(
      'when customer requests refund then vendor can approve it',
      () async {
        final vendorAuth = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'Vendor User',
        );
        final customerAuth = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'Customer User',
        );

        final setupSession = sessionBuilder.build();
        final seeded = await seedProductForUser(
          setupSession,
          vendorAuth.profile,
        );
        await User.db.updateRow(
          setupSession,
          vendorAuth.profile.copyWith(
            role: UserRole.vendor,
            status: UserAccountStatus.approved,
          ),
        );
        final order = await seedOrderForUser(
          setupSession,
          customerAuth.profile,
          seeded.product,
        );
        await PaymentTransaction.db.insertRow(
          setupSession,
          PaymentTransaction(
            orderId: order.id!,
            userId: customerAuth.profile.id!,
            provider: 'cod',
            providerTransactionId: 'cod-${order.id}',
            amount: order.totalAmount,
            paymentMethod: PaymentMethod.cashOnDelivery,
            status: PaymentTransactionStatus.paid,
          ),
        );
        await setupSession.close();

        final refund = await endpoints.refund.createRefundRequest(
          customerAuth.session,
          order.id!,
          'Wrong size delivered',
        );

        final pending = await endpoints.vendor.listPendingRefundRequests(
          vendorAuth.session,
        );
        expect(pending, hasLength(1));
        expect(pending.first.id, refund.id);

        final approved = await endpoints.vendor.approveRefundRequest(
          vendorAuth.session,
          refund.id,
        );
        expect(approved.status.name, 'completed');

        final verifySession = sessionBuilder.build();
        final updatedOrder = await Order.db.findById(verifySession, order.id!);
        await verifySession.close();
        expect(updatedOrder?.status, OrderStatus.refunded);

        final after = await endpoints.vendor.listPendingRefundRequests(
          vendorAuth.session,
        );
        expect(after, isEmpty);
      },
    );

    test(
      'when vendor rejects refund then order returns to delivered',
      () async {
        final vendorAuth = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'Vendor Reject',
        );
        final customerAuth = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'Customer Reject',
        );

        final setupSession = sessionBuilder.build();
        final seeded = await seedProductForUser(
          setupSession,
          vendorAuth.profile,
        );
        await User.db.updateRow(
          setupSession,
          vendorAuth.profile.copyWith(
            role: UserRole.vendor,
            status: UserAccountStatus.approved,
          ),
        );
        final order = await seedOrderForUser(
          setupSession,
          customerAuth.profile,
          seeded.product,
        );
        await setupSession.close();

        final refund = await endpoints.refund.createRefundRequest(
          customerAuth.session,
          order.id!,
          'Changed mind',
        );

        final rejected = await endpoints.vendor.rejectRefundRequest(
          vendorAuth.session,
          refund.id,
          reason: 'Item was not defective',
        );
        expect(rejected.status.name, 'rejected');
        expect(rejected.rejectionReason, 'Item was not defective');

        final verifySession = sessionBuilder.build();
        final updatedOrder = await Order.db.findById(verifySession, order.id!);
        await verifySession.close();
        expect(updatedOrder?.status, OrderStatus.delivered);
      },
    );
  });
}
