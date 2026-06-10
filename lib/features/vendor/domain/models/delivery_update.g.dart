// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeliveryUpdate _$DeliveryUpdateFromJson(Map<String, dynamic> json) =>
    _DeliveryUpdate(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      stage: $enumDecode(_$DeliveryStageEnumMap, json['stage']),
      note: json['note'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$DeliveryUpdateToJson(_DeliveryUpdate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'stage': _$DeliveryStageEnumMap[instance.stage]!,
      'note': instance.note,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$DeliveryStageEnumMap = {
  DeliveryStage.orderPlaced: 'orderPlaced',
  DeliveryStage.packed: 'packed',
  DeliveryStage.shipped: 'shipped',
  DeliveryStage.outForDelivery: 'outForDelivery',
  DeliveryStage.delivered: 'delivered',
};
