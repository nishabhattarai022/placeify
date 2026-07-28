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
import 'package:serverpod/serverpod.dart' as _i1;

/// One-to-one customer ↔ vendor conversation.
abstract class Conversation
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  Conversation._({
    this.id,
    required this.customerId,
    required this.vendorId,
    this.lastMessage,
    this.lastMessageTime,
    this.lastSenderId,
    int? unreadCustomerCount,
    int? unreadVendorCount,
    this.customerDeletedAt,
    this.vendorDeletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : unreadCustomerCount = unreadCustomerCount ?? 0,
       unreadVendorCount = unreadVendorCount ?? 0,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Conversation({
    _i1.UuidValue? id,
    required _i1.UuidValue customerId,
    required _i1.UuidValue vendorId,
    String? lastMessage,
    DateTime? lastMessageTime,
    _i1.UuidValue? lastSenderId,
    int? unreadCustomerCount,
    int? unreadVendorCount,
    DateTime? customerDeletedAt,
    DateTime? vendorDeletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ConversationImpl;

  factory Conversation.fromJson(Map<String, dynamic> jsonSerialization) {
    return Conversation(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      customerId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['customerId'],
      ),
      vendorId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['vendorId'],
      ),
      lastMessage: jsonSerialization['lastMessage'] as String?,
      lastMessageTime: jsonSerialization['lastMessageTime'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastMessageTime'],
            ),
      lastSenderId: jsonSerialization['lastSenderId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['lastSenderId'],
            ),
      unreadCustomerCount: jsonSerialization['unreadCustomerCount'] as int?,
      unreadVendorCount: jsonSerialization['unreadVendorCount'] as int?,
      customerDeletedAt: jsonSerialization['customerDeletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['customerDeletedAt'],
            ),
      vendorDeletedAt: jsonSerialization['vendorDeletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['vendorDeletedAt'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = ConversationTable();

  static const db = ConversationRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue customerId;

  _i1.UuidValue vendorId;

  String? lastMessage;

  DateTime? lastMessageTime;

  _i1.UuidValue? lastSenderId;

  int unreadCustomerCount;

  int unreadVendorCount;

  /// Soft-delete for the customer side of the inbox.
  DateTime? customerDeletedAt;

  /// Soft-delete for the vendor side of the inbox.
  DateTime? vendorDeletedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [Conversation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Conversation copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? customerId,
    _i1.UuidValue? vendorId,
    String? lastMessage,
    DateTime? lastMessageTime,
    _i1.UuidValue? lastSenderId,
    int? unreadCustomerCount,
    int? unreadVendorCount,
    DateTime? customerDeletedAt,
    DateTime? vendorDeletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Conversation',
      if (id != null) 'id': id?.toJson(),
      'customerId': customerId.toJson(),
      'vendorId': vendorId.toJson(),
      if (lastMessage != null) 'lastMessage': lastMessage,
      if (lastMessageTime != null) 'lastMessageTime': lastMessageTime?.toJson(),
      if (lastSenderId != null) 'lastSenderId': lastSenderId?.toJson(),
      'unreadCustomerCount': unreadCustomerCount,
      'unreadVendorCount': unreadVendorCount,
      if (customerDeletedAt != null)
        'customerDeletedAt': customerDeletedAt?.toJson(),
      if (vendorDeletedAt != null) 'vendorDeletedAt': vendorDeletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Conversation',
      if (id != null) 'id': id?.toJson(),
      'customerId': customerId.toJson(),
      'vendorId': vendorId.toJson(),
      if (lastMessage != null) 'lastMessage': lastMessage,
      if (lastMessageTime != null) 'lastMessageTime': lastMessageTime?.toJson(),
      if (lastSenderId != null) 'lastSenderId': lastSenderId?.toJson(),
      'unreadCustomerCount': unreadCustomerCount,
      'unreadVendorCount': unreadVendorCount,
      if (customerDeletedAt != null)
        'customerDeletedAt': customerDeletedAt?.toJson(),
      if (vendorDeletedAt != null) 'vendorDeletedAt': vendorDeletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static ConversationInclude include() {
    return ConversationInclude._();
  }

  static ConversationIncludeList includeList({
    _i1.WhereExpressionBuilder<ConversationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ConversationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ConversationTable>? orderByList,
    ConversationInclude? include,
  }) {
    return ConversationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Conversation.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Conversation.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ConversationImpl extends Conversation {
  _ConversationImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue customerId,
    required _i1.UuidValue vendorId,
    String? lastMessage,
    DateTime? lastMessageTime,
    _i1.UuidValue? lastSenderId,
    int? unreadCustomerCount,
    int? unreadVendorCount,
    DateTime? customerDeletedAt,
    DateTime? vendorDeletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         customerId: customerId,
         vendorId: vendorId,
         lastMessage: lastMessage,
         lastMessageTime: lastMessageTime,
         lastSenderId: lastSenderId,
         unreadCustomerCount: unreadCustomerCount,
         unreadVendorCount: unreadVendorCount,
         customerDeletedAt: customerDeletedAt,
         vendorDeletedAt: vendorDeletedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Conversation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Conversation copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? customerId,
    _i1.UuidValue? vendorId,
    Object? lastMessage = _Undefined,
    Object? lastMessageTime = _Undefined,
    Object? lastSenderId = _Undefined,
    int? unreadCustomerCount,
    int? unreadVendorCount,
    Object? customerDeletedAt = _Undefined,
    Object? vendorDeletedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Conversation(
      id: id is _i1.UuidValue? ? id : this.id,
      customerId: customerId ?? this.customerId,
      vendorId: vendorId ?? this.vendorId,
      lastMessage: lastMessage is String? ? lastMessage : this.lastMessage,
      lastMessageTime: lastMessageTime is DateTime?
          ? lastMessageTime
          : this.lastMessageTime,
      lastSenderId: lastSenderId is _i1.UuidValue?
          ? lastSenderId
          : this.lastSenderId,
      unreadCustomerCount: unreadCustomerCount ?? this.unreadCustomerCount,
      unreadVendorCount: unreadVendorCount ?? this.unreadVendorCount,
      customerDeletedAt: customerDeletedAt is DateTime?
          ? customerDeletedAt
          : this.customerDeletedAt,
      vendorDeletedAt: vendorDeletedAt is DateTime?
          ? vendorDeletedAt
          : this.vendorDeletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ConversationUpdateTable extends _i1.UpdateTable<ConversationTable> {
  ConversationUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> customerId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.customerId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> vendorId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.vendorId,
        value,
      );

  _i1.ColumnValue<String, String> lastMessage(String? value) => _i1.ColumnValue(
    table.lastMessage,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> lastMessageTime(DateTime? value) =>
      _i1.ColumnValue(
        table.lastMessageTime,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> lastSenderId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.lastSenderId,
    value,
  );

  _i1.ColumnValue<int, int> unreadCustomerCount(int value) => _i1.ColumnValue(
    table.unreadCustomerCount,
    value,
  );

  _i1.ColumnValue<int, int> unreadVendorCount(int value) => _i1.ColumnValue(
    table.unreadVendorCount,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> customerDeletedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.customerDeletedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> vendorDeletedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.vendorDeletedAt,
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

class ConversationTable extends _i1.Table<_i1.UuidValue?> {
  ConversationTable({super.tableRelation}) : super(tableName: 'conversation') {
    updateTable = ConversationUpdateTable(this);
    customerId = _i1.ColumnUuid(
      'customerId',
      this,
    );
    vendorId = _i1.ColumnUuid(
      'vendorId',
      this,
    );
    lastMessage = _i1.ColumnString(
      'lastMessage',
      this,
    );
    lastMessageTime = _i1.ColumnDateTime(
      'lastMessageTime',
      this,
    );
    lastSenderId = _i1.ColumnUuid(
      'lastSenderId',
      this,
    );
    unreadCustomerCount = _i1.ColumnInt(
      'unreadCustomerCount',
      this,
      hasDefault: true,
    );
    unreadVendorCount = _i1.ColumnInt(
      'unreadVendorCount',
      this,
      hasDefault: true,
    );
    customerDeletedAt = _i1.ColumnDateTime(
      'customerDeletedAt',
      this,
    );
    vendorDeletedAt = _i1.ColumnDateTime(
      'vendorDeletedAt',
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

  late final ConversationUpdateTable updateTable;

  late final _i1.ColumnUuid customerId;

  late final _i1.ColumnUuid vendorId;

  late final _i1.ColumnString lastMessage;

  late final _i1.ColumnDateTime lastMessageTime;

  late final _i1.ColumnUuid lastSenderId;

  late final _i1.ColumnInt unreadCustomerCount;

  late final _i1.ColumnInt unreadVendorCount;

  /// Soft-delete for the customer side of the inbox.
  late final _i1.ColumnDateTime customerDeletedAt;

  /// Soft-delete for the vendor side of the inbox.
  late final _i1.ColumnDateTime vendorDeletedAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    customerId,
    vendorId,
    lastMessage,
    lastMessageTime,
    lastSenderId,
    unreadCustomerCount,
    unreadVendorCount,
    customerDeletedAt,
    vendorDeletedAt,
    createdAt,
    updatedAt,
  ];
}

class ConversationInclude extends _i1.IncludeObject {
  ConversationInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => Conversation.t;
}

class ConversationIncludeList extends _i1.IncludeList {
  ConversationIncludeList._({
    _i1.WhereExpressionBuilder<ConversationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Conversation.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => Conversation.t;
}

class ConversationRepository {
  const ConversationRepository._();

  /// Returns a list of [Conversation]s matching the given query parameters.
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
  Future<List<Conversation>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ConversationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ConversationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ConversationTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Conversation>(
      where: where?.call(Conversation.t),
      orderBy: orderBy?.call(Conversation.t),
      orderByList: orderByList?.call(Conversation.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Conversation] matching the given query parameters.
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
  Future<Conversation?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ConversationTable>? where,
    int? offset,
    _i1.OrderByBuilder<ConversationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ConversationTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Conversation>(
      where: where?.call(Conversation.t),
      orderBy: orderBy?.call(Conversation.t),
      orderByList: orderByList?.call(Conversation.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Conversation] by its [id] or null if no such row exists.
  Future<Conversation?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Conversation>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Conversation]s in the list and returns the inserted rows.
  ///
  /// The returned [Conversation]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Conversation>> insert(
    _i1.DatabaseSession session,
    List<Conversation> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Conversation>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Conversation] and returns the inserted row.
  ///
  /// The returned [Conversation] will have its `id` field set.
  Future<Conversation> insertRow(
    _i1.DatabaseSession session,
    Conversation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Conversation>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Conversation]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Conversation>> update(
    _i1.DatabaseSession session,
    List<Conversation> rows, {
    _i1.ColumnSelections<ConversationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Conversation>(
      rows,
      columns: columns?.call(Conversation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Conversation]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Conversation> updateRow(
    _i1.DatabaseSession session,
    Conversation row, {
    _i1.ColumnSelections<ConversationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Conversation>(
      row,
      columns: columns?.call(Conversation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Conversation] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Conversation?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<ConversationUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Conversation>(
      id,
      columnValues: columnValues(Conversation.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Conversation]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Conversation>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ConversationUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ConversationTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ConversationTable>? orderBy,
    _i1.OrderByListBuilder<ConversationTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Conversation>(
      columnValues: columnValues(Conversation.t.updateTable),
      where: where(Conversation.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Conversation.t),
      orderByList: orderByList?.call(Conversation.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Conversation]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Conversation>> delete(
    _i1.DatabaseSession session,
    List<Conversation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Conversation>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Conversation].
  Future<Conversation> deleteRow(
    _i1.DatabaseSession session,
    Conversation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Conversation>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Conversation>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ConversationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Conversation>(
      where: where(Conversation.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ConversationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Conversation>(
      where: where?.call(Conversation.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Conversation] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ConversationTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Conversation>(
      where: where(Conversation.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
