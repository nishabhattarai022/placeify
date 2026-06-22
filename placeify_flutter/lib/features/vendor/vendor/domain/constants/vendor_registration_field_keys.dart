/// Field keys used for vendor registration validation errors.
abstract final class VendorRegistrationFieldKeys {
  static const businessName = 'business.businessName';
  static const contactName = 'business.contactName';
  static const email = 'business.email';
  static const phone = 'business.phone';
  static const taxId = 'business.taxId';

  static const street = 'address.street';
  static const city = 'address.city';
  static const state = 'address.state';
  static const postalCode = 'address.postalCode';
  static const country = 'address.country';

  static const category = 'category.category';
  static const categories = 'category.categories';
  static const categoryDescription = 'category.description';

  static const businessLicense = 'documents.businessLicense';
  static const governmentId = 'documents.governmentId';
  static const taxCertificate = 'documents.taxCertificate';

  static const accountHolderName = 'bank.accountHolderName';
  static const bankName = 'bank.bankName';
  static const accountNumber = 'bank.accountNumber';
  static const routingNumber = 'bank.routingNumber';
}

/// Returns true when the value is a persisted server document URL.
bool isUploadedVendorDocument(String? value) {
  if (value == null || value.trim().isEmpty) return false;
  return value.startsWith('/uploads/') ||
      value.startsWith('http://') ||
      value.startsWith('https://');
}
