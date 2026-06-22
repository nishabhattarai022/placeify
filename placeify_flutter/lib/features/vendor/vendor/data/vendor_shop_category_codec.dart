import 'dart:convert';

/// Decodes shop categories stored in the vendor profile API `category` field.
abstract final class VendorShopCategoryCodec {
  static String encode(List<String> categories) {
    final normalized = categories
        .map((category) => category.trim())
        .where((category) => category.isNotEmpty)
        .toList();
    return jsonEncode(normalized);
  }

  static List<String> decode(String? raw) {
    if (raw == null || raw.trim().isEmpty) return const [];

    final trimmed = raw.trim();
    if (trimmed.startsWith('[')) {
      try {
        final decoded = jsonDecode(trimmed);
        if (decoded is List) {
          return decoded
              .map((item) => item.toString().trim())
              .where((item) => item.isNotEmpty)
              .toList();
        }
      } catch (_) {
        // Fall through to legacy single-category handling.
      }
    }

    return [trimmed];
  }
}
