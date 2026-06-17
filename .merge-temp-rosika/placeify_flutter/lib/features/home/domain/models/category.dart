import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

@freezed
abstract class ProductCategory with _$ProductCategory {
  const factory ProductCategory({
    required String id,
    required String label,
    required String svgIconAssetPath,
    @Default(false) bool isActive,
  }) = _ProductCategory;
}
