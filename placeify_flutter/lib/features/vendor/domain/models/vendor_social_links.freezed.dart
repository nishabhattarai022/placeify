// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor_social_links.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VendorSocialLinks {

 String get facebook; String get instagram; String get website;
/// Create a copy of VendorSocialLinks
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VendorSocialLinksCopyWith<VendorSocialLinks> get copyWith => _$VendorSocialLinksCopyWithImpl<VendorSocialLinks>(this as VendorSocialLinks, _$identity);

  /// Serializes this VendorSocialLinks to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VendorSocialLinks&&(identical(other.facebook, facebook) || other.facebook == facebook)&&(identical(other.instagram, instagram) || other.instagram == instagram)&&(identical(other.website, website) || other.website == website));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,facebook,instagram,website);

@override
String toString() {
  return 'VendorSocialLinks(facebook: $facebook, instagram: $instagram, website: $website)';
}


}

/// @nodoc
abstract mixin class $VendorSocialLinksCopyWith<$Res>  {
  factory $VendorSocialLinksCopyWith(VendorSocialLinks value, $Res Function(VendorSocialLinks) _then) = _$VendorSocialLinksCopyWithImpl;
@useResult
$Res call({
 String facebook, String instagram, String website
});




}
/// @nodoc
class _$VendorSocialLinksCopyWithImpl<$Res>
    implements $VendorSocialLinksCopyWith<$Res> {
  _$VendorSocialLinksCopyWithImpl(this._self, this._then);

  final VendorSocialLinks _self;
  final $Res Function(VendorSocialLinks) _then;

/// Create a copy of VendorSocialLinks
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? facebook = null,Object? instagram = null,Object? website = null,}) {
  return _then(_self.copyWith(
facebook: null == facebook ? _self.facebook : facebook // ignore: cast_nullable_to_non_nullable
as String,instagram: null == instagram ? _self.instagram : instagram // ignore: cast_nullable_to_non_nullable
as String,website: null == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VendorSocialLinks].
extension VendorSocialLinksPatterns on VendorSocialLinks {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VendorSocialLinks value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VendorSocialLinks() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VendorSocialLinks value)  $default,){
final _that = this;
switch (_that) {
case _VendorSocialLinks():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VendorSocialLinks value)?  $default,){
final _that = this;
switch (_that) {
case _VendorSocialLinks() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String facebook,  String instagram,  String website)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VendorSocialLinks() when $default != null:
return $default(_that.facebook,_that.instagram,_that.website);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String facebook,  String instagram,  String website)  $default,) {final _that = this;
switch (_that) {
case _VendorSocialLinks():
return $default(_that.facebook,_that.instagram,_that.website);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String facebook,  String instagram,  String website)?  $default,) {final _that = this;
switch (_that) {
case _VendorSocialLinks() when $default != null:
return $default(_that.facebook,_that.instagram,_that.website);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VendorSocialLinks implements VendorSocialLinks {
  const _VendorSocialLinks({this.facebook = '', this.instagram = '', this.website = ''});
  factory _VendorSocialLinks.fromJson(Map<String, dynamic> json) => _$VendorSocialLinksFromJson(json);

@override@JsonKey() final  String facebook;
@override@JsonKey() final  String instagram;
@override@JsonKey() final  String website;

/// Create a copy of VendorSocialLinks
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VendorSocialLinksCopyWith<_VendorSocialLinks> get copyWith => __$VendorSocialLinksCopyWithImpl<_VendorSocialLinks>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VendorSocialLinksToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VendorSocialLinks&&(identical(other.facebook, facebook) || other.facebook == facebook)&&(identical(other.instagram, instagram) || other.instagram == instagram)&&(identical(other.website, website) || other.website == website));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,facebook,instagram,website);

@override
String toString() {
  return 'VendorSocialLinks(facebook: $facebook, instagram: $instagram, website: $website)';
}


}

/// @nodoc
abstract mixin class _$VendorSocialLinksCopyWith<$Res> implements $VendorSocialLinksCopyWith<$Res> {
  factory _$VendorSocialLinksCopyWith(_VendorSocialLinks value, $Res Function(_VendorSocialLinks) _then) = __$VendorSocialLinksCopyWithImpl;
@override @useResult
$Res call({
 String facebook, String instagram, String website
});




}
/// @nodoc
class __$VendorSocialLinksCopyWithImpl<$Res>
    implements _$VendorSocialLinksCopyWith<$Res> {
  __$VendorSocialLinksCopyWithImpl(this._self, this._then);

  final _VendorSocialLinks _self;
  final $Res Function(_VendorSocialLinks) _then;

/// Create a copy of VendorSocialLinks
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? facebook = null,Object? instagram = null,Object? website = null,}) {
  return _then(_VendorSocialLinks(
facebook: null == facebook ? _self.facebook : facebook // ignore: cast_nullable_to_non_nullable
as String,instagram: null == instagram ? _self.instagram : instagram // ignore: cast_nullable_to_non_nullable
as String,website: null == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
