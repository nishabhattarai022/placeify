/// Demo catalog product names → image paths when the API has no per-product image.
///
/// Keys match [MockProductRepository] / backend seed names. Used only as a
/// last-resort visual fallback — never as product data.
abstract final class CatalogDemoImageCatalog {
  /// Distinct existing image assets/URLs. Do not invent new files.
  static const imagePool = <String>[
    'assets/images/splash/Tola_Lounge_Chair_Venice_Vegan_Suede_Sage_1_0.jpg',
    'assets/images/splash/pexels-suhailat-35160826.jpg',
    'assets/images/splash/Diane_Sofa_Venice_Vegan_Suede_Sage_1.jpg',
    'https://images.unsplash.com/photo-1506439773649-6e0eb8cfb237?w=400',
    'assets/images/splash/462222_1_800.jpg',
    'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400',
    'assets/images/splash/pexels-blackcurrant-great-2016663774-35378675.jpg',
    'assets/images/splash/3d-room-decor-with-furniture-minimalist-beige-tones.jpg',
    'assets/images/home/explore_hero.jpg',
    'assets/images/categories/chair.jpg',
    'assets/images/categories/sofa.jpg',
    'assets/images/categories/desk.jpg',
    'assets/images/categories/bed.jpg',
    'assets/images/categories/table.jpg',
    'assets/images/categories/storage.jpg',
    'assets/images/categories/lighting.jpg',
    'assets/images/categories/outdoor.jpg',
    'assets/images/home/offer_chair_1.png',
    'assets/images/home/offer_chair_2.png',
    'assets/images/home/offer_chair_3.png',
    'assets/images/home/offer_chair_4.png',
    'assets/images/splash_hero.jpg',
  ];

  /// Exact name → unique pool index (no shared URLs across different products).
  static const _byName = <String, int>{
    'astra': 0,
    'brixon': 1,
    'brixon pro': 2,
    'brixon chair': 3,
    'odin 75': 4,
    'harmony chair': 5,
    'walnut desk': 6,
    'studio desk': 11,
    'cloud bed': 7,
    'linen bed frame': 12,
    'round dining table': 13,
    'oak console': 8,
    'modular shelf': 14,
    'cabinet unit': 10,
    'arc floor lamp': 15,
    'pendant light': 9,
    'patio lounge': 16,
    'garden set': 17,
  };

  static const _genericPlaceholders = [
    '3d-room-decor-with-furniture-minimalist-beige-tones',
    'explore_hero',
  ];

  static bool isGenericPlaceholder(String? source) {
    if (source == null || source.trim().isEmpty) return false;
    final normalized = source.trim().toLowerCase();
    return _genericPlaceholders.any(normalized.contains);
  }

  /// Exact name match; when [productId] is set, disambiguates duplicate names.
  static String? imageForName(String name, {String? productId}) {
    final key = name.trim().toLowerCase();
    if (key.isEmpty) return null;

    if (productId != null && productId.trim().isNotEmpty) {
      return imageForSeed('$productId|$key');
    }

    final index = _byName[key];
    if (index == null) return null;
    return imagePool[index % imagePool.length];
  }

  /// Deterministic per-product fallback from category + product identity.
  static String imageForSeed(String seed) {
    final hash = seed.hashCode & 0x7fffffff;
    return imagePool[hash % imagePool.length];
  }

  /// Returns [count] unique images, or throws if the pool is too small.
  static List<String> uniqueImagesForCount(int count) {
    if (count > imagePool.length) {
      throw StateError(
        'CatalogDemoImageCatalog image pool too small: '
        '${imagePool.length} images for $count products. '
        'Add more real assets/URLs or reduce the generated set.',
      );
    }
    return imagePool.take(count).toList(growable: false);
  }
}
