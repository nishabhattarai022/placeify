// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Product {

 String get id; String get name; String get brand; String get sku; double get price; double? get originalPrice; String get imageUrl; String get svgIconPath; bool get hasArView; bool get isWishlisted; String get categoryId; ProductDimensions get dimensions; String? get vendorId; String get offerLabel;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.price, price) || other.price == price)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.svgIconPath, svgIconPath) || other.svgIconPath == svgIconPath)&&(identical(other.hasArView, hasArView) || other.hasArView == hasArView)&&(identical(other.isWishlisted, isWishlisted) || other.isWishlisted == isWishlisted)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.dimensions, dimensions) || other.dimensions == dimensions)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.offerLabel, offerLabel) || other.offerLabel == offerLabel));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,brand,sku,price,originalPrice,imageUrl,svgIconPath,hasArView,isWishlisted,categoryId,dimensions,vendorId,offerLabel);

@override
String toString() {
  return 'Product(id: $id, name: $name, brand: $brand, sku: $sku, price: $price, originalPrice: $originalPrice, imageUrl: $imageUrl, svgIconPath: $svgIconPath, hasArView: $hasArView, isWishlisted: $isWishlisted, categoryId: $categoryId, dimensions: $dimensions, vendorId: $vendorId, offerLabel: $offerLabel)';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 String id, String name, String brand, String sku, double price, double? originalPrice, String imageUrl, String svgIconPath, bool hasArView, bool isWishlisted, String categoryId, ProductDimensions dimensions, String? vendorId, String offerLabel
});


$ProductDimensionsCopyWith<$Res> get dimensions;

}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? brand = null,Object? sku = null,Object? price = null,Object? originalPrice = freezed,Object? imageUrl = null,Object? svgIconPath = null,Object? hasArView = null,Object? isWishlisted = null,Object? categoryId = null,Object? dimensions = null,Object? vendorId = freezed,Object? offerLabel = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,originalPrice: freezed == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double?,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,svgIconPath: null == svgIconPath ? _self.svgIconPath : svgIconPath // ignore: cast_nullable_to_non_nullable
as String,hasArView: null == hasArView ? _self.hasArView : hasArView // ignore: cast_nullable_to_non_nullable
as bool,isWishlisted: null == isWishlisted ? _self.isWishlisted : isWishlisted // ignore: cast_nullable_to_non_nullable
as bool,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,dimensions: null == dimensions ? _self.dimensions : dimensions // ignore: cast_nullable_to_non_nullable
as ProductDimensions,vendorId: freezed == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String?,offerLabel: null == offerLabel ? _self.offerLabel : offerLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductDimensionsCopyWith<$Res> get dimensions {
  
  return $ProductDimensionsCopyWith<$Res>(_self.dimensions, (value) {
    return _then(_self.copyWith(dimensions: value));
  });
}
}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String brand,  String sku,  double price,  double? originalPrice,  String imageUrl,  String svgIconPath,  bool hasArView,  bool isWishlisted,  String categoryId,  ProductDimensions dimensions,  String? vendorId,  String offerLabel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.brand,_that.sku,_that.price,_that.originalPrice,_that.imageUrl,_that.svgIconPath,_that.hasArView,_that.isWishlisted,_that.categoryId,_that.dimensions,_that.vendorId,_that.offerLabel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String brand,  String sku,  double price,  double? originalPrice,  String imageUrl,  String svgIconPath,  bool hasArView,  bool isWishlisted,  String categoryId,  ProductDimensions dimensions,  String? vendorId,  String offerLabel)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.name,_that.brand,_that.sku,_that.price,_that.originalPrice,_that.imageUrl,_that.svgIconPath,_that.hasArView,_that.isWishlisted,_that.categoryId,_that.dimensions,_that.vendorId,_that.offerLabel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String brand,  String sku,  double price,  double? originalPrice,  String imageUrl,  String svgIconPath,  bool hasArView,  bool isWishlisted,  String categoryId,  ProductDimensions dimensions,  String? vendorId,  String offerLabel)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.brand,_that.sku,_that.price,_that.originalPrice,_that.imageUrl,_that.svgIconPath,_that.hasArView,_that.isWishlisted,_that.categoryId,_that.dimensions,_that.vendorId,_that.offerLabel);case _:
  return null;

}
}

}

