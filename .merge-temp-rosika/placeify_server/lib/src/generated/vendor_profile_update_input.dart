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

/// Partial update payload for the logged-in vendor shop profile.
abstract class VendorProfileUpdateInput
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  VendorProfileUpdateInput._({
    this.businessName,
    this.phone,
    this.address,
    this.category,
    this.bio,
    this.logoUrl,
    this.bannerUrl,
    this.instagramHandle,
    this.facebookHandle,
    this.operatingHours,
  });

  factory VendorProfileUpdateInput({
    String? businessName,
    String? phone,
    String? address,
    String? category,
    String? bio,
    String? logoUrl,
    String? bannerUrl,
    String? instagramHandle,
    String? facebookHandle,
    String? operatingHours,
  }) = _VendorProfileUpdateInputImpl;

  factory VendorProfileUpdateInput.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return VendorProfileUpdateInput(
      businessName: jsonSerialization['businessName'] as String?,
      phone: jsonSerialization['phone'] as String?,
      address: jsonSerialization['address'] as String?,
      category: jsonSerialization['category'] as String?,
      bio: jsonSerialization['bio'] as String?,
      logoUrl: jsonSerialization['logoUrl'] as String?,
      bannerUrl: jsonSerialization['bannerUrl'] as String?,
      instagramHandle: jsonSerialization['instagramHandle'] as String?,
      facebookHandle: jsonSerialization['facebookHandle'] as String?,
      operatingHours: jsonSerialization['operatingHours'] as String?,
    );
  }

  String? businessName;

  String? phone;

  String? address;

  String? category;

  String? bio;

  String? logoUrl;

  String? bannerUrl;

  String? instagramHandle;

  String? facebookHandle;

  String? operatingHours;

  /// Returns a shallow copy of this [VendorProfileUpdateInput]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VendorProfileUpdateInput copyWith({
    String? businessName,
    String? phone,
    String? address,
    String? category,
    String? bio,
    String? logoUrl,
    String? bannerUrl,
    String? instagramHandle,
    String? facebookHandle,
    String? operatingHours,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VendorProfileUpdateInput',
      if (businessName != null) 'businessName': businessName,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (category != null) 'category': category,
      if (bio != null) 'bio': bio,
      if (logoUrl != null) 'logoUrl': logoUrl,
      if (bannerUrl != null) 'bannerUrl': bannerUrl,
      if (instagramHandle != null) 'instagramHandle': instagramHandle,
      if (facebookHandle != null) 'facebookHandle': facebookHandle,
      if (operatingHours != null) 'operatingHours': operatingHours,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VendorProfileUpdateInput',
      if (businessName != null) 'businessName': businessName,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (category != null) 'category': category,
      if (bio != null) 'bio': bio,
      if (logoUrl != null) 'logoUrl': logoUrl,
      if (bannerUrl != null) 'bannerUrl': bannerUrl,
      if (instagramHandle != null) 'instagramHandle': instagramHandle,
      if (facebookHandle != null) 'facebookHandle': facebookHandle,
      if (operatingHours != null) 'operatingHours': operatingHours,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VendorProfileUpdateInputImpl extends VendorProfileUpdateInput {
  _VendorProfileUpdateInputImpl({
    String? businessName,
    String? phone,
    String? address,
    String? category,
    String? bio,
    String? logoUrl,
    String? bannerUrl,
    String? instagramHandle,
    String? facebookHandle,
    String? operatingHours,
  }) : super._(
         businessName: businessName,
         phone: phone,
         address: address,
         category: category,
         bio: bio,
         logoUrl: logoUrl,
         bannerUrl: bannerUrl,
         instagramHandle: instagramHandle,
         facebookHandle: facebookHandle,
         operatingHours: operatingHours,
       );

  /// Returns a shallow copy of this [VendorProfileUpdateInput]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VendorProfileUpdateInput copyWith({
    Object? businessName = _Undefined,
    Object? phone = _Undefined,
    Object? address = _Undefined,
    Object? category = _Undefined,
    Object? bio = _Undefined,
    Object? logoUrl = _Undefined,
    Object? bannerUrl = _Undefined,
    Object? instagramHandle = _Undefined,
    Object? facebookHandle = _Undefined,
    Object? operatingHours = _Undefined,
  }) {
    return VendorProfileUpdateInput(
      businessName: businessName is String? ? businessName : this.businessName,
      phone: phone is String? ? phone : this.phone,
      address: address is String? ? address : this.address,
      category: category is String? ? category : this.category,
      bio: bio is String? ? bio : this.bio,
      logoUrl: logoUrl is String? ? logoUrl : this.logoUrl,
      bannerUrl: bannerUrl is String? ? bannerUrl : this.bannerUrl,
      instagramHandle: instagramHandle is String?
          ? instagramHandle
          : this.instagramHandle,
      facebookHandle: facebookHandle is String?
          ? facebookHandle
          : this.facebookHandle,
      operatingHours: operatingHours is String?
          ? operatingHours
          : this.operatingHours,
    );
  }
}
