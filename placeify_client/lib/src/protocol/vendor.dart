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
import 'admin.dart' as _i3;
import 'package:placeify_client/src/protocol/protocol.dart' as _i4;

/// VendorProfile — vendor-specific data linked 1:1 to a User account.
abstract class Vendor implements _i1.SerializableModel {
  Vendor._({
    this.id,
    required this.userId,
    this.user,
    required this.shopName,
    this.description,
    this.businessAddress,
    this.logoUrl,
    double? rating,
    this.approvedById,
    this.approvedBy,
    this.approvedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : rating = rating ?? 0.0,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Vendor({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    _i2.User? user,
    required String shopName,
    String? description,
    String? businessAddress,
    String? logoUrl,
    double? rating,
    _i1.UuidValue? approvedById,
    _i3.Admin? approvedBy,
    DateTime? approvedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _VendorImpl;

  factory Vendor.fromJson(Map<String, dynamic> jsonSerialization) {
    return Vendor(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      user: jsonSerialization['user'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.User>(jsonSerialization['user']),
      shopName: jsonSerialization['shopName'] as String,
      description: jsonSerialization['description'] as String?,
      businessAddress: jsonSerialization['businessAddress'] as String?,
      logoUrl: jsonSerialization['logoUrl'] as String?,
      rating: (jsonSerialization['rating'] as num?)?.toDouble(),
      approvedById: jsonSerialization['approvedById'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['approvedById'],
            ),
      approvedBy: jsonSerialization['approvedBy'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.Admin>(
              jsonSerialization['approvedBy'],
            ),
      approvedAt: jsonSerialization['approvedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['approvedAt']),
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

  _i2.User? user;

  String shopName;

  String? description;

  String? businessAddress;

  String? logoUrl;

  double rating;

  _i1.UuidValue? approvedById;

  /// Admin who approved this vendor shop.
  _i3.Admin? approvedBy;

  DateTime? approvedAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Vendor]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Vendor copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    _i2.User? user,
    String? shopName,
    String? description,
    String? businessAddress,
    String? logoUrl,
    double? rating,
    _i1.UuidValue? approvedById,
    _i3.Admin? approvedBy,
    DateTime? approvedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Vendor',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      if (user != null) 'user': user?.toJson(),
      'shopName': shopName,
      if (description != null) 'description': description,
      if (businessAddress != null) 'businessAddress': businessAddress,
      if (logoUrl != null) 'logoUrl': logoUrl,
      'rating': rating,
      if (approvedById != null) 'approvedById': approvedById?.toJson(),
      if (approvedBy != null) 'approvedBy': approvedBy?.toJson(),
      if (approvedAt != null) 'approvedAt': approvedAt?.toJson(),
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

class _VendorImpl extends Vendor {
  _VendorImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    _i2.User? user,
    required String shopName,
    String? description,
    String? businessAddress,
    String? logoUrl,
    double? rating,
    _i1.UuidValue? approvedById,
    _i3.Admin? approvedBy,
    DateTime? approvedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         user: user,
         shopName: shopName,
         description: description,
         businessAddress: businessAddress,
         logoUrl: logoUrl,
         rating: rating,
         approvedById: approvedById,
         approvedBy: approvedBy,
         approvedAt: approvedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Vendor]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Vendor copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    Object? user = _Undefined,
    String? shopName,
    Object? description = _Undefined,
    Object? businessAddress = _Undefined,
    Object? logoUrl = _Undefined,
    double? rating,
    Object? approvedById = _Undefined,
    Object? approvedBy = _Undefined,
    Object? approvedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Vendor(
      id: id is _i1.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _i2.User? ? user : this.user?.copyWith(),
      shopName: shopName ?? this.shopName,
      description: description is String? ? description : this.description,
      businessAddress: businessAddress is String?
          ? businessAddress
          : this.businessAddress,
      logoUrl: logoUrl is String? ? logoUrl : this.logoUrl,
      rating: rating ?? this.rating,
      approvedById: approvedById is _i1.UuidValue?
          ? approvedById
          : this.approvedById,
      approvedBy: approvedBy is _i3.Admin?
          ? approvedBy
          : this.approvedBy?.copyWith(),
      approvedAt: approvedAt is DateTime? ? approvedAt : this.approvedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
