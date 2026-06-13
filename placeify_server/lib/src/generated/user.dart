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
import 'user_role.dart' as _i2;
import 'user_account_status.dart' as _i3;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i4;
import 'admin.dart' as _i5;
import 'package:placeify_server/src/generated/protocol.dart' as _i6;

/// Core Placeify account (customer / vendor / admin).
/// Email and password are managed by Serverpod Auth via authUser — not stored here.
/// Role `consumer` is the customer role used across the app.
abstract class User
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  User._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.name,
    this.email,
    this.phone,
    this.address,
    this.profileImageUrl,
    _i2.UserRole? role,
    _i3.UserAccountStatus? status,
    this.approvedById,
    this.approvedBy,
    this.statusChangedById,
    this.statusChangedBy,
    bool? isActive,
    this.deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : role = role ?? _i2.UserRole.consumer,
       status = status ?? _i3.UserAccountStatus.approved,
       isActive = isActive ?? true,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory User({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i4.AuthUser? authUser,
    required String name,
    String? email,
    String? phone,
    String? address,
    String? profileImageUrl,
    _i2.UserRole? role,
    _i3.UserAccountStatus? status,
    _i1.UuidValue? approvedById,
    _i5.Admin? approvedBy,
    _i1.UuidValue? statusChangedById,
    _i5.Admin? statusChangedBy,
    bool? isActive,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserImpl;

  factory User.fromJson(Map<String, dynamic> jsonSerialization) {
    return User(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i6.Protocol().deserialize<_i4.AuthUser>(
              jsonSerialization['authUser'],
            ),
      name: jsonSerialization['name'] as String,
      email: jsonSerialization['email'] as String?,
      phone: jsonSerialization['phone'] as String?,
      address: jsonSerialization['address'] as String?,
      profileImageUrl: jsonSerialization['profileImageUrl'] as String?,
      role: jsonSerialization['role'] == null
          ? null
          : _i2.UserRole.fromJson((jsonSerialization['role'] as String)),
      status: jsonSerialization['status'] == null
          ? null
          : _i3.UserAccountStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      approvedById: jsonSerialization['approvedById'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['approvedById'],
            ),
      approvedBy: jsonSerialization['approvedBy'] == null
          ? null
          : _i6.Protocol().deserialize<_i5.Admin>(
              jsonSerialization['approvedBy'],
            ),
      statusChangedById: jsonSerialization['statusChangedById'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['statusChangedById'],
            ),
      statusChangedBy: jsonSerialization['statusChangedBy'] == null
          ? null
          : _i6.Protocol().deserialize<_i5.Admin>(
              jsonSerialization['statusChangedBy'],
            ),
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = UserTable();

  static const db = UserRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue authUserId;

  _i4.AuthUser? authUser;

  String name;

  String? email;

  String? phone;

  String? address;

  String? profileImageUrl;

  _i2.UserRole role;

  _i3.UserAccountStatus status;

  _i1.UuidValue? approvedById;

  /// Admin who approved this account (vendor onboarding or customer verification).
  _i5.Admin? approvedBy;

  _i1.UuidValue? statusChangedById;

  /// Admin who last changed status (suspend, reject, re-approve).
  _i5.Admin? statusChangedBy;

  bool isActive;

  DateTime? deletedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [User]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  User copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authUserId,
    _i4.AuthUser? authUser,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? profileImageUrl,
    _i2.UserRole? role,
    _i3.UserAccountStatus? status,
    _i1.UuidValue? approvedById,
    _i5.Admin? approvedBy,
    _i1.UuidValue? statusChangedById,
    _i5.Admin? statusChangedBy,
    bool? isActive,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'User',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      'role': role.toJson(),
      'status': status.toJson(),
      if (approvedById != null) 'approvedById': approvedById?.toJson(),
      if (approvedBy != null) 'approvedBy': approvedBy?.toJson(),
      if (statusChangedById != null)
        'statusChangedById': statusChangedById?.toJson(),
      if (statusChangedBy != null) 'statusChangedBy': statusChangedBy?.toJson(),
      'isActive': isActive,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'User',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJsonForProtocol(),
      'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      'role': role.toJson(),
      'status': status.toJson(),
      if (approvedById != null) 'approvedById': approvedById?.toJson(),
      if (approvedBy != null) 'approvedBy': approvedBy?.toJsonForProtocol(),
      if (statusChangedById != null)
        'statusChangedById': statusChangedById?.toJson(),
      if (statusChangedBy != null)
        'statusChangedBy': statusChangedBy?.toJsonForProtocol(),
      'isActive': isActive,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static UserInclude include({
    _i4.AuthUserInclude? authUser,
    _i5.AdminInclude? approvedBy,
    _i5.AdminInclude? statusChangedBy,
  }) {
    return UserInclude._(
      authUser: authUser,
      approvedBy: approvedBy,
      statusChangedBy: statusChangedBy,
    );
  }

  static UserIncludeList includeList({
    _i1.WhereExpressionBuilder<UserTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserTable>? orderByList,
    UserInclude? include,
  }) {
    return UserIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(User.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(User.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserImpl extends User {
  _UserImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i4.AuthUser? authUser,
    required String name,
    String? email,
    String? phone,
    String? address,
    String? profileImageUrl,
    _i2.UserRole? role,
    _i3.UserAccountStatus? status,
    _i1.UuidValue? approvedById,
    _i5.Admin? approvedBy,
    _i1.UuidValue? statusChangedById,
    _i5.Admin? statusChangedBy,
    bool? isActive,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         name: name,
         email: email,
         phone: phone,
         address: address,
         profileImageUrl: profileImageUrl,
         role: role,
         status: status,
         approvedById: approvedById,
         approvedBy: approvedBy,
         statusChangedById: statusChangedById,
         statusChangedBy: statusChangedBy,
         isActive: isActive,
         deletedAt: deletedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [User]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  User copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    String? name,
    Object? email = _Undefined,
    Object? phone = _Undefined,
    Object? address = _Undefined,
    Object? profileImageUrl = _Undefined,
    _i2.UserRole? role,
    _i3.UserAccountStatus? status,
    Object? approvedById = _Undefined,
    Object? approvedBy = _Undefined,
    Object? statusChangedById = _Undefined,
    Object? statusChangedBy = _Undefined,
    bool? isActive,
    Object? deletedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id is _i1.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _i4.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      name: name ?? this.name,
      email: email is String? ? email : this.email,
      phone: phone is String? ? phone : this.phone,
      address: address is String? ? address : this.address,
      profileImageUrl: profileImageUrl is String?
          ? profileImageUrl
          : this.profileImageUrl,
      role: role ?? this.role,
      status: status ?? this.status,
      approvedById: approvedById is _i1.UuidValue?
          ? approvedById
          : this.approvedById,
      approvedBy: approvedBy is _i5.Admin?
          ? approvedBy
          : this.approvedBy?.copyWith(),
      statusChangedById: statusChangedById is _i1.UuidValue?
          ? statusChangedById
          : this.statusChangedById,
      statusChangedBy: statusChangedBy is _i5.Admin?
          ? statusChangedBy
          : this.statusChangedBy?.copyWith(),
      isActive: isActive ?? this.isActive,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class UserUpdateTable extends _i1.UpdateTable<UserTable> {
  UserUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> authUserId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.authUserId,
    value,
  );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> email(String? value) => _i1.ColumnValue(
    table.email,
    value,
  );

  _i1.ColumnValue<String, String> phone(String? value) => _i1.ColumnValue(
    table.phone,
    value,
  );

  _i1.ColumnValue<String, String> address(String? value) => _i1.ColumnValue(
    table.address,
    value,
  );

  _i1.ColumnValue<String, String> profileImageUrl(String? value) =>
      _i1.ColumnValue(
        table.profileImageUrl,
        value,
      );

  _i1.ColumnValue<_i2.UserRole, _i2.UserRole> role(_i2.UserRole value) =>
      _i1.ColumnValue(
        table.role,
        value,
      );

  _i1.ColumnValue<_i3.UserAccountStatus, _i3.UserAccountStatus> status(
    _i3.UserAccountStatus value,
  ) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> approvedById(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.approvedById,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> statusChangedById(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.statusChangedById,
    value,
  );

  _i1.ColumnValue<bool, bool> isActive(bool value) => _i1.ColumnValue(
    table.isActive,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> deletedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.deletedAt,
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

class UserTable extends _i1.Table<_i1.UuidValue?> {
  UserTable({super.tableRelation}) : super(tableName: 'user') {
    updateTable = UserUpdateTable(this);
    authUserId = _i1.ColumnUuid(
      'authUserId',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    phone = _i1.ColumnString(
      'phone',
      this,
    );
    address = _i1.ColumnString(
      'address',
      this,
    );
    profileImageUrl = _i1.ColumnString(
      'profileImageUrl',
      this,
    );
    role = _i1.ColumnEnum(
      'role',
      this,
      _i1.EnumSerialization.byName,
      hasDefault: true,
    );
    status = _i1.ColumnEnum(
      'status',
      this,
      _i1.EnumSerialization.byName,
      hasDefault: true,
    );
    approvedById = _i1.ColumnUuid(
      'approvedById',
      this,
    );
    statusChangedById = _i1.ColumnUuid(
      'statusChangedById',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
      hasDefault: true,
    );
    deletedAt = _i1.ColumnDateTime(
      'deletedAt',
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

  late final UserUpdateTable updateTable;

  late final _i1.ColumnUuid authUserId;

  _i4.AuthUserTable? _authUser;

  late final _i1.ColumnString name;

  late final _i1.ColumnString email;

  late final _i1.ColumnString phone;

  late final _i1.ColumnString address;

  late final _i1.ColumnString profileImageUrl;

  late final _i1.ColumnEnum<_i2.UserRole> role;

  late final _i1.ColumnEnum<_i3.UserAccountStatus> status;

  late final _i1.ColumnUuid approvedById;

  /// Admin who approved this account (vendor onboarding or customer verification).
  _i5.AdminTable? _approvedBy;

  late final _i1.ColumnUuid statusChangedById;

  /// Admin who last changed status (suspend, reject, re-approve).
  _i5.AdminTable? _statusChangedBy;

  late final _i1.ColumnBool isActive;

  late final _i1.ColumnDateTime deletedAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  _i4.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _i1.createRelationTable(
      relationFieldName: 'authUser',
      field: User.t.authUserId,
      foreignField: _i4.AuthUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.AuthUserTable(tableRelation: foreignTableRelation),
    );
    return _authUser!;
  }

  _i5.AdminTable get approvedBy {
    if (_approvedBy != null) return _approvedBy!;
    _approvedBy = _i1.createRelationTable(
      relationFieldName: 'approvedBy',
      field: User.t.approvedById,
      foreignField: _i5.Admin.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i5.AdminTable(tableRelation: foreignTableRelation),
    );
    return _approvedBy!;
  }

  _i5.AdminTable get statusChangedBy {
    if (_statusChangedBy != null) return _statusChangedBy!;
    _statusChangedBy = _i1.createRelationTable(
      relationFieldName: 'statusChangedBy',
      field: User.t.statusChangedById,
      foreignField: _i5.Admin.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i5.AdminTable(tableRelation: foreignTableRelation),
    );
    return _statusChangedBy!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    authUserId,
    name,
    email,
    phone,
    address,
    profileImageUrl,
    role,
    status,
    approvedById,
    statusChangedById,
    isActive,
    deletedAt,
    createdAt,
    updatedAt,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    if (relationField == 'approvedBy') {
      return approvedBy;
    }
    if (relationField == 'statusChangedBy') {
      return statusChangedBy;
    }
    return null;
  }
}

class UserInclude extends _i1.IncludeObject {
  UserInclude._({
    _i4.AuthUserInclude? authUser,
    _i5.AdminInclude? approvedBy,
    _i5.AdminInclude? statusChangedBy,
  }) {
    _authUser = authUser;
    _approvedBy = approvedBy;
    _statusChangedBy = statusChangedBy;
  }

  _i4.AuthUserInclude? _authUser;

  _i5.AdminInclude? _approvedBy;

  _i5.AdminInclude? _statusChangedBy;

  @override
  Map<String, _i1.Include?> get includes => {
    'authUser': _authUser,
    'approvedBy': _approvedBy,
    'statusChangedBy': _statusChangedBy,
  };

  @override
  _i1.Table<_i1.UuidValue?> get table => User.t;
}

class UserIncludeList extends _i1.IncludeList {
  UserIncludeList._({
    _i1.WhereExpressionBuilder<UserTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(User.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => User.t;
}

class UserRepository {
  const UserRepository._();

  final attachRow = const UserAttachRowRepository._();

  final detachRow = const UserDetachRowRepository._();

  /// Returns a list of [User]s matching the given query parameters.
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
  Future<List<User>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UserTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserTable>? orderByList,
    _i1.Transaction? transaction,
    UserInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<User>(
      where: where?.call(User.t),
      orderBy: orderBy?.call(User.t),
      orderByList: orderByList?.call(User.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [User] matching the given query parameters.
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
  Future<User?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UserTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserTable>? orderByList,
    _i1.Transaction? transaction,
    UserInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<User>(
      where: where?.call(User.t),
      orderBy: orderBy?.call(User.t),
      orderByList: orderByList?.call(User.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [User] by its [id] or null if no such row exists.
  Future<User?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    UserInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<User>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [User]s in the list and returns the inserted rows.
  ///
  /// The returned [User]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<User>> insert(
    _i1.DatabaseSession session,
    List<User> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<User>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [User] and returns the inserted row.
  ///
  /// The returned [User] will have its `id` field set.
  Future<User> insertRow(
    _i1.DatabaseSession session,
    User row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<User>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [User]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<User>> update(
    _i1.DatabaseSession session,
    List<User> rows, {
    _i1.ColumnSelections<UserTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<User>(
      rows,
      columns: columns?.call(User.t),
      transaction: transaction,
    );
  }

  /// Updates a single [User]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<User> updateRow(
    _i1.DatabaseSession session,
    User row, {
    _i1.ColumnSelections<UserTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<User>(
      row,
      columns: columns?.call(User.t),
      transaction: transaction,
    );
  }

  /// Updates a single [User] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<User?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<UserUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<User>(
      id,
      columnValues: columnValues(User.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [User]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<User>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<UserUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<UserTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserTable>? orderBy,
    _i1.OrderByListBuilder<UserTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<User>(
      columnValues: columnValues(User.t.updateTable),
      where: where(User.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(User.t),
      orderByList: orderByList?.call(User.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [User]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<User>> delete(
    _i1.DatabaseSession session,
    List<User> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<User>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [User].
  Future<User> deleteRow(
    _i1.DatabaseSession session,
    User row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<User>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<User>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<UserTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<User>(
      where: where(User.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UserTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<User>(
      where: where?.call(User.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [User] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<UserTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<User>(
      where: where(User.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class UserAttachRowRepository {
  const UserAttachRowRepository._();

  /// Creates a relation between the given [User] and [AuthUser]
  /// by setting the [User]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _i1.DatabaseSession session,
    User user,
    _i4.AuthUser authUser, {
    _i1.Transaction? transaction,
  }) async {
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $user = user.copyWith(authUserId: authUser.id);
    await session.db.updateRow<User>(
      $user,
      columns: [User.t.authUserId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [User] and [Admin]
  /// by setting the [User]'s foreign key `approvedById` to refer to the [Admin].
  Future<void> approvedBy(
    _i1.DatabaseSession session,
    User user,
    _i5.Admin approvedBy, {
    _i1.Transaction? transaction,
  }) async {
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }
    if (approvedBy.id == null) {
      throw ArgumentError.notNull('approvedBy.id');
    }

    var $user = user.copyWith(approvedById: approvedBy.id);
    await session.db.updateRow<User>(
      $user,
      columns: [User.t.approvedById],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [User] and [Admin]
  /// by setting the [User]'s foreign key `statusChangedById` to refer to the [Admin].
  Future<void> statusChangedBy(
    _i1.DatabaseSession session,
    User user,
    _i5.Admin statusChangedBy, {
    _i1.Transaction? transaction,
  }) async {
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }
    if (statusChangedBy.id == null) {
      throw ArgumentError.notNull('statusChangedBy.id');
    }

    var $user = user.copyWith(statusChangedById: statusChangedBy.id);
    await session.db.updateRow<User>(
      $user,
      columns: [User.t.statusChangedById],
      transaction: transaction,
    );
  }
}

class UserDetachRowRepository {
  const UserDetachRowRepository._();

  /// Detaches the relation between this [User] and the [Admin] set in `approvedBy`
  /// by setting the [User]'s foreign key `approvedById` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> approvedBy(
    _i1.DatabaseSession session,
    User user, {
    _i1.Transaction? transaction,
  }) async {
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $user = user.copyWith(approvedById: null);
    await session.db.updateRow<User>(
      $user,
      columns: [User.t.approvedById],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [User] and the [Admin] set in `statusChangedBy`
  /// by setting the [User]'s foreign key `statusChangedById` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> statusChangedBy(
    _i1.DatabaseSession session,
    User user, {
    _i1.Transaction? transaction,
  }) async {
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $user = user.copyWith(statusChangedById: null);
    await session.db.updateRow<User>(
      $user,
      columns: [User.t.statusChangedById],
      transaction: transaction,
    );
  }
}
