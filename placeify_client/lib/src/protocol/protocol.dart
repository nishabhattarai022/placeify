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
import 'checkout_request.dart' as _i6;
import 'checkout_result.dart' as _i7;
import 'customization_request.dart' as _i8;
import 'greetings/greeting.dart' as _i9;
import 'notification_preference.dart' as _i10;
import 'order.dart' as _i11;
import 'order_item.dart' as _i12;
import 'order_page.dart' as _i13;
import 'order_status.dart' as _i14;
import 'pagination_input.dart' as _i15;
import 'product.dart' as _i16;
import 'product_page.dart' as _i17;
import 'product_search_input.dart' as _i18;
import 'product_status.dart' as _i19;
import 'request_status.dart' as _i20;
import 'review.dart' as _i21;
import 'user.dart' as _i22;
import 'user_ar_session_summary.dart' as _i23;
import 'user_dashboard.dart' as _i24;
import 'user_order_summary.dart' as _i25;
import 'user_role.dart' as _i26;
import 'vendor.dart' as _i27;
import 'vendor_dashboard.dart' as _i28;
import 'vendor_order_line_item.dart' as _i29;
import 'vendor_order_summary.dart' as _i30;
import 'vendor_product_stat.dart' as _i31;
import 'vendor_shop_order.dart' as _i32;
import 'wishlist_item.dart' as _i33;
import 'wishlist_page.dart' as _i34;
import 'package:placeify_client/src/protocol/user_role.dart' as _i35;
import 'package:placeify_client/src/protocol/user_order_summary.dart' as _i36;
import 'package:placeify_client/src/protocol/user_ar_session_summary.dart'
    as _i37;
