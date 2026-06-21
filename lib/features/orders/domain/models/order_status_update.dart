import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:placeify/features/orders/domain/enums/consumer_order_status.dart';

part 'order_status_update.freezed.dart';
part 'order_status_update.g.dart';

/// Single entry in an order's status audit trail.
@freezed
abstract class OrderStatusUpdate with _$OrderStatusUpdate {
  const factory OrderStatusUpdate({
    required ConsumerOrderStatus status,
    required DateTime timestamp,
    String? note,
  }) = _OrderStatusUpdate;

  factory OrderStatusUpdate.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusUpdateFromJson(json);
}
