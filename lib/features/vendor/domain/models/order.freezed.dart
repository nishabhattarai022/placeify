// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Order {
  String get id;
  String get orderNumber;
  String get productName;
  String get productSvgIconPath;
  int get quantity;
  DateTime get date;
  OrderStatus get status;
  String? get requestMeta;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderCopyWith<Order> get copyWith =>
      _$OrderCopyWithImpl<Order>(this as Order, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Order &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.productSvgIconPath, productSvgIconPath) ||
                other.productSvgIconPath == productSvgIconPath) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.requestMeta, requestMeta) ||
                other.requestMeta == requestMeta));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, orderNumber, productName,
      productSvgIconPath, quantity, date, status, requestMeta);

  @override
  String toString() {
    return 'Order(id: $id, orderNumber: $orderNumber, productName: $productName, productSvgIconPath: $productSvgIconPath, quantity: $quantity, date: $date, status: $status, requestMeta: $requestMeta)';
  }
}

/// @nodoc
abstract mixin class $OrderCopyWith<$Res> {
  factory $OrderCopyWith(Order value, $Res Function(Order) _then) =
      _$OrderCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String orderNumber,
      String productName,
      String productSvgIconPath,
      int quantity,
      DateTime date,
      OrderStatus status,
      String? requestMeta});
}

/// @nodoc
class _$OrderCopyWithImpl<$Res> implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._self, this._then);

  final Order _self;
  final $Res Function(Order) _then;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? productName = null,
    Object? productSvgIconPath = null,
    Object? quantity = null,
    Object? date = null,
    Object? status = null,
    Object? requestMeta = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderNumber: null == orderNumber
          ? _self.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _self.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      productSvgIconPath: null == productSvgIconPath
          ? _self.productSvgIconPath
          : productSvgIconPath // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as OrderStatus,
      requestMeta: freezed == requestMeta
          ? _self.requestMeta
          : requestMeta // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Order].
extension OrderPatterns on Order {
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
    TResult Function(_Order value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Order() when $default != null:
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
    TResult Function(_Order value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Order():
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
    TResult? Function(_Order value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Order() when $default != null:
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
            String id,
            String orderNumber,
            String productName,
            String productSvgIconPath,
            int quantity,
            DateTime date,
            OrderStatus status,
            String? requestMeta)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Order() when $default != null:
        return $default(
            _that.id,
            _that.orderNumber,
            _that.productName,
            _that.productSvgIconPath,
            _that.quantity,
            _that.date,
            _that.status,
            _that.requestMeta);
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
            String id,
            String orderNumber,
            String productName,
            String productSvgIconPath,
            int quantity,
            DateTime date,
            OrderStatus status,
            String? requestMeta)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Order():
        return $default(
            _that.id,
            _that.orderNumber,
            _that.productName,
            _that.productSvgIconPath,
            _that.quantity,
            _that.date,
            _that.status,
            _that.requestMeta);
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
            String id,
            String orderNumber,
            String productName,
            String productSvgIconPath,
            int quantity,
            DateTime date,
            OrderStatus status,
            String? requestMeta)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Order() when $default != null:
        return $default(
            _that.id,
            _that.orderNumber,
            _that.productName,
            _that.productSvgIconPath,
            _that.quantity,
            _that.date,
            _that.status,
            _that.requestMeta);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Order extends Order {
  const _Order(
      {required this.id,
      required this.orderNumber,
      required this.productName,
      required this.productSvgIconPath,
      required this.quantity,
      required this.date,
      required this.status,
      this.requestMeta})
      : super._();

  @override
  final String id;
  @override
  final String orderNumber;
  @override
  final String productName;
  @override
  final String productSvgIconPath;
  @override
  final int quantity;
  @override
  final DateTime date;
  @override
  final OrderStatus status;
  @override
  final String? requestMeta;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrderCopyWith<_Order> get copyWith =>
      __$OrderCopyWithImpl<_Order>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Order &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.productSvgIconPath, productSvgIconPath) ||
                other.productSvgIconPath == productSvgIconPath) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.requestMeta, requestMeta) ||
                other.requestMeta == requestMeta));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, orderNumber, productName,
      productSvgIconPath, quantity, date, status, requestMeta);

  @override
  String toString() {
    return 'Order(id: $id, orderNumber: $orderNumber, productName: $productName, productSvgIconPath: $productSvgIconPath, quantity: $quantity, date: $date, status: $status, requestMeta: $requestMeta)';
  }
}

/// @nodoc
abstract mixin class _$OrderCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$OrderCopyWith(_Order value, $Res Function(_Order) _then) =
      __$OrderCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String orderNumber,
      String productName,
      String productSvgIconPath,
      int quantity,
      DateTime date,
      OrderStatus status,
      String? requestMeta});
}

/// @nodoc
class __$OrderCopyWithImpl<$Res> implements _$OrderCopyWith<$Res> {
  __$OrderCopyWithImpl(this._self, this._then);

  final _Order _self;
  final $Res Function(_Order) _then;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? productName = null,
    Object? productSvgIconPath = null,
    Object? quantity = null,
    Object? date = null,
    Object? status = null,
    Object? requestMeta = freezed,
  }) {
    return _then(_Order(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderNumber: null == orderNumber
          ? _self.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _self.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      productSvgIconPath: null == productSvgIconPath
          ? _self.productSvgIconPath
          : productSvgIconPath // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as OrderStatus,
      requestMeta: freezed == requestMeta
          ? _self.requestMeta
          : requestMeta // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
