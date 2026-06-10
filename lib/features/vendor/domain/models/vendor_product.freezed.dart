// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor_product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VendorProduct {
  String get id;
  String get vendorId;
  String get name;
  String get sku;
  double get price;
  int get stock;
  List<String> get imageUrls;
  String get categoryId;
  bool get isActive;
  DateTime get createdAt;

  /// Create a copy of VendorProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VendorProductCopyWith<VendorProduct> get copyWith =>
      _$VendorProductCopyWithImpl<VendorProduct>(
          this as VendorProduct, _$identity);

  /// Serializes this VendorProduct to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VendorProduct &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.stock, stock) || other.stock == stock) &&
            const DeepCollectionEquality().equals(other.imageUrls, imageUrls) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      vendorId,
      name,
      sku,
      price,
      stock,
      const DeepCollectionEquality().hash(imageUrls),
      categoryId,
      isActive,
      createdAt);

  @override
  String toString() {
    return 'VendorProduct(id: $id, vendorId: $vendorId, name: $name, sku: $sku, price: $price, stock: $stock, imageUrls: $imageUrls, categoryId: $categoryId, isActive: $isActive, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $VendorProductCopyWith<$Res> {
  factory $VendorProductCopyWith(
          VendorProduct value, $Res Function(VendorProduct) _then) =
      _$VendorProductCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String vendorId,
      String name,
      String sku,
      double price,
      int stock,
      List<String> imageUrls,
      String categoryId,
      bool isActive,
      DateTime createdAt});
}

/// @nodoc
class _$VendorProductCopyWithImpl<$Res>
    implements $VendorProductCopyWith<$Res> {
  _$VendorProductCopyWithImpl(this._self, this._then);

  final VendorProduct _self;
  final $Res Function(VendorProduct) _then;

  /// Create a copy of VendorProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vendorId = null,
    Object? name = null,
    Object? sku = null,
    Object? price = null,
    Object? stock = null,
    Object? imageUrls = null,
    Object? categoryId = null,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: null == vendorId
          ? _self.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      sku: null == sku
          ? _self.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      stock: null == stock
          ? _self.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int,
      imageUrls: null == imageUrls
          ? _self.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      categoryId: null == categoryId
          ? _self.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [VendorProduct].
extension VendorProductPatterns on VendorProduct {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_VendorProduct value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VendorProduct() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_VendorProduct value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorProduct():
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_VendorProduct value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorProduct() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String vendorId,
            String name,
            String sku,
            double price,
            int stock,
            List<String> imageUrls,
            String categoryId,
            bool isActive,
            DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VendorProduct() when $default != null:
        return $default(
            _that.id,
            _that.vendorId,
            _that.name,
            _that.sku,
            _that.price,
            _that.stock,
            _that.imageUrls,
            _that.categoryId,
            _that.isActive,
            _that.createdAt);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String vendorId,
            String name,
            String sku,
            double price,
            int stock,
            List<String> imageUrls,
            String categoryId,
            bool isActive,
            DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorProduct():
        return $default(
            _that.id,
            _that.vendorId,
            _that.name,
            _that.sku,
            _that.price,
            _that.stock,
            _that.imageUrls,
            _that.categoryId,
            _that.isActive,
            _that.createdAt);
      case _:
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String vendorId,
            String name,
            String sku,
            double price,
            int stock,
            List<String> imageUrls,
            String categoryId,
            bool isActive,
            DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorProduct() when $default != null:
        return $default(
            _that.id,
            _that.vendorId,
            _that.name,
            _that.sku,
            _that.price,
            _that.stock,
            _that.imageUrls,
            _that.categoryId,
            _that.isActive,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _VendorProduct implements VendorProduct {
  const _VendorProduct(
      {required this.id,
      required this.vendorId,
      required this.name,
      required this.sku,
      required this.price,
      required this.stock,
      final List<String> imageUrls = const [],
      required this.categoryId,
      this.isActive = true,
      required this.createdAt})
      : _imageUrls = imageUrls;
  factory _VendorProduct.fromJson(Map<String, dynamic> json) =>
      _$VendorProductFromJson(json);

  @override
  final String id;
  @override
  final String vendorId;
  @override
  final String name;
  @override
  final String sku;
  @override
  final double price;
  @override
  final int stock;
  final List<String> _imageUrls;
  @override
  @JsonKey()
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  @override
  final String categoryId;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime createdAt;

  /// Create a copy of VendorProduct
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VendorProductCopyWith<_VendorProduct> get copyWith =>
      __$VendorProductCopyWithImpl<_VendorProduct>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VendorProductToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VendorProduct &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.stock, stock) || other.stock == stock) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      vendorId,
      name,
      sku,
      price,
      stock,
      const DeepCollectionEquality().hash(_imageUrls),
      categoryId,
      isActive,
      createdAt);

  @override
  String toString() {
    return 'VendorProduct(id: $id, vendorId: $vendorId, name: $name, sku: $sku, price: $price, stock: $stock, imageUrls: $imageUrls, categoryId: $categoryId, isActive: $isActive, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$VendorProductCopyWith<$Res>
    implements $VendorProductCopyWith<$Res> {
  factory _$VendorProductCopyWith(
          _VendorProduct value, $Res Function(_VendorProduct) _then) =
      __$VendorProductCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String vendorId,
      String name,
      String sku,
      double price,
      int stock,
      List<String> imageUrls,
      String categoryId,
      bool isActive,
      DateTime createdAt});
}

/// @nodoc
class __$VendorProductCopyWithImpl<$Res>
    implements _$VendorProductCopyWith<$Res> {
  __$VendorProductCopyWithImpl(this._self, this._then);

  final _VendorProduct _self;
  final $Res Function(_VendorProduct) _then;

  /// Create a copy of VendorProduct
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? vendorId = null,
    Object? name = null,
    Object? sku = null,
    Object? price = null,
    Object? stock = null,
    Object? imageUrls = null,
    Object? categoryId = null,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(_VendorProduct(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: null == vendorId
          ? _self.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      sku: null == sku
          ? _self.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      stock: null == stock
          ? _self.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int,
      imageUrls: null == imageUrls
          ? _self._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      categoryId: null == categoryId
          ? _self.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
