import 'package:flutter/material.dart';

import '../../../../home/domain/models/product.dart';

enum WishlistSortGroup { dateAdded, price, name }

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

extension WishlistSortGroupLabel on WishlistSortGroup {
  String get sectionLabel => switch (this) {
    WishlistSortGroup.dateAdded => 'Date added',
    WishlistSortGroup.price => 'Price',
    WishlistSortGroup.name => 'Alphabetical',
  };
}

extension WishlistSortMeta on WishlistSort {
  WishlistSortGroup get group => switch (this) {
    WishlistSort.newestFirst ||
    WishlistSort.oldestFirst => WishlistSortGroup.dateAdded,
    WishlistSort.priceAsc || WishlistSort.priceDesc => WishlistSortGroup.price,
    WishlistSort.nameAsc => WishlistSortGroup.name,
  };

  IconData get icon => switch (this) {
    WishlistSort.newestFirst => Icons.schedule_outlined,
    WishlistSort.oldestFirst => Icons.history_outlined,
    WishlistSort.priceAsc => Icons.arrow_downward_rounded,
    WishlistSort.priceDesc => Icons.arrow_upward_rounded,
    WishlistSort.nameAsc => Icons.sort_by_alpha,
  };

  String get tileLabel => switch (this) {
    WishlistSort.newestFirst => 'Newest',
    WishlistSort.oldestFirst => 'Oldest',
    WishlistSort.priceAsc => 'Low to High',
    WishlistSort.priceDesc => 'High to Low',
    WishlistSort.nameAsc => 'A to Z',
  };
}

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
