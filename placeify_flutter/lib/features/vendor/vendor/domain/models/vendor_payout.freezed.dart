// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor_payout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VendorPayout {

 String get id; double get amount; PaymentStatus get status; DateTime? get paidAt; String get reference;
/// Create a copy of VendorPayout
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VendorPayoutCopyWith<VendorPayout> get copyWith => _$VendorPayoutCopyWithImpl<VendorPayout>(this as VendorPayout, _$identity);

  /// Serializes this VendorPayout to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VendorPayout&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.status, status) || other.status == status)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.reference, reference) || other.reference == reference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,amount,status,paidAt,reference);

@override
String toString() {
  return 'VendorPayout(id: $id, amount: $amount, status: $status, paidAt: $paidAt, reference: $reference)';
}


}

/// @nodoc
abstract mixin class $VendorPayoutCopyWith<$Res>  {
  factory $VendorPayoutCopyWith(VendorPayout value, $Res Function(VendorPayout) _then) = _$VendorPayoutCopyWithImpl;
@useResult
$Res call({
 String id, double amount, PaymentStatus status, DateTime? paidAt, String reference
});




}
/// @nodoc
class _$VendorPayoutCopyWithImpl<$Res>
    implements $VendorPayoutCopyWith<$Res> {
  _$VendorPayoutCopyWithImpl(this._self, this._then);

  final VendorPayout _self;
  final $Res Function(VendorPayout) _then;

/// Create a copy of VendorPayout
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? amount = null,Object? status = null,Object? paidAt = freezed,Object? reference = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reference: null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VendorPayout].
extension VendorPayoutPatterns on VendorPayout {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VendorPayout value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VendorPayout() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VendorPayout value)  $default,){
final _that = this;
switch (_that) {
case _VendorPayout():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VendorPayout value)?  $default,){
final _that = this;
switch (_that) {
case _VendorPayout() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  double amount,  PaymentStatus status,  DateTime? paidAt,  String reference)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VendorPayout() when $default != null:
return $default(_that.id,_that.amount,_that.status,_that.paidAt,_that.reference);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  double amount,  PaymentStatus status,  DateTime? paidAt,  String reference)  $default,) {final _that = this;
switch (_that) {
case _VendorPayout():
return $default(_that.id,_that.amount,_that.status,_that.paidAt,_that.reference);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  double amount,  PaymentStatus status,  DateTime? paidAt,  String reference)?  $default,) {final _that = this;
switch (_that) {
case _VendorPayout() when $default != null:
return $default(_that.id,_that.amount,_that.status,_that.paidAt,_that.reference);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VendorPayout extends VendorPayout {
  const _VendorPayout({required this.id, required this.amount, required this.status, this.paidAt, required this.reference}): super._();
  factory _VendorPayout.fromJson(Map<String, dynamic> json) => _$VendorPayoutFromJson(json);

@override final  String id;
@override final  double amount;
@override final  PaymentStatus status;
@override final  DateTime? paidAt;
@override final  String reference;

/// Create a copy of VendorPayout
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VendorPayoutCopyWith<_VendorPayout> get copyWith => __$VendorPayoutCopyWithImpl<_VendorPayout>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VendorPayoutToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VendorPayout&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.status, status) || other.status == status)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.reference, reference) || other.reference == reference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,amount,status,paidAt,reference);

@override
String toString() {
  return 'VendorPayout(id: $id, amount: $amount, status: $status, paidAt: $paidAt, reference: $reference)';
}


}

/// @nodoc
abstract mixin class _$VendorPayoutCopyWith<$Res> implements $VendorPayoutCopyWith<$Res> {
  factory _$VendorPayoutCopyWith(_VendorPayout value, $Res Function(_VendorPayout) _then) = __$VendorPayoutCopyWithImpl;
@override @useResult
$Res call({
 String id, double amount, PaymentStatus status, DateTime? paidAt, String reference
});




}
/// @nodoc
class __$VendorPayoutCopyWithImpl<$Res>
    implements _$VendorPayoutCopyWith<$Res> {
  __$VendorPayoutCopyWithImpl(this._self, this._then);

  final _VendorPayout _self;
  final $Res Function(_VendorPayout) _then;

/// Create a copy of VendorPayout
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? amount = null,Object? status = null,Object? paidAt = freezed,Object? reference = null,}) {
  return _then(_VendorPayout(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reference: null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
