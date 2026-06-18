import 'package:placeify_server/src/generated/protocol.dart';
import 'package:placeify_server/src/modules/vendor/vendor_profile_validation.dart';
import 'package:placeify_server/src/shared/placeify_exception.dart';
import 'package:test/test.dart';

void main() {
  group('VendorProfileValidation', () {
    test('accepts valid update fields', () {
      expect(
        () => VendorProfileValidation.validateUpdate(
          businessName: 'Anisha Furniture',
          phone: '+977 9800000000',
          address: 'Patan, Lalitpur',
          city: 'Lalitpur',
          country: 'Nepal',
          bio: 'Handcrafted wood furniture.',
        ),
        returnsNormally,
      );
    });

    test('rejects empty shop name', () {
      expect(
        () => VendorProfileValidation.validateUpdate(businessName: '  '),
        throwsA(
          isA<PlaceifyException>().having(
            (error) => error.code,
            'code',
            'INVALID_BUSINESS_NAME',
          ),
        ),
      );
    });

    test('rejects shop name that is too short', () {
      expect(
        () => VendorProfileValidation.validateUpdate(businessName: 'A'),
        throwsA(
          isA<PlaceifyException>().having(
            (error) => error.code,
            'code',
            'BUSINESS_NAME_TOO_SHORT',
          ),
        ),
      );
    });

    test('rejects invalid phone format', () {
      expect(
        () => VendorProfileValidation.validateUpdate(phone: 'abc'),
        throwsA(
          isA<PlaceifyException>().having(
            (error) => error.code,
            'code',
            'INVALID_PHONE_FORMAT',
          ),
        ),
      );
    });

    test('rejects bio longer than max length', () {
      expect(
        () => VendorProfileValidation.validateUpdate(
          bio: 'x' * (VendorProfileValidation.bioMaxLength + 1),
        ),
        throwsA(
          isA<PlaceifyException>().having(
            (error) => error.code,
            'code',
            'BIO_TOO_LONG',
          ),
        ),
      );
    });

    test('rejects invalid email format', () {
      expect(
        () => VendorProfileValidation.validateEmail('not-an-email'),
        throwsA(
          isA<PlaceifyException>().having(
            (error) => error.code,
            'code',
            'INVALID_EMAIL_FORMAT',
          ),
        ),
      );
    });
  });
}
