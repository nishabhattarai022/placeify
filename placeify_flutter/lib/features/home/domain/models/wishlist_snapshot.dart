import '../models/product.dart';

/// In-memory wishlist: saved timestamps plus UI products from the API.
class WishlistSnapshot {
  const WishlistSnapshot({
    this.savedAt = const {},
    this.products = const [],
  });

  static const empty = WishlistSnapshot();

  final Map<String, DateTime> savedAt;
  final List<Product> products;

  int get length => savedAt.length;
  bool get isEmpty => savedAt.isEmpty;
  bool get isNotEmpty => savedAt.isNotEmpty;
  Iterable<String> get keys => savedAt.keys;
}
