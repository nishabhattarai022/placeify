import 'package:placeify_client/placeify_client.dart' as api;

import '../../../core/config/resolve_media_url.dart';
import '../../../data/furniture_categories.dart';
import 'catalog_demo_image_catalog.dart';

/// Resolves catalog product imagery from API fields with safe fallbacks.
abstract final class CatalogImageResolver {
  static Future<String> resolveFromApiProduct(api.Product product) async {
    final categoryId = product.category?.name ?? '';
    final productKey = product.id?.toString() ?? product.name;

    final resolved = await _resolveRawCandidates([
      product.thumbnailUrl,
      if (product.viewImageUrls != null) ...product.viewImageUrls!,
    ]);
    if (resolved != null) return resolved;

    final byName = CatalogDemoImageCatalog.imageForName(product.name);
    if (byName != null) return byName;

    return fallbackForProduct(
      categoryId: categoryId,
      productId: productKey,
      productName: product.name,
    );
  }

  static Future<String> resolveFromUrlList(
    List<String> urls, {
    String categoryId = 'chairs',
    String? productName,
    String? productId,
  }) async {
    final resolved = await _resolveRawCandidates(urls);
    if (resolved != null) return resolved;

    if (productName != null) {
      final byName = CatalogDemoImageCatalog.imageForName(
        productName,
        productId: productId,
      );
      if (byName != null) return byName;
    }

    return fallbackForProduct(
      categoryId: categoryId,
      productId: productId ?? productName ?? categoryId,
      productName: productName,
    );
  }

  static Future<String?> _resolveRawCandidates(List<String?> candidates) async {
    for (final raw in candidates) {
      if (raw == null) continue;
      final trimmed = raw.trim();
      if (trimmed.isEmpty) continue;
      if (CatalogDemoImageCatalog.isGenericPlaceholder(trimmed)) continue;

      if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
        return trimmed;
      }
      if (trimmed.startsWith('assets/images/')) {
        return trimmed;
      }
      if (trimmed.startsWith('assets/icons/')) {
        continue;
      }

      final resolved = await resolveMediaUrl(trimmed);
      if (resolved.isNotEmpty &&
          !CatalogDemoImageCatalog.isGenericPlaceholder(resolved)) {
        return resolved;
      }
    }
    return null;
  }

  /// Category-aware but product-specific fallback (avoids identical cards).
  static String fallbackForProduct({
    required String categoryId,
    required String productId,
    String? productName,
  }) {
    final seed = [
      categoryId.trim().toLowerCase(),
      productId.trim().toLowerCase(),
      (productName ?? '').trim().toLowerCase(),
    ].join('|');
    return CatalogDemoImageCatalog.imageForSeed(seed);
  }

  /// Category hero JPG used only when no product identity is available.
  static String fallbackForCategory(String categoryId) {
    final normalized = categoryId.trim().toLowerCase();
    for (final category in furnitureCategories) {
      if (category.id == normalized) return category.imagePath;
      if (normalized == 'lights' && category.id == 'lighting') {
        return category.imagePath;
      }
    }
    return furnitureCategories.first.imagePath;
  }

  static bool isPhotoSource(String source) {
    final trimmed = source.trim();
    if (trimmed.isEmpty) return false;
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return true;
    }
    return trimmed.startsWith('assets/images/');
  }
}
