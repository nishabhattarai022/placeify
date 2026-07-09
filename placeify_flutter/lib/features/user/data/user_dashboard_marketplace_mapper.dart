import 'package:placeify_client/placeify_client.dart' as api;

import '../../home/data/catalog_product_mapper.dart';
import '../../home/domain/models/product.dart';

abstract final class UserDashboardMarketplaceMapper {
  static Future<List<Product>> toUiProducts(List<api.Product> products) async {
    final mapped = <Product>[];
    for (final item in products) {
      mapped.add(await CatalogProductMapper.toUiProduct(item));
    }
    return mapped;
  }

  static Future<List<Product>> toOfferProducts(
    List<api.Product> products, {
    int limit = 4,
  }) async {
    final mapped = <Product>[];
    for (final item in products) {
      final ui = await CatalogProductMapper.toUiProduct(item);
      if (!ui.isOnSale) continue;
      mapped.add(ui);
      if (mapped.length >= limit) break;
    }
    mapped.sort((a, b) => b.discountPercent.compareTo(a.discountPercent));
    return mapped.take(limit).toList(growable: false);
  }
}
