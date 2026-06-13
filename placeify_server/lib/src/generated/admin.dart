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

/// Platform administrator profile linked to a user account.
abstract class Admin
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  Admin._({
    this.id,
    required this.userId,
    this.user,
    required this.title,
    this.department,
    bool? isActive,
    DateTime? createdAt,
  }) : isActive = isActive ?? true,
       createdAt = createdAt ?? DateTime.now();

  factory Admin({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    _i2.User? user,
    required String title,
    String? department,
    bool? isActive,
    DateTime? createdAt,
  }) = _AdminImpl;

  factory Admin.fromJson(Map<String, dynamic> jsonSerialization) {
    return Admin(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      user: jsonSerialization['user'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.User>(jsonSerialization['user']),
      title: jsonSerialization['title'] as String,
      department: jsonSerialization['department'] as String?,
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = AdminTable();

  static const db = AdminRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue userId;

  _i2.User? user;

  String title;

  String? department;

  bool isActive;

  DateTime createdAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [Admin]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Admin copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    _i2.User? user,
    String? title,
    String? department,
    bool? isActive,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Admin',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      if (user != null) 'user': user?.toJson(),
      'title': title,
      if (department != null) 'department': department,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Admin',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      if (user != null) 'user': user?.toJsonForProtocol(),
      'title': title,
      if (department != null) 'department': department,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
    };
  }

  static AdminInclude include({_i2.UserInclude? user}) {
    return AdminInclude._(user: user);
  }

  static AdminIncludeList includeList({
    _i1.WhereExpressionBuilder<AdminTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AdminTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AdminTable>? orderByList,
    AdminInclude? include,
  }) {
    return AdminIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Admin.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Admin.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminImpl extends Admin {
  _AdminImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    _i2.User? user,
    required String title,
    String? department,
    bool? isActive,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         user: user,
         title: title,
         department: department,
         isActive: isActive,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Admin]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Admin copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    Object? user = _Undefined,
    String? title,
    Object? department = _Undefined,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Admin(
      id: id is _i1.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _i2.User? ? user : this.user?.copyWith(),
      title: title ?? this.title,
      department: department is String? ? department : this.department,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AdminUpdateTable extends _i1.UpdateTable<AdminTable> {
  AdminUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> department(String? value) => _i1.ColumnValue(
    table.department,
    value,
  );

  _i1.ColumnValue<bool, bool> isActive(bool value) => _i1.ColumnValue(
    table.isActive,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class AdminTable extends _i1.Table<_i1.UuidValue?> {
  AdminTable({super.tableRelation}) : super(tableName: 'admin') {
    updateTable = AdminUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    department = _i1.ColumnString(
      'department',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
      hasDefault: true,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final AdminUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  _i2.UserTable? _user;

  late final _i1.ColumnString title;

  late final _i1.ColumnString department;

  late final _i1.ColumnBool isActive;

  late final _i1.ColumnDateTime createdAt;

  _i2.UserTable get user {
    if (_user != null) return _user!;
    _user = _i1.createRelationTable(
      relationFieldName: 'user',
      field: Admin.t.userId,
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
    department,
    isActive,
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

class AdminInclude extends _i1.IncludeObject {
  AdminInclude._({_i2.UserInclude? user}) {
    _user = user;
  }

  _i2.UserInclude? _user;

  @override
  Map<String, _i1.Include?> get includes => {'user': _user};

  @override
  _i1.Table<_i1.UuidValue?> get table => Admin.t;
}

class AdminIncludeList extends _i1.IncludeList {
  AdminIncludeList._({
    _i1.WhereExpressionBuilder<AdminTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Admin.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => Admin.t;
}

class AdminRepository {
  const AdminRepository._();

  final attachRow = const AdminAttachRowRepository._();

  /// Returns a list of [Admin]s matching the given query parameters.
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
  Future<List<Admin>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AdminTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AdminTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AdminTable>? orderByList,
    _i1.Transaction? transaction,
    AdminInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Admin>(
      where: where?.call(Admin.t),
      orderBy: orderBy?.call(Admin.t),
      orderByList: orderByList?.call(Admin.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Admin] matching the given query parameters.
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
  Future<Admin?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AdminTable>? where,
    int? offset,
    _i1.OrderByBuilder<AdminTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AdminTable>? orderByList,
    _i1.Transaction? transaction,
    AdminInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Admin>(
      where: where?.call(Admin.t),
      orderBy: orderBy?.call(Admin.t),
      orderByList: orderByList?.call(Admin.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Admin] by its [id] or null if no such row exists.
  Future<Admin?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    AdminInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Admin>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Admin]s in the list and returns the inserted rows.
  ///
  /// The returned [Admin]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Admin>> insert(
    _i1.DatabaseSession session,
    List<Admin> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Admin>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Admin] and returns the inserted row.
  ///
  /// The returned [Admin] will have its `id` field set.
  Future<Admin> insertRow(
    _i1.DatabaseSession session,
    Admin row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Admin>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Admin]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Admin>> update(
    _i1.DatabaseSession session,
    List<Admin> rows, {
    _i1.ColumnSelections<AdminTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Admin>(
      rows,
      columns: columns?.call(Admin.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Admin]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Admin> updateRow(
    _i1.DatabaseSession session,
    Admin row, {
    _i1.ColumnSelections<AdminTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Admin>(
      row,
      columns: columns?.call(Admin.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Admin] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Admin?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<AdminUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Admin>(
      id,
      columnValues: columnValues(Admin.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Admin]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Admin>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AdminUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AdminTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AdminTable>? orderBy,
    _i1.OrderByListBuilder<AdminTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Admin>(
      columnValues: columnValues(Admin.t.updateTable),
      where: where(Admin.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Admin.t),
      orderByList: orderByList?.call(Admin.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Admin]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Admin>> delete(
    _i1.DatabaseSession session,
    List<Admin> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Admin>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Admin].
  Future<Admin> deleteRow(
    _i1.DatabaseSession session,
    Admin row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Admin>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Admin>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AdminTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Admin>(
      where: where(Admin.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AdminTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Admin>(
      where: where?.call(Admin.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Admin] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AdminTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Admin>(
      where: where(Admin.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class AdminAttachRowRepository {
  const AdminAttachRowRepository._();

  /// Creates a relation between the given [Admin] and [User]
  /// by setting the [Admin]'s foreign key `userId` to refer to the [User].
  Future<void> user(
    _i1.DatabaseSession session,
    Admin admin,
    _i2.User user, {
    _i1.Transaction? transaction,
  }) async {
    if (admin.id == null) {
      throw ArgumentError.notNull('admin.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $admin = admin.copyWith(userId: user.id);
    await session.db.updateRow<Admin>(
      $admin,
      columns: [Admin.t.userId],
      transaction: transaction,
    );
  }
}
