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

 String get id; String get orderNumber; String get userId; String get vendorId; String get vendorName; ConsumerOrderStatus get status; List<OrderItem> get items; List<OrderStatusUpdate> get statusHistory;@JsonKey(includeFromJson: false, includeToJson: false) List<OrderPaymentEvent> get paymentUpdates; DateTime get placedAt; DateTime? get estimatedDelivery; DateTime? get deliveredAt; String? get trackingNumber; PaymentStatus get paymentStatus; String get paymentMethod; double get subtotal; double get deliveryFee; double get discount; double get total; String get deliveryAddress; String? get cancellationReason; String? get returnReason;
/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderCopyWith<Order> get copyWith => _$OrderCopyWithImpl<Order>(this as Order, _$identity);

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Order&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.vendorName, vendorName) || other.vendorName == vendorName)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items)&&const DeepCollectionEquality().equals(other.statusHistory, statusHistory)&&const DeepCollectionEquality().equals(other.paymentUpdates, paymentUpdates)&&(identical(other.placedAt, placedAt) || other.placedAt == placedAt)&&(identical(other.estimatedDelivery, estimatedDelivery) || other.estimatedDelivery == estimatedDelivery)&&(identical(other.deliveredAt, deliveredAt) || other.deliveredAt == deliveredAt)&&(identical(other.trackingNumber, trackingNumber) || other.trackingNumber == trackingNumber)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.deliveryFee, deliveryFee) || other.deliveryFee == deliveryFee)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.total, total) || other.total == total)&&(identical(other.deliveryAddress, deliveryAddress) || other.deliveryAddress == deliveryAddress)&&(identical(other.cancellationReason, cancellationReason) || other.cancellationReason == cancellationReason)&&(identical(other.returnReason, returnReason) || other.returnReason == returnReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,orderNumber,userId,vendorId,vendorName,status,const DeepCollectionEquality().hash(items),const DeepCollectionEquality().hash(statusHistory),const DeepCollectionEquality().hash(paymentUpdates),placedAt,estimatedDelivery,deliveredAt,trackingNumber,paymentStatus,paymentMethod,subtotal,deliveryFee,discount,total,deliveryAddress,cancellationReason,returnReason]);

@override
String toString() {
  return 'Order(id: $id, orderNumber: $orderNumber, userId: $userId, vendorId: $vendorId, vendorName: $vendorName, status: $status, items: $items, statusHistory: $statusHistory, paymentUpdates: $paymentUpdates, placedAt: $placedAt, estimatedDelivery: $estimatedDelivery, deliveredAt: $deliveredAt, trackingNumber: $trackingNumber, paymentStatus: $paymentStatus, paymentMethod: $paymentMethod, subtotal: $subtotal, deliveryFee: $deliveryFee, discount: $discount, total: $total, deliveryAddress: $deliveryAddress, cancellationReason: $cancellationReason, returnReason: $returnReason)';
}


}

