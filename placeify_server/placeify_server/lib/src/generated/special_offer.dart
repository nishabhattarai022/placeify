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
import 'product.dart' as _i2;
import 'package:placeify_server/src/generated/protocol.dart' as _i3;

/// Vendor special offer linked to a single catalog product.
abstract class SpecialOffer
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  SpecialOffer._({
    this.id,
    required this.productId,
    this.product,
    required this.originalPrice,
    required this.discountedPrice,
    required this.tagline,
    String? cardColorHex,
    bool? isActive,
    int? displayOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : cardColorHex = cardColorHex ?? '#A8B5A0',
       isActive = isActive ?? true,
       displayOrder = displayOrder ?? 0,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory SpecialOffer({
    int? id,
    required int productId,
    _i2.Product? product,
    required double originalPrice,
    required double discountedPrice,
    required String tagline,
    String? cardColorHex,
    bool? isActive,
    int? displayOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _SpecialOfferImpl;

  factory SpecialOffer.fromJson(Map<String, dynamic> jsonSerialization) {
    return SpecialOffer(
      id: jsonSerialization['id'] as int?,
      productId: jsonSerialization['productId'] as int,
      product: jsonSerialization['product'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Product>(
              jsonSerialization['product'],
            ),
      originalPrice: (jsonSerialization['originalPrice'] as num).toDouble(),
      discountedPrice: (jsonSerialization['discountedPrice'] as num).toDouble(),
      tagline: jsonSerialization['tagline'] as String,
      cardColorHex: jsonSerialization['cardColorHex'] as String?,
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      displayOrder: jsonSerialization['displayOrder'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = SpecialOfferTable();

  static const db = SpecialOfferRepository._();

  @override
  int? id;

  int productId;

  _i2.Product? product;

  double originalPrice;

  double discountedPrice;

  String tagline;

  String cardColorHex;

  bool isActive;

  int displayOrder;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [SpecialOffer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SpecialOffer copyWith({
    int? id,
    int? productId,
    _i2.Product? product,
    double? originalPrice,
    double? discountedPrice,
    String? tagline,
    String? cardColorHex,
    bool? isActive,
    int? displayOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SpecialOffer',
      if (id != null) 'id': id,
      'productId': productId,
      if (product != null) 'product': product?.toJson(),
      'originalPrice': originalPrice,
      'discountedPrice': discountedPrice,
      'tagline': tagline,
      'cardColorHex': cardColorHex,
      'isActive': isActive,
      'displayOrder': displayOrder,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SpecialOffer',
      if (id != null) 'id': id,
      'productId': productId,
      if (product != null) 'product': product?.toJsonForProtocol(),
      'originalPrice': originalPrice,
      'discountedPrice': discountedPrice,
      'tagline': tagline,
      'cardColorHex': cardColorHex,
      'isActive': isActive,
      'displayOrder': displayOrder,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static SpecialOfferInclude include({_i2.ProductInclude? product}) {
    return SpecialOfferInclude._(product: product);
  }

  static SpecialOfferIncludeList includeList({
    _i1.WhereExpressionBuilder<SpecialOfferTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SpecialOfferTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SpecialOfferTable>? orderByList,
    SpecialOfferInclude? include,
  }) {
    return SpecialOfferIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SpecialOffer.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SpecialOffer.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SpecialOfferImpl extends SpecialOffer {
  _SpecialOfferImpl({
    int? id,
    required int productId,
    _i2.Product? product,
    required double originalPrice,
    required double discountedPrice,
    required String tagline,
    String? cardColorHex,
    bool? isActive,
    int? displayOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         productId: productId,
         product: product,
         originalPrice: originalPrice,
         discountedPrice: discountedPrice,
         tagline: tagline,
         cardColorHex: cardColorHex,
         isActive: isActive,
         displayOrder: displayOrder,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [SpecialOffer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SpecialOffer copyWith({
    Object? id = _Undefined,
    int? productId,
    Object? product = _Undefined,
    double? originalPrice,
    double? discountedPrice,
    String? tagline,
    String? cardColorHex,
    bool? isActive,
    int? displayOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SpecialOffer(
      id: id is int? ? id : this.id,
      productId: productId ?? this.productId,
      product: product is _i2.Product? ? product : this.product?.copyWith(),
      originalPrice: originalPrice ?? this.originalPrice,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      tagline: tagline ?? this.tagline,
      cardColorHex: cardColorHex ?? this.cardColorHex,
      isActive: isActive ?? this.isActive,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class SpecialOfferUpdateTable extends _i1.UpdateTable<SpecialOfferTable> {
  SpecialOfferUpdateTable(super.table);

  _i1.ColumnValue<int, int> productId(int value) => _i1.ColumnValue(
    table.productId,
    value,
  );

  _i1.ColumnValue<double, double> originalPrice(double value) =>
      _i1.ColumnValue(
        table.originalPrice,
        value,
      );

  _i1.ColumnValue<double, double> discountedPrice(double value) =>
      _i1.ColumnValue(
        table.discountedPrice,
        value,
      );

  _i1.ColumnValue<String, String> tagline(String value) => _i1.ColumnValue(
    table.tagline,
    value,
  );

  _i1.ColumnValue<String, String> cardColorHex(String value) => _i1.ColumnValue(
    table.cardColorHex,
    value,
  );

  _i1.ColumnValue<bool, bool> isActive(bool value) => _i1.ColumnValue(
    table.isActive,
    value,
  );

  _i1.ColumnValue<int, int> displayOrder(int value) => _i1.ColumnValue(
    table.displayOrder,
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

class SpecialOfferTable extends _i1.Table<int?> {
  SpecialOfferTable({super.tableRelation}) : super(tableName: 'special_offer') {
    updateTable = SpecialOfferUpdateTable(this);
    productId = _i1.ColumnInt(
      'productId',
      this,
    );
    originalPrice = _i1.ColumnDouble(
      'originalPrice',
      this,
    );
    discountedPrice = _i1.ColumnDouble(
      'discountedPrice',
      this,
    );
    tagline = _i1.ColumnString(
      'tagline',
      this,
    );
    cardColorHex = _i1.ColumnString(
      'cardColorHex',
      this,
      hasDefault: true,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
      hasDefault: true,
    );
    displayOrder = _i1.ColumnInt(
      'displayOrder',
      this,
      hasDefault: true,
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

  late final SpecialOfferUpdateTable updateTable;

  late final _i1.ColumnInt productId;

  _i2.ProductTable? _product;

  late final _i1.ColumnDouble originalPrice;

  late final _i1.ColumnDouble discountedPrice;

  late final _i1.ColumnString tagline;

  late final _i1.ColumnString cardColorHex;

  late final _i1.ColumnBool isActive;

  late final _i1.ColumnInt displayOrder;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  _i2.ProductTable get product {
    if (_product != null) return _product!;
    _product = _i1.createRelationTable(
      relationFieldName: 'product',
      field: SpecialOffer.t.productId,
      foreignField: _i2.Product.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ProductTable(tableRelation: foreignTableRelation),
    );
    return _product!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    productId,
    originalPrice,
    discountedPrice,
    tagline,
    cardColorHex,
    isActive,
    displayOrder,
    createdAt,
    updatedAt,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'product') {
      return product;
    }
    return null;
  }
}

class SpecialOfferInclude extends _i1.IncludeObject {
  SpecialOfferInclude._({_i2.ProductInclude? product}) {
    _product = product;
  }

  _i2.ProductInclude? _product;

  @override
  Map<String, _i1.Include?> get includes => {'product': _product};

  @override
  _i1.Table<int?> get table => SpecialOffer.t;
}

class SpecialOfferIncludeList extends _i1.IncludeList {
  SpecialOfferIncludeList._({
    _i1.WhereExpressionBuilder<SpecialOfferTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SpecialOffer.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => SpecialOffer.t;
}

class SpecialOfferRepository {
  const SpecialOfferRepository._();

  final attachRow = const SpecialOfferAttachRowRepository._();

  /// Returns a list of [SpecialOffer]s matching the given query parameters.
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
  Future<List<SpecialOffer>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<SpecialOfferTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SpecialOfferTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SpecialOfferTable>? orderByList,
    _i1.Transaction? transaction,
    SpecialOfferInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SpecialOffer>(
      where: where?.call(SpecialOffer.t),
      orderBy: orderBy?.call(SpecialOffer.t),
      orderByList: orderByList?.call(SpecialOffer.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SpecialOffer] matching the given query parameters.
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
  Future<SpecialOffer?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<SpecialOfferTable>? where,
    int? offset,
    _i1.OrderByBuilder<SpecialOfferTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SpecialOfferTable>? orderByList,
    _i1.Transaction? transaction,
    SpecialOfferInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SpecialOffer>(
      where: where?.call(SpecialOffer.t),
      orderBy: orderBy?.call(SpecialOffer.t),
      orderByList: orderByList?.call(SpecialOffer.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SpecialOffer] by its [id] or null if no such row exists.
  Future<SpecialOffer?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    SpecialOfferInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SpecialOffer>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SpecialOffer]s in the list and returns the inserted rows.
  ///
  /// The returned [SpecialOffer]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<SpecialOffer>> insert(
    _i1.DatabaseSession session,
    List<SpecialOffer> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<SpecialOffer>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [SpecialOffer] and returns the inserted row.
  ///
  /// The returned [SpecialOffer] will have its `id` field set.
  Future<SpecialOffer> insertRow(
    _i1.DatabaseSession session,
    SpecialOffer row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SpecialOffer>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [SpecialOffer]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<SpecialOffer>> update(
    _i1.DatabaseSession session,
    List<SpecialOffer> rows, {
    _i1.ColumnSelections<SpecialOfferTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SpecialOffer>(
      rows,
      columns: columns?.call(SpecialOffer.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SpecialOffer]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SpecialOffer> updateRow(
    _i1.DatabaseSession session,
    SpecialOffer row, {
    _i1.ColumnSelections<SpecialOfferTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SpecialOffer>(
      row,
      columns: columns?.call(SpecialOffer.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SpecialOffer] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SpecialOffer?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<SpecialOfferUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<SpecialOffer>(
      id,
      columnValues: columnValues(SpecialOffer.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SpecialOffer]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<SpecialOffer>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<SpecialOfferUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<SpecialOfferTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SpecialOfferTable>? orderBy,
    _i1.OrderByListBuilder<SpecialOfferTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<SpecialOffer>(
      columnValues: columnValues(SpecialOffer.t.updateTable),
      where: where(SpecialOffer.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SpecialOffer.t),
      orderByList: orderByList?.call(SpecialOffer.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [SpecialOffer]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SpecialOffer>> delete(
    _i1.DatabaseSession session,
    List<SpecialOffer> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SpecialOffer>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [SpecialOffer].
  Future<SpecialOffer> deleteRow(
    _i1.DatabaseSession session,
    SpecialOffer row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SpecialOffer>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<SpecialOffer>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<SpecialOfferTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SpecialOffer>(
      where: where(SpecialOffer.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<SpecialOfferTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SpecialOffer>(
      where: where?.call(SpecialOffer.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SpecialOffer] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<SpecialOfferTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SpecialOffer>(
      where: where(SpecialOffer.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class SpecialOfferAttachRowRepository {
  const SpecialOfferAttachRowRepository._();

  /// Creates a relation between the given [SpecialOffer] and [Product]
  /// by setting the [SpecialOffer]'s foreign key `productId` to refer to the [Product].
  Future<void> product(
    _i1.DatabaseSession session,
    SpecialOffer specialOffer,
    _i2.Product product, {
    _i1.Transaction? transaction,
  }) async {
    if (specialOffer.id == null) {
      throw ArgumentError.notNull('specialOffer.id');
    }
    if (product.id == null) {
      throw ArgumentError.notNull('product.id');
    }

    var $specialOffer = specialOffer.copyWith(productId: product.id);
    await session.db.updateRow<SpecialOffer>(
      $specialOffer,
      columns: [SpecialOffer.t.productId],
      transaction: transaction,
    );
  }
}
