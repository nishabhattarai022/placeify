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
import 'user_account_status.dart' as _i2;

/// Result of admin vendor suspend or reinstate actions.
abstract class VendorModerationResult
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  VendorModerationResult._({
    required this.vendorUserId,
    required this.vendorId,
    required this.status,
    required this.message,
    this.moderationNote,
    this.moderatedAt,
  });

  factory VendorModerationResult({
    required _i1.UuidValue vendorUserId,
    required _i1.UuidValue vendorId,
    required _i2.UserAccountStatus status,
    required String message,
    String? moderationNote,
    DateTime? moderatedAt,
  }) = _VendorModerationResultImpl;

  factory VendorModerationResult.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return VendorModerationResult(
      vendorUserId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['vendorUserId'],
      ),
      vendorId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['vendorId'],
      ),
      status: _i2.UserAccountStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      message: jsonSerialization['message'] as String,
      moderationNote: jsonSerialization['moderationNote'] as String?,
      moderatedAt: jsonSerialization['moderatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['moderatedAt'],
            ),
    );
  }

  _i1.UuidValue vendorUserId;

  _i1.UuidValue vendorId;

  _i2.UserAccountStatus status;

  String message;

  String? moderationNote;

  DateTime? moderatedAt;

  /// Returns a shallow copy of this [VendorModerationResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VendorModerationResult copyWith({
    _i1.UuidValue? vendorUserId,
    _i1.UuidValue? vendorId,
    _i2.UserAccountStatus? status,
    String? message,
    String? moderationNote,
    DateTime? moderatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VendorModerationResult',
      'vendorUserId': vendorUserId.toJson(),
      'vendorId': vendorId.toJson(),
      'status': status.toJson(),
      'message': message,
      if (moderationNote != null) 'moderationNote': moderationNote,
      if (moderatedAt != null) 'moderatedAt': moderatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VendorModerationResult',
      'vendorUserId': vendorUserId.toJson(),
      'vendorId': vendorId.toJson(),
      'status': status.toJson(),
      'message': message,
      if (moderationNote != null) 'moderationNote': moderationNote,
      if (moderatedAt != null) 'moderatedAt': moderatedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VendorModerationResultImpl extends VendorModerationResult {
  _VendorModerationResultImpl({
    required _i1.UuidValue vendorUserId,
    required _i1.UuidValue vendorId,
    required _i2.UserAccountStatus status,
    required String message,
    String? moderationNote,
    DateTime? moderatedAt,
  }) : super._(
         vendorUserId: vendorUserId,
         vendorId: vendorId,
         status: status,
         message: message,
         moderationNote: moderationNote,
         moderatedAt: moderatedAt,
       );

  /// Returns a shallow copy of this [VendorModerationResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VendorModerationResult copyWith({
    _i1.UuidValue? vendorUserId,
    _i1.UuidValue? vendorId,
    _i2.UserAccountStatus? status,
    String? message,
    Object? moderationNote = _Undefined,
    Object? moderatedAt = _Undefined,
  }) {
    return VendorModerationResult(
      vendorUserId: vendorUserId ?? this.vendorUserId,
      vendorId: vendorId ?? this.vendorId,
      status: status ?? this.status,
      message: message ?? this.message,
      moderationNote: moderationNote is String?
          ? moderationNote
          : this.moderationNote,
      moderatedAt: moderatedAt is DateTime? ? moderatedAt : this.moderatedAt,
    );
  }
}
