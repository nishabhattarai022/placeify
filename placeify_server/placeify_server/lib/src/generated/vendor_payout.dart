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
import 'vendor_payout_status.dart' as _i2;
import 'vendor.dart' as _i3;
import 'package:placeify_server/src/generated/protocol.dart' as _i4;

/// Vendor settlement payout request.
abstract class VendorPayout
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  VendorPayout._({
    this.id,
    required this.vendorId,
    this.vendor,
    required this.amount,
    _i2.VendorPayoutStatus? status,
    required this.payoutMethod,
    required this.reference,
    this.scheduledAt,
    this.paidAt,
    DateTime? createdAt,
  }) : status = status ?? _i2.VendorPayoutStatus.pending,
       createdAt = createdAt ?? DateTime.now();

  factory VendorPayout({
    int? id,
    required _i1.UuidValue vendorId,
    _i3.Vendor? vendor,
    required double amount,
    _i2.VendorPayoutStatus? status,
    required String payoutMethod,
    required String reference,
    DateTime? scheduledAt,
    DateTime? paidAt,
    DateTime? createdAt,
  }) = _VendorPayoutImpl;

  factory VendorPayout.fromJson(Map<String, dynamic> jsonSerialization) {
    return VendorPayout(
      id: jsonSerialization['id'] as int?,
      vendorId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['vendorId'],
      ),
      vendor: jsonSerialization['vendor'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.Vendor>(jsonSerialization['vendor']),
      amount: (jsonSerialization['amount'] as num).toDouble(),
      status: jsonSerialization['status'] == null
          ? null
          : _i2.VendorPayoutStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      payoutMethod: jsonSerialization['payoutMethod'] as String,
      reference: jsonSerialization['reference'] as String,
      scheduledAt: jsonSerialization['scheduledAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['scheduledAt'],
            ),
      paidAt: jsonSerialization['paidAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['paidAt']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = VendorPayoutTable();

  static const db = VendorPayoutRepository._();

  @override
  int? id;

  _i1.UuidValue vendorId;

  _i3.Vendor? vendor;

  double amount;

  _i2.VendorPayoutStatus status;

  String payoutMethod;

  String reference;

  DateTime? scheduledAt;

  DateTime? paidAt;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [VendorPayout]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VendorPayout copyWith({
    int? id,
    _i1.UuidValue? vendorId,
    _i3.Vendor? vendor,
    double? amount,
    _i2.VendorPayoutStatus? status,
    String? payoutMethod,
    String? reference,
    DateTime? scheduledAt,
    DateTime? paidAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VendorPayout',
      if (id != null) 'id': id,
      'vendorId': vendorId.toJson(),
      if (vendor != null) 'vendor': vendor?.toJson(),
      'amount': amount,
      'status': status.toJson(),
      'payoutMethod': payoutMethod,
      'reference': reference,
      if (scheduledAt != null) 'scheduledAt': scheduledAt?.toJson(),
      if (paidAt != null) 'paidAt': paidAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VendorPayout',
      if (id != null) 'id': id,
      'vendorId': vendorId.toJson(),
      if (vendor != null) 'vendor': vendor?.toJsonForProtocol(),
      'amount': amount,
      'status': status.toJson(),
      'payoutMethod': payoutMethod,
      'reference': reference,
      if (scheduledAt != null) 'scheduledAt': scheduledAt?.toJson(),
      if (paidAt != null) 'paidAt': paidAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static VendorPayoutInclude include({_i3.VendorInclude? vendor}) {
    return VendorPayoutInclude._(vendor: vendor);
  }

  static VendorPayoutIncludeList includeList({
    _i1.WhereExpressionBuilder<VendorPayoutTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<VendorPayoutTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<VendorPayoutTable>? orderByList,
    VendorPayoutInclude? include,
  }) {
    return VendorPayoutIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(VendorPayout.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(VendorPayout.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VendorPayoutImpl extends VendorPayout {
  _VendorPayoutImpl({
    int? id,
    required _i1.UuidValue vendorId,
    _i3.Vendor? vendor,
    required double amount,
    _i2.VendorPayoutStatus? status,
    required String payoutMethod,
    required String reference,
    DateTime? scheduledAt,
    DateTime? paidAt,
    DateTime? createdAt,
  }) : super._(
         id: id,
         vendorId: vendorId,
         vendor: vendor,
         amount: amount,
         status: status,
         payoutMethod: payoutMethod,
         reference: reference,
         scheduledAt: scheduledAt,
         paidAt: paidAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [VendorPayout]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VendorPayout copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? vendorId,
    Object? vendor = _Undefined,
    double? amount,
    _i2.VendorPayoutStatus? status,
    String? payoutMethod,
    String? reference,
    Object? scheduledAt = _Undefined,
    Object? paidAt = _Undefined,
    DateTime? createdAt,
  }) {
    return VendorPayout(
      id: id is int? ? id : this.id,
      vendorId: vendorId ?? this.vendorId,
      vendor: vendor is _i3.Vendor? ? vendor : this.vendor?.copyWith(),
      amount: amount ?? this.amount,
      status: status ?? this.status,
      payoutMethod: payoutMethod ?? this.payoutMethod,
      reference: reference ?? this.reference,
      scheduledAt: scheduledAt is DateTime? ? scheduledAt : this.scheduledAt,
      paidAt: paidAt is DateTime? ? paidAt : this.paidAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class VendorPayoutUpdateTable extends _i1.UpdateTable<VendorPayoutTable> {
  VendorPayoutUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> vendorId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.vendorId,
        value,
      );

  _i1.ColumnValue<double, double> amount(double value) => _i1.ColumnValue(
    table.amount,
    value,
  );

  _i1.ColumnValue<_i2.VendorPayoutStatus, _i2.VendorPayoutStatus> status(
    _i2.VendorPayoutStatus value,
  ) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> payoutMethod(String value) => _i1.ColumnValue(
    table.payoutMethod,
    value,
  );

  _i1.ColumnValue<String, String> reference(String value) => _i1.ColumnValue(
    table.reference,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> scheduledAt(DateTime? value) =>
      _i1.ColumnValue(
        table.scheduledAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> paidAt(DateTime? value) =>
      _i1.ColumnValue(
        table.paidAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class VendorPayoutTable extends _i1.Table<int?> {
  VendorPayoutTable({super.tableRelation}) : super(tableName: 'vendor_payout') {
    updateTable = VendorPayoutUpdateTable(this);
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
    payoutMethod = _i1.ColumnString(
      'payoutMethod',
      this,
    );
    reference = _i1.ColumnString(
      'reference',
      this,
    );
    scheduledAt = _i1.ColumnDateTime(
      'scheduledAt',
      this,
    );
    paidAt = _i1.ColumnDateTime(
      'paidAt',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final VendorPayoutUpdateTable updateTable;

  late final _i1.ColumnUuid vendorId;

  _i3.VendorTable? _vendor;

  late final _i1.ColumnDouble amount;

  late final _i1.ColumnEnum<_i2.VendorPayoutStatus> status;

  late final _i1.ColumnString payoutMethod;

  late final _i1.ColumnString reference;

  late final _i1.ColumnDateTime scheduledAt;

  late final _i1.ColumnDateTime paidAt;

  late final _i1.ColumnDateTime createdAt;

  _i3.VendorTable get vendor {
    if (_vendor != null) return _vendor!;
    _vendor = _i1.createRelationTable(
      relationFieldName: 'vendor',
      field: VendorPayout.t.vendorId,
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
    vendorId,
    amount,
    status,
    payoutMethod,
    reference,
    scheduledAt,
    paidAt,
    createdAt,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'vendor') {
      return vendor;
    }
    return null;
  }
}

class VendorPayoutInclude extends _i1.IncludeObject {
  VendorPayoutInclude._({_i3.VendorInclude? vendor}) {
    _vendor = vendor;
  }

  _i3.VendorInclude? _vendor;

  @override
  Map<String, _i1.Include?> get includes => {'vendor': _vendor};

  @override
  _i1.Table<int?> get table => VendorPayout.t;
}

class VendorPayoutIncludeList extends _i1.IncludeList {
  VendorPayoutIncludeList._({
    _i1.WhereExpressionBuilder<VendorPayoutTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(VendorPayout.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => VendorPayout.t;
}

class VendorPayoutRepository {
  const VendorPayoutRepository._();

  final attachRow = const VendorPayoutAttachRowRepository._();

  /// Returns a list of [VendorPayout]s matching the given query parameters.
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
  Future<List<VendorPayout>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<VendorPayoutTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<VendorPayoutTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<VendorPayoutTable>? orderByList,
    _i1.Transaction? transaction,
    VendorPayoutInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<VendorPayout>(
      where: where?.call(VendorPayout.t),
      orderBy: orderBy?.call(VendorPayout.t),
      orderByList: orderByList?.call(VendorPayout.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [VendorPayout] matching the given query parameters.
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
  Future<VendorPayout?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<VendorPayoutTable>? where,
    int? offset,
    _i1.OrderByBuilder<VendorPayoutTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<VendorPayoutTable>? orderByList,
    _i1.Transaction? transaction,
    VendorPayoutInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<VendorPayout>(
      where: where?.call(VendorPayout.t),
      orderBy: orderBy?.call(VendorPayout.t),
      orderByList: orderByList?.call(VendorPayout.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [VendorPayout] by its [id] or null if no such row exists.
  Future<VendorPayout?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    VendorPayoutInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<VendorPayout>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [VendorPayout]s in the list and returns the inserted rows.
  ///
  /// The returned [VendorPayout]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<VendorPayout>> insert(
    _i1.DatabaseSession session,
    List<VendorPayout> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<VendorPayout>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [VendorPayout] and returns the inserted row.
  ///
  /// The returned [VendorPayout] will have its `id` field set.
  Future<VendorPayout> insertRow(
    _i1.DatabaseSession session,
    VendorPayout row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<VendorPayout>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [VendorPayout]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<VendorPayout>> update(
    _i1.DatabaseSession session,
    List<VendorPayout> rows, {
    _i1.ColumnSelections<VendorPayoutTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<VendorPayout>(
      rows,
      columns: columns?.call(VendorPayout.t),
      transaction: transaction,
    );
  }

  /// Updates a single [VendorPayout]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<VendorPayout> updateRow(
    _i1.DatabaseSession session,
    VendorPayout row, {
    _i1.ColumnSelections<VendorPayoutTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<VendorPayout>(
      row,
      columns: columns?.call(VendorPayout.t),
      transaction: transaction,
    );
  }

  /// Updates a single [VendorPayout] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<VendorPayout?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<VendorPayoutUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<VendorPayout>(
      id,
      columnValues: columnValues(VendorPayout.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [VendorPayout]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<VendorPayout>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<VendorPayoutUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<VendorPayoutTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<VendorPayoutTable>? orderBy,
    _i1.OrderByListBuilder<VendorPayoutTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<VendorPayout>(
      columnValues: columnValues(VendorPayout.t.updateTable),
      where: where(VendorPayout.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(VendorPayout.t),
      orderByList: orderByList?.call(VendorPayout.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [VendorPayout]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<VendorPayout>> delete(
    _i1.DatabaseSession session,
    List<VendorPayout> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<VendorPayout>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [VendorPayout].
  Future<VendorPayout> deleteRow(
    _i1.DatabaseSession session,
    VendorPayout row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<VendorPayout>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<VendorPayout>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<VendorPayoutTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<VendorPayout>(
      where: where(VendorPayout.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<VendorPayoutTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<VendorPayout>(
      where: where?.call(VendorPayout.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [VendorPayout] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<VendorPayoutTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<VendorPayout>(
      where: where(VendorPayout.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class VendorPayoutAttachRowRepository {
  const VendorPayoutAttachRowRepository._();

  /// Creates a relation between the given [VendorPayout] and [Vendor]
  /// by setting the [VendorPayout]'s foreign key `vendorId` to refer to the [Vendor].
  Future<void> vendor(
    _i1.DatabaseSession session,
    VendorPayout vendorPayout,
    _i3.Vendor vendor, {
    _i1.Transaction? transaction,
  }) async {
    if (vendorPayout.id == null) {
      throw ArgumentError.notNull('vendorPayout.id');
    }
    if (vendor.id == null) {
      throw ArgumentError.notNull('vendor.id');
    }

    var $vendorPayout = vendorPayout.copyWith(vendorId: vendor.id);
    await session.db.updateRow<VendorPayout>(
      $vendorPayout,
      columns: [VendorPayout.t.vendorId],
      transaction: transaction,
    );
  }
}
