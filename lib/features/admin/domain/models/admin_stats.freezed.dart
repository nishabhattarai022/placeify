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
  int get pendingCount;
  int get approvedCount;
  int get suspendedCount;
  int get totalUsers;
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
            (identical(other.pendingCount, pendingCount) ||
                other.pendingCount == pendingCount) &&
            (identical(other.approvedCount, approvedCount) ||
                other.approvedCount == approvedCount) &&
            (identical(other.suspendedCount, suspendedCount) ||
                other.suspendedCount == suspendedCount) &&
            (identical(other.totalUsers, totalUsers) ||
                other.totalUsers == totalUsers) &&
            const DeepCollectionEquality()
                .equals(other.recentApplications, recentApplications));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      pendingCount,
      approvedCount,
      suspendedCount,
      totalUsers,
      const DeepCollectionEquality().hash(recentApplications));

  @override
  String toString() {
    return 'AdminStats(pendingCount: $pendingCount, approvedCount: $approvedCount, suspendedCount: $suspendedCount, totalUsers: $totalUsers, recentApplications: $recentApplications)';
  }
}

/// @nodoc
abstract mixin class $AdminStatsCopyWith<$Res> {
  factory $AdminStatsCopyWith(
          AdminStats value, $Res Function(AdminStats) _then) =
      _$AdminStatsCopyWithImpl;
  @useResult
  $Res call(
      {int pendingCount,
      int approvedCount,
      int suspendedCount,
      int totalUsers,
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
    Object? pendingCount = null,
    Object? approvedCount = null,
    Object? suspendedCount = null,
    Object? totalUsers = null,
    Object? recentApplications = null,
  }) {
    return _then(_self.copyWith(
      pendingCount: null == pendingCount
          ? _self.pendingCount
          : pendingCount // ignore: cast_nullable_to_non_nullable
              as int,
      approvedCount: null == approvedCount
          ? _self.approvedCount
          : approvedCount // ignore: cast_nullable_to_non_nullable
              as int,
      suspendedCount: null == suspendedCount
          ? _self.suspendedCount
          : suspendedCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalUsers: null == totalUsers
          ? _self.totalUsers
          : totalUsers // ignore: cast_nullable_to_non_nullable
              as int,
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
    TResult Function(int pendingCount, int approvedCount, int suspendedCount,
            int totalUsers, List<VendorApplication> recentApplications)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AdminStats() when $default != null:
        return $default(_that.pendingCount, _that.approvedCount,
            _that.suspendedCount, _that.totalUsers, _that.recentApplications);
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
    TResult Function(int pendingCount, int approvedCount, int suspendedCount,
            int totalUsers, List<VendorApplication> recentApplications)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminStats():
        return $default(_that.pendingCount, _that.approvedCount,
            _that.suspendedCount, _that.totalUsers, _that.recentApplications);
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
    TResult? Function(int pendingCount, int approvedCount, int suspendedCount,
            int totalUsers, List<VendorApplication> recentApplications)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminStats() when $default != null:
        return $default(_that.pendingCount, _that.approvedCount,
            _that.suspendedCount, _that.totalUsers, _that.recentApplications);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AdminStats implements AdminStats {
  const _AdminStats(
      {required this.pendingCount,
      required this.approvedCount,
      required this.suspendedCount,
      required this.totalUsers,
      final List<VendorApplication> recentApplications =
          const <VendorApplication>[]})
      : _recentApplications = recentApplications;
  factory _AdminStats.fromJson(Map<String, dynamic> json) =>
      _$AdminStatsFromJson(json);

  @override
  final int pendingCount;
  @override
  final int approvedCount;
  @override
  final int suspendedCount;
  @override
  final int totalUsers;
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
            (identical(other.pendingCount, pendingCount) ||
                other.pendingCount == pendingCount) &&
            (identical(other.approvedCount, approvedCount) ||
                other.approvedCount == approvedCount) &&
            (identical(other.suspendedCount, suspendedCount) ||
                other.suspendedCount == suspendedCount) &&
            (identical(other.totalUsers, totalUsers) ||
                other.totalUsers == totalUsers) &&
            const DeepCollectionEquality()
                .equals(other._recentApplications, _recentApplications));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      pendingCount,
      approvedCount,
      suspendedCount,
      totalUsers,
      const DeepCollectionEquality().hash(_recentApplications));

  @override
  String toString() {
    return 'AdminStats(pendingCount: $pendingCount, approvedCount: $approvedCount, suspendedCount: $suspendedCount, totalUsers: $totalUsers, recentApplications: $recentApplications)';
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
      {int pendingCount,
      int approvedCount,
      int suspendedCount,
      int totalUsers,
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
    Object? pendingCount = null,
    Object? approvedCount = null,
    Object? suspendedCount = null,
    Object? totalUsers = null,
    Object? recentApplications = null,
  }) {
    return _then(_AdminStats(
      pendingCount: null == pendingCount
          ? _self.pendingCount
          : pendingCount // ignore: cast_nullable_to_non_nullable
              as int,
      approvedCount: null == approvedCount
          ? _self.approvedCount
          : approvedCount // ignore: cast_nullable_to_non_nullable
              as int,
      suspendedCount: null == suspendedCount
          ? _self.suspendedCount
          : suspendedCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalUsers: null == totalUsers
          ? _self.totalUsers
          : totalUsers // ignore: cast_nullable_to_non_nullable
              as int,
      recentApplications: null == recentApplications
          ? _self._recentApplications
          : recentApplications // ignore: cast_nullable_to_non_nullable
              as List<VendorApplication>,
    ));
  }
}

// dart format on
