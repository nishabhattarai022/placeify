import 'package:placeify_client/placeify_client.dart' hide Order, OrderItem;

import '../domain/enums/consumer_order_status.dart';
import '../domain/enums/payment_status.dart';
import '../domain/models/order.dart';
import '../domain/models/order_item.dart';
import '../domain/models/order_status_update.dart';

abstract final class OrderApiMapper {
  static Order fromSummary(UserOrderSummary summary, {required String userId}) {
    return Order(
      id: summary.id.toString(),
      orderNumber: summary.orderNumber,
      userId: userId,
      vendorId: '0',
      vendorName: 'Placeify shop',
      status: mapStatus(summary.status, latestStage: summary.latestDeliveryStage),
      items: [
        OrderItem(
          productId: summary.id.toString(),
          productName: summary.primaryProductName ?? 'Order item',
          productImageUrl: '',
          brandName: 'Placeify',
          sku: summary.orderNumber,
          unitPrice: summary.totalAmount,
          quantity: summary.itemCount.clamp(1, 999),
        ),
      ],
      statusHistory: _historyFromSummary(summary),
      placedAt: summary.placedAt,
      paymentStatus: PaymentStatus.paid,
      paymentMethod: 'Online',
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
            brandName: 'Placeify',
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
      vendorName: 'Placeify shop',
      status: mapStatus(detail.status, latestStage: detail.latestDeliveryStage),
      items: items,
      statusHistory: _historyFromDetail(detail),
      placedAt: detail.placedAt,
      deliveredAt: detail.status == OrderStatus.delivered ? detail.placedAt : null,
      paymentStatus: mapPaymentStatus(payment.status),
      paymentMethod: paymentMethodLabel(payment.paymentMethod),
      subtotal: subtotal,
      deliveryFee: (detail.totalAmount - subtotal).clamp(0, double.infinity),
      total: detail.totalAmount,
      deliveryAddress: detail.shippingAddress,
    );
  }

  static PaymentStatus mapPaymentStatus(PaymentTransactionStatus status) {
    return switch (status) {
      PaymentTransactionStatus.pending => PaymentStatus.pending,
      PaymentTransactionStatus.succeeded => PaymentStatus.paid,
      PaymentTransactionStatus.failed => PaymentStatus.failed,
      PaymentTransactionStatus.refunded => PaymentStatus.refunded,
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
    if (status == OrderStatus.cancelled || status == OrderStatus.rejected) {
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
    if (status == OrderStatus.confirmed || status == OrderStatus.accepted) {
      return ConsumerOrderStatus.confirmed;
    }
    return ConsumerOrderStatus.placed;
  }

  static List<OrderStatusUpdate> _historyFromSummary(UserOrderSummary summary) {
    final status = mapStatus(summary.status, latestStage: summary.latestDeliveryStage);
    return [
      OrderStatusUpdate(
        status: status,
        timestamp: summary.placedAt,
        note: summary.latestDeliveryNote,
      ),
    ];
  }

  static List<OrderStatusUpdate> _historyFromDetail(UserOrderDetail detail) {
    if (detail.deliveryUpdates.isEmpty) {
      return _historyFromSummary(
        UserOrderSummary(
          id: detail.id,
          orderNumber: detail.orderNumber,
          status: detail.status,
          totalAmount: detail.totalAmount,
          placedAt: detail.placedAt,
          itemCount: detail.itemCount,
          primaryProductName: detail.primaryProductName,
          latestDeliveryStage: detail.latestDeliveryStage,
          latestDeliveryNote: detail.latestDeliveryNote,
        ),
      );
    }

    return [
      for (final event in detail.deliveryUpdates)
        OrderStatusUpdate(
          status: mapStatus(detail.status, latestStage: event.stage),
          timestamp: event.createdAt,
          note: event.note,
        ),
    ];
  }
}
