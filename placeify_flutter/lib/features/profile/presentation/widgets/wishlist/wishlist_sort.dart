import 'package:flutter_riverpod/legacy.dart';

import '../../../../home/domain/models/product.dart';

enum WishlistSort {
  newestFirst,
  oldestFirst,
  priceAsc,
  priceDesc,
  nameAsc,
}

extension WishlistSortLabel on WishlistSort {
  String get menuLabel => switch (this) {
        WishlistSort.newestFirst => 'Date added: Newest',
        WishlistSort.oldestFirst => 'Date added: Oldest',
        WishlistSort.priceAsc => 'Price: Low to High',
        WishlistSort.priceDesc => 'Price: High to Low',
        WishlistSort.nameAsc => 'Name: A to Z',
      };

  String get barLabel => switch (this) {
        WishlistSort.newestFirst => 'Newest first',
        WishlistSort.oldestFirst => 'Oldest first',
        WishlistSort.priceAsc => 'Price ↑',
        WishlistSort.priceDesc => 'Price ↓',
        WishlistSort.nameAsc => 'Name A–Z',
      };
}

final wishlistSortProvider = StateProvider<WishlistSort>(
  (ref) => WishlistSort.newestFirst,
);

List<Product> sortWishlistProducts({
  required List<Product> products,
  required Map<String, DateTime> savedAt,
  required WishlistSort sort,
}) {
  final list = List<Product>.from(products);
  switch (sort) {
    case WishlistSort.newestFirst:
      list.sort(
        (a, b) => savedAt[b.id]!.compareTo(savedAt[a.id]!),
      );
    case WishlistSort.oldestFirst:
      list.sort(
        (a, b) => savedAt[a.id]!.compareTo(savedAt[b.id]!),
      );
    case WishlistSort.priceAsc:
      list.sort((a, b) => a.price.compareTo(b.price));
    case WishlistSort.priceDesc:
      list.sort((a, b) => b.price.compareTo(a.price));
    case WishlistSort.nameAsc:
      list.sort((a, b) => a.name.compareTo(b.name));
  }
  return list;
}
