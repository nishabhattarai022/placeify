import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../../shared/order_display_number.dart';
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

    if (orders.isEmpty) return const [];

    final orderIds = <int>[
      for (final order in orders)
        if (order.id != null) order.id!,
    ];
    if (orderIds.isEmpty) return const [];

    final allItems = await OrderItem.db.find(
      session,
      where: (item) => item.orderId.inSet(orderIds.toSet()),
      include: OrderItem.include(
        product: Product.include(vendor: Vendor.include()),
      ),
    );
    final itemsByOrderId = <int, List<OrderItem>>{};
    for (final item in allItems) {
      itemsByOrderId.putIfAbsent(item.orderId, () => []).add(item);
    }

    final allDeliveries = await OrderDeliveryUpdate.db.find(
      session,
      where: (row) => row.orderId.inSet(orderIds.toSet()),
      orderBy: (row) => row.createdAt,
      orderDescending: true,
    );
    final latestDeliveryByOrderId = <int, OrderDeliveryUpdate>{};
    final deliveredAtByOrderId = <int, DateTime>{};
    for (final update in allDeliveries) {
      latestDeliveryByOrderId.putIfAbsent(update.orderId, () => update);
      if (update.stage == DeliveryStage.delivered) {
        deliveredAtByOrderId.putIfAbsent(update.orderId, () => update.createdAt);
      }
    }

    return [
      for (final order in orders)
        if (order.id != null)
          _buildSummary(
            order: order,
            items: itemsByOrderId[order.id!] ?? const [],
            latestDeliveryStage: latestDeliveryByOrderId[order.id!]?.stage,
            latestDeliveryNote: latestDeliveryByOrderId[order.id!]?.note,
            deliveredAt: deliveredAtByOrderId[order.id!],
          ),
    ];
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
      include: OrderItem.include(
        product: Product.include(vendor: Vendor.include()),
      ),
    );

    final deliveryRows = await OrderDeliveryUpdate.db.find(
      session,
      where: (row) => row.orderId.equals(orderId),
      orderBy: (row) => row.createdAt,
    );

    final latestDelivery = _pickLatestDeliveryUpdate(deliveryRows);
    DateTime? deliveredAt;
    for (final row in deliveryRows.reversed) {
      if (row.stage == DeliveryStage.delivered) {
        deliveredAt = row.createdAt;
        break;
      }
    }
    final summary = _buildSummary(
      order: order,
      items: items,
      latestDeliveryStage: latestDelivery?.stage,
      latestDeliveryNote: latestDelivery?.note,
      deliveredAt: deliveredAt,
    );
    final payment = await _paymentStore.getPaymentSummary(
      session,
      userId,
      orderId,
    );
    final customer = await User.db.findById(session, userId);
    final primaryItem = items.isEmpty ? null : items.first;
    final primaryVendorName = primaryItem?.product?.vendor?.shopName;

    return UserOrderDetail(
      id: summary.id,
      orderNumber: summary.orderNumber,
      status: summary.status,
      totalAmount: summary.totalAmount,
      placedAt: summary.placedAt,
      shippingAddress: order.shippingAddress,
      itemCount: summary.itemCount,
      primaryProductName: summary.primaryProductName,
      vendorId: primaryItem?.vendorId,
      vendorName: primaryVendorName,
      customerName: customer?.name,
      customerPhone: customer?.phone,
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
            thumbnailUrl: _productImageUrl(item.product),
            vendorId: item.vendorId,
            vendorName: item.product?.vendor?.shopName,
            listUnitPrice: _listUnitPrice(item.product, item.unitPrice),
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
          (row.statusType.equals(OrderStatusHistoryType.payment) |
              row.statusType.equals(OrderStatusHistoryType.order)),
      orderBy: (row) => row.changedAt,
    );

    return [
      for (final row in history)
        UserOrderPaymentEvent(
          status: _orderPaymentStatusFromHistory(row.newStatus),
          note: row.note,
          createdAt: row.changedAt,
          eventKey: row.newStatus,
          displayLabel: _timelineLabel(row.statusType, row.newStatus, row.note),
        ),
    ];
  }

  static OrderPaymentStatus _orderPaymentStatusFromHistory(String raw) {
    return switch (raw) {
      'paymentReceived' ||
      'paymentConfirmed' ||
      'paid' => OrderPaymentStatus.paymentReceived,
      'unpaid' ||
      'pending' ||
      'failed' ||
      'cancelled' ||
      'refundPending' ||
      'refunded' => OrderPaymentStatus.unpaid,
      _ => OrderPaymentStatus.unpaid,
    };
  }

  static String _timelineLabel(
    OrderStatusHistoryType type,
    String newStatus,
    String? note,
  ) {
    final trimmed = note?.trim();
    if (type == OrderStatusHistoryType.payment) {
      final base = switch (newStatus) {
        'pending' => 'Payment Initiated',
        'paid' || 'paymentReceived' => 'Payment Completed',
        'paymentConfirmed' => 'Payment Confirmed',
        'refundPending' => 'Refund Pending',
        'refunded' => 'Refund Completed',
        'failed' => 'Payment Failed',
        'cancelled' => 'Payment Cancelled',
        _ => newStatus,
      };
      return base;
    }

    final base = switch (newStatus) {
      'pending' => 'Order Created',
      'confirmed' || 'accepted' => 'Vendor Accepted',
      'processing' => 'Processing',
      'shipped' => 'Shipped',
      'delivered' => 'Delivered',
      'rejected' => 'Vendor Rejected',
      'cancelled' || 'autoCancelled' => 'Order Cancelled',
      _ => newStatus,
    };
    if (trimmed != null && trimmed.isNotEmpty && newStatus == 'rejected') {
      return base;
    }
    return base;
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
    DateTime? deliveredAt,
  }) {
    final orderId = order.id!;
    final primaryProduct = items.isEmpty ? null : items.first.product;
    final primaryName = items.isEmpty
        ? null
        : primaryProduct?.name ?? 'Order item';
    final primaryThumbnail = _productImageUrl(primaryProduct);
    final totalQuantity = items.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );
    final displayName = primaryName == null
        ? null
        : totalQuantity > 1
        ? '$primaryName × $totalQuantity'
        : primaryName;

    return UserOrderSummary(
      id: orderId,
      orderNumber: OrderDisplayNumber.format(orderId),
      status: order.status,
      totalAmount: order.totalAmount,
      placedAt: order.placedAt,
      deliveredAt: deliveredAt,
      itemCount: totalQuantity,
      primaryProductName: displayName,
      primaryThumbnailUrl: primaryThumbnail,
      shippingAddress: order.shippingAddress,
      latestDeliveryStage: latestDeliveryStage,
      latestDeliveryNote: latestDeliveryNote,
      orderPaymentStatus: order.paymentStatus,
    );
  }

  /// Prefer product thumbnail; fall back to first extra view image.
  static String? _productImageUrl(Product? product) {
    if (product == null) return null;
    final thumb = product.thumbnailUrl?.trim();
    if (thumb != null && thumb.isNotEmpty) return thumb;
    final views = product.viewImageUrls;
    if (views == null || views.isEmpty) return null;
    for (final url in views) {
      final trimmed = url.trim();
      if (trimmed.isNotEmpty) return trimmed;
    }
    return null;
  }

  static double? _listUnitPrice(Product? product, double chargedUnitPrice) {
    if (product == null) return null;
    final list = product.price;
    if (list > chargedUnitPrice) return list;
    return null;
  }
}
