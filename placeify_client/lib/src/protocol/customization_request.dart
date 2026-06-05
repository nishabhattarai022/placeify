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
import 'request_status.dart' as _i2;
import 'user.dart' as _i3;
import 'vendor.dart' as _i4;
import 'product.dart' as _i5;
import 'package:placeify_client/src/protocol/protocol.dart' as _i6;

/// Customization request or design idea shared by a user with a vendor.
abstract class CustomizationRequest implements _i1.SerializableModel {
  CustomizationRequest._({
    this.id,
    required this.userId,
    this.user,
    required this.vendorId,
    this.vendor,
    required this.productId,
    this.product,
    required this.description,
    this.attachmentUrl,
    _i2.RequestStatus? status,
    DateTime? createdAt,
  }) : status = status ?? _i2.RequestStatus.pending,
       createdAt = createdAt ?? DateTime.now();

  factory CustomizationRequest({
    int? id,
    required _i1.UuidValue userId,
    _i3.User? user,
    required _i1.UuidValue vendorId,
    _i4.Vendor? vendor,
    required int productId,
    _i5.Product? product,
    required String description,
    String? attachmentUrl,
    _i2.RequestStatus? status,
    DateTime? createdAt,
  }) = _CustomizationRequestImpl;

  factory CustomizationRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CustomizationRequest(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      user: jsonSerialization['user'] == null
          ? null
          : _i6.Protocol().deserialize<_i3.User>(jsonSerialization['user']),
      vendorId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['vendorId'],
      ),
      vendor: jsonSerialization['vendor'] == null
          ? null
          : _i6.Protocol().deserialize<_i4.Vendor>(jsonSerialization['vendor']),
      productId: jsonSerialization['productId'] as int,
      product: jsonSerialization['product'] == null
          ? null
          : _i6.Protocol().deserialize<_i5.Product>(
              jsonSerialization['product'],
            ),
      description: jsonSerialization['description'] as String,
      attachmentUrl: jsonSerialization['attachmentUrl'] as String?,
      status: jsonSerialization['status'] == null
          ? null
          : _i2.RequestStatus.fromJson((jsonSerialization['status'] as String)),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue userId;

  _i3.User? user;

  _i1.UuidValue vendorId;

  _i4.Vendor? vendor;

  int productId;

  _i5.Product? product;

  String description;

  String? attachmentUrl;

  _i2.RequestStatus status;

  DateTime createdAt;

  /// Returns a shallow copy of this [CustomizationRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CustomizationRequest copyWith({
    int? id,
    _i1.UuidValue? userId,
    _i3.User? user,
    _i1.UuidValue? vendorId,
    _i4.Vendor? vendor,
    int? productId,
    _i5.Product? product,
    String? description,
    String? attachmentUrl,
    _i2.RequestStatus? status,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CustomizationRequest',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      if (user != null) 'user': user?.toJson(),
      'vendorId': vendorId.toJson(),
      if (vendor != null) 'vendor': vendor?.toJson(),
      'productId': productId,
      if (product != null) 'product': product?.toJson(),
      'description': description,
      if (attachmentUrl != null) 'attachmentUrl': attachmentUrl,
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

class _CustomizationRequestImpl extends CustomizationRequest {
  _CustomizationRequestImpl({
    int? id,
    required _i1.UuidValue userId,
    _i3.User? user,
    required _i1.UuidValue vendorId,
    _i4.Vendor? vendor,
    required int productId,
    _i5.Product? product,
    required String description,
    String? attachmentUrl,
    _i2.RequestStatus? status,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         user: user,
         vendorId: vendorId,
         vendor: vendor,
         productId: productId,
         product: product,
         description: description,
         attachmentUrl: attachmentUrl,
         status: status,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [CustomizationRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CustomizationRequest copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    Object? user = _Undefined,
    _i1.UuidValue? vendorId,
    Object? vendor = _Undefined,
    int? productId,
    Object? product = _Undefined,
    String? description,
    Object? attachmentUrl = _Undefined,
    _i2.RequestStatus? status,
    DateTime? createdAt,
  }) {
    return CustomizationRequest(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _i3.User? ? user : this.user?.copyWith(),
      vendorId: vendorId ?? this.vendorId,
      vendor: vendor is _i4.Vendor? ? vendor : this.vendor?.copyWith(),
      productId: productId ?? this.productId,
      product: product is _i5.Product? ? product : this.product?.copyWith(),
      description: description ?? this.description,
      attachmentUrl: attachmentUrl is String?
          ? attachmentUrl
          : this.attachmentUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
