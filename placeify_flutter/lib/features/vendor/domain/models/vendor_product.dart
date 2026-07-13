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
    @Default('') String description,
    @Default('') String brand,
    double? originalPrice,
    @Default('') String offerLabel,
    @Default(0) double widthCm,
    @Default(0) double depthCm,
    @Default(0) double heightCm,
    @Default(0) double weightKg,
    @Default(false) bool hasArView,
    /// none | building | ready | failed — mirrors server [Product.model3dStatus].
    @Default('none') String model3dStatus,
    @Default('') String model3dError,
    @Default('') String materials,
    @Default('') String warrantyNote,
    @Default('') String shippingNote,
    @Default(5) int lowStockThreshold,
  }) = _VendorProduct;

  const VendorProduct._();

  bool get isLowStock => stock <= lowStockThreshold;

  bool get isOnSale =>
      originalPrice != null && originalPrice! > price;

  bool get isOffer => isOnSale;

  String? get primaryImageUrl =>
      imageUrls.isNotEmpty ? imageUrls.first : null;

  double get discountPercent => isOnSale
      ? ((originalPrice! - price) / originalPrice! * 100).roundToDouble()
      : 0;

  double get discountPercentage => discountPercent;

  /// Combined warranty + shipping line for product detail (e.g. "2-year warranty • Ships in 5–7 days").
  String? get fulfillmentNote {
    final warranty = warrantyNote.trim();
    final shipping = shippingNote.trim();
    if (warranty.isEmpty && shipping.isEmpty) return null;
    if (warranty.isNotEmpty && shipping.isNotEmpty) {
      return '$warranty • $shipping';
    }
    return warranty.isNotEmpty ? warranty : shipping;
  }

  factory VendorProduct.fromJson(Map<String, dynamic> json) =>
      _$VendorProductFromJson(json);
}
