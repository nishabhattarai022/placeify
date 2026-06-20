// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor_registration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VendorBusinessInfo {
  String get businessName;
  String get contactName;
  String get email;
  String get phone;
  String get taxId;

  /// Create a copy of VendorBusinessInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VendorBusinessInfoCopyWith<VendorBusinessInfo> get copyWith =>
      _$VendorBusinessInfoCopyWithImpl<VendorBusinessInfo>(
          this as VendorBusinessInfo, _$identity);

  /// Serializes this VendorBusinessInfo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VendorBusinessInfo &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.contactName, contactName) ||
                other.contactName == contactName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.taxId, taxId) || other.taxId == taxId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, businessName, contactName, email, phone, taxId);

  @override
  String toString() {
    return 'VendorBusinessInfo(businessName: $businessName, contactName: $contactName, email: $email, phone: $phone, taxId: $taxId)';
  }
}

/// @nodoc
abstract mixin class $VendorBusinessInfoCopyWith<$Res> {
  factory $VendorBusinessInfoCopyWith(
          VendorBusinessInfo value, $Res Function(VendorBusinessInfo) _then) =
      _$VendorBusinessInfoCopyWithImpl;
  @useResult
  $Res call(
      {String businessName,
      String contactName,
      String email,
      String phone,
      String taxId});
}

/// @nodoc
class _$VendorBusinessInfoCopyWithImpl<$Res>
    implements $VendorBusinessInfoCopyWith<$Res> {
  _$VendorBusinessInfoCopyWithImpl(this._self, this._then);

  final VendorBusinessInfo _self;
  final $Res Function(VendorBusinessInfo) _then;

  /// Create a copy of VendorBusinessInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? businessName = null,
    Object? contactName = null,
    Object? email = null,
    Object? phone = null,
    Object? taxId = null,
  }) {
    return _then(_self.copyWith(
      businessName: null == businessName
          ? _self.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String,
      contactName: null == contactName
          ? _self.contactName
          : contactName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      taxId: null == taxId
          ? _self.taxId
          : taxId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [VendorBusinessInfo].
extension VendorBusinessInfoPatterns on VendorBusinessInfo {
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
    TResult Function(_VendorBusinessInfo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VendorBusinessInfo() when $default != null:
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
    TResult Function(_VendorBusinessInfo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorBusinessInfo():
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
    TResult? Function(_VendorBusinessInfo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorBusinessInfo() when $default != null:
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
    TResult Function(String businessName, String contactName, String email,
            String phone, String taxId)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VendorBusinessInfo() when $default != null:
        return $default(_that.businessName, _that.contactName, _that.email,
            _that.phone, _that.taxId);
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
    TResult Function(String businessName, String contactName, String email,
            String phone, String taxId)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorBusinessInfo():
        return $default(_that.businessName, _that.contactName, _that.email,
            _that.phone, _that.taxId);
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
    TResult? Function(String businessName, String contactName, String email,
            String phone, String taxId)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorBusinessInfo() when $default != null:
        return $default(_that.businessName, _that.contactName, _that.email,
            _that.phone, _that.taxId);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _VendorBusinessInfo implements VendorBusinessInfo {
  const _VendorBusinessInfo(
      {this.businessName = '',
      this.contactName = '',
      this.email = '',
      this.phone = '',
      this.taxId = ''});
  factory _VendorBusinessInfo.fromJson(Map<String, dynamic> json) =>
      _$VendorBusinessInfoFromJson(json);

  @override
  @JsonKey()
  final String businessName;
  @override
  @JsonKey()
  final String contactName;
  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final String phone;
  @override
  @JsonKey()
  final String taxId;

  /// Create a copy of VendorBusinessInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VendorBusinessInfoCopyWith<_VendorBusinessInfo> get copyWith =>
      __$VendorBusinessInfoCopyWithImpl<_VendorBusinessInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VendorBusinessInfoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VendorBusinessInfo &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.contactName, contactName) ||
                other.contactName == contactName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.taxId, taxId) || other.taxId == taxId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, businessName, contactName, email, phone, taxId);

  @override
  String toString() {
    return 'VendorBusinessInfo(businessName: $businessName, contactName: $contactName, email: $email, phone: $phone, taxId: $taxId)';
  }
}

/// @nodoc
abstract mixin class _$VendorBusinessInfoCopyWith<$Res>
    implements $VendorBusinessInfoCopyWith<$Res> {
  factory _$VendorBusinessInfoCopyWith(
          _VendorBusinessInfo value, $Res Function(_VendorBusinessInfo) _then) =
      __$VendorBusinessInfoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String businessName,
      String contactName,
      String email,
      String phone,
      String taxId});
}

/// @nodoc
class __$VendorBusinessInfoCopyWithImpl<$Res>
    implements _$VendorBusinessInfoCopyWith<$Res> {
  __$VendorBusinessInfoCopyWithImpl(this._self, this._then);

  final _VendorBusinessInfo _self;
  final $Res Function(_VendorBusinessInfo) _then;

  /// Create a copy of VendorBusinessInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? businessName = null,
    Object? contactName = null,
    Object? email = null,
    Object? phone = null,
    Object? taxId = null,
  }) {
    return _then(_VendorBusinessInfo(
      businessName: null == businessName
          ? _self.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String,
      contactName: null == contactName
          ? _self.contactName
          : contactName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      taxId: null == taxId
          ? _self.taxId
          : taxId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$VendorAddress {
  String get street;
  String get city;
  String get state;
  String get postalCode;
  String get country;

  /// Create a copy of VendorAddress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VendorAddressCopyWith<VendorAddress> get copyWith =>
      _$VendorAddressCopyWithImpl<VendorAddress>(
          this as VendorAddress, _$identity);

  /// Serializes this VendorAddress to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VendorAddress &&
            (identical(other.street, street) || other.street == street) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.country, country) || other.country == country));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, street, city, state, postalCode, country);

  @override
  String toString() {
    return 'VendorAddress(street: $street, city: $city, state: $state, postalCode: $postalCode, country: $country)';
  }
}

