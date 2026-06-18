import 'package:placeify_server/src/generated/protocol.dart' hide Order;
import 'package:placeify_server/src/generated/order.dart' as models;
import 'package:placeify_server/src/modules/vendor/vendor_sales_metrics.dart';
import 'package:serverpod/serverpod.dart' hide Order;
import 'package:test/test.dart';

OrderItem _item({
  required int id,
  required int orderId,
  required OrderStatus status,
  required int productId,
  required int quantity,
  required double unitPrice,
}) {
  return OrderItem(
    id: id,
    orderId: orderId,
    order: models.Order(
      id: orderId,
      userId: UuidValue.fromString('01930000-0000-7000-8000-000000000099'),
      status: status,
      totalAmount: unitPrice * quantity,
      shippingAddress: 'Test address',
      placedAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    ),
    productId: productId,
    vendorId: UuidValue.fromString('01930000-0000-7000-8000-000000000001'),
    quantity: quantity,
    unitPrice: unitPrice,
  );
}

void main() {
  group('VendorSalesMetricsCalculator', () {
    test('counts only delivered orders and line revenue', () {
      final items = [
        _item(
          id: 1,
          orderId: 100,
          status: OrderStatus.delivered,
          productId: 1,
          quantity: 2,
          unitPrice: 50,
        ),
        _item(
          id: 2,
          orderId: 100,
          status: OrderStatus.delivered,
          productId: 2,
          quantity: 1,
          unitPrice: 30,
        ),
        _item(
          id: 3,
          orderId: 101,
          status: OrderStatus.pending,
          productId: 3,
          quantity: 1,
          unitPrice: 999,
        ),
        _item(
          id: 4,
          orderId: 102,
          status: OrderStatus.cancelled,
          productId: 4,
          quantity: 1,
          unitPrice: 200,
        ),
      ];

      final metrics = VendorSalesMetricsCalculator.compute(
        orderItems: items,
        completedRefundOrderIds: {},
      );

      expect(metrics.grossRevenue, 130);
      expect(metrics.netRevenue, 130);
      expect(metrics.deliveredOrderCount, 1);
      expect(metrics.deliveredItems, hasLength(2));
    });

    test('uses distinct order count when vendor has multiple delivered orders', () {
      final items = [
        _item(
          id: 1,
          orderId: 200,
          status: OrderStatus.delivered,
          productId: 1,
          quantity: 1,
          unitPrice: 40,
        ),
        _item(
          id: 2,
          orderId: 201,
          status: OrderStatus.delivered,
          productId: 2,
          quantity: 1,
          unitPrice: 60,
        ),
        _item(
          id: 3,
          orderId: 202,
          status: OrderStatus.shipped,
          productId: 3,
          quantity: 1,
          unitPrice: 500,
        ),
      ];

      final metrics = VendorSalesMetricsCalculator.compute(
        orderItems: items,
        completedRefundOrderIds: {},
      );

      expect(metrics.deliveredOrderCount, 2);
      expect(metrics.grossRevenue, 100);
    });

    test('subtracts vendor line totals for completed refunds', () {
      final items = [
        _item(
          id: 1,
          orderId: 300,
          status: OrderStatus.delivered,
          productId: 1,
          quantity: 2,
          unitPrice: 50,
        ),
        _item(
          id: 2,
          orderId: 301,
          status: OrderStatus.delivered,
          productId: 2,
          quantity: 1,
          unitPrice: 80,
        ),
      ];

      final metrics = VendorSalesMetricsCalculator.compute(
        orderItems: items,
        completedRefundOrderIds: {300},
      );

      expect(metrics.grossRevenue, 180);
      expect(metrics.refundDeductions, 100);
      expect(metrics.netRevenue, 80);
      expect(metrics.deliveredOrderCount, 2);
    });

    test('ignores pending refunds and non-delivered refunded orders', () {
      final items = [
        _item(
          id: 1,
          orderId: 400,
          status: OrderStatus.pending,
          productId: 1,
          quantity: 1,
          unitPrice: 120,
        ),
      ];

      final metrics = VendorSalesMetricsCalculator.compute(
        orderItems: items,
        completedRefundOrderIds: {400},
      );

      expect(metrics.grossRevenue, 0);
      expect(metrics.refundDeductions, 0);
      expect(metrics.netRevenue, 0);
      expect(metrics.deliveredOrderCount, 0);
    });

    test('never returns negative net revenue', () {
      final items = [
        _item(
          id: 1,
          orderId: 500,
          status: OrderStatus.delivered,
          productId: 1,
          quantity: 1,
          unitPrice: 25,
        ),
      ];

      final metrics = VendorSalesMetricsCalculator.compute(
        orderItems: items,
        completedRefundOrderIds: {500, 501},
      );

      expect(metrics.netRevenue, 0);
    });
  });
}
