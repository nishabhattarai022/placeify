import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';

/// Creates vendor-visible delivery milestones when a customer places an order.
abstract final class CheckoutOrderSetup {
  static Future<void> notifyVendorsOfNewOrder(
    Session session,
    int orderId,
    Iterable<UuidValue> vendorIds,
  ) async {
    final uniqueVendorIds = vendorIds.toSet();
    for (final vendorId in uniqueVendorIds) {
      final existing = await OrderDeliveryUpdate.db.findFirstRow(
        session,
        where: (row) =>
            row.orderId.equals(orderId) & row.vendorId.equals(vendorId),
      );
      if (existing != null) continue;

      await OrderDeliveryUpdate.db.insertRow(
        session,
        OrderDeliveryUpdate(
          orderId: orderId,
          vendorId: vendorId,
          stage: DeliveryStage.orderPlaced,
          note: 'New order received — awaiting shop confirmation',
        ),
      );
    }
  }
}
