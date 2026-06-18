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
import 'vendor.dart' as _i3;
import 'vendor_document_type.dart' as _i4;
import 'package:placeify_server/src/generated/protocol.dart' as _i5;

/// Verification document uploaded during vendor onboarding.
abstract class VendorDocument
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  VendorDocument._({
    this.id,
    required this.userId,
    this.user,
    this.vendorId,
    this.vendor,
    required this.documentType,
    required this.fileUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory VendorDocument({
    int? id,
    required _i1.UuidValue userId,
    _i2.User? user,
    _i1.UuidValue? vendorId,
    _i3.Vendor? vendor,
    required _i4.VendorDocumentType documentType,
    required String fileUrl,
    DateTime? createdAt,
  }) = _VendorDocumentImpl;

  factory VendorDocument.fromJson(Map<String, dynamic> jsonSerialization) {
    return VendorDocument(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      user: jsonSerialization['user'] == null
          ? null
          : _i5.Protocol().deserialize<_i2.User>(jsonSerialization['user']),
      vendorId: jsonSerialization['vendorId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['vendorId']),
      vendor: jsonSerialization['vendor'] == null
          ? null
          : _i5.Protocol().deserialize<_i3.Vendor>(jsonSerialization['vendor']),
      documentType: _i4.VendorDocumentType.fromJson(
        (jsonSerialization['documentType'] as String),
      ),
      fileUrl: jsonSerialization['fileUrl'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = VendorDocumentTable();

  static const db = VendorDocumentRepository._();

  @override
  int? id;

  _i1.UuidValue userId;

  _i2.User? user;

  _i1.UuidValue? vendorId;

  _i3.Vendor? vendor;

  _i4.VendorDocumentType documentType;

  String fileUrl;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [VendorDocument]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VendorDocument copyWith({
    int? id,
    _i1.UuidValue? userId,
    _i2.User? user,
    _i1.UuidValue? vendorId,
    _i3.Vendor? vendor,
    _i4.VendorDocumentType? documentType,
    String? fileUrl,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VendorDocument',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      if (user != null) 'user': user?.toJson(),
      if (vendorId != null) 'vendorId': vendorId?.toJson(),
      if (vendor != null) 'vendor': vendor?.toJson(),
      'documentType': documentType.toJson(),
      'fileUrl': fileUrl,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VendorDocument',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      if (user != null) 'user': user?.toJsonForProtocol(),
      if (vendorId != null) 'vendorId': vendorId?.toJson(),
      if (vendor != null) 'vendor': vendor?.toJsonForProtocol(),
      'documentType': documentType.toJson(),
      'fileUrl': fileUrl,
      'createdAt': createdAt.toJson(),
    };
  }

  static VendorDocumentInclude include({
    _i2.UserInclude? user,
    _i3.VendorInclude? vendor,
  }) {
    return VendorDocumentInclude._(
      user: user,
      vendor: vendor,
    );
  }

  static VendorDocumentIncludeList includeList({
    _i1.WhereExpressionBuilder<VendorDocumentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<VendorDocumentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<VendorDocumentTable>? orderByList,
    VendorDocumentInclude? include,
  }) {
    return VendorDocumentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(VendorDocument.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(VendorDocument.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VendorDocumentImpl extends VendorDocument {
  _VendorDocumentImpl({
    int? id,
    required _i1.UuidValue userId,
    _i2.User? user,
    _i1.UuidValue? vendorId,
    _i3.Vendor? vendor,
    required _i4.VendorDocumentType documentType,
    required String fileUrl,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         user: user,
         vendorId: vendorId,
         vendor: vendor,
         documentType: documentType,
         fileUrl: fileUrl,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [VendorDocument]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VendorDocument copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    Object? user = _Undefined,
    Object? vendorId = _Undefined,
    Object? vendor = _Undefined,
    _i4.VendorDocumentType? documentType,
    String? fileUrl,
    DateTime? createdAt,
  }) {
    return VendorDocument(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _i2.User? ? user : this.user?.copyWith(),
      vendorId: vendorId is _i1.UuidValue? ? vendorId : this.vendorId,
      vendor: vendor is _i3.Vendor? ? vendor : this.vendor?.copyWith(),
      documentType: documentType ?? this.documentType,
      fileUrl: fileUrl ?? this.fileUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class VendorDocumentUpdateTable extends _i1.UpdateTable<VendorDocumentTable> {
  VendorDocumentUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> vendorId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.vendorId,
    value,
  );

  _i1.ColumnValue<_i4.VendorDocumentType, _i4.VendorDocumentType> documentType(
    _i4.VendorDocumentType value,
  ) => _i1.ColumnValue(
    table.documentType,
    value,
  );

  _i1.ColumnValue<String, String> fileUrl(String value) => _i1.ColumnValue(
    table.fileUrl,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class VendorDocumentTable extends _i1.Table<int?> {
  VendorDocumentTable({super.tableRelation})
    : super(tableName: 'vendor_document') {
    updateTable = VendorDocumentUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    vendorId = _i1.ColumnUuid(
      'vendorId',
      this,
    );
    documentType = _i1.ColumnEnum(
      'documentType',
      this,
      _i1.EnumSerialization.byName,
    );
    fileUrl = _i1.ColumnString(
      'fileUrl',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final VendorDocumentUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  _i2.UserTable? _user;

  late final _i1.ColumnUuid vendorId;

  _i3.VendorTable? _vendor;

  late final _i1.ColumnEnum<_i4.VendorDocumentType> documentType;

  late final _i1.ColumnString fileUrl;

  late final _i1.ColumnDateTime createdAt;

  _i2.UserTable get user {
    if (_user != null) return _user!;
    _user = _i1.createRelationTable(
      relationFieldName: 'user',
      field: VendorDocument.t.userId,
      foreignField: _i2.User.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.UserTable(tableRelation: foreignTableRelation),
    );
    return _user!;
  }

  _i3.VendorTable get vendor {
    if (_vendor != null) return _vendor!;
    _vendor = _i1.createRelationTable(
      relationFieldName: 'vendor',
      field: VendorDocument.t.vendorId,
      foreignField: _i3.Vendor.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.VendorTable(tableRelation: foreignTableRelation),
    );
    return _vendor!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    vendorId,
    documentType,
    fileUrl,
    createdAt,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'user') {
      return user;
    }
    if (relationField == 'vendor') {
      return vendor;
    }
    return null;
  }
}

class VendorDocumentInclude extends _i1.IncludeObject {
  VendorDocumentInclude._({
    _i2.UserInclude? user,
    _i3.VendorInclude? vendor,
  }) {
    _user = user;
    _vendor = vendor;
  }

  _i2.UserInclude? _user;

  _i3.VendorInclude? _vendor;

  @override
  Map<String, _i1.Include?> get includes => {
    'user': _user,
    'vendor': _vendor,
  };

  @override
  _i1.Table<int?> get table => VendorDocument.t;
}

class VendorDocumentIncludeList extends _i1.IncludeList {
  VendorDocumentIncludeList._({
    _i1.WhereExpressionBuilder<VendorDocumentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(VendorDocument.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => VendorDocument.t;
}

class VendorDocumentRepository {
  const VendorDocumentRepository._();

  final attachRow = const VendorDocumentAttachRowRepository._();

  final detachRow = const VendorDocumentDetachRowRepository._();

  /// Returns a list of [VendorDocument]s matching the given query parameters.
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
  Future<List<VendorDocument>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<VendorDocumentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<VendorDocumentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<VendorDocumentTable>? orderByList,
    _i1.Transaction? transaction,
    VendorDocumentInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<VendorDocument>(
      where: where?.call(VendorDocument.t),
      orderBy: orderBy?.call(VendorDocument.t),
      orderByList: orderByList?.call(VendorDocument.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [VendorDocument] matching the given query parameters.
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
  Future<VendorDocument?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<VendorDocumentTable>? where,
    int? offset,
    _i1.OrderByBuilder<VendorDocumentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<VendorDocumentTable>? orderByList,
    _i1.Transaction? transaction,
    VendorDocumentInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<VendorDocument>(
      where: where?.call(VendorDocument.t),
      orderBy: orderBy?.call(VendorDocument.t),
      orderByList: orderByList?.call(VendorDocument.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [VendorDocument] by its [id] or null if no such row exists.
  Future<VendorDocument?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    VendorDocumentInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<VendorDocument>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [VendorDocument]s in the list and returns the inserted rows.
  ///
  /// The returned [VendorDocument]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<VendorDocument>> insert(
    _i1.DatabaseSession session,
    List<VendorDocument> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<VendorDocument>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [VendorDocument] and returns the inserted row.
  ///
  /// The returned [VendorDocument] will have its `id` field set.
  Future<VendorDocument> insertRow(
    _i1.DatabaseSession session,
    VendorDocument row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<VendorDocument>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [VendorDocument]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<VendorDocument>> update(
    _i1.DatabaseSession session,
    List<VendorDocument> rows, {
    _i1.ColumnSelections<VendorDocumentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<VendorDocument>(
      rows,
      columns: columns?.call(VendorDocument.t),
      transaction: transaction,
    );
  }

  /// Updates a single [VendorDocument]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<VendorDocument> updateRow(
    _i1.DatabaseSession session,
    VendorDocument row, {
    _i1.ColumnSelections<VendorDocumentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<VendorDocument>(
      row,
      columns: columns?.call(VendorDocument.t),
      transaction: transaction,
    );
  }

  /// Updates a single [VendorDocument] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<VendorDocument?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<VendorDocumentUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<VendorDocument>(
      id,
      columnValues: columnValues(VendorDocument.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [VendorDocument]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<VendorDocument>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<VendorDocumentUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<VendorDocumentTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<VendorDocumentTable>? orderBy,
    _i1.OrderByListBuilder<VendorDocumentTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<VendorDocument>(
      columnValues: columnValues(VendorDocument.t.updateTable),
      where: where(VendorDocument.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(VendorDocument.t),
      orderByList: orderByList?.call(VendorDocument.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [VendorDocument]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<VendorDocument>> delete(
    _i1.DatabaseSession session,
    List<VendorDocument> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<VendorDocument>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [VendorDocument].
  Future<VendorDocument> deleteRow(
    _i1.DatabaseSession session,
    VendorDocument row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<VendorDocument>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<VendorDocument>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<VendorDocumentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<VendorDocument>(
      where: where(VendorDocument.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<VendorDocumentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<VendorDocument>(
      where: where?.call(VendorDocument.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [VendorDocument] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<VendorDocumentTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<VendorDocument>(
      where: where(VendorDocument.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class VendorDocumentAttachRowRepository {
  const VendorDocumentAttachRowRepository._();

  /// Creates a relation between the given [VendorDocument] and [User]
  /// by setting the [VendorDocument]'s foreign key `userId` to refer to the [User].
  Future<void> user(
    _i1.DatabaseSession session,
    VendorDocument vendorDocument,
    _i2.User user, {
    _i1.Transaction? transaction,
  }) async {
    if (vendorDocument.id == null) {
      throw ArgumentError.notNull('vendorDocument.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $vendorDocument = vendorDocument.copyWith(userId: user.id);
    await session.db.updateRow<VendorDocument>(
      $vendorDocument,
      columns: [VendorDocument.t.userId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [VendorDocument] and [Vendor]
  /// by setting the [VendorDocument]'s foreign key `vendorId` to refer to the [Vendor].
  Future<void> vendor(
    _i1.DatabaseSession session,
    VendorDocument vendorDocument,
    _i3.Vendor vendor, {
    _i1.Transaction? transaction,
  }) async {
    if (vendorDocument.id == null) {
      throw ArgumentError.notNull('vendorDocument.id');
    }
    if (vendor.id == null) {
      throw ArgumentError.notNull('vendor.id');
    }

    var $vendorDocument = vendorDocument.copyWith(vendorId: vendor.id);
    await session.db.updateRow<VendorDocument>(
      $vendorDocument,
      columns: [VendorDocument.t.vendorId],
      transaction: transaction,
    );
  }
}

class VendorDocumentDetachRowRepository {
  const VendorDocumentDetachRowRepository._();

  /// Detaches the relation between this [VendorDocument] and the [Vendor] set in `vendor`
  /// by setting the [VendorDocument]'s foreign key `vendorId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> vendor(
    _i1.DatabaseSession session,
    VendorDocument vendorDocument, {
    _i1.Transaction? transaction,
  }) async {
    if (vendorDocument.id == null) {
      throw ArgumentError.notNull('vendorDocument.id');
    }

    var $vendorDocument = vendorDocument.copyWith(vendorId: null);
    await session.db.updateRow<VendorDocument>(
      $vendorDocument,
      columns: [VendorDocument.t.vendorId],
      transaction: transaction,
    );
  }
}
