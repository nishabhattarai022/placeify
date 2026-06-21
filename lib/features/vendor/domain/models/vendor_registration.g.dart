// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_registration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VendorBusinessInfo _$VendorBusinessInfoFromJson(Map<String, dynamic> json) =>
    _VendorBusinessInfo(
      businessName: json['businessName'] as String? ?? '',
      contactName: json['contactName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      taxId: json['taxId'] as String? ?? '',
    );

Map<String, dynamic> _$VendorBusinessInfoToJson(_VendorBusinessInfo instance) =>
    <String, dynamic>{
      'businessName': instance.businessName,
      'contactName': instance.contactName,
      'email': instance.email,
      'phone': instance.phone,
      'taxId': instance.taxId,
    };

_VendorAddress _$VendorAddressFromJson(Map<String, dynamic> json) =>
    _VendorAddress(
      street: json['street'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      postalCode: json['postalCode'] as String? ?? '',
      country: json['country'] as String? ?? '',
    );

Map<String, dynamic> _$VendorAddressToJson(_VendorAddress instance) =>
    <String, dynamic>{
      'street': instance.street,
      'city': instance.city,
      'state': instance.state,
      'postalCode': instance.postalCode,
      'country': instance.country,
    };

_VendorDocuments _$VendorDocumentsFromJson(Map<String, dynamic> json) =>
    _VendorDocuments(
      businessLicensePath: json['businessLicensePath'] as String?,
      governmentIdPath: json['governmentIdPath'] as String?,
      taxCertificatePath: json['taxCertificatePath'] as String?,
    );

Map<String, dynamic> _$VendorDocumentsToJson(_VendorDocuments instance) =>
    <String, dynamic>{
      'businessLicensePath': instance.businessLicensePath,
      'governmentIdPath': instance.governmentIdPath,
      'taxCertificatePath': instance.taxCertificatePath,
    };

_VendorBankDetails _$VendorBankDetailsFromJson(Map<String, dynamic> json) =>
    _VendorBankDetails(
      accountHolderName: json['accountHolderName'] as String? ?? '',
      bankName: json['bankName'] as String? ?? '',
      accountNumber: json['accountNumber'] as String? ?? '',
      routingNumber: json['routingNumber'] as String? ?? '',
    );

Map<String, dynamic> _$VendorBankDetailsToJson(_VendorBankDetails instance) =>
    <String, dynamic>{
      'accountHolderName': instance.accountHolderName,
      'bankName': instance.bankName,
      'accountNumber': instance.accountNumber,
      'routingNumber': instance.routingNumber,
    };

_VendorRegistration _$VendorRegistrationFromJson(Map<String, dynamic> json) =>
    _VendorRegistration(
      business: json['business'] == null
          ? const VendorBusinessInfo()
          : VendorBusinessInfo.fromJson(
              json['business'] as Map<String, dynamic>),
      address: json['address'] == null
          ? const VendorAddress()
          : VendorAddress.fromJson(json['address'] as Map<String, dynamic>),
      category: json['category'] == null
          ? const VendorCategoryInfo()
          : VendorCategoryInfo.fromJson(
              json['category'] as Map<String, dynamic>),
      documents: json['documents'] == null
          ? const VendorDocuments()
          : VendorDocuments.fromJson(json['documents'] as Map<String, dynamic>),
      bank: json['bank'] == null
          ? const VendorBankDetails()
          : VendorBankDetails.fromJson(json['bank'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VendorRegistrationToJson(_VendorRegistration instance) =>
    <String, dynamic>{
      'business': instance.business,
      'address': instance.address,
      'category': instance.category,
      'documents': instance.documents,
      'bank': instance.bank,
    };
