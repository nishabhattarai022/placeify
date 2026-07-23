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

/// Pending email-IDP registration completed via magic link.
/// Stores only a hashed link token (never the raw token). The short-lived
/// IDP verification code is required to call verifyRegistrationCode.
abstract class EmailVerificationPending implements _i1.SerializableModel {
  EmailVerificationPending._({
    this.id,
    required this.email,
    required this.accountRequestId,
    required this.verificationCode,
    required this.tokenHash,
    required this.expiresAt,
    bool? used,
    DateTime? createdAt,
  }) : used = used ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory EmailVerificationPending({
    _i1.UuidValue? id,
    required String email,
    required _i1.UuidValue accountRequestId,
    required String verificationCode,
    required String tokenHash,
    required DateTime expiresAt,
    bool? used,
    DateTime? createdAt,
  }) = _EmailVerificationPendingImpl;

  factory EmailVerificationPending.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return EmailVerificationPending(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      email: jsonSerialization['email'] as String,
      accountRequestId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['accountRequestId'],
      ),
      verificationCode: jsonSerialization['verificationCode'] as String,
      tokenHash: jsonSerialization['tokenHash'] as String,
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      used: jsonSerialization['used'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['used']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue? id;

  String email;

  _i1.UuidValue accountRequestId;

  /// Short-lived Email IDP OTP captured when the magic link is issued.
  String verificationCode;

  String tokenHash;

  DateTime expiresAt;

  bool used;

  DateTime createdAt;

  /// Returns a shallow copy of this [EmailVerificationPending]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailVerificationPending copyWith({
    _i1.UuidValue? id,
    String? email,
    _i1.UuidValue? accountRequestId,
    String? verificationCode,
    String? tokenHash,
    DateTime? expiresAt,
    bool? used,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EmailVerificationPending',
      if (id != null) 'id': id?.toJson(),
      'email': email,
      'accountRequestId': accountRequestId.toJson(),
      'verificationCode': verificationCode,
      'tokenHash': tokenHash,
      'expiresAt': expiresAt.toJson(),
      'used': used,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailVerificationPendingImpl extends EmailVerificationPending {
  _EmailVerificationPendingImpl({
    _i1.UuidValue? id,
    required String email,
    required _i1.UuidValue accountRequestId,
    required String verificationCode,
    required String tokenHash,
    required DateTime expiresAt,
    bool? used,
    DateTime? createdAt,
  }) : super._(
         id: id,
         email: email,
         accountRequestId: accountRequestId,
         verificationCode: verificationCode,
         tokenHash: tokenHash,
         expiresAt: expiresAt,
         used: used,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [EmailVerificationPending]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailVerificationPending copyWith({
    Object? id = _Undefined,
    String? email,
    _i1.UuidValue? accountRequestId,
    String? verificationCode,
    String? tokenHash,
    DateTime? expiresAt,
    bool? used,
    DateTime? createdAt,
  }) {
    return EmailVerificationPending(
      id: id is _i1.UuidValue? ? id : this.id,
      email: email ?? this.email,
      accountRequestId: accountRequestId ?? this.accountRequestId,
      verificationCode: verificationCode ?? this.verificationCode,
      tokenHash: tokenHash ?? this.tokenHash,
      expiresAt: expiresAt ?? this.expiresAt,
      used: used ?? this.used,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
