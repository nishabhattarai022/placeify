// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VendorProfile {

 String get id; String get businessName; String get email; String get phone; String get address; String? get logoUrl; String get bio; String? get bannerUrl; List<String> get tags; List<VendorOperatingDay> get schedule; VendorSocialLinks get socialLinks; DateTime get createdAt;
/// Create a copy of VendorProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VendorProfileCopyWith<VendorProfile> get copyWith => _$VendorProfileCopyWithImpl<VendorProfile>(this as VendorProfile, _$identity);

  /// Serializes this VendorProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VendorProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.businessName, businessName) || other.businessName == businessName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.address, address) || other.address == address)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.bannerUrl, bannerUrl) || other.bannerUrl == bannerUrl)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.schedule, schedule)&&(identical(other.socialLinks, socialLinks) || other.socialLinks == socialLinks)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,businessName,email,phone,address,logoUrl,bio,bannerUrl,const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(schedule),socialLinks,createdAt);

@override
String toString() {
  return 'VendorProfile(id: $id, businessName: $businessName, email: $email, phone: $phone, address: $address, logoUrl: $logoUrl, bio: $bio, bannerUrl: $bannerUrl, tags: $tags, schedule: $schedule, socialLinks: $socialLinks, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $VendorProfileCopyWith<$Res>  {
  factory $VendorProfileCopyWith(VendorProfile value, $Res Function(VendorProfile) _then) = _$VendorProfileCopyWithImpl;
@useResult
$Res call({
 String id, String businessName, String email, String phone, String address, String? logoUrl, String bio, String? bannerUrl, List<String> tags, List<VendorOperatingDay> schedule, VendorSocialLinks socialLinks, DateTime createdAt
});


$VendorSocialLinksCopyWith<$Res> get socialLinks;

}
/// @nodoc
class _$VendorProfileCopyWithImpl<$Res>
    implements $VendorProfileCopyWith<$Res> {
  _$VendorProfileCopyWithImpl(this._self, this._then);

  final VendorProfile _self;
  final $Res Function(VendorProfile) _then;

/// Create a copy of VendorProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessName = null,Object? email = null,Object? phone = null,Object? address = null,Object? logoUrl = freezed,Object? bio = null,Object? bannerUrl = freezed,Object? tags = null,Object? schedule = null,Object? socialLinks = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessName: null == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,bannerUrl: freezed == bannerUrl ? _self.bannerUrl : bannerUrl // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as List<VendorOperatingDay>,socialLinks: null == socialLinks ? _self.socialLinks : socialLinks // ignore: cast_nullable_to_non_nullable
as VendorSocialLinks,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of VendorProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VendorSocialLinksCopyWith<$Res> get socialLinks {
  
  return $VendorSocialLinksCopyWith<$Res>(_self.socialLinks, (value) {
    return _then(_self.copyWith(socialLinks: value));
  });
}
}


