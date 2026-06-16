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

/// Full vendor shop profile returned to the Flutter vendor profile screen.
abstract class VendorProfileDetail
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  VendorProfileDetail._({
    required this.id,
    required this.businessName,
    required this.email,
    required this.phone,
    required this.address,
    required this.category,
    this.logoUrl,
    required this.bio,
    this.bannerUrl,
    required this.instagramHandle,
    required this.facebookHandle,
    required this.operatingHours,
    required this.createdAt,
  });

  factory VendorProfileDetail({
    required _i1.UuidValue id,
    required String businessName,
    required String email,
    required String phone,
    required String address,
    required String category,
    String? logoUrl,
    required String bio,
    String? bannerUrl,
    required String instagramHandle,
    required String facebookHandle,
    required String operatingHours,
    required DateTime createdAt,
  }) = _VendorProfileDetailImpl;

  factory VendorProfileDetail.fromJson(Map<String, dynamic> jsonSerialization) {
    return VendorProfileDetail(
      id: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      businessName: jsonSerialization['businessName'] as String,
      email: jsonSerialization['email'] as String,
      phone: jsonSerialization['phone'] as String,
      address: jsonSerialization['address'] as String,
      category: jsonSerialization['category'] as String,
      logoUrl: jsonSerialization['logoUrl'] as String?,
      bio: jsonSerialization['bio'] as String,
      bannerUrl: jsonSerialization['bannerUrl'] as String?,
      instagramHandle: jsonSerialization['instagramHandle'] as String,
      facebookHandle: jsonSerialization['facebookHandle'] as String,
      operatingHours: jsonSerialization['operatingHours'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  _i1.UuidValue id;

  String businessName;

  String email;

  String phone;

  String address;

  String category;

  String? logoUrl;

  String bio;

  String? bannerUrl;

  String instagramHandle;

  String facebookHandle;

  String operatingHours;

  DateTime createdAt;

  /// Returns a shallow copy of this [VendorProfileDetail]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VendorProfileDetail copyWith({
    _i1.UuidValue? id,
    String? businessName,
    String? email,
    String? phone,
    String? address,
    String? category,
    String? logoUrl,
    String? bio,
    String? bannerUrl,
    String? instagramHandle,
    String? facebookHandle,
    String? operatingHours,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VendorProfileDetail',
      'id': id.toJson(),
      'businessName': businessName,
      'email': email,
      'phone': phone,
      'address': address,
      'category': category,
      if (logoUrl != null) 'logoUrl': logoUrl,
      'bio': bio,
      if (bannerUrl != null) 'bannerUrl': bannerUrl,
      'instagramHandle': instagramHandle,
      'facebookHandle': facebookHandle,
      'operatingHours': operatingHours,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VendorProfileDetail',
      'id': id.toJson(),
      'businessName': businessName,
      'email': email,
      'phone': phone,
      'address': address,
      'category': category,
      if (logoUrl != null) 'logoUrl': logoUrl,
      'bio': bio,
      if (bannerUrl != null) 'bannerUrl': bannerUrl,
      'instagramHandle': instagramHandle,
      'facebookHandle': facebookHandle,
      'operatingHours': operatingHours,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VendorProfileDetailImpl extends VendorProfileDetail {
  _VendorProfileDetailImpl({
    required _i1.UuidValue id,
    required String businessName,
    required String email,
    required String phone,
    required String address,
    required String category,
    String? logoUrl,
    required String bio,
    String? bannerUrl,
    required String instagramHandle,
    required String facebookHandle,
    required String operatingHours,
    required DateTime createdAt,
  }) : super._(
         id: id,
         businessName: businessName,
         email: email,
         phone: phone,
         address: address,
         category: category,
         logoUrl: logoUrl,
         bio: bio,
         bannerUrl: bannerUrl,
         instagramHandle: instagramHandle,
         facebookHandle: facebookHandle,
         operatingHours: operatingHours,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [VendorProfileDetail]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VendorProfileDetail copyWith({
    _i1.UuidValue? id,
    String? businessName,
    String? email,
    String? phone,
    String? address,
    String? category,
    Object? logoUrl = _Undefined,
    String? bio,
    Object? bannerUrl = _Undefined,
    String? instagramHandle,
    String? facebookHandle,
    String? operatingHours,
    DateTime? createdAt,
  }) {
    return VendorProfileDetail(
      id: id ?? this.id,
      businessName: businessName ?? this.businessName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      category: category ?? this.category,
      logoUrl: logoUrl is String? ? logoUrl : this.logoUrl,
      bio: bio ?? this.bio,
      bannerUrl: bannerUrl is String? ? bannerUrl : this.bannerUrl,
      instagramHandle: instagramHandle ?? this.instagramHandle,
      facebookHandle: facebookHandle ?? this.facebookHandle,
      operatingHours: operatingHours ?? this.operatingHours,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
