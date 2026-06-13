import 'package:placeify_client/placeify_client.dart' hide Product;

import '../../home/data/catalog_product_mapper.dart';
import '../../home/domain/models/product.dart';

/// Wishlist row ready for the user dashboard UI.
class UserWishlistEntry {
  const UserWishlistEntry({
    required this.savedAt,
    required this.product,
  });

  final DateTime savedAt;
  final Product product;
}

enum UserWishlistSort {
  newestFirst,
  oldestFirst,
  priceAsc,
  priceDesc,
  nameAsc,
}

abstract final class UserWishlistMappers {
  static const sortLabels = {
    UserWishlistSort.newestFirst: 'Newest first',
    UserWishlistSort.oldestFirst: 'Oldest first',
    UserWishlistSort.priceAsc: 'Price ↑',
    UserWishlistSort.priceDesc: 'Price ↓',
    UserWishlistSort.nameAsc: 'Name A–Z',
  };

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

  static List<UserWishlistEntry> sortEntries(
    List<UserWishlistEntry> entries,
    UserWishlistSort sort,
  ) {
    final list = List<UserWishlistEntry>.from(entries);
    switch (sort) {
      case UserWishlistSort.newestFirst:
        list.sort((a, b) => b.savedAt.compareTo(a.savedAt));
      case UserWishlistSort.oldestFirst:
        list.sort((a, b) => a.savedAt.compareTo(b.savedAt));
      case UserWishlistSort.priceAsc:
        list.sort((a, b) => a.product.price.compareTo(b.product.price));
      case UserWishlistSort.priceDesc:
        list.sort((a, b) => b.product.price.compareTo(a.product.price));
      case UserWishlistSort.nameAsc:
        list.sort((a, b) => a.product.name.compareTo(b.product.name));
    }
    return list;
  }
}
