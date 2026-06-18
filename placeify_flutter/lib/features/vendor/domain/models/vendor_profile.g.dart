// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VendorProfile _$VendorProfileFromJson(
  Map<String, dynamic> json,
) => _VendorProfile(
  id: json['id'] as String,
  businessName: json['businessName'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  address: json['address'] as String,
  city: json['city'] as String? ?? '',
  country: json['country'] as String? ?? '',
  logoUrl: json['logoUrl'] as String?,
  bio: json['bio'] as String? ?? '',
  bannerUrl: json['bannerUrl'] as String?,
  coverUrl: json['coverUrl'] as String?,
  isOpen: json['isOpen'] as bool? ?? true,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  schedule:
      (json['schedule'] as List<dynamic>?)
          ?.map((e) => VendorOperatingDay.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  socialLinks: json['socialLinks'] == null
      ? const VendorSocialLinks()
      : VendorSocialLinks.fromJson(json['socialLinks'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$VendorProfileToJson(_VendorProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessName': instance.businessName,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'city': instance.city,
      'country': instance.country,
      'logoUrl': instance.logoUrl,
      'bio': instance.bio,
      'bannerUrl': instance.bannerUrl,
      'coverUrl': instance.coverUrl,
      'isOpen': instance.isOpen,
      'tags': instance.tags,
      'schedule': instance.schedule,
      'socialLinks': instance.socialLinks,
      'createdAt': instance.createdAt.toIso8601String(),
    };
