// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor_operating_day.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VendorOperatingDay {
  String get dayKey;
  bool get isClosed;
  String get openTime;
  String get closeTime;

  /// Create a copy of VendorOperatingDay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VendorOperatingDayCopyWith<VendorOperatingDay> get copyWith =>
      _$VendorOperatingDayCopyWithImpl<VendorOperatingDay>(
          this as VendorOperatingDay, _$identity);

  /// Serializes this VendorOperatingDay to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VendorOperatingDay &&
            (identical(other.dayKey, dayKey) || other.dayKey == dayKey) &&
            (identical(other.isClosed, isClosed) ||
                other.isClosed == isClosed) &&
            (identical(other.openTime, openTime) ||
                other.openTime == openTime) &&
            (identical(other.closeTime, closeTime) ||
                other.closeTime == closeTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, dayKey, isClosed, openTime, closeTime);

  @override
  String toString() {
    return 'VendorOperatingDay(dayKey: $dayKey, isClosed: $isClosed, openTime: $openTime, closeTime: $closeTime)';
  }
}

/// @nodoc
abstract mixin class $VendorOperatingDayCopyWith<$Res> {
  factory $VendorOperatingDayCopyWith(
          VendorOperatingDay value, $Res Function(VendorOperatingDay) _then) =
      _$VendorOperatingDayCopyWithImpl;
  @useResult
  $Res call({String dayKey, bool isClosed, String openTime, String closeTime});
}

/// @nodoc
class _$VendorOperatingDayCopyWithImpl<$Res>
    implements $VendorOperatingDayCopyWith<$Res> {
  _$VendorOperatingDayCopyWithImpl(this._self, this._then);

  final VendorOperatingDay _self;
  final $Res Function(VendorOperatingDay) _then;

  /// Create a copy of VendorOperatingDay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayKey = null,
    Object? isClosed = null,
    Object? openTime = null,
    Object? closeTime = null,
  }) {
    return _then(_self.copyWith(
      dayKey: null == dayKey
          ? _self.dayKey
          : dayKey // ignore: cast_nullable_to_non_nullable
              as String,
      isClosed: null == isClosed
          ? _self.isClosed
          : isClosed // ignore: cast_nullable_to_non_nullable
              as bool,
      openTime: null == openTime
          ? _self.openTime
          : openTime // ignore: cast_nullable_to_non_nullable
              as String,
      closeTime: null == closeTime
          ? _self.closeTime
          : closeTime // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [VendorOperatingDay].
extension VendorOperatingDayPatterns on VendorOperatingDay {
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
    TResult Function(_VendorOperatingDay value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VendorOperatingDay() when $default != null:
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
    TResult Function(_VendorOperatingDay value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorOperatingDay():
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
    TResult? Function(_VendorOperatingDay value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorOperatingDay() when $default != null:
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
            String dayKey, bool isClosed, String openTime, String closeTime)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VendorOperatingDay() when $default != null:
        return $default(
            _that.dayKey, _that.isClosed, _that.openTime, _that.closeTime);
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
            String dayKey, bool isClosed, String openTime, String closeTime)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorOperatingDay():
        return $default(
            _that.dayKey, _that.isClosed, _that.openTime, _that.closeTime);
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
            String dayKey, bool isClosed, String openTime, String closeTime)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorOperatingDay() when $default != null:
        return $default(
            _that.dayKey, _that.isClosed, _that.openTime, _that.closeTime);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _VendorOperatingDay implements VendorOperatingDay {
  const _VendorOperatingDay(
      {required this.dayKey,
      this.isClosed = false,
      this.openTime = '09:00',
      this.closeTime = '17:00'});
  factory _VendorOperatingDay.fromJson(Map<String, dynamic> json) =>
      _$VendorOperatingDayFromJson(json);

  @override
  final String dayKey;
  @override
  @JsonKey()
  final bool isClosed;
  @override
  @JsonKey()
  final String openTime;
  @override
  @JsonKey()
  final String closeTime;

  /// Create a copy of VendorOperatingDay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VendorOperatingDayCopyWith<_VendorOperatingDay> get copyWith =>
      __$VendorOperatingDayCopyWithImpl<_VendorOperatingDay>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VendorOperatingDayToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VendorOperatingDay &&
            (identical(other.dayKey, dayKey) || other.dayKey == dayKey) &&
            (identical(other.isClosed, isClosed) ||
                other.isClosed == isClosed) &&
            (identical(other.openTime, openTime) ||
                other.openTime == openTime) &&
            (identical(other.closeTime, closeTime) ||
                other.closeTime == closeTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, dayKey, isClosed, openTime, closeTime);

  @override
  String toString() {
    return 'VendorOperatingDay(dayKey: $dayKey, isClosed: $isClosed, openTime: $openTime, closeTime: $closeTime)';
  }
}

/// @nodoc
abstract mixin class _$VendorOperatingDayCopyWith<$Res>
    implements $VendorOperatingDayCopyWith<$Res> {
  factory _$VendorOperatingDayCopyWith(
          _VendorOperatingDay value, $Res Function(_VendorOperatingDay) _then) =
      __$VendorOperatingDayCopyWithImpl;
  @override
  @useResult
  $Res call({String dayKey, bool isClosed, String openTime, String closeTime});
}

/// @nodoc
class __$VendorOperatingDayCopyWithImpl<$Res>
    implements _$VendorOperatingDayCopyWith<$Res> {
  __$VendorOperatingDayCopyWithImpl(this._self, this._then);

  final _VendorOperatingDay _self;
  final $Res Function(_VendorOperatingDay) _then;

  /// Create a copy of VendorOperatingDay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? dayKey = null,
    Object? isClosed = null,
    Object? openTime = null,
    Object? closeTime = null,
  }) {
    return _then(_VendorOperatingDay(
      dayKey: null == dayKey
          ? _self.dayKey
          : dayKey // ignore: cast_nullable_to_non_nullable
              as String,
      isClosed: null == isClosed
          ? _self.isClosed
          : isClosed // ignore: cast_nullable_to_non_nullable
              as bool,
      openTime: null == openTime
          ? _self.openTime
          : openTime // ignore: cast_nullable_to_non_nullable
              as String,
      closeTime: null == closeTime
          ? _self.closeTime
          : closeTime // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
