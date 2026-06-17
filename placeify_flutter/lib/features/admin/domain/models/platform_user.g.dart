// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlatformUser _$PlatformUserFromJson(Map<String, dynamic> json) =>
    _PlatformUser(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      vendorStatus: $enumDecode(_$VendorStatusEnumMap, json['vendorStatus']),
      vendorId: json['vendorId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PlatformUserToJson(_PlatformUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'role': _$UserRoleEnumMap[instance.role]!,
      'vendorStatus': _$VendorStatusEnumMap[instance.vendorStatus]!,
      'vendorId': instance.vendorId,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$UserRoleEnumMap = {
  UserRole.customer: 'customer',
  UserRole.vendor: 'vendor',
  UserRole.admin: 'admin',
};

const _$VendorStatusEnumMap = {
  VendorStatus.none: 'none',
  VendorStatus.pending: 'pending',
  VendorStatus.approved: 'approved',
  VendorStatus.suspended: 'suspended',
};