/// @nodoc
abstract mixin class $OrderCopyWith<$Res>  {
  factory $OrderCopyWith(Order value, $Res Function(Order) _then) = _$OrderCopyWithImpl;
@useResult
$Res call({
 String id, String orderNumber, String userId, String vendorId, String vendorName, ConsumerOrderStatus status, List<OrderItem> items, List<OrderStatusUpdate> statusHistory,@JsonKey(includeFromJson: false, includeToJson: false) List<OrderPaymentEvent> paymentUpdates, DateTime placedAt, DateTime? estimatedDelivery, DateTime? deliveredAt, String? trackingNumber, PaymentStatus paymentStatus, String paymentMethod, double subtotal, double deliveryFee, double discount, double total, String deliveryAddress, String? cancellationReason, String? returnReason
});




}
/// @nodoc
class _$OrderCopyWithImpl<$Res>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._self, this._then);

  final Order _self;
  final $Res Function(Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderNumber = null,Object? userId = null,Object? vendorId = null,Object? vendorName = null,Object? status = null,Object? items = null,Object? statusHistory = null,Object? paymentUpdates = null,Object? placedAt = null,Object? estimatedDelivery = freezed,Object? deliveredAt = freezed,Object? trackingNumber = freezed,Object? paymentStatus = null,Object? paymentMethod = null,Object? subtotal = null,Object? deliveryFee = null,Object? discount = null,Object? total = null,Object? deliveryAddress = null,Object? cancellationReason = freezed,Object? returnReason = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String,vendorName: null == vendorName ? _self.vendorName : vendorName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ConsumerOrderStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItem>,statusHistory: null == statusHistory ? _self.statusHistory : statusHistory // ignore: cast_nullable_to_non_nullable
as List<OrderStatusUpdate>,paymentUpdates: null == paymentUpdates ? _self.paymentUpdates : paymentUpdates // ignore: cast_nullable_to_non_nullable
as List<OrderPaymentEvent>,placedAt: null == placedAt ? _self.placedAt : placedAt // ignore: cast_nullable_to_non_nullable
as DateTime,estimatedDelivery: freezed == estimatedDelivery ? _self.estimatedDelivery : estimatedDelivery // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveredAt: freezed == deliveredAt ? _self.deliveredAt : deliveredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,trackingNumber: freezed == trackingNumber ? _self.trackingNumber : trackingNumber // ignore: cast_nullable_to_non_nullable
as String?,paymentStatus: null == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as PaymentStatus,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,deliveryFee: null == deliveryFee ? _self.deliveryFee : deliveryFee // ignore: cast_nullable_to_non_nullable
as double,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as double,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,deliveryAddress: null == deliveryAddress ? _self.deliveryAddress : deliveryAddress // ignore: cast_nullable_to_non_nullable
as String,cancellationReason: freezed == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String?,returnReason: freezed == returnReason ? _self.returnReason : returnReason // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Order value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Order value)  $default,){
final _that = this;
switch (_that) {
case _Order():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Order value)?  $default,){
final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orderNumber,  String userId,  String vendorId,  String vendorName,  ConsumerOrderStatus status,  List<OrderItem> items,  List<OrderStatusUpdate> statusHistory, @JsonKey(includeFromJson: false, includeToJson: false)  List<OrderPaymentEvent> paymentUpdates,  DateTime placedAt,  DateTime? estimatedDelivery,  DateTime? deliveredAt,  String? trackingNumber,  PaymentStatus paymentStatus,  String paymentMethod,  double subtotal,  double deliveryFee,  double discount,  double total,  String deliveryAddress,  String? cancellationReason,  String? returnReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.orderNumber,_that.userId,_that.vendorId,_that.vendorName,_that.status,_that.items,_that.statusHistory,_that.paymentUpdates,_that.placedAt,_that.estimatedDelivery,_that.deliveredAt,_that.trackingNumber,_that.paymentStatus,_that.paymentMethod,_that.subtotal,_that.deliveryFee,_that.discount,_that.total,_that.deliveryAddress,_that.cancellationReason,_that.returnReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orderNumber,  String userId,  String vendorId,  String vendorName,  ConsumerOrderStatus status,  List<OrderItem> items,  List<OrderStatusUpdate> statusHistory, @JsonKey(includeFromJson: false, includeToJson: false)  List<OrderPaymentEvent> paymentUpdates,  DateTime placedAt,  DateTime? estimatedDelivery,  DateTime? deliveredAt,  String? trackingNumber,  PaymentStatus paymentStatus,  String paymentMethod,  double subtotal,  double deliveryFee,  double discount,  double total,  String deliveryAddress,  String? cancellationReason,  String? returnReason)  $default,) {final _that = this;
switch (_that) {
case _Order():
return $default(_that.id,_that.orderNumber,_that.userId,_that.vendorId,_that.vendorName,_that.status,_that.items,_that.statusHistory,_that.paymentUpdates,_that.placedAt,_that.estimatedDelivery,_that.deliveredAt,_that.trackingNumber,_that.paymentStatus,_that.paymentMethod,_that.subtotal,_that.deliveryFee,_that.discount,_that.total,_that.deliveryAddress,_that.cancellationReason,_that.returnReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orderNumber,  String userId,  String vendorId,  String vendorName,  ConsumerOrderStatus status,  List<OrderItem> items,  List<OrderStatusUpdate> statusHistory, @JsonKey(includeFromJson: false, includeToJson: false)  List<OrderPaymentEvent> paymentUpdates,  DateTime placedAt,  DateTime? estimatedDelivery,  DateTime? deliveredAt,  String? trackingNumber,  PaymentStatus paymentStatus,  String paymentMethod,  double subtotal,  double deliveryFee,  double discount,  double total,  String deliveryAddress,  String? cancellationReason,  String? returnReason)?  $default,) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.orderNumber,_that.userId,_that.vendorId,_that.vendorName,_that.status,_that.items,_that.statusHistory,_that.paymentUpdates,_that.placedAt,_that.estimatedDelivery,_that.deliveredAt,_that.trackingNumber,_that.paymentStatus,_that.paymentMethod,_that.subtotal,_that.deliveryFee,_that.discount,_that.total,_that.deliveryAddress,_that.cancellationReason,_that.returnReason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Order extends Order {
  const _Order({required this.id, required this.orderNumber, required this.userId, required this.vendorId, required this.vendorName, required this.status, required final  List<OrderItem> items, required final  List<OrderStatusUpdate> statusHistory, @JsonKey(includeFromJson: false, includeToJson: false) final  List<OrderPaymentEvent> paymentUpdates = const [], required this.placedAt, this.estimatedDelivery, this.deliveredAt, this.trackingNumber, required this.paymentStatus, required this.paymentMethod, required this.subtotal, required this.deliveryFee, this.discount = 0, required this.total, required this.deliveryAddress, this.cancellationReason, this.returnReason}): _items = items,_statusHistory = statusHistory,_paymentUpdates = paymentUpdates,super._();
  factory _Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

@override final  String id;
@override final  String orderNumber;
@override final  String userId;
@override final  String vendorId;
@override final  String vendorName;
@override final  ConsumerOrderStatus status;
 final  List<OrderItem> _items;
@override List<OrderItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  List<OrderStatusUpdate> _statusHistory;
@override List<OrderStatusUpdate> get statusHistory {
  if (_statusHistory is EqualUnmodifiableListView) return _statusHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_statusHistory);
}

 final  List<OrderPaymentEvent> _paymentUpdates;
@override@JsonKey(includeFromJson: false, includeToJson: false) List<OrderPaymentEvent> get paymentUpdates {
  if (_paymentUpdates is EqualUnmodifiableListView) return _paymentUpdates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_paymentUpdates);
}

