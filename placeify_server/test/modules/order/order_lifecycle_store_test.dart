import 'package:placeify_server/src/generated/protocol.dart';
import 'package:placeify_server/src/modules/order/order_lifecycle_store.dart';
import 'package:test/test.dart';

void main() {
  group('OrderLifecycleStore delivery transitions', () {
    test('allows first step from null to processing', () {
      expect(
        OrderLifecycleStore.canAdvanceDeliveryStatus(
          null,
          OrderDeliveryStatus.processing,
        ),
        isTrue,
      );
    });

    test('rejects backward delivery progression', () {
      expect(
        OrderLifecycleStore.canAdvanceDeliveryStatus(
          OrderDeliveryStatus.shipped,
          OrderDeliveryStatus.processing,
        ),
        isFalse,
      );

      expect(
        OrderLifecycleStore.canAdvanceDeliveryStatus(
          OrderDeliveryStatus.delivered,
          OrderDeliveryStatus.outForDelivery,
        ),
        isFalse,
      );
    });

    test('allows only the next forward delivery step', () {
      expect(
        OrderLifecycleStore.canAdvanceDeliveryStatus(
          OrderDeliveryStatus.processing,
          OrderDeliveryStatus.shipped,
        ),
        isTrue,
      );

      expect(
        OrderLifecycleStore.canAdvanceDeliveryStatus(
          OrderDeliveryStatus.processing,
          OrderDeliveryStatus.delivered,
        ),
        isFalse,
      );
    });
  });

  group('OrderLifecycleStore payment transitions', () {
    test('rejects backward payment progression', () {
      expect(
        OrderLifecycleStore.canAdvancePaymentStatus(
          OrderPaymentStatus.paymentConfirmed,
          OrderPaymentStatus.paymentReceived,
        ),
        isFalse,
      );
    });

    test('allows only the next forward payment step', () {
      expect(
        OrderLifecycleStore.canAdvancePaymentStatus(
          OrderPaymentStatus.unpaid,
          OrderPaymentStatus.paymentReceived,
        ),
        isTrue,
      );

      expect(
        OrderLifecycleStore.canAdvancePaymentStatus(
          OrderPaymentStatus.unpaid,
          OrderPaymentStatus.paymentConfirmed,
        ),
        isFalse,
      );
    });
  });
}
