import 'package:json_annotation/json_annotation.dart';

/// Consumer-facing order lifecycle (distinct from vendor [OrderStatus]).
@JsonEnum()
enum ConsumerOrderStatus {
  placed,
  confirmed,
  packed,
  dispatched,
  inTransit,
  outForDelivery,
  delivered,
  cancelled,
  returnRequested,
  returned,
}

extension ConsumerOrderStatusX on ConsumerOrderStatus {
  String get label => switch (this) {
    ConsumerOrderStatus.placed => 'Placed',
    ConsumerOrderStatus.confirmed => 'Confirmed',
    ConsumerOrderStatus.packed => 'Packed',
    ConsumerOrderStatus.dispatched => 'Dispatched',
    ConsumerOrderStatus.inTransit => 'In transit',
    ConsumerOrderStatus.outForDelivery => 'Out for delivery',
    ConsumerOrderStatus.delivered => 'Delivered',
    ConsumerOrderStatus.cancelled => 'Cancelled',
    ConsumerOrderStatus.returnRequested => 'Return requested',
    ConsumerOrderStatus.returned => 'Returned',
  };

  bool get isTerminal => switch (this) {
    ConsumerOrderStatus.delivered ||
    ConsumerOrderStatus.cancelled ||
    ConsumerOrderStatus.returned => true,
    _ => false,
  };
}
