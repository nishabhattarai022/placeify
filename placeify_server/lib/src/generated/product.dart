/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'product_status.dart' as _i2;
import 'vendor.dart' as _i3;
import 'category.dart' as _i4;
import 'admin.dart' as _i5;
import 'package:placeify_server/src/generated/protocol.dart' as _i6;

abstract class Product
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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
    this.viewImageUrls,
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
    List<String>? viewImageUrls,
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
      viewImageUrls: jsonSerialization['viewImageUrls'] == null
          ? null
          : _i6.Protocol().deserialize<List<String>>(
              jsonSerialization['viewImageUrls'],
            ),
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

  static final t = ProductTable();

  static const db = ProductRepository._();

  @override
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

  /// Extra product photos for multiview 3D generation (left, back, right, etc.).
  List<String>? viewImageUrls;

  _i2.ProductStatus status;

  /// Why the product was removed from the catalog.
  String? removedReason;

  _i1.UuidValue? removedById;

  /// Admin who removed or flagged the product.
  _i5.Admin? removedBy;

  DateTime? removedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

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
    List<String>? viewImageUrls,
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
      if (viewImageUrls != null) 'viewImageUrls': viewImageUrls?.toJson(),
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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Product',
      if (id != null) 'id': id,
      'vendorId': vendorId.toJson(),
      if (vendor != null) 'vendor': vendor?.toJsonForProtocol(),
      if (categoryId != null) 'categoryId': categoryId,
      if (category != null) 'category': category?.toJsonForProtocol(),
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
      if (viewImageUrls != null) 'viewImageUrls': viewImageUrls?.toJson(),
      'status': status.toJson(),
      if (removedReason != null) 'removedReason': removedReason,
      if (removedById != null) 'removedById': removedById?.toJson(),
      if (removedBy != null) 'removedBy': removedBy?.toJsonForProtocol(),
      if (removedAt != null) 'removedAt': removedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static ProductInclude include({
    _i3.VendorInclude? vendor,
    _i4.CategoryInclude? category,
    _i5.AdminInclude? removedBy,
  }) {
    return ProductInclude._(
      vendor: vendor,
      category: category,
      removedBy: removedBy,
    );
  }

  static ProductIncludeList includeList({
    _i1.WhereExpressionBuilder<ProductTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProductTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProductTable>? orderByList,
    ProductInclude? include,
  }) {
    return ProductIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Product.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Product.t),
      include: include,
    );
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
    List<String>? viewImageUrls,
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
         viewImageUrls: viewImageUrls,
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
    Object? viewImageUrls = _Undefined,
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
      viewImageUrls: viewImageUrls is List<String>?
          ? viewImageUrls
          : this.viewImageUrls?.map((e0) => e0).toList(),
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

