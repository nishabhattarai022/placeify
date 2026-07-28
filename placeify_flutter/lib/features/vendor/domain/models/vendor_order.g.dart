// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VendorOrder _$VendorOrderFromJson(Map<String, dynamic> json) => _VendorOrder(
  id: json['id'] as String,
  orderNumber: json['orderNumber'] as String,
  vendorId: json['vendorId'] as String,
  productId: json['productId'] as String,
  productName: json['productName'] as String,
  quantity: (json['quantity'] as num).toInt(),
  totalAmount: (json['totalAmount'] as num).toDouble(),
  status: $enumDecode(_$OrderStatusEnumMap, json['status']),
  customerName: json['customerName'] as String,
  orderedAt: DateTime.parse(json['orderedAt'] as String),
  orderPaymentStatus:
      $enumDecodeNullable(
        _$OrderPaymentStatusEnumMap,
        json['orderPaymentStatus'],
      ) ??
      OrderPaymentStatus.unpaid,
  currentDeliveryStage: $enumDecodeNullable(
    _$DeliveryStageEnumMap,
    json['currentDeliveryStage'],
  ),
);

Map<String, dynamic> _$VendorOrderToJson(
  _VendorOrder instance,
) => <String, dynamic>{
  'id': instance.id,
  'orderNumber': instance.orderNumber,
  'vendorId': instance.vendorId,
  'productId': instance.productId,
  'productName': instance.productName,
  'quantity': instance.quantity,
  'totalAmount': instance.totalAmount,
  'status': _$OrderStatusEnumMap[instance.status]!,
  'customerName': instance.customerName,
  'orderedAt': instance.orderedAt.toIso8601String(),
  'orderPaymentStatus': instance.orderPaymentStatus,
  'currentDeliveryStage': _$DeliveryStageEnumMap[instance.currentDeliveryStage],
};

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.accepted: 'accepted',
  OrderStatus.rejected: 'rejected',
  OrderStatus.processing: 'processing',
  OrderStatus.shipped: 'shipped',
  OrderStatus.delivered: 'delivered',
  OrderStatus.returnRequested: 'returnRequested',
  OrderStatus.refunded: 'refunded',
  OrderStatus.cancelled: 'cancelled',
};

const _$OrderPaymentStatusEnumMap = {
  OrderPaymentStatus.unpaid: 'unpaid',
  OrderPaymentStatus.paymentReceived: 'paymentReceived',
  OrderPaymentStatus.paymentConfirmed: 'paymentConfirmed',
};

const _$DeliveryStageEnumMap = {
  DeliveryStage.orderPlaced: 'orderPlaced',
  DeliveryStage.packed: 'packed',
  DeliveryStage.shipped: 'shipped',
  DeliveryStage.outForDelivery: 'outForDelivery',
  DeliveryStage.delivered: 'delivered',
  DeliveryStage.rejected: 'rejected',
};
