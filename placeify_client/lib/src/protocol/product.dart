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
import 'product_status.dart' as _i2;
import 'vendor.dart' as _i3;
import 'category.dart' as _i4;
import 'package:placeify_client/src/protocol/protocol.dart' as _i5;

/// Furniture product listed by a vendor in the marketplace.
abstract class Product implements _i1.SerializableModel {
  Product._({
    this.id,
    required this.vendorId,
    this.vendor,
    this.categoryId,
    this.category,
    required this.name,
    required this.description,
    required this.price,
    this.model3dUrl,
    this.thumbnailUrl,
    _i2.ProductStatus? status,
    DateTime? createdAt,
  }) : status = status ?? _i2.ProductStatus.active,
       createdAt = createdAt ?? DateTime.now();

  factory Product({
    int? id,
    required _i1.UuidValue vendorId,
    _i3.Vendor? vendor,
    int? categoryId,
    _i4.Category? category,
    required String name,
    required String description,
    required double price,
    String? model3dUrl,
    String? thumbnailUrl,
    _i2.ProductStatus? status,
    DateTime? createdAt,
  }) = _ProductImpl;

  factory Product.fromJson(Map<String, dynamic> jsonSerialization) {
    return Product(
      id: jsonSerialization['id'] as int?,
      vendorId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['vendorId'],
      ),
      vendor: jsonSerialization['vendor'] == null
          ? null
          : _i5.Protocol().deserialize<_i3.Vendor>(jsonSerialization['vendor']),
      categoryId: jsonSerialization['categoryId'] as int?,
      category: jsonSerialization['category'] == null
          ? null
          : _i5.Protocol().deserialize<_i4.Category>(
              jsonSerialization['category'],
            ),
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
      price: (jsonSerialization['price'] as num).toDouble(),
      model3dUrl: jsonSerialization['model3dUrl'] as String?,
      thumbnailUrl: jsonSerialization['thumbnailUrl'] as String?,
      status: jsonSerialization['status'] == null
          ? null
          : _i2.ProductStatus.fromJson((jsonSerialization['status'] as String)),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue vendorId;

  _i3.Vendor? vendor;

  int? categoryId;

  _i4.Category? category;

  String name;

  String description;

  double price;

  String? model3dUrl;

  String? thumbnailUrl;

  _i2.ProductStatus status;

  DateTime createdAt;

  /// Returns a shallow copy of this [Product]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Product copyWith({
    int? id,
    _i1.UuidValue? vendorId,
    _i3.Vendor? vendor,
    int? categoryId,
    _i4.Category? category,
    String? name,
    String? description,
    double? price,
    String? model3dUrl,
    String? thumbnailUrl,
    _i2.ProductStatus? status,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Product',
      if (id != null) 'id': id,
      'vendorId': vendorId.toJson(),
      if (vendor != null) 'vendor': vendor?.toJson(),
      if (categoryId != null) 'categoryId': categoryId,
      if (category != null) 'category': category?.toJson(),
      'name': name,
      'description': description,
      'price': price,
      if (model3dUrl != null) 'model3dUrl': model3dUrl,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
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

class _ProductImpl extends Product {
  _ProductImpl({
    int? id,
    required _i1.UuidValue vendorId,
    _i3.Vendor? vendor,
    int? categoryId,
    _i4.Category? category,
    required String name,
    required String description,
    required double price,
    String? model3dUrl,
    String? thumbnailUrl,
    _i2.ProductStatus? status,
    DateTime? createdAt,
  }) : super._(
         id: id,
         vendorId: vendorId,
         vendor: vendor,
         categoryId: categoryId,
         category: category,
         name: name,
         description: description,
         price: price,
         model3dUrl: model3dUrl,
         thumbnailUrl: thumbnailUrl,
         status: status,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Product]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Product copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? vendorId,
    Object? vendor = _Undefined,
    Object? categoryId = _Undefined,
    Object? category = _Undefined,
    String? name,
    String? description,
    double? price,
    Object? model3dUrl = _Undefined,
    Object? thumbnailUrl = _Undefined,
    _i2.ProductStatus? status,
    DateTime? createdAt,
  }) {
    return Product(
      id: id is int? ? id : this.id,
      vendorId: vendorId ?? this.vendorId,
      vendor: vendor is _i3.Vendor? ? vendor : this.vendor?.copyWith(),
      categoryId: categoryId is int? ? categoryId : this.categoryId,
      category: category is _i4.Category?
          ? category
          : this.category?.copyWith(),
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      model3dUrl: model3dUrl is String? ? model3dUrl : this.model3dUrl,
      thumbnailUrl: thumbnailUrl is String? ? thumbnailUrl : this.thumbnailUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
