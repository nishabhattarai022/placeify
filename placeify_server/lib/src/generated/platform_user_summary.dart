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
import 'user_role.dart' as _i2;
import 'user_account_status.dart' as _i3;

/// Platform user row for admin user management.
abstract class PlatformUserSummary
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  PlatformUserSummary._({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    this.vendorId,
    required this.createdAt,
  });

  factory PlatformUserSummary({
    required _i1.UuidValue id,
    required String name,
    required String email,
    required _i2.UserRole role,
    required _i3.UserAccountStatus status,
    _i1.UuidValue? vendorId,
    required DateTime createdAt,
  }) = _PlatformUserSummaryImpl;

  factory PlatformUserSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlatformUserSummary(
      id: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      email: jsonSerialization['email'] as String,
      role: _i2.UserRole.fromJson((jsonSerialization['role'] as String)),
      status: _i3.UserAccountStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      vendorId: jsonSerialization['vendorId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['vendorId']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  _i1.UuidValue id;

  String name;

  String email;

  _i2.UserRole role;

  _i3.UserAccountStatus status;

  _i1.UuidValue? vendorId;

  DateTime createdAt;

  /// Returns a shallow copy of this [PlatformUserSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PlatformUserSummary copyWith({
    _i1.UuidValue? id,
    String? name,
    String? email,
    _i2.UserRole? role,
    _i3.UserAccountStatus? status,
    _i1.UuidValue? vendorId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PlatformUserSummary',
      'id': id.toJson(),
      'name': name,
      'email': email,
      'role': role.toJson(),
      'status': status.toJson(),
      if (vendorId != null) 'vendorId': vendorId?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PlatformUserSummary',
      'id': id.toJson(),
      'name': name,
      'email': email,
      'role': role.toJson(),
      'status': status.toJson(),
      if (vendorId != null) 'vendorId': vendorId?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PlatformUserSummaryImpl extends PlatformUserSummary {
  _PlatformUserSummaryImpl({
    required _i1.UuidValue id,
    required String name,
    required String email,
    required _i2.UserRole role,
    required _i3.UserAccountStatus status,
    _i1.UuidValue? vendorId,
    required DateTime createdAt,
  }) : super._(
         id: id,
         name: name,
         email: email,
         role: role,
         status: status,
         vendorId: vendorId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [PlatformUserSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PlatformUserSummary copyWith({
    _i1.UuidValue? id,
    String? name,
    String? email,
    _i2.UserRole? role,
    _i3.UserAccountStatus? status,
    Object? vendorId = _Undefined,
    DateTime? createdAt,
  }) {
    return PlatformUserSummary(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      status: status ?? this.status,
      vendorId: vendorId is _i1.UuidValue? ? vendorId : this.vendorId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
