// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VendorOrder {

 String get id; String get orderNumber; String get vendorId; String get productId; String get productName; int get quantity; double get totalAmount; OrderStatus get status; String get customerName; DateTime get orderedAt;
/// Create a copy of VendorOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VendorOrderCopyWith<VendorOrder> get copyWith => _$VendorOrderCopyWithImpl<VendorOrder>(this as VendorOrder, _$identity);

  /// Serializes this VendorOrder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VendorOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.status, status) || other.status == status)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.orderedAt, orderedAt) || other.orderedAt == orderedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderNumber,vendorId,productId,productName,quantity,totalAmount,status,customerName,orderedAt);

@override
String toString() {
  return 'VendorOrder(id: $id, orderNumber: $orderNumber, vendorId: $vendorId, productId: $productId, productName: $productName, quantity: $quantity, totalAmount: $totalAmount, status: $status, customerName: $customerName, orderedAt: $orderedAt)';
}


}

/// @nodoc
abstract mixin class $VendorOrderCopyWith<$Res>  {
  factory $VendorOrderCopyWith(VendorOrder value, $Res Function(VendorOrder) _then) = _$VendorOrderCopyWithImpl;
@useResult
$Res call({
 String id, String orderNumber, String vendorId, String productId, String productName, int quantity, double totalAmount, OrderStatus status, String customerName, DateTime orderedAt
});




}
/// @nodoc
class _$VendorOrderCopyWithImpl<$Res>
    implements $VendorOrderCopyWith<$Res> {
  _$VendorOrderCopyWithImpl(this._self, this._then);

  final VendorOrder _self;
  final $Res Function(VendorOrder) _then;

/// Create a copy of VendorOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderNumber = null,Object? vendorId = null,Object? productId = null,Object? productName = null,Object? quantity = null,Object? totalAmount = null,Object? status = null,Object? customerName = null,Object? orderedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,orderedAt: null == orderedAt ? _self.orderedAt : orderedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [VendorOrder].
extension VendorOrderPatterns on VendorOrder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VendorOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VendorOrder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VendorOrder value)  $default,){
final _that = this;
switch (_that) {
case _VendorOrder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VendorOrder value)?  $default,){
final _that = this;
switch (_that) {
case _VendorOrder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orderNumber,  String vendorId,  String productId,  String productName,  int quantity,  double totalAmount,  OrderStatus status,  String customerName,  DateTime orderedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VendorOrder() when $default != null:
return $default(_that.id,_that.orderNumber,_that.vendorId,_that.productId,_that.productName,_that.quantity,_that.totalAmount,_that.status,_that.customerName,_that.orderedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orderNumber,  String vendorId,  String productId,  String productName,  int quantity,  double totalAmount,  OrderStatus status,  String customerName,  DateTime orderedAt)  $default,) {final _that = this;
switch (_that) {
case _VendorOrder():
return $default(_that.id,_that.orderNumber,_that.vendorId,_that.productId,_that.productName,_that.quantity,_that.totalAmount,_that.status,_that.customerName,_that.orderedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orderNumber,  String vendorId,  String productId,  String productName,  int quantity,  double totalAmount,  OrderStatus status,  String customerName,  DateTime orderedAt)?  $default,) {final _that = this;
switch (_that) {
case _VendorOrder() when $default != null:
return $default(_that.id,_that.orderNumber,_that.vendorId,_that.productId,_that.productName,_that.quantity,_that.totalAmount,_that.status,_that.customerName,_that.orderedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VendorOrder extends VendorOrder {
  const _VendorOrder({required this.id, required this.orderNumber, required this.vendorId, required this.productId, required this.productName, required this.quantity, required this.totalAmount, required this.status, required this.customerName, required this.orderedAt}): super._();
  factory _VendorOrder.fromJson(Map<String, dynamic> json) => _$VendorOrderFromJson(json);

@override final  String id;
@override final  String orderNumber;
@override final  String vendorId;
@override final  String productId;
@override final  String productName;
@override final  int quantity;
@override final  double totalAmount;
@override final  OrderStatus status;
@override final  String customerName;
@override final  DateTime orderedAt;

/// Create a copy of VendorOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VendorOrderCopyWith<_VendorOrder> get copyWith => __$VendorOrderCopyWithImpl<_VendorOrder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VendorOrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VendorOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.status, status) || other.status == status)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.orderedAt, orderedAt) || other.orderedAt == orderedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderNumber,vendorId,productId,productName,quantity,totalAmount,status,customerName,orderedAt);

@override
String toString() {
  return 'VendorOrder(id: $id, orderNumber: $orderNumber, vendorId: $vendorId, productId: $productId, productName: $productName, quantity: $quantity, totalAmount: $totalAmount, status: $status, customerName: $customerName, orderedAt: $orderedAt)';
}


}

/// @nodoc
abstract mixin class _$VendorOrderCopyWith<$Res> implements $VendorOrderCopyWith<$Res> {
  factory _$VendorOrderCopyWith(_VendorOrder value, $Res Function(_VendorOrder) _then) = __$VendorOrderCopyWithImpl;
@override @useResult
$Res call({
 String id, String orderNumber, String vendorId, String productId, String productName, int quantity, double totalAmount, OrderStatus status, String customerName, DateTime orderedAt
});




}
/// @nodoc
class __$VendorOrderCopyWithImpl<$Res>
    implements _$VendorOrderCopyWith<$Res> {
  __$VendorOrderCopyWithImpl(this._self, this._then);

  final _VendorOrder _self;
  final $Res Function(_VendorOrder) _then;

/// Create a copy of VendorOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderNumber = null,Object? vendorId = null,Object? productId = null,Object? productName = null,Object? quantity = null,Object? totalAmount = null,Object? status = null,Object? customerName = null,Object? orderedAt = null,}) {
  return _then(_VendorOrder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,orderedAt: null == orderedAt ? _self.orderedAt : orderedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
