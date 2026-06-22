import 'package:placeify_server/src/generated/protocol.dart';
import 'package:placeify_server/src/modules/order/order_auto_cancel_service.dart';
import 'package:serverpod/serverpod.dart' hide Order;
import 'package:test/test.dart';

void main() {
  group('OrderAutoCancelService', () {
    final service = OrderAutoCancelService();
    final userId = UuidValue.fromString('00000000-0000-0000-0000-000000000001');

    test('shouldCancel returns true when pending order expired', () async {
      final now = DateTime(2026, 6, 22);
      final order = Order(
        userId: userId,
        status: OrderStatus.pending,
        totalAmount: 100,
        shippingAddress: 'Kathmandu',
        autoExpiresAt: now.subtract(const Duration(days: 1)),
        placedAt: now.subtract(const Duration(days: 31)),
      );

      expect(await service.shouldCancel(order, now), isTrue);
    });

    test('shouldCancel returns false before autoExpiresAt', () async {
      final now = DateTime(2026, 6, 22);
      final order = Order(
        userId: userId,
        status: OrderStatus.pending,
        totalAmount: 100,
        shippingAddress: 'Kathmandu',
        autoExpiresAt: now.add(const Duration(days: 5)),
        placedAt: now.subtract(const Duration(days: 25)),
      );

      expect(await service.shouldCancel(order, now), isFalse);
    });

    test('shouldCancel ignores non-pending orders', () async {
      final now = DateTime(2026, 6, 22);
      final order = Order(
        userId: userId,
        status: OrderStatus.accepted,
        totalAmount: 100,
        shippingAddress: 'Kathmandu',
        autoExpiresAt: now.subtract(const Duration(days: 1)),
        placedAt: now.subtract(const Duration(days: 31)),
      );

      expect(await service.shouldCancel(order, now), isFalse);
    });
  });
}
