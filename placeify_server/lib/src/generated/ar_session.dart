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
import 'user.dart' as _i2;
import 'product.dart' as _i3;
import 'package:placeify_server/src/generated/protocol.dart' as _i4;

/// AR visualization session for a product.
abstract class ARSession
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ARSession._({
    this.id,
    required this.userId,
    this.user,
    required this.productId,
    this.product,
    DateTime? startedAt,
    this.deviceInfo,
    this.snapshotUrl,
  }) : startedAt = startedAt ?? DateTime.now();

  factory ARSession({
    int? id,
    required _i1.UuidValue userId,
    _i2.User? user,
    required int productId,
    _i3.Product? product,
    DateTime? startedAt,
    String? deviceInfo,
    String? snapshotUrl,
  }) = _ARSessionImpl;

  factory ARSession.fromJson(Map<String, dynamic> jsonSerialization) {
    return ARSession(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      user: jsonSerialization['user'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.User>(jsonSerialization['user']),
      productId: jsonSerialization['productId'] as int,
      product: jsonSerialization['product'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.Product>(
              jsonSerialization['product'],
            ),
      startedAt: jsonSerialization['startedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['startedAt']),
      deviceInfo: jsonSerialization['deviceInfo'] as String?,
      snapshotUrl: jsonSerialization['snapshotUrl'] as String?,
    );
  }

  static final t = ARSessionTable();

  static const db = ARSessionRepository._();

  @override
  int? id;

  _i1.UuidValue userId;

  _i2.User? user;

  int productId;

  _i3.Product? product;

  DateTime startedAt;

  String? deviceInfo;

  String? snapshotUrl;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ARSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ARSession copyWith({
    int? id,
    _i1.UuidValue? userId,
    _i2.User? user,
    int? productId,
    _i3.Product? product,
    DateTime? startedAt,
    String? deviceInfo,
    String? snapshotUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ARSession',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      if (user != null) 'user': user?.toJson(),
      'productId': productId,
      if (product != null) 'product': product?.toJson(),
      'startedAt': startedAt.toJson(),
      if (deviceInfo != null) 'deviceInfo': deviceInfo,
      if (snapshotUrl != null) 'snapshotUrl': snapshotUrl,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ARSession',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      if (user != null) 'user': user?.toJsonForProtocol(),
      'productId': productId,
      if (product != null) 'product': product?.toJsonForProtocol(),
      'startedAt': startedAt.toJson(),
      if (deviceInfo != null) 'deviceInfo': deviceInfo,
      if (snapshotUrl != null) 'snapshotUrl': snapshotUrl,
    };
  }

  static ARSessionInclude include({
    _i2.UserInclude? user,
    _i3.ProductInclude? product,
  }) {
    return ARSessionInclude._(
      user: user,
      product: product,
    );
  }

  static ARSessionIncludeList includeList({
    _i1.WhereExpressionBuilder<ARSessionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ARSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ARSessionTable>? orderByList,
    ARSessionInclude? include,
  }) {
    return ARSessionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ARSession.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ARSession.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ARSessionImpl extends ARSession {
  _ARSessionImpl({
    int? id,
    required _i1.UuidValue userId,
    _i2.User? user,
    required int productId,
    _i3.Product? product,
    DateTime? startedAt,
    String? deviceInfo,
    String? snapshotUrl,
  }) : super._(
         id: id,
         userId: userId,
         user: user,
         productId: productId,
         product: product,
         startedAt: startedAt,
         deviceInfo: deviceInfo,
         snapshotUrl: snapshotUrl,
       );

  /// Returns a shallow copy of this [ARSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ARSession copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    Object? user = _Undefined,
    int? productId,
    Object? product = _Undefined,
    DateTime? startedAt,
    Object? deviceInfo = _Undefined,
    Object? snapshotUrl = _Undefined,
  }) {
    return ARSession(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _i2.User? ? user : this.user?.copyWith(),
      productId: productId ?? this.productId,
      product: product is _i3.Product? ? product : this.product?.copyWith(),
      startedAt: startedAt ?? this.startedAt,
      deviceInfo: deviceInfo is String? ? deviceInfo : this.deviceInfo,
      snapshotUrl: snapshotUrl is String? ? snapshotUrl : this.snapshotUrl,
    );
  }
}

class ARSessionUpdateTable extends _i1.UpdateTable<ARSessionTable> {
  ARSessionUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<int, int> productId(int value) => _i1.ColumnValue(
    table.productId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> startedAt(DateTime value) =>
      _i1.ColumnValue(
        table.startedAt,
        value,
      );

  _i1.ColumnValue<String, String> deviceInfo(String? value) => _i1.ColumnValue(
    table.deviceInfo,
    value,
  );

  _i1.ColumnValue<String, String> snapshotUrl(String? value) => _i1.ColumnValue(
    table.snapshotUrl,
    value,
  );
}

class ARSessionTable extends _i1.Table<int?> {
  ARSessionTable({super.tableRelation}) : super(tableName: 'ar_session') {
    updateTable = ARSessionUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    productId = _i1.ColumnInt(
      'productId',
      this,
    );
    startedAt = _i1.ColumnDateTime(
      'startedAt',
      this,
      hasDefault: true,
    );
    deviceInfo = _i1.ColumnString(
      'deviceInfo',
      this,
    );
    snapshotUrl = _i1.ColumnString(
      'snapshotUrl',
      this,
    );
  }

  late final ARSessionUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  _i2.UserTable? _user;

  late final _i1.ColumnInt productId;

  _i3.ProductTable? _product;

  late final _i1.ColumnDateTime startedAt;

  late final _i1.ColumnString deviceInfo;

  late final _i1.ColumnString snapshotUrl;

  _i2.UserTable get user {
    if (_user != null) return _user!;
    _user = _i1.createRelationTable(
      relationFieldName: 'user',
      field: ARSession.t.userId,
      foreignField: _i2.User.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.UserTable(tableRelation: foreignTableRelation),
    );
    return _user!;
  }

  _i3.ProductTable get product {
    if (_product != null) return _product!;
    _product = _i1.createRelationTable(
      relationFieldName: 'product',
      field: ARSession.t.productId,
      foreignField: _i3.Product.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.ProductTable(tableRelation: foreignTableRelation),
    );
    return _product!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    productId,
    startedAt,
    deviceInfo,
    snapshotUrl,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'user') {
      return user;
    }
    if (relationField == 'product') {
      return product;
    }
    return null;
  }
}

class ARSessionInclude extends _i1.IncludeObject {
  ARSessionInclude._({
    _i2.UserInclude? user,
    _i3.ProductInclude? product,
  }) {
    _user = user;
    _product = product;
  }

  _i2.UserInclude? _user;

  _i3.ProductInclude? _product;

  @override
  Map<String, _i1.Include?> get includes => {
    'user': _user,
    'product': _product,
  };

  @override
  _i1.Table<int?> get table => ARSession.t;
}

class ARSessionIncludeList extends _i1.IncludeList {
  ARSessionIncludeList._({
    _i1.WhereExpressionBuilder<ARSessionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ARSession.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ARSession.t;
}

class ARSessionRepository {
  const ARSessionRepository._();

  final attachRow = const ARSessionAttachRowRepository._();

  /// Returns a list of [ARSession]s matching the given query parameters.
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
  Future<List<ARSession>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ARSessionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ARSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ARSessionTable>? orderByList,
    _i1.Transaction? transaction,
    ARSessionInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ARSession>(
      where: where?.call(ARSession.t),
      orderBy: orderBy?.call(ARSession.t),
      orderByList: orderByList?.call(ARSession.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ARSession] matching the given query parameters.
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
  Future<ARSession?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ARSessionTable>? where,
    int? offset,
    _i1.OrderByBuilder<ARSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ARSessionTable>? orderByList,
    _i1.Transaction? transaction,
    ARSessionInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ARSession>(
      where: where?.call(ARSession.t),
      orderBy: orderBy?.call(ARSession.t),
      orderByList: orderByList?.call(ARSession.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ARSession] by its [id] or null if no such row exists.
  Future<ARSession?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    ARSessionInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ARSession>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ARSession]s in the list and returns the inserted rows.
  ///
  /// The returned [ARSession]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<ARSession>> insert(
    _i1.DatabaseSession session,
    List<ARSession> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ARSession>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ARSession] and returns the inserted row.
  ///
  /// The returned [ARSession] will have its `id` field set.
  Future<ARSession> insertRow(
    _i1.DatabaseSession session,
    ARSession row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ARSession>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ARSession]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ARSession>> update(
    _i1.DatabaseSession session,
    List<ARSession> rows, {
    _i1.ColumnSelections<ARSessionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ARSession>(
      rows,
      columns: columns?.call(ARSession.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ARSession]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ARSession> updateRow(
    _i1.DatabaseSession session,
    ARSession row, {
    _i1.ColumnSelections<ARSessionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ARSession>(
      row,
      columns: columns?.call(ARSession.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ARSession] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ARSession?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<ARSessionUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ARSession>(
      id,
      columnValues: columnValues(ARSession.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ARSession]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ARSession>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ARSessionUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ARSessionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ARSessionTable>? orderBy,
    _i1.OrderByListBuilder<ARSessionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ARSession>(
      columnValues: columnValues(ARSession.t.updateTable),
      where: where(ARSession.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ARSession.t),
      orderByList: orderByList?.call(ARSession.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ARSession]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ARSession>> delete(
    _i1.DatabaseSession session,
    List<ARSession> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ARSession>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ARSession].
  Future<ARSession> deleteRow(
    _i1.DatabaseSession session,
    ARSession row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ARSession>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ARSession>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ARSessionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ARSession>(
      where: where(ARSession.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ARSessionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ARSession>(
      where: where?.call(ARSession.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ARSession] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ARSessionTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ARSession>(
      where: where(ARSession.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class ARSessionAttachRowRepository {
  const ARSessionAttachRowRepository._();

  /// Creates a relation between the given [ARSession] and [User]
  /// by setting the [ARSession]'s foreign key `userId` to refer to the [User].
  Future<void> user(
    _i1.DatabaseSession session,
    ARSession aRSession,
    _i2.User user, {
    _i1.Transaction? transaction,
  }) async {
    if (aRSession.id == null) {
      throw ArgumentError.notNull('aRSession.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $aRSession = aRSession.copyWith(userId: user.id);
    await session.db.updateRow<ARSession>(
      $aRSession,
      columns: [ARSession.t.userId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [ARSession] and [Product]
  /// by setting the [ARSession]'s foreign key `productId` to refer to the [Product].
  Future<void> product(
    _i1.DatabaseSession session,
    ARSession aRSession,
    _i3.Product product, {
    _i1.Transaction? transaction,
  }) async {
    if (aRSession.id == null) {
      throw ArgumentError.notNull('aRSession.id');
    }
    if (product.id == null) {
      throw ArgumentError.notNull('product.id');
    }

    var $aRSession = aRSession.copyWith(productId: product.id);
    await session.db.updateRow<ARSession>(
      $aRSession,
      columns: [ARSession.t.productId],
      transaction: transaction,
    );
  }
}
