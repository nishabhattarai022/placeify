import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:placeify/features/vendor/domain/enums/delivery_stage.dart';

part 'delivery_update.freezed.dart';
part 'delivery_update.g.dart';

@freezed
abstract class DeliveryUpdate with _$DeliveryUpdate {
  const factory DeliveryUpdate({
    required String id,
    required String orderId,
    required DeliveryStage stage,
    required String note,
    required DateTime updatedAt,
  }) = _DeliveryUpdate;

  factory DeliveryUpdate.fromJson(Map<String, dynamic> json) =>
      _$DeliveryUpdateFromJson(json);
}
