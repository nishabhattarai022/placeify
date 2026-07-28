import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:placeify_client/placeify_client.dart' show OrderPaymentStatus;
import 'package:placeify_flutter/features/vendor/domain/enums/delivery_stage.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/order_status.dart';

part 'vendor_order.freezed.dart';
part 'vendor_order.g.dart';

@freezed
abstract class VendorOrder with _$VendorOrder {
  const factory VendorOrder({
    required String id,
    required String orderNumber,
    required String vendorId,
    required String productId,
    required String productName,
    required int quantity,
    required double totalAmount,
    required OrderStatus status,
    required String customerName,
    required DateTime orderedAt,
    @Default(OrderPaymentStatus.unpaid) OrderPaymentStatus orderPaymentStatus,
    DeliveryStage? currentDeliveryStage,
  }) = _VendorOrder;

  const VendorOrder._();

  factory VendorOrder.fromJson(Map<String, dynamic> json) =>
      _$VendorOrderFromJson(json);

  bool get canUpdatePayment =>
      orderPaymentStatus == OrderPaymentStatus.unpaid;

  String get displayStatusLabel {
    if (status == OrderStatus.rejected) return 'Rejected';
    if (status == OrderStatus.cancelled) return 'Cancelled';
    if (status == OrderStatus.returnRequested) return 'Return requested';
    if (status == OrderStatus.refunded) return 'Refunded';
    if (currentDeliveryStage != null) {
      return _deliveryStageLabel(currentDeliveryStage!);
    }
    return switch (status) {
      OrderStatus.pending => 'Pending',
      OrderStatus.accepted => 'Order Placed',
      OrderStatus.processing => 'Packed',
      OrderStatus.shipped => 'Shipped',
      OrderStatus.delivered => 'Delivered',
      OrderStatus.returnRequested => 'Return requested',
      OrderStatus.refunded => 'Refunded',
      OrderStatus.rejected => 'Rejected',
      OrderStatus.cancelled => 'Cancelled',
    };
  }

  String get statusLabel => displayStatusLabel;

  static String _deliveryStageLabel(DeliveryStage stage) {
    return switch (stage) {
      DeliveryStage.orderPlaced => 'Order Placed',
      DeliveryStage.packed => 'Packed',
      DeliveryStage.shipped => 'Shipped',
      DeliveryStage.outForDelivery => 'Out for Delivery',
      DeliveryStage.delivered => 'Delivered',
      DeliveryStage.rejected => 'Rejected',
    };
  }
}
