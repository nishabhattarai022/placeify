import 'package:placeify_client/placeify_client.dart' as api;

import '../domain/models/vendor_registration.dart';

/// Maps Flutter vendor bank details to Serverpod API models.
abstract final class VendorBankDetailsMapper {
  static api.VendorBankDetailsInput toApiInput(VendorBankDetails bank) {
    return api.VendorBankDetailsInput(
      accountHolderName: bank.accountHolderName.trim(),
      bankName: bank.bankName.trim(),
      accountNumber: bank.accountNumber.trim(),
      branchCode: bank.routingNumber.trim(),
    );
  }

  static VendorBankDetails fromApiDetail(api.VendorBankDetails detail) {
    return VendorBankDetails(
      accountHolderName: detail.accountHolderName,
      bankName: detail.bankName,
      accountNumber: detail.accountNumber,
      routingNumber: detail.branchCode,
    );
  }
}
