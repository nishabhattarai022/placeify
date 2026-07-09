import '../../shared/placeify_exception.dart';

/// Validates vendor profile update payloads before persisting to PostgreSQL.
abstract final class VendorProfileValidation {
  static const businessNameMinLength = 2;
  static const businessNameMaxLength = 80;
  static const bioMaxLength = 500;
  static const phoneMinLength = 7;
  static const phoneMaxLength = 20;
  static const addressMaxLength = 200;
  static const cityMaxLength = 80;
  static const countryMaxLength = 80;

  static final _emailPattern = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final _phonePattern = RegExp(r'^[+]?[\d\s().-]{7,20}$');

  /// Throws [PlaceifyException] when any provided field fails validation.
  static void validateUpdate({
    String? businessName,
    String? phone,
    String? address,
    String? city,
    String? country,
    String? bio,
  }) {
    if (businessName != null) {
      final trimmed = businessName.trim();
      if (trimmed.isEmpty) {
        throw PlaceifyException(
          message: 'Shop name is required.',
          code: 'INVALID_BUSINESS_NAME',
        );
      }
      if (trimmed.length < businessNameMinLength) {
        throw PlaceifyException(
          message:
              'Shop name must be at least $businessNameMinLength characters.',
          code: 'BUSINESS_NAME_TOO_SHORT',
        );
      }
      if (trimmed.length > businessNameMaxLength) {
        throw PlaceifyException(
          message:
              'Shop name must be $businessNameMaxLength characters or fewer.',
          code: 'BUSINESS_NAME_TOO_LONG',
        );
      }
    }

    if (phone != null) {
      final trimmed = phone.trim();
      if (trimmed.isEmpty) {
        throw PlaceifyException(
          message: 'Phone number is required.',
          code: 'INVALID_PHONE',
        );
      }
      if (!_phonePattern.hasMatch(trimmed)) {
        throw PlaceifyException(
          message: 'Enter a valid phone number.',
          code: 'INVALID_PHONE_FORMAT',
        );
      }
    }

    if (address != null) {
      final trimmed = address.trim();
      if (trimmed.isEmpty) {
        throw PlaceifyException(
          message: 'Address is required.',
          code: 'INVALID_ADDRESS',
        );
      }
      if (trimmed.length > addressMaxLength) {
        throw PlaceifyException(
          message: 'Address must be $addressMaxLength characters or fewer.',
          code: 'ADDRESS_TOO_LONG',
        );
      }
    }

    if (city != null) {
      final trimmed = city.trim();
      if (trimmed.length > cityMaxLength) {
        throw PlaceifyException(
          message: 'City must be $cityMaxLength characters or fewer.',
          code: 'CITY_TOO_LONG',
        );
      }
    }

    if (country != null) {
      final trimmed = country.trim();
      if (trimmed.length > countryMaxLength) {
        throw PlaceifyException(
          message: 'Country must be $countryMaxLength characters or fewer.',
          code: 'COUNTRY_TOO_LONG',
        );
      }
    }

    if (bio != null && bio.trim().length > bioMaxLength) {
      throw PlaceifyException(
        message: 'Description must be $bioMaxLength characters or fewer.',
        code: 'BIO_TOO_LONG',
      );
    }
  }

  /// Validates email format when profile email is updated separately.
  static void validateEmail(String? email) {
    if (email == null) return;
    final trimmed = email.trim();
    if (trimmed.isEmpty) {
      throw PlaceifyException(
        message: 'Email is required.',
        code: 'INVALID_EMAIL',
      );
    }
    if (!_emailPattern.hasMatch(trimmed)) {
      throw PlaceifyException(
        message: 'Enter a valid email address.',
        code: 'INVALID_EMAIL_FORMAT',
      );
    }
  }
}
