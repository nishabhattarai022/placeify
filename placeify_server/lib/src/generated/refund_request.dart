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
import 'request_status.dart' as _i2;
import 'user.dart' as _i3;
import 'order.dart' as _i4;
import 'package:placeify_server/src/generated/protocol.dart' as _i5;

/// Customer refund or return request linked to an order.
abstract class RefundRequest
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  RefundRequest._({
    this.id,
    required this.userId,
    this.user,
    required this.orderId,
    this.order,
    required this.reason,
    _i2.RequestStatus? status,
    required this.refundAmount,
    this.rejectionReason,
    this.resolvedByUserId,
    this.gatewayStatus,
    this.gatewayReference,
    this.gatewayResponse,
    this.refundCompletedAt,
    this.lastGatewayCheckAt,
    this.settlementMode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : status = status ?? _i2.RequestStatus.pending,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory RefundRequest({
    int? id,
    required _i1.UuidValue userId,
    _i3.User? user,
    required int orderId,
    _i4.Order? order,
    required String reason,
    _i2.RequestStatus? status,
    required double refundAmount,
    String? rejectionReason,
    _i1.UuidValue? resolvedByUserId,
    String? gatewayStatus,
    String? gatewayReference,
    String? gatewayResponse,
    DateTime? refundCompletedAt,
    DateTime? lastGatewayCheckAt,
    String? settlementMode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _RefundRequestImpl;

  factory RefundRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return RefundRequest(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      user: jsonSerialization['user'] == null
          ? null
          : _i5.Protocol().deserialize<_i3.User>(jsonSerialization['user']),
      orderId: jsonSerialization['orderId'] as int,
      order: jsonSerialization['order'] == null
          ? null
          : _i5.Protocol().deserialize<_i4.Order>(jsonSerialization['order']),
      reason: jsonSerialization['reason'] as String,
      status: jsonSerialization['status'] == null
          ? null
          : _i2.RequestStatus.fromJson((jsonSerialization['status'] as String)),
      refundAmount: (jsonSerialization['refundAmount'] as num).toDouble(),
      rejectionReason: jsonSerialization['rejectionReason'] as String?,
      resolvedByUserId: jsonSerialization['resolvedByUserId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['resolvedByUserId'],
            ),
      gatewayStatus: jsonSerialization['gatewayStatus'] as String?,
      gatewayReference: jsonSerialization['gatewayReference'] as String?,
      gatewayResponse: jsonSerialization['gatewayResponse'] as String?,
      refundCompletedAt: jsonSerialization['refundCompletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['refundCompletedAt'],
            ),
      lastGatewayCheckAt: jsonSerialization['lastGatewayCheckAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastGatewayCheckAt'],
            ),
      settlementMode: jsonSerialization['settlementMode'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = RefundRequestTable();

  static const db = RefundRequestRepository._();

  @override
  int? id;

  _i1.UuidValue userId;

  _i3.User? user;

  int orderId;

  _i4.Order? order;

  String reason;

  _i2.RequestStatus status;

  double refundAmount;

  String? rejectionReason;

  _i1.UuidValue? resolvedByUserId;

  String? gatewayStatus;

  String? gatewayReference;

  String? gatewayResponse;

  DateTime? refundCompletedAt;

  DateTime? lastGatewayCheckAt;

  /// manual_portal | auto_api (future Mode A)
  String? settlementMode;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [RefundRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RefundRequest copyWith({
    int? id,
    _i1.UuidValue? userId,
    _i3.User? user,
    int? orderId,
    _i4.Order? order,
    String? reason,
    _i2.RequestStatus? status,
    double? refundAmount,
    String? rejectionReason,
    _i1.UuidValue? resolvedByUserId,
    String? gatewayStatus,
    String? gatewayReference,
    String? gatewayResponse,
    DateTime? refundCompletedAt,
    DateTime? lastGatewayCheckAt,
    String? settlementMode,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RefundRequest',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      if (user != null) 'user': user?.toJson(),
      'orderId': orderId,
      if (order != null) 'order': order?.toJson(),
      'reason': reason,
      'status': status.toJson(),
      'refundAmount': refundAmount,
      if (rejectionReason != null) 'rejectionReason': rejectionReason,
      if (resolvedByUserId != null)
        'resolvedByUserId': resolvedByUserId?.toJson(),
      if (gatewayStatus != null) 'gatewayStatus': gatewayStatus,
      if (gatewayReference != null) 'gatewayReference': gatewayReference,
      if (gatewayResponse != null) 'gatewayResponse': gatewayResponse,
      if (refundCompletedAt != null)
        'refundCompletedAt': refundCompletedAt?.toJson(),
      if (lastGatewayCheckAt != null)
        'lastGatewayCheckAt': lastGatewayCheckAt?.toJson(),
      if (settlementMode != null) 'settlementMode': settlementMode,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RefundRequest',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      if (user != null) 'user': user?.toJsonForProtocol(),
      'orderId': orderId,
      if (order != null) 'order': order?.toJsonForProtocol(),
      'reason': reason,
      'status': status.toJson(),
      'refundAmount': refundAmount,
      if (rejectionReason != null) 'rejectionReason': rejectionReason,
      if (resolvedByUserId != null)
        'resolvedByUserId': resolvedByUserId?.toJson(),
      if (gatewayStatus != null) 'gatewayStatus': gatewayStatus,
      if (gatewayReference != null) 'gatewayReference': gatewayReference,
      if (gatewayResponse != null) 'gatewayResponse': gatewayResponse,
      if (refundCompletedAt != null)
        'refundCompletedAt': refundCompletedAt?.toJson(),
      if (lastGatewayCheckAt != null)
        'lastGatewayCheckAt': lastGatewayCheckAt?.toJson(),
      if (settlementMode != null) 'settlementMode': settlementMode,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static RefundRequestInclude include({
    _i3.UserInclude? user,
    _i4.OrderInclude? order,
  }) {
    return RefundRequestInclude._(
      user: user,
      order: order,
    );
  }

  static RefundRequestIncludeList includeList({
    _i1.WhereExpressionBuilder<RefundRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RefundRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RefundRequestTable>? orderByList,
    RefundRequestInclude? include,
  }) {
    return RefundRequestIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RefundRequest.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RefundRequest.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RefundRequestImpl extends RefundRequest {
  _RefundRequestImpl({
    int? id,
    required _i1.UuidValue userId,
    _i3.User? user,
    required int orderId,
    _i4.Order? order,
    required String reason,
    _i2.RequestStatus? status,
    required double refundAmount,
    String? rejectionReason,
    _i1.UuidValue? resolvedByUserId,
    String? gatewayStatus,
    String? gatewayReference,
    String? gatewayResponse,
    DateTime? refundCompletedAt,
    DateTime? lastGatewayCheckAt,
    String? settlementMode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         user: user,
         orderId: orderId,
         order: order,
         reason: reason,
         status: status,
         refundAmount: refundAmount,
         rejectionReason: rejectionReason,
         resolvedByUserId: resolvedByUserId,
         gatewayStatus: gatewayStatus,
         gatewayReference: gatewayReference,
         gatewayResponse: gatewayResponse,
         refundCompletedAt: refundCompletedAt,
         lastGatewayCheckAt: lastGatewayCheckAt,
         settlementMode: settlementMode,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [RefundRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RefundRequest copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    Object? user = _Undefined,
    int? orderId,
    Object? order = _Undefined,
    String? reason,
    _i2.RequestStatus? status,
    double? refundAmount,
    Object? rejectionReason = _Undefined,
    Object? resolvedByUserId = _Undefined,
    Object? gatewayStatus = _Undefined,
    Object? gatewayReference = _Undefined,
    Object? gatewayResponse = _Undefined,
    Object? refundCompletedAt = _Undefined,
    Object? lastGatewayCheckAt = _Undefined,
    Object? settlementMode = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RefundRequest(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _i3.User? ? user : this.user?.copyWith(),
      orderId: orderId ?? this.orderId,
      order: order is _i4.Order? ? order : this.order?.copyWith(),
      reason: reason ?? this.reason,
      status: status ?? this.status,
      refundAmount: refundAmount ?? this.refundAmount,
      rejectionReason: rejectionReason is String?
          ? rejectionReason
          : this.rejectionReason,
      resolvedByUserId: resolvedByUserId is _i1.UuidValue?
          ? resolvedByUserId
          : this.resolvedByUserId,
      gatewayStatus: gatewayStatus is String?
          ? gatewayStatus
          : this.gatewayStatus,
      gatewayReference: gatewayReference is String?
          ? gatewayReference
          : this.gatewayReference,
      gatewayResponse: gatewayResponse is String?
          ? gatewayResponse
          : this.gatewayResponse,
      refundCompletedAt: refundCompletedAt is DateTime?
          ? refundCompletedAt
          : this.refundCompletedAt,
      lastGatewayCheckAt: lastGatewayCheckAt is DateTime?
          ? lastGatewayCheckAt
          : this.lastGatewayCheckAt,
      settlementMode: settlementMode is String?
          ? settlementMode
          : this.settlementMode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class RefundRequestUpdateTable extends _i1.UpdateTable<RefundRequestTable> {
  RefundRequestUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<int, int> orderId(int value) => _i1.ColumnValue(
    table.orderId,
    value,
  );

  _i1.ColumnValue<String, String> reason(String value) => _i1.ColumnValue(
    table.reason,
    value,
  );

  _i1.ColumnValue<_i2.RequestStatus, _i2.RequestStatus> status(
    _i2.RequestStatus value,
  ) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<double, double> refundAmount(double value) => _i1.ColumnValue(
    table.refundAmount,
    value,
  );

  _i1.ColumnValue<String, String> rejectionReason(String? value) =>
      _i1.ColumnValue(
        table.rejectionReason,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> resolvedByUserId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.resolvedByUserId,
    value,
  );

  _i1.ColumnValue<String, String> gatewayStatus(String? value) =>
      _i1.ColumnValue(
        table.gatewayStatus,
        value,
      );

  _i1.ColumnValue<String, String> gatewayReference(String? value) =>
      _i1.ColumnValue(
        table.gatewayReference,
        value,
      );

  _i1.ColumnValue<String, String> gatewayResponse(String? value) =>
      _i1.ColumnValue(
        table.gatewayResponse,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> refundCompletedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.refundCompletedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> lastGatewayCheckAt(DateTime? value) =>
      _i1.ColumnValue(
        table.lastGatewayCheckAt,
        value,
      );

  _i1.ColumnValue<String, String> settlementMode(String? value) =>
      _i1.ColumnValue(
        table.settlementMode,
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

class RefundRequestTable extends _i1.Table<int?> {
  RefundRequestTable({super.tableRelation})
    : super(tableName: 'refund_request') {
    updateTable = RefundRequestUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    orderId = _i1.ColumnInt(
      'orderId',
      this,
    );
    reason = _i1.ColumnString(
      'reason',
      this,
    );
    status = _i1.ColumnEnum(
      'status',
      this,
      _i1.EnumSerialization.byName,
      hasDefault: true,
    );
    refundAmount = _i1.ColumnDouble(
      'refundAmount',
      this,
    );
    rejectionReason = _i1.ColumnString(
      'rejectionReason',
      this,
    );
    resolvedByUserId = _i1.ColumnUuid(
      'resolvedByUserId',
      this,
    );
    gatewayStatus = _i1.ColumnString(
      'gatewayStatus',
      this,
    );
    gatewayReference = _i1.ColumnString(
      'gatewayReference',
      this,
    );
    gatewayResponse = _i1.ColumnString(
      'gatewayResponse',
      this,
    );
    refundCompletedAt = _i1.ColumnDateTime(
      'refundCompletedAt',
      this,
    );
    lastGatewayCheckAt = _i1.ColumnDateTime(
      'lastGatewayCheckAt',
      this,
    );
    settlementMode = _i1.ColumnString(
      'settlementMode',
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

  late final RefundRequestUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  _i3.UserTable? _user;

  late final _i1.ColumnInt orderId;

  _i4.OrderTable? _order;

  late final _i1.ColumnString reason;

  late final _i1.ColumnEnum<_i2.RequestStatus> status;

  late final _i1.ColumnDouble refundAmount;

  late final _i1.ColumnString rejectionReason;

  late final _i1.ColumnUuid resolvedByUserId;

  late final _i1.ColumnString gatewayStatus;

  late final _i1.ColumnString gatewayReference;

  late final _i1.ColumnString gatewayResponse;

  late final _i1.ColumnDateTime refundCompletedAt;

  late final _i1.ColumnDateTime lastGatewayCheckAt;

  /// manual_portal | auto_api (future Mode A)
  late final _i1.ColumnString settlementMode;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  _i3.UserTable get user {
    if (_user != null) return _user!;
    _user = _i1.createRelationTable(
      relationFieldName: 'user',
      field: RefundRequest.t.userId,
      foreignField: _i3.User.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.UserTable(tableRelation: foreignTableRelation),
    );
    return _user!;
  }

  _i4.OrderTable get order {
    if (_order != null) return _order!;
    _order = _i1.createRelationTable(
      relationFieldName: 'order',
      field: RefundRequest.t.orderId,
      foreignField: _i4.Order.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.OrderTable(tableRelation: foreignTableRelation),
    );
    return _order!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    orderId,
    reason,
    status,
    refundAmount,
    rejectionReason,
    resolvedByUserId,
    gatewayStatus,
    gatewayReference,
    gatewayResponse,
    refundCompletedAt,
    lastGatewayCheckAt,
    settlementMode,
    createdAt,
    updatedAt,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'user') {
      return user;
    }
    if (relationField == 'order') {
      return order;
    }
    return null;
  }
}

class RefundRequestInclude extends _i1.IncludeObject {
  RefundRequestInclude._({
    _i3.UserInclude? user,
    _i4.OrderInclude? order,
  }) {
    _user = user;
    _order = order;
  }

  _i3.UserInclude? _user;

  _i4.OrderInclude? _order;

  @override
  Map<String, _i1.Include?> get includes => {
    'user': _user,
    'order': _order,
  };

  @override
  _i1.Table<int?> get table => RefundRequest.t;
}

class RefundRequestIncludeList extends _i1.IncludeList {
  RefundRequestIncludeList._({
    _i1.WhereExpressionBuilder<RefundRequestTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RefundRequest.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => RefundRequest.t;
}

class RefundRequestRepository {
  const RefundRequestRepository._();

  final attachRow = const RefundRequestAttachRowRepository._();

  /// Returns a list of [RefundRequest]s matching the given query parameters.
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
  Future<List<RefundRequest>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RefundRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RefundRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RefundRequestTable>? orderByList,
    _i1.Transaction? transaction,
    RefundRequestInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RefundRequest>(
      where: where?.call(RefundRequest.t),
      orderBy: orderBy?.call(RefundRequest.t),
      orderByList: orderByList?.call(RefundRequest.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RefundRequest] matching the given query parameters.
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
  Future<RefundRequest?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RefundRequestTable>? where,
    int? offset,
    _i1.OrderByBuilder<RefundRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RefundRequestTable>? orderByList,
    _i1.Transaction? transaction,
    RefundRequestInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RefundRequest>(
      where: where?.call(RefundRequest.t),
      orderBy: orderBy?.call(RefundRequest.t),
      orderByList: orderByList?.call(RefundRequest.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RefundRequest] by its [id] or null if no such row exists.
  Future<RefundRequest?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    RefundRequestInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RefundRequest>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RefundRequest]s in the list and returns the inserted rows.
  ///
  /// The returned [RefundRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<RefundRequest>> insert(
    _i1.DatabaseSession session,
    List<RefundRequest> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<RefundRequest>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [RefundRequest] and returns the inserted row.
  ///
  /// The returned [RefundRequest] will have its `id` field set.
  Future<RefundRequest> insertRow(
    _i1.DatabaseSession session,
    RefundRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RefundRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [RefundRequest]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<RefundRequest>> update(
    _i1.DatabaseSession session,
    List<RefundRequest> rows, {
    _i1.ColumnSelections<RefundRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RefundRequest>(
      rows,
      columns: columns?.call(RefundRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RefundRequest]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RefundRequest> updateRow(
    _i1.DatabaseSession session,
    RefundRequest row, {
    _i1.ColumnSelections<RefundRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RefundRequest>(
      row,
      columns: columns?.call(RefundRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RefundRequest] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RefundRequest?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<RefundRequestUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<RefundRequest>(
      id,
      columnValues: columnValues(RefundRequest.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RefundRequest]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<RefundRequest>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<RefundRequestUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<RefundRequestTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RefundRequestTable>? orderBy,
    _i1.OrderByListBuilder<RefundRequestTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<RefundRequest>(
      columnValues: columnValues(RefundRequest.t.updateTable),
      where: where(RefundRequest.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RefundRequest.t),
      orderByList: orderByList?.call(RefundRequest.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [RefundRequest]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<RefundRequest>> delete(
    _i1.DatabaseSession session,
    List<RefundRequest> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RefundRequest>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [RefundRequest].
  Future<RefundRequest> deleteRow(
    _i1.DatabaseSession session,
    RefundRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RefundRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<RefundRequest>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RefundRequestTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RefundRequest>(
      where: where(RefundRequest.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RefundRequestTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RefundRequest>(
      where: where?.call(RefundRequest.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RefundRequest] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RefundRequestTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RefundRequest>(
      where: where(RefundRequest.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class RefundRequestAttachRowRepository {
  const RefundRequestAttachRowRepository._();

  /// Creates a relation between the given [RefundRequest] and [User]
  /// by setting the [RefundRequest]'s foreign key `userId` to refer to the [User].
  Future<void> user(
    _i1.DatabaseSession session,
    RefundRequest refundRequest,
    _i3.User user, {
    _i1.Transaction? transaction,
  }) async {
    if (refundRequest.id == null) {
      throw ArgumentError.notNull('refundRequest.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $refundRequest = refundRequest.copyWith(userId: user.id);
    await session.db.updateRow<RefundRequest>(
      $refundRequest,
      columns: [RefundRequest.t.userId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [RefundRequest] and [Order]
  /// by setting the [RefundRequest]'s foreign key `orderId` to refer to the [Order].
  Future<void> order(
    _i1.DatabaseSession session,
    RefundRequest refundRequest,
    _i4.Order order, {
    _i1.Transaction? transaction,
  }) async {
    if (refundRequest.id == null) {
      throw ArgumentError.notNull('refundRequest.id');
    }
    if (order.id == null) {
      throw ArgumentError.notNull('order.id');
    }

    var $refundRequest = refundRequest.copyWith(orderId: order.id);
    await session.db.updateRow<RefundRequest>(
      $refundRequest,
      columns: [RefundRequest.t.orderId],
      transaction: transaction,
    );
  }
}
