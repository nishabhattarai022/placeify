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
import 'vendor.dart' as _i3;
import 'delivery_stage.dart' as _i4;
import 'package:placeify_server/src/generated/protocol.dart' as _i5;

/// Vendor-posted delivery milestone for a customer order.
abstract class OrderDeliveryUpdate
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  OrderDeliveryUpdate._({
    this.id,
    required this.orderId,
    this.order,
    required this.vendorId,
    this.vendor,
    required this.stage,
    this.note,
    this.photoUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory OrderDeliveryUpdate({
    int? id,
    required int orderId,
    _i2.Order? order,
    required _i1.UuidValue vendorId,
    _i3.Vendor? vendor,
    required _i4.DeliveryStage stage,
    String? note,
    String? photoUrl,
    DateTime? createdAt,
  }) = _OrderDeliveryUpdateImpl;

  factory OrderDeliveryUpdate.fromJson(Map<String, dynamic> jsonSerialization) {
    return OrderDeliveryUpdate(
      id: jsonSerialization['id'] as int?,
      orderId: jsonSerialization['orderId'] as int,
      order: jsonSerialization['order'] == null
          ? null
          : _i5.Protocol().deserialize<_i2.Order>(jsonSerialization['order']),
      vendorId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['vendorId'],
      ),
      vendor: jsonSerialization['vendor'] == null
          ? null
          : _i5.Protocol().deserialize<_i3.Vendor>(jsonSerialization['vendor']),
      stage: _i4.DeliveryStage.fromJson((jsonSerialization['stage'] as String)),
      note: jsonSerialization['note'] as String?,
      photoUrl: jsonSerialization['photoUrl'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = OrderDeliveryUpdateTable();

  static const db = OrderDeliveryUpdateRepository._();

  @override
  int? id;

  int orderId;

  _i2.Order? order;

  _i1.UuidValue vendorId;

  _i3.Vendor? vendor;

  _i4.DeliveryStage stage;

  String? note;

  String? photoUrl;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [OrderDeliveryUpdate]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OrderDeliveryUpdate copyWith({
    int? id,
    int? orderId,
    _i2.Order? order,
    _i1.UuidValue? vendorId,
    _i3.Vendor? vendor,
    _i4.DeliveryStage? stage,
    String? note,
    String? photoUrl,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OrderDeliveryUpdate',
      if (id != null) 'id': id,
      'orderId': orderId,
      if (order != null) 'order': order?.toJson(),
      'vendorId': vendorId.toJson(),
      if (vendor != null) 'vendor': vendor?.toJson(),
      'stage': stage.toJson(),
      if (note != null) 'note': note,
      if (photoUrl != null) 'photoUrl': photoUrl,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OrderDeliveryUpdate',
      if (id != null) 'id': id,
      'orderId': orderId,
      if (order != null) 'order': order?.toJsonForProtocol(),
      'vendorId': vendorId.toJson(),
      if (vendor != null) 'vendor': vendor?.toJsonForProtocol(),
      'stage': stage.toJson(),
      if (note != null) 'note': note,
      if (photoUrl != null) 'photoUrl': photoUrl,
      'createdAt': createdAt.toJson(),
    };
  }

  static OrderDeliveryUpdateInclude include({
    _i2.OrderInclude? order,
    _i3.VendorInclude? vendor,
  }) {
    return OrderDeliveryUpdateInclude._(
      order: order,
      vendor: vendor,
    );
  }

  static OrderDeliveryUpdateIncludeList includeList({
    _i1.WhereExpressionBuilder<OrderDeliveryUpdateTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrderDeliveryUpdateTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrderDeliveryUpdateTable>? orderByList,
    OrderDeliveryUpdateInclude? include,
  }) {
    return OrderDeliveryUpdateIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OrderDeliveryUpdate.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(OrderDeliveryUpdate.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrderDeliveryUpdateImpl extends OrderDeliveryUpdate {
  _OrderDeliveryUpdateImpl({
    int? id,
    required int orderId,
    _i2.Order? order,
    required _i1.UuidValue vendorId,
    _i3.Vendor? vendor,
    required _i4.DeliveryStage stage,
    String? note,
    String? photoUrl,
    DateTime? createdAt,
  }) : super._(
         id: id,
         orderId: orderId,
         order: order,
         vendorId: vendorId,
         vendor: vendor,
         stage: stage,
         note: note,
         photoUrl: photoUrl,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [OrderDeliveryUpdate]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OrderDeliveryUpdate copyWith({
    Object? id = _Undefined,
    int? orderId,
    Object? order = _Undefined,
    _i1.UuidValue? vendorId,
    Object? vendor = _Undefined,
    _i4.DeliveryStage? stage,
    Object? note = _Undefined,
    Object? photoUrl = _Undefined,
    DateTime? createdAt,
  }) {
    return OrderDeliveryUpdate(
      id: id is int? ? id : this.id,
      orderId: orderId ?? this.orderId,
      order: order is _i2.Order? ? order : this.order?.copyWith(),
      vendorId: vendorId ?? this.vendorId,
      vendor: vendor is _i3.Vendor? ? vendor : this.vendor?.copyWith(),
      stage: stage ?? this.stage,
      note: note is String? ? note : this.note,
      photoUrl: photoUrl is String? ? photoUrl : this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class OrderDeliveryUpdateUpdateTable
    extends _i1.UpdateTable<OrderDeliveryUpdateTable> {
  OrderDeliveryUpdateUpdateTable(super.table);

  _i1.ColumnValue<int, int> orderId(int value) => _i1.ColumnValue(
    table.orderId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> vendorId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.vendorId,
        value,
      );

  _i1.ColumnValue<_i4.DeliveryStage, _i4.DeliveryStage> stage(
    _i4.DeliveryStage value,
  ) => _i1.ColumnValue(
    table.stage,
    value,
  );

  _i1.ColumnValue<String, String> note(String? value) => _i1.ColumnValue(
    table.note,
    value,
  );

  _i1.ColumnValue<String, String> photoUrl(String? value) => _i1.ColumnValue(
    table.photoUrl,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class OrderDeliveryUpdateTable extends _i1.Table<int?> {
  OrderDeliveryUpdateTable({super.tableRelation})
    : super(tableName: 'order_delivery_update') {
    updateTable = OrderDeliveryUpdateUpdateTable(this);
    orderId = _i1.ColumnInt(
      'orderId',
      this,
    );
    vendorId = _i1.ColumnUuid(
      'vendorId',
      this,
    );
    stage = _i1.ColumnEnum(
      'stage',
      this,
      _i1.EnumSerialization.byName,
    );
    note = _i1.ColumnString(
      'note',
      this,
    );
    photoUrl = _i1.ColumnString(
      'photoUrl',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final OrderDeliveryUpdateUpdateTable updateTable;

  late final _i1.ColumnInt orderId;

  _i2.OrderTable? _order;

  late final _i1.ColumnUuid vendorId;

  _i3.VendorTable? _vendor;

  late final _i1.ColumnEnum<_i4.DeliveryStage> stage;

  late final _i1.ColumnString note;

  late final _i1.ColumnString photoUrl;

  late final _i1.ColumnDateTime createdAt;

  _i2.OrderTable get order {
    if (_order != null) return _order!;
    _order = _i1.createRelationTable(
      relationFieldName: 'order',
      field: OrderDeliveryUpdate.t.orderId,
      foreignField: _i2.Order.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.OrderTable(tableRelation: foreignTableRelation),
    );
    return _order!;
  }

  _i3.VendorTable get vendor {
    if (_vendor != null) return _vendor!;
    _vendor = _i1.createRelationTable(
      relationFieldName: 'vendor',
      field: OrderDeliveryUpdate.t.vendorId,
      foreignField: _i3.Vendor.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.VendorTable(tableRelation: foreignTableRelation),
    );
    return _vendor!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    orderId,
    vendorId,
    stage,
    note,
    photoUrl,
    createdAt,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'order') {
      return order;
    }
    if (relationField == 'vendor') {
      return vendor;
    }
    return null;
  }
}

class OrderDeliveryUpdateInclude extends _i1.IncludeObject {
  OrderDeliveryUpdateInclude._({
    _i2.OrderInclude? order,
    _i3.VendorInclude? vendor,
  }) {
    _order = order;
    _vendor = vendor;
  }

  _i2.OrderInclude? _order;

  _i3.VendorInclude? _vendor;

  @override
  Map<String, _i1.Include?> get includes => {
    'order': _order,
    'vendor': _vendor,
  };

  @override
  _i1.Table<int?> get table => OrderDeliveryUpdate.t;
}

class OrderDeliveryUpdateIncludeList extends _i1.IncludeList {
  OrderDeliveryUpdateIncludeList._({
    _i1.WhereExpressionBuilder<OrderDeliveryUpdateTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(OrderDeliveryUpdate.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => OrderDeliveryUpdate.t;
}

class OrderDeliveryUpdateRepository {
  const OrderDeliveryUpdateRepository._();

  final attachRow = const OrderDeliveryUpdateAttachRowRepository._();

  /// Returns a list of [OrderDeliveryUpdate]s matching the given query parameters.
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
  Future<List<OrderDeliveryUpdate>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OrderDeliveryUpdateTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrderDeliveryUpdateTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrderDeliveryUpdateTable>? orderByList,
    _i1.Transaction? transaction,
    OrderDeliveryUpdateInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<OrderDeliveryUpdate>(
      where: where?.call(OrderDeliveryUpdate.t),
      orderBy: orderBy?.call(OrderDeliveryUpdate.t),
      orderByList: orderByList?.call(OrderDeliveryUpdate.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [OrderDeliveryUpdate] matching the given query parameters.
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
  Future<OrderDeliveryUpdate?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OrderDeliveryUpdateTable>? where,
    int? offset,
    _i1.OrderByBuilder<OrderDeliveryUpdateTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrderDeliveryUpdateTable>? orderByList,
    _i1.Transaction? transaction,
    OrderDeliveryUpdateInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<OrderDeliveryUpdate>(
      where: where?.call(OrderDeliveryUpdate.t),
      orderBy: orderBy?.call(OrderDeliveryUpdate.t),
      orderByList: orderByList?.call(OrderDeliveryUpdate.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [OrderDeliveryUpdate] by its [id] or null if no such row exists.
  Future<OrderDeliveryUpdate?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    OrderDeliveryUpdateInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<OrderDeliveryUpdate>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [OrderDeliveryUpdate]s in the list and returns the inserted rows.
  ///
  /// The returned [OrderDeliveryUpdate]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<OrderDeliveryUpdate>> insert(
    _i1.DatabaseSession session,
    List<OrderDeliveryUpdate> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<OrderDeliveryUpdate>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [OrderDeliveryUpdate] and returns the inserted row.
  ///
  /// The returned [OrderDeliveryUpdate] will have its `id` field set.
  Future<OrderDeliveryUpdate> insertRow(
    _i1.DatabaseSession session,
    OrderDeliveryUpdate row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<OrderDeliveryUpdate>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [OrderDeliveryUpdate]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<OrderDeliveryUpdate>> update(
    _i1.DatabaseSession session,
    List<OrderDeliveryUpdate> rows, {
    _i1.ColumnSelections<OrderDeliveryUpdateTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<OrderDeliveryUpdate>(
      rows,
      columns: columns?.call(OrderDeliveryUpdate.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OrderDeliveryUpdate]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<OrderDeliveryUpdate> updateRow(
    _i1.DatabaseSession session,
    OrderDeliveryUpdate row, {
    _i1.ColumnSelections<OrderDeliveryUpdateTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<OrderDeliveryUpdate>(
      row,
      columns: columns?.call(OrderDeliveryUpdate.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OrderDeliveryUpdate] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<OrderDeliveryUpdate?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<OrderDeliveryUpdateUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<OrderDeliveryUpdate>(
      id,
      columnValues: columnValues(OrderDeliveryUpdate.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [OrderDeliveryUpdate]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<OrderDeliveryUpdate>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<OrderDeliveryUpdateUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<OrderDeliveryUpdateTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrderDeliveryUpdateTable>? orderBy,
    _i1.OrderByListBuilder<OrderDeliveryUpdateTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<OrderDeliveryUpdate>(
      columnValues: columnValues(OrderDeliveryUpdate.t.updateTable),
      where: where(OrderDeliveryUpdate.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OrderDeliveryUpdate.t),
      orderByList: orderByList?.call(OrderDeliveryUpdate.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [OrderDeliveryUpdate]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<OrderDeliveryUpdate>> delete(
    _i1.DatabaseSession session,
    List<OrderDeliveryUpdate> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<OrderDeliveryUpdate>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [OrderDeliveryUpdate].
  Future<OrderDeliveryUpdate> deleteRow(
    _i1.DatabaseSession session,
    OrderDeliveryUpdate row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<OrderDeliveryUpdate>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<OrderDeliveryUpdate>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<OrderDeliveryUpdateTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<OrderDeliveryUpdate>(
      where: where(OrderDeliveryUpdate.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OrderDeliveryUpdateTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<OrderDeliveryUpdate>(
      where: where?.call(OrderDeliveryUpdate.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [OrderDeliveryUpdate] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<OrderDeliveryUpdateTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<OrderDeliveryUpdate>(
      where: where(OrderDeliveryUpdate.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class OrderDeliveryUpdateAttachRowRepository {
  const OrderDeliveryUpdateAttachRowRepository._();

  /// Creates a relation between the given [OrderDeliveryUpdate] and [Order]
  /// by setting the [OrderDeliveryUpdate]'s foreign key `orderId` to refer to the [Order].
  Future<void> order(
    _i1.DatabaseSession session,
    OrderDeliveryUpdate orderDeliveryUpdate,
    _i2.Order order, {
    _i1.Transaction? transaction,
  }) async {
    if (orderDeliveryUpdate.id == null) {
      throw ArgumentError.notNull('orderDeliveryUpdate.id');
    }
    if (order.id == null) {
      throw ArgumentError.notNull('order.id');
    }

    var $orderDeliveryUpdate = orderDeliveryUpdate.copyWith(orderId: order.id);
    await session.db.updateRow<OrderDeliveryUpdate>(
      $orderDeliveryUpdate,
      columns: [OrderDeliveryUpdate.t.orderId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [OrderDeliveryUpdate] and [Vendor]
  /// by setting the [OrderDeliveryUpdate]'s foreign key `vendorId` to refer to the [Vendor].
  Future<void> vendor(
    _i1.DatabaseSession session,
    OrderDeliveryUpdate orderDeliveryUpdate,
    _i3.Vendor vendor, {
    _i1.Transaction? transaction,
  }) async {
    if (orderDeliveryUpdate.id == null) {
      throw ArgumentError.notNull('orderDeliveryUpdate.id');
    }
    if (vendor.id == null) {
      throw ArgumentError.notNull('vendor.id');
    }

    var $orderDeliveryUpdate = orderDeliveryUpdate.copyWith(
      vendorId: vendor.id,
    );
    await session.db.updateRow<OrderDeliveryUpdate>(
      $orderDeliveryUpdate,
      columns: [OrderDeliveryUpdate.t.vendorId],
      transaction: transaction,
    );
  }
}
