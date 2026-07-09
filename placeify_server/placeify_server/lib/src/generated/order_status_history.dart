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
import 'order.dart' as _i2;
import 'order_status_history_type.dart' as _i3;
import 'user.dart' as _i4;
import 'package:placeify_server/src/generated/protocol.dart' as _i5;

/// Audit log for order, delivery, and payment status changes.
abstract class OrderStatusHistory
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  OrderStatusHistory._({
    this.id,
    required this.orderId,
    this.order,
    this.previousStatus,
    required this.newStatus,
    required this.statusType,
    this.changedById,
    this.changedBy,
    DateTime? changedAt,
    this.note,
  }) : changedAt = changedAt ?? DateTime.now();

  factory OrderStatusHistory({
    int? id,
    required int orderId,
    _i2.Order? order,
    String? previousStatus,
    required String newStatus,
    required _i3.OrderStatusHistoryType statusType,
    _i1.UuidValue? changedById,
    _i4.User? changedBy,
    DateTime? changedAt,
    String? note,
  }) = _OrderStatusHistoryImpl;

  factory OrderStatusHistory.fromJson(Map<String, dynamic> jsonSerialization) {
    return OrderStatusHistory(
      id: jsonSerialization['id'] as int?,
      orderId: jsonSerialization['orderId'] as int,
      order: jsonSerialization['order'] == null
          ? null
          : _i5.Protocol().deserialize<_i2.Order>(jsonSerialization['order']),
      previousStatus: jsonSerialization['previousStatus'] as String?,
      newStatus: jsonSerialization['newStatus'] as String,
      statusType: _i3.OrderStatusHistoryType.fromJson(
        (jsonSerialization['statusType'] as String),
      ),
      changedById: jsonSerialization['changedById'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['changedById'],
            ),
      changedBy: jsonSerialization['changedBy'] == null
          ? null
          : _i5.Protocol().deserialize<_i4.User>(
              jsonSerialization['changedBy'],
            ),
      changedAt: jsonSerialization['changedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['changedAt']),
      note: jsonSerialization['note'] as String?,
    );
  }

  static final t = OrderStatusHistoryTable();

  static const db = OrderStatusHistoryRepository._();

  @override
  int? id;

  int orderId;

  _i2.Order? order;

  String? previousStatus;

  String newStatus;

  _i3.OrderStatusHistoryType statusType;

  _i1.UuidValue? changedById;

  _i4.User? changedBy;

  DateTime changedAt;

  String? note;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [OrderStatusHistory]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OrderStatusHistory copyWith({
    int? id,
    int? orderId,
    _i2.Order? order,
    String? previousStatus,
    String? newStatus,
    _i3.OrderStatusHistoryType? statusType,
    _i1.UuidValue? changedById,
    _i4.User? changedBy,
    DateTime? changedAt,
    String? note,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OrderStatusHistory',
      if (id != null) 'id': id,
      'orderId': orderId,
      if (order != null) 'order': order?.toJson(),
      if (previousStatus != null) 'previousStatus': previousStatus,
      'newStatus': newStatus,
      'statusType': statusType.toJson(),
      if (changedById != null) 'changedById': changedById?.toJson(),
      if (changedBy != null) 'changedBy': changedBy?.toJson(),
      'changedAt': changedAt.toJson(),
      if (note != null) 'note': note,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OrderStatusHistory',
      if (id != null) 'id': id,
      'orderId': orderId,
      if (order != null) 'order': order?.toJsonForProtocol(),
      if (previousStatus != null) 'previousStatus': previousStatus,
      'newStatus': newStatus,
      'statusType': statusType.toJson(),
      if (changedById != null) 'changedById': changedById?.toJson(),
      if (changedBy != null) 'changedBy': changedBy?.toJsonForProtocol(),
      'changedAt': changedAt.toJson(),
      if (note != null) 'note': note,
    };
  }

  static OrderStatusHistoryInclude include({
    _i2.OrderInclude? order,
    _i4.UserInclude? changedBy,
  }) {
    return OrderStatusHistoryInclude._(
      order: order,
      changedBy: changedBy,
    );
  }

  static OrderStatusHistoryIncludeList includeList({
    _i1.WhereExpressionBuilder<OrderStatusHistoryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrderStatusHistoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrderStatusHistoryTable>? orderByList,
    OrderStatusHistoryInclude? include,
  }) {
    return OrderStatusHistoryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OrderStatusHistory.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(OrderStatusHistory.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrderStatusHistoryImpl extends OrderStatusHistory {
  _OrderStatusHistoryImpl({
    int? id,
    required int orderId,
    _i2.Order? order,
    String? previousStatus,
    required String newStatus,
    required _i3.OrderStatusHistoryType statusType,
    _i1.UuidValue? changedById,
    _i4.User? changedBy,
    DateTime? changedAt,
    String? note,
  }) : super._(
         id: id,
         orderId: orderId,
         order: order,
         previousStatus: previousStatus,
         newStatus: newStatus,
         statusType: statusType,
         changedById: changedById,
         changedBy: changedBy,
         changedAt: changedAt,
         note: note,
       );

  /// Returns a shallow copy of this [OrderStatusHistory]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OrderStatusHistory copyWith({
    Object? id = _Undefined,
    int? orderId,
    Object? order = _Undefined,
    Object? previousStatus = _Undefined,
    String? newStatus,
    _i3.OrderStatusHistoryType? statusType,
    Object? changedById = _Undefined,
    Object? changedBy = _Undefined,
    DateTime? changedAt,
    Object? note = _Undefined,
  }) {
    return OrderStatusHistory(
      id: id is int? ? id : this.id,
      orderId: orderId ?? this.orderId,
      order: order is _i2.Order? ? order : this.order?.copyWith(),
      previousStatus: previousStatus is String?
          ? previousStatus
          : this.previousStatus,
      newStatus: newStatus ?? this.newStatus,
      statusType: statusType ?? this.statusType,
      changedById: changedById is _i1.UuidValue?
          ? changedById
          : this.changedById,
      changedBy: changedBy is _i4.User?
          ? changedBy
          : this.changedBy?.copyWith(),
      changedAt: changedAt ?? this.changedAt,
      note: note is String? ? note : this.note,
    );
  }
}

class OrderStatusHistoryUpdateTable
    extends _i1.UpdateTable<OrderStatusHistoryTable> {
  OrderStatusHistoryUpdateTable(super.table);

  _i1.ColumnValue<int, int> orderId(int value) => _i1.ColumnValue(
    table.orderId,
    value,
  );

  _i1.ColumnValue<String, String> previousStatus(String? value) =>
      _i1.ColumnValue(
        table.previousStatus,
        value,
      );

  _i1.ColumnValue<String, String> newStatus(String value) => _i1.ColumnValue(
    table.newStatus,
    value,
  );

  _i1.ColumnValue<_i3.OrderStatusHistoryType, _i3.OrderStatusHistoryType>
  statusType(_i3.OrderStatusHistoryType value) => _i1.ColumnValue(
    table.statusType,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> changedById(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.changedById,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> changedAt(DateTime value) =>
      _i1.ColumnValue(
        table.changedAt,
        value,
      );

  _i1.ColumnValue<String, String> note(String? value) => _i1.ColumnValue(
    table.note,
    value,
  );
}

class OrderStatusHistoryTable extends _i1.Table<int?> {
  OrderStatusHistoryTable({super.tableRelation})
    : super(tableName: 'order_status_history') {
    updateTable = OrderStatusHistoryUpdateTable(this);
    orderId = _i1.ColumnInt(
      'orderId',
      this,
    );
    previousStatus = _i1.ColumnString(
      'previousStatus',
      this,
    );
    newStatus = _i1.ColumnString(
      'newStatus',
      this,
    );
    statusType = _i1.ColumnEnum(
      'statusType',
      this,
      _i1.EnumSerialization.byName,
    );
    changedById = _i1.ColumnUuid(
      'changedById',
      this,
    );
    changedAt = _i1.ColumnDateTime(
      'changedAt',
      this,
      hasDefault: true,
    );
    note = _i1.ColumnString(
      'note',
      this,
    );
  }

  late final OrderStatusHistoryUpdateTable updateTable;

  late final _i1.ColumnInt orderId;

  _i2.OrderTable? _order;

  late final _i1.ColumnString previousStatus;

  late final _i1.ColumnString newStatus;

  late final _i1.ColumnEnum<_i3.OrderStatusHistoryType> statusType;

  late final _i1.ColumnUuid changedById;

  _i4.UserTable? _changedBy;

  late final _i1.ColumnDateTime changedAt;

  late final _i1.ColumnString note;

  _i2.OrderTable get order {
    if (_order != null) return _order!;
    _order = _i1.createRelationTable(
      relationFieldName: 'order',
      field: OrderStatusHistory.t.orderId,
      foreignField: _i2.Order.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.OrderTable(tableRelation: foreignTableRelation),
    );
    return _order!;
  }

  _i4.UserTable get changedBy {
    if (_changedBy != null) return _changedBy!;
    _changedBy = _i1.createRelationTable(
      relationFieldName: 'changedBy',
      field: OrderStatusHistory.t.changedById,
      foreignField: _i4.User.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.UserTable(tableRelation: foreignTableRelation),
    );
    return _changedBy!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    orderId,
    previousStatus,
    newStatus,
    statusType,
    changedById,
    changedAt,
    note,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'order') {
      return order;
    }
    if (relationField == 'changedBy') {
      return changedBy;
    }
    return null;
  }
}

class OrderStatusHistoryInclude extends _i1.IncludeObject {
  OrderStatusHistoryInclude._({
    _i2.OrderInclude? order,
    _i4.UserInclude? changedBy,
  }) {
    _order = order;
    _changedBy = changedBy;
  }

  _i2.OrderInclude? _order;

  _i4.UserInclude? _changedBy;

  @override
  Map<String, _i1.Include?> get includes => {
    'order': _order,
    'changedBy': _changedBy,
  };

  @override
  _i1.Table<int?> get table => OrderStatusHistory.t;
}

class OrderStatusHistoryIncludeList extends _i1.IncludeList {
  OrderStatusHistoryIncludeList._({
    _i1.WhereExpressionBuilder<OrderStatusHistoryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(OrderStatusHistory.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => OrderStatusHistory.t;
}

class OrderStatusHistoryRepository {
  const OrderStatusHistoryRepository._();

  final attachRow = const OrderStatusHistoryAttachRowRepository._();

  final detachRow = const OrderStatusHistoryDetachRowRepository._();

  /// Returns a list of [OrderStatusHistory]s matching the given query parameters.
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
  Future<List<OrderStatusHistory>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OrderStatusHistoryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrderStatusHistoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrderStatusHistoryTable>? orderByList,
    _i1.Transaction? transaction,
    OrderStatusHistoryInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<OrderStatusHistory>(
      where: where?.call(OrderStatusHistory.t),
      orderBy: orderBy?.call(OrderStatusHistory.t),
      orderByList: orderByList?.call(OrderStatusHistory.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [OrderStatusHistory] matching the given query parameters.
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
  Future<OrderStatusHistory?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OrderStatusHistoryTable>? where,
    int? offset,
    _i1.OrderByBuilder<OrderStatusHistoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrderStatusHistoryTable>? orderByList,
    _i1.Transaction? transaction,
    OrderStatusHistoryInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<OrderStatusHistory>(
      where: where?.call(OrderStatusHistory.t),
      orderBy: orderBy?.call(OrderStatusHistory.t),
      orderByList: orderByList?.call(OrderStatusHistory.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [OrderStatusHistory] by its [id] or null if no such row exists.
  Future<OrderStatusHistory?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    OrderStatusHistoryInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<OrderStatusHistory>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [OrderStatusHistory]s in the list and returns the inserted rows.
  ///
  /// The returned [OrderStatusHistory]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<OrderStatusHistory>> insert(
    _i1.DatabaseSession session,
    List<OrderStatusHistory> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<OrderStatusHistory>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [OrderStatusHistory] and returns the inserted row.
  ///
  /// The returned [OrderStatusHistory] will have its `id` field set.
  Future<OrderStatusHistory> insertRow(
    _i1.DatabaseSession session,
    OrderStatusHistory row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<OrderStatusHistory>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [OrderStatusHistory]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<OrderStatusHistory>> update(
    _i1.DatabaseSession session,
    List<OrderStatusHistory> rows, {
    _i1.ColumnSelections<OrderStatusHistoryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<OrderStatusHistory>(
      rows,
      columns: columns?.call(OrderStatusHistory.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OrderStatusHistory]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<OrderStatusHistory> updateRow(
    _i1.DatabaseSession session,
    OrderStatusHistory row, {
    _i1.ColumnSelections<OrderStatusHistoryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<OrderStatusHistory>(
      row,
      columns: columns?.call(OrderStatusHistory.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OrderStatusHistory] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<OrderStatusHistory?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<OrderStatusHistoryUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<OrderStatusHistory>(
      id,
      columnValues: columnValues(OrderStatusHistory.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [OrderStatusHistory]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<OrderStatusHistory>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<OrderStatusHistoryUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<OrderStatusHistoryTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrderStatusHistoryTable>? orderBy,
    _i1.OrderByListBuilder<OrderStatusHistoryTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<OrderStatusHistory>(
      columnValues: columnValues(OrderStatusHistory.t.updateTable),
      where: where(OrderStatusHistory.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OrderStatusHistory.t),
      orderByList: orderByList?.call(OrderStatusHistory.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [OrderStatusHistory]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<OrderStatusHistory>> delete(
    _i1.DatabaseSession session,
    List<OrderStatusHistory> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<OrderStatusHistory>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [OrderStatusHistory].
  Future<OrderStatusHistory> deleteRow(
    _i1.DatabaseSession session,
    OrderStatusHistory row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<OrderStatusHistory>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<OrderStatusHistory>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<OrderStatusHistoryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<OrderStatusHistory>(
      where: where(OrderStatusHistory.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OrderStatusHistoryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<OrderStatusHistory>(
      where: where?.call(OrderStatusHistory.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [OrderStatusHistory] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<OrderStatusHistoryTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<OrderStatusHistory>(
      where: where(OrderStatusHistory.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class OrderStatusHistoryAttachRowRepository {
  const OrderStatusHistoryAttachRowRepository._();

  /// Creates a relation between the given [OrderStatusHistory] and [Order]
  /// by setting the [OrderStatusHistory]'s foreign key `orderId` to refer to the [Order].
  Future<void> order(
    _i1.DatabaseSession session,
    OrderStatusHistory orderStatusHistory,
    _i2.Order order, {
    _i1.Transaction? transaction,
  }) async {
    if (orderStatusHistory.id == null) {
      throw ArgumentError.notNull('orderStatusHistory.id');
    }
    if (order.id == null) {
      throw ArgumentError.notNull('order.id');
    }

    var $orderStatusHistory = orderStatusHistory.copyWith(orderId: order.id);
    await session.db.updateRow<OrderStatusHistory>(
      $orderStatusHistory,
      columns: [OrderStatusHistory.t.orderId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [OrderStatusHistory] and [User]
  /// by setting the [OrderStatusHistory]'s foreign key `changedById` to refer to the [User].
  Future<void> changedBy(
    _i1.DatabaseSession session,
    OrderStatusHistory orderStatusHistory,
    _i4.User changedBy, {
    _i1.Transaction? transaction,
  }) async {
    if (orderStatusHistory.id == null) {
      throw ArgumentError.notNull('orderStatusHistory.id');
    }
    if (changedBy.id == null) {
      throw ArgumentError.notNull('changedBy.id');
    }

    var $orderStatusHistory = orderStatusHistory.copyWith(
      changedById: changedBy.id,
    );
    await session.db.updateRow<OrderStatusHistory>(
      $orderStatusHistory,
      columns: [OrderStatusHistory.t.changedById],
      transaction: transaction,
    );
  }
}

class OrderStatusHistoryDetachRowRepository {
  const OrderStatusHistoryDetachRowRepository._();

  /// Detaches the relation between this [OrderStatusHistory] and the [User] set in `changedBy`
  /// by setting the [OrderStatusHistory]'s foreign key `changedById` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> changedBy(
    _i1.DatabaseSession session,
    OrderStatusHistory orderStatusHistory, {
    _i1.Transaction? transaction,
  }) async {
    if (orderStatusHistory.id == null) {
      throw ArgumentError.notNull('orderStatusHistory.id');
    }

    var $orderStatusHistory = orderStatusHistory.copyWith(changedById: null);
    await session.db.updateRow<OrderStatusHistory>(
      $orderStatusHistory,
      columns: [OrderStatusHistory.t.changedById],
      transaction: transaction,
    );
  }
}
