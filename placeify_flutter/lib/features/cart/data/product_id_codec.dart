/// Maps UI product ids (`p1`) to database integer ids (`1`).
abstract final class ProductIdCodec {
  static int? toDatabaseId(String productId) {
    final raw = productId.trim();
    if (raw.isEmpty) return null;
    final normalized = raw.startsWith('p') ? raw.substring(1) : raw;
    return int.tryParse(normalized);
  }

  static String fromDatabaseId(int productId) => 'p$productId';
}
