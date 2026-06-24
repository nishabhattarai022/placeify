// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'platform_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlatformUser {

 String get id; String get name; String get email; UserRole get role; VendorStatus get vendorStatus; String? get vendorId; DateTime get createdAt;
/// Create a copy of PlatformUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlatformUserCopyWith<PlatformUser> get copyWith => _$PlatformUserCopyWithImpl<PlatformUser>(this as PlatformUser, _$identity);

  /// Serializes this PlatformUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlatformUser&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.vendorStatus, vendorStatus) || other.vendorStatus == vendorStatus)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,role,vendorStatus,vendorId,createdAt);

@override
String toString() {
  return 'PlatformUser(id: $id, name: $name, email: $email, role: $role, vendorStatus: $vendorStatus, vendorId: $vendorId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PlatformUserCopyWith<$Res>  {
  factory $PlatformUserCopyWith(PlatformUser value, $Res Function(PlatformUser) _then) = _$PlatformUserCopyWithImpl;
@useResult
$Res call({
 String id, String name, String email, UserRole role, VendorStatus vendorStatus, String? vendorId, DateTime createdAt
});




}
/// @nodoc
class _$PlatformUserCopyWithImpl<$Res>
    implements $PlatformUserCopyWith<$Res> {
  _$PlatformUserCopyWithImpl(this._self, this._then);

  final PlatformUser _self;
  final $Res Function(PlatformUser) _then;

/// Create a copy of PlatformUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = null,Object? role = null,Object? vendorStatus = null,Object? vendorId = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,vendorStatus: null == vendorStatus ? _self.vendorStatus : vendorStatus // ignore: cast_nullable_to_non_nullable
as VendorStatus,vendorId: freezed == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PlatformUser].
extension PlatformUserPatterns on PlatformUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlatformUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlatformUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlatformUser value)  $default,){
final _that = this;
switch (_that) {
case _PlatformUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlatformUser value)?  $default,){
final _that = this;
switch (_that) {
case _PlatformUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String email,  UserRole role,  VendorStatus vendorStatus,  String? vendorId,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlatformUser() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.role,_that.vendorStatus,_that.vendorId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String email,  UserRole role,  VendorStatus vendorStatus,  String? vendorId,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _PlatformUser():
return $default(_that.id,_that.name,_that.email,_that.role,_that.vendorStatus,_that.vendorId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String email,  UserRole role,  VendorStatus vendorStatus,  String? vendorId,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PlatformUser() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.role,_that.vendorStatus,_that.vendorId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlatformUser implements PlatformUser {
  const _PlatformUser({required this.id, required this.name, required this.email, required this.role, required this.vendorStatus, this.vendorId, required this.createdAt});
  factory _PlatformUser.fromJson(Map<String, dynamic> json) => _$PlatformUserFromJson(json);

@override final  String id;
@override final  String name;
@override final  String email;
@override final  UserRole role;
@override final  VendorStatus vendorStatus;
@override final  String? vendorId;
@override final  DateTime createdAt;

/// Create a copy of PlatformUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlatformUserCopyWith<_PlatformUser> get copyWith => __$PlatformUserCopyWithImpl<_PlatformUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlatformUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlatformUser&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.vendorStatus, vendorStatus) || other.vendorStatus == vendorStatus)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,role,vendorStatus,vendorId,createdAt);

@override
String toString() {
  return 'PlatformUser(id: $id, name: $name, email: $email, role: $role, vendorStatus: $vendorStatus, vendorId: $vendorId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PlatformUserCopyWith<$Res> implements $PlatformUserCopyWith<$Res> {
  factory _$PlatformUserCopyWith(_PlatformUser value, $Res Function(_PlatformUser) _then) = __$PlatformUserCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String email, UserRole role, VendorStatus vendorStatus, String? vendorId, DateTime createdAt
});




}
/// @nodoc
class __$PlatformUserCopyWithImpl<$Res>
    implements _$PlatformUserCopyWith<$Res> {
  __$PlatformUserCopyWithImpl(this._self, this._then);

  final _PlatformUser _self;
  final $Res Function(_PlatformUser) _then;

/// Create a copy of PlatformUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = null,Object? role = null,Object? vendorStatus = null,Object? vendorId = freezed,Object? createdAt = null,}) {
  return _then(_PlatformUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,vendorStatus: null == vendorStatus ? _self.vendorStatus : vendorStatus // ignore: cast_nullable_to_non_nullable
as VendorStatus,vendorId: freezed == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
