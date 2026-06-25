import '../../shops/data/vendor_product_mapper.dart';

/// Maps UI product ids (`p1`, `shop-{vendor}-p1`) to database integer ids (`1`).
abstract final class ProductIdCodec {
  static int? toDatabaseId(String productId) {
    final raw = productId.trim();
    if (raw.isEmpty) return null;

    if (raw.startsWith('shop-')) {
      final parsed = VendorProductMapper.parseConsumerProductId(raw);
      if (parsed != null) {
        return toDatabaseId(parsed.productId);
      }
    }

    final normalized = raw.startsWith('p') ? raw.substring(1) : raw;
    return int.tryParse(normalized);
  }

  static String fromDatabaseId(int productId) => 'p$productId';

  /// Maps browse variant ids (`p5-v2`) and shop ids to a purchasable `p{n}` id.
  static String normalizeUiProductId(String productId) {
    final raw = productId.trim();
    if (raw.isEmpty) return raw;

    if (raw.startsWith('shop-')) {
      final parsed = VendorProductMapper.parseConsumerProductId(raw);
      if (parsed != null) {
        return normalizeUiProductId(parsed.productId);
      }
    }

    final base = RegExp(r'^(p\d+)').firstMatch(raw)?.group(1);
    return base ?? raw;
  }

  /// Newest database ids first (`p12` before `p9`).
  static int compareNewestFirst(String a, String b) {
    final idA = toDatabaseId(a) ?? 0;
    final idB = toDatabaseId(b) ?? 0;
    return idB.compareTo(idA);
  }
}
