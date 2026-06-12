// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminStats {
  int get totalVendors;
  int get pendingCount;
  int get totalUsers;
  double get platformGmv;
  int get approvedCount;
  int get declinedCount;
  int get suspendedCount;
  List<AdminAuditLogEntry> get recentActivity;
  List<double> get signupSeries;
  List<VendorApplication> get recentApplications;

  /// Create a copy of AdminStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AdminStatsCopyWith<AdminStats> get copyWith =>
      _$AdminStatsCopyWithImpl<AdminStats>(this as AdminStats, _$identity);

  /// Serializes this AdminStats to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AdminStats &&
            (identical(other.totalVendors, totalVendors) ||
                other.totalVendors == totalVendors) &&
            (identical(other.pendingCount, pendingCount) ||
                other.pendingCount == pendingCount) &&
            (identical(other.totalUsers, totalUsers) ||
                other.totalUsers == totalUsers) &&
            (identical(other.platformGmv, platformGmv) ||
                other.platformGmv == platformGmv) &&
            (identical(other.approvedCount, approvedCount) ||
                other.approvedCount == approvedCount) &&
            (identical(other.declinedCount, declinedCount) ||
                other.declinedCount == declinedCount) &&
            (identical(other.suspendedCount, suspendedCount) ||
                other.suspendedCount == suspendedCount) &&
            const DeepCollectionEquality()
                .equals(other.recentActivity, recentActivity) &&
            const DeepCollectionEquality()
                .equals(other.signupSeries, signupSeries) &&
            const DeepCollectionEquality()
                .equals(other.recentApplications, recentApplications));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalVendors,
      pendingCount,
      totalUsers,
      platformGmv,
      approvedCount,
      declinedCount,
      suspendedCount,
      const DeepCollectionEquality().hash(recentActivity),
      const DeepCollectionEquality().hash(signupSeries),
      const DeepCollectionEquality().hash(recentApplications));

  @override
  String toString() {
    return 'AdminStats(totalVendors: $totalVendors, pendingCount: $pendingCount, totalUsers: $totalUsers, platformGmv: $platformGmv, approvedCount: $approvedCount, declinedCount: $declinedCount, suspendedCount: $suspendedCount, recentActivity: $recentActivity, signupSeries: $signupSeries, recentApplications: $recentApplications)';
  }
}

/// @nodoc
abstract mixin class $AdminStatsCopyWith<$Res> {
  factory $AdminStatsCopyWith(
          AdminStats value, $Res Function(AdminStats) _then) =
      _$AdminStatsCopyWithImpl;
  @useResult
  $Res call(
      {int totalVendors,
      int pendingCount,
      int totalUsers,
      double platformGmv,
      int approvedCount,
      int declinedCount,
      int suspendedCount,
      List<AdminAuditLogEntry> recentActivity,
      List<double> signupSeries,
      List<VendorApplication> recentApplications});
}

/// @nodoc
class _$AdminStatsCopyWithImpl<$Res> implements $AdminStatsCopyWith<$Res> {
  _$AdminStatsCopyWithImpl(this._self, this._then);

  final AdminStats _self;
  final $Res Function(AdminStats) _then;

  /// Create a copy of AdminStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalVendors = null,
    Object? pendingCount = null,
    Object? totalUsers = null,
    Object? platformGmv = null,
    Object? approvedCount = null,
    Object? declinedCount = null,
    Object? suspendedCount = null,
    Object? recentActivity = null,
    Object? signupSeries = null,
    Object? recentApplications = null,
  }) {
    return _then(_self.copyWith(
      totalVendors: null == totalVendors
          ? _self.totalVendors
          : totalVendors // ignore: cast_nullable_to_non_nullable
              as int,
      pendingCount: null == pendingCount
          ? _self.pendingCount
          : pendingCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalUsers: null == totalUsers
          ? _self.totalUsers
          : totalUsers // ignore: cast_nullable_to_non_nullable
              as int,
      platformGmv: null == platformGmv
          ? _self.platformGmv
          : platformGmv // ignore: cast_nullable_to_non_nullable
              as double,
      approvedCount: null == approvedCount
          ? _self.approvedCount
          : approvedCount // ignore: cast_nullable_to_non_nullable
              as int,
      declinedCount: null == declinedCount
          ? _self.declinedCount
          : declinedCount // ignore: cast_nullable_to_non_nullable
              as int,
      suspendedCount: null == suspendedCount
          ? _self.suspendedCount
          : suspendedCount // ignore: cast_nullable_to_non_nullable
              as int,
      recentActivity: null == recentActivity
          ? _self.recentActivity
          : recentActivity // ignore: cast_nullable_to_non_nullable
              as List<AdminAuditLogEntry>,
      signupSeries: null == signupSeries
          ? _self.signupSeries
          : signupSeries // ignore: cast_nullable_to_non_nullable
              as List<double>,
      recentApplications: null == recentApplications
          ? _self.recentApplications
          : recentApplications // ignore: cast_nullable_to_non_nullable
              as List<VendorApplication>,
    ));
  }
}

