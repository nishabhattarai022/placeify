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
import 'admin_type.dart' as _i2;
import 'user.dart' as _i3;
import 'package:placeify_client/src/protocol/protocol.dart' as _i4;

/// Platform administrator profile linked 1:1 to a User account.
/// Audit actions (approve, remove, resolve) reference this table's id, not user.id.
abstract class Admin implements _i1.SerializableModel {
  Admin._({
    this.id,
    required this.userId,
    this.user,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    _i2.AdminType? adminType,
    bool? isActive,
    bool? newApplicationAlerts,
    bool? systemAlerts,
    this.lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : adminType = adminType ?? _i2.AdminType.moderator,
       isActive = isActive ?? true,
       newApplicationAlerts = newApplicationAlerts ?? true,
       systemAlerts = systemAlerts ?? true,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Admin({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    _i3.User? user,
    required String fullName,
    required String email,
    String? phoneNumber,
    _i2.AdminType? adminType,
    bool? isActive,
    bool? newApplicationAlerts,
    bool? systemAlerts,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AdminImpl;

  factory Admin.fromJson(Map<String, dynamic> jsonSerialization) {
    return Admin(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      user: jsonSerialization['user'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.User>(jsonSerialization['user']),
      fullName: jsonSerialization['fullName'] as String,
      email: jsonSerialization['email'] as String,
      phoneNumber: jsonSerialization['phoneNumber'] as String?,
      adminType: jsonSerialization['adminType'] == null
          ? null
          : _i2.AdminType.fromJson((jsonSerialization['adminType'] as String)),
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      newApplicationAlerts: jsonSerialization['newApplicationAlerts'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['newApplicationAlerts'],
            ),
      systemAlerts: jsonSerialization['systemAlerts'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['systemAlerts']),
      lastLoginAt: jsonSerialization['lastLoginAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastLoginAt'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue? id;

  _i1.UuidValue userId;

  _i3.User? user;

  String fullName;

  String email;

  String? phoneNumber;

  _i2.AdminType adminType;

  bool isActive;

  bool newApplicationAlerts;

  bool systemAlerts;

  DateTime? lastLoginAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Admin]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Admin copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    _i3.User? user,
    String? fullName,
    String? email,
    String? phoneNumber,
    _i2.AdminType? adminType,
    bool? isActive,
    bool? newApplicationAlerts,
    bool? systemAlerts,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Admin',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      if (user != null) 'user': user?.toJson(),
      'fullName': fullName,
      'email': email,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      'adminType': adminType.toJson(),
      'isActive': isActive,
      'newApplicationAlerts': newApplicationAlerts,
      'systemAlerts': systemAlerts,
      if (lastLoginAt != null) 'lastLoginAt': lastLoginAt?.toJson(),
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

class _AdminImpl extends Admin {
  _AdminImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    _i3.User? user,
    required String fullName,
    required String email,
    String? phoneNumber,
    _i2.AdminType? adminType,
    bool? isActive,
    bool? newApplicationAlerts,
    bool? systemAlerts,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         user: user,
         fullName: fullName,
         email: email,
         phoneNumber: phoneNumber,
         adminType: adminType,
         isActive: isActive,
         newApplicationAlerts: newApplicationAlerts,
         systemAlerts: systemAlerts,
         lastLoginAt: lastLoginAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Admin]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Admin copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    Object? user = _Undefined,
    String? fullName,
    String? email,
    Object? phoneNumber = _Undefined,
    _i2.AdminType? adminType,
    bool? isActive,
    bool? newApplicationAlerts,
    bool? systemAlerts,
    Object? lastLoginAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Admin(
      id: id is _i1.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _i3.User? ? user : this.user?.copyWith(),
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber is String? ? phoneNumber : this.phoneNumber,
      adminType: adminType ?? this.adminType,
      isActive: isActive ?? this.isActive,
      newApplicationAlerts: newApplicationAlerts ?? this.newApplicationAlerts,
      systemAlerts: systemAlerts ?? this.systemAlerts,
      lastLoginAt: lastLoginAt is DateTime? ? lastLoginAt : this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
