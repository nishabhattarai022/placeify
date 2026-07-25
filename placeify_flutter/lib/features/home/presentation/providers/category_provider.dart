import 'package:placeify_flutter/features/shops/data/vendor_product_mapper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/category.dart';
import '../../domain/models/product.dart';
import '../../../shops/presentation/providers/consumer_shop_provider.dart';
import 'catalog_provider.dart';

part 'category_provider.g.dart';

@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  String build() => 'chairs';

  void select(String categoryId) => state = categoryId;
}

@riverpod
List<ProductCategory> categories(Ref ref) {
  ref.watch(catalogIndexProvider);
  return const [
    ProductCategory(id: 'chairs', label: 'Chairs', svgIconAssetPath: 'assets/icons/ic_chair.svg'),
    ProductCategory(id: 'sofas', label: 'Sofas', svgIconAssetPath: 'assets/icons/ic_sofa.svg'),
    ProductCategory(id: 'tables', label: 'Tables', svgIconAssetPath: 'assets/icons/ic_table.svg'),
    ProductCategory(id: 'desks', label: 'Desks', svgIconAssetPath: 'assets/icons/ic_table.svg'),
    ProductCategory(id: 'beds', label: 'Beds', svgIconAssetPath: 'assets/icons/ic_bed.svg'),
    ProductCategory(id: 'storage', label: 'Storage', svgIconAssetPath: 'assets/icons/ic_package.svg'),
    ProductCategory(id: 'lighting', label: 'Lighting', svgIconAssetPath: 'assets/icons/ic_lamp.svg'),
    ProductCategory(id: 'outdoor', label: 'Outdoor', svgIconAssetPath: 'assets/icons/ic_plant.svg'),
  ];
}

@riverpod
List<Product> filteredProducts(Ref ref) {
  final categoryId = ref.watch(selectedCategoryProvider);
  return ref.watch(catalogProductsByCategoryProvider(categoryId));
}

@riverpod
Product? productById(Ref ref, String id) {
  final catalog = ref.watch(catalogIndexProvider).value;
  if (catalog != null) {
    final direct = catalog[id];
    if (direct != null) return direct;

    if (VendorProductMapper.isShopProductId(id)) {
      final parsed = VendorProductMapper.parseConsumerProductId(id);
      if (parsed != null) {
        final base = catalog[parsed.productId];
        if (base != null) {
          return base.copyWith(id: id, vendorId: parsed.vendorId);
        }
      }
    }
  }

  final shopProduct = ref.watch(shopProductByConsumerIdProvider(id)).value;
  if (shopProduct != null) return shopProduct;

  // Prefer live catalog IDs so cart/wishlist stay consistent with the backend.
  return null;
}

const _categoryLabels = <String, String>{
  'chairs': 'Chairs',
  'sofas': 'Sofas',
  'tables': 'Tables',
  'desks': 'Desks',
  'beds': 'Beds',
  'storage': 'Storage',
  'lighting': 'Lighting',
  'outdoor': 'Outdoor',
};

String categoryTitle(String categoryId) {
  return _categoryLabels[categoryId] ?? 'Chairs';
}
