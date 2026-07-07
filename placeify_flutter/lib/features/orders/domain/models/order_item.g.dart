// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => _OrderItem(
  productId: json['productId'] as String,
  productName: json['productName'] as String,
  productImageUrl: json['productImageUrl'] as String,
  brandName: json['brandName'] as String,
  sku: json['sku'] as String,
  unitPrice: (json['unitPrice'] as num).toDouble(),
  discountedPrice: (json['discountedPrice'] as num?)?.toDouble(),
  quantity: (json['quantity'] as num).toInt(),
  selectedColor: json['selectedColor'] as String?,
  dimensions:
      (json['dimensions'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
);

Map<String, dynamic> _$OrderItemToJson(_OrderItem instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'productImageUrl': instance.productImageUrl,
      'brandName': instance.brandName,
      'sku': instance.sku,
      'unitPrice': instance.unitPrice,
      'discountedPrice': instance.discountedPrice,
      'quantity': instance.quantity,
      'selectedColor': instance.selectedColor,
      'dimensions': instance.dimensions,
    };
