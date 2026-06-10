// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VendorProduct _$VendorProductFromJson(Map<String, dynamic> json) =>
    _VendorProduct(
      id: json['id'] as String,
      vendorId: json['vendorId'] as String,
      name: json['name'] as String,
      sku: json['sku'] as String,
      price: (json['price'] as num).toDouble(),
      stock: (json['stock'] as num).toInt(),
      imageUrls:
          (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      categoryId: json['categoryId'] as String,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$VendorProductToJson(_VendorProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vendorId': instance.vendorId,
      'name': instance.name,
      'sku': instance.sku,
      'price': instance.price,
      'stock': instance.stock,
      'imageUrls': instance.imageUrls,
      'categoryId': instance.categoryId,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
    };
