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
import 'complaint_status.dart' as _i2;
import 'product.dart' as _i3;
import 'user.dart' as _i4;
import 'admin.dart' as _i5;
import 'package:placeify_server/src/generated/protocol.dart' as _i6;

/// Product complaint/damage report. Admins resolve these and may remove flagged products.
abstract class Complaint
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  Complaint._({
    this.id,
    required this.productId,
    this.product,
    required this.reportedById,
    this.reportedBy,
    required this.reason,
    this.description,
    _i2.ComplaintStatus? status,
    this.assignedToId,
    this.assignedTo,
    this.internalNote,
    this.resolvedById,
    this.resolvedBy,
    this.resolvedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : status = status ?? _i2.ComplaintStatus.pending,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Complaint({
    _i1.UuidValue? id,
    required int productId,
    _i3.Product? product,
    required _i1.UuidValue reportedById,
    _i4.User? reportedBy,
    required String reason,
    String? description,
    _i2.ComplaintStatus? status,
    _i1.UuidValue? assignedToId,
    _i5.Admin? assignedTo,
    String? internalNote,
    _i1.UuidValue? resolvedById,
    _i5.Admin? resolvedBy,
    DateTime? resolvedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ComplaintImpl;

  factory Complaint.fromJson(Map<String, dynamic> jsonSerialization) {
    return Complaint(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      productId: jsonSerialization['productId'] as int,
      product: jsonSerialization['product'] == null
          ? null
          : _i6.Protocol().deserialize<_i3.Product>(
              jsonSerialization['product'],
            ),
      reportedById: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['reportedById'],
      ),
      reportedBy: jsonSerialization['reportedBy'] == null
          ? null
          : _i6.Protocol().deserialize<_i4.User>(
              jsonSerialization['reportedBy'],
            ),
      reason: jsonSerialization['reason'] as String,
      description: jsonSerialization['description'] as String?,
      status: jsonSerialization['status'] == null
          ? null
          : _i2.ComplaintStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      assignedToId: jsonSerialization['assignedToId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['assignedToId'],
            ),
      assignedTo: jsonSerialization['assignedTo'] == null
          ? null
          : _i6.Protocol().deserialize<_i5.Admin>(
              jsonSerialization['assignedTo'],
            ),
      internalNote: jsonSerialization['internalNote'] as String?,
      resolvedById: jsonSerialization['resolvedById'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['resolvedById'],
            ),
      resolvedBy: jsonSerialization['resolvedBy'] == null
          ? null
          : _i6.Protocol().deserialize<_i5.Admin>(
              jsonSerialization['resolvedBy'],
            ),
      resolvedAt: jsonSerialization['resolvedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['resolvedAt']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = ComplaintTable();

  static const db = ComplaintRepository._();

  @override
  _i1.UuidValue? id;

  int productId;

  _i3.Product? product;

  _i1.UuidValue reportedById;

  _i4.User? reportedBy;

  String reason;

  String? description;

  _i2.ComplaintStatus status;

  _i1.UuidValue? assignedToId;

  /// Admin assigned to review this complaint.
  _i5.Admin? assignedTo;

  /// Internal admin-only notes (not visible to reporters).
  String? internalNote;

  _i1.UuidValue? resolvedById;

  /// Admin who marked this complaint resolved or rejected.
  _i5.Admin? resolvedBy;

  DateTime? resolvedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [Complaint]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Complaint copyWith({
    _i1.UuidValue? id,
    int? productId,
    _i3.Product? product,
    _i1.UuidValue? reportedById,
    _i4.User? reportedBy,
    String? reason,
    String? description,
    _i2.ComplaintStatus? status,
    _i1.UuidValue? assignedToId,
    _i5.Admin? assignedTo,
    String? internalNote,
    _i1.UuidValue? resolvedById,
    _i5.Admin? resolvedBy,
    DateTime? resolvedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Complaint',
      if (id != null) 'id': id?.toJson(),
      'productId': productId,
      if (product != null) 'product': product?.toJson(),
      'reportedById': reportedById.toJson(),
      if (reportedBy != null) 'reportedBy': reportedBy?.toJson(),
      'reason': reason,
      if (description != null) 'description': description,
      'status': status.toJson(),
      if (assignedToId != null) 'assignedToId': assignedToId?.toJson(),
      if (assignedTo != null) 'assignedTo': assignedTo?.toJson(),
      if (internalNote != null) 'internalNote': internalNote,
      if (resolvedById != null) 'resolvedById': resolvedById?.toJson(),
      if (resolvedBy != null) 'resolvedBy': resolvedBy?.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Complaint',
      if (id != null) 'id': id?.toJson(),
      'productId': productId,
      if (product != null) 'product': product?.toJsonForProtocol(),
      'reportedById': reportedById.toJson(),
      if (reportedBy != null) 'reportedBy': reportedBy?.toJsonForProtocol(),
      'reason': reason,
      if (description != null) 'description': description,
      'status': status.toJson(),
      if (assignedToId != null) 'assignedToId': assignedToId?.toJson(),
      if (assignedTo != null) 'assignedTo': assignedTo?.toJsonForProtocol(),
      if (internalNote != null) 'internalNote': internalNote,
      if (resolvedById != null) 'resolvedById': resolvedById?.toJson(),
      if (resolvedBy != null) 'resolvedBy': resolvedBy?.toJsonForProtocol(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static ComplaintInclude include({
    _i3.ProductInclude? product,
    _i4.UserInclude? reportedBy,
    _i5.AdminInclude? assignedTo,
    _i5.AdminInclude? resolvedBy,
  }) {
    return ComplaintInclude._(
      product: product,
      reportedBy: reportedBy,
      assignedTo: assignedTo,
      resolvedBy: resolvedBy,
    );
  }

  static ComplaintIncludeList includeList({
    _i1.WhereExpressionBuilder<ComplaintTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ComplaintTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ComplaintTable>? orderByList,
    ComplaintInclude? include,
  }) {
    return ComplaintIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Complaint.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Complaint.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ComplaintImpl extends Complaint {
  _ComplaintImpl({
    _i1.UuidValue? id,
    required int productId,
    _i3.Product? product,
    required _i1.UuidValue reportedById,
    _i4.User? reportedBy,
    required String reason,
    String? description,
    _i2.ComplaintStatus? status,
    _i1.UuidValue? assignedToId,
    _i5.Admin? assignedTo,
    String? internalNote,
    _i1.UuidValue? resolvedById,
    _i5.Admin? resolvedBy,
    DateTime? resolvedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         productId: productId,
         product: product,
         reportedById: reportedById,
         reportedBy: reportedBy,
         reason: reason,
         description: description,
         status: status,
         assignedToId: assignedToId,
         assignedTo: assignedTo,
         internalNote: internalNote,
         resolvedById: resolvedById,
         resolvedBy: resolvedBy,
         resolvedAt: resolvedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Complaint]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Complaint copyWith({
    Object? id = _Undefined,
    int? productId,
    Object? product = _Undefined,
    _i1.UuidValue? reportedById,
    Object? reportedBy = _Undefined,
    String? reason,
    Object? description = _Undefined,
    _i2.ComplaintStatus? status,
    Object? assignedToId = _Undefined,
    Object? assignedTo = _Undefined,
    Object? internalNote = _Undefined,
    Object? resolvedById = _Undefined,
    Object? resolvedBy = _Undefined,
    Object? resolvedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Complaint(
      id: id is _i1.UuidValue? ? id : this.id,
      productId: productId ?? this.productId,
      product: product is _i3.Product? ? product : this.product?.copyWith(),
      reportedById: reportedById ?? this.reportedById,
      reportedBy: reportedBy is _i4.User?
          ? reportedBy
          : this.reportedBy?.copyWith(),
      reason: reason ?? this.reason,
      description: description is String? ? description : this.description,
      status: status ?? this.status,
      assignedToId: assignedToId is _i1.UuidValue?
          ? assignedToId
          : this.assignedToId,
      assignedTo: assignedTo is _i5.Admin?
          ? assignedTo
          : this.assignedTo?.copyWith(),
      internalNote: internalNote is String? ? internalNote : this.internalNote,
      resolvedById: resolvedById is _i1.UuidValue?
          ? resolvedById
          : this.resolvedById,
      resolvedBy: resolvedBy is _i5.Admin?
          ? resolvedBy
          : this.resolvedBy?.copyWith(),
      resolvedAt: resolvedAt is DateTime? ? resolvedAt : this.resolvedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ComplaintUpdateTable extends _i1.UpdateTable<ComplaintTable> {
  ComplaintUpdateTable(super.table);

  _i1.ColumnValue<int, int> productId(int value) => _i1.ColumnValue(
    table.productId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> reportedById(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.reportedById,
    value,
  );

  _i1.ColumnValue<String, String> reason(String value) => _i1.ColumnValue(
    table.reason,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<_i2.ComplaintStatus, _i2.ComplaintStatus> status(
    _i2.ComplaintStatus value,
  ) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> assignedToId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.assignedToId,
    value,
  );

  _i1.ColumnValue<String, String> internalNote(String? value) =>
      _i1.ColumnValue(
        table.internalNote,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> resolvedById(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.resolvedById,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> resolvedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.resolvedAt,
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

class ComplaintTable extends _i1.Table<_i1.UuidValue?> {
  ComplaintTable({super.tableRelation}) : super(tableName: 'complaint') {
    updateTable = ComplaintUpdateTable(this);
    productId = _i1.ColumnInt(
      'productId',
      this,
    );
    reportedById = _i1.ColumnUuid(
      'reportedById',
      this,
    );
    reason = _i1.ColumnString(
      'reason',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    status = _i1.ColumnEnum(
      'status',
      this,
      _i1.EnumSerialization.byName,
      hasDefault: true,
    );
    assignedToId = _i1.ColumnUuid(
      'assignedToId',
      this,
    );
    internalNote = _i1.ColumnString(
      'internalNote',
      this,
    );
    resolvedById = _i1.ColumnUuid(
      'resolvedById',
      this,
    );
    resolvedAt = _i1.ColumnDateTime(
      'resolvedAt',
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

  late final ComplaintUpdateTable updateTable;

  late final _i1.ColumnInt productId;

  _i3.ProductTable? _product;

  late final _i1.ColumnUuid reportedById;

  _i4.UserTable? _reportedBy;

  late final _i1.ColumnString reason;

  late final _i1.ColumnString description;

  late final _i1.ColumnEnum<_i2.ComplaintStatus> status;

  late final _i1.ColumnUuid assignedToId;

  /// Admin assigned to review this complaint.
  _i5.AdminTable? _assignedTo;

  /// Internal admin-only notes (not visible to reporters).
  late final _i1.ColumnString internalNote;

  late final _i1.ColumnUuid resolvedById;

  /// Admin who marked this complaint resolved or rejected.
  _i5.AdminTable? _resolvedBy;

  late final _i1.ColumnDateTime resolvedAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  _i3.ProductTable get product {
    if (_product != null) return _product!;
    _product = _i1.createRelationTable(
      relationFieldName: 'product',
      field: Complaint.t.productId,
      foreignField: _i3.Product.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.ProductTable(tableRelation: foreignTableRelation),
    );
    return _product!;
  }

  _i4.UserTable get reportedBy {
    if (_reportedBy != null) return _reportedBy!;
    _reportedBy = _i1.createRelationTable(
      relationFieldName: 'reportedBy',
      field: Complaint.t.reportedById,
      foreignField: _i4.User.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.UserTable(tableRelation: foreignTableRelation),
    );
    return _reportedBy!;
  }

  _i5.AdminTable get assignedTo {
    if (_assignedTo != null) return _assignedTo!;
    _assignedTo = _i1.createRelationTable(
      relationFieldName: 'assignedTo',
      field: Complaint.t.assignedToId,
      foreignField: _i5.Admin.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i5.AdminTable(tableRelation: foreignTableRelation),
    );
    return _assignedTo!;
  }

  _i5.AdminTable get resolvedBy {
    if (_resolvedBy != null) return _resolvedBy!;
    _resolvedBy = _i1.createRelationTable(
      relationFieldName: 'resolvedBy',
      field: Complaint.t.resolvedById,
      foreignField: _i5.Admin.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i5.AdminTable(tableRelation: foreignTableRelation),
    );
    return _resolvedBy!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    productId,
    reportedById,
    reason,
    description,
    status,
    assignedToId,
    internalNote,
    resolvedById,
    resolvedAt,
    createdAt,
    updatedAt,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'product') {
      return product;
    }
    if (relationField == 'reportedBy') {
      return reportedBy;
    }
    if (relationField == 'assignedTo') {
      return assignedTo;
    }
    if (relationField == 'resolvedBy') {
      return resolvedBy;
    }
    return null;
  }
}

class ComplaintInclude extends _i1.IncludeObject {
  ComplaintInclude._({
    _i3.ProductInclude? product,
    _i4.UserInclude? reportedBy,
    _i5.AdminInclude? assignedTo,
    _i5.AdminInclude? resolvedBy,
  }) {
    _product = product;
    _reportedBy = reportedBy;
    _assignedTo = assignedTo;
    _resolvedBy = resolvedBy;
  }

  _i3.ProductInclude? _product;

  _i4.UserInclude? _reportedBy;

  _i5.AdminInclude? _assignedTo;

  _i5.AdminInclude? _resolvedBy;

  @override
  Map<String, _i1.Include?> get includes => {
    'product': _product,
    'reportedBy': _reportedBy,
    'assignedTo': _assignedTo,
    'resolvedBy': _resolvedBy,
  };

  @override
  _i1.Table<_i1.UuidValue?> get table => Complaint.t;
}

class ComplaintIncludeList extends _i1.IncludeList {
  ComplaintIncludeList._({
    _i1.WhereExpressionBuilder<ComplaintTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Complaint.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => Complaint.t;
}

class ComplaintRepository {
  const ComplaintRepository._();

  final attachRow = const ComplaintAttachRowRepository._();

  final detachRow = const ComplaintDetachRowRepository._();

  /// Returns a list of [Complaint]s matching the given query parameters.
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
  Future<List<Complaint>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ComplaintTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ComplaintTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ComplaintTable>? orderByList,
    _i1.Transaction? transaction,
    ComplaintInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Complaint>(
      where: where?.call(Complaint.t),
      orderBy: orderBy?.call(Complaint.t),
      orderByList: orderByList?.call(Complaint.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Complaint] matching the given query parameters.
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
  Future<Complaint?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ComplaintTable>? where,
    int? offset,
    _i1.OrderByBuilder<ComplaintTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ComplaintTable>? orderByList,
    _i1.Transaction? transaction,
    ComplaintInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Complaint>(
      where: where?.call(Complaint.t),
      orderBy: orderBy?.call(Complaint.t),
      orderByList: orderByList?.call(Complaint.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Complaint] by its [id] or null if no such row exists.
  Future<Complaint?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    ComplaintInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Complaint>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Complaint]s in the list and returns the inserted rows.
  ///
  /// The returned [Complaint]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Complaint>> insert(
    _i1.DatabaseSession session,
    List<Complaint> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Complaint>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Complaint] and returns the inserted row.
  ///
  /// The returned [Complaint] will have its `id` field set.
  Future<Complaint> insertRow(
    _i1.DatabaseSession session,
    Complaint row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Complaint>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Complaint]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Complaint>> update(
    _i1.DatabaseSession session,
    List<Complaint> rows, {
    _i1.ColumnSelections<ComplaintTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Complaint>(
      rows,
      columns: columns?.call(Complaint.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Complaint]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Complaint> updateRow(
    _i1.DatabaseSession session,
    Complaint row, {
    _i1.ColumnSelections<ComplaintTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Complaint>(
      row,
      columns: columns?.call(Complaint.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Complaint] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Complaint?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<ComplaintUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Complaint>(
      id,
      columnValues: columnValues(Complaint.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Complaint]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Complaint>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ComplaintUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ComplaintTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ComplaintTable>? orderBy,
    _i1.OrderByListBuilder<ComplaintTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Complaint>(
      columnValues: columnValues(Complaint.t.updateTable),
      where: where(Complaint.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Complaint.t),
      orderByList: orderByList?.call(Complaint.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Complaint]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Complaint>> delete(
    _i1.DatabaseSession session,
    List<Complaint> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Complaint>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Complaint].
  Future<Complaint> deleteRow(
    _i1.DatabaseSession session,
    Complaint row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Complaint>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Complaint>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ComplaintTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Complaint>(
      where: where(Complaint.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ComplaintTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Complaint>(
      where: where?.call(Complaint.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Complaint] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ComplaintTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Complaint>(
      where: where(Complaint.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class ComplaintAttachRowRepository {
  const ComplaintAttachRowRepository._();

  /// Creates a relation between the given [Complaint] and [Product]
  /// by setting the [Complaint]'s foreign key `productId` to refer to the [Product].
  Future<void> product(
    _i1.DatabaseSession session,
    Complaint complaint,
    _i3.Product product, {
    _i1.Transaction? transaction,
  }) async {
    if (complaint.id == null) {
      throw ArgumentError.notNull('complaint.id');
    }
    if (product.id == null) {
      throw ArgumentError.notNull('product.id');
    }

    var $complaint = complaint.copyWith(productId: product.id);
    await session.db.updateRow<Complaint>(
      $complaint,
      columns: [Complaint.t.productId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Complaint] and [User]
  /// by setting the [Complaint]'s foreign key `reportedById` to refer to the [User].
  Future<void> reportedBy(
    _i1.DatabaseSession session,
    Complaint complaint,
    _i4.User reportedBy, {
    _i1.Transaction? transaction,
  }) async {
    if (complaint.id == null) {
      throw ArgumentError.notNull('complaint.id');
    }
    if (reportedBy.id == null) {
      throw ArgumentError.notNull('reportedBy.id');
    }

    var $complaint = complaint.copyWith(reportedById: reportedBy.id);
    await session.db.updateRow<Complaint>(
      $complaint,
      columns: [Complaint.t.reportedById],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Complaint] and [Admin]
  /// by setting the [Complaint]'s foreign key `assignedToId` to refer to the [Admin].
  Future<void> assignedTo(
    _i1.DatabaseSession session,
    Complaint complaint,
    _i5.Admin assignedTo, {
    _i1.Transaction? transaction,
  }) async {
    if (complaint.id == null) {
      throw ArgumentError.notNull('complaint.id');
    }
    if (assignedTo.id == null) {
      throw ArgumentError.notNull('assignedTo.id');
    }

    var $complaint = complaint.copyWith(assignedToId: assignedTo.id);
    await session.db.updateRow<Complaint>(
      $complaint,
      columns: [Complaint.t.assignedToId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Complaint] and [Admin]
  /// by setting the [Complaint]'s foreign key `resolvedById` to refer to the [Admin].
  Future<void> resolvedBy(
    _i1.DatabaseSession session,
    Complaint complaint,
    _i5.Admin resolvedBy, {
    _i1.Transaction? transaction,
  }) async {
    if (complaint.id == null) {
      throw ArgumentError.notNull('complaint.id');
    }
    if (resolvedBy.id == null) {
      throw ArgumentError.notNull('resolvedBy.id');
    }

    var $complaint = complaint.copyWith(resolvedById: resolvedBy.id);
    await session.db.updateRow<Complaint>(
      $complaint,
      columns: [Complaint.t.resolvedById],
      transaction: transaction,
    );
  }
}

class ComplaintDetachRowRepository {
  const ComplaintDetachRowRepository._();

  /// Detaches the relation between this [Complaint] and the [Admin] set in `assignedTo`
  /// by setting the [Complaint]'s foreign key `assignedToId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> assignedTo(
    _i1.DatabaseSession session,
    Complaint complaint, {
    _i1.Transaction? transaction,
  }) async {
    if (complaint.id == null) {
      throw ArgumentError.notNull('complaint.id');
    }

    var $complaint = complaint.copyWith(assignedToId: null);
    await session.db.updateRow<Complaint>(
      $complaint,
      columns: [Complaint.t.assignedToId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [Complaint] and the [Admin] set in `resolvedBy`
  /// by setting the [Complaint]'s foreign key `resolvedById` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> resolvedBy(
    _i1.DatabaseSession session,
    Complaint complaint, {
    _i1.Transaction? transaction,
  }) async {
    if (complaint.id == null) {
      throw ArgumentError.notNull('complaint.id');
    }

    var $complaint = complaint.copyWith(resolvedById: null);
    await session.db.updateRow<Complaint>(
      $complaint,
      columns: [Complaint.t.resolvedById],
      transaction: transaction,
    );
  }
}
