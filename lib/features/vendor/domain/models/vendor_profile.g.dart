// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VendorProfile _$VendorProfileFromJson(Map<String, dynamic> json) =>
    _VendorProfile(
      id: json['id'] as String,
      businessName: json['businessName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      category: json['category'] as String,
      logoUrl: json['logoUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$VendorProfileToJson(_VendorProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessName': instance.businessName,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'category': instance.category,
      'logoUrl': instance.logoUrl,
      'createdAt': instance.createdAt.toIso8601String(),
    };
