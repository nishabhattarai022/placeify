import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';

enum OrderStatus { pending, shipped, customRequest }

@freezed
abstract class Order with _$Order {
  const factory Order({
    required String id,
    required String orderNumber,
    required String productName,
    required String productSvgIconPath,
    required int quantity,
    required DateTime date,
    required OrderStatus status,
    String? requestMeta,
  }) = _Order;

  const Order._();

  String get statusLabel => switch (status) {
        OrderStatus.pending => 'Pending',
        OrderStatus.shipped => 'Shipped',
        OrderStatus.customRequest => 'Request',
      };
}
