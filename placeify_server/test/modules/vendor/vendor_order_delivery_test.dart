import 'package:placeify_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  group('Vendor order delivery stages', () {
    test('defines all delivery stages used by the vendor delivery UI', () {
      expect(
        DeliveryStage.values,
        [
          DeliveryStage.orderPlaced,
          DeliveryStage.packed,
          DeliveryStage.shipped,
          DeliveryStage.outForDelivery,
          DeliveryStage.delivered,
          DeliveryStage.rejected,
        ],
      );
    });

    test('includes vendor workflow statuses on the server order enum', () {
      expect(OrderStatus.values, contains(OrderStatus.accepted));
      expect(OrderStatus.values, contains(OrderStatus.rejected));
      expect(OrderStatus.values, contains(OrderStatus.processing));
    });
  });
}
