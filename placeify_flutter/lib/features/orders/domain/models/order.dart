import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:placeify_flutter/features/orders/domain/enums/consumer_order_status.dart';
import 'package:placeify_flutter/features/orders/domain/enums/order_list_filter.dart';
import 'package:placeify_flutter/features/orders/domain/enums/payment_status.dart';
import 'package:placeify_flutter/features/orders/domain/models/order_item.dart';
import 'package:placeify_flutter/features/orders/domain/models/order_status_update.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
abstract class Order with _$Order {
  const factory Order({
    required String id,
    required String orderNumber,
    required String userId,
    required String vendorId,
    required String vendorName,
    required ConsumerOrderStatus status,
    required List<OrderItem> items,
    required List<OrderStatusUpdate> statusHistory,
    required DateTime placedAt,
    DateTime? estimatedDelivery,
    DateTime? deliveredAt,
    String? trackingNumber,
    required PaymentStatus paymentStatus,
    required String paymentMethod,
    required double subtotal,
    required double deliveryFee,
    @Default(0) double discount,
    required double total,
    required String deliveryAddress,
    String? customerName,
    String? customerPhone,
    String? cancellationReason,
    String? returnReason,
  }) = _Order;

  const Order._();

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  bool get isActive => switch (status) {
        ConsumerOrderStatus.placed ||
        ConsumerOrderStatus.confirmed ||
        ConsumerOrderStatus.packed ||
        ConsumerOrderStatus.dispatched ||
        ConsumerOrderStatus.inTransit ||
        ConsumerOrderStatus.outForDelivery =>
          true,
        _ => false,
      };

  bool get isCancellable => switch (status) {
        ConsumerOrderStatus.placed || ConsumerOrderStatus.confirmed => true,
        _ => false,
      };

  bool get isDelivered => status == ConsumerOrderStatus.delivered;

  bool get isCancelled => status == ConsumerOrderStatus.cancelled;

  bool get isReturn =>
      status == ConsumerOrderStatus.returnRequested ||
      status == ConsumerOrderStatus.returned;

  bool get hasTracking =>
      trackingNumber != null &&
      trackingNumber!.isNotEmpty &&
      (isActive || isDelivered);

  /// Unpaid eSewa orders can resume payment from order details.
  bool get needsEsewaPayment =>
      paymentStatus == PaymentStatus.pending &&
      paymentMethod.toLowerCase().contains('esewa');

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}

extension OrderFilterX on Order {
  bool matchesListFilter(OrderListFilter filter) => switch (filter) {
        OrderListFilter.all => true,
        OrderListFilter.active => isActive,
        OrderListFilter.delivered => isDelivered,
        OrderListFilter.cancelled => isCancelled,
        OrderListFilter.returns => isReturn,
      };
}
