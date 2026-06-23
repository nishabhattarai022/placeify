// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor_notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VendorNotification {
  String get id;
  NotificationType get type;
  String get title;
  String get body;
  bool get isRead;
  DateTime get createdAt;
  String? get relatedId;

  /// Create a copy of VendorNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VendorNotificationCopyWith<VendorNotification> get copyWith =>
      _$VendorNotificationCopyWithImpl<VendorNotification>(
          this as VendorNotification, _$identity);

  /// Serializes this VendorNotification to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VendorNotification &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.relatedId, relatedId) ||
                other.relatedId == relatedId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, type, title, body, isRead, createdAt, relatedId);

  @override
  String toString() {
    return 'VendorNotification(id: $id, type: $type, title: $title, body: $body, isRead: $isRead, createdAt: $createdAt, relatedId: $relatedId)';
  }
}

/// @nodoc
abstract mixin class $VendorNotificationCopyWith<$Res> {
  factory $VendorNotificationCopyWith(
          VendorNotification value, $Res Function(VendorNotification) _then) =
      _$VendorNotificationCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      NotificationType type,
      String title,
      String body,
      bool isRead,
      DateTime createdAt,
      String? relatedId});
}

/// @nodoc
class _$VendorNotificationCopyWithImpl<$Res>
    implements $VendorNotificationCopyWith<$Res> {
  _$VendorNotificationCopyWithImpl(this._self, this._then);

  final VendorNotification _self;
  final $Res Function(VendorNotification) _then;

  /// Create a copy of VendorNotification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? body = null,
    Object? isRead = null,
    Object? createdAt = null,
    Object? relatedId = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as NotificationType,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      isRead: null == isRead
          ? _self.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      relatedId: freezed == relatedId
          ? _self.relatedId
          : relatedId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [VendorNotification].
extension VendorNotificationPatterns on VendorNotification {
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
    TResult Function(_VendorNotification value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VendorNotification() when $default != null:
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
    TResult Function(_VendorNotification value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorNotification():
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
    TResult? Function(_VendorNotification value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorNotification() when $default != null:
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
    TResult Function(String id, NotificationType type, String title,
            String body, bool isRead, DateTime createdAt, String? relatedId)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VendorNotification() when $default != null:
        return $default(_that.id, _that.type, _that.title, _that.body,
            _that.isRead, _that.createdAt, _that.relatedId);
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
    TResult Function(String id, NotificationType type, String title,
            String body, bool isRead, DateTime createdAt, String? relatedId)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorNotification():
        return $default(_that.id, _that.type, _that.title, _that.body,
            _that.isRead, _that.createdAt, _that.relatedId);
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
    TResult? Function(String id, NotificationType type, String title,
            String body, bool isRead, DateTime createdAt, String? relatedId)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorNotification() when $default != null:
        return $default(_that.id, _that.type, _that.title, _that.body,
            _that.isRead, _that.createdAt, _that.relatedId);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _VendorNotification implements VendorNotification {
  const _VendorNotification(
      {required this.id,
      required this.type,
      required this.title,
      required this.body,
      this.isRead = false,
      required this.createdAt,
      this.relatedId});
  factory _VendorNotification.fromJson(Map<String, dynamic> json) =>
      _$VendorNotificationFromJson(json);

  @override
  final String id;
  @override
  final NotificationType type;
  @override
  final String title;
  @override
  final String body;
  @override
  @JsonKey()
  final bool isRead;
  @override
  final DateTime createdAt;
  @override
  final String? relatedId;

  /// Create a copy of VendorNotification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VendorNotificationCopyWith<_VendorNotification> get copyWith =>
      __$VendorNotificationCopyWithImpl<_VendorNotification>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VendorNotificationToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VendorNotification &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.relatedId, relatedId) ||
                other.relatedId == relatedId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, type, title, body, isRead, createdAt, relatedId);

  @override
  String toString() {
    return 'VendorNotification(id: $id, type: $type, title: $title, body: $body, isRead: $isRead, createdAt: $createdAt, relatedId: $relatedId)';
  }
}

/// @nodoc
abstract mixin class _$VendorNotificationCopyWith<$Res>
    implements $VendorNotificationCopyWith<$Res> {
  factory _$VendorNotificationCopyWith(
          _VendorNotification value, $Res Function(_VendorNotification) _then) =
      __$VendorNotificationCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      NotificationType type,
      String title,
      String body,
      bool isRead,
      DateTime createdAt,
      String? relatedId});
}

/// @nodoc
class __$VendorNotificationCopyWithImpl<$Res>
    implements _$VendorNotificationCopyWith<$Res> {
  __$VendorNotificationCopyWithImpl(this._self, this._then);

  final _VendorNotification _self;
  final $Res Function(_VendorNotification) _then;

  /// Create a copy of VendorNotification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? body = null,
    Object? isRead = null,
    Object? createdAt = null,
    Object? relatedId = freezed,
  }) {
    return _then(_VendorNotification(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as NotificationType,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      isRead: null == isRead
          ? _self.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      relatedId: freezed == relatedId
          ? _self.relatedId
          : relatedId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
