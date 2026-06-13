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
import 'admin.dart' as _i3;
import 'package:placeify_server/src/generated/protocol.dart' as _i4;

/// VendorProfile — vendor-specific data linked 1:1 to a User account.
abstract class Vendor
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  Vendor._({
    this.id,
    required this.userId,
    this.user,
    required this.shopName,
    this.description,
    this.businessAddress,
    this.logoUrl,
    double? rating,
    this.approvedById,
    this.approvedBy,
    this.approvedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : rating = rating ?? 0.0,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Vendor({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    _i2.User? user,
    required String shopName,
    String? description,
    String? businessAddress,
    String? logoUrl,
    double? rating,
    _i1.UuidValue? approvedById,
    _i3.Admin? approvedBy,
    DateTime? approvedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _VendorImpl;

  factory Vendor.fromJson(Map<String, dynamic> jsonSerialization) {
    return Vendor(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      user: jsonSerialization['user'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.User>(jsonSerialization['user']),
      shopName: jsonSerialization['shopName'] as String,
      description: jsonSerialization['description'] as String?,
      businessAddress: jsonSerialization['businessAddress'] as String?,
      logoUrl: jsonSerialization['logoUrl'] as String?,
      rating: (jsonSerialization['rating'] as num?)?.toDouble(),
      approvedById: jsonSerialization['approvedById'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['approvedById'],
            ),
      approvedBy: jsonSerialization['approvedBy'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.Admin>(
              jsonSerialization['approvedBy'],
            ),
      approvedAt: jsonSerialization['approvedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['approvedAt']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = VendorTable();

  static const db = VendorRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue userId;

  _i2.User? user;

  String shopName;

  String? description;

  String? businessAddress;

  String? logoUrl;

  double rating;

  _i1.UuidValue? approvedById;

  /// Admin who approved this vendor shop.
  _i3.Admin? approvedBy;

  DateTime? approvedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [Vendor]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Vendor copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    _i2.User? user,
    String? shopName,
    String? description,
    String? businessAddress,
    String? logoUrl,
    double? rating,
    _i1.UuidValue? approvedById,
    _i3.Admin? approvedBy,
    DateTime? approvedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Vendor',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      if (user != null) 'user': user?.toJson(),
      'shopName': shopName,
      if (description != null) 'description': description,
      if (businessAddress != null) 'businessAddress': businessAddress,
      if (logoUrl != null) 'logoUrl': logoUrl,
      'rating': rating,
      if (approvedById != null) 'approvedById': approvedById?.toJson(),
      if (approvedBy != null) 'approvedBy': approvedBy?.toJson(),
      if (approvedAt != null) 'approvedAt': approvedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Vendor',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      if (user != null) 'user': user?.toJsonForProtocol(),
      'shopName': shopName,
      if (description != null) 'description': description,
      if (businessAddress != null) 'businessAddress': businessAddress,
      if (logoUrl != null) 'logoUrl': logoUrl,
      'rating': rating,
      if (approvedById != null) 'approvedById': approvedById?.toJson(),
      if (approvedBy != null) 'approvedBy': approvedBy?.toJsonForProtocol(),
      if (approvedAt != null) 'approvedAt': approvedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static VendorInclude include({
    _i2.UserInclude? user,
    _i3.AdminInclude? approvedBy,
  }) {
    return VendorInclude._(
      user: user,
      approvedBy: approvedBy,
    );
  }

  static VendorIncludeList includeList({
    _i1.WhereExpressionBuilder<VendorTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<VendorTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<VendorTable>? orderByList,
    VendorInclude? include,
  }) {
    return VendorIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Vendor.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Vendor.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VendorImpl extends Vendor {
  _VendorImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    _i2.User? user,
    required String shopName,
    String? description,
    String? businessAddress,
    String? logoUrl,
    double? rating,
    _i1.UuidValue? approvedById,
    _i3.Admin? approvedBy,
    DateTime? approvedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         user: user,
         shopName: shopName,
         description: description,
         businessAddress: businessAddress,
         logoUrl: logoUrl,
         rating: rating,
         approvedById: approvedById,
         approvedBy: approvedBy,
         approvedAt: approvedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Vendor]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Vendor copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    Object? user = _Undefined,
    String? shopName,
    Object? description = _Undefined,
    Object? businessAddress = _Undefined,
    Object? logoUrl = _Undefined,
    double? rating,
    Object? approvedById = _Undefined,
    Object? approvedBy = _Undefined,
    Object? approvedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Vendor(
      id: id is _i1.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _i2.User? ? user : this.user?.copyWith(),
      shopName: shopName ?? this.shopName,
      description: description is String? ? description : this.description,
      businessAddress: businessAddress is String?
          ? businessAddress
          : this.businessAddress,
      logoUrl: logoUrl is String? ? logoUrl : this.logoUrl,
      rating: rating ?? this.rating,
      approvedById: approvedById is _i1.UuidValue?
          ? approvedById
          : this.approvedById,
      approvedBy: approvedBy is _i3.Admin?
          ? approvedBy
          : this.approvedBy?.copyWith(),
      approvedAt: approvedAt is DateTime? ? approvedAt : this.approvedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class VendorUpdateTable extends _i1.UpdateTable<VendorTable> {
  VendorUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<String, String> shopName(String value) => _i1.ColumnValue(
    table.shopName,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> businessAddress(String? value) =>
      _i1.ColumnValue(
        table.businessAddress,
        value,
      );

  _i1.ColumnValue<String, String> logoUrl(String? value) => _i1.ColumnValue(
    table.logoUrl,
    value,
  );

  _i1.ColumnValue<double, double> rating(double value) => _i1.ColumnValue(
    table.rating,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> approvedById(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.approvedById,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> approvedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.approvedAt,
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

class VendorTable extends _i1.Table<_i1.UuidValue?> {
  VendorTable({super.tableRelation}) : super(tableName: 'vendor') {
    updateTable = VendorUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    shopName = _i1.ColumnString(
      'shopName',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    businessAddress = _i1.ColumnString(
      'businessAddress',
      this,
    );
    logoUrl = _i1.ColumnString(
      'logoUrl',
      this,
    );
    rating = _i1.ColumnDouble(
      'rating',
      this,
      hasDefault: true,
    );
    approvedById = _i1.ColumnUuid(
      'approvedById',
      this,
    );
    approvedAt = _i1.ColumnDateTime(
      'approvedAt',
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

  late final VendorUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  _i2.UserTable? _user;

  late final _i1.ColumnString shopName;

  late final _i1.ColumnString description;

  late final _i1.ColumnString businessAddress;

  late final _i1.ColumnString logoUrl;

  late final _i1.ColumnDouble rating;

  late final _i1.ColumnUuid approvedById;

  /// Admin who approved this vendor shop.
  _i3.AdminTable? _approvedBy;

  late final _i1.ColumnDateTime approvedAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  _i2.UserTable get user {
    if (_user != null) return _user!;
    _user = _i1.createRelationTable(
      relationFieldName: 'user',
      field: Vendor.t.userId,
      foreignField: _i2.User.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.UserTable(tableRelation: foreignTableRelation),
    );
    return _user!;
  }

  _i3.AdminTable get approvedBy {
    if (_approvedBy != null) return _approvedBy!;
    _approvedBy = _i1.createRelationTable(
      relationFieldName: 'approvedBy',
      field: Vendor.t.approvedById,
      foreignField: _i3.Admin.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.AdminTable(tableRelation: foreignTableRelation),
    );
    return _approvedBy!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    shopName,
    description,
    businessAddress,
    logoUrl,
    rating,
    approvedById,
    approvedAt,
    createdAt,
    updatedAt,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'user') {
      return user;
    }
    if (relationField == 'approvedBy') {
      return approvedBy;
    }
    return null;
  }
}

class VendorInclude extends _i1.IncludeObject {
  VendorInclude._({
    _i2.UserInclude? user,
    _i3.AdminInclude? approvedBy,
  }) {
    _user = user;
    _approvedBy = approvedBy;
  }

  _i2.UserInclude? _user;

  _i3.AdminInclude? _approvedBy;

  @override
  Map<String, _i1.Include?> get includes => {
    'user': _user,
    'approvedBy': _approvedBy,
  };

  @override
  _i1.Table<_i1.UuidValue?> get table => Vendor.t;
}

class VendorIncludeList extends _i1.IncludeList {
  VendorIncludeList._({
    _i1.WhereExpressionBuilder<VendorTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Vendor.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => Vendor.t;
}

class VendorRepository {
  const VendorRepository._();

  final attachRow = const VendorAttachRowRepository._();

  final detachRow = const VendorDetachRowRepository._();

  /// Returns a list of [Vendor]s matching the given query parameters.
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
  Future<List<Vendor>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<VendorTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<VendorTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<VendorTable>? orderByList,
    _i1.Transaction? transaction,
    VendorInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Vendor>(
      where: where?.call(Vendor.t),
      orderBy: orderBy?.call(Vendor.t),
      orderByList: orderByList?.call(Vendor.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Vendor] matching the given query parameters.
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
  Future<Vendor?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<VendorTable>? where,
    int? offset,
    _i1.OrderByBuilder<VendorTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<VendorTable>? orderByList,
    _i1.Transaction? transaction,
    VendorInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Vendor>(
      where: where?.call(Vendor.t),
      orderBy: orderBy?.call(Vendor.t),
      orderByList: orderByList?.call(Vendor.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Vendor] by its [id] or null if no such row exists.
  Future<Vendor?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    VendorInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Vendor>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Vendor]s in the list and returns the inserted rows.
  ///
  /// The returned [Vendor]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Vendor>> insert(
    _i1.DatabaseSession session,
    List<Vendor> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Vendor>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Vendor] and returns the inserted row.
  ///
  /// The returned [Vendor] will have its `id` field set.
  Future<Vendor> insertRow(
    _i1.DatabaseSession session,
    Vendor row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Vendor>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Vendor]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Vendor>> update(
    _i1.DatabaseSession session,
    List<Vendor> rows, {
    _i1.ColumnSelections<VendorTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Vendor>(
      rows,
      columns: columns?.call(Vendor.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Vendor]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Vendor> updateRow(
    _i1.DatabaseSession session,
    Vendor row, {
    _i1.ColumnSelections<VendorTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Vendor>(
      row,
      columns: columns?.call(Vendor.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Vendor] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Vendor?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<VendorUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Vendor>(
      id,
      columnValues: columnValues(Vendor.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Vendor]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Vendor>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<VendorUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<VendorTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<VendorTable>? orderBy,
    _i1.OrderByListBuilder<VendorTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Vendor>(
      columnValues: columnValues(Vendor.t.updateTable),
      where: where(Vendor.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Vendor.t),
      orderByList: orderByList?.call(Vendor.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Vendor]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Vendor>> delete(
    _i1.DatabaseSession session,
    List<Vendor> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Vendor>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Vendor].
  Future<Vendor> deleteRow(
    _i1.DatabaseSession session,
    Vendor row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Vendor>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Vendor>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<VendorTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Vendor>(
      where: where(Vendor.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<VendorTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Vendor>(
      where: where?.call(Vendor.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Vendor] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<VendorTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Vendor>(
      where: where(Vendor.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class VendorAttachRowRepository {
  const VendorAttachRowRepository._();

  /// Creates a relation between the given [Vendor] and [User]
  /// by setting the [Vendor]'s foreign key `userId` to refer to the [User].
  Future<void> user(
    _i1.DatabaseSession session,
    Vendor vendor,
    _i2.User user, {
    _i1.Transaction? transaction,
  }) async {
    if (vendor.id == null) {
      throw ArgumentError.notNull('vendor.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $vendor = vendor.copyWith(userId: user.id);
    await session.db.updateRow<Vendor>(
      $vendor,
      columns: [Vendor.t.userId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Vendor] and [Admin]
  /// by setting the [Vendor]'s foreign key `approvedById` to refer to the [Admin].
  Future<void> approvedBy(
    _i1.DatabaseSession session,
    Vendor vendor,
    _i3.Admin approvedBy, {
    _i1.Transaction? transaction,
  }) async {
    if (vendor.id == null) {
      throw ArgumentError.notNull('vendor.id');
    }
    if (approvedBy.id == null) {
      throw ArgumentError.notNull('approvedBy.id');
    }

    var $vendor = vendor.copyWith(approvedById: approvedBy.id);
    await session.db.updateRow<Vendor>(
      $vendor,
      columns: [Vendor.t.approvedById],
      transaction: transaction,
    );
  }
}

class VendorDetachRowRepository {
  const VendorDetachRowRepository._();

  /// Detaches the relation between this [Vendor] and the [Admin] set in `approvedBy`
  /// by setting the [Vendor]'s foreign key `approvedById` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> approvedBy(
    _i1.DatabaseSession session,
    Vendor vendor, {
    _i1.Transaction? transaction,
  }) async {
    if (vendor.id == null) {
      throw ArgumentError.notNull('vendor.id');
    }

    var $vendor = vendor.copyWith(approvedById: null);
    await session.db.updateRow<Vendor>(
      $vendor,
      columns: [Vendor.t.approvedById],
      transaction: transaction,
    );
  }
}
