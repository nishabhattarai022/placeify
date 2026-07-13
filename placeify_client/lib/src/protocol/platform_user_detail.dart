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
import 'user_role.dart' as _i2;
import 'user_account_status.dart' as _i3;

/// Full platform user record for admin user detail views.
abstract class PlatformUserDetail implements _i1.SerializableModel {
  PlatformUserDetail._({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.isActive,
    this.phone,
    this.address,
    this.vendorId,
    this.vendorShopName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PlatformUserDetail({
    required _i1.UuidValue id,
    required String name,
    required String email,
    required _i2.UserRole role,
    required _i3.UserAccountStatus status,
    required bool isActive,
    String? phone,
    String? address,
    _i1.UuidValue? vendorId,
    String? vendorShopName,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PlatformUserDetailImpl;

  factory PlatformUserDetail.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlatformUserDetail(
      id: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      email: jsonSerialization['email'] as String,
      role: _i2.UserRole.fromJson((jsonSerialization['role'] as String)),
      status: _i3.UserAccountStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      phone: jsonSerialization['phone'] as String?,
      address: jsonSerialization['address'] as String?,
      vendorId: jsonSerialization['vendorId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['vendorId']),
      vendorShopName: jsonSerialization['vendorShopName'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  _i1.UuidValue id;

  String name;

  String email;

  _i2.UserRole role;

  _i3.UserAccountStatus status;

  bool isActive;

  String? phone;

  String? address;

  _i1.UuidValue? vendorId;

  String? vendorShopName;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [PlatformUserDetail]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PlatformUserDetail copyWith({
    _i1.UuidValue? id,
    String? name,
    String? email,
    _i2.UserRole? role,
    _i3.UserAccountStatus? status,
    bool? isActive,
    String? phone,
    String? address,
    _i1.UuidValue? vendorId,
    String? vendorShopName,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PlatformUserDetail',
      'id': id.toJson(),
      'name': name,
      'email': email,
      'role': role.toJson(),
      'status': status.toJson(),
      'isActive': isActive,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (vendorId != null) 'vendorId': vendorId?.toJson(),
      if (vendorShopName != null) 'vendorShopName': vendorShopName,
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

class _PlatformUserDetailImpl extends PlatformUserDetail {
  _PlatformUserDetailImpl({
    required _i1.UuidValue id,
    required String name,
    required String email,
    required _i2.UserRole role,
    required _i3.UserAccountStatus status,
    required bool isActive,
    String? phone,
    String? address,
    _i1.UuidValue? vendorId,
    String? vendorShopName,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         name: name,
         email: email,
         role: role,
         status: status,
         isActive: isActive,
         phone: phone,
         address: address,
         vendorId: vendorId,
         vendorShopName: vendorShopName,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [PlatformUserDetail]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PlatformUserDetail copyWith({
    _i1.UuidValue? id,
    String? name,
    String? email,
    _i2.UserRole? role,
    _i3.UserAccountStatus? status,
    bool? isActive,
    Object? phone = _Undefined,
    Object? address = _Undefined,
    Object? vendorId = _Undefined,
    Object? vendorShopName = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PlatformUserDetail(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
      phone: phone is String? ? phone : this.phone,
      address: address is String? ? address : this.address,
      vendorId: vendorId is _i1.UuidValue? ? vendorId : this.vendorId,
      vendorShopName: vendorShopName is String?
          ? vendorShopName
          : this.vendorShopName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
