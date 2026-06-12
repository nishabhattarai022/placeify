// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminNotification {
  String get id;
  String get title;
  String get body;
  DateTime get createdAt;
  bool get read;
  AdminNotificationType get type;
  String? get linkedVendorId;

  /// Create a copy of AdminNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AdminNotificationCopyWith<AdminNotification> get copyWith =>
      _$AdminNotificationCopyWithImpl<AdminNotification>(
          this as AdminNotification, _$identity);

  /// Serializes this AdminNotification to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AdminNotification &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.read, read) || other.read == read) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.linkedVendorId, linkedVendorId) ||
                other.linkedVendorId == linkedVendorId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, body, createdAt, read, type, linkedVendorId);

  @override
  String toString() {
    return 'AdminNotification(id: $id, title: $title, body: $body, createdAt: $createdAt, read: $read, type: $type, linkedVendorId: $linkedVendorId)';
  }
}

/// @nodoc
abstract mixin class $AdminNotificationCopyWith<$Res> {
  factory $AdminNotificationCopyWith(
          AdminNotification value, $Res Function(AdminNotification) _then) =
      _$AdminNotificationCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String title,
      String body,
      DateTime createdAt,
      bool read,
      AdminNotificationType type,
      String? linkedVendorId});
}

/// @nodoc
class _$AdminNotificationCopyWithImpl<$Res>
    implements $AdminNotificationCopyWith<$Res> {
  _$AdminNotificationCopyWithImpl(this._self, this._then);

  final AdminNotification _self;
  final $Res Function(AdminNotification) _then;

  /// Create a copy of AdminNotification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? createdAt = null,
    Object? read = null,
    Object? type = null,
    Object? linkedVendorId = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      read: null == read
          ? _self.read
          : read // ignore: cast_nullable_to_non_nullable
              as bool,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as AdminNotificationType,
      linkedVendorId: freezed == linkedVendorId
          ? _self.linkedVendorId
          : linkedVendorId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [AdminNotification].
extension AdminNotificationPatterns on AdminNotification {
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
    TResult Function(_AdminNotification value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AdminNotification() when $default != null:
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
    TResult Function(_AdminNotification value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminNotification():
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
    TResult? Function(_AdminNotification value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminNotification() when $default != null:
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
    TResult Function(String id, String title, String body, DateTime createdAt,
            bool read, AdminNotificationType type, String? linkedVendorId)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AdminNotification() when $default != null:
        return $default(_that.id, _that.title, _that.body, _that.createdAt,
            _that.read, _that.type, _that.linkedVendorId);
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
    TResult Function(String id, String title, String body, DateTime createdAt,
            bool read, AdminNotificationType type, String? linkedVendorId)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminNotification():
        return $default(_that.id, _that.title, _that.body, _that.createdAt,
            _that.read, _that.type, _that.linkedVendorId);
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
    TResult? Function(String id, String title, String body, DateTime createdAt,
            bool read, AdminNotificationType type, String? linkedVendorId)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminNotification() when $default != null:
        return $default(_that.id, _that.title, _that.body, _that.createdAt,
            _that.read, _that.type, _that.linkedVendorId);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AdminNotification implements AdminNotification {
  const _AdminNotification(
      {required this.id,
      required this.title,
      required this.body,
      required this.createdAt,
      this.read = false,
      this.type = AdminNotificationType.systemAlert,
      this.linkedVendorId});
  factory _AdminNotification.fromJson(Map<String, dynamic> json) =>
      _$AdminNotificationFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String body;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final bool read;
  @override
  @JsonKey()
  final AdminNotificationType type;
  @override
  final String? linkedVendorId;

  /// Create a copy of AdminNotification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AdminNotificationCopyWith<_AdminNotification> get copyWith =>
      __$AdminNotificationCopyWithImpl<_AdminNotification>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AdminNotificationToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AdminNotification &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.read, read) || other.read == read) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.linkedVendorId, linkedVendorId) ||
                other.linkedVendorId == linkedVendorId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, body, createdAt, read, type, linkedVendorId);

  @override
  String toString() {
    return 'AdminNotification(id: $id, title: $title, body: $body, createdAt: $createdAt, read: $read, type: $type, linkedVendorId: $linkedVendorId)';
  }
}

/// @nodoc
abstract mixin class _$AdminNotificationCopyWith<$Res>
    implements $AdminNotificationCopyWith<$Res> {
  factory _$AdminNotificationCopyWith(
          _AdminNotification value, $Res Function(_AdminNotification) _then) =
      __$AdminNotificationCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String body,
      DateTime createdAt,
      bool read,
      AdminNotificationType type,
      String? linkedVendorId});
}

/// @nodoc
class __$AdminNotificationCopyWithImpl<$Res>
    implements _$AdminNotificationCopyWith<$Res> {
  __$AdminNotificationCopyWithImpl(this._self, this._then);

  final _AdminNotification _self;
  final $Res Function(_AdminNotification) _then;

  /// Create a copy of AdminNotification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? createdAt = null,
    Object? read = null,
    Object? type = null,
    Object? linkedVendorId = freezed,
  }) {
    return _then(_AdminNotification(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      read: null == read
          ? _self.read
          : read // ignore: cast_nullable_to_non_nullable
              as bool,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as AdminNotificationType,
      linkedVendorId: freezed == linkedVendorId
          ? _self.linkedVendorId
          : linkedVendorId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
