import 'package:flutter_test/flutter_test.dart';
import 'package:placeify_client/placeify_client.dart';
import 'package:placeify_flutter/features/cart/data/cart_api_errors.dart';
import 'package:placeify_flutter/features/cart/domain/constants/cart_strings.dart';

void main() {
  group('CartApiErrors', () {
    test('maps own-shop codes without treating unrelated text as own-product', () {
      expect(
        CartApiErrors.message(
          PlaceifyException(
            message: "You cannot add your own shop's product to cart.",
            code: 'OWN_SHOP_PURCHASE_FORBIDDEN',
          ),
        ),
        CartStrings.ownProductBlocked,
      );
      expect(
        CartApiErrors.message(
          StateError(
            'OWN_SHOP_ORDER_FORBIDDEN: Your order contains a product from your own shop.',
          ),
        ),
        contains('own shop'),
      );
    });

    test('maps eSewa outage instead of own-product', () {
      expect(
        CartApiErrors.message(
          PlaceifyException(
            message: 'eSewa is temporarily unavailable. Please try again later.',
            code: 'ESEWA_UNAVAILABLE',
          ),
        ),
        CartStrings.esewaUnavailable,
      );
      expect(
        CartApiErrors.message(
          StateError("SocketException: Failed host lookup: 'rc.esewa.com.np'"),
        ),
        CartStrings.esewaUnavailable,
      );
      expect(
        CartApiErrors.message(
          StateError('eSewa status HTTP 503'),
        ),
        CartStrings.esewaUnavailable,
      );
    });

    test('maps placeify server connectivity failures', () {
      expect(
        CartApiErrors.message(
          StateError('SocketException: Connection refused'),
        ),
        CartStrings.serverUnreachable,
      );
      expect(
        CartApiErrors.message(
          StateError('TimeoutException after 0:00:20.000000: Future not completed'),
        ),
        CartStrings.serverUnreachable,
      );
    });

    test('does not treat generic text containing YOUR OWN as own-product', () {
      expect(
        CartApiErrors.message(
          StateError('Please check your own network settings and retry.'),
          fallback: 'fallback',
        ),
        'fallback',
      );
    });
  });
}
