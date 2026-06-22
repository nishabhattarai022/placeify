import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';

/// Validates vendor payout bank detail payloads.
abstract final class VendorBankDetailsValidation {
  static const accountHolderMinLength = 2;
  static const accountHolderMaxLength = 80;
  static const bankNameMinLength = 2;
  static const bankNameMaxLength = 80;
  static const accountNumberMinLength = 6;
  static const accountNumberMaxLength = 34;
  static const branchCodeMinLength = 6;
  static const branchCodeMaxLength = 20;

  static void validateInput(VendorBankDetailsInput input) {
    validateFields(
      accountHolderName: input.accountHolderName,
      bankName: input.bankName,
      accountNumber: input.accountNumber,
      branchCode: input.branchCode,
    );
  }

  static void validateFields({
    required String accountHolderName,
    required String bankName,
    required String accountNumber,
    required String branchCode,
  }) {
    final holder = accountHolderName.trim();
    if (holder.isEmpty) {
      throw PlaceifyException(
        message: 'Account holder name is required.',
        code: 'INVALID_ACCOUNT_HOLDER',
      );
    }
    if (holder.length < accountHolderMinLength) {
      throw PlaceifyException(
        message:
            'Account holder name must be at least $accountHolderMinLength characters.',
        code: 'INVALID_ACCOUNT_HOLDER',
      );
    }
    if (holder.length > accountHolderMaxLength) {
      throw PlaceifyException(
        message:
            'Account holder name must be $accountHolderMaxLength characters or fewer.',
        code: 'INVALID_ACCOUNT_HOLDER',
      );
    }

    final bank = bankName.trim();
    if (bank.isEmpty) {
      throw PlaceifyException(
        message: 'Bank name is required.',
        code: 'INVALID_BANK_NAME',
      );
    }
    if (bank.length < bankNameMinLength) {
      throw PlaceifyException(
        message: 'Bank name must be at least $bankNameMinLength characters.',
        code: 'INVALID_BANK_NAME',
      );
    }
    if (bank.length > bankNameMaxLength) {
      throw PlaceifyException(
        message: 'Bank name must be $bankNameMaxLength characters or fewer.',
        code: 'INVALID_BANK_NAME',
      );
    }

    final account = accountNumber.trim();
    if (account.length < accountNumberMinLength) {
      throw PlaceifyException(
        message:
            'Account number must be at least $accountNumberMinLength characters.',
        code: 'INVALID_ACCOUNT_NUMBER',
      );
    }
    if (account.length > accountNumberMaxLength) {
      throw PlaceifyException(
        message:
            'Account number must be $accountNumberMaxLength characters or fewer.',
        code: 'INVALID_ACCOUNT_NUMBER',
      );
    }

    final branch = branchCode.trim();
    if (branch.length < branchCodeMinLength) {
      throw PlaceifyException(
        message:
            'Branch or routing code must be at least $branchCodeMinLength characters.',
        code: 'INVALID_BRANCH_CODE',
      );
    }
    if (branch.length > branchCodeMaxLength) {
      throw PlaceifyException(
        message:
            'Branch or routing code must be $branchCodeMaxLength characters or fewer.',
        code: 'INVALID_BRANCH_CODE',
      );
    }
  }
}