/// @nodoc


class _Product extends Product {
  const _Product({required this.id, required this.name, required this.brand, required this.sku, required this.price, this.originalPrice, required this.imageUrl, required this.svgIconPath, required this.hasArView, this.isWishlisted = false, required this.categoryId, required this.dimensions, this.vendorId, this.offerLabel = ''}): super._();
  

@override final  String id;
@override final  String name;
@override final  String brand;
@override final  String sku;
@override final  double price;
@override final  double? originalPrice;
@override final  String imageUrl;
@override final  String svgIconPath;
@override final  bool hasArView;
@override@JsonKey() final  bool isWishlisted;
@override final  String categoryId;
@override final  ProductDimensions dimensions;
@override final  String? vendorId;
@override@JsonKey() final  String offerLabel;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.price, price) || other.price == price)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.svgIconPath, svgIconPath) || other.svgIconPath == svgIconPath)&&(identical(other.hasArView, hasArView) || other.hasArView == hasArView)&&(identical(other.isWishlisted, isWishlisted) || other.isWishlisted == isWishlisted)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.dimensions, dimensions) || other.dimensions == dimensions)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.offerLabel, offerLabel) || other.offerLabel == offerLabel));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,brand,sku,price,originalPrice,imageUrl,svgIconPath,hasArView,isWishlisted,categoryId,dimensions,vendorId,offerLabel);

@override
String toString() {
  return 'Product(id: $id, name: $name, brand: $brand, sku: $sku, price: $price, originalPrice: $originalPrice, imageUrl: $imageUrl, svgIconPath: $svgIconPath, hasArView: $hasArView, isWishlisted: $isWishlisted, categoryId: $categoryId, dimensions: $dimensions, vendorId: $vendorId, offerLabel: $offerLabel)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String brand, String sku, double price, double? originalPrice, String imageUrl, String svgIconPath, bool hasArView, bool isWishlisted, String categoryId, ProductDimensions dimensions, String? vendorId, String offerLabel
});


@override $ProductDimensionsCopyWith<$Res> get dimensions;

}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? brand = null,Object? sku = null,Object? price = null,Object? originalPrice = freezed,Object? imageUrl = null,Object? svgIconPath = null,Object? hasArView = null,Object? isWishlisted = null,Object? categoryId = null,Object? dimensions = null,Object? vendorId = freezed,Object? offerLabel = null,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,originalPrice: freezed == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double?,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,svgIconPath: null == svgIconPath ? _self.svgIconPath : svgIconPath // ignore: cast_nullable_to_non_nullable
as String,hasArView: null == hasArView ? _self.hasArView : hasArView // ignore: cast_nullable_to_non_nullable
as bool,isWishlisted: null == isWishlisted ? _self.isWishlisted : isWishlisted // ignore: cast_nullable_to_non_nullable
as bool,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,dimensions: null == dimensions ? _self.dimensions : dimensions // ignore: cast_nullable_to_non_nullable
as ProductDimensions,vendorId: freezed == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String?,offerLabel: null == offerLabel ? _self.offerLabel : offerLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductDimensionsCopyWith<$Res> get dimensions {
  
  return $ProductDimensionsCopyWith<$Res>(_self.dimensions, (value) {
    return _then(_self.copyWith(dimensions: value));
  });
}
}

/// @nodoc
mixin _$ProductDimensions {

 double get widthCm; double get depthCm; double get heightCm;
/// Create a copy of ProductDimensions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductDimensionsCopyWith<ProductDimensions> get copyWith => _$ProductDimensionsCopyWithImpl<ProductDimensions>(this as ProductDimensions, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductDimensions&&(identical(other.widthCm, widthCm) || other.widthCm == widthCm)&&(identical(other.depthCm, depthCm) || other.depthCm == depthCm)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm));
}


@override
int get hashCode => Object.hash(runtimeType,widthCm,depthCm,heightCm);

