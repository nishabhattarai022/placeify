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
import 'payment_transaction_status.dart' as _i2;
import 'order.dart' as _i3;
import 'vendor.dart' as _i4;
import 'package:placeify_server/src/generated/protocol.dart' as _i5;

/// Per-vendor payment allocation for a multi-vendor order.
abstract class OrderVendorPayment
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  OrderVendorPayment._({
    this.id,
    required this.orderId,
    this.order,
    required this.vendorId,
    this.vendor,
    required this.amount,
    _i2.PaymentTransactionStatus? status,
    this.note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : status = status ?? _i2.PaymentTransactionStatus.pending,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory OrderVendorPayment({
    int? id,
    required int orderId,
    _i3.Order? order,
    required _i1.UuidValue vendorId,
    _i4.Vendor? vendor,
    required double amount,
    _i2.PaymentTransactionStatus? status,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _OrderVendorPaymentImpl;

  factory OrderVendorPayment.fromJson(Map<String, dynamic> jsonSerialization) {
    return OrderVendorPayment(
      id: jsonSerialization['id'] as int?,
      orderId: jsonSerialization['orderId'] as int,
      order: jsonSerialization['order'] == null
          ? null
          : _i5.Protocol().deserialize<_i3.Order>(jsonSerialization['order']),
      vendorId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['vendorId'],
      ),
      vendor: jsonSerialization['vendor'] == null
          ? null
          : _i5.Protocol().deserialize<_i4.Vendor>(jsonSerialization['vendor']),
      amount: (jsonSerialization['amount'] as num).toDouble(),
      status: jsonSerialization['status'] == null
          ? null
          : _i2.PaymentTransactionStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      note: jsonSerialization['note'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = OrderVendorPaymentTable();

  static const db = OrderVendorPaymentRepository._();

  @override
  int? id;

  int orderId;

  _i3.Order? order;

  _i1.UuidValue vendorId;

  _i4.Vendor? vendor;

  double amount;

  _i2.PaymentTransactionStatus status;

  String? note;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [OrderVendorPayment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OrderVendorPayment copyWith({
    int? id,
    int? orderId,
    _i3.Order? order,
    _i1.UuidValue? vendorId,
    _i4.Vendor? vendor,
    double? amount,
    _i2.PaymentTransactionStatus? status,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OrderVendorPayment',
      if (id != null) 'id': id,
      'orderId': orderId,
      if (order != null) 'order': order?.toJson(),
      'vendorId': vendorId.toJson(),
      if (vendor != null) 'vendor': vendor?.toJson(),
      'amount': amount,
      'status': status.toJson(),
      if (note != null) 'note': note,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OrderVendorPayment',
      if (id != null) 'id': id,
      'orderId': orderId,
      if (order != null) 'order': order?.toJsonForProtocol(),
      'vendorId': vendorId.toJson(),
      if (vendor != null) 'vendor': vendor?.toJsonForProtocol(),
      'amount': amount,
      'status': status.toJson(),
      if (note != null) 'note': note,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static OrderVendorPaymentInclude include({
    _i3.OrderInclude? order,
    _i4.VendorInclude? vendor,
  }) {
    return OrderVendorPaymentInclude._(
      order: order,
      vendor: vendor,
    );
  }

  static OrderVendorPaymentIncludeList includeList({
    _i1.WhereExpressionBuilder<OrderVendorPaymentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrderVendorPaymentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrderVendorPaymentTable>? orderByList,
    OrderVendorPaymentInclude? include,
  }) {
    return OrderVendorPaymentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OrderVendorPayment.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(OrderVendorPayment.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrderVendorPaymentImpl extends OrderVendorPayment {
  _OrderVendorPaymentImpl({
    int? id,
    required int orderId,
    _i3.Order? order,
    required _i1.UuidValue vendorId,
    _i4.Vendor? vendor,
    required double amount,
    _i2.PaymentTransactionStatus? status,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         orderId: orderId,
         order: order,
         vendorId: vendorId,
         vendor: vendor,
         amount: amount,
         status: status,
         note: note,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [OrderVendorPayment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OrderVendorPayment copyWith({
    Object? id = _Undefined,
    int? orderId,
    Object? order = _Undefined,
    _i1.UuidValue? vendorId,
    Object? vendor = _Undefined,
    double? amount,
    _i2.PaymentTransactionStatus? status,
    Object? note = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderVendorPayment(
      id: id is int? ? id : this.id,
      orderId: orderId ?? this.orderId,
      order: order is _i3.Order? ? order : this.order?.copyWith(),
      vendorId: vendorId ?? this.vendorId,
      vendor: vendor is _i4.Vendor? ? vendor : this.vendor?.copyWith(),
      amount: amount ?? this.amount,
      status: status ?? this.status,
      note: note is String? ? note : this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class OrderVendorPaymentUpdateTable
    extends _i1.UpdateTable<OrderVendorPaymentTable> {
  OrderVendorPaymentUpdateTable(super.table);

  _i1.ColumnValue<int, int> orderId(int value) => _i1.ColumnValue(
    table.orderId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> vendorId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.vendorId,
        value,
      );

  _i1.ColumnValue<double, double> amount(double value) => _i1.ColumnValue(
    table.amount,
    value,
  );

  _i1.ColumnValue<_i2.PaymentTransactionStatus, _i2.PaymentTransactionStatus>
  status(_i2.PaymentTransactionStatus value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> note(String? value) => _i1.ColumnValue(
    table.note,
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

class OrderVendorPaymentTable extends _i1.Table<int?> {
  OrderVendorPaymentTable({super.tableRelation})
    : super(tableName: 'order_vendor_payment') {
    updateTable = OrderVendorPaymentUpdateTable(this);
    orderId = _i1.ColumnInt(
      'orderId',
      this,
    );
    vendorId = _i1.ColumnUuid(
      'vendorId',
      this,
    );
    amount = _i1.ColumnDouble(
      'amount',
      this,
    );
    status = _i1.ColumnEnum(
      'status',
      this,
      _i1.EnumSerialization.byName,
      hasDefault: true,
    );
    note = _i1.ColumnString(
      'note',
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

  late final OrderVendorPaymentUpdateTable updateTable;

  late final _i1.ColumnInt orderId;

  _i3.OrderTable? _order;

  late final _i1.ColumnUuid vendorId;

  _i4.VendorTable? _vendor;

  late final _i1.ColumnDouble amount;

  late final _i1.ColumnEnum<_i2.PaymentTransactionStatus> status;

  late final _i1.ColumnString note;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  _i3.OrderTable get order {
    if (_order != null) return _order!;
    _order = _i1.createRelationTable(
      relationFieldName: 'order',
      field: OrderVendorPayment.t.orderId,
      foreignField: _i3.Order.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.OrderTable(tableRelation: foreignTableRelation),
    );
    return _order!;
  }

  _i4.VendorTable get vendor {
    if (_vendor != null) return _vendor!;
    _vendor = _i1.createRelationTable(
      relationFieldName: 'vendor',
      field: OrderVendorPayment.t.vendorId,
      foreignField: _i4.Vendor.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.VendorTable(tableRelation: foreignTableRelation),
    );
    return _vendor!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    orderId,
    vendorId,
    amount,
    status,
    note,
    createdAt,
    updatedAt,
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

class OrderVendorPaymentInclude extends _i1.IncludeObject {
  OrderVendorPaymentInclude._({
    _i3.OrderInclude? order,
    _i4.VendorInclude? vendor,
  }) {
    _order = order;
    _vendor = vendor;
  }

  _i3.OrderInclude? _order;

  _i4.VendorInclude? _vendor;

  @override
  Map<String, _i1.Include?> get includes => {
    'order': _order,
    'vendor': _vendor,
  };

  @override
  _i1.Table<int?> get table => OrderVendorPayment.t;
}

class OrderVendorPaymentIncludeList extends _i1.IncludeList {
  OrderVendorPaymentIncludeList._({
    _i1.WhereExpressionBuilder<OrderVendorPaymentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(OrderVendorPayment.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => OrderVendorPayment.t;
}

class OrderVendorPaymentRepository {
  const OrderVendorPaymentRepository._();

  final attachRow = const OrderVendorPaymentAttachRowRepository._();

  /// Returns a list of [OrderVendorPayment]s matching the given query parameters.
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
  Future<List<OrderVendorPayment>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OrderVendorPaymentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrderVendorPaymentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrderVendorPaymentTable>? orderByList,
    _i1.Transaction? transaction,
    OrderVendorPaymentInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<OrderVendorPayment>(
      where: where?.call(OrderVendorPayment.t),
      orderBy: orderBy?.call(OrderVendorPayment.t),
      orderByList: orderByList?.call(OrderVendorPayment.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [OrderVendorPayment] matching the given query parameters.
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
  Future<OrderVendorPayment?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OrderVendorPaymentTable>? where,
    int? offset,
    _i1.OrderByBuilder<OrderVendorPaymentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrderVendorPaymentTable>? orderByList,
    _i1.Transaction? transaction,
    OrderVendorPaymentInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<OrderVendorPayment>(
      where: where?.call(OrderVendorPayment.t),
      orderBy: orderBy?.call(OrderVendorPayment.t),
      orderByList: orderByList?.call(OrderVendorPayment.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [OrderVendorPayment] by its [id] or null if no such row exists.
  Future<OrderVendorPayment?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    OrderVendorPaymentInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<OrderVendorPayment>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [OrderVendorPayment]s in the list and returns the inserted rows.
  ///
  /// The returned [OrderVendorPayment]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<OrderVendorPayment>> insert(
    _i1.DatabaseSession session,
    List<OrderVendorPayment> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<OrderVendorPayment>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [OrderVendorPayment] and returns the inserted row.
  ///
  /// The returned [OrderVendorPayment] will have its `id` field set.
  Future<OrderVendorPayment> insertRow(
    _i1.DatabaseSession session,
    OrderVendorPayment row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<OrderVendorPayment>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [OrderVendorPayment]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<OrderVendorPayment>> update(
    _i1.DatabaseSession session,
    List<OrderVendorPayment> rows, {
    _i1.ColumnSelections<OrderVendorPaymentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<OrderVendorPayment>(
      rows,
      columns: columns?.call(OrderVendorPayment.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OrderVendorPayment]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<OrderVendorPayment> updateRow(
    _i1.DatabaseSession session,
    OrderVendorPayment row, {
    _i1.ColumnSelections<OrderVendorPaymentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<OrderVendorPayment>(
      row,
      columns: columns?.call(OrderVendorPayment.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OrderVendorPayment] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<OrderVendorPayment?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<OrderVendorPaymentUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<OrderVendorPayment>(
      id,
      columnValues: columnValues(OrderVendorPayment.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [OrderVendorPayment]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<OrderVendorPayment>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<OrderVendorPaymentUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<OrderVendorPaymentTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrderVendorPaymentTable>? orderBy,
    _i1.OrderByListBuilder<OrderVendorPaymentTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<OrderVendorPayment>(
      columnValues: columnValues(OrderVendorPayment.t.updateTable),
      where: where(OrderVendorPayment.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OrderVendorPayment.t),
      orderByList: orderByList?.call(OrderVendorPayment.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [OrderVendorPayment]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<OrderVendorPayment>> delete(
    _i1.DatabaseSession session,
    List<OrderVendorPayment> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<OrderVendorPayment>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [OrderVendorPayment].
  Future<OrderVendorPayment> deleteRow(
    _i1.DatabaseSession session,
    OrderVendorPayment row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<OrderVendorPayment>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<OrderVendorPayment>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<OrderVendorPaymentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<OrderVendorPayment>(
      where: where(OrderVendorPayment.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OrderVendorPaymentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<OrderVendorPayment>(
      where: where?.call(OrderVendorPayment.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [OrderVendorPayment] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<OrderVendorPaymentTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<OrderVendorPayment>(
      where: where(OrderVendorPayment.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class OrderVendorPaymentAttachRowRepository {
  const OrderVendorPaymentAttachRowRepository._();

  /// Creates a relation between the given [OrderVendorPayment] and [Order]
  /// by setting the [OrderVendorPayment]'s foreign key `orderId` to refer to the [Order].
  Future<void> order(
    _i1.DatabaseSession session,
    OrderVendorPayment orderVendorPayment,
    _i3.Order order, {
    _i1.Transaction? transaction,
  }) async {
    if (orderVendorPayment.id == null) {
      throw ArgumentError.notNull('orderVendorPayment.id');
    }
    if (order.id == null) {
      throw ArgumentError.notNull('order.id');
    }

    var $orderVendorPayment = orderVendorPayment.copyWith(orderId: order.id);
    await session.db.updateRow<OrderVendorPayment>(
      $orderVendorPayment,
      columns: [OrderVendorPayment.t.orderId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [OrderVendorPayment] and [Vendor]
  /// by setting the [OrderVendorPayment]'s foreign key `vendorId` to refer to the [Vendor].
  Future<void> vendor(
    _i1.DatabaseSession session,
    OrderVendorPayment orderVendorPayment,
    _i4.Vendor vendor, {
    _i1.Transaction? transaction,
  }) async {
    if (orderVendorPayment.id == null) {
      throw ArgumentError.notNull('orderVendorPayment.id');
    }
    if (vendor.id == null) {
      throw ArgumentError.notNull('vendor.id');
    }

    var $orderVendorPayment = orderVendorPayment.copyWith(vendorId: vendor.id);
    await session.db.updateRow<OrderVendorPayment>(
      $orderVendorPayment,
      columns: [OrderVendorPayment.t.vendorId],
      transaction: transaction,
    );
  }
}
