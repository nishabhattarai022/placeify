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
import 'vendor.dart' as _i2;
import 'package:placeify_server/src/generated/protocol.dart' as _i3;

/// Payout bank account linked 1:1 to a vendor shop.
abstract class VendorBankDetails
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  VendorBankDetails._({
    this.id,
    required this.vendorId,
    this.vendor,
    required this.accountHolderName,
    required this.bankName,
    required this.accountNumber,
    required this.branchCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory VendorBankDetails({
    int? id,
    required _i1.UuidValue vendorId,
    _i2.Vendor? vendor,
    required String accountHolderName,
    required String bankName,
    required String accountNumber,
    required String branchCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _VendorBankDetailsImpl;

  factory VendorBankDetails.fromJson(Map<String, dynamic> jsonSerialization) {
    return VendorBankDetails(
      id: jsonSerialization['id'] as int?,
      vendorId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['vendorId'],
      ),
      vendor: jsonSerialization['vendor'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Vendor>(jsonSerialization['vendor']),
      accountHolderName: jsonSerialization['accountHolderName'] as String,
      bankName: jsonSerialization['bankName'] as String,
      accountNumber: jsonSerialization['accountNumber'] as String,
      branchCode: jsonSerialization['branchCode'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = VendorBankDetailsTable();

  static const db = VendorBankDetailsRepository._();

  @override
  int? id;

  _i1.UuidValue vendorId;

  _i2.Vendor? vendor;

  String accountHolderName;

  String bankName;

  String accountNumber;

  /// Branch code, IFSC, routing number, or SWIFT — region-specific payout identifier.
  String branchCode;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [VendorBankDetails]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VendorBankDetails copyWith({
    int? id,
    _i1.UuidValue? vendorId,
    _i2.Vendor? vendor,
    String? accountHolderName,
    String? bankName,
    String? accountNumber,
    String? branchCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VendorBankDetails',
      if (id != null) 'id': id,
      'vendorId': vendorId.toJson(),
      if (vendor != null) 'vendor': vendor?.toJson(),
      'accountHolderName': accountHolderName,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'branchCode': branchCode,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VendorBankDetails',
      if (id != null) 'id': id,
      'vendorId': vendorId.toJson(),
      if (vendor != null) 'vendor': vendor?.toJsonForProtocol(),
      'accountHolderName': accountHolderName,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'branchCode': branchCode,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static VendorBankDetailsInclude include({_i2.VendorInclude? vendor}) {
    return VendorBankDetailsInclude._(vendor: vendor);
  }

  static VendorBankDetailsIncludeList includeList({
    _i1.WhereExpressionBuilder<VendorBankDetailsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<VendorBankDetailsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<VendorBankDetailsTable>? orderByList,
    VendorBankDetailsInclude? include,
  }) {
    return VendorBankDetailsIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(VendorBankDetails.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(VendorBankDetails.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VendorBankDetailsImpl extends VendorBankDetails {
  _VendorBankDetailsImpl({
    int? id,
    required _i1.UuidValue vendorId,
    _i2.Vendor? vendor,
    required String accountHolderName,
    required String bankName,
    required String accountNumber,
    required String branchCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         vendorId: vendorId,
         vendor: vendor,
         accountHolderName: accountHolderName,
         bankName: bankName,
         accountNumber: accountNumber,
         branchCode: branchCode,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [VendorBankDetails]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VendorBankDetails copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? vendorId,
    Object? vendor = _Undefined,
    String? accountHolderName,
    String? bankName,
    String? accountNumber,
    String? branchCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VendorBankDetails(
      id: id is int? ? id : this.id,
      vendorId: vendorId ?? this.vendorId,
      vendor: vendor is _i2.Vendor? ? vendor : this.vendor?.copyWith(),
      accountHolderName: accountHolderName ?? this.accountHolderName,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      branchCode: branchCode ?? this.branchCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class VendorBankDetailsUpdateTable
    extends _i1.UpdateTable<VendorBankDetailsTable> {
  VendorBankDetailsUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> vendorId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.vendorId,
        value,
      );

  _i1.ColumnValue<String, String> accountHolderName(String value) =>
      _i1.ColumnValue(
        table.accountHolderName,
        value,
      );

  _i1.ColumnValue<String, String> bankName(String value) => _i1.ColumnValue(
    table.bankName,
    value,
  );

  _i1.ColumnValue<String, String> accountNumber(String value) =>
      _i1.ColumnValue(
        table.accountNumber,
        value,
      );

  _i1.ColumnValue<String, String> branchCode(String value) => _i1.ColumnValue(
    table.branchCode,
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

class VendorBankDetailsTable extends _i1.Table<int?> {
  VendorBankDetailsTable({super.tableRelation})
    : super(tableName: 'vendor_bank_details') {
    updateTable = VendorBankDetailsUpdateTable(this);
    vendorId = _i1.ColumnUuid(
      'vendorId',
      this,
    );
    accountHolderName = _i1.ColumnString(
      'accountHolderName',
      this,
    );
    bankName = _i1.ColumnString(
      'bankName',
      this,
    );
    accountNumber = _i1.ColumnString(
      'accountNumber',
      this,
    );
    branchCode = _i1.ColumnString(
      'branchCode',
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

  late final VendorBankDetailsUpdateTable updateTable;

  late final _i1.ColumnUuid vendorId;

  _i2.VendorTable? _vendor;

  late final _i1.ColumnString accountHolderName;

  late final _i1.ColumnString bankName;

  late final _i1.ColumnString accountNumber;

  /// Branch code, IFSC, routing number, or SWIFT — region-specific payout identifier.
  late final _i1.ColumnString branchCode;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  _i2.VendorTable get vendor {
    if (_vendor != null) return _vendor!;
    _vendor = _i1.createRelationTable(
      relationFieldName: 'vendor',
      field: VendorBankDetails.t.vendorId,
      foreignField: _i2.Vendor.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.VendorTable(tableRelation: foreignTableRelation),
    );
    return _vendor!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    vendorId,
    accountHolderName,
    bankName,
    accountNumber,
    branchCode,
    createdAt,
    updatedAt,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'vendor') {
      return vendor;
    }
    return null;
  }
}

class VendorBankDetailsInclude extends _i1.IncludeObject {
  VendorBankDetailsInclude._({_i2.VendorInclude? vendor}) {
    _vendor = vendor;
  }

  _i2.VendorInclude? _vendor;

  @override
  Map<String, _i1.Include?> get includes => {'vendor': _vendor};

  @override
  _i1.Table<int?> get table => VendorBankDetails.t;
}

class VendorBankDetailsIncludeList extends _i1.IncludeList {
  VendorBankDetailsIncludeList._({
    _i1.WhereExpressionBuilder<VendorBankDetailsTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(VendorBankDetails.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => VendorBankDetails.t;
}

class VendorBankDetailsRepository {
  const VendorBankDetailsRepository._();

  final attachRow = const VendorBankDetailsAttachRowRepository._();

  /// Returns a list of [VendorBankDetails]s matching the given query parameters.
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
  Future<List<VendorBankDetails>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<VendorBankDetailsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<VendorBankDetailsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<VendorBankDetailsTable>? orderByList,
    _i1.Transaction? transaction,
    VendorBankDetailsInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<VendorBankDetails>(
      where: where?.call(VendorBankDetails.t),
      orderBy: orderBy?.call(VendorBankDetails.t),
      orderByList: orderByList?.call(VendorBankDetails.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [VendorBankDetails] matching the given query parameters.
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
  Future<VendorBankDetails?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<VendorBankDetailsTable>? where,
    int? offset,
    _i1.OrderByBuilder<VendorBankDetailsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<VendorBankDetailsTable>? orderByList,
    _i1.Transaction? transaction,
    VendorBankDetailsInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<VendorBankDetails>(
      where: where?.call(VendorBankDetails.t),
      orderBy: orderBy?.call(VendorBankDetails.t),
      orderByList: orderByList?.call(VendorBankDetails.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [VendorBankDetails] by its [id] or null if no such row exists.
  Future<VendorBankDetails?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    VendorBankDetailsInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<VendorBankDetails>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [VendorBankDetails]s in the list and returns the inserted rows.
  ///
  /// The returned [VendorBankDetails]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<VendorBankDetails>> insert(
    _i1.DatabaseSession session,
    List<VendorBankDetails> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<VendorBankDetails>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [VendorBankDetails] and returns the inserted row.
  ///
  /// The returned [VendorBankDetails] will have its `id` field set.
  Future<VendorBankDetails> insertRow(
    _i1.DatabaseSession session,
    VendorBankDetails row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<VendorBankDetails>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [VendorBankDetails]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<VendorBankDetails>> update(
    _i1.DatabaseSession session,
    List<VendorBankDetails> rows, {
    _i1.ColumnSelections<VendorBankDetailsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<VendorBankDetails>(
      rows,
      columns: columns?.call(VendorBankDetails.t),
      transaction: transaction,
    );
  }

  /// Updates a single [VendorBankDetails]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<VendorBankDetails> updateRow(
    _i1.DatabaseSession session,
    VendorBankDetails row, {
    _i1.ColumnSelections<VendorBankDetailsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<VendorBankDetails>(
      row,
      columns: columns?.call(VendorBankDetails.t),
      transaction: transaction,
    );
  }

  /// Updates a single [VendorBankDetails] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<VendorBankDetails?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<VendorBankDetailsUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<VendorBankDetails>(
      id,
      columnValues: columnValues(VendorBankDetails.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [VendorBankDetails]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<VendorBankDetails>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<VendorBankDetailsUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<VendorBankDetailsTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<VendorBankDetailsTable>? orderBy,
    _i1.OrderByListBuilder<VendorBankDetailsTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<VendorBankDetails>(
      columnValues: columnValues(VendorBankDetails.t.updateTable),
      where: where(VendorBankDetails.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(VendorBankDetails.t),
      orderByList: orderByList?.call(VendorBankDetails.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [VendorBankDetails]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<VendorBankDetails>> delete(
    _i1.DatabaseSession session,
    List<VendorBankDetails> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<VendorBankDetails>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [VendorBankDetails].
  Future<VendorBankDetails> deleteRow(
    _i1.DatabaseSession session,
    VendorBankDetails row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<VendorBankDetails>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<VendorBankDetails>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<VendorBankDetailsTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<VendorBankDetails>(
      where: where(VendorBankDetails.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<VendorBankDetailsTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<VendorBankDetails>(
      where: where?.call(VendorBankDetails.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [VendorBankDetails] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<VendorBankDetailsTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<VendorBankDetails>(
      where: where(VendorBankDetails.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class VendorBankDetailsAttachRowRepository {
  const VendorBankDetailsAttachRowRepository._();

  /// Creates a relation between the given [VendorBankDetails] and [Vendor]
  /// by setting the [VendorBankDetails]'s foreign key `vendorId` to refer to the [Vendor].
  Future<void> vendor(
    _i1.DatabaseSession session,
    VendorBankDetails vendorBankDetails,
    _i2.Vendor vendor, {
    _i1.Transaction? transaction,
  }) async {
    if (vendorBankDetails.id == null) {
      throw ArgumentError.notNull('vendorBankDetails.id');
    }
    if (vendor.id == null) {
      throw ArgumentError.notNull('vendor.id');
    }

    var $vendorBankDetails = vendorBankDetails.copyWith(vendorId: vendor.id);
    await session.db.updateRow<VendorBankDetails>(
      $vendorBankDetails,
      columns: [VendorBankDetails.t.vendorId],
      transaction: transaction,
    );
  }
}