@override
String toString() {
  return 'ProductDimensions(widthCm: $widthCm, depthCm: $depthCm, heightCm: $heightCm)';
}


}

/// @nodoc
abstract mixin class $ProductDimensionsCopyWith<$Res>  {
  factory $ProductDimensionsCopyWith(ProductDimensions value, $Res Function(ProductDimensions) _then) = _$ProductDimensionsCopyWithImpl;
@useResult
$Res call({
 double widthCm, double depthCm, double heightCm
});




}
/// @nodoc
class _$ProductDimensionsCopyWithImpl<$Res>
    implements $ProductDimensionsCopyWith<$Res> {
  _$ProductDimensionsCopyWithImpl(this._self, this._then);

  final ProductDimensions _self;
  final $Res Function(ProductDimensions) _then;

/// Create a copy of ProductDimensions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? widthCm = null,Object? depthCm = null,Object? heightCm = null,}) {
  return _then(_self.copyWith(
widthCm: null == widthCm ? _self.widthCm : widthCm // ignore: cast_nullable_to_non_nullable
as double,depthCm: null == depthCm ? _self.depthCm : depthCm // ignore: cast_nullable_to_non_nullable
as double,heightCm: null == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductDimensions].
extension ProductDimensionsPatterns on ProductDimensions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductDimensions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductDimensions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductDimensions value)  $default,){
final _that = this;
switch (_that) {
case _ProductDimensions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductDimensions value)?  $default,){
final _that = this;
switch (_that) {
case _ProductDimensions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double widthCm,  double depthCm,  double heightCm)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductDimensions() when $default != null:
return $default(_that.widthCm,_that.depthCm,_that.heightCm);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double widthCm,  double depthCm,  double heightCm)  $default,) {final _that = this;
switch (_that) {
case _ProductDimensions():
return $default(_that.widthCm,_that.depthCm,_that.heightCm);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double widthCm,  double depthCm,  double heightCm)?  $default,) {final _that = this;
switch (_that) {
case _ProductDimensions() when $default != null:
return $default(_that.widthCm,_that.depthCm,_that.heightCm);case _:
  return null;

}
}

}

/// @nodoc


class _ProductDimensions extends ProductDimensions {
  const _ProductDimensions({required this.widthCm, required this.depthCm, required this.heightCm}): super._();
  

@override final  double widthCm;
@override final  double depthCm;
@override final  double heightCm;

/// Create a copy of ProductDimensions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductDimensionsCopyWith<_ProductDimensions> get copyWith => __$ProductDimensionsCopyWithImpl<_ProductDimensions>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductDimensions&&(identical(other.widthCm, widthCm) || other.widthCm == widthCm)&&(identical(other.depthCm, depthCm) || other.depthCm == depthCm)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm));
}


@override
int get hashCode => Object.hash(runtimeType,widthCm,depthCm,heightCm);

@override
String toString() {
  return 'ProductDimensions(widthCm: $widthCm, depthCm: $depthCm, heightCm: $heightCm)';
}


}

/// @nodoc
abstract mixin class _$ProductDimensionsCopyWith<$Res> implements $ProductDimensionsCopyWith<$Res> {
  factory _$ProductDimensionsCopyWith(_ProductDimensions value, $Res Function(_ProductDimensions) _then) = __$ProductDimensionsCopyWithImpl;
@override @useResult
$Res call({
 double widthCm, double depthCm, double heightCm
});




}
/// @nodoc
class __$ProductDimensionsCopyWithImpl<$Res>
    implements _$ProductDimensionsCopyWith<$Res> {
  __$ProductDimensionsCopyWithImpl(this._self, this._then);

  final _ProductDimensions _self;
  final $Res Function(_ProductDimensions) _then;

/// Create a copy of ProductDimensions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? widthCm = null,Object? depthCm = null,Object? heightCm = null,}) {
  return _then(_ProductDimensions(
widthCm: null == widthCm ? _self.widthCm : widthCm // ignore: cast_nullable_to_non_nullable
as double,depthCm: null == depthCm ? _self.depthCm : depthCm // ignore: cast_nullable_to_non_nullable
as double,heightCm: null == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
