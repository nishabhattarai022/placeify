/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Payload for creating or updating vendor payout bank details.
abstract class VendorBankDetailsInput
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  VendorBankDetailsInput._({
    required this.accountHolderName,
    required this.bankName,
    required this.accountNumber,
    required this.branchCode,
  });

  factory VendorBankDetailsInput({
    required String accountHolderName,
    required String bankName,
    required String accountNumber,
    required String branchCode,
  }) = _VendorBankDetailsInputImpl;

  factory VendorBankDetailsInput.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return VendorBankDetailsInput(
      accountHolderName: jsonSerialization['accountHolderName'] as String,
      bankName: jsonSerialization['bankName'] as String,
      accountNumber: jsonSerialization['accountNumber'] as String,
      branchCode: jsonSerialization['branchCode'] as String,
    );
  }

  String accountHolderName;

  String bankName;

  String accountNumber;

  String branchCode;

  /// Returns a shallow copy of this [VendorBankDetailsInput]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VendorBankDetailsInput copyWith({
    String? accountHolderName,
    String? bankName,
    String? accountNumber,
    String? branchCode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VendorBankDetailsInput',
      'accountHolderName': accountHolderName,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'branchCode': branchCode,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VendorBankDetailsInput',
      'accountHolderName': accountHolderName,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'branchCode': branchCode,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _VendorBankDetailsInputImpl extends VendorBankDetailsInput {
  _VendorBankDetailsInputImpl({
    required String accountHolderName,
    required String bankName,
    required String accountNumber,
    required String branchCode,
  }) : super._(
         accountHolderName: accountHolderName,
         bankName: bankName,
         accountNumber: accountNumber,
         branchCode: branchCode,
       );

  /// Returns a shallow copy of this [VendorBankDetailsInput]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VendorBankDetailsInput copyWith({
    String? accountHolderName,
    String? bankName,
    String? accountNumber,
    String? branchCode,
  }) {
    return VendorBankDetailsInput(
      accountHolderName: accountHolderName ?? this.accountHolderName,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      branchCode: branchCode ?? this.branchCode,
    );
  }
}
