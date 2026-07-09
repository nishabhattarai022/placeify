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
import 'complaint_status.dart' as _i2;

/// Complaint row embedded in admin product detail.
abstract class AdminProductComplaintSummary implements _i1.SerializableModel {
  AdminProductComplaintSummary._({
    required this.complaintId,
    required this.reason,
    this.description,
    required this.status,
    required this.createdAt,
  });

  factory AdminProductComplaintSummary({
    required _i1.UuidValue complaintId,
    required String reason,
    String? description,
    required _i2.ComplaintStatus status,
    required DateTime createdAt,
  }) = _AdminProductComplaintSummaryImpl;

  factory AdminProductComplaintSummary.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminProductComplaintSummary(
      complaintId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['complaintId'],
      ),
      reason: jsonSerialization['reason'] as String,
      description: jsonSerialization['description'] as String?,
      status: _i2.ComplaintStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  _i1.UuidValue complaintId;

  String reason;

  String? description;

  _i2.ComplaintStatus status;

  DateTime createdAt;

  /// Returns a shallow copy of this [AdminProductComplaintSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AdminProductComplaintSummary copyWith({
    _i1.UuidValue? complaintId,
    String? reason,
    String? description,
    _i2.ComplaintStatus? status,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminProductComplaintSummary',
      'complaintId': complaintId.toJson(),
      'reason': reason,
      if (description != null) 'description': description,
      'status': status.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminProductComplaintSummaryImpl extends AdminProductComplaintSummary {
  _AdminProductComplaintSummaryImpl({
    required _i1.UuidValue complaintId,
    required String reason,
    String? description,
    required _i2.ComplaintStatus status,
    required DateTime createdAt,
  }) : super._(
         complaintId: complaintId,
         reason: reason,
         description: description,
         status: status,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AdminProductComplaintSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AdminProductComplaintSummary copyWith({
    _i1.UuidValue? complaintId,
    String? reason,
    Object? description = _Undefined,
    _i2.ComplaintStatus? status,
    DateTime? createdAt,
  }) {
    return AdminProductComplaintSummary(
      complaintId: complaintId ?? this.complaintId,
      reason: reason ?? this.reason,
      description: description is String? ? description : this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