/// Adds pattern-matching-related methods to [VendorProfile].
extension VendorProfilePatterns on VendorProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VendorProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VendorProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VendorProfile value)  $default,){
final _that = this;
switch (_that) {
case _VendorProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VendorProfile value)?  $default,){
final _that = this;
switch (_that) {
case _VendorProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String businessName,  String email,  String phone,  String address,  String? logoUrl,  String bio,  String? bannerUrl,  List<String> tags,  List<VendorOperatingDay> schedule,  VendorSocialLinks socialLinks,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VendorProfile() when $default != null:
return $default(_that.id,_that.businessName,_that.email,_that.phone,_that.address,_that.logoUrl,_that.bio,_that.bannerUrl,_that.tags,_that.schedule,_that.socialLinks,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String businessName,  String email,  String phone,  String address,  String? logoUrl,  String bio,  String? bannerUrl,  List<String> tags,  List<VendorOperatingDay> schedule,  VendorSocialLinks socialLinks,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _VendorProfile():
return $default(_that.id,_that.businessName,_that.email,_that.phone,_that.address,_that.logoUrl,_that.bio,_that.bannerUrl,_that.tags,_that.schedule,_that.socialLinks,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String businessName,  String email,  String phone,  String address,  String? logoUrl,  String bio,  String? bannerUrl,  List<String> tags,  List<VendorOperatingDay> schedule,  VendorSocialLinks socialLinks,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _VendorProfile() when $default != null:
return $default(_that.id,_that.businessName,_that.email,_that.phone,_that.address,_that.logoUrl,_that.bio,_that.bannerUrl,_that.tags,_that.schedule,_that.socialLinks,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VendorProfile implements VendorProfile {
  const _VendorProfile({required this.id, required this.businessName, required this.email, required this.phone, required this.address, this.logoUrl, this.bio = '', this.bannerUrl, final  List<String> tags = const [], final  List<VendorOperatingDay> schedule = const [], this.socialLinks = const VendorSocialLinks(), required this.createdAt}): _tags = tags,_schedule = schedule;
  factory _VendorProfile.fromJson(Map<String, dynamic> json) => _$VendorProfileFromJson(json);

@override final  String id;
@override final  String businessName;
@override final  String email;
@override final  String phone;
@override final  String address;
@override final  String? logoUrl;
@override@JsonKey() final  String bio;
@override final  String? bannerUrl;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

 final  List<VendorOperatingDay> _schedule;
@override@JsonKey() List<VendorOperatingDay> get schedule {
  if (_schedule is EqualUnmodifiableListView) return _schedule;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_schedule);
}

@override@JsonKey() final  VendorSocialLinks socialLinks;
@override final  DateTime createdAt;

/// Create a copy of VendorProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VendorProfileCopyWith<_VendorProfile> get copyWith => __$VendorProfileCopyWithImpl<_VendorProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VendorProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VendorProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.businessName, businessName) || other.businessName == businessName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.address, address) || other.address == address)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.bannerUrl, bannerUrl) || other.bannerUrl == bannerUrl)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._schedule, _schedule)&&(identical(other.socialLinks, socialLinks) || other.socialLinks == socialLinks)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,businessName,email,phone,address,logoUrl,bio,bannerUrl,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_schedule),socialLinks,createdAt);

@override
String toString() {
  return 'VendorProfile(id: $id, businessName: $businessName, email: $email, phone: $phone, address: $address, logoUrl: $logoUrl, bio: $bio, bannerUrl: $bannerUrl, tags: $tags, schedule: $schedule, socialLinks: $socialLinks, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$VendorProfileCopyWith<$Res> implements $VendorProfileCopyWith<$Res> {
  factory _$VendorProfileCopyWith(_VendorProfile value, $Res Function(_VendorProfile) _then) = __$VendorProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String businessName, String email, String phone, String address, String? logoUrl, String bio, String? bannerUrl, List<String> tags, List<VendorOperatingDay> schedule, VendorSocialLinks socialLinks, DateTime createdAt
});


@override $VendorSocialLinksCopyWith<$Res> get socialLinks;

}
/// @nodoc
class __$VendorProfileCopyWithImpl<$Res>
    implements _$VendorProfileCopyWith<$Res> {
  __$VendorProfileCopyWithImpl(this._self, this._then);

  final _VendorProfile _self;
  final $Res Function(_VendorProfile) _then;

/// Create a copy of VendorProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessName = null,Object? email = null,Object? phone = null,Object? address = null,Object? logoUrl = freezed,Object? bio = null,Object? bannerUrl = freezed,Object? tags = null,Object? schedule = null,Object? socialLinks = null,Object? createdAt = null,}) {
  return _then(_VendorProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessName: null == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,bannerUrl: freezed == bannerUrl ? _self.bannerUrl : bannerUrl // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,schedule: null == schedule ? _self._schedule : schedule // ignore: cast_nullable_to_non_nullable
as List<VendorOperatingDay>,socialLinks: null == socialLinks ? _self.socialLinks : socialLinks // ignore: cast_nullable_to_non_nullable
as VendorSocialLinks,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of VendorProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VendorSocialLinksCopyWith<$Res> get socialLinks {
  
  return $VendorSocialLinksCopyWith<$Res>(_self.socialLinks, (value) {
    return _then(_self.copyWith(socialLinks: value));
  });
}
}

// dart format on
