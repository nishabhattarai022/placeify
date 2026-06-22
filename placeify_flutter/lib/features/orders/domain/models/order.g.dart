// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Order _$OrderFromJson(Map<String, dynamic> json) => _Order(
      id: json['id'] as String,
      orderNumber: json['orderNumber'] as String,
      userId: json['userId'] as String,
      vendorId: json['vendorId'] as String,
      vendorName: json['vendorName'] as String,
      status: $enumDecode(_$ConsumerOrderStatusEnumMap, json['status']),
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      statusHistory: (json['statusHistory'] as List<dynamic>)
          .map((e) => OrderStatusUpdate.fromJson(e as Map<String, dynamic>))
          .toList(),
      placedAt: DateTime.parse(json['placedAt'] as String),
      estimatedDelivery: json['estimatedDelivery'] == null
          ? null
          : DateTime.parse(json['estimatedDelivery'] as String),
      deliveredAt: json['deliveredAt'] == null
          ? null
          : DateTime.parse(json['deliveredAt'] as String),
      trackingNumber: json['trackingNumber'] as String?,
      paymentStatus: $enumDecode(_$PaymentStatusEnumMap, json['paymentStatus']),
      paymentMethod: json['paymentMethod'] as String,
      subtotal: (json['subtotal'] as num).toDouble(),
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
      total: (json['total'] as num).toDouble(),
      deliveryAddress: json['deliveryAddress'] as String,
      cancellationReason: json['cancellationReason'] as String?,
      returnReason: json['returnReason'] as String?,
    );

Map<String, dynamic> _$OrderToJson(_Order instance) => <String, dynamic>{
      'id': instance.id,
      'orderNumber': instance.orderNumber,
      'userId': instance.userId,
      'vendorId': instance.vendorId,
      'vendorName': instance.vendorName,
      'status': _$ConsumerOrderStatusEnumMap[instance.status]!,
      'items': instance.items,
      'statusHistory': instance.statusHistory,
      'placedAt': instance.placedAt.toIso8601String(),
      'estimatedDelivery': instance.estimatedDelivery?.toIso8601String(),
      'deliveredAt': instance.deliveredAt?.toIso8601String(),
      'trackingNumber': instance.trackingNumber,
      'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus]!,
      'paymentMethod': instance.paymentMethod,
      'subtotal': instance.subtotal,
      'deliveryFee': instance.deliveryFee,
      'discount': instance.discount,
      'total': instance.total,
      'deliveryAddress': instance.deliveryAddress,
      'cancellationReason': instance.cancellationReason,
      'returnReason': instance.returnReason,
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

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.paid: 'paid',
  PaymentStatus.failed: 'failed',
  PaymentStatus.refunded: 'refunded',
};
