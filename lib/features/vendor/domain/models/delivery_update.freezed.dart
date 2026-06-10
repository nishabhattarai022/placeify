// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery_update.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeliveryUpdate {

 String get id; String get orderId; DeliveryStage get stage; String get note; DateTime get updatedAt;
/// Create a copy of DeliveryUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeliveryUpdateCopyWith<DeliveryUpdate> get copyWith => _$DeliveryUpdateCopyWithImpl<DeliveryUpdate>(this as DeliveryUpdate, _$identity);

  /// Serializes this DeliveryUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeliveryUpdate&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.note, note) || other.note == note)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,stage,note,updatedAt);

@override
String toString() {
  return 'DeliveryUpdate(id: $id, orderId: $orderId, stage: $stage, note: $note, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DeliveryUpdateCopyWith<$Res>  {
  factory $DeliveryUpdateCopyWith(DeliveryUpdate value, $Res Function(DeliveryUpdate) _then) = _$DeliveryUpdateCopyWithImpl;
@useResult
$Res call({
 String id, String orderId, DeliveryStage stage, String note, DateTime updatedAt
});




}
/// @nodoc
class _$DeliveryUpdateCopyWithImpl<$Res>
    implements $DeliveryUpdateCopyWith<$Res> {
  _$DeliveryUpdateCopyWithImpl(this._self, this._then);

  final DeliveryUpdate _self;
  final $Res Function(DeliveryUpdate) _then;

/// Create a copy of DeliveryUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderId = null,Object? stage = null,Object? note = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as DeliveryStage,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DeliveryUpdate].
extension DeliveryUpdatePatterns on DeliveryUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeliveryUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeliveryUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeliveryUpdate value)  $default,){
final _that = this;
switch (_that) {
case _DeliveryUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeliveryUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _DeliveryUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orderId,  DeliveryStage stage,  String note,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeliveryUpdate() when $default != null:
return $default(_that.id,_that.orderId,_that.stage,_that.note,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orderId,  DeliveryStage stage,  String note,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DeliveryUpdate():
return $default(_that.id,_that.orderId,_that.stage,_that.note,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orderId,  DeliveryStage stage,  String note,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DeliveryUpdate() when $default != null:
return $default(_that.id,_that.orderId,_that.stage,_that.note,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeliveryUpdate implements DeliveryUpdate {
  const _DeliveryUpdate({required this.id, required this.orderId, required this.stage, required this.note, required this.updatedAt});
  factory _DeliveryUpdate.fromJson(Map<String, dynamic> json) => _$DeliveryUpdateFromJson(json);

@override final  String id;
@override final  String orderId;
@override final  DeliveryStage stage;
@override final  String note;
@override final  DateTime updatedAt;

/// Create a copy of DeliveryUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeliveryUpdateCopyWith<_DeliveryUpdate> get copyWith => __$DeliveryUpdateCopyWithImpl<_DeliveryUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeliveryUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeliveryUpdate&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.note, note) || other.note == note)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,stage,note,updatedAt);

@override
String toString() {
  return 'DeliveryUpdate(id: $id, orderId: $orderId, stage: $stage, note: $note, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DeliveryUpdateCopyWith<$Res> implements $DeliveryUpdateCopyWith<$Res> {
  factory _$DeliveryUpdateCopyWith(_DeliveryUpdate value, $Res Function(_DeliveryUpdate) _then) = __$DeliveryUpdateCopyWithImpl;
@override @useResult
$Res call({
 String id, String orderId, DeliveryStage stage, String note, DateTime updatedAt
});




}
/// @nodoc
class __$DeliveryUpdateCopyWithImpl<$Res>
    implements _$DeliveryUpdateCopyWith<$Res> {
  __$DeliveryUpdateCopyWithImpl(this._self, this._then);

  final _DeliveryUpdate _self;
  final $Res Function(_DeliveryUpdate) _then;

/// Create a copy of DeliveryUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderId = null,Object? stage = null,Object? note = null,Object? updatedAt = null,}) {
  return _then(_DeliveryUpdate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as DeliveryStage,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