import 'package:placeify_client/src/protocol/ar_session.dart' as _i38;
import 'package:placeify_client/src/protocol/cart_item.dart' as _i39;
import 'package:placeify_client/src/protocol/category.dart' as _i40;
import 'package:placeify_client/src/protocol/product.dart' as _i41;
import 'package:placeify_client/src/protocol/review.dart' as _i42;
import 'package:placeify_client/src/protocol/vendor_shop_order.dart' as _i43;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i44;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i45;
export 'ar_session.dart';
export 'cart.dart';
export 'cart_item.dart';
export 'category.dart';
export 'checkout_request.dart';
export 'checkout_result.dart';
export 'customization_request.dart';
export 'greetings/greeting.dart';
export 'notification_preference.dart';
export 'order.dart';
export 'order_item.dart';
export 'order_page.dart';
export 'order_status.dart';
export 'pagination_input.dart';
export 'product.dart';
export 'product_page.dart';
export 'product_search_input.dart';
export 'product_status.dart';
export 'request_status.dart';
export 'review.dart';
export 'user.dart';
export 'user_ar_session_summary.dart';
export 'user_dashboard.dart';
export 'user_order_summary.dart';
export 'user_role.dart';
export 'vendor.dart';
export 'vendor_dashboard.dart';
export 'vendor_order_line_item.dart';
export 'vendor_order_summary.dart';
export 'vendor_product_stat.dart';
export 'vendor_shop_order.dart';
export 'wishlist_item.dart';
export 'wishlist_page.dart';
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
    if (t == _i6.CheckoutRequest) {
      return _i6.CheckoutRequest.fromJson(data) as T;
    }
    if (t == _i7.CheckoutResult) {
      return _i7.CheckoutResult.fromJson(data) as T;
    }
    if (t == _i8.CustomizationRequest) {
      return _i8.CustomizationRequest.fromJson(data) as T;
    }
    if (t == _i9.Greeting) {
      return _i9.Greeting.fromJson(data) as T;
    }
    if (t == _i10.NotificationPreference) {
      return _i10.NotificationPreference.fromJson(data) as T;
    }
    if (t == _i11.Order) {
      return _i11.Order.fromJson(data) as T;
    }
    if (t == _i12.OrderItem) {
      return _i12.OrderItem.fromJson(data) as T;
    }
    if (t == _i13.OrderPage) {
      return _i13.OrderPage.fromJson(data) as T;
    }
    if (t == _i14.OrderStatus) {
      return _i14.OrderStatus.fromJson(data) as T;
    }
    if (t == _i15.PaginationInput) {
      return _i15.PaginationInput.fromJson(data) as T;
    }
    if (t == _i16.Product) {
      return _i16.Product.fromJson(data) as T;
    }
    if (t == _i17.ProductPage) {
      return _i17.ProductPage.fromJson(data) as T;
    }
    if (t == _i18.ProductSearchInput) {
      return _i18.ProductSearchInput.fromJson(data) as T;
    }
    if (t == _i19.ProductStatus) {
      return _i19.ProductStatus.fromJson(data) as T;
    }
    if (t == _i20.RequestStatus) {
      return _i20.RequestStatus.fromJson(data) as T;
    }
    if (t == _i21.Review) {
      return _i21.Review.fromJson(data) as T;
    }
    if (t == _i22.User) {
      return _i22.User.fromJson(data) as T;
    }
    if (t == _i23.UserArSessionSummary) {
      return _i23.UserArSessionSummary.fromJson(data) as T;
    }
    if (t == _i24.UserDashboard) {
      return _i24.UserDashboard.fromJson(data) as T;
    }
    if (t == _i25.UserOrderSummary) {
      return _i25.UserOrderSummary.fromJson(data) as T;
    }
    if (t == _i26.UserRole) {
      return _i26.UserRole.fromJson(data) as T;
    }
    if (t == _i27.Vendor) {
      return _i27.Vendor.fromJson(data) as T;
    }
    if (t == _i28.VendorDashboard) {
      return _i28.VendorDashboard.fromJson(data) as T;
    }
    if (t == _i29.VendorOrderLineItem) {
      return _i29.VendorOrderLineItem.fromJson(data) as T;
    }
    if (t == _i30.VendorOrderSummary) {
      return _i30.VendorOrderSummary.fromJson(data) as T;
    }
    if (t == _i31.VendorProductStat) {
      return _i31.VendorProductStat.fromJson(data) as T;
    }
    if (t == _i32.VendorShopOrder) {
      return _i32.VendorShopOrder.fromJson(data) as T;
    }
    if (t == _i33.WishlistItem) {
      return _i33.WishlistItem.fromJson(data) as T;
    }
    if (t == _i34.WishlistPage) {
      return _i34.WishlistPage.fromJson(data) as T;
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
    if (t == _i1.getType<_i6.CheckoutRequest?>()) {
      return (data != null ? _i6.CheckoutRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.CheckoutResult?>()) {
      return (data != null ? _i7.CheckoutResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.CustomizationRequest?>()) {
      return (data != null ? _i8.CustomizationRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i9.Greeting?>()) {
      return (data != null ? _i9.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.NotificationPreference?>()) {
      return (data != null ? _i10.NotificationPreference.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.Order?>()) {
      return (data != null ? _i11.Order.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.OrderItem?>()) {
      return (data != null ? _i12.OrderItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.OrderPage?>()) {
      return (data != null ? _i13.OrderPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.OrderStatus?>()) {
      return (data != null ? _i14.OrderStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.PaginationInput?>()) {
      return (data != null ? _i15.PaginationInput.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.Product?>()) {
      return (data != null ? _i16.Product.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.ProductPage?>()) {
      return (data != null ? _i17.ProductPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.ProductSearchInput?>()) {
      return (data != null ? _i18.ProductSearchInput.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i19.ProductStatus?>()) {
      return (data != null ? _i19.ProductStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.RequestStatus?>()) {
      return (data != null ? _i20.RequestStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.Review?>()) {
      return (data != null ? _i21.Review.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.User?>()) {
      return (data != null ? _i22.User.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.UserArSessionSummary?>()) {
      return (data != null ? _i23.UserArSessionSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i24.UserDashboard?>()) {
      return (data != null ? _i24.UserDashboard.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.UserOrderSummary?>()) {
      return (data != null ? _i25.UserOrderSummary.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.UserRole?>()) {
      return (data != null ? _i26.UserRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.Vendor?>()) {
      return (data != null ? _i27.Vendor.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.VendorDashboard?>()) {
      return (data != null ? _i28.VendorDashboard.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.VendorOrderLineItem?>()) {
      return (data != null ? _i29.VendorOrderLineItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i30.VendorOrderSummary?>()) {
      return (data != null ? _i30.VendorOrderSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i31.VendorProductStat?>()) {
      return (data != null ? _i31.VendorProductStat.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.VendorShopOrder?>()) {
      return (data != null ? _i32.VendorShopOrder.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.WishlistItem?>()) {
      return (data != null ? _i33.WishlistItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.WishlistPage?>()) {
      return (data != null ? _i34.WishlistPage.fromJson(data) : null) as T;
    }
    if (t == List<_i11.Order>) {
      return (data as List).map((e) => deserialize<_i11.Order>(e)).toList()
          as T;
    }
    if (t == List<_i16.Product>) {
      return (data as List).map((e) => deserialize<_i16.Product>(e)).toList()
          as T;
    }
    if (t == List<_i30.VendorOrderSummary>) {
      return (data as List)
              .map((e) => deserialize<_i30.VendorOrderSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i31.VendorProductStat>) {
      return (data as List)
              .map((e) => deserialize<_i31.VendorProductStat>(e))
              .toList()
          as T;
    }
    if (t == List<_i29.VendorOrderLineItem>) {
      return (data as List)
              .map((e) => deserialize<_i29.VendorOrderLineItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i33.WishlistItem>) {
      return (data as List)
              .map((e) => deserialize<_i33.WishlistItem>(e))
              .toList()
          as T;
    }
    if (t == Set<_i35.UserRole>) {
      return (data as List).map((e) => deserialize<_i35.UserRole>(e)).toSet()
          as T;
    }
    if (t == List<_i36.UserOrderSummary>) {
      return (data as List)
              .map((e) => deserialize<_i36.UserOrderSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i37.UserArSessionSummary>) {
      return (data as List)
              .map((e) => deserialize<_i37.UserArSessionSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i38.ARSession>) {
      return (data as List).map((e) => deserialize<_i38.ARSession>(e)).toList()
          as T;
    }
    if (t == List<_i39.CartItem>) {
      return (data as List).map((e) => deserialize<_i39.CartItem>(e)).toList()
          as T;
    }
    if (t == List<_i40.Category>) {
      return (data as List).map((e) => deserialize<_i40.Category>(e)).toList()
          as T;
    }
    if (t == List<_i41.Product>) {
      return (data as List).map((e) => deserialize<_i41.Product>(e)).toList()
          as T;
    }
    if (t == List<_i42.Review>) {
      return (data as List).map((e) => deserialize<_i42.Review>(e)).toList()
          as T;
    }
    if (t == List<_i43.VendorShopOrder>) {
      return (data as List)
              .map((e) => deserialize<_i43.VendorShopOrder>(e))
              .toList()
          as T;
    }
    try {
      return _i44.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i45.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.ARSession => 'ARSession',
      _i3.Cart => 'Cart',
      _i4.CartItem => 'CartItem',
      _i5.Category => 'Category',
      _i6.CheckoutRequest => 'CheckoutRequest',
      _i7.CheckoutResult => 'CheckoutResult',
      _i8.CustomizationRequest => 'CustomizationRequest',
      _i9.Greeting => 'Greeting',
      _i10.NotificationPreference => 'NotificationPreference',
      _i11.Order => 'Order',
      _i12.OrderItem => 'OrderItem',
      _i13.OrderPage => 'OrderPage',
      _i14.OrderStatus => 'OrderStatus',
      _i15.PaginationInput => 'PaginationInput',
      _i16.Product => 'Product',
      _i17.ProductPage => 'ProductPage',
      _i18.ProductSearchInput => 'ProductSearchInput',
      _i19.ProductStatus => 'ProductStatus',
      _i20.RequestStatus => 'RequestStatus',
      _i21.Review => 'Review',
      _i22.User => 'User',
      _i23.UserArSessionSummary => 'UserArSessionSummary',
      _i24.UserDashboard => 'UserDashboard',
      _i25.UserOrderSummary => 'UserOrderSummary',
      _i26.UserRole => 'UserRole',
      _i27.Vendor => 'Vendor',
      _i28.VendorDashboard => 'VendorDashboard',
      _i29.VendorOrderLineItem => 'VendorOrderLineItem',
      _i30.VendorOrderSummary => 'VendorOrderSummary',
      _i31.VendorProductStat => 'VendorProductStat',
      _i32.VendorShopOrder => 'VendorShopOrder',
      _i33.WishlistItem => 'WishlistItem',
      _i34.WishlistPage => 'WishlistPage',
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
      case _i6.CheckoutRequest():
        return 'CheckoutRequest';
      case _i7.CheckoutResult():
        return 'CheckoutResult';
      case _i8.CustomizationRequest():
        return 'CustomizationRequest';
      case _i9.Greeting():
        return 'Greeting';
      case _i10.NotificationPreference():
        return 'NotificationPreference';
      case _i11.Order():
        return 'Order';
      case _i12.OrderItem():
        return 'OrderItem';
      case _i13.OrderPage():
        return 'OrderPage';
      case _i14.OrderStatus():
        return 'OrderStatus';
      case _i15.PaginationInput():
        return 'PaginationInput';
      case _i16.Product():
        return 'Product';
      case _i17.ProductPage():
        return 'ProductPage';
      case _i18.ProductSearchInput():
        return 'ProductSearchInput';
      case _i19.ProductStatus():
        return 'ProductStatus';
      case _i20.RequestStatus():
        return 'RequestStatus';
      case _i21.Review():
        return 'Review';
      case _i22.User():
        return 'User';
      case _i23.UserArSessionSummary():
        return 'UserArSessionSummary';
      case _i24.UserDashboard():
        return 'UserDashboard';
      case _i25.UserOrderSummary():
        return 'UserOrderSummary';
      case _i26.UserRole():
        return 'UserRole';
      case _i27.Vendor():
        return 'Vendor';
      case _i28.VendorDashboard():
        return 'VendorDashboard';
      case _i29.VendorOrderLineItem():
        return 'VendorOrderLineItem';
      case _i30.VendorOrderSummary():
        return 'VendorOrderSummary';
      case _i31.VendorProductStat():
        return 'VendorProductStat';
      case _i32.VendorShopOrder():
        return 'VendorShopOrder';
      case _i33.WishlistItem():
        return 'WishlistItem';
      case _i34.WishlistPage():
        return 'WishlistPage';
    }
    className = _i44.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    className = _i45.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'CheckoutRequest') {
      return deserialize<_i6.CheckoutRequest>(data['data']);
    }
    if (dataClassName == 'CheckoutResult') {
      return deserialize<_i7.CheckoutResult>(data['data']);
    }
    if (dataClassName == 'CustomizationRequest') {
      return deserialize<_i8.CustomizationRequest>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i9.Greeting>(data['data']);
    }
    if (dataClassName == 'NotificationPreference') {
      return deserialize<_i10.NotificationPreference>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i11.Order>(data['data']);
    }
    if (dataClassName == 'OrderItem') {
      return deserialize<_i12.OrderItem>(data['data']);
    }
    if (dataClassName == 'OrderPage') {
      return deserialize<_i13.OrderPage>(data['data']);
    }
    if (dataClassName == 'OrderStatus') {
      return deserialize<_i14.OrderStatus>(data['data']);
    }
    if (dataClassName == 'PaginationInput') {
      return deserialize<_i15.PaginationInput>(data['data']);
    }
    if (dataClassName == 'Product') {
      return deserialize<_i16.Product>(data['data']);
    }
    if (dataClassName == 'ProductPage') {
      return deserialize<_i17.ProductPage>(data['data']);
    }
    if (dataClassName == 'ProductSearchInput') {
      return deserialize<_i18.ProductSearchInput>(data['data']);
    }
    if (dataClassName == 'ProductStatus') {
      return deserialize<_i19.ProductStatus>(data['data']);
    }
    if (dataClassName == 'RequestStatus') {
      return deserialize<_i20.RequestStatus>(data['data']);
    }
    if (dataClassName == 'Review') {
      return deserialize<_i21.Review>(data['data']);
    }
    if (dataClassName == 'User') {
      return deserialize<_i22.User>(data['data']);
    }
    if (dataClassName == 'UserArSessionSummary') {
      return deserialize<_i23.UserArSessionSummary>(data['data']);
    }
    if (dataClassName == 'UserDashboard') {
      return deserialize<_i24.UserDashboard>(data['data']);
    }
    if (dataClassName == 'UserOrderSummary') {
      return deserialize<_i25.UserOrderSummary>(data['data']);
    }
    if (dataClassName == 'UserRole') {
      return deserialize<_i26.UserRole>(data['data']);
    }
    if (dataClassName == 'Vendor') {
      return deserialize<_i27.Vendor>(data['data']);
    }
    if (dataClassName == 'VendorDashboard') {
      return deserialize<_i28.VendorDashboard>(data['data']);
    }
    if (dataClassName == 'VendorOrderLineItem') {
      return deserialize<_i29.VendorOrderLineItem>(data['data']);
    }
    if (dataClassName == 'VendorOrderSummary') {
      return deserialize<_i30.VendorOrderSummary>(data['data']);
    }
    if (dataClassName == 'VendorProductStat') {
      return deserialize<_i31.VendorProductStat>(data['data']);
    }
    if (dataClassName == 'VendorShopOrder') {
      return deserialize<_i32.VendorShopOrder>(data['data']);
    }
    if (dataClassName == 'WishlistItem') {
      return deserialize<_i33.WishlistItem>(data['data']);
    }
    if (dataClassName == 'WishlistPage') {
      return deserialize<_i34.WishlistPage>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i44.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i45.Protocol().deserializeByClassName(data);
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
      return _i44.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i45.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