/// Adds pattern-matching-related methods to [AdminStats].
extension AdminStatsPatterns on AdminStats {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AdminStats value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AdminStats() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AdminStats value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminStats():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AdminStats value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminStats() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            int totalVendors,
            int pendingCount,
            int totalUsers,
            double platformGmv,
            int approvedCount,
            int declinedCount,
            int suspendedCount,
            List<AdminAuditLogEntry> recentActivity,
            List<double> signupSeries,
            List<VendorApplication> recentApplications)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AdminStats() when $default != null:
        return $default(
            _that.totalVendors,
            _that.pendingCount,
            _that.totalUsers,
            _that.platformGmv,
            _that.approvedCount,
            _that.declinedCount,
            _that.suspendedCount,
            _that.recentActivity,
            _that.signupSeries,
            _that.recentApplications);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            int totalVendors,
            int pendingCount,
            int totalUsers,
            double platformGmv,
            int approvedCount,
            int declinedCount,
            int suspendedCount,
            List<AdminAuditLogEntry> recentActivity,
            List<double> signupSeries,
            List<VendorApplication> recentApplications)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminStats():
        return $default(
            _that.totalVendors,
            _that.pendingCount,
            _that.totalUsers,
            _that.platformGmv,
            _that.approvedCount,
            _that.declinedCount,
            _that.suspendedCount,
            _that.recentActivity,
            _that.signupSeries,
            _that.recentApplications);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            int totalVendors,
            int pendingCount,
            int totalUsers,
            double platformGmv,
            int approvedCount,
            int declinedCount,
            int suspendedCount,
            List<AdminAuditLogEntry> recentActivity,
            List<double> signupSeries,
            List<VendorApplication> recentApplications)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminStats() when $default != null:
        return $default(
            _that.totalVendors,
            _that.pendingCount,
            _that.totalUsers,
            _that.platformGmv,
            _that.approvedCount,
            _that.declinedCount,
            _that.suspendedCount,
            _that.recentActivity,
            _that.signupSeries,
            _that.recentApplications);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AdminStats implements AdminStats {
  const _AdminStats(
      {required this.totalVendors,
      required this.pendingCount,
      required this.totalUsers,
      required this.platformGmv,
      required this.approvedCount,
      required this.declinedCount,
      required this.suspendedCount,
      final List<AdminAuditLogEntry> recentActivity =
          const <AdminAuditLogEntry>[],
      final List<double> signupSeries = const <double>[],
      final List<VendorApplication> recentApplications =
          const <VendorApplication>[]})
      : _recentActivity = recentActivity,
        _signupSeries = signupSeries,
        _recentApplications = recentApplications;
  factory _AdminStats.fromJson(Map<String, dynamic> json) =>
      _$AdminStatsFromJson(json);

  @override
  final int totalVendors;
  @override
  final int pendingCount;
  @override
  final int totalUsers;
  @override
  final double platformGmv;
  @override
  final int approvedCount;
  @override
  final int declinedCount;
  @override
  final int suspendedCount;
  final List<AdminAuditLogEntry> _recentActivity;
  @override
  @JsonKey()
  List<AdminAuditLogEntry> get recentActivity {
    if (_recentActivity is EqualUnmodifiableListView) return _recentActivity;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentActivity);
  }

  final List<double> _signupSeries;
  @override
  @JsonKey()
  List<double> get signupSeries {
    if (_signupSeries is EqualUnmodifiableListView) return _signupSeries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_signupSeries);
  }

  final List<VendorApplication> _recentApplications;
  @override
  @JsonKey()
  List<VendorApplication> get recentApplications {
    if (_recentApplications is EqualUnmodifiableListView)
      return _recentApplications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentApplications);
  }

  /// Create a copy of AdminStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AdminStatsCopyWith<_AdminStats> get copyWith =>
      __$AdminStatsCopyWithImpl<_AdminStats>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AdminStatsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AdminStats &&
            (identical(other.totalVendors, totalVendors) ||
                other.totalVendors == totalVendors) &&
            (identical(other.pendingCount, pendingCount) ||
                other.pendingCount == pendingCount) &&
            (identical(other.totalUsers, totalUsers) ||
                other.totalUsers == totalUsers) &&
            (identical(other.platformGmv, platformGmv) ||
                other.platformGmv == platformGmv) &&
            (identical(other.approvedCount, approvedCount) ||
                other.approvedCount == approvedCount) &&
            (identical(other.declinedCount, declinedCount) ||
                other.declinedCount == declinedCount) &&
            (identical(other.suspendedCount, suspendedCount) ||
                other.suspendedCount == suspendedCount) &&
            const DeepCollectionEquality()
                .equals(other._recentActivity, _recentActivity) &&
            const DeepCollectionEquality()
                .equals(other._signupSeries, _signupSeries) &&
            const DeepCollectionEquality()
                .equals(other._recentApplications, _recentApplications));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalVendors,
      pendingCount,
      totalUsers,
      platformGmv,
      approvedCount,
      declinedCount,
      suspendedCount,
      const DeepCollectionEquality().hash(_recentActivity),
      const DeepCollectionEquality().hash(_signupSeries),
      const DeepCollectionEquality().hash(_recentApplications));

  @override
  String toString() {
    return 'AdminStats(totalVendors: $totalVendors, pendingCount: $pendingCount, totalUsers: $totalUsers, platformGmv: $platformGmv, approvedCount: $approvedCount, declinedCount: $declinedCount, suspendedCount: $suspendedCount, recentActivity: $recentActivity, signupSeries: $signupSeries, recentApplications: $recentApplications)';
  }
}

