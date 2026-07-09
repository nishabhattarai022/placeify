// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shop_listing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShopListing {
  String get vendorId;
  String get businessName;
  String get locality;
  List<String> get tags;
  String? get logoUrl;
  String? get bannerUrl;
  int get productCount;
  double get averageRating;

  /// Create a copy of ShopListing
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ShopListingCopyWith<ShopListing> get copyWith =>
      _$ShopListingCopyWithImpl<ShopListing>(this as ShopListing, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ShopListing &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.locality, locality) ||
                other.locality == locality) &&
            const DeepCollectionEquality().equals(other.tags, tags) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.bannerUrl, bannerUrl) ||
                other.bannerUrl == bannerUrl) &&
            (identical(other.productCount, productCount) ||
                other.productCount == productCount) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      vendorId,
      businessName,
      locality,
      const DeepCollectionEquality().hash(tags),
      logoUrl,
      bannerUrl,
      productCount,
      averageRating);

  @override
  String toString() {
    return 'ShopListing(vendorId: $vendorId, businessName: $businessName, locality: $locality, tags: $tags, logoUrl: $logoUrl, bannerUrl: $bannerUrl, productCount: $productCount, averageRating: $averageRating)';
  }
}

/// @nodoc
abstract mixin class $ShopListingCopyWith<$Res> {
  factory $ShopListingCopyWith(
          ShopListing value, $Res Function(ShopListing) _then) =
      _$ShopListingCopyWithImpl;
  @useResult
  $Res call(
      {String vendorId,
      String businessName,
      String locality,
      List<String> tags,
      String? logoUrl,
      String? bannerUrl,
      int productCount,
      double averageRating});
}

/// @nodoc
class _$ShopListingCopyWithImpl<$Res> implements $ShopListingCopyWith<$Res> {
  _$ShopListingCopyWithImpl(this._self, this._then);

  final ShopListing _self;
  final $Res Function(ShopListing) _then;

  /// Create a copy of ShopListing
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vendorId = null,
    Object? businessName = null,
    Object? locality = null,
    Object? tags = null,
    Object? logoUrl = freezed,
    Object? bannerUrl = freezed,
    Object? productCount = null,
    Object? averageRating = null,
  }) {
    return _then(_self.copyWith(
      vendorId: null == vendorId
          ? _self.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      businessName: null == businessName
          ? _self.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String,
      locality: null == locality
          ? _self.locality
          : locality // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _self.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      logoUrl: freezed == logoUrl
          ? _self.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bannerUrl: freezed == bannerUrl
          ? _self.bannerUrl
          : bannerUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      productCount: null == productCount
          ? _self.productCount
          : productCount // ignore: cast_nullable_to_non_nullable
              as int,
      averageRating: null == averageRating
          ? _self.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [ShopListing].
extension ShopListingPatterns on ShopListing {
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
    TResult Function(_ShopListing value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ShopListing() when $default != null:
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
    TResult Function(_ShopListing value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShopListing():
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
    TResult? Function(_ShopListing value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShopListing() when $default != null:
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
            String vendorId,
            String businessName,
            String locality,
            List<String> tags,
            String? logoUrl,
            String? bannerUrl,
            int productCount,
            double averageRating)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ShopListing() when $default != null:
        return $default(
            _that.vendorId,
            _that.businessName,
            _that.locality,
            _that.tags,
            _that.logoUrl,
            _that.bannerUrl,
            _that.productCount,
            _that.averageRating);
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
            String vendorId,
            String businessName,
            String locality,
            List<String> tags,
            String? logoUrl,
            String? bannerUrl,
            int productCount,
            double averageRating)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShopListing():
        return $default(
            _that.vendorId,
            _that.businessName,
            _that.locality,
            _that.tags,
            _that.logoUrl,
            _that.bannerUrl,
            _that.productCount,
            _that.averageRating);
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
            String vendorId,
            String businessName,
            String locality,
            List<String> tags,
            String? logoUrl,
            String? bannerUrl,
            int productCount,
            double averageRating)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShopListing() when $default != null:
        return $default(
            _that.vendorId,
            _that.businessName,
            _that.locality,
            _that.tags,
            _that.logoUrl,
            _that.bannerUrl,
            _that.productCount,
            _that.averageRating);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ShopListing implements ShopListing {
  const _ShopListing(
      {required this.vendorId,
      required this.businessName,
      required this.locality,
      final List<String> tags = const [],
      this.logoUrl,
      this.bannerUrl,
      this.productCount = 0,
      this.averageRating = 0})
      : _tags = tags;

  @override
  final String vendorId;
  @override
  final String businessName;
  @override
  final String locality;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final String? logoUrl;
  @override
  final String? bannerUrl;
  @override
  @JsonKey()
  final int productCount;
  @override
  @JsonKey()
  final double averageRating;

  /// Create a copy of ShopListing
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ShopListingCopyWith<_ShopListing> get copyWith =>
      __$ShopListingCopyWithImpl<_ShopListing>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ShopListing &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.locality, locality) ||
                other.locality == locality) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.bannerUrl, bannerUrl) ||
                other.bannerUrl == bannerUrl) &&
            (identical(other.productCount, productCount) ||
                other.productCount == productCount) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      vendorId,
      businessName,
      locality,
      const DeepCollectionEquality().hash(_tags),
      logoUrl,
      bannerUrl,
      productCount,
      averageRating);

  @override
  String toString() {
    return 'ShopListing(vendorId: $vendorId, businessName: $businessName, locality: $locality, tags: $tags, logoUrl: $logoUrl, bannerUrl: $bannerUrl, productCount: $productCount, averageRating: $averageRating)';
  }
}

/// @nodoc
abstract mixin class _$ShopListingCopyWith<$Res>
    implements $ShopListingCopyWith<$Res> {
  factory _$ShopListingCopyWith(
          _ShopListing value, $Res Function(_ShopListing) _then) =
      __$ShopListingCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String vendorId,
      String businessName,
      String locality,
      List<String> tags,
      String? logoUrl,
      String? bannerUrl,
      int productCount,
      double averageRating});
}

/// @nodoc
class __$ShopListingCopyWithImpl<$Res> implements _$ShopListingCopyWith<$Res> {
  __$ShopListingCopyWithImpl(this._self, this._then);

  final _ShopListing _self;
  final $Res Function(_ShopListing) _then;

  /// Create a copy of ShopListing
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? vendorId = null,
    Object? businessName = null,
    Object? locality = null,
    Object? tags = null,
    Object? logoUrl = freezed,
    Object? bannerUrl = freezed,
    Object? productCount = null,
    Object? averageRating = null,
  }) {
    return _then(_ShopListing(
      vendorId: null == vendorId
          ? _self.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      businessName: null == businessName
          ? _self.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String,
      locality: null == locality
          ? _self.locality
          : locality // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _self._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      logoUrl: freezed == logoUrl
          ? _self.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bannerUrl: freezed == bannerUrl
          ? _self.bannerUrl
          : bannerUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      productCount: null == productCount
          ? _self.productCount
          : productCount // ignore: cast_nullable_to_non_nullable
              as int,
      averageRating: null == averageRating
          ? _self.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
