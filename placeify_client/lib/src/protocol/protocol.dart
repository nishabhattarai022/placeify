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
import 'admin.dart' as _i2;
import 'admin_type.dart' as _i3;
import 'ar_session.dart' as _i4;
import 'cart.dart' as _i5;
import 'cart_item.dart' as _i6;
import 'category.dart' as _i7;
import 'checkout_request.dart' as _i8;
import 'checkout_result.dart' as _i9;
import 'complaint.dart' as _i10;
import 'complaint_status.dart' as _i11;
import 'customization_request.dart' as _i12;
import 'greetings/greeting.dart' as _i13;
import 'notification_preference.dart' as _i14;
import 'order.dart' as _i15;
import 'order_item.dart' as _i16;
import 'order_page.dart' as _i17;
import 'order_status.dart' as _i18;
import 'pagination_input.dart' as _i19;
import 'placeify_exception.dart' as _i20;
import 'product.dart' as _i21;
import 'product_page.dart' as _i22;
import 'product_search_input.dart' as _i23;
import 'product_status.dart' as _i24;
import 'request_status.dart' as _i25;
import 'review.dart' as _i26;
import 'user.dart' as _i27;
import 'user_account_status.dart' as _i28;
import 'user_ar_session_summary.dart' as _i29;
import 'user_dashboard.dart' as _i30;
import 'user_order_summary.dart' as _i31;
import 'user_role.dart' as _i32;
import 'vendor.dart' as _i33;
import 'vendor_dashboard.dart' as _i34;
import 'vendor_order_line_item.dart' as _i35;
import 'vendor_order_summary.dart' as _i36;
import 'vendor_product_stat.dart' as _i37;
import 'vendor_product_upload_input.dart' as _i38;
import 'vendor_shop_order.dart' as _i39;
import 'wishlist_item.dart' as _i40;
import 'wishlist_page.dart' as _i41;
import 'package:placeify_client/src/protocol/user_role.dart' as _i42;
import 'package:placeify_client/src/protocol/user_order_summary.dart' as _i43;
import 'package:placeify_client/src/protocol/user_ar_session_summary.dart'
    as _i44;
