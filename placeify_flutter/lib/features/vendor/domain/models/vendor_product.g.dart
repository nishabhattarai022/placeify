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
      description: json['description'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      offerLabel: json['offerLabel'] as String? ?? '',
      widthCm: (json['widthCm'] as num?)?.toDouble() ?? 0,
      depthCm: (json['depthCm'] as num?)?.toDouble() ?? 0,
      heightCm: (json['heightCm'] as num?)?.toDouble() ?? 0,
      weightKg: (json['weightKg'] as num?)?.toDouble() ?? 0,
      hasArView: json['hasArView'] as bool? ?? false,
      materials: json['materials'] as String? ?? '',
      warrantyNote: json['warrantyNote'] as String? ?? '',
      shippingNote: json['shippingNote'] as String? ?? '',
      lowStockThreshold: (json['lowStockThreshold'] as num?)?.toInt() ?? 5,
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
      'description': instance.description,
      'brand': instance.brand,
      'originalPrice': instance.originalPrice,
      'offerLabel': instance.offerLabel,
      'widthCm': instance.widthCm,
      'depthCm': instance.depthCm,
      'heightCm': instance.heightCm,
      'weightKg': instance.weightKg,
      'hasArView': instance.hasArView,
      'materials': instance.materials,
      'warrantyNote': instance.warrantyNote,
      'shippingNote': instance.shippingNote,
      'lowStockThreshold': instance.lowStockThreshold,
    };
