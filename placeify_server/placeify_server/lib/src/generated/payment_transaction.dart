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
import 'payment_method.dart' as _i2;
import 'payment_transaction_status.dart' as _i3;
import 'order.dart' as _i4;
import 'user.dart' as _i5;
import 'package:placeify_server/src/generated/protocol.dart' as _i6;

/// Customer payment record for a placed order.
abstract class PaymentTransaction
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  PaymentTransaction._({
    this.id,
    required this.orderId,
    this.order,
    required this.userId,
    this.user,
    required this.provider,
    required this.providerTransactionId,
    _i2.PaymentMethod? paymentMethod,
    required this.amount,
    String? currency,
    _i3.PaymentTransactionStatus? status,
    this.note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : paymentMethod = paymentMethod ?? _i2.PaymentMethod.mockOnline,
       currency = currency ?? 'NPR',
       status = status ?? _i3.PaymentTransactionStatus.pending,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory PaymentTransaction({
    int? id,
    required int orderId,
    _i4.Order? order,
    required _i1.UuidValue userId,
    _i5.User? user,
    required String provider,
    required String providerTransactionId,
    _i2.PaymentMethod? paymentMethod,
    required double amount,
    String? currency,
    _i3.PaymentTransactionStatus? status,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PaymentTransactionImpl;

  factory PaymentTransaction.fromJson(Map<String, dynamic> jsonSerialization) {
    return PaymentTransaction(
      id: jsonSerialization['id'] as int?,
      orderId: jsonSerialization['orderId'] as int,
      order: jsonSerialization['order'] == null
          ? null
          : _i6.Protocol().deserialize<_i4.Order>(jsonSerialization['order']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      user: jsonSerialization['user'] == null
          ? null
          : _i6.Protocol().deserialize<_i5.User>(jsonSerialization['user']),
      provider: jsonSerialization['provider'] as String,
      providerTransactionId:
          jsonSerialization['providerTransactionId'] as String,
      paymentMethod: jsonSerialization['paymentMethod'] == null
          ? null
          : _i2.PaymentMethod.fromJson(
              (jsonSerialization['paymentMethod'] as String),
            ),
      amount: (jsonSerialization['amount'] as num).toDouble(),
      currency: jsonSerialization['currency'] as String?,
      status: jsonSerialization['status'] == null
          ? null
          : _i3.PaymentTransactionStatus.fromJson(
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

  static final t = PaymentTransactionTable();

  static const db = PaymentTransactionRepository._();

  @override
  int? id;

  int orderId;

  _i4.Order? order;

  _i1.UuidValue userId;

  _i5.User? user;

  String provider;

  String providerTransactionId;

  _i2.PaymentMethod paymentMethod;

  double amount;

  String currency;

  _i3.PaymentTransactionStatus status;

  String? note;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [PaymentTransaction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PaymentTransaction copyWith({
    int? id,
    int? orderId,
    _i4.Order? order,
    _i1.UuidValue? userId,
    _i5.User? user,
    String? provider,
    String? providerTransactionId,
    _i2.PaymentMethod? paymentMethod,
    double? amount,
    String? currency,
    _i3.PaymentTransactionStatus? status,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PaymentTransaction',
      if (id != null) 'id': id,
      'orderId': orderId,
      if (order != null) 'order': order?.toJson(),
      'userId': userId.toJson(),
      if (user != null) 'user': user?.toJson(),
      'provider': provider,
      'providerTransactionId': providerTransactionId,
      'paymentMethod': paymentMethod.toJson(),
      'amount': amount,
      'currency': currency,
      'status': status.toJson(),
      if (note != null) 'note': note,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PaymentTransaction',
      if (id != null) 'id': id,
      'orderId': orderId,
      if (order != null) 'order': order?.toJsonForProtocol(),
      'userId': userId.toJson(),
      if (user != null) 'user': user?.toJsonForProtocol(),
      'provider': provider,
      'providerTransactionId': providerTransactionId,
      'paymentMethod': paymentMethod.toJson(),
      'amount': amount,
      'currency': currency,
      'status': status.toJson(),
      if (note != null) 'note': note,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static PaymentTransactionInclude include({
    _i4.OrderInclude? order,
    _i5.UserInclude? user,
  }) {
    return PaymentTransactionInclude._(
      order: order,
      user: user,
    );
  }

  static PaymentTransactionIncludeList includeList({
    _i1.WhereExpressionBuilder<PaymentTransactionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PaymentTransactionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PaymentTransactionTable>? orderByList,
    PaymentTransactionInclude? include,
  }) {
    return PaymentTransactionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PaymentTransaction.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PaymentTransaction.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PaymentTransactionImpl extends PaymentTransaction {
  _PaymentTransactionImpl({
    int? id,
    required int orderId,
    _i4.Order? order,
    required _i1.UuidValue userId,
    _i5.User? user,
    required String provider,
    required String providerTransactionId,
    _i2.PaymentMethod? paymentMethod,
    required double amount,
    String? currency,
    _i3.PaymentTransactionStatus? status,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         orderId: orderId,
         order: order,
         userId: userId,
         user: user,
         provider: provider,
         providerTransactionId: providerTransactionId,
         paymentMethod: paymentMethod,
         amount: amount,
         currency: currency,
         status: status,
         note: note,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [PaymentTransaction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PaymentTransaction copyWith({
    Object? id = _Undefined,
    int? orderId,
    Object? order = _Undefined,
    _i1.UuidValue? userId,
    Object? user = _Undefined,
    String? provider,
    String? providerTransactionId,
    _i2.PaymentMethod? paymentMethod,
    double? amount,
    String? currency,
    _i3.PaymentTransactionStatus? status,
    Object? note = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentTransaction(
      id: id is int? ? id : this.id,
      orderId: orderId ?? this.orderId,
      order: order is _i4.Order? ? order : this.order?.copyWith(),
      userId: userId ?? this.userId,
      user: user is _i5.User? ? user : this.user?.copyWith(),
      provider: provider ?? this.provider,
      providerTransactionId:
          providerTransactionId ?? this.providerTransactionId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      note: note is String? ? note : this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class PaymentTransactionUpdateTable
    extends _i1.UpdateTable<PaymentTransactionTable> {
  PaymentTransactionUpdateTable(super.table);

  _i1.ColumnValue<int, int> orderId(int value) => _i1.ColumnValue(
    table.orderId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<String, String> provider(String value) => _i1.ColumnValue(
    table.provider,
    value,
  );

  _i1.ColumnValue<String, String> providerTransactionId(String value) =>
      _i1.ColumnValue(
        table.providerTransactionId,
        value,
      );

  _i1.ColumnValue<_i2.PaymentMethod, _i2.PaymentMethod> paymentMethod(
    _i2.PaymentMethod value,
  ) => _i1.ColumnValue(
    table.paymentMethod,
    value,
  );

  _i1.ColumnValue<double, double> amount(double value) => _i1.ColumnValue(
    table.amount,
    value,
  );

  _i1.ColumnValue<String, String> currency(String value) => _i1.ColumnValue(
    table.currency,
    value,
  );

  _i1.ColumnValue<_i3.PaymentTransactionStatus, _i3.PaymentTransactionStatus>
  status(_i3.PaymentTransactionStatus value) => _i1.ColumnValue(
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

class PaymentTransactionTable extends _i1.Table<int?> {
  PaymentTransactionTable({super.tableRelation})
    : super(tableName: 'payment_transaction') {
    updateTable = PaymentTransactionUpdateTable(this);
    orderId = _i1.ColumnInt(
      'orderId',
      this,
    );
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    provider = _i1.ColumnString(
      'provider',
      this,
    );
    providerTransactionId = _i1.ColumnString(
      'providerTransactionId',
      this,
    );
    paymentMethod = _i1.ColumnEnum(
      'paymentMethod',
      this,
      _i1.EnumSerialization.byName,
      hasDefault: true,
    );
    amount = _i1.ColumnDouble(
      'amount',
      this,
    );
    currency = _i1.ColumnString(
      'currency',
      this,
      hasDefault: true,
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

  late final PaymentTransactionUpdateTable updateTable;

  late final _i1.ColumnInt orderId;

  _i4.OrderTable? _order;

  late final _i1.ColumnUuid userId;

  _i5.UserTable? _user;

  late final _i1.ColumnString provider;

  late final _i1.ColumnString providerTransactionId;

  late final _i1.ColumnEnum<_i2.PaymentMethod> paymentMethod;

  late final _i1.ColumnDouble amount;

  late final _i1.ColumnString currency;

  late final _i1.ColumnEnum<_i3.PaymentTransactionStatus> status;

  late final _i1.ColumnString note;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  _i4.OrderTable get order {
    if (_order != null) return _order!;
    _order = _i1.createRelationTable(
      relationFieldName: 'order',
      field: PaymentTransaction.t.orderId,
      foreignField: _i4.Order.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.OrderTable(tableRelation: foreignTableRelation),
    );
    return _order!;
  }

  _i5.UserTable get user {
    if (_user != null) return _user!;
    _user = _i1.createRelationTable(
      relationFieldName: 'user',
      field: PaymentTransaction.t.userId,
      foreignField: _i5.User.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i5.UserTable(tableRelation: foreignTableRelation),
    );
    return _user!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    orderId,
    userId,
    provider,
    providerTransactionId,
    paymentMethod,
    amount,
    currency,
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
    if (relationField == 'user') {
      return user;
    }
    return null;
  }
}

class PaymentTransactionInclude extends _i1.IncludeObject {
  PaymentTransactionInclude._({
    _i4.OrderInclude? order,
    _i5.UserInclude? user,
  }) {
    _order = order;
    _user = user;
  }

  _i4.OrderInclude? _order;

  _i5.UserInclude? _user;

  @override
  Map<String, _i1.Include?> get includes => {
    'order': _order,
    'user': _user,
  };

  @override
  _i1.Table<int?> get table => PaymentTransaction.t;
}

class PaymentTransactionIncludeList extends _i1.IncludeList {
  PaymentTransactionIncludeList._({
    _i1.WhereExpressionBuilder<PaymentTransactionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PaymentTransaction.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => PaymentTransaction.t;
}

class PaymentTransactionRepository {
  const PaymentTransactionRepository._();

  final attachRow = const PaymentTransactionAttachRowRepository._();

  /// Returns a list of [PaymentTransaction]s matching the given query parameters.
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
  Future<List<PaymentTransaction>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PaymentTransactionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PaymentTransactionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PaymentTransactionTable>? orderByList,
    _i1.Transaction? transaction,
    PaymentTransactionInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PaymentTransaction>(
      where: where?.call(PaymentTransaction.t),
      orderBy: orderBy?.call(PaymentTransaction.t),
      orderByList: orderByList?.call(PaymentTransaction.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PaymentTransaction] matching the given query parameters.
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
  Future<PaymentTransaction?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PaymentTransactionTable>? where,
    int? offset,
    _i1.OrderByBuilder<PaymentTransactionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PaymentTransactionTable>? orderByList,
    _i1.Transaction? transaction,
    PaymentTransactionInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PaymentTransaction>(
      where: where?.call(PaymentTransaction.t),
      orderBy: orderBy?.call(PaymentTransaction.t),
      orderByList: orderByList?.call(PaymentTransaction.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PaymentTransaction] by its [id] or null if no such row exists.
  Future<PaymentTransaction?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    PaymentTransactionInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PaymentTransaction>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PaymentTransaction]s in the list and returns the inserted rows.
  ///
  /// The returned [PaymentTransaction]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<PaymentTransaction>> insert(
    _i1.DatabaseSession session,
    List<PaymentTransaction> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<PaymentTransaction>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [PaymentTransaction] and returns the inserted row.
  ///
  /// The returned [PaymentTransaction] will have its `id` field set.
  Future<PaymentTransaction> insertRow(
    _i1.DatabaseSession session,
    PaymentTransaction row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PaymentTransaction>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PaymentTransaction]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PaymentTransaction>> update(
    _i1.DatabaseSession session,
    List<PaymentTransaction> rows, {
    _i1.ColumnSelections<PaymentTransactionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PaymentTransaction>(
      rows,
      columns: columns?.call(PaymentTransaction.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PaymentTransaction]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PaymentTransaction> updateRow(
    _i1.DatabaseSession session,
    PaymentTransaction row, {
    _i1.ColumnSelections<PaymentTransactionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PaymentTransaction>(
      row,
      columns: columns?.call(PaymentTransaction.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PaymentTransaction] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PaymentTransaction?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<PaymentTransactionUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PaymentTransaction>(
      id,
      columnValues: columnValues(PaymentTransaction.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PaymentTransaction]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PaymentTransaction>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<PaymentTransactionUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<PaymentTransactionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PaymentTransactionTable>? orderBy,
    _i1.OrderByListBuilder<PaymentTransactionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PaymentTransaction>(
      columnValues: columnValues(PaymentTransaction.t.updateTable),
      where: where(PaymentTransaction.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PaymentTransaction.t),
      orderByList: orderByList?.call(PaymentTransaction.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PaymentTransaction]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PaymentTransaction>> delete(
    _i1.DatabaseSession session,
    List<PaymentTransaction> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PaymentTransaction>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PaymentTransaction].
  Future<PaymentTransaction> deleteRow(
    _i1.DatabaseSession session,
    PaymentTransaction row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PaymentTransaction>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PaymentTransaction>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<PaymentTransactionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PaymentTransaction>(
      where: where(PaymentTransaction.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PaymentTransactionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PaymentTransaction>(
      where: where?.call(PaymentTransaction.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PaymentTransaction] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<PaymentTransactionTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PaymentTransaction>(
      where: where(PaymentTransaction.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class PaymentTransactionAttachRowRepository {
  const PaymentTransactionAttachRowRepository._();

  /// Creates a relation between the given [PaymentTransaction] and [Order]
  /// by setting the [PaymentTransaction]'s foreign key `orderId` to refer to the [Order].
  Future<void> order(
    _i1.DatabaseSession session,
    PaymentTransaction paymentTransaction,
    _i4.Order order, {
    _i1.Transaction? transaction,
  }) async {
    if (paymentTransaction.id == null) {
      throw ArgumentError.notNull('paymentTransaction.id');
    }
    if (order.id == null) {
      throw ArgumentError.notNull('order.id');
    }

    var $paymentTransaction = paymentTransaction.copyWith(orderId: order.id);
    await session.db.updateRow<PaymentTransaction>(
      $paymentTransaction,
      columns: [PaymentTransaction.t.orderId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [PaymentTransaction] and [User]
  /// by setting the [PaymentTransaction]'s foreign key `userId` to refer to the [User].
  Future<void> user(
    _i1.DatabaseSession session,
    PaymentTransaction paymentTransaction,
    _i5.User user, {
    _i1.Transaction? transaction,
  }) async {
    if (paymentTransaction.id == null) {
      throw ArgumentError.notNull('paymentTransaction.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $paymentTransaction = paymentTransaction.copyWith(userId: user.id);
    await session.db.updateRow<PaymentTransaction>(
      $paymentTransaction,
      columns: [PaymentTransaction.t.userId],
      transaction: transaction,
    );
  }
}
