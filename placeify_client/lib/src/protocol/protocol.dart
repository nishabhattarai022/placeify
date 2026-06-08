/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'ar_session.dart' as _i2;
import 'cart.dart' as _i3;
import 'cart_item.dart' as _i4;
import 'category.dart' as _i5;
import 'customization_request.dart' as _i6;
import 'greetings/greeting.dart' as _i7;
import 'order.dart' as _i8;
import 'order_item.dart' as _i9;
import 'order_status.dart' as _i10;
import 'product.dart' as _i11;
import 'product_status.dart' as _i12;
import 'request_status.dart' as _i13;
import 'review.dart' as _i14;
import 'user.dart' as _i15;
import 'user_role.dart' as _i16;
import 'vendor.dart' as _i17;
import 'package:placeify_client/src/protocol/user_role.dart' as _i18;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i19;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i20;
export 'ar_session.dart';
export 'cart.dart';
export 'cart_item.dart';
export 'category.dart';
export 'customization_request.dart';
export 'greetings/greeting.dart';
export 'order.dart';
export 'order_item.dart';
export 'order_status.dart';
export 'product.dart';
export 'product_status.dart';
export 'request_status.dart';
export 'review.dart';
export 'user.dart';
export 'user_role.dart';
export 'vendor.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.ARSession) {
      return _i2.ARSession.fromJson(data) as T;
    }
    if (t == _i3.Cart) {
      return _i3.Cart.fromJson(data) as T;
    }
    if (t == _i4.CartItem) {
      return _i4.CartItem.fromJson(data) as T;
    }
    if (t == _i5.Category) {
      return _i5.Category.fromJson(data) as T;
    }
    if (t == _i6.CustomizationRequest) {
      return _i6.CustomizationRequest.fromJson(data) as T;
    }
    if (t == _i7.Greeting) {
      return _i7.Greeting.fromJson(data) as T;
    }
    if (t == _i8.Order) {
      return _i8.Order.fromJson(data) as T;
    }
    if (t == _i9.OrderItem) {
      return _i9.OrderItem.fromJson(data) as T;
    }
    if (t == _i10.OrderStatus) {
      return _i10.OrderStatus.fromJson(data) as T;
    }
    if (t == _i11.Product) {
      return _i11.Product.fromJson(data) as T;
    }
    if (t == _i12.ProductStatus) {
      return _i12.ProductStatus.fromJson(data) as T;
    }
    if (t == _i13.RequestStatus) {
      return _i13.RequestStatus.fromJson(data) as T;
    }
    if (t == _i14.Review) {
      return _i14.Review.fromJson(data) as T;
    }
    if (t == _i15.User) {
      return _i15.User.fromJson(data) as T;
    }
    if (t == _i16.UserRole) {
      return _i16.UserRole.fromJson(data) as T;
    }
    if (t == _i17.Vendor) {
      return _i17.Vendor.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.ARSession?>()) {
      return (data != null ? _i2.ARSession.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.Cart?>()) {
      return (data != null ? _i3.Cart.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.CartItem?>()) {
      return (data != null ? _i4.CartItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.Category?>()) {
      return (data != null ? _i5.Category.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.CustomizationRequest?>()) {
      return (data != null ? _i6.CustomizationRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i7.Greeting?>()) {
      return (data != null ? _i7.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.Order?>()) {
      return (data != null ? _i8.Order.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.OrderItem?>()) {
      return (data != null ? _i9.OrderItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.OrderStatus?>()) {
      return (data != null ? _i10.OrderStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.Product?>()) {
      return (data != null ? _i11.Product.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.ProductStatus?>()) {
      return (data != null ? _i12.ProductStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.RequestStatus?>()) {
      return (data != null ? _i13.RequestStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.Review?>()) {
      return (data != null ? _i14.Review.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.User?>()) {
      return (data != null ? _i15.User.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.UserRole?>()) {
      return (data != null ? _i16.UserRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.Vendor?>()) {
      return (data != null ? _i17.Vendor.fromJson(data) : null) as T;
    }
    if (t == Set<_i18.UserRole>) {
      return (data as List).map((e) => deserialize<_i18.UserRole>(e)).toSet()
          as T;
    }
    try {
      return _i19.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i20.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.ARSession => 'ARSession',
      _i3.Cart => 'Cart',
      _i4.CartItem => 'CartItem',
      _i5.Category => 'Category',
      _i6.CustomizationRequest => 'CustomizationRequest',
      _i7.Greeting => 'Greeting',
      _i8.Order => 'Order',
      _i9.OrderItem => 'OrderItem',
      _i10.OrderStatus => 'OrderStatus',
      _i11.Product => 'Product',
      _i12.ProductStatus => 'ProductStatus',
      _i13.RequestStatus => 'RequestStatus',
      _i14.Review => 'Review',
      _i15.User => 'User',
      _i16.UserRole => 'UserRole',
      _i17.Vendor => 'Vendor',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('placeify.', '');
    }

    switch (data) {
      case _i2.ARSession():
        return 'ARSession';
      case _i3.Cart():
        return 'Cart';
      case _i4.CartItem():
        return 'CartItem';
      case _i5.Category():
        return 'Category';
      case _i6.CustomizationRequest():
        return 'CustomizationRequest';
      case _i7.Greeting():
        return 'Greeting';
      case _i8.Order():
        return 'Order';
      case _i9.OrderItem():
        return 'OrderItem';
      case _i10.OrderStatus():
        return 'OrderStatus';
      case _i11.Product():
        return 'Product';
      case _i12.ProductStatus():
        return 'ProductStatus';
      case _i13.RequestStatus():
        return 'RequestStatus';
      case _i14.Review():
        return 'Review';
      case _i15.User():
        return 'User';
      case _i16.UserRole():
        return 'UserRole';
      case _i17.Vendor():
        return 'Vendor';
    }
    className = _i19.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    className = _i20.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'ARSession') {
      return deserialize<_i2.ARSession>(data['data']);
    }
    if (dataClassName == 'Cart') {
      return deserialize<_i3.Cart>(data['data']);
    }
    if (dataClassName == 'CartItem') {
      return deserialize<_i4.CartItem>(data['data']);
    }
    if (dataClassName == 'Category') {
      return deserialize<_i5.Category>(data['data']);
    }
    if (dataClassName == 'CustomizationRequest') {
      return deserialize<_i6.CustomizationRequest>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i7.Greeting>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i8.Order>(data['data']);
    }
    if (dataClassName == 'OrderItem') {
      return deserialize<_i9.OrderItem>(data['data']);
    }
    if (dataClassName == 'OrderStatus') {
      return deserialize<_i10.OrderStatus>(data['data']);
    }
    if (dataClassName == 'Product') {
      return deserialize<_i11.Product>(data['data']);
    }
    if (dataClassName == 'ProductStatus') {
      return deserialize<_i12.ProductStatus>(data['data']);
    }
    if (dataClassName == 'RequestStatus') {
      return deserialize<_i13.RequestStatus>(data['data']);
    }
    if (dataClassName == 'Review') {
      return deserialize<_i14.Review>(data['data']);
    }
    if (dataClassName == 'User') {
      return deserialize<_i15.User>(data['data']);
    }
    if (dataClassName == 'UserRole') {
      return deserialize<_i16.UserRole>(data['data']);
    }
    if (dataClassName == 'Vendor') {
      return deserialize<_i17.Vendor>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i19.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i20.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i19.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i20.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
