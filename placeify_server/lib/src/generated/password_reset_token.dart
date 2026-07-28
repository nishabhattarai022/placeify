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
import 'package:placeify_server/src/generated/protocol.dart' as _i3;

/// Password reset token for custom link-based reset flow.
abstract class PasswordResetToken
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  PasswordResetToken._({
    this.id,
    required this.userId,
    this.user,
    required this.tokenHash,
    required this.expiresAt,
    bool? used,
    DateTime? createdAt,
  }) : used = used ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory PasswordResetToken({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    _i2.User? user,
    required String tokenHash,
    required DateTime expiresAt,
    bool? used,
    DateTime? createdAt,
  }) = _PasswordResetTokenImpl;

  factory PasswordResetToken.fromJson(Map<String, dynamic> jsonSerialization) {
    return PasswordResetToken(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      user: jsonSerialization['user'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.User>(jsonSerialization['user']),
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

  static final t = PasswordResetTokenTable();

  static const db = PasswordResetTokenRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue userId;

  _i2.User? user;

  String tokenHash;

  DateTime expiresAt;

  bool used;

  DateTime createdAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [PasswordResetToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PasswordResetToken copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    _i2.User? user,
    String? tokenHash,
    DateTime? expiresAt,
    bool? used,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PasswordResetToken',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      if (user != null) 'user': user?.toJson(),
      'tokenHash': tokenHash,
      'expiresAt': expiresAt.toJson(),
      'used': used,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PasswordResetToken',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      if (user != null) 'user': user?.toJsonForProtocol(),
      'tokenHash': tokenHash,
      'expiresAt': expiresAt.toJson(),
      'used': used,
      'createdAt': createdAt.toJson(),
    };
  }

  static PasswordResetTokenInclude include({_i2.UserInclude? user}) {
    return PasswordResetTokenInclude._(user: user);
  }

  static PasswordResetTokenIncludeList includeList({
    _i1.WhereExpressionBuilder<PasswordResetTokenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PasswordResetTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PasswordResetTokenTable>? orderByList,
    PasswordResetTokenInclude? include,
  }) {
    return PasswordResetTokenIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PasswordResetToken.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PasswordResetToken.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PasswordResetTokenImpl extends PasswordResetToken {
  _PasswordResetTokenImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    _i2.User? user,
    required String tokenHash,
    required DateTime expiresAt,
    bool? used,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         user: user,
         tokenHash: tokenHash,
         expiresAt: expiresAt,
         used: used,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [PasswordResetToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PasswordResetToken copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    Object? user = _Undefined,
    String? tokenHash,
    DateTime? expiresAt,
    bool? used,
    DateTime? createdAt,
  }) {
    return PasswordResetToken(
      id: id is _i1.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _i2.User? ? user : this.user?.copyWith(),
      tokenHash: tokenHash ?? this.tokenHash,
      expiresAt: expiresAt ?? this.expiresAt,
      used: used ?? this.used,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class PasswordResetTokenUpdateTable
    extends _i1.UpdateTable<PasswordResetTokenTable> {
  PasswordResetTokenUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
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

class PasswordResetTokenTable extends _i1.Table<_i1.UuidValue?> {
  PasswordResetTokenTable({super.tableRelation})
    : super(tableName: 'password_reset_tokens') {
    updateTable = PasswordResetTokenUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
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

  late final PasswordResetTokenUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  _i2.UserTable? _user;

  late final _i1.ColumnString tokenHash;

  late final _i1.ColumnDateTime expiresAt;

  late final _i1.ColumnBool used;

  late final _i1.ColumnDateTime createdAt;

  _i2.UserTable get user {
    if (_user != null) return _user!;
    _user = _i1.createRelationTable(
      relationFieldName: 'user',
      field: PasswordResetToken.t.userId,
      foreignField: _i2.User.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.UserTable(tableRelation: foreignTableRelation),
    );
    return _user!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    tokenHash,
    expiresAt,
    used,
    createdAt,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'user') {
      return user;
    }
    return null;
  }
}

class PasswordResetTokenInclude extends _i1.IncludeObject {
  PasswordResetTokenInclude._({_i2.UserInclude? user}) {
    _user = user;
  }

  _i2.UserInclude? _user;

  @override
  Map<String, _i1.Include?> get includes => {'user': _user};

  @override
  _i1.Table<_i1.UuidValue?> get table => PasswordResetToken.t;
}

class PasswordResetTokenIncludeList extends _i1.IncludeList {
  PasswordResetTokenIncludeList._({
    _i1.WhereExpressionBuilder<PasswordResetTokenTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PasswordResetToken.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => PasswordResetToken.t;
}

class PasswordResetTokenRepository {
  const PasswordResetTokenRepository._();

  final attachRow = const PasswordResetTokenAttachRowRepository._();

  /// Returns a list of [PasswordResetToken]s matching the given query parameters.
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
  Future<List<PasswordResetToken>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PasswordResetTokenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PasswordResetTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PasswordResetTokenTable>? orderByList,
    _i1.Transaction? transaction,
    PasswordResetTokenInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PasswordResetToken>(
      where: where?.call(PasswordResetToken.t),
      orderBy: orderBy?.call(PasswordResetToken.t),
      orderByList: orderByList?.call(PasswordResetToken.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PasswordResetToken] matching the given query parameters.
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
  Future<PasswordResetToken?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PasswordResetTokenTable>? where,
    int? offset,
    _i1.OrderByBuilder<PasswordResetTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PasswordResetTokenTable>? orderByList,
    _i1.Transaction? transaction,
    PasswordResetTokenInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PasswordResetToken>(
      where: where?.call(PasswordResetToken.t),
      orderBy: orderBy?.call(PasswordResetToken.t),
      orderByList: orderByList?.call(PasswordResetToken.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PasswordResetToken] by its [id] or null if no such row exists.
  Future<PasswordResetToken?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    PasswordResetTokenInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PasswordResetToken>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PasswordResetToken]s in the list and returns the inserted rows.
  ///
  /// The returned [PasswordResetToken]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<PasswordResetToken>> insert(
    _i1.DatabaseSession session,
    List<PasswordResetToken> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<PasswordResetToken>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [PasswordResetToken] and returns the inserted row.
  ///
  /// The returned [PasswordResetToken] will have its `id` field set.
  Future<PasswordResetToken> insertRow(
    _i1.DatabaseSession session,
    PasswordResetToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PasswordResetToken>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PasswordResetToken]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PasswordResetToken>> update(
    _i1.DatabaseSession session,
    List<PasswordResetToken> rows, {
    _i1.ColumnSelections<PasswordResetTokenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PasswordResetToken>(
      rows,
      columns: columns?.call(PasswordResetToken.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PasswordResetToken]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PasswordResetToken> updateRow(
    _i1.DatabaseSession session,
    PasswordResetToken row, {
    _i1.ColumnSelections<PasswordResetTokenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PasswordResetToken>(
      row,
      columns: columns?.call(PasswordResetToken.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PasswordResetToken] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PasswordResetToken?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<PasswordResetTokenUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PasswordResetToken>(
      id,
      columnValues: columnValues(PasswordResetToken.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PasswordResetToken]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PasswordResetToken>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<PasswordResetTokenUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<PasswordResetTokenTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PasswordResetTokenTable>? orderBy,
    _i1.OrderByListBuilder<PasswordResetTokenTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PasswordResetToken>(
      columnValues: columnValues(PasswordResetToken.t.updateTable),
      where: where(PasswordResetToken.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PasswordResetToken.t),
      orderByList: orderByList?.call(PasswordResetToken.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PasswordResetToken]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PasswordResetToken>> delete(
    _i1.DatabaseSession session,
    List<PasswordResetToken> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PasswordResetToken>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PasswordResetToken].
  Future<PasswordResetToken> deleteRow(
    _i1.DatabaseSession session,
    PasswordResetToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PasswordResetToken>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PasswordResetToken>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<PasswordResetTokenTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PasswordResetToken>(
      where: where(PasswordResetToken.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PasswordResetTokenTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PasswordResetToken>(
      where: where?.call(PasswordResetToken.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PasswordResetToken] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<PasswordResetTokenTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PasswordResetToken>(
      where: where(PasswordResetToken.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class PasswordResetTokenAttachRowRepository {
  const PasswordResetTokenAttachRowRepository._();

  /// Creates a relation between the given [PasswordResetToken] and [User]
  /// by setting the [PasswordResetToken]'s foreign key `userId` to refer to the [User].
  Future<void> user(
    _i1.DatabaseSession session,
    PasswordResetToken passwordResetToken,
    _i2.User user, {
    _i1.Transaction? transaction,
  }) async {
    if (passwordResetToken.id == null) {
      throw ArgumentError.notNull('passwordResetToken.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $passwordResetToken = passwordResetToken.copyWith(userId: user.id);
    await session.db.updateRow<PasswordResetToken>(
      $passwordResetToken,
      columns: [PasswordResetToken.t.userId],
      transaction: transaction,
    );
  }
}
