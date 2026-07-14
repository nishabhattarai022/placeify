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
import 'user_account_status.dart' as _i2;

/// Vendor onboarding application list item.
abstract class VendorApplicationSummary implements _i1.SerializableModel {
  VendorApplicationSummary._({
    required this.vendorId,
    required this.userId,
    required this.businessName,
    required this.contactEmail,
    required this.submittedAt,
    required this.status,
    this.moderationNote,
    this.moderatedAt,
    this.appealMessage,
    this.appealSubmittedAt,
  });

  factory VendorApplicationSummary({
    required _i1.UuidValue vendorId,
    required _i1.UuidValue userId,
    required String businessName,
    required String contactEmail,
    required DateTime submittedAt,
    required _i2.UserAccountStatus status,
    String? moderationNote,
    DateTime? moderatedAt,
    String? appealMessage,
    DateTime? appealSubmittedAt,
  }) = _VendorApplicationSummaryImpl;

  factory VendorApplicationSummary.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return VendorApplicationSummary(
      vendorId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['vendorId'],
      ),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      businessName: jsonSerialization['businessName'] as String,
      contactEmail: jsonSerialization['contactEmail'] as String,
      submittedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['submittedAt'],
      ),
      status: _i2.UserAccountStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      moderationNote: jsonSerialization['moderationNote'] as String?,
      moderatedAt: jsonSerialization['moderatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['moderatedAt'],
            ),
      appealMessage: jsonSerialization['appealMessage'] as String?,
      appealSubmittedAt: jsonSerialization['appealSubmittedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['appealSubmittedAt'],
            ),
    );
  }

  _i1.UuidValue vendorId;

  _i1.UuidValue userId;

  String businessName;

  String contactEmail;

  DateTime submittedAt;

  _i2.UserAccountStatus status;

  String? moderationNote;

  DateTime? moderatedAt;

  String? appealMessage;

  DateTime? appealSubmittedAt;

  /// Returns a shallow copy of this [VendorApplicationSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VendorApplicationSummary copyWith({
    _i1.UuidValue? vendorId,
    _i1.UuidValue? userId,
    String? businessName,
    String? contactEmail,
    DateTime? submittedAt,
    _i2.UserAccountStatus? status,
    String? moderationNote,
    DateTime? moderatedAt,
    String? appealMessage,
    DateTime? appealSubmittedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VendorApplicationSummary',
      'vendorId': vendorId.toJson(),
      'userId': userId.toJson(),
      'businessName': businessName,
      'contactEmail': contactEmail,
      'submittedAt': submittedAt.toJson(),
      'status': status.toJson(),
      if (moderationNote != null) 'moderationNote': moderationNote,
      if (moderatedAt != null) 'moderatedAt': moderatedAt?.toJson(),
      if (appealMessage != null) 'appealMessage': appealMessage,
      if (appealSubmittedAt != null)
        'appealSubmittedAt': appealSubmittedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VendorApplicationSummaryImpl extends VendorApplicationSummary {
  _VendorApplicationSummaryImpl({
    required _i1.UuidValue vendorId,
    required _i1.UuidValue userId,
    required String businessName,
    required String contactEmail,
    required DateTime submittedAt,
    required _i2.UserAccountStatus status,
    String? moderationNote,
    DateTime? moderatedAt,
    String? appealMessage,
    DateTime? appealSubmittedAt,
  }) : super._(
         vendorId: vendorId,
         userId: userId,
         businessName: businessName,
         contactEmail: contactEmail,
         submittedAt: submittedAt,
         status: status,
         moderationNote: moderationNote,
         moderatedAt: moderatedAt,
         appealMessage: appealMessage,
         appealSubmittedAt: appealSubmittedAt,
       );

  /// Returns a shallow copy of this [VendorApplicationSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VendorApplicationSummary copyWith({
    _i1.UuidValue? vendorId,
    _i1.UuidValue? userId,
    String? businessName,
    String? contactEmail,
    DateTime? submittedAt,
    _i2.UserAccountStatus? status,
    Object? moderationNote = _Undefined,
    Object? moderatedAt = _Undefined,
    Object? appealMessage = _Undefined,
    Object? appealSubmittedAt = _Undefined,
  }) {
    return VendorApplicationSummary(
      vendorId: vendorId ?? this.vendorId,
      userId: userId ?? this.userId,
      businessName: businessName ?? this.businessName,
      contactEmail: contactEmail ?? this.contactEmail,
      submittedAt: submittedAt ?? this.submittedAt,
      status: status ?? this.status,
      moderationNote: moderationNote is String?
          ? moderationNote
          : this.moderationNote,
      moderatedAt: moderatedAt is DateTime? ? moderatedAt : this.moderatedAt,
      appealMessage: appealMessage is String?
          ? appealMessage
          : this.appealMessage,
      appealSubmittedAt: appealSubmittedAt is DateTime?
          ? appealSubmittedAt
          : this.appealSubmittedAt,
    );
  }
}
