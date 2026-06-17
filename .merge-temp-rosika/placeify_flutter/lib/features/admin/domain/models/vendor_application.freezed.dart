// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor_application.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VendorApplication {

 String get vendorId; String get userId; String get businessName; String get contactEmail; DateTime get submittedAt; VendorRegistration get registration; VendorStatus get status;
/// Create a copy of VendorApplication
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VendorApplicationCopyWith<VendorApplication> get copyWith => _$VendorApplicationCopyWithImpl<VendorApplication>(this as VendorApplication, _$identity);

  /// Serializes this VendorApplication to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VendorApplication&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.businessName, businessName) || other.businessName == businessName)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.registration, registration) || other.registration == registration)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,vendorId,userId,businessName,contactEmail,submittedAt,registration,status);

@override
String toString() {
  return 'VendorApplication(vendorId: $vendorId, userId: $userId, businessName: $businessName, contactEmail: $contactEmail, submittedAt: $submittedAt, registration: $registration, status: $status)';
}


}

/// @nodoc
abstract mixin class $VendorApplicationCopyWith<$Res>  {
  factory $VendorApplicationCopyWith(VendorApplication value, $Res Function(VendorApplication) _then) = _$VendorApplicationCopyWithImpl;
@useResult
$Res call({
 String vendorId, String userId, String businessName, String contactEmail, DateTime submittedAt, VendorRegistration registration, VendorStatus status
});


$VendorRegistrationCopyWith<$Res> get registration;

}
/// @nodoc
class _$VendorApplicationCopyWithImpl<$Res>
    implements $VendorApplicationCopyWith<$Res> {
  _$VendorApplicationCopyWithImpl(this._self, this._then);

  final VendorApplication _self;
  final $Res Function(VendorApplication) _then;

/// Create a copy of VendorApplication
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? vendorId = null,Object? userId = null,Object? businessName = null,Object? contactEmail = null,Object? submittedAt = null,Object? registration = null,Object? status = null,}) {
  return _then(_self.copyWith(
vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,businessName: null == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String,contactEmail: null == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String,submittedAt: null == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime,registration: null == registration ? _self.registration : registration // ignore: cast_nullable_to_non_nullable
as VendorRegistration,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VendorStatus,
  ));
}
/// Create a copy of VendorApplication
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VendorRegistrationCopyWith<$Res> get registration {
  
  return $VendorRegistrationCopyWith<$Res>(_self.registration, (value) {
    return _then(_self.copyWith(registration: value));
  });
}
}


/// Adds pattern-matching-related methods to [VendorApplication].
extension VendorApplicationPatterns on VendorApplication {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VendorApplication value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VendorApplication() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VendorApplication value)  $default,){
final _that = this;
switch (_that) {
case _VendorApplication():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VendorApplication value)?  $default,){
final _that = this;
switch (_that) {
case _VendorApplication() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String vendorId,  String userId,  String businessName,  String contactEmail,  DateTime submittedAt,  VendorRegistration registration,  VendorStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VendorApplication() when $default != null:
return $default(_that.vendorId,_that.userId,_that.businessName,_that.contactEmail,_that.submittedAt,_that.registration,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String vendorId,  String userId,  String businessName,  String contactEmail,  DateTime submittedAt,  VendorRegistration registration,  VendorStatus status)  $default,) {final _that = this;
switch (_that) {
case _VendorApplication():
return $default(_that.vendorId,_that.userId,_that.businessName,_that.contactEmail,_that.submittedAt,_that.registration,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String vendorId,  String userId,  String businessName,  String contactEmail,  DateTime submittedAt,  VendorRegistration registration,  VendorStatus status)?  $default,) {final _that = this;
switch (_that) {
case _VendorApplication() when $default != null:
return $default(_that.vendorId,_that.userId,_that.businessName,_that.contactEmail,_that.submittedAt,_that.registration,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VendorApplication implements VendorApplication {
  const _VendorApplication({required this.vendorId, required this.userId, required this.businessName, required this.contactEmail, required this.submittedAt, required this.registration, required this.status});
  factory _VendorApplication.fromJson(Map<String, dynamic> json) => _$VendorApplicationFromJson(json);

@override final  String vendorId;
@override final  String userId;
@override final  String businessName;
@override final  String contactEmail;
@override final  DateTime submittedAt;
@override final  VendorRegistration registration;
@override final  VendorStatus status;

/// Create a copy of VendorApplication
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VendorApplicationCopyWith<_VendorApplication> get copyWith => __$VendorApplicationCopyWithImpl<_VendorApplication>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VendorApplicationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VendorApplication&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.businessName, businessName) || other.businessName == businessName)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.registration, registration) || other.registration == registration)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,vendorId,userId,businessName,contactEmail,submittedAt,registration,status);

@override
String toString() {
  return 'VendorApplication(vendorId: $vendorId, userId: $userId, businessName: $businessName, contactEmail: $contactEmail, submittedAt: $submittedAt, registration: $registration, status: $status)';
}


}

/// @nodoc
abstract mixin class _$VendorApplicationCopyWith<$Res> implements $VendorApplicationCopyWith<$Res> {
  factory _$VendorApplicationCopyWith(_VendorApplication value, $Res Function(_VendorApplication) _then) = __$VendorApplicationCopyWithImpl;
@override @useResult
$Res call({
 String vendorId, String userId, String businessName, String contactEmail, DateTime submittedAt, VendorRegistration registration, VendorStatus status
});


@override $VendorRegistrationCopyWith<$Res> get registration;

}
/// @nodoc
class __$VendorApplicationCopyWithImpl<$Res>
    implements _$VendorApplicationCopyWith<$Res> {
  __$VendorApplicationCopyWithImpl(this._self, this._then);

  final _VendorApplication _self;
  final $Res Function(_VendorApplication) _then;

/// Create a copy of VendorApplication
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? vendorId = null,Object? userId = null,Object? businessName = null,Object? contactEmail = null,Object? submittedAt = null,Object? registration = null,Object? status = null,}) {
  return _then(_VendorApplication(
vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,businessName: null == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String,contactEmail: null == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String,submittedAt: null == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime,registration: null == registration ? _self.registration : registration // ignore: cast_nullable_to_non_nullable
as VendorRegistration,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VendorStatus,
  ));
}

/// Create a copy of VendorApplication
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VendorRegistrationCopyWith<$Res> get registration {
  
  return $VendorRegistrationCopyWith<$Res>(_self.registration, (value) {
    return _then(_self.copyWith(registration: value));
  });
}
}

// dart format on
