// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderItem {

 String get productId; String get productName; String get productImageUrl; String get brandName; String get sku; double get unitPrice; double? get discountedPrice; int get quantity; String? get selectedColor; Map<String, String> get dimensions;
/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderItemCopyWith<OrderItem> get copyWith => _$OrderItemCopyWithImpl<OrderItem>(this as OrderItem, _$identity);

  /// Serializes this OrderItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderItem&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productImageUrl, productImageUrl) || other.productImageUrl == productImageUrl)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.discountedPrice, discountedPrice) || other.discountedPrice == discountedPrice)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.selectedColor, selectedColor) || other.selectedColor == selectedColor)&&const DeepCollectionEquality().equals(other.dimensions, dimensions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,productName,productImageUrl,brandName,sku,unitPrice,discountedPrice,quantity,selectedColor,const DeepCollectionEquality().hash(dimensions));

@override
String toString() {
  return 'OrderItem(productId: $productId, productName: $productName, productImageUrl: $productImageUrl, brandName: $brandName, sku: $sku, unitPrice: $unitPrice, discountedPrice: $discountedPrice, quantity: $quantity, selectedColor: $selectedColor, dimensions: $dimensions)';
}


}

/// @nodoc
abstract mixin class $OrderItemCopyWith<$Res>  {
  factory $OrderItemCopyWith(OrderItem value, $Res Function(OrderItem) _then) = _$OrderItemCopyWithImpl;
@useResult
$Res call({
 String productId, String productName, String productImageUrl, String brandName, String sku, double unitPrice, double? discountedPrice, int quantity, String? selectedColor, Map<String, String> dimensions
});




}
/// @nodoc
class _$OrderItemCopyWithImpl<$Res>
    implements $OrderItemCopyWith<$Res> {
  _$OrderItemCopyWithImpl(this._self, this._then);

  final OrderItem _self;
  final $Res Function(OrderItem) _then;

/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? productName = null,Object? productImageUrl = null,Object? brandName = null,Object? sku = null,Object? unitPrice = null,Object? discountedPrice = freezed,Object? quantity = null,Object? selectedColor = freezed,Object? dimensions = null,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,productImageUrl: null == productImageUrl ? _self.productImageUrl : productImageUrl // ignore: cast_nullable_to_non_nullable
as String,brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,discountedPrice: freezed == discountedPrice ? _self.discountedPrice : discountedPrice // ignore: cast_nullable_to_non_nullable
as double?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,selectedColor: freezed == selectedColor ? _self.selectedColor : selectedColor // ignore: cast_nullable_to_non_nullable
as String?,dimensions: null == dimensions ? _self.dimensions : dimensions // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderItem].
extension OrderItemPatterns on OrderItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderItem value)  $default,){
final _that = this;
switch (_that) {
case _OrderItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderItem value)?  $default,){
final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  String productName,  String productImageUrl,  String brandName,  String sku,  double unitPrice,  double? discountedPrice,  int quantity,  String? selectedColor,  Map<String, String> dimensions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
return $default(_that.productId,_that.productName,_that.productImageUrl,_that.brandName,_that.sku,_that.unitPrice,_that.discountedPrice,_that.quantity,_that.selectedColor,_that.dimensions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  String productName,  String productImageUrl,  String brandName,  String sku,  double unitPrice,  double? discountedPrice,  int quantity,  String? selectedColor,  Map<String, String> dimensions)  $default,) {final _that = this;
switch (_that) {
case _OrderItem():
return $default(_that.productId,_that.productName,_that.productImageUrl,_that.brandName,_that.sku,_that.unitPrice,_that.discountedPrice,_that.quantity,_that.selectedColor,_that.dimensions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  String productName,  String productImageUrl,  String brandName,  String sku,  double unitPrice,  double? discountedPrice,  int quantity,  String? selectedColor,  Map<String, String> dimensions)?  $default,) {final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
return $default(_that.productId,_that.productName,_that.productImageUrl,_that.brandName,_that.sku,_that.unitPrice,_that.discountedPrice,_that.quantity,_that.selectedColor,_that.dimensions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderItem extends OrderItem {
  const _OrderItem({required this.productId, required this.productName, required this.productImageUrl, required this.brandName, required this.sku, required this.unitPrice, this.discountedPrice, required this.quantity, this.selectedColor, final  Map<String, String> dimensions = const {}}): _dimensions = dimensions,super._();
  factory _OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);

@override final  String productId;
@override final  String productName;
@override final  String productImageUrl;
@override final  String brandName;
@override final  String sku;
@override final  double unitPrice;
@override final  double? discountedPrice;
@override final  int quantity;
@override final  String? selectedColor;
 final  Map<String, String> _dimensions;
@override@JsonKey() Map<String, String> get dimensions {
  if (_dimensions is EqualUnmodifiableMapView) return _dimensions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_dimensions);
}


/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderItemCopyWith<_OrderItem> get copyWith => __$OrderItemCopyWithImpl<_OrderItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderItem&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productImageUrl, productImageUrl) || other.productImageUrl == productImageUrl)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.discountedPrice, discountedPrice) || other.discountedPrice == discountedPrice)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.selectedColor, selectedColor) || other.selectedColor == selectedColor)&&const DeepCollectionEquality().equals(other._dimensions, _dimensions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,productName,productImageUrl,brandName,sku,unitPrice,discountedPrice,quantity,selectedColor,const DeepCollectionEquality().hash(_dimensions));

@override
String toString() {
  return 'OrderItem(productId: $productId, productName: $productName, productImageUrl: $productImageUrl, brandName: $brandName, sku: $sku, unitPrice: $unitPrice, discountedPrice: $discountedPrice, quantity: $quantity, selectedColor: $selectedColor, dimensions: $dimensions)';
}


}

/// @nodoc
abstract mixin class _$OrderItemCopyWith<$Res> implements $OrderItemCopyWith<$Res> {
  factory _$OrderItemCopyWith(_OrderItem value, $Res Function(_OrderItem) _then) = __$OrderItemCopyWithImpl;
@override @useResult
$Res call({
 String productId, String productName, String productImageUrl, String brandName, String sku, double unitPrice, double? discountedPrice, int quantity, String? selectedColor, Map<String, String> dimensions
});




}
/// @nodoc
class __$OrderItemCopyWithImpl<$Res>
    implements _$OrderItemCopyWith<$Res> {
  __$OrderItemCopyWithImpl(this._self, this._then);

  final _OrderItem _self;
  final $Res Function(_OrderItem) _then;

/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? productName = null,Object? productImageUrl = null,Object? brandName = null,Object? sku = null,Object? unitPrice = null,Object? discountedPrice = freezed,Object? quantity = null,Object? selectedColor = freezed,Object? dimensions = null,}) {
  return _then(_OrderItem(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,productImageUrl: null == productImageUrl ? _self.productImageUrl : productImageUrl // ignore: cast_nullable_to_non_nullable
as String,brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,discountedPrice: freezed == discountedPrice ? _self.discountedPrice : discountedPrice // ignore: cast_nullable_to_non_nullable
as double?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,selectedColor: freezed == selectedColor ? _self.selectedColor : selectedColor // ignore: cast_nullable_to_non_nullable
as String?,dimensions: null == dimensions ? _self._dimensions : dimensions // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
