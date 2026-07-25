import 'package:placeify_client/placeify_client.dart' hide Order, OrderItem;

import '../../../core/config/resolve_media_url.dart';
import '../../cart/data/product_id_codec.dart';
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
          productId: '',
          productName: summary.primaryProductName ?? 'Order item',
          productImageUrl: summary.primaryThumbnailUrl ?? '',
          brandName: '',
          sku: summary.orderNumber,
          unitPrice: summary.totalAmount,
          quantity: summary.itemCount.clamp(1, 999),
        ),
      ],
      statusHistory: const [],
      placedAt: summary.placedAt,
      deliveredAt: summary.deliveredAt,
      paymentStatus: mapOrderPaymentStatus(summary.orderPaymentStatus),
      paymentMethod: '',
      subtotal: summary.totalAmount,
      deliveryFee: 0,
      total: summary.totalAmount,
      deliveryAddress: summary.shippingAddress,
    );
  }

  static Order fromDetail(UserOrderDetail detail, {required String userId}) {
    final items = detail.items
        .map(
          (line) {
            final listPrice = line.listUnitPrice;
            final hasDiscount =
                listPrice != null && listPrice > line.unitPrice;
            return OrderItem(
              productId: ProductIdCodec.fromDatabaseId(line.productId),
              productName: line.productName,
              productImageUrl: line.thumbnailUrl ?? '',
              brandName: line.vendorName?.trim() ?? '',
              sku: '${detail.orderNumber}-${line.productId}',
              unitPrice: hasDiscount ? listPrice : line.unitPrice,
              discountedPrice: hasDiscount ? line.unitPrice : null,
              quantity: line.quantity,
            );
          },
        )
        .toList();

    final subtotal = items.fold<double>(0, (sum, item) => sum + item.lineTotal);

    final payment = detail.payment;

    final vendorId = detail.vendorId?.uuid ??
        (detail.items.isNotEmpty ? detail.items.first.vendorId?.uuid : null) ??
        '';
    final vendorName = detail.vendorName?.trim().isNotEmpty == true
        ? detail.vendorName!.trim()
        : detail.items
                .map((line) => line.vendorName?.trim())
                .whereType<String>()
                .where((name) => name.isNotEmpty)
                .firstOrNull ??
            'Vendor';

    return Order(
      id: detail.id.toString(),
      orderNumber: detail.orderNumber,
      userId: userId,
      vendorId: vendorId,
      vendorName: vendorName,
      status: mapStatus(detail.status, latestStage: detail.latestDeliveryStage),
      items: items,
      statusHistory: _historyFromDetail(detail),
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
      customerName: detail.customerName,
      customerPhone: detail.customerPhone,
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
      OrderPaymentStatus.paymentReceived => PaymentStatus.paid,
      OrderPaymentStatus.paymentConfirmed => PaymentStatus.paid,
    };
  }

  static String paymentMethodLabel(PaymentMethod method) {
    return switch (method) {
      PaymentMethod.cashOnDelivery => 'Cash on delivery',
      PaymentMethod.mockOnline => 'Card',
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
    if (status == OrderStatus.returnRequested) {
      return ConsumerOrderStatus.returnRequested;
    }
    if (status == OrderStatus.refunded) {
      return ConsumerOrderStatus.returned;
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
      DeliveryStage.rejected => ConsumerOrderStatus.cancelled,
    };
  }

  static String deliveryStageLabel(DeliveryStage stage) {
    return switch (stage) {
      DeliveryStage.orderPlaced => 'Order accepted',
      DeliveryStage.packed => 'Packed',
      DeliveryStage.shipped => 'Shipped',
      DeliveryStage.outForDelivery => 'Out for delivery',
      DeliveryStage.delivered => 'Delivered',
      DeliveryStage.rejected => 'Rejected',
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
