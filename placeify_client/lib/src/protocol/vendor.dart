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
import 'package:placeify_client/src/protocol/protocol.dart' as _i3;

/// Vendor shop profile linked to a user account.
abstract class Vendor implements _i1.SerializableModel {
  Vendor._({
    this.id,
    required this.userId,
    this.user,
    required this.shopName,
    this.description,
    this.logoUrl,
    double? rating,
    DateTime? createdAt,
  }) : rating = rating ?? 0.0,
       createdAt = createdAt ?? DateTime.now();

  factory Vendor({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    _i2.User? user,
    required String shopName,
    String? description,
    String? logoUrl,
    double? rating,
    DateTime? createdAt,
  }) = _VendorImpl;

  factory Vendor.fromJson(Map<String, dynamic> jsonSerialization) {
    return Vendor(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      user: jsonSerialization['user'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.User>(jsonSerialization['user']),
      shopName: jsonSerialization['shopName'] as String,
      description: jsonSerialization['description'] as String?,
      logoUrl: jsonSerialization['logoUrl'] as String?,
      rating: (jsonSerialization['rating'] as num?)?.toDouble(),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
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

  String? logoUrl;

  double rating;

  DateTime createdAt;

  /// Returns a shallow copy of this [Vendor]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Vendor copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    _i2.User? user,
    String? shopName,
    String? description,
    String? logoUrl,
    double? rating,
    DateTime? createdAt,
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
      if (logoUrl != null) 'logoUrl': logoUrl,
      'rating': rating,
      'createdAt': createdAt.toJson(),
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
    String? logoUrl,
    double? rating,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         user: user,
         shopName: shopName,
         description: description,
         logoUrl: logoUrl,
         rating: rating,
         createdAt: createdAt,
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
    Object? logoUrl = _Undefined,
    double? rating,
    DateTime? createdAt,
  }) {
    return Vendor(
      id: id is _i1.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _i2.User? ? user : this.user?.copyWith(),
      shopName: shopName ?? this.shopName,
      description: description is String? ? description : this.description,
      logoUrl: logoUrl is String? ? logoUrl : this.logoUrl,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
