import 'package:placeify_client/placeify_client.dart' hide Order, OrderItem;

import '../../../core/config/resolve_media_url.dart';
import '../domain/enums/consumer_order_status.dart';
import '../domain/enums/payment_status.dart';
import '../domain/models/order.dart';
import '../domain/models/order_item.dart';
import '../domain/models/order_payment_event.dart';
import '../domain/models/order_status_update.dart';

abstract final class OrderApiMapper {
  static Order fromSummary(UserOrderSummary summary, {required String userId}) {
    return Order(
      id: summary.id.toString(),
      orderNumber: summary.orderNumber,
      userId: userId,
      vendorId: '0',
      vendorName: summary.primaryProductName ?? 'Vendor',
      status: mapStatus(summary.status, latestStage: summary.latestDeliveryStage),
      items: [
        OrderItem(
          productId: summary.id.toString(),
          productName: summary.primaryProductName ?? 'Order item',
          productImageUrl: summary.primaryThumbnailUrl ?? '',
          brandName: '',
          sku: summary.orderNumber,
          unitPrice: summary.totalAmount,
          quantity: summary.itemCount.clamp(1, 999),
        ),
      ],
      statusHistory: const [],
      paymentUpdates: const [],
      placedAt: summary.placedAt,
      paymentStatus: mapOrderPaymentStatus(summary.orderPaymentStatus),
      paymentMethod: '',
      subtotal: summary.totalAmount,
      deliveryFee: 0,
      total: summary.totalAmount,
      deliveryAddress: '',
    );
  }

  static Order fromDetail(UserOrderDetail detail, {required String userId}) {
    final items = detail.items
        .map(
          (line) => OrderItem(
            productId: line.productId.toString(),
            productName: line.productName,
            productImageUrl: line.thumbnailUrl ?? '',
            brandName: '',
            sku: '${detail.orderNumber}-${line.productId}',
            unitPrice: line.unitPrice,
            quantity: line.quantity,
          ),
        )
        .toList();

    final subtotal = items.fold<double>(0, (sum, item) => sum + item.lineTotal);

    final payment = detail.payment;

    return Order(
      id: detail.id.toString(),
      orderNumber: detail.orderNumber,
      userId: userId,
      vendorId: '0',
      vendorName: detail.primaryProductName ?? 'Vendor',
      status: mapStatus(detail.status, latestStage: detail.latestDeliveryStage),
      items: items,
      statusHistory: _historyFromDetail(detail),
      paymentUpdates: _paymentHistoryFromDetail(detail),
      placedAt: detail.placedAt,
      deliveredAt: detail.status == OrderStatus.delivered
          ? _deliveredAt(detail)
          : null,
      paymentStatus: mapOrderPaymentStatus(detail.orderPaymentStatus),
      paymentMethod: paymentMethodLabel(payment.paymentMethod),
      subtotal: subtotal,
      deliveryFee: (detail.totalAmount - subtotal).clamp(0, double.infinity),
      total: detail.totalAmount,
      deliveryAddress: detail.shippingAddress,
    );
  }

  static DateTime? _deliveredAt(UserOrderDetail detail) {
    for (final event in detail.deliveryUpdates) {
      if (event.stage == DeliveryStage.delivered) {
        return event.createdAt;
      }
    }
    return null;
  }

  static PaymentStatus mapOrderPaymentStatus(OrderPaymentStatus status) {
    return switch (status) {
      OrderPaymentStatus.unpaid => PaymentStatus.pending,
      OrderPaymentStatus.paymentReceived => PaymentStatus.received,
      OrderPaymentStatus.paymentConfirmed => PaymentStatus.confirmed,
    };
  }

  static String paymentMethodLabel(PaymentMethod method) {
    return switch (method) {
      PaymentMethod.cod => 'Cash on delivery',
      PaymentMethod.mockOnline => 'Card (mock online)',
      PaymentMethod.esewa => 'eSewa',
      PaymentMethod.khalti => 'Khalti',
    };
  }

  static ConsumerOrderStatus mapStatus(
    OrderStatus status, {
    DeliveryStage? latestStage,
  }) {
    if (status == OrderStatus.cancelled ||
        status == OrderStatus.rejected ||
        status == OrderStatus.autoCancelled) {
      return ConsumerOrderStatus.cancelled;
    }
    if (status == OrderStatus.delivered) {
      return ConsumerOrderStatus.delivered;
    }
    if (status == OrderStatus.shipped) {
      return switch (latestStage) {
        DeliveryStage.outForDelivery => ConsumerOrderStatus.outForDelivery,
        DeliveryStage.shipped => ConsumerOrderStatus.inTransit,
        DeliveryStage.packed => ConsumerOrderStatus.dispatched,
        _ => ConsumerOrderStatus.inTransit,
      };
    }
    if (status == OrderStatus.processing) {
      return ConsumerOrderStatus.packed;
    }
    if (status == OrderStatus.accepted) {
      return ConsumerOrderStatus.confirmed;
    }
    if (status == OrderStatus.confirmed) {
      return ConsumerOrderStatus.placed;
    }
    return ConsumerOrderStatus.placed;
  }

  static ConsumerOrderStatus statusForDeliveryStage(DeliveryStage stage) {
    return switch (stage) {
      DeliveryStage.orderPlaced => ConsumerOrderStatus.confirmed,
      DeliveryStage.packed => ConsumerOrderStatus.packed,
      DeliveryStage.shipped => ConsumerOrderStatus.inTransit,
      DeliveryStage.outForDelivery => ConsumerOrderStatus.outForDelivery,
      DeliveryStage.delivered => ConsumerOrderStatus.delivered,
    };
  }

  static String deliveryStageLabel(DeliveryStage stage) {
    return switch (stage) {
      DeliveryStage.orderPlaced => 'Order accepted',
      DeliveryStage.packed => 'Packed',
      DeliveryStage.shipped => 'Shipped',
      DeliveryStage.outForDelivery => 'Out for delivery',
      DeliveryStage.delivered => 'Delivered',
    };
  }

  static List<OrderPaymentEvent> _paymentHistoryFromDetail(
    UserOrderDetail detail,
  ) {
    if (detail.paymentUpdates.isEmpty) return const [];

    return [
      for (final event in detail.paymentUpdates)
        OrderPaymentEvent(
          status: mapOrderPaymentStatus(event.status),
          timestamp: event.createdAt,
          note: event.note,
        ),
    ];
  }

  static List<OrderStatusUpdate> _historyFromDetail(UserOrderDetail detail) {
    if (detail.deliveryUpdates.isEmpty) return const [];

    final sorted = [...detail.deliveryUpdates]
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    return [
      for (final event in sorted)
        OrderStatusUpdate(
          status: statusForDeliveryStage(event.stage),
          timestamp: event.createdAt,
          note: event.note,
        ),
    ];
  }

  static Future<Order> withResolvedImages(Order order) async {
    final items = await Future.wait(
      order.items.map((item) async {
        final raw = item.productImageUrl.trim();
        if (raw.isEmpty ||
            raw.startsWith('http') ||
            raw.startsWith('assets/')) {
          return item;
        }
        final resolved = await resolveMediaUrl(raw);
        if (resolved.isEmpty) return item;
        return item.copyWith(productImageUrl: resolved);
      }),
    );
    return order.copyWith(items: items);
  }
}
