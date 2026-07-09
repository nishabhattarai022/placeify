import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';

/// Seeds demo special offers linked to catalog products by name.
abstract final class SpecialOfferSeed {
  static const _demoOffers = <({
    String productName,
    double originalPrice,
    double discountedPrice,
    String tagline,
    String cardColorHex,
    int displayOrder,
  })>[
    (
      productName: 'Astra',
      originalPrice: 399,
      discountedPrice: 199,
      tagline: 'Sage suede sculptural lounge.',
      cardColorHex: '#B5A99A',
      displayOrder: 0,
    ),
    (
      productName: 'Harmony Chair',
      originalPrice: 299,
      discountedPrice: 179,
      tagline: 'Sculpted suede, modern lines.',
      cardColorHex: '#A8B5A0',
      displayOrder: 1,
    ),
    (
      productName: 'Walnut Desk',
      originalPrice: 499,
      discountedPrice: 299,
      tagline: 'Mid-century walnut classic.',
      cardColorHex: '#B0AABF',
      displayOrder: 2,
    ),
    (
      productName: 'Patio Lounge',
      originalPrice: 349,
      discountedPrice: 229,
      tagline: 'Curved cream, warm interiors.',
      cardColorHex: '#BFAE98',
      displayOrder: 3,
    ),
  ];

  static Future<void> ensureDemoOffers(Session session) async {
    for (final seed in _demoOffers) {
      final product = await Product.db.findFirstRow(
        session,
        where: (row) => row.name.equals(seed.productName),
      );
      if (product?.id == null) continue;
      final linkedProduct = product!;

      final existing = await SpecialOffer.db.findFirstRow(
        session,
        where: (row) => row.productId.equals(linkedProduct.id!),
      );

      final now = DateTime.now();
      if (existing == null) {
        await SpecialOffer.db.insertRow(
          session,
          SpecialOffer(
            productId: linkedProduct.id!,
            originalPrice: seed.originalPrice,
            discountedPrice: seed.discountedPrice,
            tagline: seed.tagline,
            cardColorHex: seed.cardColorHex,
            isActive: true,
            displayOrder: seed.displayOrder,
          ),
        );
        continue;
      }

      await SpecialOffer.db.updateRow(
        session,
        existing.copyWith(
          originalPrice: seed.originalPrice,
          discountedPrice: seed.discountedPrice,
          tagline: seed.tagline,
          cardColorHex: seed.cardColorHex,
          isActive: true,
          displayOrder: seed.displayOrder,
          updatedAt: now,
        ),
      );
    }
  }
}