@override final  DateTime placedAt;
@override final  DateTime? estimatedDelivery;
@override final  DateTime? deliveredAt;
@override final  String? trackingNumber;
@override final  PaymentStatus paymentStatus;
@override final  String paymentMethod;
@override final  double subtotal;
@override final  double deliveryFee;
@override@JsonKey() final  double discount;
@override final  double total;
@override final  String deliveryAddress;
@override final  String? cancellationReason;
@override final  String? returnReason;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderCopyWith<_Order> get copyWith => __$OrderCopyWithImpl<_Order>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Order&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.vendorName, vendorName) || other.vendorName == vendorName)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items)&&const DeepCollectionEquality().equals(other._statusHistory, _statusHistory)&&const DeepCollectionEquality().equals(other._paymentUpdates, _paymentUpdates)&&(identical(other.placedAt, placedAt) || other.placedAt == placedAt)&&(identical(other.estimatedDelivery, estimatedDelivery) || other.estimatedDelivery == estimatedDelivery)&&(identical(other.deliveredAt, deliveredAt) || other.deliveredAt == deliveredAt)&&(identical(other.trackingNumber, trackingNumber) || other.trackingNumber == trackingNumber)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.deliveryFee, deliveryFee) || other.deliveryFee == deliveryFee)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.total, total) || other.total == total)&&(identical(other.deliveryAddress, deliveryAddress) || other.deliveryAddress == deliveryAddress)&&(identical(other.cancellationReason, cancellationReason) || other.cancellationReason == cancellationReason)&&(identical(other.returnReason, returnReason) || other.returnReason == returnReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,orderNumber,userId,vendorId,vendorName,status,const DeepCollectionEquality().hash(_items),const DeepCollectionEquality().hash(_statusHistory),const DeepCollectionEquality().hash(_paymentUpdates),placedAt,estimatedDelivery,deliveredAt,trackingNumber,paymentStatus,paymentMethod,subtotal,deliveryFee,discount,total,deliveryAddress,cancellationReason,returnReason]);

