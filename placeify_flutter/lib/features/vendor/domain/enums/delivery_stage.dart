import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum DeliveryStage {
  orderPlaced,
  packed,
  shipped,
  outForDelivery,
  delivered,
}
