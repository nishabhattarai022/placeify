// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_update.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaymentUpdate {

 String get id; String get orderId; double get amount; PaymentStatus get status; String get note; DateTime get updatedAt; String? get paymentMethodLabel; String? get customerName;
/// Create a copy of PaymentUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentUpdateCopyWith<PaymentUpdate> get copyWith => _$PaymentUpdateCopyWithImpl<PaymentUpdate>(this as PaymentUpdate, _$identity);

  /// Serializes this PaymentUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentUpdate&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.paymentMethodLabel, paymentMethodLabel) || other.paymentMethodLabel == paymentMethodLabel)&&(identical(other.customerName, customerName) || other.customerName == customerName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,amount,status,note,updatedAt,paymentMethodLabel,customerName);

@override
String toString() {
  return 'PaymentUpdate(id: $id, orderId: $orderId, amount: $amount, status: $status, note: $note, updatedAt: $updatedAt, paymentMethodLabel: $paymentMethodLabel, customerName: $customerName)';
}


}

/// @nodoc
abstract mixin class $PaymentUpdateCopyWith<$Res>  {
  factory $PaymentUpdateCopyWith(PaymentUpdate value, $Res Function(PaymentUpdate) _then) = _$PaymentUpdateCopyWithImpl;
@useResult
$Res call({
 String id, String orderId, double amount, PaymentStatus status, String note, DateTime updatedAt, String? paymentMethodLabel, String? customerName
});




}
/// @nodoc
class _$PaymentUpdateCopyWithImpl<$Res>
    implements $PaymentUpdateCopyWith<$Res> {
  _$PaymentUpdateCopyWithImpl(this._self, this._then);

  final PaymentUpdate _self;
  final $Res Function(PaymentUpdate) _then;

/// Create a copy of PaymentUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderId = null,Object? amount = null,Object? status = null,Object? note = null,Object? updatedAt = null,Object? paymentMethodLabel = freezed,Object? customerName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,paymentMethodLabel: freezed == paymentMethodLabel ? _self.paymentMethodLabel : paymentMethodLabel // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentUpdate].
extension PaymentUpdatePatterns on PaymentUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentUpdate value)  $default,){
final _that = this;
switch (_that) {
case _PaymentUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orderId,  double amount,  PaymentStatus status,  String note,  DateTime updatedAt,  String? paymentMethodLabel,  String? customerName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentUpdate() when $default != null:
return $default(_that.id,_that.orderId,_that.amount,_that.status,_that.note,_that.updatedAt,_that.paymentMethodLabel,_that.customerName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orderId,  double amount,  PaymentStatus status,  String note,  DateTime updatedAt,  String? paymentMethodLabel,  String? customerName)  $default,) {final _that = this;
switch (_that) {
case _PaymentUpdate():
return $default(_that.id,_that.orderId,_that.amount,_that.status,_that.note,_that.updatedAt,_that.paymentMethodLabel,_that.customerName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orderId,  double amount,  PaymentStatus status,  String note,  DateTime updatedAt,  String? paymentMethodLabel,  String? customerName)?  $default,) {final _that = this;
switch (_that) {
case _PaymentUpdate() when $default != null:
return $default(_that.id,_that.orderId,_that.amount,_that.status,_that.note,_that.updatedAt,_that.paymentMethodLabel,_that.customerName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentUpdate implements PaymentUpdate {
  const _PaymentUpdate({required this.id, required this.orderId, required this.amount, required this.status, required this.note, required this.updatedAt, this.paymentMethodLabel, this.customerName});
  factory _PaymentUpdate.fromJson(Map<String, dynamic> json) => _$PaymentUpdateFromJson(json);

@override final  String id;
@override final  String orderId;
@override final  double amount;
@override final  PaymentStatus status;
@override final  String note;
@override final  DateTime updatedAt;
@override final  String? paymentMethodLabel;
@override final  String? customerName;

/// Create a copy of PaymentUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentUpdateCopyWith<_PaymentUpdate> get copyWith => __$PaymentUpdateCopyWithImpl<_PaymentUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentUpdate&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.paymentMethodLabel, paymentMethodLabel) || other.paymentMethodLabel == paymentMethodLabel)&&(identical(other.customerName, customerName) || other.customerName == customerName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,amount,status,note,updatedAt,paymentMethodLabel,customerName);

@override
String toString() {
  return 'PaymentUpdate(id: $id, orderId: $orderId, amount: $amount, status: $status, note: $note, updatedAt: $updatedAt, paymentMethodLabel: $paymentMethodLabel, customerName: $customerName)';
}


}

/// @nodoc
abstract mixin class _$PaymentUpdateCopyWith<$Res> implements $PaymentUpdateCopyWith<$Res> {
  factory _$PaymentUpdateCopyWith(_PaymentUpdate value, $Res Function(_PaymentUpdate) _then) = __$PaymentUpdateCopyWithImpl;
@override @useResult
$Res call({
 String id, String orderId, double amount, PaymentStatus status, String note, DateTime updatedAt, String? paymentMethodLabel, String? customerName
});




}
/// @nodoc
class __$PaymentUpdateCopyWithImpl<$Res>
    implements _$PaymentUpdateCopyWith<$Res> {
  __$PaymentUpdateCopyWithImpl(this._self, this._then);

  final _PaymentUpdate _self;
  final $Res Function(_PaymentUpdate) _then;

/// Create a copy of PaymentUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderId = null,Object? amount = null,Object? status = null,Object? note = null,Object? updatedAt = null,Object? paymentMethodLabel = freezed,Object? customerName = freezed,}) {
  return _then(_PaymentUpdate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,paymentMethodLabel: freezed == paymentMethodLabel ? _self.paymentMethodLabel : paymentMethodLabel // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
