import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/config/vendor_mock_config.dart';
import '../../domain/models/vendor_product.dart';
import 'vendor_products_provider.dart';

String? _imageFromProducts(List<VendorProduct> products, String productId) {
  for (final product in products) {
    if (product.id == productId && product.imageUrls.isNotEmpty) {
      return product.imageUrls.first;
    }
  }
  return null;
}

/// Resolves a vendor product's primary image for order list/detail views.
final vendorProductImageUrlProvider =
    Provider.family<String?, String>((ref, productId) {
  final productsAsync = ref.watch(vendorProductsProvider);

  return productsAsync.maybeWhen(
    data: (products) => _imageFromProducts(products, productId),
    orElse: () => VendorMockConfig.productImageFor(productId),
  );
});
