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
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i3;
import 'package:placeify_client/src/protocol/protocol.dart' as _i4;

/// Application user account.
abstract class User implements _i1.SerializableModel {
  User._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.name,
    this.phone,
    this.address,
    _i2.UserRole? role,
    DateTime? createdAt,
  }) : role = role ?? _i2.UserRole.consumer,
       createdAt = createdAt ?? DateTime.now();

  factory User({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i3.AuthUser? authUser,
    required String name,
    String? phone,
    String? address,
    _i2.UserRole? role,
    DateTime? createdAt,
  }) = _UserImpl;

  factory User.fromJson(Map<String, dynamic> jsonSerialization) {
    return User(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.AuthUser>(
              jsonSerialization['authUser'],
            ),
      name: jsonSerialization['name'] as String,
      phone: jsonSerialization['phone'] as String?,
      address: jsonSerialization['address'] as String?,
      role: jsonSerialization['role'] == null
          ? null
          : _i2.UserRole.fromJson((jsonSerialization['role'] as String)),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue? id;

  _i1.UuidValue authUserId;

  _i3.AuthUser? authUser;

  String name;

  String? phone;

  String? address;

  _i2.UserRole role;

  DateTime createdAt;

  /// Returns a shallow copy of this [User]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  User copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authUserId,
    _i3.AuthUser? authUser,
    String? name,
    String? phone,
    String? address,
    _i2.UserRole? role,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'User',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'name': name,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      'role': role.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserImpl extends User {
  _UserImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i3.AuthUser? authUser,
    required String name,
    String? phone,
    String? address,
    _i2.UserRole? role,
    DateTime? createdAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         name: name,
         phone: phone,
         address: address,
         role: role,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [User]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  User copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    String? name,
    Object? phone = _Undefined,
    Object? address = _Undefined,
    _i2.UserRole? role,
    DateTime? createdAt,
  }) {
    return User(
      id: id is _i1.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _i3.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      name: name ?? this.name,
      phone: phone is String? ? phone : this.phone,
      address: address is String? ? address : this.address,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