/// @nodoc
abstract mixin class $VendorAddressCopyWith<$Res> {
  factory $VendorAddressCopyWith(
          VendorAddress value, $Res Function(VendorAddress) _then) =
      _$VendorAddressCopyWithImpl;
  @useResult
  $Res call(
      {String street,
      String city,
      String state,
      String postalCode,
      String country});
}

/// @nodoc
class _$VendorAddressCopyWithImpl<$Res>
    implements $VendorAddressCopyWith<$Res> {
  _$VendorAddressCopyWithImpl(this._self, this._then);

  final VendorAddress _self;
  final $Res Function(VendorAddress) _then;

  /// Create a copy of VendorAddress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? street = null,
    Object? city = null,
    Object? state = null,
    Object? postalCode = null,
    Object? country = null,
  }) {
    return _then(_self.copyWith(
      street: null == street
          ? _self.street
          : street // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _self.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      postalCode: null == postalCode
          ? _self.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _self.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [VendorAddress].
extension VendorAddressPatterns on VendorAddress {
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
    TResult Function(_VendorAddress value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VendorAddress() when $default != null:
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
    TResult Function(_VendorAddress value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorAddress():
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
    TResult? Function(_VendorAddress value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorAddress() when $default != null:
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
    TResult Function(String street, String city, String state,
            String postalCode, String country)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VendorAddress() when $default != null:
        return $default(_that.street, _that.city, _that.state, _that.postalCode,
            _that.country);
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
    TResult Function(String street, String city, String state,
            String postalCode, String country)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorAddress():
        return $default(_that.street, _that.city, _that.state, _that.postalCode,
            _that.country);
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
    TResult? Function(String street, String city, String state,
            String postalCode, String country)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorAddress() when $default != null:
        return $default(_that.street, _that.city, _that.state, _that.postalCode,
            _that.country);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _VendorAddress implements VendorAddress {
  const _VendorAddress(
      {this.street = '',
      this.city = '',
      this.state = '',
      this.postalCode = '',
      this.country = ''});
  factory _VendorAddress.fromJson(Map<String, dynamic> json) =>
      _$VendorAddressFromJson(json);

  @override
  @JsonKey()
  final String street;
  @override
  @JsonKey()
  final String city;
  @override
  @JsonKey()
  final String state;
  @override
  @JsonKey()
  final String postalCode;
  @override
  @JsonKey()
  final String country;

  /// Create a copy of VendorAddress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VendorAddressCopyWith<_VendorAddress> get copyWith =>
      __$VendorAddressCopyWithImpl<_VendorAddress>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VendorAddressToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VendorAddress &&
            (identical(other.street, street) || other.street == street) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.country, country) || other.country == country));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, street, city, state, postalCode, country);

  @override
  String toString() {
    return 'VendorAddress(street: $street, city: $city, state: $state, postalCode: $postalCode, country: $country)';
  }
}

/// @nodoc
abstract mixin class _$VendorAddressCopyWith<$Res>
    implements $VendorAddressCopyWith<$Res> {
  factory _$VendorAddressCopyWith(
          _VendorAddress value, $Res Function(_VendorAddress) _then) =
      __$VendorAddressCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String street,
      String city,
      String state,
      String postalCode,
      String country});
}

/// @nodoc
class __$VendorAddressCopyWithImpl<$Res>
    implements _$VendorAddressCopyWith<$Res> {
  __$VendorAddressCopyWithImpl(this._self, this._then);

  final _VendorAddress _self;
  final $Res Function(_VendorAddress) _then;

  /// Create a copy of VendorAddress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? street = null,
    Object? city = null,
    Object? state = null,
    Object? postalCode = null,
    Object? country = null,
  }) {
    return _then(_VendorAddress(
      street: null == street
          ? _self.street
          : street // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _self.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      postalCode: null == postalCode
          ? _self.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _self.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$VendorCategoryInfo {
  List<String> get categories;
  String get description;

  /// Create a copy of VendorCategoryInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VendorCategoryInfoCopyWith<VendorCategoryInfo> get copyWith =>
      _$VendorCategoryInfoCopyWithImpl<VendorCategoryInfo>(
          this as VendorCategoryInfo, _$identity);

  /// Serializes this VendorCategoryInfo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VendorCategoryInfo &&
            const DeepCollectionEquality()
                .equals(other.categories, categories) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(categories), description);

  @override
  String toString() {
    return 'VendorCategoryInfo(categories: $categories, description: $description)';
  }
}

/// @nodoc
abstract mixin class $VendorCategoryInfoCopyWith<$Res> {
  factory $VendorCategoryInfoCopyWith(
          VendorCategoryInfo value, $Res Function(VendorCategoryInfo) _then) =
      _$VendorCategoryInfoCopyWithImpl;
  @useResult
  $Res call({List<String> categories, String description});
}

/// @nodoc
class _$VendorCategoryInfoCopyWithImpl<$Res>
    implements $VendorCategoryInfoCopyWith<$Res> {
  _$VendorCategoryInfoCopyWithImpl(this._self, this._then);

  final VendorCategoryInfo _self;
  final $Res Function(VendorCategoryInfo) _then;

  /// Create a copy of VendorCategoryInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categories = null,
    Object? description = null,
  }) {
    return _then(_self.copyWith(
      categories: null == categories
          ? _self.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [VendorCategoryInfo].
extension VendorCategoryInfoPatterns on VendorCategoryInfo {
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
    TResult Function(_VendorCategoryInfo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VendorCategoryInfo() when $default != null:
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
    TResult Function(_VendorCategoryInfo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorCategoryInfo():
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
    TResult? Function(_VendorCategoryInfo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorCategoryInfo() when $default != null:
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
    TResult Function(List<String> categories, String description)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VendorCategoryInfo() when $default != null:
        return $default(_that.categories, _that.description);
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
    TResult Function(List<String> categories, String description) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorCategoryInfo():
        return $default(_that.categories, _that.description);
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
    TResult? Function(List<String> categories, String description)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorCategoryInfo() when $default != null:
        return $default(_that.categories, _that.description);
      case _:
        return null;
    }
  }
}

/// @nodoc
class _VendorCategoryInfo implements VendorCategoryInfo {
  const _VendorCategoryInfo(
      {final List<String> categories = const [], this.description = ''})
      : _categories = categories;

  factory _VendorCategoryInfo.fromJson(Map<String, dynamic> json) {
    final raw = json['categories'];
    final categories = raw is List
        ? raw
            .map((e) => e.toString().trim())
            .where((name) => name.isNotEmpty)
            .toList()
        : <String>[];
    if (categories.isEmpty) {
      final legacy = json['category'] as String? ?? '';
      if (legacy.trim().isNotEmpty) {
        categories.add(legacy.trim());
      }
    }
    return _VendorCategoryInfo(
      categories: categories,
      description: json['description'] as String? ?? '',
    );
  }

  final List<String> _categories;
  @override
  @JsonKey()
  List<String> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  @JsonKey()
  final String description;

  /// Create a copy of VendorCategoryInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VendorCategoryInfoCopyWith<_VendorCategoryInfo> get copyWith =>
      __$VendorCategoryInfoCopyWithImpl<_VendorCategoryInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() => {
        'categories': categories,
        'description': description,
      };

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VendorCategoryInfo &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_categories), description);

  @override
  String toString() {
    return 'VendorCategoryInfo(categories: $categories, description: $description)';
  }
}

/// @nodoc
abstract mixin class _$VendorCategoryInfoCopyWith<$Res>
    implements $VendorCategoryInfoCopyWith<$Res> {
  factory _$VendorCategoryInfoCopyWith(
          _VendorCategoryInfo value, $Res Function(_VendorCategoryInfo) _then) =
      __$VendorCategoryInfoCopyWithImpl;
  @override
  @useResult
  $Res call({List<String> categories, String description});
}

/// @nodoc
class __$VendorCategoryInfoCopyWithImpl<$Res>
    implements _$VendorCategoryInfoCopyWith<$Res> {
  __$VendorCategoryInfoCopyWithImpl(this._self, this._then);

  final _VendorCategoryInfo _self;
  final $Res Function(_VendorCategoryInfo) _then;

  /// Create a copy of VendorCategoryInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? categories = null,
    Object? description = null,
  }) {
    return _then(_VendorCategoryInfo(
      categories: null == categories
          ? _self._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$VendorDocuments {
  String? get businessLicensePath;
  String? get governmentIdPath;
  String? get taxCertificatePath;

  /// Create a copy of VendorDocuments
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VendorDocumentsCopyWith<VendorDocuments> get copyWith =>
      _$VendorDocumentsCopyWithImpl<VendorDocuments>(
          this as VendorDocuments, _$identity);

  /// Serializes this VendorDocuments to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VendorDocuments &&
            (identical(other.businessLicensePath, businessLicensePath) ||
                other.businessLicensePath == businessLicensePath) &&
            (identical(other.governmentIdPath, governmentIdPath) ||
                other.governmentIdPath == governmentIdPath) &&
            (identical(other.taxCertificatePath, taxCertificatePath) ||
                other.taxCertificatePath == taxCertificatePath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, businessLicensePath, governmentIdPath, taxCertificatePath);

  @override
  String toString() {
    return 'VendorDocuments(businessLicensePath: $businessLicensePath, governmentIdPath: $governmentIdPath, taxCertificatePath: $taxCertificatePath)';
  }
}

/// @nodoc
abstract mixin class $VendorDocumentsCopyWith<$Res> {
  factory $VendorDocumentsCopyWith(
          VendorDocuments value, $Res Function(VendorDocuments) _then) =
      _$VendorDocumentsCopyWithImpl;
  @useResult
  $Res call(
      {String? businessLicensePath,
      String? governmentIdPath,
      String? taxCertificatePath});
}

/// @nodoc
class _$VendorDocumentsCopyWithImpl<$Res>
    implements $VendorDocumentsCopyWith<$Res> {
  _$VendorDocumentsCopyWithImpl(this._self, this._then);

  final VendorDocuments _self;
  final $Res Function(VendorDocuments) _then;

  /// Create a copy of VendorDocuments
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? businessLicensePath = freezed,
    Object? governmentIdPath = freezed,
    Object? taxCertificatePath = freezed,
  }) {
    return _then(_self.copyWith(
      businessLicensePath: freezed == businessLicensePath
          ? _self.businessLicensePath
          : businessLicensePath // ignore: cast_nullable_to_non_nullable
              as String?,
      governmentIdPath: freezed == governmentIdPath
          ? _self.governmentIdPath
          : governmentIdPath // ignore: cast_nullable_to_non_nullable
              as String?,
      taxCertificatePath: freezed == taxCertificatePath
          ? _self.taxCertificatePath
          : taxCertificatePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [VendorDocuments].
extension VendorDocumentsPatterns on VendorDocuments {
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
    TResult Function(_VendorDocuments value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VendorDocuments() when $default != null:
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
    TResult Function(_VendorDocuments value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorDocuments():
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
    TResult? Function(_VendorDocuments value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorDocuments() when $default != null:
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
    TResult Function(String? businessLicensePath, String? governmentIdPath,
            String? taxCertificatePath)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VendorDocuments() when $default != null:
        return $default(_that.businessLicensePath, _that.governmentIdPath,
            _that.taxCertificatePath);
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
    TResult Function(String? businessLicensePath, String? governmentIdPath,
            String? taxCertificatePath)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorDocuments():
        return $default(_that.businessLicensePath, _that.governmentIdPath,
            _that.taxCertificatePath);
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
    TResult? Function(String? businessLicensePath, String? governmentIdPath,
            String? taxCertificatePath)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorDocuments() when $default != null:
        return $default(_that.businessLicensePath, _that.governmentIdPath,
            _that.taxCertificatePath);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _VendorDocuments implements VendorDocuments {
  const _VendorDocuments(
      {this.businessLicensePath,
      this.governmentIdPath,
      this.taxCertificatePath});
  factory _VendorDocuments.fromJson(Map<String, dynamic> json) =>
      _$VendorDocumentsFromJson(json);

  @override
  final String? businessLicensePath;
  @override
  final String? governmentIdPath;
  @override
  final String? taxCertificatePath;

  /// Create a copy of VendorDocuments
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VendorDocumentsCopyWith<_VendorDocuments> get copyWith =>
      __$VendorDocumentsCopyWithImpl<_VendorDocuments>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VendorDocumentsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VendorDocuments &&
            (identical(other.businessLicensePath, businessLicensePath) ||
                other.businessLicensePath == businessLicensePath) &&
            (identical(other.governmentIdPath, governmentIdPath) ||
                other.governmentIdPath == governmentIdPath) &&
            (identical(other.taxCertificatePath, taxCertificatePath) ||
                other.taxCertificatePath == taxCertificatePath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, businessLicensePath, governmentIdPath, taxCertificatePath);

  @override
  String toString() {
    return 'VendorDocuments(businessLicensePath: $businessLicensePath, governmentIdPath: $governmentIdPath, taxCertificatePath: $taxCertificatePath)';
  }
}

/// @nodoc
abstract mixin class _$VendorDocumentsCopyWith<$Res>
    implements $VendorDocumentsCopyWith<$Res> {
  factory _$VendorDocumentsCopyWith(
          _VendorDocuments value, $Res Function(_VendorDocuments) _then) =
      __$VendorDocumentsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? businessLicensePath,
      String? governmentIdPath,
      String? taxCertificatePath});
}

/// @nodoc
class __$VendorDocumentsCopyWithImpl<$Res>
    implements _$VendorDocumentsCopyWith<$Res> {
  __$VendorDocumentsCopyWithImpl(this._self, this._then);

  final _VendorDocuments _self;
  final $Res Function(_VendorDocuments) _then;

  /// Create a copy of VendorDocuments
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? businessLicensePath = freezed,
    Object? governmentIdPath = freezed,
    Object? taxCertificatePath = freezed,
  }) {
    return _then(_VendorDocuments(
      businessLicensePath: freezed == businessLicensePath
          ? _self.businessLicensePath
          : businessLicensePath // ignore: cast_nullable_to_non_nullable
              as String?,
      governmentIdPath: freezed == governmentIdPath
          ? _self.governmentIdPath
          : governmentIdPath // ignore: cast_nullable_to_non_nullable
              as String?,
      taxCertificatePath: freezed == taxCertificatePath
          ? _self.taxCertificatePath
          : taxCertificatePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$VendorBankDetails {
  String get accountHolderName;
  String get bankName;
  String get accountNumber;
  String get routingNumber;

  /// Create a copy of VendorBankDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VendorBankDetailsCopyWith<VendorBankDetails> get copyWith =>
      _$VendorBankDetailsCopyWithImpl<VendorBankDetails>(
          this as VendorBankDetails, _$identity);

  /// Serializes this VendorBankDetails to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VendorBankDetails &&
            (identical(other.accountHolderName, accountHolderName) ||
                other.accountHolderName == accountHolderName) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.accountNumber, accountNumber) ||
                other.accountNumber == accountNumber) &&
            (identical(other.routingNumber, routingNumber) ||
                other.routingNumber == routingNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, accountHolderName, bankName, accountNumber, routingNumber);

  @override
  String toString() {
    return 'VendorBankDetails(accountHolderName: $accountHolderName, bankName: $bankName, accountNumber: $accountNumber, routingNumber: $routingNumber)';
  }
}

/// @nodoc
abstract mixin class $VendorBankDetailsCopyWith<$Res> {
  factory $VendorBankDetailsCopyWith(
          VendorBankDetails value, $Res Function(VendorBankDetails) _then) =
      _$VendorBankDetailsCopyWithImpl;
  @useResult
  $Res call(
      {String accountHolderName,
      String bankName,
      String accountNumber,
      String routingNumber});
}

/// @nodoc
class _$VendorBankDetailsCopyWithImpl<$Res>
    implements $VendorBankDetailsCopyWith<$Res> {
  _$VendorBankDetailsCopyWithImpl(this._self, this._then);

  final VendorBankDetails _self;
  final $Res Function(VendorBankDetails) _then;

  /// Create a copy of VendorBankDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountHolderName = null,
    Object? bankName = null,
    Object? accountNumber = null,
    Object? routingNumber = null,
  }) {
    return _then(_self.copyWith(
      accountHolderName: null == accountHolderName
          ? _self.accountHolderName
          : accountHolderName // ignore: cast_nullable_to_non_nullable
              as String,
      bankName: null == bankName
          ? _self.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String,
      accountNumber: null == accountNumber
          ? _self.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as String,
      routingNumber: null == routingNumber
          ? _self.routingNumber
          : routingNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [VendorBankDetails].
extension VendorBankDetailsPatterns on VendorBankDetails {
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
    TResult Function(_VendorBankDetails value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VendorBankDetails() when $default != null:
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
    TResult Function(_VendorBankDetails value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorBankDetails():
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
    TResult? Function(_VendorBankDetails value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorBankDetails() when $default != null:
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
    TResult Function(String accountHolderName, String bankName,
            String accountNumber, String routingNumber)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VendorBankDetails() when $default != null:
        return $default(_that.accountHolderName, _that.bankName,
            _that.accountNumber, _that.routingNumber);
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
    TResult Function(String accountHolderName, String bankName,
            String accountNumber, String routingNumber)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorBankDetails():
        return $default(_that.accountHolderName, _that.bankName,
            _that.accountNumber, _that.routingNumber);
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
    TResult? Function(String accountHolderName, String bankName,
            String accountNumber, String routingNumber)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorBankDetails() when $default != null:
        return $default(_that.accountHolderName, _that.bankName,
            _that.accountNumber, _that.routingNumber);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _VendorBankDetails implements VendorBankDetails {
  const _VendorBankDetails(
      {this.accountHolderName = '',
      this.bankName = '',
      this.accountNumber = '',
      this.routingNumber = ''});
  factory _VendorBankDetails.fromJson(Map<String, dynamic> json) =>
      _$VendorBankDetailsFromJson(json);

  @override
  @JsonKey()
  final String accountHolderName;
  @override
  @JsonKey()
  final String bankName;
  @override
  @JsonKey()
  final String accountNumber;
  @override
  @JsonKey()
  final String routingNumber;

  /// Create a copy of VendorBankDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VendorBankDetailsCopyWith<_VendorBankDetails> get copyWith =>
      __$VendorBankDetailsCopyWithImpl<_VendorBankDetails>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VendorBankDetailsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VendorBankDetails &&
            (identical(other.accountHolderName, accountHolderName) ||
                other.accountHolderName == accountHolderName) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.accountNumber, accountNumber) ||
                other.accountNumber == accountNumber) &&
            (identical(other.routingNumber, routingNumber) ||
                other.routingNumber == routingNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, accountHolderName, bankName, accountNumber, routingNumber);

  @override
  String toString() {
    return 'VendorBankDetails(accountHolderName: $accountHolderName, bankName: $bankName, accountNumber: $accountNumber, routingNumber: $routingNumber)';
  }
}

/// @nodoc
abstract mixin class _$VendorBankDetailsCopyWith<$Res>
    implements $VendorBankDetailsCopyWith<$Res> {
  factory _$VendorBankDetailsCopyWith(
          _VendorBankDetails value, $Res Function(_VendorBankDetails) _then) =
      __$VendorBankDetailsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String accountHolderName,
      String bankName,
      String accountNumber,
      String routingNumber});
}

/// @nodoc
class __$VendorBankDetailsCopyWithImpl<$Res>
    implements _$VendorBankDetailsCopyWith<$Res> {
  __$VendorBankDetailsCopyWithImpl(this._self, this._then);

  final _VendorBankDetails _self;
  final $Res Function(_VendorBankDetails) _then;

  /// Create a copy of VendorBankDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? accountHolderName = null,
    Object? bankName = null,
    Object? accountNumber = null,
    Object? routingNumber = null,
  }) {
    return _then(_VendorBankDetails(
      accountHolderName: null == accountHolderName
          ? _self.accountHolderName
          : accountHolderName // ignore: cast_nullable_to_non_nullable
              as String,
      bankName: null == bankName
          ? _self.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String,
      accountNumber: null == accountNumber
          ? _self.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as String,
      routingNumber: null == routingNumber
          ? _self.routingNumber
          : routingNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$VendorRegistration {
  VendorBusinessInfo get business;
  VendorAddress get address;
  VendorCategoryInfo get category;
  VendorDocuments get documents;
  VendorBankDetails get bank;

  /// Create a copy of VendorRegistration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VendorRegistrationCopyWith<VendorRegistration> get copyWith =>
      _$VendorRegistrationCopyWithImpl<VendorRegistration>(
          this as VendorRegistration, _$identity);

  /// Serializes this VendorRegistration to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VendorRegistration &&
            (identical(other.business, business) ||
                other.business == business) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.documents, documents) ||
                other.documents == documents) &&
            (identical(other.bank, bank) || other.bank == bank));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, business, address, category, documents, bank);

  @override
  String toString() {
    return 'VendorRegistration(business: $business, address: $address, category: $category, documents: $documents, bank: $bank)';
  }
}

/// @nodoc
abstract mixin class $VendorRegistrationCopyWith<$Res> {
  factory $VendorRegistrationCopyWith(
          VendorRegistration value, $Res Function(VendorRegistration) _then) =
      _$VendorRegistrationCopyWithImpl;
  @useResult
  $Res call(
      {VendorBusinessInfo business,
      VendorAddress address,
      VendorCategoryInfo category,
      VendorDocuments documents,
      VendorBankDetails bank});

  $VendorBusinessInfoCopyWith<$Res> get business;
  $VendorAddressCopyWith<$Res> get address;
  $VendorCategoryInfoCopyWith<$Res> get category;
  $VendorDocumentsCopyWith<$Res> get documents;
  $VendorBankDetailsCopyWith<$Res> get bank;
}

/// @nodoc
class _$VendorRegistrationCopyWithImpl<$Res>
    implements $VendorRegistrationCopyWith<$Res> {
  _$VendorRegistrationCopyWithImpl(this._self, this._then);

  final VendorRegistration _self;
  final $Res Function(VendorRegistration) _then;

  /// Create a copy of VendorRegistration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? business = null,
    Object? address = null,
    Object? category = null,
    Object? documents = null,
    Object? bank = null,
  }) {
    return _then(_self.copyWith(
      business: null == business
          ? _self.business
          : business // ignore: cast_nullable_to_non_nullable
              as VendorBusinessInfo,
      address: null == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as VendorAddress,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as VendorCategoryInfo,
      documents: null == documents
          ? _self.documents
          : documents // ignore: cast_nullable_to_non_nullable
              as VendorDocuments,
      bank: null == bank
          ? _self.bank
          : bank // ignore: cast_nullable_to_non_nullable
              as VendorBankDetails,
    ));
  }

  /// Create a copy of VendorRegistration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VendorBusinessInfoCopyWith<$Res> get business {
    return $VendorBusinessInfoCopyWith<$Res>(_self.business, (value) {
      return _then(_self.copyWith(business: value));
    });
  }

  /// Create a copy of VendorRegistration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VendorAddressCopyWith<$Res> get address {
    return $VendorAddressCopyWith<$Res>(_self.address, (value) {
      return _then(_self.copyWith(address: value));
    });
  }

  /// Create a copy of VendorRegistration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VendorCategoryInfoCopyWith<$Res> get category {
    return $VendorCategoryInfoCopyWith<$Res>(_self.category, (value) {
      return _then(_self.copyWith(category: value));
    });
  }

  /// Create a copy of VendorRegistration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VendorDocumentsCopyWith<$Res> get documents {
    return $VendorDocumentsCopyWith<$Res>(_self.documents, (value) {
      return _then(_self.copyWith(documents: value));
    });
  }

  /// Create a copy of VendorRegistration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VendorBankDetailsCopyWith<$Res> get bank {
    return $VendorBankDetailsCopyWith<$Res>(_self.bank, (value) {
      return _then(_self.copyWith(bank: value));
    });
  }
}

/// Adds pattern-matching-related methods to [VendorRegistration].
extension VendorRegistrationPatterns on VendorRegistration {
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
    TResult Function(_VendorRegistration value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VendorRegistration() when $default != null:
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
    TResult Function(_VendorRegistration value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorRegistration():
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
    TResult? Function(_VendorRegistration value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorRegistration() when $default != null:
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
            VendorBusinessInfo business,
            VendorAddress address,
            VendorCategoryInfo category,
            VendorDocuments documents,
            VendorBankDetails bank)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VendorRegistration() when $default != null:
        return $default(_that.business, _that.address, _that.category,
            _that.documents, _that.bank);
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
            VendorBusinessInfo business,
            VendorAddress address,
            VendorCategoryInfo category,
            VendorDocuments documents,
            VendorBankDetails bank)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorRegistration():
        return $default(_that.business, _that.address, _that.category,
            _that.documents, _that.bank);
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
            VendorBusinessInfo business,
            VendorAddress address,
            VendorCategoryInfo category,
            VendorDocuments documents,
            VendorBankDetails bank)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VendorRegistration() when $default != null:
        return $default(_that.business, _that.address, _that.category,
            _that.documents, _that.bank);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _VendorRegistration implements VendorRegistration {
  const _VendorRegistration(
      {this.business = const VendorBusinessInfo(),
      this.address = const VendorAddress(),
      this.category = const VendorCategoryInfo(),
      this.documents = const VendorDocuments(),
      this.bank = const VendorBankDetails()});
  factory _VendorRegistration.fromJson(Map<String, dynamic> json) =>
      _$VendorRegistrationFromJson(json);

  @override
  @JsonKey()
  final VendorBusinessInfo business;
  @override
  @JsonKey()
  final VendorAddress address;
  @override
  @JsonKey()
  final VendorCategoryInfo category;
  @override
  @JsonKey()
  final VendorDocuments documents;
  @override
  @JsonKey()
  final VendorBankDetails bank;

  /// Create a copy of VendorRegistration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VendorRegistrationCopyWith<_VendorRegistration> get copyWith =>
      __$VendorRegistrationCopyWithImpl<_VendorRegistration>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VendorRegistrationToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VendorRegistration &&
            (identical(other.business, business) ||
                other.business == business) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.documents, documents) ||
                other.documents == documents) &&
            (identical(other.bank, bank) || other.bank == bank));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, business, address, category, documents, bank);

  @override
  String toString() {
    return 'VendorRegistration(business: $business, address: $address, category: $category, documents: $documents, bank: $bank)';
  }
}

