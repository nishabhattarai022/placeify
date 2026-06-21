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

/// Partial update payload for the logged-in vendor shop profile.
abstract class VendorProfileUpdateInput implements _i1.SerializableModel {
  VendorProfileUpdateInput._({
    this.businessName,
    this.email,
    this.phone,
    this.address,
    this.city,
    this.country,
    this.category,
    this.bio,
    this.logoUrl,
    this.bannerUrl,
    this.coverUrl,
    this.instagramHandle,
    this.facebookHandle,
    this.operatingHours,
    this.isOpen,
  });

  factory VendorProfileUpdateInput({
    String? businessName,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? country,
    String? category,
    String? bio,
    String? logoUrl,
    String? bannerUrl,
    String? coverUrl,
    String? instagramHandle,
    String? facebookHandle,
    String? operatingHours,
    bool? isOpen,
  }) = _VendorProfileUpdateInputImpl;

  factory VendorProfileUpdateInput.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return VendorProfileUpdateInput(
      businessName: jsonSerialization['businessName'] as String?,
      email: jsonSerialization['email'] as String?,
      phone: jsonSerialization['phone'] as String?,
      address: jsonSerialization['address'] as String?,
      city: jsonSerialization['city'] as String?,
      country: jsonSerialization['country'] as String?,
      category: jsonSerialization['category'] as String?,
      bio: jsonSerialization['bio'] as String?,
      logoUrl: jsonSerialization['logoUrl'] as String?,
      bannerUrl: jsonSerialization['bannerUrl'] as String?,
      coverUrl: jsonSerialization['coverUrl'] as String?,
      instagramHandle: jsonSerialization['instagramHandle'] as String?,
      facebookHandle: jsonSerialization['facebookHandle'] as String?,
      operatingHours: jsonSerialization['operatingHours'] as String?,
      isOpen: jsonSerialization['isOpen'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isOpen']),
    );
  }

  String? businessName;

  String? email;

  String? phone;

  String? address;

  String? city;

  String? country;

  String? category;

  String? bio;

  String? logoUrl;

  String? bannerUrl;

  String? coverUrl;

  String? instagramHandle;

  String? facebookHandle;

  String? operatingHours;

  bool? isOpen;

  /// Returns a shallow copy of this [VendorProfileUpdateInput]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VendorProfileUpdateInput copyWith({
    String? businessName,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? country,
    String? category,
    String? bio,
    String? logoUrl,
    String? bannerUrl,
    String? coverUrl,
    String? instagramHandle,
    String? facebookHandle,
    String? operatingHours,
    bool? isOpen,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VendorProfileUpdateInput',
      if (businessName != null) 'businessName': businessName,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (country != null) 'country': country,
      if (category != null) 'category': category,
      if (bio != null) 'bio': bio,
      if (logoUrl != null) 'logoUrl': logoUrl,
      if (bannerUrl != null) 'bannerUrl': bannerUrl,
      if (coverUrl != null) 'coverUrl': coverUrl,
      if (instagramHandle != null) 'instagramHandle': instagramHandle,
      if (facebookHandle != null) 'facebookHandle': facebookHandle,
      if (operatingHours != null) 'operatingHours': operatingHours,
      if (isOpen != null) 'isOpen': isOpen,
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
    String? email,
    String? phone,
    String? address,
    String? city,
    String? country,
    String? category,
    String? bio,
    String? logoUrl,
    String? bannerUrl,
    String? coverUrl,
    String? instagramHandle,
    String? facebookHandle,
    String? operatingHours,
    bool? isOpen,
  }) : super._(
         businessName: businessName,
         email: email,
         phone: phone,
         address: address,
         city: city,
         country: country,
         category: category,
         bio: bio,
         logoUrl: logoUrl,
         bannerUrl: bannerUrl,
         coverUrl: coverUrl,
         instagramHandle: instagramHandle,
         facebookHandle: facebookHandle,
         operatingHours: operatingHours,
         isOpen: isOpen,
       );

  /// Returns a shallow copy of this [VendorProfileUpdateInput]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VendorProfileUpdateInput copyWith({
    Object? businessName = _Undefined,
    Object? email = _Undefined,
    Object? phone = _Undefined,
    Object? address = _Undefined,
    Object? city = _Undefined,
    Object? country = _Undefined,
    Object? category = _Undefined,
    Object? bio = _Undefined,
    Object? logoUrl = _Undefined,
    Object? bannerUrl = _Undefined,
    Object? coverUrl = _Undefined,
    Object? instagramHandle = _Undefined,
    Object? facebookHandle = _Undefined,
    Object? operatingHours = _Undefined,
    Object? isOpen = _Undefined,
  }) {
    return VendorProfileUpdateInput(
      businessName: businessName is String? ? businessName : this.businessName,
      email: email is String? ? email : this.email,
      phone: phone is String? ? phone : this.phone,
      address: address is String? ? address : this.address,
      city: city is String? ? city : this.city,
      country: country is String? ? country : this.country,
      category: category is String? ? category : this.category,
      bio: bio is String? ? bio : this.bio,
      logoUrl: logoUrl is String? ? logoUrl : this.logoUrl,
      bannerUrl: bannerUrl is String? ? bannerUrl : this.bannerUrl,
      coverUrl: coverUrl is String? ? coverUrl : this.coverUrl,
      instagramHandle: instagramHandle is String?
          ? instagramHandle
          : this.instagramHandle,
      facebookHandle: facebookHandle is String?
          ? facebookHandle
          : this.facebookHandle,
      operatingHours: operatingHours is String?
          ? operatingHours
          : this.operatingHours,
      isOpen: isOpen is bool? ? isOpen : this.isOpen,
    );
  }
}
