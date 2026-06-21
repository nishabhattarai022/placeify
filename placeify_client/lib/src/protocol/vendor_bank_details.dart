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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'vendor.dart' as _i2;
import 'package:placeify_client/src/protocol/protocol.dart' as _i3;

/// Payout bank account linked 1:1 to a vendor shop.
abstract class VendorBankDetails implements _i1.SerializableModel {
  VendorBankDetails._({
    this.id,
    required this.vendorId,
    this.vendor,
    required this.accountHolderName,
    required this.bankName,
    required this.accountNumber,
    required this.branchCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory VendorBankDetails({
    int? id,
    required _i1.UuidValue vendorId,
    _i2.Vendor? vendor,
    required String accountHolderName,
    required String bankName,
    required String accountNumber,
    required String branchCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _VendorBankDetailsImpl;

  factory VendorBankDetails.fromJson(Map<String, dynamic> jsonSerialization) {
    return VendorBankDetails(
      id: jsonSerialization['id'] as int?,
      vendorId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['vendorId'],
      ),
      vendor: jsonSerialization['vendor'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Vendor>(jsonSerialization['vendor']),
      accountHolderName: jsonSerialization['accountHolderName'] as String,
      bankName: jsonSerialization['bankName'] as String,
      accountNumber: jsonSerialization['accountNumber'] as String,
      branchCode: jsonSerialization['branchCode'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue vendorId;

  _i2.Vendor? vendor;

  String accountHolderName;

  String bankName;

  String accountNumber;

  /// Branch code, IFSC, routing number, or SWIFT — region-specific payout identifier.
  String branchCode;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [VendorBankDetails]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VendorBankDetails copyWith({
    int? id,
    _i1.UuidValue? vendorId,
    _i2.Vendor? vendor,
    String? accountHolderName,
    String? bankName,
    String? accountNumber,
    String? branchCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VendorBankDetails',
      if (id != null) 'id': id,
      'vendorId': vendorId.toJson(),
      if (vendor != null) 'vendor': vendor?.toJson(),
      'accountHolderName': accountHolderName,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'branchCode': branchCode,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VendorBankDetailsImpl extends VendorBankDetails {
  _VendorBankDetailsImpl({
    int? id,
    required _i1.UuidValue vendorId,
    _i2.Vendor? vendor,
    required String accountHolderName,
    required String bankName,
    required String accountNumber,
    required String branchCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         vendorId: vendorId,
         vendor: vendor,
         accountHolderName: accountHolderName,
         bankName: bankName,
         accountNumber: accountNumber,
         branchCode: branchCode,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [VendorBankDetails]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VendorBankDetails copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? vendorId,
    Object? vendor = _Undefined,
    String? accountHolderName,
    String? bankName,
    String? accountNumber,
    String? branchCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VendorBankDetails(
      id: id is int? ? id : this.id,
      vendorId: vendorId ?? this.vendorId,
      vendor: vendor is _i2.Vendor? ? vendor : this.vendor?.copyWith(),
      accountHolderName: accountHolderName ?? this.accountHolderName,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      branchCode: branchCode ?? this.branchCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
