import 'package:placeify_flutter/core/constants/country_phone_codes.dart';
import 'package:placeify_flutter/features/vendor/domain/constants/vendor_registration_field_keys.dart'
    show isUploadedVendorDocument;
import 'package:placeify_flutter/features/vendor/domain/models/vendor_registration.dart';

/// Map keys for inline field error display on the vendor registration form.
abstract final class VendorRegistrationFieldKeys {
  static const businessName = 'businessName';
  static const contactName = 'contactName';
  static const email = 'email';
  static const phone = 'phone';
  static const taxId = 'taxId';

  static const street = 'street';
  static const city = 'city';
  static const state = 'state';
  static const postalCode = 'postalCode';
  static const country = 'country';

  static const categories = 'categories';

  static const businessLicense = 'businessLicense';
  static const governmentId = 'governmentId';
  static const taxCertificate = 'taxCertificate';

  static const accountHolderName = 'accountHolderName';
  static const bankName = 'bankName';
  static const accountNumber = 'accountNumber';
  static const routingNumber = 'routingNumber';
}

/// Pure-Dart validation for the multi-step vendor registration flow.
abstract final class VendorRegistrationValidator {
  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  /// Returns a map of field keys to user-facing error messages.
  /// Empty when the step is valid.
  static Map<String, String> validateStep(int step, VendorRegistration form) {
    return switch (step) {
      0 => _validateBusiness(form.business),
      1 => _validateAddress(form.address),
      2 => _validateCategory(form.category),
      3 => _validateDocuments(form.documents),
      4 => _validateBank(form.bank),
      5 => _validateAll(form),
      _ => const {},
    };
  }

  static Map<String, String> _validateAll(VendorRegistration form) {
    for (var step = 0; step < 5; step++) {
      final errors = validateStep(step, form);
      if (errors.isNotEmpty) return errors;
    }
    return const {};
  }

  static Map<String, String> _validateBusiness(VendorBusinessInfo business) {
    final errors = <String, String>{};
    final name = business.businessName.trim();
    if (name.isEmpty) {
      errors[VendorRegistrationFieldKeys.businessName] =
          'Business name is required';
    }

    final contact = business.contactName.trim();
    if (contact.isEmpty) {
      errors[VendorRegistrationFieldKeys.contactName] =
          'Contact name is required';
    }

    final email = business.email.trim();
    if (email.isEmpty) {
      errors[VendorRegistrationFieldKeys.email] = 'Email is required';
    } else if (!_emailRegex.hasMatch(email)) {
      errors[VendorRegistrationFieldKeys.email] =
          'Enter a valid email address (e.g. vendor@example.com)';
    }

    final phoneError = CountryPhoneCodes.validatePhone(business.phone);
    if (phoneError != null) {
      errors[VendorRegistrationFieldKeys.phone] = phoneError;
    }

    final taxId = business.taxId.trim();
    if (taxId.isEmpty) {
      errors[VendorRegistrationFieldKeys.taxId] =
          'PAN / VAT number is required';
    } else if (taxId.length != 9 || !RegExp(r'^\d{9}$').hasMatch(taxId)) {
      errors[VendorRegistrationFieldKeys.taxId] =
          'PAN / VAT number must be exactly 9 digits';
    }

    return errors;
  }

  static Map<String, String> _validateAddress(VendorAddress address) {
    final errors = <String, String>{};

    if (address.street.trim().isEmpty) {
      errors[VendorRegistrationFieldKeys.street] =
          'Street address is required';
    }
    if (address.city.trim().isEmpty) {
      errors[VendorRegistrationFieldKeys.city] = 'City is required';
    }
    if (address.state.trim().isEmpty) {
      errors[VendorRegistrationFieldKeys.state] =
          'State / province is required';
    }
    if (address.postalCode.trim().isEmpty) {
      errors[VendorRegistrationFieldKeys.postalCode] =
          'Postal code is required';
    }
    if (address.country.trim().isEmpty) {
      errors[VendorRegistrationFieldKeys.country] = 'Country is required';
    }

    return errors;
  }

  static Map<String, String> _validateCategory(VendorCategoryInfo category) {
    if (category.categories.isEmpty) {
      return {
        VendorRegistrationFieldKeys.categories:
            'Select at least one product category',
      };
    }
    return const {};
  }

  static Map<String, String> _validateDocuments(VendorDocuments documents) {
    final errors = <String, String>{};

    if (!isUploadedVendorDocument(documents.businessLicensePath)) {
      errors[VendorRegistrationFieldKeys.businessLicense] =
          'Upload your business license';
    }
    if (!isUploadedVendorDocument(documents.governmentIdPath)) {
      errors[VendorRegistrationFieldKeys.governmentId] =
          'Upload a government-issued ID';
    }

    return errors;
  }

  static Map<String, String> _validateBank(VendorBankDetails bank) {
    final errors = <String, String>{};

    if (bank.accountHolderName.trim().isEmpty) {
      errors[VendorRegistrationFieldKeys.accountHolderName] =
          'Account holder name is required';
    }
    if (bank.bankName.trim().isEmpty) {
      errors[VendorRegistrationFieldKeys.bankName] = 'Bank name is required';
    }
    if (bank.accountNumber.trim().length < 6) {
      errors[VendorRegistrationFieldKeys.accountNumber] =
          'Enter a valid account number (at least 6 digits)';
    }
    if (bank.routingNumber.trim().length < 6) {
      errors[VendorRegistrationFieldKeys.routingNumber] =
          'Enter a valid branch / SWIFT code (at least 6 characters)';
    }

    return errors;
  }

  /// Returns the first step index (0–4) that has validation errors, or null.
  static int? firstInvalidStep(VendorRegistration form) {
    for (var step = 0; step < 5; step++) {
      if (validateStep(step, form).isNotEmpty) return step;
    }
    return null;
  }
}
