import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';

/// Reads active vendor special offers for the consumer home carousel.
class SpecialOfferReader {
  Future<List<SpecialOfferSummary>> listActiveOffers(
    Session session, {
    int limit = 12,
  }) async {
    final offers = await SpecialOffer.db.find(
      session,
      where: (row) => row.isActive.equals(true),
      include: SpecialOffer.include(
        product: Product.include(
          vendor: Vendor.include(),
          category: Category.include(),
        ),
      ),
      orderBy: (row) => row.displayOrder,
      orderDescending: false,
      limit: limit,
    );

    final summaries = <SpecialOfferSummary>[];
    for (final offer in offers) {
      final product = offer.product;
      final productId = product?.id ?? offer.productId;
      if (productId == null) continue;
      if (product == null || product.status != ProductStatus.active) continue;

      final original = offer.originalPrice;
      final discounted = offer.discountedPrice;
      if (original <= 0 || discounted <= 0 || discounted >= original) continue;

      final discountPercent =
          (((original - discounted) / original) * 100).round().clamp(1, 99);

      summaries.add(
        SpecialOfferSummary(
          productId: productId,
          productName: product.name,
          imageUrl: product.thumbnailUrl,
          originalPrice: original,
          discountedPrice: discounted,
          discountPercent: discountPercent,
          tagline: offer.tagline,
          cardColorHex: offer.cardColorHex,
        ),
      );
    }

    return summaries;
  }
}
