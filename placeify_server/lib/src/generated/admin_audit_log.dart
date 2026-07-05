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
import 'admin.dart' as _i2;
import 'admin_action_type.dart' as _i3;
import 'package:placeify_server/src/generated/protocol.dart' as _i4;

/// Immutable audit record for admin actions.
abstract class AdminAuditLog
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  AdminAuditLog._({
    this.id,
    required this.actorAdminId,
    this.actorAdmin,
    required this.actionType,
    this.targetUserId,
    this.targetVendorId,
    this.targetProductId,
    this.targetComplaintId,
    this.targetPayoutId,
    this.targetRefundId,
    this.previousStatus,
    this.newStatus,
    this.reason,
    this.note,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory AdminAuditLog({
    _i1.UuidValue? id,
    required _i1.UuidValue actorAdminId,
    _i2.Admin? actorAdmin,
    required _i3.AdminActionType actionType,
    _i1.UuidValue? targetUserId,
    _i1.UuidValue? targetVendorId,
    int? targetProductId,
    _i1.UuidValue? targetComplaintId,
    int? targetPayoutId,
    int? targetRefundId,
    String? previousStatus,
    String? newStatus,
    String? reason,
    String? note,
    DateTime? createdAt,
  }) = _AdminAuditLogImpl;

  factory AdminAuditLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminAuditLog(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      actorAdminId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['actorAdminId'],
      ),
      actorAdmin: jsonSerialization['actorAdmin'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.Admin>(
              jsonSerialization['actorAdmin'],
            ),
      actionType: _i3.AdminActionType.fromJson(
        (jsonSerialization['actionType'] as String),
      ),
      targetUserId: jsonSerialization['targetUserId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['targetUserId'],
            ),
      targetVendorId: jsonSerialization['targetVendorId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['targetVendorId'],
            ),
      targetProductId: jsonSerialization['targetProductId'] as int?,
      targetComplaintId: jsonSerialization['targetComplaintId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['targetComplaintId'],
            ),
      targetPayoutId: jsonSerialization['targetPayoutId'] as int?,
      targetRefundId: jsonSerialization['targetRefundId'] as int?,
      previousStatus: jsonSerialization['previousStatus'] as String?,
      newStatus: jsonSerialization['newStatus'] as String?,
      reason: jsonSerialization['reason'] as String?,
      note: jsonSerialization['note'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = AdminAuditLogTable();

  static const db = AdminAuditLogRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue actorAdminId;

  _i2.Admin? actorAdmin;

  _i3.AdminActionType actionType;

  _i1.UuidValue? targetUserId;

  _i1.UuidValue? targetVendorId;

  int? targetProductId;

  _i1.UuidValue? targetComplaintId;

  int? targetPayoutId;

  int? targetRefundId;

  String? previousStatus;

  String? newStatus;

  String? reason;

  String? note;

  DateTime createdAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [AdminAuditLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AdminAuditLog copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? actorAdminId,
    _i2.Admin? actorAdmin,
    _i3.AdminActionType? actionType,
    _i1.UuidValue? targetUserId,
    _i1.UuidValue? targetVendorId,
    int? targetProductId,
    _i1.UuidValue? targetComplaintId,
    int? targetPayoutId,
    int? targetRefundId,
    String? previousStatus,
    String? newStatus,
    String? reason,
    String? note,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminAuditLog',
      if (id != null) 'id': id?.toJson(),
      'actorAdminId': actorAdminId.toJson(),
      if (actorAdmin != null) 'actorAdmin': actorAdmin?.toJson(),
      'actionType': actionType.toJson(),
      if (targetUserId != null) 'targetUserId': targetUserId?.toJson(),
      if (targetVendorId != null) 'targetVendorId': targetVendorId?.toJson(),
      if (targetProductId != null) 'targetProductId': targetProductId,
      if (targetComplaintId != null)
        'targetComplaintId': targetComplaintId?.toJson(),
      if (targetPayoutId != null) 'targetPayoutId': targetPayoutId,
      if (targetRefundId != null) 'targetRefundId': targetRefundId,
      if (previousStatus != null) 'previousStatus': previousStatus,
      if (newStatus != null) 'newStatus': newStatus,
      if (reason != null) 'reason': reason,
      if (note != null) 'note': note,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminAuditLog',
      if (id != null) 'id': id?.toJson(),
      'actorAdminId': actorAdminId.toJson(),
      if (actorAdmin != null) 'actorAdmin': actorAdmin?.toJsonForProtocol(),
      'actionType': actionType.toJson(),
      if (targetUserId != null) 'targetUserId': targetUserId?.toJson(),
      if (targetVendorId != null) 'targetVendorId': targetVendorId?.toJson(),
      if (targetProductId != null) 'targetProductId': targetProductId,
      if (targetComplaintId != null)
        'targetComplaintId': targetComplaintId?.toJson(),
      if (targetPayoutId != null) 'targetPayoutId': targetPayoutId,
      if (targetRefundId != null) 'targetRefundId': targetRefundId,
      if (previousStatus != null) 'previousStatus': previousStatus,
      if (newStatus != null) 'newStatus': newStatus,
      if (reason != null) 'reason': reason,
      if (note != null) 'note': note,
      'createdAt': createdAt.toJson(),
    };
  }

  static AdminAuditLogInclude include({_i2.AdminInclude? actorAdmin}) {
    return AdminAuditLogInclude._(actorAdmin: actorAdmin);
  }

  static AdminAuditLogIncludeList includeList({
    _i1.WhereExpressionBuilder<AdminAuditLogTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AdminAuditLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AdminAuditLogTable>? orderByList,
    AdminAuditLogInclude? include,
  }) {
    return AdminAuditLogIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AdminAuditLog.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AdminAuditLog.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminAuditLogImpl extends AdminAuditLog {
  _AdminAuditLogImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue actorAdminId,
    _i2.Admin? actorAdmin,
    required _i3.AdminActionType actionType,
    _i1.UuidValue? targetUserId,
    _i1.UuidValue? targetVendorId,
    int? targetProductId,
    _i1.UuidValue? targetComplaintId,
    int? targetPayoutId,
    int? targetRefundId,
    String? previousStatus,
    String? newStatus,
    String? reason,
    String? note,
    DateTime? createdAt,
  }) : super._(
         id: id,
         actorAdminId: actorAdminId,
         actorAdmin: actorAdmin,
         actionType: actionType,
         targetUserId: targetUserId,
         targetVendorId: targetVendorId,
         targetProductId: targetProductId,
         targetComplaintId: targetComplaintId,
         targetPayoutId: targetPayoutId,
         targetRefundId: targetRefundId,
         previousStatus: previousStatus,
         newStatus: newStatus,
         reason: reason,
         note: note,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AdminAuditLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AdminAuditLog copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? actorAdminId,
    Object? actorAdmin = _Undefined,
    _i3.AdminActionType? actionType,
    Object? targetUserId = _Undefined,
    Object? targetVendorId = _Undefined,
    Object? targetProductId = _Undefined,
    Object? targetComplaintId = _Undefined,
    Object? targetPayoutId = _Undefined,
    Object? targetRefundId = _Undefined,
    Object? previousStatus = _Undefined,
    Object? newStatus = _Undefined,
    Object? reason = _Undefined,
    Object? note = _Undefined,
    DateTime? createdAt,
  }) {
    return AdminAuditLog(
      id: id is _i1.UuidValue? ? id : this.id,
      actorAdminId: actorAdminId ?? this.actorAdminId,
      actorAdmin: actorAdmin is _i2.Admin?
          ? actorAdmin
          : this.actorAdmin?.copyWith(),
      actionType: actionType ?? this.actionType,
      targetUserId: targetUserId is _i1.UuidValue?
          ? targetUserId
          : this.targetUserId,
      targetVendorId: targetVendorId is _i1.UuidValue?
          ? targetVendorId
          : this.targetVendorId,
      targetProductId: targetProductId is int?
          ? targetProductId
          : this.targetProductId,
      targetComplaintId: targetComplaintId is _i1.UuidValue?
          ? targetComplaintId
          : this.targetComplaintId,
      targetPayoutId: targetPayoutId is int?
          ? targetPayoutId
          : this.targetPayoutId,
      targetRefundId: targetRefundId is int?
          ? targetRefundId
          : this.targetRefundId,
      previousStatus: previousStatus is String?
          ? previousStatus
          : this.previousStatus,
      newStatus: newStatus is String? ? newStatus : this.newStatus,
      reason: reason is String? ? reason : this.reason,
      note: note is String? ? note : this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AdminAuditLogUpdateTable extends _i1.UpdateTable<AdminAuditLogTable> {
  AdminAuditLogUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> actorAdminId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.actorAdminId,
    value,
  );

  _i1.ColumnValue<_i3.AdminActionType, _i3.AdminActionType> actionType(
    _i3.AdminActionType value,
  ) => _i1.ColumnValue(
    table.actionType,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> targetUserId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.targetUserId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> targetVendorId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.targetVendorId,
    value,
  );

  _i1.ColumnValue<int, int> targetProductId(int? value) => _i1.ColumnValue(
    table.targetProductId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> targetComplaintId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.targetComplaintId,
    value,
  );

  _i1.ColumnValue<int, int> targetPayoutId(int? value) => _i1.ColumnValue(
    table.targetPayoutId,
    value,
  );

  _i1.ColumnValue<int, int> targetRefundId(int? value) => _i1.ColumnValue(
    table.targetRefundId,
    value,
  );

  _i1.ColumnValue<String, String> previousStatus(String? value) =>
      _i1.ColumnValue(
        table.previousStatus,
        value,
      );

  _i1.ColumnValue<String, String> newStatus(String? value) => _i1.ColumnValue(
    table.newStatus,
    value,
  );

  _i1.ColumnValue<String, String> reason(String? value) => _i1.ColumnValue(
    table.reason,
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
}

class AdminAuditLogTable extends _i1.Table<_i1.UuidValue?> {
  AdminAuditLogTable({super.tableRelation})
    : super(tableName: 'admin_audit_log') {
    updateTable = AdminAuditLogUpdateTable(this);
    actorAdminId = _i1.ColumnUuid(
      'actorAdminId',
      this,
    );
    actionType = _i1.ColumnEnum(
      'actionType',
      this,
      _i1.EnumSerialization.byName,
    );
    targetUserId = _i1.ColumnUuid(
      'targetUserId',
      this,
    );
    targetVendorId = _i1.ColumnUuid(
      'targetVendorId',
      this,
    );
    targetProductId = _i1.ColumnInt(
      'targetProductId',
      this,
    );
    targetComplaintId = _i1.ColumnUuid(
      'targetComplaintId',
      this,
    );
    targetPayoutId = _i1.ColumnInt(
      'targetPayoutId',
      this,
    );
    targetRefundId = _i1.ColumnInt(
      'targetRefundId',
      this,
    );
    previousStatus = _i1.ColumnString(
      'previousStatus',
      this,
    );
    newStatus = _i1.ColumnString(
      'newStatus',
      this,
    );
    reason = _i1.ColumnString(
      'reason',
      this,
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
  }

  late final AdminAuditLogUpdateTable updateTable;

  late final _i1.ColumnUuid actorAdminId;

  _i2.AdminTable? _actorAdmin;

  late final _i1.ColumnEnum<_i3.AdminActionType> actionType;

  late final _i1.ColumnUuid targetUserId;

  late final _i1.ColumnUuid targetVendorId;

  late final _i1.ColumnInt targetProductId;

  late final _i1.ColumnUuid targetComplaintId;

  late final _i1.ColumnInt targetPayoutId;

  late final _i1.ColumnInt targetRefundId;

  late final _i1.ColumnString previousStatus;

  late final _i1.ColumnString newStatus;

  late final _i1.ColumnString reason;

  late final _i1.ColumnString note;

  late final _i1.ColumnDateTime createdAt;

  _i2.AdminTable get actorAdmin {
    if (_actorAdmin != null) return _actorAdmin!;
    _actorAdmin = _i1.createRelationTable(
      relationFieldName: 'actorAdmin',
      field: AdminAuditLog.t.actorAdminId,
      foreignField: _i2.Admin.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.AdminTable(tableRelation: foreignTableRelation),
    );
    return _actorAdmin!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    actorAdminId,
    actionType,
    targetUserId,
    targetVendorId,
    targetProductId,
    targetComplaintId,
    targetPayoutId,
    targetRefundId,
    previousStatus,
    newStatus,
    reason,
    note,
    createdAt,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'actorAdmin') {
      return actorAdmin;
    }
    return null;
  }
}

class AdminAuditLogInclude extends _i1.IncludeObject {
  AdminAuditLogInclude._({_i2.AdminInclude? actorAdmin}) {
    _actorAdmin = actorAdmin;
  }

  _i2.AdminInclude? _actorAdmin;

  @override
  Map<String, _i1.Include?> get includes => {'actorAdmin': _actorAdmin};

  @override
  _i1.Table<_i1.UuidValue?> get table => AdminAuditLog.t;
}

class AdminAuditLogIncludeList extends _i1.IncludeList {
  AdminAuditLogIncludeList._({
    _i1.WhereExpressionBuilder<AdminAuditLogTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AdminAuditLog.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => AdminAuditLog.t;
}

class AdminAuditLogRepository {
  const AdminAuditLogRepository._();

  final attachRow = const AdminAuditLogAttachRowRepository._();

  /// Returns a list of [AdminAuditLog]s matching the given query parameters.
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
  Future<List<AdminAuditLog>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AdminAuditLogTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AdminAuditLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AdminAuditLogTable>? orderByList,
    _i1.Transaction? transaction,
    AdminAuditLogInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AdminAuditLog>(
      where: where?.call(AdminAuditLog.t),
      orderBy: orderBy?.call(AdminAuditLog.t),
      orderByList: orderByList?.call(AdminAuditLog.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AdminAuditLog] matching the given query parameters.
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
  Future<AdminAuditLog?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AdminAuditLogTable>? where,
    int? offset,
    _i1.OrderByBuilder<AdminAuditLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AdminAuditLogTable>? orderByList,
    _i1.Transaction? transaction,
    AdminAuditLogInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AdminAuditLog>(
      where: where?.call(AdminAuditLog.t),
      orderBy: orderBy?.call(AdminAuditLog.t),
      orderByList: orderByList?.call(AdminAuditLog.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AdminAuditLog] by its [id] or null if no such row exists.
  Future<AdminAuditLog?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    AdminAuditLogInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AdminAuditLog>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AdminAuditLog]s in the list and returns the inserted rows.
  ///
  /// The returned [AdminAuditLog]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AdminAuditLog>> insert(
    _i1.DatabaseSession session,
    List<AdminAuditLog> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AdminAuditLog>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AdminAuditLog] and returns the inserted row.
  ///
  /// The returned [AdminAuditLog] will have its `id` field set.
  Future<AdminAuditLog> insertRow(
    _i1.DatabaseSession session,
    AdminAuditLog row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AdminAuditLog>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AdminAuditLog]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AdminAuditLog>> update(
    _i1.DatabaseSession session,
    List<AdminAuditLog> rows, {
    _i1.ColumnSelections<AdminAuditLogTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AdminAuditLog>(
      rows,
      columns: columns?.call(AdminAuditLog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AdminAuditLog]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AdminAuditLog> updateRow(
    _i1.DatabaseSession session,
    AdminAuditLog row, {
    _i1.ColumnSelections<AdminAuditLogTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AdminAuditLog>(
      row,
      columns: columns?.call(AdminAuditLog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AdminAuditLog] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AdminAuditLog?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<AdminAuditLogUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AdminAuditLog>(
      id,
      columnValues: columnValues(AdminAuditLog.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AdminAuditLog]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AdminAuditLog>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AdminAuditLogUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AdminAuditLogTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AdminAuditLogTable>? orderBy,
    _i1.OrderByListBuilder<AdminAuditLogTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AdminAuditLog>(
      columnValues: columnValues(AdminAuditLog.t.updateTable),
      where: where(AdminAuditLog.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AdminAuditLog.t),
      orderByList: orderByList?.call(AdminAuditLog.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AdminAuditLog]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AdminAuditLog>> delete(
    _i1.DatabaseSession session,
    List<AdminAuditLog> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AdminAuditLog>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AdminAuditLog].
  Future<AdminAuditLog> deleteRow(
    _i1.DatabaseSession session,
    AdminAuditLog row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AdminAuditLog>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AdminAuditLog>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AdminAuditLogTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AdminAuditLog>(
      where: where(AdminAuditLog.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AdminAuditLogTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AdminAuditLog>(
      where: where?.call(AdminAuditLog.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AdminAuditLog] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AdminAuditLogTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AdminAuditLog>(
      where: where(AdminAuditLog.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class AdminAuditLogAttachRowRepository {
  const AdminAuditLogAttachRowRepository._();

  /// Creates a relation between the given [AdminAuditLog] and [Admin]
  /// by setting the [AdminAuditLog]'s foreign key `actorAdminId` to refer to the [Admin].
  Future<void> actorAdmin(
    _i1.DatabaseSession session,
    AdminAuditLog adminAuditLog,
    _i2.Admin actorAdmin, {
    _i1.Transaction? transaction,
  }) async {
    if (adminAuditLog.id == null) {
      throw ArgumentError.notNull('adminAuditLog.id');
    }
    if (actorAdmin.id == null) {
      throw ArgumentError.notNull('actorAdmin.id');
    }

    var $adminAuditLog = adminAuditLog.copyWith(actorAdminId: actorAdmin.id);
    await session.db.updateRow<AdminAuditLog>(
      $adminAuditLog,
      columns: [AdminAuditLog.t.actorAdminId],
      transaction: transaction,
    );
  }
}
