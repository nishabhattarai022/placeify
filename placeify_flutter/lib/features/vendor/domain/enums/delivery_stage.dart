import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum DeliveryStage {
  orderPlaced,
  packed,
  shipped,
  outForDelivery,
  delivered,
  rejected;

  /// Linear fulfillment path (excludes terminal [rejected]).
  static const List<DeliveryStage> progression = [
    DeliveryStage.orderPlaced,
    DeliveryStage.packed,
    DeliveryStage.shipped,
    DeliveryStage.outForDelivery,
    DeliveryStage.delivered,
  ];
}
