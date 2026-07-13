import 'package:flutter/foundation.dart';
import 'package:placeify_client/placeify_client.dart'
    hide Product, VendorBankDetails;
import 'package:placeify_flutter/core/config/placeify_server_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:placeify_flutter/features/vendor/domain/constants/vendor_registration_field_keys.dart'
    show isUploadedVendorDocument;
import 'package:placeify_flutter/features/vendor/domain/models/vendor_registration.dart';
import 'package:placeify_flutter/features/vendor/domain/repositories/vendor_registration_repository.dart';
import 'package:placeify_flutter/features/vendor/data/vendor_shop_category_codec.dart';
import 'package:placeify_flutter/features/vendor/data/vendor_bank_details_mapper.dart';

/// Persists vendor registration submissions to PostgreSQL via [client.vendor.createShop].
class ServerpodVendorRegistrationRepository
    implements VendorRegistrationRepository {
  ServerpodVendorRegistrationRepository();

  @override
  bool simulateNetworkError = false;

  @override
  Future<String> submitRegistration(VendorRegistration registration) async {
    if (simulateNetworkError) {
      throw VendorRegistrationException(
        'Could not submit registration. Check your connection and try again.',
      );
    }

    if (!client.auth.isAuthenticated) {
      throw VendorRegistrationException('Sign in to register as a vendor.');
    }

    final business = registration.business;
    final address = registration.address;
    final category = registration.category;
    final bank = registration.bank;

    final shopName = business.businessName.trim();
    final phone = business.phone.trim();
    final contactEmail = business.email.trim();
    final streetLine = address.street.trim();
    final city = address.city.trim();
    final country = address.country.trim();

    final fullAddress = [
      streetLine,
      if (city.isNotEmpty) city,
      if (address.state.trim().isNotEmpty) address.state.trim(),
      if (address.postalCode.trim().isNotEmpty) address.postalCode.trim(),
      if (country.isNotEmpty) country,
    ].join(', ');

    if (shopName.isEmpty ||
        phone.isEmpty ||
        category.categories.isEmpty ||
        fullAddress.isEmpty ||
        bank.accountHolderName.trim().isEmpty ||
        bank.bankName.trim().isEmpty ||
        bank.accountNumber.trim().length < 6 ||
        bank.routingNumber.trim().length < 6) {
      throw VendorRegistrationException(
        'Complete all required fields before submitting.',
      );
    }

    final licensePath = registration.documents.businessLicensePath;
    final governmentIdPath = registration.documents.governmentIdPath;
    final taxCertificatePath = registration.documents.taxCertificatePath;

    if (kDebugMode) {
      debugPrint(
        'vendor_registration_docs '
        'businessLicensePath=$licensePath '
        'governmentIdPath=$governmentIdPath '
        'taxCertificatePath=$taxCertificatePath',
      );
    }

    final missingDocuments = <String>[
      if (!isUploadedVendorDocument(licensePath)) 'Business License',
      if (!isUploadedVendorDocument(governmentIdPath)) 'Government ID',
    ];
    if (missingDocuments.isNotEmpty) {
      throw VendorRegistrationException(
        missingDocuments.length == 1
            ? 'Upload ${missingDocuments.first} before submitting.'
            : 'Upload ${missingDocuments.join(' and ')} before submitting.',
      );
    }

    final description = category.description.trim().isNotEmpty
        ? category.description.trim()
        : '$shopName — ${category.categoriesLabel} vendor on Placeify.';

    final shopCategory = VendorShopCategoryCodec.encode(category.categories);
    final bankDetails = VendorBankDetailsMapper.toApiInput(bank);

    try {
      final vendor = await client.vendor.createShop(
        shopName,
        description: description,
        phone: phone,
        address: fullAddress,
        city: city.isEmpty ? null : city,
        country: country.isEmpty ? null : country,
        shopCategory: shopCategory,
        contactEmail: contactEmail.isEmpty ? null : contactEmail,
        bankDetails: bankDetails,
      );

      return vendor.id.toString();
    } catch (error) {
      throw VendorRegistrationException(_mapError(error));
    }
  }

  String _mapError(Object error) {
    if (error is VendorRegistrationException) return error.message;
    if (error is PlaceifyException) {
      return switch (error.code) {
        'VENDOR_EXISTS' =>
          'You already have a vendor shop linked to this account.',
        'INVALID_SHOP_NAME' => 'Enter your business name.',
        'INVALID_DESCRIPTION' ||
        'INVALID_SHOP_DESCRIPTION' => 'Add a short store description.',
        'INVALID_PHONE' ||
        'INVALID_PHONE_FORMAT' => 'Enter a valid phone number.',
        'INVALID_ADDRESS' || 'MISSING_REQUIRED_FIELD' => error.message,
        'BUSINESS_NAME_TOO_SHORT' => error.message,
        'BUSINESS_NAME_TOO_LONG' => error.message,
        'INVALID_ACCOUNT_HOLDER' ||
        'INVALID_BANK_NAME' ||
        'INVALID_ACCOUNT_NUMBER' ||
        'INVALID_BRANCH_CODE' => error.message,
        _ => error.message,
      };
    }

    final raw = error.toString();
    if (raw.toLowerCase().contains('socketexception') ||
        raw.toLowerCase().contains('connection refused')) {
      return 'Cannot reach the server. Make sure placeify_server is running.';
    }
    return 'Could not submit registration. Please try again.';
  }
}