@override
String toString() {
  return 'Order(id: $id, orderNumber: $orderNumber, userId: $userId, vendorId: $vendorId, vendorName: $vendorName, status: $status, items: $items, statusHistory: $statusHistory, paymentUpdates: $paymentUpdates, placedAt: $placedAt, estimatedDelivery: $estimatedDelivery, deliveredAt: $deliveredAt, trackingNumber: $trackingNumber, paymentStatus: $paymentStatus, paymentMethod: $paymentMethod, subtotal: $subtotal, deliveryFee: $deliveryFee, discount: $discount, total: $total, deliveryAddress: $deliveryAddress, cancellationReason: $cancellationReason, returnReason: $returnReason)';
}


}

/// @nodoc
abstract mixin class _$OrderCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$OrderCopyWith(_Order value, $Res Function(_Order) _then) = __$OrderCopyWithImpl;
@override @useResult
$Res call({
 String id, String orderNumber, String userId, String vendorId, String vendorName, ConsumerOrderStatus status, List<OrderItem> items, List<OrderStatusUpdate> statusHistory,@JsonKey(includeFromJson: false, includeToJson: false) List<OrderPaymentEvent> paymentUpdates, DateTime placedAt, DateTime? estimatedDelivery, DateTime? deliveredAt, String? trackingNumber, PaymentStatus paymentStatus, String paymentMethod, double subtotal, double deliveryFee, double discount, double total, String deliveryAddress, String? cancellationReason, String? returnReason
});




}
/// @nodoc
class __$OrderCopyWithImpl<$Res>
    implements _$OrderCopyWith<$Res> {
  __$OrderCopyWithImpl(this._self, this._then);

  final _Order _self;
  final $Res Function(_Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderNumber = null,Object? userId = null,Object? vendorId = null,Object? vendorName = null,Object? status = null,Object? items = null,Object? statusHistory = null,Object? paymentUpdates = null,Object? placedAt = null,Object? estimatedDelivery = freezed,Object? deliveredAt = freezed,Object? trackingNumber = freezed,Object? paymentStatus = null,Object? paymentMethod = null,Object? subtotal = null,Object? deliveryFee = null,Object? discount = null,Object? total = null,Object? deliveryAddress = null,Object? cancellationReason = freezed,Object? returnReason = freezed,}) {
  return _then(_Order(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String,vendorName: null == vendorName ? _self.vendorName : vendorName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ConsumerOrderStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItem>,statusHistory: null == statusHistory ? _self._statusHistory : statusHistory // ignore: cast_nullable_to_non_nullable
as List<OrderStatusUpdate>,paymentUpdates: null == paymentUpdates ? _self._paymentUpdates : paymentUpdates // ignore: cast_nullable_to_non_nullable
as List<OrderPaymentEvent>,placedAt: null == placedAt ? _self.placedAt : placedAt // ignore: cast_nullable_to_non_nullable
as DateTime,estimatedDelivery: freezed == estimatedDelivery ? _self.estimatedDelivery : estimatedDelivery // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveredAt: freezed == deliveredAt ? _self.deliveredAt : deliveredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,trackingNumber: freezed == trackingNumber ? _self.trackingNumber : trackingNumber // ignore: cast_nullable_to_non_nullable
as String?,paymentStatus: null == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as PaymentStatus,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,deliveryFee: null == deliveryFee ? _self.deliveryFee : deliveryFee // ignore: cast_nullable_to_non_nullable
as double,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as double,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,deliveryAddress: null == deliveryAddress ? _self.deliveryAddress : deliveryAddress // ignore: cast_nullable_to_non_nullable
as String,cancellationReason: freezed == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String?,returnReason: freezed == returnReason ? _self.returnReason : returnReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
