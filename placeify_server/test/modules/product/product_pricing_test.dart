import 'package:placeify_server/src/generated/protocol.dart';
import 'package:placeify_server/src/modules/product/product_pricing.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('ProductPricing', () {
    Product baseProduct({double price = 1000}) => Product(
          vendorId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
          name: 'Chair',
          description: 'Test',
          price: price,
          materials: 'Wood',
          widthCm: 50,
          depthCm: 50,
          heightCm: 90,
          careInstructions: 'Wipe clean',
        );

    test('uses discountPrice when lower than list price', () {
      final product = baseProduct().copyWith(discountPrice: 700);
      expect(ProductPricing.effectiveUnitPrice(product), 700);
      expect(ProductPricing.hasActiveOffer(product), isTrue);
    });

    test('uses discountPercentage when discountPrice is absent', () {
      final product = baseProduct().copyWith(discountPercentage: 25);
      expect(ProductPricing.effectiveUnitPrice(product), 750);
      expect(ProductPricing.hasActiveOffer(product), isTrue);
    });

    test('prefers discountPrice over discountPercentage', () {
      final normalized = ProductPricing.normalizeDiscounts(
        listPrice: 1000,
        discountPrice: 800,
        discountPercentage: 50,
      );
      expect(normalized.discountPrice, 800);
      expect(normalized.discountPercentage, isNull);
    });

    test('ignores invalid discounts and warranty text is not parsed', () {
      final product = baseProduct().copyWith(
        warranty: '30% off limited time',
        discountPrice: null,
        discountPercentage: null,
      );
      expect(ProductPricing.effectiveUnitPrice(product), 1000);
      expect(ProductPricing.hasActiveOffer(product), isFalse);
    });

    test('featured flag is independent of offer state', () {
      final product = baseProduct().copyWith(featured: true);
      expect(ProductPricing.isFeatured(product), isTrue);
      expect(ProductPricing.hasActiveOffer(product), isFalse);
    });
  });
}
