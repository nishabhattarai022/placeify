import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';

@freezed
abstract class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required String brand,
    required String sku,
    required double price,
    double? originalPrice,
    required String imageUrl,
    @Default(<String>[]) List<String> imageUrls,
    required String svgIconPath,
    required bool hasArView,
    @Default(false) bool isWishlisted,
    required String categoryId,
    required ProductDimensions dimensions,
    String? vendorId,
    @Default('') String description,
    String? materials,
    double? weightKg,
    String? assemblyNote,
    String? careInstructions,
    String? warranty,
  }) = _Product;

  const Product._();

  bool get isOnSale => originalPrice != null && originalPrice! > price;

  double get discountPercent => isOnSale
      ? ((originalPrice! - price) / originalPrice! * 100).roundToDouble()
      : 0;
}

@freezed
abstract class ProductDimensions with _$ProductDimensions {
  const factory ProductDimensions({
    required double widthCm,
    required double depthCm,
    required double heightCm,
  }) = _ProductDimensions;

  const ProductDimensions._();

  String get formatted =>
      '${widthCm.toInt()} × ${depthCm.toInt()} × ${heightCm.toInt()} cm';
}
