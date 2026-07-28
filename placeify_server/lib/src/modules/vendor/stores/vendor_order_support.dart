import 'package:serverpod/serverpod.dart' hide Order;

import '../../../generated/protocol.dart';
import '../../../shared/order_display_number.dart';

/// Shared order queries and grouping used by vendor order and delivery stores.
abstract final class VendorOrderSupport {
  static Future<Order> requireMutableVendorOrder(
    Session session,
    UuidValue vendorId,
    int orderId,
  ) async {
    await assertVendorOwnsOrder(session, vendorId, orderId);

    final order = await Order.db.findById(
      session,
      orderId,
    );

    if (order == null) {
      throw PlaceifyException(
        message: 'Order not found.',
        code: 'ORDER_NOT_FOUND',
      );
    }

    return order;
  }

  static Future<void> assertVendorOwnsOrder(
    Session session,
    UuidValue vendorId,
    int orderId,
  ) async {
    final ownsOrder = await OrderItem.db.findFirstRow(
      session,
      where: (row) =>
          row.vendorId.equals(vendorId) & row.orderId.equals(orderId),
    );

    if (ownsOrder == null) {
      throw PlaceifyException(
        message: 'Order not found.',
        code: 'ORDER_NOT_FOUND',
      );
    }
  }

  static Future<List<OrderDeliveryUpdate>> deliveryUpdatesFor(
    Session session,
    UuidValue vendorId,
    int orderId,
  ) {
    return OrderDeliveryUpdate.db.find(
      session,
      where: (row) =>
          row.vendorId.equals(vendorId) & row.orderId.equals(orderId),
      orderBy: (row) => row.createdAt,
    );
  }

  /// Returns the next allowed delivery stage.
  static DeliveryStage? nextDeliveryStage(
    List<OrderDeliveryUpdate> existing,
  ) {
    if (existing.isEmpty) {
      return DeliveryStage.orderPlaced;
    }

    final latest = existing.reduce(
      (a, b) => a.createdAt.isAfter(b.createdAt) ? a : b,
    );

    return switch (latest.stage) {
      DeliveryStage.orderPlaced => DeliveryStage.packed,
      DeliveryStage.packed => DeliveryStage.shipped,
      DeliveryStage.shipped => DeliveryStage.outForDelivery,
      DeliveryStage.outForDelivery => DeliveryStage.delivered,
      DeliveryStage.delivered => null,
      DeliveryStage.rejected => null,
    };
  }

  static String stageLabel(
    DeliveryStage stage,
  ) {
    return switch (stage) {
      DeliveryStage.orderPlaced => 'Order placed',
      DeliveryStage.packed => 'Packed',
      DeliveryStage.shipped => 'Shipped',
      DeliveryStage.outForDelivery => 'Out for delivery',
      DeliveryStage.delivered => 'Delivered',
      DeliveryStage.rejected => 'Rejected',
    };
  }

  static Future<Map<int, DeliveryStage>> latestDeliveryStagesForOrders(
    Session session,
    UuidValue vendorId,
    Set<int> orderIds,
  ) async {
    if (orderIds.isEmpty) {
      return const {};
    }

    final updates = await OrderDeliveryUpdate.db.find(
      session,
      where: (row) => row.vendorId.equals(vendorId),
      orderBy: (row) => row.createdAt,
    );

    final latestUpdates = <int, OrderDeliveryUpdate>{};

    for (final update in updates) {
      if (!orderIds.contains(update.orderId)) {
        continue;
      }

      final previous = latestUpdates[update.orderId];

      if (previous == null || update.createdAt.isAfter(previous.createdAt)) {
        latestUpdates[update.orderId] = update;
      }
    }

    return {
      for (final entry in latestUpdates.entries) entry.key: entry.value.stage,
    };
  }

  static VendorShopOrder withDeliveryStage(
    VendorShopOrder order,
    DeliveryStage? stage,
  ) {
    if (stage == null) {
      return order;
    }

    return order.copyWith(
      currentDeliveryStage: stage,
    );
  }

  static Future<List<OrderItem>> loadVendorOrderItems(
    Session session,
    UuidValue vendorId,
  ) {
    return OrderItem.db.find(
      session,
      where: (row) => row.vendorId.equals(vendorId),
      include: OrderItem.include(
        order: Order.include(
          user: User.include(),
        ),
        product: Product.include(),
      ),
      orderDescending: true,
      orderBy: (row) => row.id,
    );
  }

  static List<VendorShopOrder> groupVendorShopOrders(
    List<OrderItem> orderItems,
  ) {
    final grouped = <int, List<OrderItem>>{};

    for (final item in orderItems) {
      grouped.putIfAbsent(item.orderId, () => []).add(item);
    }

    final orders = <VendorShopOrder>[];

    for (final entry in grouped.entries) {
      final items = entry.value;

      final order = items.first.order;

      if (order == null) {
        continue;
      }

      final lineItems = <VendorOrderLineItem>[
        for (final item in items)
          if (item.id != null)
            VendorOrderLineItem(
              orderItemId: item.id!,
              productId: item.productId,
              productName: item.product?.name ?? 'Product',
              quantity: item.quantity,
              unitPrice: item.unitPrice,
              lineTotal: item.unitPrice * item.quantity,
              thumbnailUrl: item.product?.thumbnailUrl,
            ),
      ];

      final vendorTotal = lineItems.fold<double>(
        0,
        (sum, item) => sum + item.lineTotal,
      );

      final itemCount = lineItems.fold<int>(
        0,
        (sum, item) => sum + item.quantity,
      );

      orders.add(
        VendorShopOrder(
          orderId: entry.key,
          orderNumber: OrderDisplayNumber.format(entry.key),
          status: order.status,
          placedAt: order.placedAt,
          customerName: order.user?.name ?? 'Customer',
          shippingAddress: order.shippingAddress,
          vendorTotal: vendorTotal,
          itemCount: itemCount,
          items: lineItems,
          rejectionReason: order.rejectionReason,
          orderPaymentStatus: order.paymentStatus,
          currentDeliveryStage: null,
        ),
      );
    }

    orders.sort(
      (a, b) => b.placedAt.compareTo(a.placedAt),
    );

    return orders;
  }
}
