import 'package:placeify_client/placeify_client.dart' hide Product;

import '../../home/data/catalog_product_mapper.dart';
import '../../home/domain/models/product.dart';

/// Wishlist row mapped from the API for shared providers.
class UserWishlistEntry {
  const UserWishlistEntry({
    required this.savedAt,
    required this.product,
  });

  final DateTime savedAt;
  final Product product;
}

abstract final class UserWishlistMappers {
  static Future<List<UserWishlistEntry>> fromApiItems(
    List<WishlistItem> items,
  ) async {
    final entries = <UserWishlistEntry>[];
    for (final item in items) {
      final apiProduct = item.product;
      if (apiProduct == null) continue;
      entries.add(
        UserWishlistEntry(
          savedAt: item.createdAt,
          product: await CatalogProductMapper.toUiProduct(apiProduct),
        ),
      );
    }
    return entries;
  }
}