/// @nodoc
abstract mixin class _$AdminStatsCopyWith<$Res>
    implements $AdminStatsCopyWith<$Res> {
  factory _$AdminStatsCopyWith(
          _AdminStats value, $Res Function(_AdminStats) _then) =
      __$AdminStatsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int totalVendors,
      int pendingCount,
      int totalUsers,
      double platformGmv,
      int approvedCount,
      int declinedCount,
      int suspendedCount,
      List<AdminAuditLogEntry> recentActivity,
      List<double> signupSeries,
      List<VendorApplication> recentApplications});
}

/// @nodoc
class __$AdminStatsCopyWithImpl<$Res> implements _$AdminStatsCopyWith<$Res> {
  __$AdminStatsCopyWithImpl(this._self, this._then);

  final _AdminStats _self;
  final $Res Function(_AdminStats) _then;

  /// Create a copy of AdminStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? totalVendors = null,
    Object? pendingCount = null,
    Object? totalUsers = null,
    Object? platformGmv = null,
    Object? approvedCount = null,
    Object? declinedCount = null,
    Object? suspendedCount = null,
    Object? recentActivity = null,
    Object? signupSeries = null,
    Object? recentApplications = null,
  }) {
    return _then(_AdminStats(
      totalVendors: null == totalVendors
          ? _self.totalVendors
          : totalVendors // ignore: cast_nullable_to_non_nullable
              as int,
      pendingCount: null == pendingCount
          ? _self.pendingCount
          : pendingCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalUsers: null == totalUsers
          ? _self.totalUsers
          : totalUsers // ignore: cast_nullable_to_non_nullable
              as int,
      platformGmv: null == platformGmv
          ? _self.platformGmv
          : platformGmv // ignore: cast_nullable_to_non_nullable
              as double,
      approvedCount: null == approvedCount
          ? _self.approvedCount
          : approvedCount // ignore: cast_nullable_to_non_nullable
              as int,
      declinedCount: null == declinedCount
          ? _self.declinedCount
          : declinedCount // ignore: cast_nullable_to_non_nullable
              as int,
      suspendedCount: null == suspendedCount
          ? _self.suspendedCount
          : suspendedCount // ignore: cast_nullable_to_non_nullable
              as int,
      recentActivity: null == recentActivity
          ? _self._recentActivity
          : recentActivity // ignore: cast_nullable_to_non_nullable
              as List<AdminAuditLogEntry>,
      signupSeries: null == signupSeries
          ? _self._signupSeries
          : signupSeries // ignore: cast_nullable_to_non_nullable
              as List<double>,
      recentApplications: null == recentApplications
          ? _self._recentApplications
          : recentApplications // ignore: cast_nullable_to_non_nullable
              as List<VendorApplication>,
    ));
  }
}

// dart format on
