import '../../generated/protocol.dart';

/// Deterministic product pricing derived from dedicated discount fields only.
abstract final class ProductPricing {
  /// Returns the customer-facing unit price for [product].
  static double effectiveUnitPrice(Product product) {
    final listPrice = product.price;
    if (listPrice <= 0) return listPrice;

    final discountPrice = product.discountPrice;
    if (discountPrice != null &&
        discountPrice > 0 &&
        discountPrice < listPrice) {
      return discountPrice;
    }

    final discountPercentage = product.discountPercentage;
    if (discountPercentage != null &&
        discountPercentage > 0 &&
        discountPercentage < 100) {
      return listPrice * (1 - discountPercentage / 100);
    }

    return listPrice;
  }

  static bool hasActiveOffer(Product product) {
    return effectiveUnitPrice(product) < product.price;
  }

  static bool isFeatured(Product product) => product.featured;

  /// Normalizes optional discount inputs for persistence.
  static ({double? discountPrice, double? discountPercentage})
  normalizeDiscounts({
    required double listPrice,
    double? discountPrice,
    double? discountPercentage,
  }) {
    if (listPrice <= 0) {
      return (discountPrice: null, discountPercentage: null);
    }

    double? normalizedPrice;
    if (discountPrice != null &&
        discountPrice > 0 &&
        discountPrice < listPrice) {
      normalizedPrice = discountPrice;
    }

    double? normalizedPercent;
    if (discountPercentage != null &&
        discountPercentage > 0 &&
        discountPercentage < 100) {
      normalizedPercent = discountPercentage;
    }

    if (normalizedPrice != null) {
      return (discountPrice: normalizedPrice, discountPercentage: null);
    }
    return (discountPrice: null, discountPercentage: normalizedPercent);
  }
}
