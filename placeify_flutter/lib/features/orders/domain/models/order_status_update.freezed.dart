// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_status_update.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderStatusUpdate {

 ConsumerOrderStatus get status; DateTime get timestamp; String? get note;
/// Create a copy of OrderStatusUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderStatusUpdateCopyWith<OrderStatusUpdate> get copyWith => _$OrderStatusUpdateCopyWithImpl<OrderStatusUpdate>(this as OrderStatusUpdate, _$identity);

  /// Serializes this OrderStatusUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderStatusUpdate&&(identical(other.status, status) || other.status == status)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,timestamp,note);

@override
String toString() {
  return 'OrderStatusUpdate(status: $status, timestamp: $timestamp, note: $note)';
}


}

/// @nodoc
abstract mixin class $OrderStatusUpdateCopyWith<$Res>  {
  factory $OrderStatusUpdateCopyWith(OrderStatusUpdate value, $Res Function(OrderStatusUpdate) _then) = _$OrderStatusUpdateCopyWithImpl;
@useResult
$Res call({
 ConsumerOrderStatus status, DateTime timestamp, String? note
});




}
/// @nodoc
class _$OrderStatusUpdateCopyWithImpl<$Res>
    implements $OrderStatusUpdateCopyWith<$Res> {
  _$OrderStatusUpdateCopyWithImpl(this._self, this._then);

  final OrderStatusUpdate _self;
  final $Res Function(OrderStatusUpdate) _then;

/// Create a copy of OrderStatusUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? timestamp = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ConsumerOrderStatus,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderStatusUpdate].
extension OrderStatusUpdatePatterns on OrderStatusUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderStatusUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderStatusUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderStatusUpdate value)  $default,){
final _that = this;
switch (_that) {
case _OrderStatusUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderStatusUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _OrderStatusUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ConsumerOrderStatus status,  DateTime timestamp,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderStatusUpdate() when $default != null:
return $default(_that.status,_that.timestamp,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ConsumerOrderStatus status,  DateTime timestamp,  String? note)  $default,) {final _that = this;
switch (_that) {
case _OrderStatusUpdate():
return $default(_that.status,_that.timestamp,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ConsumerOrderStatus status,  DateTime timestamp,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _OrderStatusUpdate() when $default != null:
return $default(_that.status,_that.timestamp,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderStatusUpdate implements OrderStatusUpdate {
  const _OrderStatusUpdate({required this.status, required this.timestamp, this.note});
  factory _OrderStatusUpdate.fromJson(Map<String, dynamic> json) => _$OrderStatusUpdateFromJson(json);

@override final  ConsumerOrderStatus status;
@override final  DateTime timestamp;
@override final  String? note;

/// Create a copy of OrderStatusUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderStatusUpdateCopyWith<_OrderStatusUpdate> get copyWith => __$OrderStatusUpdateCopyWithImpl<_OrderStatusUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderStatusUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderStatusUpdate&&(identical(other.status, status) || other.status == status)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,timestamp,note);

@override
String toString() {
  return 'OrderStatusUpdate(status: $status, timestamp: $timestamp, note: $note)';
}


}

/// @nodoc
abstract mixin class _$OrderStatusUpdateCopyWith<$Res> implements $OrderStatusUpdateCopyWith<$Res> {
  factory _$OrderStatusUpdateCopyWith(_OrderStatusUpdate value, $Res Function(_OrderStatusUpdate) _then) = __$OrderStatusUpdateCopyWithImpl;
@override @useResult
$Res call({
 ConsumerOrderStatus status, DateTime timestamp, String? note
});




}
/// @nodoc
class __$OrderStatusUpdateCopyWithImpl<$Res>
    implements _$OrderStatusUpdateCopyWith<$Res> {
  __$OrderStatusUpdateCopyWithImpl(this._self, this._then);

  final _OrderStatusUpdate _self;
  final $Res Function(_OrderStatusUpdate) _then;

/// Create a copy of OrderStatusUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? timestamp = null,Object? note = freezed,}) {
  return _then(_OrderStatusUpdate(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ConsumerOrderStatus,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
