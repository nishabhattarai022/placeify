import 'package:placeify_server/src/generated/protocol.dart';
import 'package:placeify_server/src/modules/vendor/vendor_bank_details_validation.dart';
import 'package:placeify_server/src/shared/placeify_exception.dart';
import 'package:test/test.dart';

void main() {
  group('VendorBankDetailsValidation', () {
    VendorBankDetailsInput validInput() => VendorBankDetailsInput(
          accountHolderName: 'Anisha Furniture',
          bankName: 'Nepal Bank',
          accountNumber: '1234567890',
          branchCode: 'NBL1234',
        );

    test('accepts valid bank details', () {
      expect(
        () => VendorBankDetailsValidation.validateInput(validInput()),
        returnsNormally,
      );
    });

    test('rejects empty account holder', () {
      expect(
        () => VendorBankDetailsValidation.validateInput(
          validInput().copyWith(accountHolderName: ' '),
        ),
        throwsA(
          isA<PlaceifyException>().having(
            (error) => error.code,
            'code',
            'INVALID_ACCOUNT_HOLDER',
          ),
        ),
      );
    });

    test('rejects short account number', () {
      expect(
        () => VendorBankDetailsValidation.validateInput(
          validInput().copyWith(accountNumber: '12345'),
        ),
        throwsA(
          isA<PlaceifyException>().having(
            (error) => error.code,
            'code',
            'INVALID_ACCOUNT_NUMBER',
          ),
        ),
      );
    });

    test('rejects short branch code', () {
      expect(
        () => VendorBankDetailsValidation.validateInput(
          validInput().copyWith(branchCode: '12345'),
        ),
        throwsA(
          isA<PlaceifyException>().having(
            (error) => error.code,
            'code',
            'INVALID_BRANCH_CODE',
          ),
        ),
      );
    });
  });
}