class ProductUpdateTable extends _i1.UpdateTable<ProductTable> {
  ProductUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> vendorId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.vendorId,
        value,
      );

  _i1.ColumnValue<int, int> categoryId(int? value) => _i1.ColumnValue(
    table.categoryId,
    value,
  );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> description(String value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<double, double> price(double value) => _i1.ColumnValue(
    table.price,
    value,
  );

  _i1.ColumnValue<String, String> materials(String? value) => _i1.ColumnValue(
    table.materials,
    value,
  );

  _i1.ColumnValue<double, double> widthCm(double? value) => _i1.ColumnValue(
    table.widthCm,
    value,
  );

  _i1.ColumnValue<double, double> depthCm(double? value) => _i1.ColumnValue(
    table.depthCm,
    value,
  );

  _i1.ColumnValue<double, double> heightCm(double? value) => _i1.ColumnValue(
    table.heightCm,
    value,
  );

  _i1.ColumnValue<double, double> weightKg(double? value) => _i1.ColumnValue(
    table.weightKg,
    value,
  );

  _i1.ColumnValue<String, String> assemblyNote(String? value) =>
      _i1.ColumnValue(
        table.assemblyNote,
        value,
      );

  _i1.ColumnValue<String, String> careInstructions(String? value) =>
      _i1.ColumnValue(
        table.careInstructions,
        value,
      );

  _i1.ColumnValue<String, String> warranty(String? value) => _i1.ColumnValue(
    table.warranty,
    value,
  );

  _i1.ColumnValue<String, String> model3dUrl(String? value) => _i1.ColumnValue(
    table.model3dUrl,
    value,
  );

  _i1.ColumnValue<String, String> thumbnailUrl(String? value) =>
      _i1.ColumnValue(
        table.thumbnailUrl,
        value,
      );

  _i1.ColumnValue<List<String>, List<String>> viewImageUrls(
    List<String>? value,
  ) => _i1.ColumnValue(
    table.viewImageUrls,
    value,
  );

  _i1.ColumnValue<_i2.ProductStatus, _i2.ProductStatus> status(
    _i2.ProductStatus value,
  ) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> removedReason(String? value) =>
      _i1.ColumnValue(
        table.removedReason,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> removedById(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.removedById,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> removedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.removedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class ProductTable extends _i1.Table<int?> {
  ProductTable({super.tableRelation}) : super(tableName: 'product') {
    updateTable = ProductUpdateTable(this);
    vendorId = _i1.ColumnUuid(
      'vendorId',
      this,
    );
    categoryId = _i1.ColumnInt(
      'categoryId',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    price = _i1.ColumnDouble(
      'price',
      this,
    );
    materials = _i1.ColumnString(
      'materials',
      this,
    );
    widthCm = _i1.ColumnDouble(
      'widthCm',
      this,
    );
    depthCm = _i1.ColumnDouble(
      'depthCm',
      this,
    );
    heightCm = _i1.ColumnDouble(
      'heightCm',
      this,
    );
    weightKg = _i1.ColumnDouble(
      'weightKg',
      this,
    );
    assemblyNote = _i1.ColumnString(
      'assemblyNote',
      this,
    );
    careInstructions = _i1.ColumnString(
      'careInstructions',
      this,
    );
    warranty = _i1.ColumnString(
      'warranty',
      this,
    );
    model3dUrl = _i1.ColumnString(
      'model3dUrl',
      this,
    );
    thumbnailUrl = _i1.ColumnString(
      'thumbnailUrl',
      this,
    );
    viewImageUrls = _i1.ColumnSerializable<List<String>>(
      'viewImageUrls',
      this,
    );
    status = _i1.ColumnEnum(
      'status',
      this,
      _i1.EnumSerialization.byName,
      hasDefault: true,
    );
    removedReason = _i1.ColumnString(
      'removedReason',
      this,
    );
    removedById = _i1.ColumnUuid(
      'removedById',
      this,
    );
    removedAt = _i1.ColumnDateTime(
      'removedAt',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
  }

  late final ProductUpdateTable updateTable;

  late final _i1.ColumnUuid vendorId;

  _i3.VendorTable? _vendor;

  late final _i1.ColumnInt categoryId;

  _i4.CategoryTable? _category;

  late final _i1.ColumnString name;

  late final _i1.ColumnString description;

  late final _i1.ColumnDouble price;

  late final _i1.ColumnString materials;

  late final _i1.ColumnDouble widthCm;

  late final _i1.ColumnDouble depthCm;

  late final _i1.ColumnDouble heightCm;

  late final _i1.ColumnDouble weightKg;

  late final _i1.ColumnString assemblyNote;

  late final _i1.ColumnString careInstructions;

  late final _i1.ColumnString warranty;

  late final _i1.ColumnString model3dUrl;

  late final _i1.ColumnString thumbnailUrl;

  /// Extra product photos for multiview 3D generation (left, back, right, etc.).
  late final _i1.ColumnSerializable<List<String>> viewImageUrls;

  late final _i1.ColumnEnum<_i2.ProductStatus> status;

  /// Why the product was removed from the catalog.
  late final _i1.ColumnString removedReason;

  late final _i1.ColumnUuid removedById;

  /// Admin who removed or flagged the product.
  _i5.AdminTable? _removedBy;

  late final _i1.ColumnDateTime removedAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  _i3.VendorTable get vendor {
    if (_vendor != null) return _vendor!;
    _vendor = _i1.createRelationTable(
      relationFieldName: 'vendor',
      field: Product.t.vendorId,
      foreignField: _i3.Vendor.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.VendorTable(tableRelation: foreignTableRelation),
    );
    return _vendor!;
  }

  _i4.CategoryTable get category {
    if (_category != null) return _category!;
    _category = _i1.createRelationTable(
      relationFieldName: 'category',
      field: Product.t.categoryId,
      foreignField: _i4.Category.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.CategoryTable(tableRelation: foreignTableRelation),
    );
    return _category!;
  }

  _i5.AdminTable get removedBy {
    if (_removedBy != null) return _removedBy!;
    _removedBy = _i1.createRelationTable(
      relationFieldName: 'removedBy',
      field: Product.t.removedById,
      foreignField: _i5.Admin.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i5.AdminTable(tableRelation: foreignTableRelation),
    );
    return _removedBy!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    vendorId,
    categoryId,
    name,
    description,
    price,
    materials,
    widthCm,
    depthCm,
    heightCm,
    weightKg,
    assemblyNote,
    careInstructions,
    warranty,
    model3dUrl,
    thumbnailUrl,
    viewImageUrls,
    status,
    removedReason,
    removedById,
    removedAt,
    createdAt,
    updatedAt,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'vendor') {
      return vendor;
    }
    if (relationField == 'category') {
      return category;
    }
    if (relationField == 'removedBy') {
      return removedBy;
    }
    return null;
  }
}

class ProductInclude extends _i1.IncludeObject {
  ProductInclude._({
    _i3.VendorInclude? vendor,
    _i4.CategoryInclude? category,
    _i5.AdminInclude? removedBy,
  }) {
    _vendor = vendor;
    _category = category;
    _removedBy = removedBy;
  }

  _i3.VendorInclude? _vendor;

  _i4.CategoryInclude? _category;

  _i5.AdminInclude? _removedBy;

  @override
  Map<String, _i1.Include?> get includes => {
    'vendor': _vendor,
    'category': _category,
    'removedBy': _removedBy,
  };

  @override
  _i1.Table<int?> get table => Product.t;
}

class ProductIncludeList extends _i1.IncludeList {
  ProductIncludeList._({
    _i1.WhereExpressionBuilder<ProductTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Product.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Product.t;
}

class ProductRepository {
  const ProductRepository._();

  final attachRow = const ProductAttachRowRepository._();

  final detachRow = const ProductDetachRowRepository._();

  /// Returns a list of [Product]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Product>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProductTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProductTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProductTable>? orderByList,
    _i1.Transaction? transaction,
    ProductInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Product>(
      where: where?.call(Product.t),
      orderBy: orderBy?.call(Product.t),
      orderByList: orderByList?.call(Product.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Product] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Product?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProductTable>? where,
    int? offset,
    _i1.OrderByBuilder<ProductTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProductTable>? orderByList,
    _i1.Transaction? transaction,
    ProductInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Product>(
      where: where?.call(Product.t),
      orderBy: orderBy?.call(Product.t),
      orderByList: orderByList?.call(Product.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Product] by its [id] or null if no such row exists.
  Future<Product?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    ProductInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Product>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Product]s in the list and returns the inserted rows.
  ///
  /// The returned [Product]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Product>> insert(
    _i1.DatabaseSession session,
    List<Product> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Product>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Product] and returns the inserted row.
  ///
  /// The returned [Product] will have its `id` field set.
  Future<Product> insertRow(
    _i1.DatabaseSession session,
    Product row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Product>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Product]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Product>> update(
    _i1.DatabaseSession session,
    List<Product> rows, {
    _i1.ColumnSelections<ProductTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Product>(
      rows,
      columns: columns?.call(Product.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Product]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Product> updateRow(
    _i1.DatabaseSession session,
    Product row, {
    _i1.ColumnSelections<ProductTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Product>(
      row,
      columns: columns?.call(Product.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Product] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Product?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<ProductUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Product>(
      id,
      columnValues: columnValues(Product.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Product]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Product>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ProductUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ProductTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProductTable>? orderBy,
    _i1.OrderByListBuilder<ProductTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Product>(
      columnValues: columnValues(Product.t.updateTable),
      where: where(Product.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Product.t),
      orderByList: orderByList?.call(Product.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Product]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Product>> delete(
    _i1.DatabaseSession session,
    List<Product> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Product>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Product].
  Future<Product> deleteRow(
    _i1.DatabaseSession session,
    Product row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Product>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Product>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ProductTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Product>(
      where: where(Product.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProductTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Product>(
      where: where?.call(Product.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Product] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ProductTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Product>(
      where: where(Product.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class ProductAttachRowRepository {
  const ProductAttachRowRepository._();

  /// Creates a relation between the given [Product] and [Vendor]
  /// by setting the [Product]'s foreign key `vendorId` to refer to the [Vendor].
  Future<void> vendor(
    _i1.DatabaseSession session,
    Product product,
    _i3.Vendor vendor, {
    _i1.Transaction? transaction,
  }) async {
    if (product.id == null) {
      throw ArgumentError.notNull('product.id');
    }
    if (vendor.id == null) {
      throw ArgumentError.notNull('vendor.id');
    }

    var $product = product.copyWith(vendorId: vendor.id);
    await session.db.updateRow<Product>(
      $product,
      columns: [Product.t.vendorId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Product] and [Category]
  /// by setting the [Product]'s foreign key `categoryId` to refer to the [Category].
  Future<void> category(
    _i1.DatabaseSession session,
    Product product,
    _i4.Category category, {
    _i1.Transaction? transaction,
  }) async {
    if (product.id == null) {
      throw ArgumentError.notNull('product.id');
    }
    if (category.id == null) {
      throw ArgumentError.notNull('category.id');
    }

    var $product = product.copyWith(categoryId: category.id);
    await session.db.updateRow<Product>(
      $product,
      columns: [Product.t.categoryId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Product] and [Admin]
  /// by setting the [Product]'s foreign key `removedById` to refer to the [Admin].
  Future<void> removedBy(
    _i1.DatabaseSession session,
    Product product,
    _i5.Admin removedBy, {
    _i1.Transaction? transaction,
  }) async {
    if (product.id == null) {
      throw ArgumentError.notNull('product.id');
    }
    if (removedBy.id == null) {
      throw ArgumentError.notNull('removedBy.id');
    }

    var $product = product.copyWith(removedById: removedBy.id);
    await session.db.updateRow<Product>(
      $product,
      columns: [Product.t.removedById],
      transaction: transaction,
    );
  }
}

class ProductDetachRowRepository {
  const ProductDetachRowRepository._();

  /// Detaches the relation between this [Product] and the [Category] set in `category`
  /// by setting the [Product]'s foreign key `categoryId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> category(
    _i1.DatabaseSession session,
    Product product, {
    _i1.Transaction? transaction,
  }) async {
    if (product.id == null) {
      throw ArgumentError.notNull('product.id');
    }

    var $product = product.copyWith(categoryId: null);
    await session.db.updateRow<Product>(
      $product,
      columns: [Product.t.categoryId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [Product] and the [Admin] set in `removedBy`
  /// by setting the [Product]'s foreign key `removedById` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> removedBy(
    _i1.DatabaseSession session,
    Product product, {
    _i1.Transaction? transaction,
  }) async {
    if (product.id == null) {
      throw ArgumentError.notNull('product.id');
    }

    var $product = product.copyWith(removedById: null);
    await session.db.updateRow<Product>(
      $product,
      columns: [Product.t.removedById],
      transaction: transaction,
    );
  }
}
