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
import 'request_status.dart' as _i2;
import 'user.dart' as _i3;
import 'vendor.dart' as _i4;
import 'product.dart' as _i5;
import 'package:placeify_server/src/generated/protocol.dart' as _i6;

/// Customization request or design idea shared by a user with a vendor.
abstract class CustomizationRequest
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = CustomizationRequestTable();

  static const db = CustomizationRequestRepository._();

  @override
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

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CustomizationRequest',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      if (user != null) 'user': user?.toJsonForProtocol(),
      'vendorId': vendorId.toJson(),
      if (vendor != null) 'vendor': vendor?.toJsonForProtocol(),
      'productId': productId,
      if (product != null) 'product': product?.toJsonForProtocol(),
      'description': description,
      if (attachmentUrl != null) 'attachmentUrl': attachmentUrl,
      'status': status.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static CustomizationRequestInclude include({
    _i3.UserInclude? user,
    _i4.VendorInclude? vendor,
    _i5.ProductInclude? product,
  }) {
    return CustomizationRequestInclude._(
      user: user,
      vendor: vendor,
      product: product,
    );
  }

  static CustomizationRequestIncludeList includeList({
    _i1.WhereExpressionBuilder<CustomizationRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CustomizationRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CustomizationRequestTable>? orderByList,
    CustomizationRequestInclude? include,
  }) {
    return CustomizationRequestIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CustomizationRequest.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CustomizationRequest.t),
      include: include,
    );
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

