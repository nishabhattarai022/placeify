import 'package:placeify_server/src/generated/placeify_exception.dart';
import 'package:placeify_server/src/generated/protocol.dart';
import 'package:placeify_server/src/shared/vendor_purchase_policy.dart';
import 'package:serverpod/serverpod.dart' show UuidValue;
import 'package:test/test.dart';

void main() {
  group('VendorPurchasePolicy', () {
    final shopA = UuidValue.fromString('00000000-0000-7000-8000-000000000001');
    final shopB = UuidValue.fromString('00000000-0000-7000-8000-000000000002');

    test('isOwnShopProduct returns false without a buyer shop', () {
      expect(
        VendorPurchasePolicy.isOwnShopProduct(
          productVendorId: shopA,
          buyerShopVendorId: null,
        ),
        isFalse,
      );
    });

    test('isOwnShopProduct matches vendor ids', () {
      expect(
        VendorPurchasePolicy.isOwnShopProduct(
          productVendorId: shopA,
          buyerShopVendorId: shopA,
        ),
        isTrue,
      );
      expect(
        VendorPurchasePolicy.isOwnShopProduct(
          productVendorId: shopA,
          buyerShopVendorId: shopB,
        ),
        isFalse,
      );
    });

    test('assertCanAddProductToCart throws for own shop products', () {
      expect(
        () => VendorPurchasePolicy.assertCanAddProductToCart(
          productVendorId: shopA,
          buyerShopVendorId: shopA,
        ),
        throwsA(
          isA<PlaceifyException>().having(
            (error) => error.code,
            'code',
            'OWN_SHOP_PURCHASE_FORBIDDEN',
          ),
        ),
      );
    });

    test('assertCanCheckoutProducts throws when cart has own shop item', () {
      expect(
        () => VendorPurchasePolicy.assertCanCheckoutProducts(
          buyerShopVendorId: shopA,
          products: [
            Product(
              vendorId: shopA,
              name: 'Chair',
              description: 'Test',
              price: 10,
            ),
          ],
        ),
        throwsA(
          isA<PlaceifyException>().having(
            (error) => error.code,
            'code',
            'OWN_SHOP_ORDER_FORBIDDEN',
          ),
        ),
      );
    });
  });
}
