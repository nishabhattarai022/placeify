import 'package:placeify_server/src/generated/protocol.dart';
import 'package:placeify_server/src/modules/payment/esewa_refund_service.dart';
import 'package:placeify_server/src/modules/payment/esewa_status_api.dart';
import 'package:placeify_server/src/shared/placeify_exception.dart';
import 'package:serverpod/serverpod.dart' hide Order;
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_tools/user_test_helpers.dart';

void main() {
  withServerpod('Given eSewa Mode B refunds', (sessionBuilder, endpoints) {
    Future<
        ({
          AuthenticatedTestSession vendorSession,
          User vendorProfile,
          Order order,
          RefundRequestSummary refund,
        })> seedEsewaRefund() async {
      final vendorAuth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'Vendor Esewa',
      );
      final customerAuth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'Customer Esewa',
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
          provider: 'esewa',
          providerTransactionId: 'esewa-uuid-${order.id}',
          amount: order.totalAmount,
          paymentMethod: PaymentMethod.esewa,
          status: PaymentTransactionStatus.paid,
        ),
      );
      await setupSession.close();

      final refund = await endpoints.refund.createRefundRequest(
        customerAuth.session,
        order.id!,
        'eSewa Mode B test',
      );

      return (
        vendorSession: vendorAuth.session,
        vendorProfile: vendorAuth.profile,
        order: order,
        refund: refund,
      );
    }

    Future<EsewaTransactionStatusResult> fakeStatus(
      String status, {
      String? refId,
    }) async {
      return EsewaTransactionStatusResult(
        status: status,
        rawBody: '{"status":"$status"}',
        refId: refId,
      );
    }

    test(
      'when eSewa refund is approved then payment parks refundPending and order stays returnRequested',
      () async {
        final seeded = await seedEsewaRefund();

        final approved = await endpoints.vendor.approveRefundRequest(
          seeded.vendorSession,
          seeded.refund.id,
        );
        expect(approved.status, RequestStatus.inProgress);

        final verify = sessionBuilder.build();
        final payment = await PaymentTransaction.db.findFirstRow(
          verify,
          where: (tx) => tx.orderId.equals(seeded.order.id!),
        );
        final order = await Order.db.findById(verify, seeded.order.id!);
        final row = await RefundRequest.db.findById(verify, seeded.refund.id);
        await verify.close();

        expect(payment?.status, PaymentTransactionStatus.refundPending);
        expect(order?.status, OrderStatus.returnRequested);
        expect(row?.status, RequestStatus.inProgress);
        expect(
          row?.settlementMode,
          EsewaRefundService.settlementModeManualPortal,
        );
        expect(row?.gatewayStatus, 'unavailable');
      },
    );

    test(
      'when approve is called again while inProgress then settlement is idempotent',
      () async {
        final seeded = await seedEsewaRefund();
        await endpoints.vendor.approveRefundRequest(
          seeded.vendorSession,
          seeded.refund.id,
        );

        final again = await endpoints.vendor.approveRefundRequest(
          seeded.vendorSession,
          seeded.refund.id,
        );
        expect(again.status, RequestStatus.inProgress);

        final verify = sessionBuilder.build();
        final payment = await PaymentTransaction.db.findFirstRow(
          verify,
          where: (tx) => tx.orderId.equals(seeded.order.id!),
        );
        await verify.close();
        expect(payment?.status, PaymentTransactionStatus.refundPending);
      },
    );

    test(
      'when status is FULL_REFUND then settlement completes',
      () async {
        final seeded = await seedEsewaRefund();
        await endpoints.vendor.approveRefundRequest(
          seeded.vendorSession,
          seeded.refund.id,
        );

        final session = sessionBuilder.build();
        final completed = await EsewaRefundService.checkAndMaybeComplete(
          session,
          seeded.refund.id,
          actorUserId: seeded.vendorProfile.id,
          statusFetcher: ({
            required Session session,
            required double amount,
            required String transactionUuid,
            httpClient,
          }) =>
              fakeStatus('FULL_REFUND', refId: 'RF-1'),
        );
        final payment = await PaymentTransaction.db.findFirstRow(
          session,
          where: (tx) => tx.orderId.equals(seeded.order.id!),
        );
        final order = await Order.db.findById(session, seeded.order.id!);
        await session.close();

        expect(completed.status, RequestStatus.completed);
        expect(completed.refundCompletedAt, isNotNull);
        expect(completed.gatewayReference, 'RF-1');
        expect(payment?.status, PaymentTransactionStatus.refunded);
        expect(order?.status, OrderStatus.refunded);
      },
    );

    test(
      'when status is COMPLETE then refund stays inProgress with gateway fields updated',
      () async {
        final seeded = await seedEsewaRefund();
        await endpoints.vendor.approveRefundRequest(
          seeded.vendorSession,
          seeded.refund.id,
        );

        final session = sessionBuilder.build();
        final updated = await EsewaRefundService.checkAndMaybeComplete(
          session,
          seeded.refund.id,
          statusFetcher: ({
            required Session session,
            required double amount,
            required String transactionUuid,
            httpClient,
          }) =>
              fakeStatus('COMPLETE', refId: 'RF-KEEP'),
        );
        final payment = await PaymentTransaction.db.findFirstRow(
          session,
          where: (tx) => tx.orderId.equals(seeded.order.id!),
        );
        final order = await Order.db.findById(session, seeded.order.id!);
        await session.close();

        expect(updated.status, RequestStatus.inProgress);
        expect(updated.gatewayStatus, 'COMPLETE');
        expect(updated.gatewayReference, 'RF-KEEP');
        expect(payment?.status, PaymentTransactionStatus.refundPending);
        expect(order?.status, OrderStatus.returnRequested);
      },
    );

    test(
      'when requireFullRefund and status is COMPLETE then complete throws',
      () async {
        final seeded = await seedEsewaRefund();
        await endpoints.vendor.approveRefundRequest(
          seeded.vendorSession,
          seeded.refund.id,
        );

        final session = sessionBuilder.build();
        await expectLater(
          EsewaRefundService.checkAndMaybeComplete(
            session,
            seeded.refund.id,
            requireFullRefundToComplete: true,
            statusFetcher: ({
              required Session session,
              required double amount,
              required String transactionUuid,
              httpClient,
            }) =>
                fakeStatus('COMPLETE'),
          ),
          throwsA(
            isA<PlaceifyException>().having(
              (e) => e.code,
              'code',
              'ESEWA_REFUND_NOT_CONFIRMED',
            ),
          ),
        );
        await session.close();
      },
    );

    test(
      'when initiate is not configured then initiateRefund returns unavailable',
      () async {
        final session = sessionBuilder.build();
        expect(EsewaRefundService.isInitiateConfigured(session), isFalse);

        final payment = PaymentTransaction(
          orderId: 1,
          userId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
          provider: 'esewa',
          providerTransactionId: 'x',
          amount: 10,
          paymentMethod: PaymentMethod.esewa,
          status: PaymentTransactionStatus.paid,
        );
        final refund = RefundRequest(
          orderId: 1,
          userId: payment.userId,
          reason: 't',
          refundAmount: 10,
          status: RequestStatus.pending,
        );
        final result = await EsewaRefundService.initiateRefund(
          session,
          payment: payment,
          refund: refund,
        );
        await session.close();

        expect(result.outcome, EsewaRefundInitiateOutcome.unavailable);
        expect(
          result.message,
          contains('Automatic eSewa refund is unavailable'),
        );
      },
    );
  });
}