import 'package:placeify_client/src/protocol/complaint.dart' as _i45;
import 'package:placeify_client/src/protocol/ar_session.dart' as _i46;
import 'package:placeify_client/src/protocol/cart_item.dart' as _i47;
import 'package:placeify_client/src/protocol/category.dart' as _i48;
import 'package:placeify_client/src/protocol/product.dart' as _i49;
import 'package:placeify_client/src/protocol/review.dart' as _i50;
import 'package:placeify_client/src/protocol/vendor_shop_order.dart' as _i51;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i52;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i53;
export 'admin.dart';
export 'admin_type.dart';
export 'ar_session.dart';
export 'cart.dart';
export 'cart_item.dart';
export 'category.dart';
export 'checkout_request.dart';
export 'checkout_result.dart';
export 'complaint.dart';
export 'complaint_status.dart';
export 'customization_request.dart';
export 'greetings/greeting.dart';
export 'notification_preference.dart';
export 'order.dart';
export 'order_item.dart';
export 'order_page.dart';
export 'order_status.dart';
export 'pagination_input.dart';
export 'placeify_exception.dart';
export 'product.dart';
export 'product_page.dart';
export 'product_search_input.dart';
export 'product_status.dart';
export 'request_status.dart';
export 'review.dart';
export 'user.dart';
export 'user_account_status.dart';
export 'user_ar_session_summary.dart';
export 'user_dashboard.dart';
export 'user_order_summary.dart';
export 'user_role.dart';
export 'vendor.dart';
export 'vendor_dashboard.dart';
export 'vendor_order_line_item.dart';
export 'vendor_order_summary.dart';
export 'vendor_product_stat.dart';
export 'vendor_product_upload_input.dart';
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

    if (t == _i2.Admin) {
      return _i2.Admin.fromJson(data) as T;
    }
    if (t == _i3.AdminType) {
      return _i3.AdminType.fromJson(data) as T;
    }
    if (t == _i4.ARSession) {
      return _i4.ARSession.fromJson(data) as T;
    }
    if (t == _i5.Cart) {
      return _i5.Cart.fromJson(data) as T;
    }
    if (t == _i6.CartItem) {
      return _i6.CartItem.fromJson(data) as T;
    }
    if (t == _i7.Category) {
      return _i7.Category.fromJson(data) as T;
    }
    if (t == _i8.CheckoutRequest) {
      return _i8.CheckoutRequest.fromJson(data) as T;
    }
    if (t == _i9.CheckoutResult) {
      return _i9.CheckoutResult.fromJson(data) as T;
    }
    if (t == _i10.Complaint) {
      return _i10.Complaint.fromJson(data) as T;
    }
    if (t == _i11.ComplaintStatus) {
      return _i11.ComplaintStatus.fromJson(data) as T;
    }
    if (t == _i12.CustomizationRequest) {
      return _i12.CustomizationRequest.fromJson(data) as T;
    }
    if (t == _i13.Greeting) {
      return _i13.Greeting.fromJson(data) as T;
    }
    if (t == _i14.NotificationPreference) {
      return _i14.NotificationPreference.fromJson(data) as T;
    }
    if (t == _i15.Order) {
      return _i15.Order.fromJson(data) as T;
    }
    if (t == _i16.OrderItem) {
      return _i16.OrderItem.fromJson(data) as T;
    }
    if (t == _i17.OrderPage) {
      return _i17.OrderPage.fromJson(data) as T;
    }
    if (t == _i18.OrderStatus) {
      return _i18.OrderStatus.fromJson(data) as T;
    }
    if (t == _i19.PaginationInput) {
      return _i19.PaginationInput.fromJson(data) as T;
    }
    if (t == _i20.PlaceifyException) {
      return _i20.PlaceifyException.fromJson(data) as T;
    }
    if (t == _i21.Product) {
      return _i21.Product.fromJson(data) as T;
    }
    if (t == _i22.ProductPage) {
      return _i22.ProductPage.fromJson(data) as T;
    }
    if (t == _i23.ProductSearchInput) {
      return _i23.ProductSearchInput.fromJson(data) as T;
    }
    if (t == _i24.ProductStatus) {
      return _i24.ProductStatus.fromJson(data) as T;
    }
    if (t == _i25.RequestStatus) {
      return _i25.RequestStatus.fromJson(data) as T;
    }
    if (t == _i26.Review) {
      return _i26.Review.fromJson(data) as T;
    }
    if (t == _i27.User) {
      return _i27.User.fromJson(data) as T;
    }
    if (t == _i28.UserAccountStatus) {
      return _i28.UserAccountStatus.fromJson(data) as T;
    }
    if (t == _i29.UserArSessionSummary) {
      return _i29.UserArSessionSummary.fromJson(data) as T;
    }
    if (t == _i30.UserDashboard) {
      return _i30.UserDashboard.fromJson(data) as T;
    }
    if (t == _i31.UserOrderSummary) {
      return _i31.UserOrderSummary.fromJson(data) as T;
    }
    if (t == _i32.UserRole) {
      return _i32.UserRole.fromJson(data) as T;
    }
    if (t == _i33.Vendor) {
      return _i33.Vendor.fromJson(data) as T;
    }
    if (t == _i34.VendorDashboard) {
      return _i34.VendorDashboard.fromJson(data) as T;
    }
    if (t == _i35.VendorOrderLineItem) {
      return _i35.VendorOrderLineItem.fromJson(data) as T;
    }
    if (t == _i36.VendorOrderSummary) {
      return _i36.VendorOrderSummary.fromJson(data) as T;
    }
    if (t == _i37.VendorProductStat) {
      return _i37.VendorProductStat.fromJson(data) as T;
    }
    if (t == _i38.VendorProductUploadInput) {
      return _i38.VendorProductUploadInput.fromJson(data) as T;
    }
    if (t == _i39.VendorShopOrder) {
      return _i39.VendorShopOrder.fromJson(data) as T;
    }
    if (t == _i40.WishlistItem) {
      return _i40.WishlistItem.fromJson(data) as T;
    }
    if (t == _i41.WishlistPage) {
      return _i41.WishlistPage.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Admin?>()) {
      return (data != null ? _i2.Admin.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.AdminType?>()) {
      return (data != null ? _i3.AdminType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.ARSession?>()) {
      return (data != null ? _i4.ARSession.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.Cart?>()) {
      return (data != null ? _i5.Cart.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.CartItem?>()) {
      return (data != null ? _i6.CartItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.Category?>()) {
      return (data != null ? _i7.Category.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.CheckoutRequest?>()) {
      return (data != null ? _i8.CheckoutRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.CheckoutResult?>()) {
      return (data != null ? _i9.CheckoutResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.Complaint?>()) {
      return (data != null ? _i10.Complaint.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.ComplaintStatus?>()) {
      return (data != null ? _i11.ComplaintStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.CustomizationRequest?>()) {
      return (data != null ? _i12.CustomizationRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i13.Greeting?>()) {
      return (data != null ? _i13.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.NotificationPreference?>()) {
      return (data != null ? _i14.NotificationPreference.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i15.Order?>()) {
      return (data != null ? _i15.Order.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.OrderItem?>()) {
      return (data != null ? _i16.OrderItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.OrderPage?>()) {
      return (data != null ? _i17.OrderPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.OrderStatus?>()) {
      return (data != null ? _i18.OrderStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.PaginationInput?>()) {
      return (data != null ? _i19.PaginationInput.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.PlaceifyException?>()) {
      return (data != null ? _i20.PlaceifyException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.Product?>()) {
      return (data != null ? _i21.Product.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.ProductPage?>()) {
      return (data != null ? _i22.ProductPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.ProductSearchInput?>()) {
      return (data != null ? _i23.ProductSearchInput.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i24.ProductStatus?>()) {
      return (data != null ? _i24.ProductStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.RequestStatus?>()) {
      return (data != null ? _i25.RequestStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.Review?>()) {
      return (data != null ? _i26.Review.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.User?>()) {
      return (data != null ? _i27.User.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.UserAccountStatus?>()) {
      return (data != null ? _i28.UserAccountStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.UserArSessionSummary?>()) {
      return (data != null ? _i29.UserArSessionSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i30.UserDashboard?>()) {
      return (data != null ? _i30.UserDashboard.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.UserOrderSummary?>()) {
      return (data != null ? _i31.UserOrderSummary.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.UserRole?>()) {
      return (data != null ? _i32.UserRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.Vendor?>()) {
      return (data != null ? _i33.Vendor.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.VendorDashboard?>()) {
      return (data != null ? _i34.VendorDashboard.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.VendorOrderLineItem?>()) {
      return (data != null ? _i35.VendorOrderLineItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i36.VendorOrderSummary?>()) {
      return (data != null ? _i36.VendorOrderSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i37.VendorProductStat?>()) {
      return (data != null ? _i37.VendorProductStat.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i38.VendorProductUploadInput?>()) {
      return (data != null
              ? _i38.VendorProductUploadInput.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i39.VendorShopOrder?>()) {
      return (data != null ? _i39.VendorShopOrder.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.WishlistItem?>()) {
      return (data != null ? _i40.WishlistItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i41.WishlistPage?>()) {
      return (data != null ? _i41.WishlistPage.fromJson(data) : null) as T;
    }
    if (t == List<_i15.Order>) {
      return (data as List).map((e) => deserialize<_i15.Order>(e)).toList()
          as T;
    }
    if (t == List<_i21.Product>) {
      return (data as List).map((e) => deserialize<_i21.Product>(e)).toList()
          as T;
    }
    if (t == List<_i36.VendorOrderSummary>) {
      return (data as List)
              .map((e) => deserialize<_i36.VendorOrderSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i37.VendorProductStat>) {
      return (data as List)
              .map((e) => deserialize<_i37.VendorProductStat>(e))
              .toList()
          as T;
    }
    if (t == List<_i35.VendorOrderLineItem>) {
      return (data as List)
              .map((e) => deserialize<_i35.VendorOrderLineItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i40.WishlistItem>) {
      return (data as List)
              .map((e) => deserialize<_i40.WishlistItem>(e))
              .toList()
          as T;
    }
    if (t == Set<_i42.UserRole>) {
      return (data as List).map((e) => deserialize<_i42.UserRole>(e)).toSet()
          as T;
    }
    if (t == List<_i43.UserOrderSummary>) {
      return (data as List)
              .map((e) => deserialize<_i43.UserOrderSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i44.UserArSessionSummary>) {
      return (data as List)
              .map((e) => deserialize<_i44.UserArSessionSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i45.Complaint>) {
      return (data as List).map((e) => deserialize<_i45.Complaint>(e)).toList()
          as T;
    }
    if (t == List<_i46.ARSession>) {
      return (data as List).map((e) => deserialize<_i46.ARSession>(e)).toList()
          as T;
    }
    if (t == List<_i47.CartItem>) {
      return (data as List).map((e) => deserialize<_i47.CartItem>(e)).toList()
          as T;
    }
    if (t == List<_i48.Category>) {
      return (data as List).map((e) => deserialize<_i48.Category>(e)).toList()
          as T;
    }
    if (t == List<_i49.Product>) {
      return (data as List).map((e) => deserialize<_i49.Product>(e)).toList()
          as T;
    }
    if (t == List<_i50.Review>) {
      return (data as List).map((e) => deserialize<_i50.Review>(e)).toList()
          as T;
    }
    if (t == List<_i51.VendorShopOrder>) {
      return (data as List)
              .map((e) => deserialize<_i51.VendorShopOrder>(e))
              .toList()
          as T;
    }
    try {
      return _i52.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i53.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.Admin => 'Admin',
      _i3.AdminType => 'AdminType',
      _i4.ARSession => 'ARSession',
      _i5.Cart => 'Cart',
      _i6.CartItem => 'CartItem',
      _i7.Category => 'Category',
      _i8.CheckoutRequest => 'CheckoutRequest',
      _i9.CheckoutResult => 'CheckoutResult',
      _i10.Complaint => 'Complaint',
      _i11.ComplaintStatus => 'ComplaintStatus',
      _i12.CustomizationRequest => 'CustomizationRequest',
      _i13.Greeting => 'Greeting',
      _i14.NotificationPreference => 'NotificationPreference',
      _i15.Order => 'Order',
      _i16.OrderItem => 'OrderItem',
      _i17.OrderPage => 'OrderPage',
      _i18.OrderStatus => 'OrderStatus',
      _i19.PaginationInput => 'PaginationInput',
      _i20.PlaceifyException => 'PlaceifyException',
      _i21.Product => 'Product',
      _i22.ProductPage => 'ProductPage',
      _i23.ProductSearchInput => 'ProductSearchInput',
      _i24.ProductStatus => 'ProductStatus',
      _i25.RequestStatus => 'RequestStatus',
      _i26.Review => 'Review',
      _i27.User => 'User',
      _i28.UserAccountStatus => 'UserAccountStatus',
      _i29.UserArSessionSummary => 'UserArSessionSummary',
      _i30.UserDashboard => 'UserDashboard',
      _i31.UserOrderSummary => 'UserOrderSummary',
      _i32.UserRole => 'UserRole',
      _i33.Vendor => 'Vendor',
      _i34.VendorDashboard => 'VendorDashboard',
      _i35.VendorOrderLineItem => 'VendorOrderLineItem',
      _i36.VendorOrderSummary => 'VendorOrderSummary',
      _i37.VendorProductStat => 'VendorProductStat',
      _i38.VendorProductUploadInput => 'VendorProductUploadInput',
      _i39.VendorShopOrder => 'VendorShopOrder',
      _i40.WishlistItem => 'WishlistItem',
      _i41.WishlistPage => 'WishlistPage',
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
      case _i2.Admin():
        return 'Admin';
      case _i3.AdminType():
        return 'AdminType';
      case _i4.ARSession():
        return 'ARSession';
      case _i5.Cart():
        return 'Cart';
      case _i6.CartItem():
        return 'CartItem';
      case _i7.Category():
        return 'Category';
      case _i8.CheckoutRequest():
        return 'CheckoutRequest';
      case _i9.CheckoutResult():
        return 'CheckoutResult';
      case _i10.Complaint():
        return 'Complaint';
      case _i11.ComplaintStatus():
        return 'ComplaintStatus';
      case _i12.CustomizationRequest():
        return 'CustomizationRequest';
      case _i13.Greeting():
        return 'Greeting';
      case _i14.NotificationPreference():
        return 'NotificationPreference';
      case _i15.Order():
        return 'Order';
      case _i16.OrderItem():
        return 'OrderItem';
      case _i17.OrderPage():
        return 'OrderPage';
      case _i18.OrderStatus():
        return 'OrderStatus';
      case _i19.PaginationInput():
        return 'PaginationInput';
      case _i20.PlaceifyException():
        return 'PlaceifyException';
      case _i21.Product():
        return 'Product';
      case _i22.ProductPage():
        return 'ProductPage';
      case _i23.ProductSearchInput():
        return 'ProductSearchInput';
      case _i24.ProductStatus():
        return 'ProductStatus';
      case _i25.RequestStatus():
        return 'RequestStatus';
      case _i26.Review():
        return 'Review';
      case _i27.User():
        return 'User';
      case _i28.UserAccountStatus():
        return 'UserAccountStatus';
      case _i29.UserArSessionSummary():
        return 'UserArSessionSummary';
      case _i30.UserDashboard():
        return 'UserDashboard';
      case _i31.UserOrderSummary():
        return 'UserOrderSummary';
      case _i32.UserRole():
        return 'UserRole';
      case _i33.Vendor():
        return 'Vendor';
      case _i34.VendorDashboard():
        return 'VendorDashboard';
      case _i35.VendorOrderLineItem():
        return 'VendorOrderLineItem';
      case _i36.VendorOrderSummary():
        return 'VendorOrderSummary';
      case _i37.VendorProductStat():
        return 'VendorProductStat';
      case _i38.VendorProductUploadInput():
        return 'VendorProductUploadInput';
      case _i39.VendorShopOrder():
        return 'VendorShopOrder';
      case _i40.WishlistItem():
        return 'WishlistItem';
      case _i41.WishlistPage():
        return 'WishlistPage';
    }
    className = _i52.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    className = _i53.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'Admin') {
      return deserialize<_i2.Admin>(data['data']);
    }
    if (dataClassName == 'AdminType') {
      return deserialize<_i3.AdminType>(data['data']);
    }
    if (dataClassName == 'ARSession') {
      return deserialize<_i4.ARSession>(data['data']);
    }
    if (dataClassName == 'Cart') {
      return deserialize<_i5.Cart>(data['data']);
    }
    if (dataClassName == 'CartItem') {
      return deserialize<_i6.CartItem>(data['data']);
    }
    if (dataClassName == 'Category') {
      return deserialize<_i7.Category>(data['data']);
    }
    if (dataClassName == 'CheckoutRequest') {
      return deserialize<_i8.CheckoutRequest>(data['data']);
    }
    if (dataClassName == 'CheckoutResult') {
      return deserialize<_i9.CheckoutResult>(data['data']);
    }
    if (dataClassName == 'Complaint') {
      return deserialize<_i10.Complaint>(data['data']);
    }
    if (dataClassName == 'ComplaintStatus') {
      return deserialize<_i11.ComplaintStatus>(data['data']);
    }
    if (dataClassName == 'CustomizationRequest') {
      return deserialize<_i12.CustomizationRequest>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i13.Greeting>(data['data']);
    }
    if (dataClassName == 'NotificationPreference') {
      return deserialize<_i14.NotificationPreference>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i15.Order>(data['data']);
    }
    if (dataClassName == 'OrderItem') {
      return deserialize<_i16.OrderItem>(data['data']);
    }
    if (dataClassName == 'OrderPage') {
      return deserialize<_i17.OrderPage>(data['data']);
    }
    if (dataClassName == 'OrderStatus') {
      return deserialize<_i18.OrderStatus>(data['data']);
    }
    if (dataClassName == 'PaginationInput') {
      return deserialize<_i19.PaginationInput>(data['data']);
    }
    if (dataClassName == 'PlaceifyException') {
      return deserialize<_i20.PlaceifyException>(data['data']);
    }
    if (dataClassName == 'Product') {
      return deserialize<_i21.Product>(data['data']);
    }
    if (dataClassName == 'ProductPage') {
      return deserialize<_i22.ProductPage>(data['data']);
    }
    if (dataClassName == 'ProductSearchInput') {
      return deserialize<_i23.ProductSearchInput>(data['data']);
    }
    if (dataClassName == 'ProductStatus') {
      return deserialize<_i24.ProductStatus>(data['data']);
    }
    if (dataClassName == 'RequestStatus') {
      return deserialize<_i25.RequestStatus>(data['data']);
    }
    if (dataClassName == 'Review') {
      return deserialize<_i26.Review>(data['data']);
    }
    if (dataClassName == 'User') {
      return deserialize<_i27.User>(data['data']);
    }
    if (dataClassName == 'UserAccountStatus') {
      return deserialize<_i28.UserAccountStatus>(data['data']);
    }
    if (dataClassName == 'UserArSessionSummary') {
      return deserialize<_i29.UserArSessionSummary>(data['data']);
    }
    if (dataClassName == 'UserDashboard') {
      return deserialize<_i30.UserDashboard>(data['data']);
    }
    if (dataClassName == 'UserOrderSummary') {
      return deserialize<_i31.UserOrderSummary>(data['data']);
    }
    if (dataClassName == 'UserRole') {
      return deserialize<_i32.UserRole>(data['data']);
    }
    if (dataClassName == 'Vendor') {
      return deserialize<_i33.Vendor>(data['data']);
    }
    if (dataClassName == 'VendorDashboard') {
      return deserialize<_i34.VendorDashboard>(data['data']);
    }
    if (dataClassName == 'VendorOrderLineItem') {
      return deserialize<_i35.VendorOrderLineItem>(data['data']);
    }
    if (dataClassName == 'VendorOrderSummary') {
      return deserialize<_i36.VendorOrderSummary>(data['data']);
    }
    if (dataClassName == 'VendorProductStat') {
      return deserialize<_i37.VendorProductStat>(data['data']);
    }
    if (dataClassName == 'VendorProductUploadInput') {
      return deserialize<_i38.VendorProductUploadInput>(data['data']);
    }
    if (dataClassName == 'VendorShopOrder') {
      return deserialize<_i39.VendorShopOrder>(data['data']);
    }
    if (dataClassName == 'WishlistItem') {
      return deserialize<_i40.WishlistItem>(data['data']);
    }
    if (dataClassName == 'WishlistPage') {
      return deserialize<_i41.WishlistPage>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i52.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i53.Protocol().deserializeByClassName(data);
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
      return _i52.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i53.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
