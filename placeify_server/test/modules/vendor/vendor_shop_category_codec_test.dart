import 'package:placeify_server/src/modules/vendor/vendor_shop_category_codec.dart';
import 'package:test/test.dart';

void main() {
  group('VendorShopCategoryCodec', () {
    test('encodes and decodes multiple categories', () {
      const categories = ['Chairs', 'Tables', 'Sofas'];
      final encoded = VendorShopCategoryCodec.encode(categories);

      expect(encoded, '["Chairs","Tables","Sofas"]');
      expect(VendorShopCategoryCodec.decode(encoded), categories);
    });

    test('decodes legacy single category strings', () {
      expect(VendorShopCategoryCodec.decode('furniture'), ['furniture']);
    });

    test('normalize canonicalizes legacy values', () {
      expect(
        VendorShopCategoryCodec.normalize('furniture'),
        '["furniture"]',
      );
    });
  });
}
