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
import 'in_app_notification_type.dart' as _i3;
import 'package:placeify_server/src/generated/protocol.dart' as _i4;

/// Persisted in-app notification for customers and vendors.
abstract class InAppNotification
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  InAppNotification._({
    this.id,
    required this.userId,
    this.user,
    required this.title,
    required this.message,
    required this.type,
    this.referenceId,
    bool? isRead,
    DateTime? createdAt,
  }) : isRead = isRead ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory InAppNotification({
    int? id,
    required _i1.UuidValue userId,
    _i2.User? user,
    required String title,
    required String message,
    required _i3.InAppNotificationType type,
    int? referenceId,
    bool? isRead,
    DateTime? createdAt,
  }) = _InAppNotificationImpl;

  factory InAppNotification.fromJson(Map<String, dynamic> jsonSerialization) {
    return InAppNotification(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      user: jsonSerialization['user'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.User>(jsonSerialization['user']),
      title: jsonSerialization['title'] as String,
      message: jsonSerialization['message'] as String,
      type: _i3.InAppNotificationType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      referenceId: jsonSerialization['referenceId'] as int?,
      isRead: jsonSerialization['isRead'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isRead']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = InAppNotificationTable();

  static const db = InAppNotificationRepository._();

  @override
  int? id;

  _i1.UuidValue userId;

  _i2.User? user;

  String title;

  String message;

  _i3.InAppNotificationType type;

  int? referenceId;

  bool isRead;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [InAppNotification]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  InAppNotification copyWith({
    int? id,
    _i1.UuidValue? userId,
    _i2.User? user,
    String? title,
    String? message,
    _i3.InAppNotificationType? type,
    int? referenceId,
    bool? isRead,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'InAppNotification',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      if (user != null) 'user': user?.toJson(),
      'title': title,
      'message': message,
      'type': type.toJson(),
      if (referenceId != null) 'referenceId': referenceId,
      'isRead': isRead,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'InAppNotification',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      if (user != null) 'user': user?.toJsonForProtocol(),
      'title': title,
      'message': message,
      'type': type.toJson(),
      if (referenceId != null) 'referenceId': referenceId,
      'isRead': isRead,
      'createdAt': createdAt.toJson(),
    };
  }

  static InAppNotificationInclude include({_i2.UserInclude? user}) {
    return InAppNotificationInclude._(user: user);
  }

  static InAppNotificationIncludeList includeList({
    _i1.WhereExpressionBuilder<InAppNotificationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<InAppNotificationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<InAppNotificationTable>? orderByList,
    InAppNotificationInclude? include,
  }) {
    return InAppNotificationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(InAppNotification.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(InAppNotification.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _InAppNotificationImpl extends InAppNotification {
  _InAppNotificationImpl({
    int? id,
    required _i1.UuidValue userId,
    _i2.User? user,
    required String title,
    required String message,
    required _i3.InAppNotificationType type,
    int? referenceId,
    bool? isRead,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         user: user,
         title: title,
         message: message,
         type: type,
         referenceId: referenceId,
         isRead: isRead,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [InAppNotification]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  InAppNotification copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    Object? user = _Undefined,
    String? title,
    String? message,
    _i3.InAppNotificationType? type,
    Object? referenceId = _Undefined,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return InAppNotification(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _i2.User? ? user : this.user?.copyWith(),
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      referenceId: referenceId is int? ? referenceId : this.referenceId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class InAppNotificationUpdateTable
    extends _i1.UpdateTable<InAppNotificationTable> {
  InAppNotificationUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> message(String value) => _i1.ColumnValue(
    table.message,
    value,
  );

  _i1.ColumnValue<_i3.InAppNotificationType, _i3.InAppNotificationType> type(
    _i3.InAppNotificationType value,
  ) => _i1.ColumnValue(
    table.type,
    value,
  );

  _i1.ColumnValue<int, int> referenceId(int? value) => _i1.ColumnValue(
    table.referenceId,
    value,
  );

  _i1.ColumnValue<bool, bool> isRead(bool value) => _i1.ColumnValue(
    table.isRead,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class InAppNotificationTable extends _i1.Table<int?> {
  InAppNotificationTable({super.tableRelation})
    : super(tableName: 'in_app_notification') {
    updateTable = InAppNotificationUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    message = _i1.ColumnString(
      'message',
      this,
    );
    type = _i1.ColumnEnum(
      'type',
      this,
      _i1.EnumSerialization.byName,
    );
    referenceId = _i1.ColumnInt(
      'referenceId',
      this,
    );
    isRead = _i1.ColumnBool(
      'isRead',
      this,
      hasDefault: true,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final InAppNotificationUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  _i2.UserTable? _user;

  late final _i1.ColumnString title;

  late final _i1.ColumnString message;

  late final _i1.ColumnEnum<_i3.InAppNotificationType> type;

  late final _i1.ColumnInt referenceId;

  late final _i1.ColumnBool isRead;

  late final _i1.ColumnDateTime createdAt;

  _i2.UserTable get user {
    if (_user != null) return _user!;
    _user = _i1.createRelationTable(
      relationFieldName: 'user',
      field: InAppNotification.t.userId,
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
    title,
    message,
    type,
    referenceId,
    isRead,
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

class InAppNotificationInclude extends _i1.IncludeObject {
  InAppNotificationInclude._({_i2.UserInclude? user}) {
    _user = user;
  }

  _i2.UserInclude? _user;

  @override
  Map<String, _i1.Include?> get includes => {'user': _user};

  @override
  _i1.Table<int?> get table => InAppNotification.t;
}

class InAppNotificationIncludeList extends _i1.IncludeList {
  InAppNotificationIncludeList._({
    _i1.WhereExpressionBuilder<InAppNotificationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(InAppNotification.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => InAppNotification.t;
}

class InAppNotificationRepository {
  const InAppNotificationRepository._();

  final attachRow = const InAppNotificationAttachRowRepository._();

  /// Returns a list of [InAppNotification]s matching the given query parameters.
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
  Future<List<InAppNotification>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<InAppNotificationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<InAppNotificationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<InAppNotificationTable>? orderByList,
    _i1.Transaction? transaction,
    InAppNotificationInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<InAppNotification>(
      where: where?.call(InAppNotification.t),
      orderBy: orderBy?.call(InAppNotification.t),
      orderByList: orderByList?.call(InAppNotification.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [InAppNotification] matching the given query parameters.
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
  Future<InAppNotification?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<InAppNotificationTable>? where,
    int? offset,
    _i1.OrderByBuilder<InAppNotificationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<InAppNotificationTable>? orderByList,
    _i1.Transaction? transaction,
    InAppNotificationInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<InAppNotification>(
      where: where?.call(InAppNotification.t),
      orderBy: orderBy?.call(InAppNotification.t),
      orderByList: orderByList?.call(InAppNotification.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [InAppNotification] by its [id] or null if no such row exists.
  Future<InAppNotification?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    InAppNotificationInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<InAppNotification>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [InAppNotification]s in the list and returns the inserted rows.
  ///
  /// The returned [InAppNotification]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<InAppNotification>> insert(
    _i1.DatabaseSession session,
    List<InAppNotification> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<InAppNotification>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [InAppNotification] and returns the inserted row.
  ///
  /// The returned [InAppNotification] will have its `id` field set.
  Future<InAppNotification> insertRow(
    _i1.DatabaseSession session,
    InAppNotification row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<InAppNotification>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [InAppNotification]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<InAppNotification>> update(
    _i1.DatabaseSession session,
    List<InAppNotification> rows, {
    _i1.ColumnSelections<InAppNotificationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<InAppNotification>(
      rows,
      columns: columns?.call(InAppNotification.t),
      transaction: transaction,
    );
  }

  /// Updates a single [InAppNotification]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<InAppNotification> updateRow(
    _i1.DatabaseSession session,
    InAppNotification row, {
    _i1.ColumnSelections<InAppNotificationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<InAppNotification>(
      row,
      columns: columns?.call(InAppNotification.t),
      transaction: transaction,
    );
  }

  /// Updates a single [InAppNotification] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<InAppNotification?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<InAppNotificationUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<InAppNotification>(
      id,
      columnValues: columnValues(InAppNotification.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [InAppNotification]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<InAppNotification>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<InAppNotificationUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<InAppNotificationTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<InAppNotificationTable>? orderBy,
    _i1.OrderByListBuilder<InAppNotificationTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<InAppNotification>(
      columnValues: columnValues(InAppNotification.t.updateTable),
      where: where(InAppNotification.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(InAppNotification.t),
      orderByList: orderByList?.call(InAppNotification.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [InAppNotification]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<InAppNotification>> delete(
    _i1.DatabaseSession session,
    List<InAppNotification> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<InAppNotification>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [InAppNotification].
  Future<InAppNotification> deleteRow(
    _i1.DatabaseSession session,
    InAppNotification row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<InAppNotification>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<InAppNotification>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<InAppNotificationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<InAppNotification>(
      where: where(InAppNotification.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<InAppNotificationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<InAppNotification>(
      where: where?.call(InAppNotification.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [InAppNotification] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<InAppNotificationTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<InAppNotification>(
      where: where(InAppNotification.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class InAppNotificationAttachRowRepository {
  const InAppNotificationAttachRowRepository._();

  /// Creates a relation between the given [InAppNotification] and [User]
  /// by setting the [InAppNotification]'s foreign key `userId` to refer to the [User].
  Future<void> user(
    _i1.DatabaseSession session,
    InAppNotification inAppNotification,
    _i2.User user, {
    _i1.Transaction? transaction,
  }) async {
    if (inAppNotification.id == null) {
      throw ArgumentError.notNull('inAppNotification.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $inAppNotification = inAppNotification.copyWith(userId: user.id);
    await session.db.updateRow<InAppNotification>(
      $inAppNotification,
      columns: [InAppNotification.t.userId],
      transaction: transaction,
    );
  }
}