/// @nodoc
abstract mixin class _$VendorRegistrationCopyWith<$Res>
    implements $VendorRegistrationCopyWith<$Res> {
  factory _$VendorRegistrationCopyWith(
          _VendorRegistration value, $Res Function(_VendorRegistration) _then) =
      __$VendorRegistrationCopyWithImpl;
  @override
  @useResult
  $Res call(
      {VendorBusinessInfo business,
      VendorAddress address,
      VendorCategoryInfo category,
      VendorDocuments documents,
      VendorBankDetails bank});

  @override
  $VendorBusinessInfoCopyWith<$Res> get business;
  @override
  $VendorAddressCopyWith<$Res> get address;
  @override
  $VendorCategoryInfoCopyWith<$Res> get category;
  @override
  $VendorDocumentsCopyWith<$Res> get documents;
  @override
  $VendorBankDetailsCopyWith<$Res> get bank;
}

/// @nodoc
class __$VendorRegistrationCopyWithImpl<$Res>
    implements _$VendorRegistrationCopyWith<$Res> {
  __$VendorRegistrationCopyWithImpl(this._self, this._then);

  final _VendorRegistration _self;
  final $Res Function(_VendorRegistration) _then;

  /// Create a copy of VendorRegistration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? business = null,
    Object? address = null,
    Object? category = null,
    Object? documents = null,
    Object? bank = null,
  }) {
    return _then(_VendorRegistration(
      business: null == business
          ? _self.business
          : business // ignore: cast_nullable_to_non_nullable
              as VendorBusinessInfo,
      address: null == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as VendorAddress,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as VendorCategoryInfo,
      documents: null == documents
          ? _self.documents
          : documents // ignore: cast_nullable_to_non_nullable
              as VendorDocuments,
      bank: null == bank
          ? _self.bank
          : bank // ignore: cast_nullable_to_non_nullable
              as VendorBankDetails,
    ));
  }

  /// Create a copy of VendorRegistration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VendorBusinessInfoCopyWith<$Res> get business {
    return $VendorBusinessInfoCopyWith<$Res>(_self.business, (value) {
      return _then(_self.copyWith(business: value));
    });
  }

  /// Create a copy of VendorRegistration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VendorAddressCopyWith<$Res> get address {
    return $VendorAddressCopyWith<$Res>(_self.address, (value) {
      return _then(_self.copyWith(address: value));
    });
  }

  /// Create a copy of VendorRegistration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VendorCategoryInfoCopyWith<$Res> get category {
    return $VendorCategoryInfoCopyWith<$Res>(_self.category, (value) {
      return _then(_self.copyWith(category: value));
    });
  }

  /// Create a copy of VendorRegistration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VendorDocumentsCopyWith<$Res> get documents {
    return $VendorDocumentsCopyWith<$Res>(_self.documents, (value) {
      return _then(_self.copyWith(documents: value));
    });
  }

  /// Create a copy of VendorRegistration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VendorBankDetailsCopyWith<$Res> get bank {
    return $VendorBankDetailsCopyWith<$Res>(_self.bank, (value) {
      return _then(_self.copyWith(bank: value));
    });
  }
}

// dart format on
