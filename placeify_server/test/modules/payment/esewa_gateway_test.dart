import 'package:placeify_server/src/modules/payment/esewa_gateway.dart';
import 'package:test/test.dart';

void main() {
  group('EsewaGateway', () {
    test('uses live rc.esewa.com.np host for test product codes', () {
      final fields = EsewaGateway.buildFormFields(
        amount: 100,
        transactionUuid: 'esewa-1-test',
        productCode: 'EPAYTEST',
        secretKey: '8gBm/:&EnhH.1/q',
      );

      expect(
        fields['payment_url'],
        'https://rc.esewa.com.np/api/epay/main/v2/form',
      );
      expect(fields['payment_url'], isNot(contains('rc-epay')));
    });

    test('uses production epay host for live merchant codes', () {
      final fields = EsewaGateway.buildFormFields(
        amount: 250.5,
        transactionUuid: 'esewa-42-live',
        productCode: 'PLACEIFY-LIVE',
        secretKey: 'live-secret',
      );

      expect(
        fields['payment_url'],
        'https://epay.esewa.com.np/api/epay/main/v2/form',
      );
    });
  });
}
