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
import 'user_account_status.dart' as _i2;

/// Full vendor application detail for admin review screens.
abstract class VendorApplicationDetail
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  VendorApplicationDetail._({
    required this.vendorId,
    required this.userId,
    required this.status,
    required this.submittedAt,
    required this.businessName,
    required this.contactName,
    required this.contactEmail,
    required this.phone,
    this.taxId,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.category,
    required this.description,
    this.businessLicenseUrl,
    this.governmentIdUrl,
    this.taxCertificateUrl,
    this.moderationNote,
    this.moderatedAt,
  });

  factory VendorApplicationDetail({
    required _i1.UuidValue vendorId,
    required _i1.UuidValue userId,
    required _i2.UserAccountStatus status,
    required DateTime submittedAt,
    required String businessName,
    required String contactName,
    required String contactEmail,
    required String phone,
    String? taxId,
    required String street,
    required String city,
    required String state,
    required String postalCode,
    required String country,
    required String category,
    required String description,
    String? businessLicenseUrl,
    String? governmentIdUrl,
    String? taxCertificateUrl,
    String? moderationNote,
    DateTime? moderatedAt,
  }) = _VendorApplicationDetailImpl;

  factory VendorApplicationDetail.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return VendorApplicationDetail(
      vendorId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['vendorId'],
      ),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      status: _i2.UserAccountStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      submittedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['submittedAt'],
      ),
      businessName: jsonSerialization['businessName'] as String,
      contactName: jsonSerialization['contactName'] as String,
      contactEmail: jsonSerialization['contactEmail'] as String,
      phone: jsonSerialization['phone'] as String,
      taxId: jsonSerialization['taxId'] as String?,
      street: jsonSerialization['street'] as String,
      city: jsonSerialization['city'] as String,
      state: jsonSerialization['state'] as String,
      postalCode: jsonSerialization['postalCode'] as String,
      country: jsonSerialization['country'] as String,
      category: jsonSerialization['category'] as String,
      description: jsonSerialization['description'] as String,
      businessLicenseUrl: jsonSerialization['businessLicenseUrl'] as String?,
      governmentIdUrl: jsonSerialization['governmentIdUrl'] as String?,
      taxCertificateUrl: jsonSerialization['taxCertificateUrl'] as String?,
      moderationNote: jsonSerialization['moderationNote'] as String?,
      moderatedAt: jsonSerialization['moderatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['moderatedAt'],
            ),
    );
  }

  _i1.UuidValue vendorId;

  _i1.UuidValue userId;

  _i2.UserAccountStatus status;

  DateTime submittedAt;

  String businessName;

  String contactName;

  String contactEmail;

  String phone;

  String? taxId;

  String street;

  String city;

  String state;

  String postalCode;

  String country;

  String category;

  String description;

  String? businessLicenseUrl;

  String? governmentIdUrl;

  String? taxCertificateUrl;

  String? moderationNote;

  DateTime? moderatedAt;

  /// Returns a shallow copy of this [VendorApplicationDetail]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VendorApplicationDetail copyWith({
    _i1.UuidValue? vendorId,
    _i1.UuidValue? userId,
    _i2.UserAccountStatus? status,
    DateTime? submittedAt,
    String? businessName,
    String? contactName,
    String? contactEmail,
    String? phone,
    String? taxId,
    String? street,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    String? category,
    String? description,
    String? businessLicenseUrl,
    String? governmentIdUrl,
    String? taxCertificateUrl,
    String? moderationNote,
    DateTime? moderatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VendorApplicationDetail',
      'vendorId': vendorId.toJson(),
      'userId': userId.toJson(),
      'status': status.toJson(),
      'submittedAt': submittedAt.toJson(),
      'businessName': businessName,
      'contactName': contactName,
      'contactEmail': contactEmail,
      'phone': phone,
      if (taxId != null) 'taxId': taxId,
      'street': street,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
      'category': category,
      'description': description,
      if (businessLicenseUrl != null) 'businessLicenseUrl': businessLicenseUrl,
      if (governmentIdUrl != null) 'governmentIdUrl': governmentIdUrl,
      if (taxCertificateUrl != null) 'taxCertificateUrl': taxCertificateUrl,
      if (moderationNote != null) 'moderationNote': moderationNote,
      if (moderatedAt != null) 'moderatedAt': moderatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VendorApplicationDetail',
      'vendorId': vendorId.toJson(),
      'userId': userId.toJson(),
      'status': status.toJson(),
      'submittedAt': submittedAt.toJson(),
      'businessName': businessName,
      'contactName': contactName,
      'contactEmail': contactEmail,
      'phone': phone,
      if (taxId != null) 'taxId': taxId,
      'street': street,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
      'category': category,
      'description': description,
      if (businessLicenseUrl != null) 'businessLicenseUrl': businessLicenseUrl,
      if (governmentIdUrl != null) 'governmentIdUrl': governmentIdUrl,
      if (taxCertificateUrl != null) 'taxCertificateUrl': taxCertificateUrl,
      if (moderationNote != null) 'moderationNote': moderationNote,
      if (moderatedAt != null) 'moderatedAt': moderatedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VendorApplicationDetailImpl extends VendorApplicationDetail {
  _VendorApplicationDetailImpl({
    required _i1.UuidValue vendorId,
    required _i1.UuidValue userId,
    required _i2.UserAccountStatus status,
    required DateTime submittedAt,
    required String businessName,
    required String contactName,
    required String contactEmail,
    required String phone,
    String? taxId,
    required String street,
    required String city,
    required String state,
    required String postalCode,
    required String country,
    required String category,
    required String description,
    String? businessLicenseUrl,
    String? governmentIdUrl,
    String? taxCertificateUrl,
    String? moderationNote,
    DateTime? moderatedAt,
  }) : super._(
         vendorId: vendorId,
         userId: userId,
         status: status,
         submittedAt: submittedAt,
         businessName: businessName,
         contactName: contactName,
         contactEmail: contactEmail,
         phone: phone,
         taxId: taxId,
         street: street,
         city: city,
         state: state,
         postalCode: postalCode,
         country: country,
         category: category,
         description: description,
         businessLicenseUrl: businessLicenseUrl,
         governmentIdUrl: governmentIdUrl,
         taxCertificateUrl: taxCertificateUrl,
         moderationNote: moderationNote,
         moderatedAt: moderatedAt,
       );

  /// Returns a shallow copy of this [VendorApplicationDetail]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VendorApplicationDetail copyWith({
    _i1.UuidValue? vendorId,
    _i1.UuidValue? userId,
    _i2.UserAccountStatus? status,
    DateTime? submittedAt,
    String? businessName,
    String? contactName,
    String? contactEmail,
    String? phone,
    Object? taxId = _Undefined,
    String? street,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    String? category,
    String? description,
    Object? businessLicenseUrl = _Undefined,
    Object? governmentIdUrl = _Undefined,
    Object? taxCertificateUrl = _Undefined,
    Object? moderationNote = _Undefined,
    Object? moderatedAt = _Undefined,
  }) {
    return VendorApplicationDetail(
      vendorId: vendorId ?? this.vendorId,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      submittedAt: submittedAt ?? this.submittedAt,
      businessName: businessName ?? this.businessName,
      contactName: contactName ?? this.contactName,
      contactEmail: contactEmail ?? this.contactEmail,
      phone: phone ?? this.phone,
      taxId: taxId is String? ? taxId : this.taxId,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      category: category ?? this.category,
      description: description ?? this.description,
      businessLicenseUrl: businessLicenseUrl is String?
          ? businessLicenseUrl
          : this.businessLicenseUrl,
      governmentIdUrl: governmentIdUrl is String?
          ? governmentIdUrl
          : this.governmentIdUrl,
      taxCertificateUrl: taxCertificateUrl is String?
          ? taxCertificateUrl
          : this.taxCertificateUrl,
      moderationNote: moderationNote is String?
          ? moderationNote
          : this.moderationNote,
      moderatedAt: moderatedAt is DateTime? ? moderatedAt : this.moderatedAt,
    );
  }
}
