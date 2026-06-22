// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      role: $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ??
          UserRole.customer,
      vendorStatus:
          $enumDecodeNullable(_$VendorStatusEnumMap, json['vendorStatus']) ??
              VendorStatus.none,
      vendorId: json['vendorId'] as String?,
    );

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'email': instance.email,
      'role': _$UserRoleEnumMap[instance.role]!,
      'vendorStatus': _$VendorStatusEnumMap[instance.vendorStatus]!,
      'vendorId': instance.vendorId,
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
