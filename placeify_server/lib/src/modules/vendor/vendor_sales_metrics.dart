import '../../generated/protocol.dart';

/// Aggregated vendor sales figures used by profile and dashboard APIs.
class VendorSalesMetrics {
  const VendorSalesMetrics({
    required this.grossRevenue,
    required this.refundDeductions,
    required this.netRevenue,
    required this.deliveredOrderCount,
    required this.deliveredItems,
  });

  /// Revenue from delivered orders before refunds.
  final double grossRevenue;

  /// Vendor line totals removed for completed refunds.
  final double refundDeductions;

  /// Recognized revenue after completed refunds.
  final double netRevenue;

  /// Distinct delivered orders for this vendor.
  final int deliveredOrderCount;

  /// Delivered line items used for product performance rollups.
  final List<OrderItem> deliveredItems;
}

/// Pure sales calculations — easy to unit test without a database.
abstract final class VendorSalesMetricsCalculator {
  static List<OrderItem> deliveredItems(List<OrderItem> items) {
    return [
      for (final item in items)
        if (item.order?.status == OrderStatus.delivered) item,
    ];
  }

  static double grossRevenue(List<OrderItem> delivered) {
    return delivered.fold<double>(
      0,
      (sum, item) => sum + item.unitPrice * item.quantity,
    );
  }

  static int deliveredOrderCount(List<OrderItem> delivered) {
    return delivered.map((item) => item.orderId).toSet().length;
  }

  /// Subtracts this vendor's delivered line totals for refunded orders.
  static double refundDeductions({
    required List<OrderItem> delivered,
    required Set<int> refundedOrderIds,
  }) {
    var deductions = 0.0;
    for (final orderId in refundedOrderIds) {
      for (final item in delivered) {
        if (item.orderId == orderId) {
          deductions += item.unitPrice * item.quantity;
        }
      }
    }
    return deductions;
  }

  static VendorSalesMetrics compute({
    required List<OrderItem> orderItems,
    required Set<int> completedRefundOrderIds,
  }) {
    final delivered = deliveredItems(orderItems);
    final gross = grossRevenue(delivered);
    final deductions = refundDeductions(
      delivered: delivered,
      refundedOrderIds: completedRefundOrderIds,
    );
    final net = (gross - deductions).clamp(0.0, double.infinity);

    return VendorSalesMetrics(
      grossRevenue: gross,
      refundDeductions: deductions,
      netRevenue: net,
      deliveredOrderCount: deliveredOrderCount(delivered),
      deliveredItems: delivered,
    );
  }
}
