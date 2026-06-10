// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VendorStats {

 double get revenue; int get orderCount; int get productCount; int get viewCount; double get conversionRate; String get periodLabel;
/// Create a copy of VendorStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VendorStatsCopyWith<VendorStats> get copyWith => _$VendorStatsCopyWithImpl<VendorStats>(this as VendorStats, _$identity);

  /// Serializes this VendorStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VendorStats&&(identical(other.revenue, revenue) || other.revenue == revenue)&&(identical(other.orderCount, orderCount) || other.orderCount == orderCount)&&(identical(other.productCount, productCount) || other.productCount == productCount)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.conversionRate, conversionRate) || other.conversionRate == conversionRate)&&(identical(other.periodLabel, periodLabel) || other.periodLabel == periodLabel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,revenue,orderCount,productCount,viewCount,conversionRate,periodLabel);

@override
String toString() {
  return 'VendorStats(revenue: $revenue, orderCount: $orderCount, productCount: $productCount, viewCount: $viewCount, conversionRate: $conversionRate, periodLabel: $periodLabel)';
}


}

/// @nodoc
abstract mixin class $VendorStatsCopyWith<$Res>  {
  factory $VendorStatsCopyWith(VendorStats value, $Res Function(VendorStats) _then) = _$VendorStatsCopyWithImpl;
@useResult
$Res call({
 double revenue, int orderCount, int productCount, int viewCount, double conversionRate, String periodLabel
});




}
/// @nodoc
class _$VendorStatsCopyWithImpl<$Res>
    implements $VendorStatsCopyWith<$Res> {
  _$VendorStatsCopyWithImpl(this._self, this._then);

  final VendorStats _self;
  final $Res Function(VendorStats) _then;

/// Create a copy of VendorStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? revenue = null,Object? orderCount = null,Object? productCount = null,Object? viewCount = null,Object? conversionRate = null,Object? periodLabel = null,}) {
  return _then(_self.copyWith(
revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as double,orderCount: null == orderCount ? _self.orderCount : orderCount // ignore: cast_nullable_to_non_nullable
as int,productCount: null == productCount ? _self.productCount : productCount // ignore: cast_nullable_to_non_nullable
as int,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,conversionRate: null == conversionRate ? _self.conversionRate : conversionRate // ignore: cast_nullable_to_non_nullable
as double,periodLabel: null == periodLabel ? _self.periodLabel : periodLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VendorStats].
extension VendorStatsPatterns on VendorStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VendorStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VendorStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VendorStats value)  $default,){
final _that = this;
switch (_that) {
case _VendorStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VendorStats value)?  $default,){
final _that = this;
switch (_that) {
case _VendorStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double revenue,  int orderCount,  int productCount,  int viewCount,  double conversionRate,  String periodLabel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VendorStats() when $default != null:
return $default(_that.revenue,_that.orderCount,_that.productCount,_that.viewCount,_that.conversionRate,_that.periodLabel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double revenue,  int orderCount,  int productCount,  int viewCount,  double conversionRate,  String periodLabel)  $default,) {final _that = this;
switch (_that) {
case _VendorStats():
return $default(_that.revenue,_that.orderCount,_that.productCount,_that.viewCount,_that.conversionRate,_that.periodLabel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double revenue,  int orderCount,  int productCount,  int viewCount,  double conversionRate,  String periodLabel)?  $default,) {final _that = this;
switch (_that) {
case _VendorStats() when $default != null:
return $default(_that.revenue,_that.orderCount,_that.productCount,_that.viewCount,_that.conversionRate,_that.periodLabel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VendorStats implements VendorStats {
  const _VendorStats({required this.revenue, required this.orderCount, required this.productCount, required this.viewCount, required this.conversionRate, required this.periodLabel});
  factory _VendorStats.fromJson(Map<String, dynamic> json) => _$VendorStatsFromJson(json);

@override final  double revenue;
@override final  int orderCount;
@override final  int productCount;
@override final  int viewCount;
@override final  double conversionRate;
@override final  String periodLabel;

/// Create a copy of VendorStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VendorStatsCopyWith<_VendorStats> get copyWith => __$VendorStatsCopyWithImpl<_VendorStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VendorStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VendorStats&&(identical(other.revenue, revenue) || other.revenue == revenue)&&(identical(other.orderCount, orderCount) || other.orderCount == orderCount)&&(identical(other.productCount, productCount) || other.productCount == productCount)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.conversionRate, conversionRate) || other.conversionRate == conversionRate)&&(identical(other.periodLabel, periodLabel) || other.periodLabel == periodLabel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,revenue,orderCount,productCount,viewCount,conversionRate,periodLabel);

@override
String toString() {
  return 'VendorStats(revenue: $revenue, orderCount: $orderCount, productCount: $productCount, viewCount: $viewCount, conversionRate: $conversionRate, periodLabel: $periodLabel)';
}


}

/// @nodoc
abstract mixin class _$VendorStatsCopyWith<$Res> implements $VendorStatsCopyWith<$Res> {
  factory _$VendorStatsCopyWith(_VendorStats value, $Res Function(_VendorStats) _then) = __$VendorStatsCopyWithImpl;
@override @useResult
$Res call({
 double revenue, int orderCount, int productCount, int viewCount, double conversionRate, String periodLabel
});




}
/// @nodoc
class __$VendorStatsCopyWithImpl<$Res>
    implements _$VendorStatsCopyWith<$Res> {
  __$VendorStatsCopyWithImpl(this._self, this._then);

  final _VendorStats _self;
  final $Res Function(_VendorStats) _then;

/// Create a copy of VendorStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? revenue = null,Object? orderCount = null,Object? productCount = null,Object? viewCount = null,Object? conversionRate = null,Object? periodLabel = null,}) {
  return _then(_VendorStats(
revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as double,orderCount: null == orderCount ? _self.orderCount : orderCount // ignore: cast_nullable_to_non_nullable
as int,productCount: null == productCount ? _self.productCount : productCount // ignore: cast_nullable_to_non_nullable
as int,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,conversionRate: null == conversionRate ? _self.conversionRate : conversionRate // ignore: cast_nullable_to_non_nullable
as double,periodLabel: null == periodLabel ? _self.periodLabel : periodLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