class CustomizationRequestUpdateTable
    extends _i1.UpdateTable<CustomizationRequestTable> {
  CustomizationRequestUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> vendorId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.vendorId,
        value,
      );

  _i1.ColumnValue<int, int> productId(int value) => _i1.ColumnValue(
    table.productId,
    value,
  );

  _i1.ColumnValue<String, String> description(String value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> attachmentUrl(String? value) =>
      _i1.ColumnValue(
        table.attachmentUrl,
        value,
      );

  _i1.ColumnValue<_i2.RequestStatus, _i2.RequestStatus> status(
    _i2.RequestStatus value,
  ) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class CustomizationRequestTable extends _i1.Table<int?> {
  CustomizationRequestTable({super.tableRelation})
    : super(tableName: 'customization_request') {
    updateTable = CustomizationRequestUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    vendorId = _i1.ColumnUuid(
      'vendorId',
      this,
    );
    productId = _i1.ColumnInt(
      'productId',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    attachmentUrl = _i1.ColumnString(
      'attachmentUrl',
      this,
    );
    status = _i1.ColumnEnum(
      'status',
      this,
      _i1.EnumSerialization.byName,
      hasDefault: true,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final CustomizationRequestUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  _i3.UserTable? _user;

  late final _i1.ColumnUuid vendorId;

  _i4.VendorTable? _vendor;

  late final _i1.ColumnInt productId;

  _i5.ProductTable? _product;

  late final _i1.ColumnString description;

  late final _i1.ColumnString attachmentUrl;

  late final _i1.ColumnEnum<_i2.RequestStatus> status;

  late final _i1.ColumnDateTime createdAt;

  _i3.UserTable get user {
    if (_user != null) return _user!;
    _user = _i1.createRelationTable(
      relationFieldName: 'user',
      field: CustomizationRequest.t.userId,
      foreignField: _i3.User.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.UserTable(tableRelation: foreignTableRelation),
    );
    return _user!;
  }

  _i4.VendorTable get vendor {
    if (_vendor != null) return _vendor!;
    _vendor = _i1.createRelationTable(
      relationFieldName: 'vendor',
      field: CustomizationRequest.t.vendorId,
      foreignField: _i4.Vendor.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.VendorTable(tableRelation: foreignTableRelation),
    );
    return _vendor!;
  }

  _i5.ProductTable get product {
    if (_product != null) return _product!;
    _product = _i1.createRelationTable(
      relationFieldName: 'product',
      field: CustomizationRequest.t.productId,
      foreignField: _i5.Product.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i5.ProductTable(tableRelation: foreignTableRelation),
    );
    return _product!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    vendorId,
    productId,
    description,
    attachmentUrl,
    status,
    createdAt,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'user') {
      return user;
    }
    if (relationField == 'vendor') {
      return vendor;
    }
    if (relationField == 'product') {
      return product;
    }
    return null;
  }
}

class CustomizationRequestInclude extends _i1.IncludeObject {
  CustomizationRequestInclude._({
    _i3.UserInclude? user,
    _i4.VendorInclude? vendor,
    _i5.ProductInclude? product,
  }) {
    _user = user;
    _vendor = vendor;
    _product = product;
  }

  _i3.UserInclude? _user;

  _i4.VendorInclude? _vendor;

  _i5.ProductInclude? _product;

  @override
  Map<String, _i1.Include?> get includes => {
    'user': _user,
    'vendor': _vendor,
    'product': _product,
  };

  @override
  _i1.Table<int?> get table => CustomizationRequest.t;
}

class CustomizationRequestIncludeList extends _i1.IncludeList {
  CustomizationRequestIncludeList._({
    _i1.WhereExpressionBuilder<CustomizationRequestTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CustomizationRequest.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CustomizationRequest.t;
}

class CustomizationRequestRepository {
  const CustomizationRequestRepository._();

  final attachRow = const CustomizationRequestAttachRowRepository._();

  /// Returns a list of [CustomizationRequest]s matching the given query parameters.
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
  Future<List<CustomizationRequest>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CustomizationRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CustomizationRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CustomizationRequestTable>? orderByList,
    _i1.Transaction? transaction,
    CustomizationRequestInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CustomizationRequest>(
      where: where?.call(CustomizationRequest.t),
      orderBy: orderBy?.call(CustomizationRequest.t),
      orderByList: orderByList?.call(CustomizationRequest.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CustomizationRequest] matching the given query parameters.
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
  Future<CustomizationRequest?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CustomizationRequestTable>? where,
    int? offset,
    _i1.OrderByBuilder<CustomizationRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CustomizationRequestTable>? orderByList,
    _i1.Transaction? transaction,
    CustomizationRequestInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CustomizationRequest>(
      where: where?.call(CustomizationRequest.t),
      orderBy: orderBy?.call(CustomizationRequest.t),
      orderByList: orderByList?.call(CustomizationRequest.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CustomizationRequest] by its [id] or null if no such row exists.
  Future<CustomizationRequest?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    CustomizationRequestInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CustomizationRequest>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CustomizationRequest]s in the list and returns the inserted rows.
  ///
  /// The returned [CustomizationRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<CustomizationRequest>> insert(
    _i1.DatabaseSession session,
    List<CustomizationRequest> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<CustomizationRequest>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [CustomizationRequest] and returns the inserted row.
  ///
  /// The returned [CustomizationRequest] will have its `id` field set.
  Future<CustomizationRequest> insertRow(
    _i1.DatabaseSession session,
    CustomizationRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CustomizationRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CustomizationRequest]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CustomizationRequest>> update(
    _i1.DatabaseSession session,
    List<CustomizationRequest> rows, {
    _i1.ColumnSelections<CustomizationRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CustomizationRequest>(
      rows,
      columns: columns?.call(CustomizationRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CustomizationRequest]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CustomizationRequest> updateRow(
    _i1.DatabaseSession session,
    CustomizationRequest row, {
    _i1.ColumnSelections<CustomizationRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CustomizationRequest>(
      row,
      columns: columns?.call(CustomizationRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CustomizationRequest] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CustomizationRequest?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<CustomizationRequestUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CustomizationRequest>(
      id,
      columnValues: columnValues(CustomizationRequest.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CustomizationRequest]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CustomizationRequest>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<CustomizationRequestUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<CustomizationRequestTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CustomizationRequestTable>? orderBy,
    _i1.OrderByListBuilder<CustomizationRequestTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CustomizationRequest>(
      columnValues: columnValues(CustomizationRequest.t.updateTable),
      where: where(CustomizationRequest.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CustomizationRequest.t),
      orderByList: orderByList?.call(CustomizationRequest.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CustomizationRequest]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CustomizationRequest>> delete(
    _i1.DatabaseSession session,
    List<CustomizationRequest> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CustomizationRequest>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CustomizationRequest].
  Future<CustomizationRequest> deleteRow(
    _i1.DatabaseSession session,
    CustomizationRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CustomizationRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CustomizationRequest>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CustomizationRequestTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CustomizationRequest>(
      where: where(CustomizationRequest.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CustomizationRequestTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CustomizationRequest>(
      where: where?.call(CustomizationRequest.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CustomizationRequest] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CustomizationRequestTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CustomizationRequest>(
      where: where(CustomizationRequest.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class CustomizationRequestAttachRowRepository {
  const CustomizationRequestAttachRowRepository._();

  /// Creates a relation between the given [CustomizationRequest] and [User]
  /// by setting the [CustomizationRequest]'s foreign key `userId` to refer to the [User].
  Future<void> user(
    _i1.DatabaseSession session,
    CustomizationRequest customizationRequest,
    _i3.User user, {
    _i1.Transaction? transaction,
  }) async {
    if (customizationRequest.id == null) {
      throw ArgumentError.notNull('customizationRequest.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $customizationRequest = customizationRequest.copyWith(userId: user.id);
    await session.db.updateRow<CustomizationRequest>(
      $customizationRequest,
      columns: [CustomizationRequest.t.userId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [CustomizationRequest] and [Vendor]
  /// by setting the [CustomizationRequest]'s foreign key `vendorId` to refer to the [Vendor].
  Future<void> vendor(
    _i1.DatabaseSession session,
    CustomizationRequest customizationRequest,
    _i4.Vendor vendor, {
    _i1.Transaction? transaction,
  }) async {
    if (customizationRequest.id == null) {
      throw ArgumentError.notNull('customizationRequest.id');
    }
    if (vendor.id == null) {
      throw ArgumentError.notNull('vendor.id');
    }

    var $customizationRequest = customizationRequest.copyWith(
      vendorId: vendor.id,
    );
    await session.db.updateRow<CustomizationRequest>(
      $customizationRequest,
      columns: [CustomizationRequest.t.vendorId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [CustomizationRequest] and [Product]
  /// by setting the [CustomizationRequest]'s foreign key `productId` to refer to the [Product].
  Future<void> product(
    _i1.DatabaseSession session,
    CustomizationRequest customizationRequest,
    _i5.Product product, {
    _i1.Transaction? transaction,
  }) async {
    if (customizationRequest.id == null) {
      throw ArgumentError.notNull('customizationRequest.id');
    }
    if (product.id == null) {
      throw ArgumentError.notNull('product.id');
    }

    var $customizationRequest = customizationRequest.copyWith(
      productId: product.id,
    );
    await session.db.updateRow<CustomizationRequest>(
      $customizationRequest,
      columns: [CustomizationRequest.t.productId],
      transaction: transaction,
    );
  }
}
