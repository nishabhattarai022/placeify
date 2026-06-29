import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';
import '../notification/order_notification_service.dart';
import '../order/order_lifecycle_store.dart';
import 'user_payment_store.dart';

class UserOrderStore {
  UserOrderStore({UserPaymentStore? paymentStore})
      : _paymentStore = paymentStore ?? UserPaymentStore();

  final UserPaymentStore _paymentStore;
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
    final payment =
        await _paymentStore.getPaymentSummary(session, userId, orderId);

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
      orderPaymentStatus: order.paymentStatus,
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
      payment: payment,
      paymentUpdates: await _paymentUpdatesForOrder(session, orderId),
    );
  }

  Future<List<UserOrderPaymentEvent>> _paymentUpdatesForOrder(
    Session session,
    int orderId,
  ) async {
    final history = await OrderStatusHistory.db.find(
      session,
      where: (row) =>
          row.orderId.equals(orderId) &
          row.statusType.equals(OrderStatusHistoryType.payment),
      orderBy: (row) => row.changedAt,
    );

    return [
      for (final row in history)
        UserOrderPaymentEvent(
          status: OrderPaymentStatus.fromJson(row.newStatus),
          note: row.note,
          createdAt: row.changedAt,
        ),
    ];
  }

  Future<UserOrderDetail> cancelOrder(
    Session session,
    UuidValue userId,
    int orderId,
    String reason,
  ) async {
    final trimmed = reason.trim();
    if (trimmed.isEmpty) {
      throw PlaceifyException(
        message: 'Select a cancellation reason.',
        code: 'INVALID_REASON',
      );
    }

    final order = await Order.db.findById(session, orderId);
    if (order == null || order.userId != userId) {
      throw PlaceifyException(
        message: 'Order not found.',
        code: 'NOT_FOUND',
      );
    }

    final cancellable = order.status == OrderStatus.pending;
    if (!cancellable) {
      throw PlaceifyException(
        message: 'This order can no longer be cancelled.',
        code: 'ORDER_NOT_CANCELLABLE',
      );
    }

    await session.db.transaction((transaction) async {
      await OrderLifecycleStore.updateOrderWithVersion(
        session,
        order,
        (current) => current.copyWith(
          status: OrderStatus.cancelled,
          rejectionReason: trimmed,
        ),
        transaction: transaction,
      );

      await OrderLifecycleStore.appendHistory(
        session,
        orderId,
        statusType: OrderStatusHistoryType.order,
        previousStatus: order.status.name,
        newStatus: OrderStatus.cancelled.name,
        changedByUserId: userId,
        note: trimmed,
        transaction: transaction,
      );

      final items = await OrderItem.db.find(
        session,
        where: (item) => item.orderId.equals(orderId),
        transaction: transaction,
      );
      final vendorIds = items.map((item) => item.vendorId).toSet();
      for (final vendorId in vendorIds) {
        await OrderNotificationService.notifyVendorOrderCancelled(
          session,
          order: order.copyWith(status: OrderStatus.cancelled),
          vendorId: vendorId,
          reason: trimmed,
        );
      }
    });

    return getDetail(session, userId, orderId);
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
      orderPaymentStatus: order.paymentStatus,
    );
  }
}
