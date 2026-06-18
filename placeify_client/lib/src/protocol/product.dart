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
import 'admin.dart' as _i5;
import 'package:placeify_client/src/protocol/protocol.dart' as _i6;

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
    this.materials,
    this.widthCm,
    this.depthCm,
    this.heightCm,
    this.weightKg,
    this.assemblyNote,
    this.careInstructions,
    this.warranty,
    this.model3dUrl,
    this.thumbnailUrl,
    _i2.ProductStatus? status,
    this.removedReason,
    this.removedById,
    this.removedBy,
    this.removedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : status = status ?? _i2.ProductStatus.active,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Product({
    int? id,
    required _i1.UuidValue vendorId,
    _i3.Vendor? vendor,
    int? categoryId,
    _i4.Category? category,
    required String name,
    required String description,
    required double price,
    String? materials,
    double? widthCm,
    double? depthCm,
    double? heightCm,
    double? weightKg,
    String? assemblyNote,
    String? careInstructions,
    String? warranty,
    String? model3dUrl,
    String? thumbnailUrl,
    _i2.ProductStatus? status,
    String? removedReason,
    _i1.UuidValue? removedById,
    _i5.Admin? removedBy,
    DateTime? removedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ProductImpl;

  factory Product.fromJson(Map<String, dynamic> jsonSerialization) {
    return Product(
      id: jsonSerialization['id'] as int?,
      vendorId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['vendorId'],
      ),
      vendor: jsonSerialization['vendor'] == null
          ? null
          : _i6.Protocol().deserialize<_i3.Vendor>(jsonSerialization['vendor']),
      categoryId: jsonSerialization['categoryId'] as int?,
      category: jsonSerialization['category'] == null
          ? null
          : _i6.Protocol().deserialize<_i4.Category>(
              jsonSerialization['category'],
            ),
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
      price: (jsonSerialization['price'] as num).toDouble(),
      materials: jsonSerialization['materials'] as String?,
      widthCm: (jsonSerialization['widthCm'] as num?)?.toDouble(),
      depthCm: (jsonSerialization['depthCm'] as num?)?.toDouble(),
      heightCm: (jsonSerialization['heightCm'] as num?)?.toDouble(),
      weightKg: (jsonSerialization['weightKg'] as num?)?.toDouble(),
      assemblyNote: jsonSerialization['assemblyNote'] as String?,
      careInstructions: jsonSerialization['careInstructions'] as String?,
      warranty: jsonSerialization['warranty'] as String?,
      model3dUrl: jsonSerialization['model3dUrl'] as String?,
      thumbnailUrl: jsonSerialization['thumbnailUrl'] as String?,
      status: jsonSerialization['status'] == null
          ? null
          : _i2.ProductStatus.fromJson((jsonSerialization['status'] as String)),
      removedReason: jsonSerialization['removedReason'] as String?,
      removedById: jsonSerialization['removedById'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['removedById'],
            ),
      removedBy: jsonSerialization['removedBy'] == null
          ? null
          : _i6.Protocol().deserialize<_i5.Admin>(
              jsonSerialization['removedBy'],
            ),
      removedAt: jsonSerialization['removedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['removedAt']),
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
  int? id;

  _i1.UuidValue vendorId;

  _i3.Vendor? vendor;

  int? categoryId;

  _i4.Category? category;

  String name;

  String description;

  double price;

  String? materials;

  double? widthCm;

  double? depthCm;

  double? heightCm;

  double? weightKg;

  String? assemblyNote;

  String? careInstructions;

  String? warranty;

  String? model3dUrl;

  String? thumbnailUrl;

  _i2.ProductStatus status;

  /// Why the product was removed from the catalog.
  String? removedReason;

  _i1.UuidValue? removedById;

  /// Admin who removed or flagged the product.
  _i5.Admin? removedBy;

  DateTime? removedAt;

  DateTime createdAt;

  DateTime updatedAt;

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
    String? materials,
    double? widthCm,
    double? depthCm,
    double? heightCm,
    double? weightKg,
    String? assemblyNote,
    String? careInstructions,
    String? warranty,
    String? model3dUrl,
    String? thumbnailUrl,
    _i2.ProductStatus? status,
    String? removedReason,
    _i1.UuidValue? removedById,
    _i5.Admin? removedBy,
    DateTime? removedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
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
      if (materials != null) 'materials': materials,
      if (widthCm != null) 'widthCm': widthCm,
      if (depthCm != null) 'depthCm': depthCm,
      if (heightCm != null) 'heightCm': heightCm,
      if (weightKg != null) 'weightKg': weightKg,
      if (assemblyNote != null) 'assemblyNote': assemblyNote,
      if (careInstructions != null) 'careInstructions': careInstructions,
      if (warranty != null) 'warranty': warranty,
      if (model3dUrl != null) 'model3dUrl': model3dUrl,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
      'status': status.toJson(),
      if (removedReason != null) 'removedReason': removedReason,
      if (removedById != null) 'removedById': removedById?.toJson(),
      if (removedBy != null) 'removedBy': removedBy?.toJson(),
      if (removedAt != null) 'removedAt': removedAt?.toJson(),
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
    String? materials,
    double? widthCm,
    double? depthCm,
    double? heightCm,
    double? weightKg,
    String? assemblyNote,
    String? careInstructions,
    String? warranty,
    String? model3dUrl,
    String? thumbnailUrl,
    _i2.ProductStatus? status,
    String? removedReason,
    _i1.UuidValue? removedById,
    _i5.Admin? removedBy,
    DateTime? removedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         vendorId: vendorId,
         vendor: vendor,
         categoryId: categoryId,
         category: category,
         name: name,
         description: description,
         price: price,
         materials: materials,
         widthCm: widthCm,
         depthCm: depthCm,
         heightCm: heightCm,
         weightKg: weightKg,
         assemblyNote: assemblyNote,
         careInstructions: careInstructions,
         warranty: warranty,
         model3dUrl: model3dUrl,
         thumbnailUrl: thumbnailUrl,
         status: status,
         removedReason: removedReason,
         removedById: removedById,
         removedBy: removedBy,
         removedAt: removedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
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
    Object? materials = _Undefined,
    Object? widthCm = _Undefined,
    Object? depthCm = _Undefined,
    Object? heightCm = _Undefined,
    Object? weightKg = _Undefined,
    Object? assemblyNote = _Undefined,
    Object? careInstructions = _Undefined,
    Object? warranty = _Undefined,
    Object? model3dUrl = _Undefined,
    Object? thumbnailUrl = _Undefined,
    _i2.ProductStatus? status,
    Object? removedReason = _Undefined,
    Object? removedById = _Undefined,
    Object? removedBy = _Undefined,
    Object? removedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
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
      materials: materials is String? ? materials : this.materials,
      widthCm: widthCm is double? ? widthCm : this.widthCm,
      depthCm: depthCm is double? ? depthCm : this.depthCm,
      heightCm: heightCm is double? ? heightCm : this.heightCm,
      weightKg: weightKg is double? ? weightKg : this.weightKg,
      assemblyNote: assemblyNote is String? ? assemblyNote : this.assemblyNote,
      careInstructions: careInstructions is String?
          ? careInstructions
          : this.careInstructions,
      warranty: warranty is String? ? warranty : this.warranty,
      model3dUrl: model3dUrl is String? ? model3dUrl : this.model3dUrl,
      thumbnailUrl: thumbnailUrl is String? ? thumbnailUrl : this.thumbnailUrl,
      status: status ?? this.status,
      removedReason: removedReason is String?
          ? removedReason
          : this.removedReason,
      removedById: removedById is _i1.UuidValue?
          ? removedById
          : this.removedById,
      removedBy: removedBy is _i5.Admin?
          ? removedBy
          : this.removedBy?.copyWith(),
      removedAt: removedAt is DateTime? ? removedAt : this.removedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
