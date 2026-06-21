import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';

class UserOrderStore {
  Future<List<UserOrderSummary>> listSummaries(
    Session session,
    UuidValue userId, {
    int limit = 20,
    int offset = 0,
    OrderStatus? status,
  }) async {
    final orders = await Order.db.find(
      session,
      where: (order) {
        var expression = order.userId.equals(userId);
        if (status != null) {
          expression = expression & order.status.equals(status);
        }
        return expression;
      },
      orderBy: (order) => order.placedAt,
      orderDescending: true,
      limit: limit,
      offset: offset,
    );

    final summaries = <UserOrderSummary>[];
    for (final order in orders) {
      final orderId = order.id;
      if (orderId == null) continue;

      final items = await OrderItem.db.find(
        session,
        where: (item) => item.orderId.equals(orderId),
        include: OrderItem.include(product: Product.include()),
      );

      final latestDelivery = await _latestDeliveryUpdate(session, orderId);

      summaries.add(
        _buildSummary(
          order: order,
          items: items,
          latestDeliveryStage: latestDelivery?.stage,
          latestDeliveryNote: latestDelivery?.note,
        ),
      );
    }

    return summaries;
  }

  Future<UserOrderDetail> getDetail(
    Session session,
    UuidValue userId,
    int orderId,
  ) async {
    final order = await Order.db.findById(session, orderId);
    if (order == null || order.userId != userId) {
      throw PlaceifyException(
        message: 'Order not found.',
        code: 'NOT_FOUND',
      );
    }

    final items = await OrderItem.db.find(
      session,
      where: (item) => item.orderId.equals(orderId),
      include: OrderItem.include(product: Product.include()),
    );

    final deliveryRows = await OrderDeliveryUpdate.db.find(
      session,
      where: (row) => row.orderId.equals(orderId),
      orderBy: (row) => row.createdAt,
    );

    final latestDelivery = _pickLatestDeliveryUpdate(deliveryRows);
    final summary = _buildSummary(
      order: order,
      items: items,
      latestDeliveryStage: latestDelivery?.stage,
      latestDeliveryNote: latestDelivery?.note,
    );

    return UserOrderDetail(
      id: summary.id,
      orderNumber: summary.orderNumber,
      status: summary.status,
      totalAmount: summary.totalAmount,
      placedAt: summary.placedAt,
      shippingAddress: order.shippingAddress,
      itemCount: summary.itemCount,
      primaryProductName: summary.primaryProductName,
      latestDeliveryStage: summary.latestDeliveryStage,
      latestDeliveryNote: summary.latestDeliveryNote,
      items: [
        for (final item in items)
          UserOrderLineItem(
            productId: item.productId,
            productName: item.product?.name ?? 'Product',
            quantity: item.quantity,
            unitPrice: item.unitPrice,
            lineTotal: item.unitPrice * item.quantity,
            thumbnailUrl: item.product?.thumbnailUrl,
          ),
      ],
      deliveryUpdates: [
        for (final update in deliveryRows)
          UserOrderDeliveryEvent(
            stage: update.stage,
            note: update.note,
            createdAt: update.createdAt,
          ),
      ],
    );
  }

  Future<OrderDeliveryUpdate?> _latestDeliveryUpdate(
    Session session,
    int orderId,
  ) async {
    final updates = await OrderDeliveryUpdate.db.find(
      session,
      where: (row) => row.orderId.equals(orderId),
      orderBy: (row) => row.createdAt,
      orderDescending: true,
      limit: 1,
    );
    if (updates.isEmpty) return null;
    return updates.first;
  }

  OrderDeliveryUpdate? _pickLatestDeliveryUpdate(
    List<OrderDeliveryUpdate> updates,
  ) {
    if (updates.isEmpty) return null;

    return updates.reduce(
      (latest, current) =>
          current.createdAt.isAfter(latest.createdAt) ? current : latest,
    );
  }

  UserOrderSummary _buildSummary({
    required Order order,
    required List<OrderItem> items,
    DeliveryStage? latestDeliveryStage,
    String? latestDeliveryNote,
  }) {
    final orderId = order.id!;
    final primaryName = items.isEmpty
        ? null
        : items.first.product?.name ?? 'Order item';
    final totalQuantity =
        items.fold<int>(0, (sum, item) => sum + item.quantity);
    final displayName = primaryName == null
        ? null
        : totalQuantity > 1
            ? '$primaryName × $totalQuantity'
            : primaryName;

    return UserOrderSummary(
      id: orderId,
      orderNumber: orderId.toString().padLeft(5, '0'),
      status: order.status,
      totalAmount: order.totalAmount,
      placedAt: order.placedAt,
      itemCount: totalQuantity,
      primaryProductName: displayName,
      latestDeliveryStage: latestDeliveryStage,
      latestDeliveryNote: latestDeliveryNote,
    );
  }
}
