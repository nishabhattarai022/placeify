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
import 'user.dart' as _i2;
import 'vendor.dart' as _i3;
import 'vendor_document_type.dart' as _i4;
import 'package:placeify_client/src/protocol/protocol.dart' as _i5;

/// Verification document uploaded during vendor onboarding.
abstract class VendorDocument implements _i1.SerializableModel {
  VendorDocument._({
    this.id,
    required this.userId,
    this.user,
    this.vendorId,
    this.vendor,
    required this.documentType,
    required this.fileUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory VendorDocument({
    int? id,
    required _i1.UuidValue userId,
    _i2.User? user,
    _i1.UuidValue? vendorId,
    _i3.Vendor? vendor,
    required _i4.VendorDocumentType documentType,
    required String fileUrl,
    DateTime? createdAt,
  }) = _VendorDocumentImpl;

  factory VendorDocument.fromJson(Map<String, dynamic> jsonSerialization) {
    return VendorDocument(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      user: jsonSerialization['user'] == null
          ? null
          : _i5.Protocol().deserialize<_i2.User>(jsonSerialization['user']),
      vendorId: jsonSerialization['vendorId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['vendorId']),
      vendor: jsonSerialization['vendor'] == null
          ? null
          : _i5.Protocol().deserialize<_i3.Vendor>(jsonSerialization['vendor']),
      documentType: _i4.VendorDocumentType.fromJson(
        (jsonSerialization['documentType'] as String),
      ),
      fileUrl: jsonSerialization['fileUrl'] as String,
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

  _i2.User? user;

  _i1.UuidValue? vendorId;

  _i3.Vendor? vendor;

  _i4.VendorDocumentType documentType;

  String fileUrl;

  DateTime createdAt;

  /// Returns a shallow copy of this [VendorDocument]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VendorDocument copyWith({
    int? id,
    _i1.UuidValue? userId,
    _i2.User? user,
    _i1.UuidValue? vendorId,
    _i3.Vendor? vendor,
    _i4.VendorDocumentType? documentType,
    String? fileUrl,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VendorDocument',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      if (user != null) 'user': user?.toJson(),
      if (vendorId != null) 'vendorId': vendorId?.toJson(),
      if (vendor != null) 'vendor': vendor?.toJson(),
      'documentType': documentType.toJson(),
      'fileUrl': fileUrl,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VendorDocumentImpl extends VendorDocument {
  _VendorDocumentImpl({
    int? id,
    required _i1.UuidValue userId,
    _i2.User? user,
    _i1.UuidValue? vendorId,
    _i3.Vendor? vendor,
    required _i4.VendorDocumentType documentType,
    required String fileUrl,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         user: user,
         vendorId: vendorId,
         vendor: vendor,
         documentType: documentType,
         fileUrl: fileUrl,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [VendorDocument]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VendorDocument copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    Object? user = _Undefined,
    Object? vendorId = _Undefined,
    Object? vendor = _Undefined,
    _i4.VendorDocumentType? documentType,
    String? fileUrl,
    DateTime? createdAt,
  }) {
    return VendorDocument(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _i2.User? ? user : this.user?.copyWith(),
      vendorId: vendorId is _i1.UuidValue? ? vendorId : this.vendorId,
      vendor: vendor is _i3.Vendor? ? vendor : this.vendor?.copyWith(),
      documentType: documentType ?? this.documentType,
      fileUrl: fileUrl ?? this.fileUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
