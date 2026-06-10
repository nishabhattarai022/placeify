import 'package:freezed_annotation/freezed_annotation.dart';

part 'vendor_product.freezed.dart';
part 'vendor_product.g.dart';

@freezed
abstract class VendorProduct with _$VendorProduct {
  const factory VendorProduct({
    required String id,
    required String vendorId,
    required String name,
    required String sku,
    required double price,
    required int stock,
    @Default([]) List<String> imageUrls,
    required String categoryId,
    @Default(true) bool isActive,
    required DateTime createdAt,
  }) = _VendorProduct;

  factory VendorProduct.fromJson(Map<String, dynamic> json) =>
      _$VendorProductFromJson(json);
}
