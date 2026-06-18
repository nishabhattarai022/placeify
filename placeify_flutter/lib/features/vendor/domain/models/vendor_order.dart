import 'package:freezed_annotation/freezed_annotation.dart';
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
  }) = _VendorOrder;

  const VendorOrder._();

  factory VendorOrder.fromJson(Map<String, dynamic> json) =>
      _$VendorOrderFromJson(json);

  String get statusLabel => switch (status) {
        OrderStatus.pending => 'Pending',
        OrderStatus.accepted => 'Accepted',
        OrderStatus.rejected => 'Rejected',
        OrderStatus.processing => 'Processing',
        OrderStatus.shipped => 'Shipped',
        OrderStatus.delivered => 'Delivered',
        OrderStatus.cancelled => 'Cancelled',
      };
}
