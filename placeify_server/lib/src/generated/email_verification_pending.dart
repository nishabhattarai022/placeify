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

/// Pending email-IDP registration completed via magic link.
/// Stores only a hashed link token (never the raw token). The short-lived
/// IDP verification code is required to call verifyRegistrationCode.
abstract class EmailVerificationPending
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  EmailVerificationPending._({
    this.id,
    required this.email,
    required this.accountRequestId,
    required this.verificationCode,
    required this.tokenHash,
    required this.expiresAt,
    bool? used,
    DateTime? createdAt,
  }) : used = used ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory EmailVerificationPending({
    _i1.UuidValue? id,
    required String email,
    required _i1.UuidValue accountRequestId,
    required String verificationCode,
    required String tokenHash,
    required DateTime expiresAt,
    bool? used,
    DateTime? createdAt,
  }) = _EmailVerificationPendingImpl;

  factory EmailVerificationPending.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return EmailVerificationPending(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      email: jsonSerialization['email'] as String,
      accountRequestId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['accountRequestId'],
      ),
      verificationCode: jsonSerialization['verificationCode'] as String,
      tokenHash: jsonSerialization['tokenHash'] as String,
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      used: jsonSerialization['used'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['used']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = EmailVerificationPendingTable();

  static const db = EmailVerificationPendingRepository._();

  @override
  _i1.UuidValue? id;

  String email;

  _i1.UuidValue accountRequestId;

  /// Short-lived Email IDP OTP captured when the magic link is issued.
  String verificationCode;

  String tokenHash;

  DateTime expiresAt;

  bool used;

  DateTime createdAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [EmailVerificationPending]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailVerificationPending copyWith({
    _i1.UuidValue? id,
    String? email,
    _i1.UuidValue? accountRequestId,
    String? verificationCode,
    String? tokenHash,
    DateTime? expiresAt,
    bool? used,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EmailVerificationPending',
      if (id != null) 'id': id?.toJson(),
      'email': email,
      'accountRequestId': accountRequestId.toJson(),
      'verificationCode': verificationCode,
      'tokenHash': tokenHash,
      'expiresAt': expiresAt.toJson(),
      'used': used,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EmailVerificationPending',
      if (id != null) 'id': id?.toJson(),
      'email': email,
      'accountRequestId': accountRequestId.toJson(),
      'verificationCode': verificationCode,
      'tokenHash': tokenHash,
      'expiresAt': expiresAt.toJson(),
      'used': used,
      'createdAt': createdAt.toJson(),
    };
  }

  static EmailVerificationPendingInclude include() {
    return EmailVerificationPendingInclude._();
  }

  static EmailVerificationPendingIncludeList includeList({
    _i1.WhereExpressionBuilder<EmailVerificationPendingTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailVerificationPendingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailVerificationPendingTable>? orderByList,
    EmailVerificationPendingInclude? include,
  }) {
    return EmailVerificationPendingIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailVerificationPending.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EmailVerificationPending.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailVerificationPendingImpl extends EmailVerificationPending {
  _EmailVerificationPendingImpl({
    _i1.UuidValue? id,
    required String email,
    required _i1.UuidValue accountRequestId,
    required String verificationCode,
    required String tokenHash,
    required DateTime expiresAt,
    bool? used,
    DateTime? createdAt,
  }) : super._(
         id: id,
         email: email,
         accountRequestId: accountRequestId,
         verificationCode: verificationCode,
         tokenHash: tokenHash,
         expiresAt: expiresAt,
         used: used,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [EmailVerificationPending]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailVerificationPending copyWith({
    Object? id = _Undefined,
    String? email,
    _i1.UuidValue? accountRequestId,
    String? verificationCode,
    String? tokenHash,
    DateTime? expiresAt,
    bool? used,
    DateTime? createdAt,
  }) {
    return EmailVerificationPending(
      id: id is _i1.UuidValue? ? id : this.id,
      email: email ?? this.email,
      accountRequestId: accountRequestId ?? this.accountRequestId,
      verificationCode: verificationCode ?? this.verificationCode,
      tokenHash: tokenHash ?? this.tokenHash,
      expiresAt: expiresAt ?? this.expiresAt,
      used: used ?? this.used,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class EmailVerificationPendingUpdateTable
    extends _i1.UpdateTable<EmailVerificationPendingTable> {
  EmailVerificationPendingUpdateTable(super.table);

  _i1.ColumnValue<String, String> email(String value) => _i1.ColumnValue(
    table.email,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> accountRequestId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.accountRequestId,
    value,
  );

  _i1.ColumnValue<String, String> verificationCode(String value) =>
      _i1.ColumnValue(
        table.verificationCode,
        value,
      );

  _i1.ColumnValue<String, String> tokenHash(String value) => _i1.ColumnValue(
    table.tokenHash,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> expiresAt(DateTime value) =>
      _i1.ColumnValue(
        table.expiresAt,
        value,
      );

  _i1.ColumnValue<bool, bool> used(bool value) => _i1.ColumnValue(
    table.used,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class EmailVerificationPendingTable extends _i1.Table<_i1.UuidValue?> {
  EmailVerificationPendingTable({super.tableRelation})
    : super(tableName: 'email_verification_pending') {
    updateTable = EmailVerificationPendingUpdateTable(this);
    email = _i1.ColumnString(
      'email',
      this,
    );
    accountRequestId = _i1.ColumnUuid(
      'accountRequestId',
      this,
    );
    verificationCode = _i1.ColumnString(
      'verificationCode',
      this,
    );
    tokenHash = _i1.ColumnString(
      'tokenHash',
      this,
    );
    expiresAt = _i1.ColumnDateTime(
      'expiresAt',
      this,
    );
    used = _i1.ColumnBool(
      'used',
      this,
      hasDefault: true,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final EmailVerificationPendingUpdateTable updateTable;

  late final _i1.ColumnString email;

  late final _i1.ColumnUuid accountRequestId;

  /// Short-lived Email IDP OTP captured when the magic link is issued.
  late final _i1.ColumnString verificationCode;

  late final _i1.ColumnString tokenHash;

  late final _i1.ColumnDateTime expiresAt;

  late final _i1.ColumnBool used;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    email,
    accountRequestId,
    verificationCode,
    tokenHash,
    expiresAt,
    used,
    createdAt,
  ];
}

class EmailVerificationPendingInclude extends _i1.IncludeObject {
  EmailVerificationPendingInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => EmailVerificationPending.t;
}

class EmailVerificationPendingIncludeList extends _i1.IncludeList {
  EmailVerificationPendingIncludeList._({
    _i1.WhereExpressionBuilder<EmailVerificationPendingTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EmailVerificationPending.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => EmailVerificationPending.t;
}

class EmailVerificationPendingRepository {
  const EmailVerificationPendingRepository._();

  /// Returns a list of [EmailVerificationPending]s matching the given query parameters.
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
  Future<List<EmailVerificationPending>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<EmailVerificationPendingTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailVerificationPendingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailVerificationPendingTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<EmailVerificationPending>(
      where: where?.call(EmailVerificationPending.t),
      orderBy: orderBy?.call(EmailVerificationPending.t),
      orderByList: orderByList?.call(EmailVerificationPending.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [EmailVerificationPending] matching the given query parameters.
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
  Future<EmailVerificationPending?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<EmailVerificationPendingTable>? where,
    int? offset,
    _i1.OrderByBuilder<EmailVerificationPendingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailVerificationPendingTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<EmailVerificationPending>(
      where: where?.call(EmailVerificationPending.t),
      orderBy: orderBy?.call(EmailVerificationPending.t),
      orderByList: orderByList?.call(EmailVerificationPending.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [EmailVerificationPending] by its [id] or null if no such row exists.
  Future<EmailVerificationPending?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<EmailVerificationPending>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [EmailVerificationPending]s in the list and returns the inserted rows.
  ///
  /// The returned [EmailVerificationPending]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<EmailVerificationPending>> insert(
    _i1.DatabaseSession session,
    List<EmailVerificationPending> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<EmailVerificationPending>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [EmailVerificationPending] and returns the inserted row.
  ///
  /// The returned [EmailVerificationPending] will have its `id` field set.
  Future<EmailVerificationPending> insertRow(
    _i1.DatabaseSession session,
    EmailVerificationPending row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmailVerificationPending>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [EmailVerificationPending]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<EmailVerificationPending>> update(
    _i1.DatabaseSession session,
    List<EmailVerificationPending> rows, {
    _i1.ColumnSelections<EmailVerificationPendingTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EmailVerificationPending>(
      rows,
      columns: columns?.call(EmailVerificationPending.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailVerificationPending]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmailVerificationPending> updateRow(
    _i1.DatabaseSession session,
    EmailVerificationPending row, {
    _i1.ColumnSelections<EmailVerificationPendingTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmailVerificationPending>(
      row,
      columns: columns?.call(EmailVerificationPending.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailVerificationPending] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EmailVerificationPending?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<EmailVerificationPendingUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<EmailVerificationPending>(
      id,
      columnValues: columnValues(EmailVerificationPending.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EmailVerificationPending]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<EmailVerificationPending>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<EmailVerificationPendingUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<EmailVerificationPendingTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailVerificationPendingTable>? orderBy,
    _i1.OrderByListBuilder<EmailVerificationPendingTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<EmailVerificationPending>(
      columnValues: columnValues(EmailVerificationPending.t.updateTable),
      where: where(EmailVerificationPending.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailVerificationPending.t),
      orderByList: orderByList?.call(EmailVerificationPending.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [EmailVerificationPending]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<EmailVerificationPending>> delete(
    _i1.DatabaseSession session,
    List<EmailVerificationPending> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EmailVerificationPending>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [EmailVerificationPending].
  Future<EmailVerificationPending> deleteRow(
    _i1.DatabaseSession session,
    EmailVerificationPending row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmailVerificationPending>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<EmailVerificationPending>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<EmailVerificationPendingTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EmailVerificationPending>(
      where: where(EmailVerificationPending.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<EmailVerificationPendingTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EmailVerificationPending>(
      where: where?.call(EmailVerificationPending.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [EmailVerificationPending] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<EmailVerificationPendingTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<EmailVerificationPending>(
      where: where(EmailVerificationPending.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
