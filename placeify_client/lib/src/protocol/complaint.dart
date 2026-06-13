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
import 'product.dart' as _i3;
import 'user.dart' as _i4;
import 'admin.dart' as _i5;
import 'package:placeify_client/src/protocol/protocol.dart' as _i6;

/// Product complaint/damage report. Admins resolve these and may remove flagged products.
abstract class Complaint implements _i1.SerializableModel {
  Complaint._({
    this.id,
    required this.productId,
    this.product,
    required this.reportedById,
    this.reportedBy,
    required this.reason,
    required this.description,
    _i2.ComplaintStatus? status,
    this.resolvedById,
    this.resolvedBy,
    this.resolvedAt,
    DateTime? createdAt,
  }) : status = status ?? _i2.ComplaintStatus.pending,
       createdAt = createdAt ?? DateTime.now();

  factory Complaint({
    int? id,
    required int productId,
    _i3.Product? product,
    required _i1.UuidValue reportedById,
    _i4.User? reportedBy,
    required String reason,
    required String description,
    _i2.ComplaintStatus? status,
    _i1.UuidValue? resolvedById,
    _i5.Admin? resolvedBy,
    DateTime? resolvedAt,
    DateTime? createdAt,
  }) = _ComplaintImpl;

  factory Complaint.fromJson(Map<String, dynamic> jsonSerialization) {
    return Complaint(
      id: jsonSerialization['id'] as int?,
      productId: jsonSerialization['productId'] as int,
      product: jsonSerialization['product'] == null
          ? null
          : _i6.Protocol().deserialize<_i3.Product>(
              jsonSerialization['product'],
            ),
      reportedById: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['reportedById'],
      ),
      reportedBy: jsonSerialization['reportedBy'] == null
          ? null
          : _i6.Protocol().deserialize<_i4.User>(
              jsonSerialization['reportedBy'],
            ),
      reason: jsonSerialization['reason'] as String,
      description: jsonSerialization['description'] as String,
      status: jsonSerialization['status'] == null
          ? null
          : _i2.ComplaintStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      resolvedById: jsonSerialization['resolvedById'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['resolvedById'],
            ),
      resolvedBy: jsonSerialization['resolvedBy'] == null
          ? null
          : _i6.Protocol().deserialize<_i5.Admin>(
              jsonSerialization['resolvedBy'],
            ),
      resolvedAt: jsonSerialization['resolvedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['resolvedAt']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int productId;

  _i3.Product? product;

  _i1.UuidValue reportedById;

  _i4.User? reportedBy;

  String reason;

  String description;

  _i2.ComplaintStatus status;

  _i1.UuidValue? resolvedById;

  /// Admin who marked this complaint resolved.
  _i5.Admin? resolvedBy;

  DateTime? resolvedAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [Complaint]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Complaint copyWith({
    int? id,
    int? productId,
    _i3.Product? product,
    _i1.UuidValue? reportedById,
    _i4.User? reportedBy,
    String? reason,
    String? description,
    _i2.ComplaintStatus? status,
    _i1.UuidValue? resolvedById,
    _i5.Admin? resolvedBy,
    DateTime? resolvedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Complaint',
      if (id != null) 'id': id,
      'productId': productId,
      if (product != null) 'product': product?.toJson(),
      'reportedById': reportedById.toJson(),
      if (reportedBy != null) 'reportedBy': reportedBy?.toJson(),
      'reason': reason,
      'description': description,
      'status': status.toJson(),
      if (resolvedById != null) 'resolvedById': resolvedById?.toJson(),
      if (resolvedBy != null) 'resolvedBy': resolvedBy?.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ComplaintImpl extends Complaint {
  _ComplaintImpl({
    int? id,
    required int productId,
    _i3.Product? product,
    required _i1.UuidValue reportedById,
    _i4.User? reportedBy,
    required String reason,
    required String description,
    _i2.ComplaintStatus? status,
    _i1.UuidValue? resolvedById,
    _i5.Admin? resolvedBy,
    DateTime? resolvedAt,
    DateTime? createdAt,
  }) : super._(
         id: id,
         productId: productId,
         product: product,
         reportedById: reportedById,
         reportedBy: reportedBy,
         reason: reason,
         description: description,
         status: status,
         resolvedById: resolvedById,
         resolvedBy: resolvedBy,
         resolvedAt: resolvedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Complaint]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Complaint copyWith({
    Object? id = _Undefined,
    int? productId,
    Object? product = _Undefined,
    _i1.UuidValue? reportedById,
    Object? reportedBy = _Undefined,
    String? reason,
    String? description,
    _i2.ComplaintStatus? status,
    Object? resolvedById = _Undefined,
    Object? resolvedBy = _Undefined,
    Object? resolvedAt = _Undefined,
    DateTime? createdAt,
  }) {
    return Complaint(
      id: id is int? ? id : this.id,
      productId: productId ?? this.productId,
      product: product is _i3.Product? ? product : this.product?.copyWith(),
      reportedById: reportedById ?? this.reportedById,
      reportedBy: reportedBy is _i4.User?
          ? reportedBy
          : this.reportedBy?.copyWith(),
      reason: reason ?? this.reason,
      description: description ?? this.description,
      status: status ?? this.status,
      resolvedById: resolvedById is _i1.UuidValue?
          ? resolvedById
          : this.resolvedById,
      resolvedBy: resolvedBy is _i5.Admin?
          ? resolvedBy
          : this.resolvedBy?.copyWith(),
      resolvedAt: resolvedAt is DateTime? ? resolvedAt : this.resolvedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
