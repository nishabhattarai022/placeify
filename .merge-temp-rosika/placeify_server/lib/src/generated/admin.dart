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
import 'admin_type.dart' as _i2;
import 'user.dart' as _i3;
import 'package:placeify_server/src/generated/protocol.dart' as _i4;

/// Platform administrator profile linked 1:1 to a User account.
/// Audit actions (approve, remove, resolve) reference this table's id, not user.id.
abstract class Admin
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  Admin._({
    this.id,
    required this.userId,
    this.user,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    _i2.AdminType? adminType,
    bool? isActive,
    this.lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : adminType = adminType ?? _i2.AdminType.moderator,
       isActive = isActive ?? true,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Admin({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    _i3.User? user,
    required String fullName,
    required String email,
    String? phoneNumber,
    _i2.AdminType? adminType,
    bool? isActive,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AdminImpl;

  factory Admin.fromJson(Map<String, dynamic> jsonSerialization) {
    return Admin(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      user: jsonSerialization['user'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.User>(jsonSerialization['user']),
      fullName: jsonSerialization['fullName'] as String,
      email: jsonSerialization['email'] as String,
      phoneNumber: jsonSerialization['phoneNumber'] as String?,
      adminType: jsonSerialization['adminType'] == null
          ? null
          : _i2.AdminType.fromJson((jsonSerialization['adminType'] as String)),
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      lastLoginAt: jsonSerialization['lastLoginAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastLoginAt'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = AdminTable();

  static const db = AdminRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue userId;

  _i3.User? user;

  String fullName;

  String email;

  String? phoneNumber;

  _i2.AdminType adminType;

  bool isActive;

  DateTime? lastLoginAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [Admin]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Admin copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    _i3.User? user,
    String? fullName,
    String? email,
    String? phoneNumber,
    _i2.AdminType? adminType,
    bool? isActive,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Admin',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      if (user != null) 'user': user?.toJson(),
      'fullName': fullName,
      'email': email,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      'adminType': adminType.toJson(),
      'isActive': isActive,
      if (lastLoginAt != null) 'lastLoginAt': lastLoginAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Admin',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      if (user != null) 'user': user?.toJsonForProtocol(),
      'fullName': fullName,
      'email': email,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      'adminType': adminType.toJson(),
      'isActive': isActive,
      if (lastLoginAt != null) 'lastLoginAt': lastLoginAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static AdminInclude include({_i3.UserInclude? user}) {
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
    _i3.User? user,
    required String fullName,
    required String email,
    String? phoneNumber,
    _i2.AdminType? adminType,
    bool? isActive,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         user: user,
         fullName: fullName,
         email: email,
         phoneNumber: phoneNumber,
         adminType: adminType,
         isActive: isActive,
         lastLoginAt: lastLoginAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Admin]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Admin copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    Object? user = _Undefined,
    String? fullName,
    String? email,
    Object? phoneNumber = _Undefined,
    _i2.AdminType? adminType,
    bool? isActive,
    Object? lastLoginAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Admin(
      id: id is _i1.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _i3.User? ? user : this.user?.copyWith(),
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber is String? ? phoneNumber : this.phoneNumber,
      adminType: adminType ?? this.adminType,
      isActive: isActive ?? this.isActive,
      lastLoginAt: lastLoginAt is DateTime? ? lastLoginAt : this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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

  _i1.ColumnValue<String, String> fullName(String value) => _i1.ColumnValue(
    table.fullName,
    value,
  );

  _i1.ColumnValue<String, String> email(String value) => _i1.ColumnValue(
    table.email,
    value,
  );

  _i1.ColumnValue<String, String> phoneNumber(String? value) => _i1.ColumnValue(
    table.phoneNumber,
    value,
  );

  _i1.ColumnValue<_i2.AdminType, _i2.AdminType> adminType(
    _i2.AdminType value,
  ) => _i1.ColumnValue(
    table.adminType,
    value,
  );

  _i1.ColumnValue<bool, bool> isActive(bool value) => _i1.ColumnValue(
    table.isActive,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> lastLoginAt(DateTime? value) =>
      _i1.ColumnValue(
        table.lastLoginAt,
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

class AdminTable extends _i1.Table<_i1.UuidValue?> {
  AdminTable({super.tableRelation}) : super(tableName: 'admin') {
    updateTable = AdminUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    fullName = _i1.ColumnString(
      'fullName',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    phoneNumber = _i1.ColumnString(
      'phoneNumber',
      this,
    );
    adminType = _i1.ColumnEnum(
      'adminType',
      this,
      _i1.EnumSerialization.byName,
      hasDefault: true,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
      hasDefault: true,
    );
    lastLoginAt = _i1.ColumnDateTime(
      'lastLoginAt',
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

  late final AdminUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  _i3.UserTable? _user;

  late final _i1.ColumnString fullName;

  late final _i1.ColumnString email;

  late final _i1.ColumnString phoneNumber;

  late final _i1.ColumnEnum<_i2.AdminType> adminType;

  late final _i1.ColumnBool isActive;

  late final _i1.ColumnDateTime lastLoginAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  _i3.UserTable get user {
    if (_user != null) return _user!;
    _user = _i1.createRelationTable(
      relationFieldName: 'user',
      field: Admin.t.userId,
      foreignField: _i3.User.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.UserTable(tableRelation: foreignTableRelation),
    );
    return _user!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    fullName,
    email,
    phoneNumber,
    adminType,
    isActive,
    lastLoginAt,
    createdAt,
    updatedAt,
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
  AdminInclude._({_i3.UserInclude? user}) {
    _user = user;
  }

  _i3.UserInclude? _user;

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
    _i3.User user, {
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
