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
}
