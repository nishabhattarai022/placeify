// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_status_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderStatusUpdate _$OrderStatusUpdateFromJson(Map<String, dynamic> json) =>
    _OrderStatusUpdate(
      status: $enumDecode(_$ConsumerOrderStatusEnumMap, json['status']),
      timestamp: DateTime.parse(json['timestamp'] as String),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$OrderStatusUpdateToJson(_OrderStatusUpdate instance) =>
    <String, dynamic>{
      'status': _$ConsumerOrderStatusEnumMap[instance.status]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'note': instance.note,
    };

const _$ConsumerOrderStatusEnumMap = {
  ConsumerOrderStatus.placed: 'placed',
  ConsumerOrderStatus.confirmed: 'confirmed',
  ConsumerOrderStatus.packed: 'packed',
  ConsumerOrderStatus.dispatched: 'dispatched',
  ConsumerOrderStatus.inTransit: 'inTransit',
  ConsumerOrderStatus.outForDelivery: 'outForDelivery',
  ConsumerOrderStatus.delivered: 'delivered',
  ConsumerOrderStatus.cancelled: 'cancelled',
  ConsumerOrderStatus.returnRequested: 'returnRequested',
  ConsumerOrderStatus.returned: 'returned',
};
