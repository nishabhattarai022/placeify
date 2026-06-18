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
import 'delivery_stage.dart' as _i13;
import 'greetings/greeting.dart' as _i14;
import 'notification_preference.dart' as _i15;
import 'order.dart' as _i16;
import 'order_delivery_update.dart' as _i17;
import 'order_item.dart' as _i18;
import 'order_page.dart' as _i19;
import 'order_status.dart' as _i20;
import 'pagination_input.dart' as _i21;
import 'placeify_exception.dart' as _i22;
import 'product.dart' as _i23;
import 'product_page.dart' as _i24;
import 'product_search_input.dart' as _i25;
import 'product_status.dart' as _i26;
import 'refund_request.dart' as _i27;
import 'refund_request_summary.dart' as _i28;
import 'request_status.dart' as _i29;
import 'review.dart' as _i30;
import 'user.dart' as _i31;
import 'user_account_status.dart' as _i32;
import 'user_ar_session_summary.dart' as _i33;
import 'user_dashboard.dart' as _i34;
import 'user_order_summary.dart' as _i35;
import 'user_role.dart' as _i36;
import 'vendor.dart' as _i37;
import 'vendor_dashboard.dart' as _i38;
import 'vendor_document.dart' as _i39;
import 'vendor_document_type.dart' as _i40;
import 'vendor_order_line_item.dart' as _i41;
import 'vendor_order_summary.dart' as _i42;
import 'vendor_product_stat.dart' as _i43;
import 'vendor_product_upload_input.dart' as _i44;
import 'vendor_profile_detail.dart' as _i45;
import 'vendor_profile_update_input.dart' as _i46;
import 'vendor_shop_order.dart' as _i47;
import 'wishlist_item.dart' as _i48;
import 'wishlist_page.dart' as _i49;
import 'package:placeify_client/src/protocol/user_role.dart' as _i50;
import 'package:placeify_client/src/protocol/user_order_summary.dart' as _i51;
import 'package:placeify_client/src/protocol/user_ar_session_summary.dart'
    as _i52;
import 'package:placeify_client/src/protocol/complaint.dart' as _i53;
import 'package:placeify_client/src/protocol/ar_session.dart' as _i54;
import 'package:placeify_client/src/protocol/cart_item.dart' as _i55;
import 'package:placeify_client/src/protocol/order_delivery_update.dart'
    as _i56;
import 'package:placeify_client/src/protocol/category.dart' as _i57;
import 'package:placeify_client/src/protocol/product.dart' as _i58;
import 'package:placeify_client/src/protocol/refund_request_summary.dart'
    as _i59;
import 'package:placeify_client/src/protocol/review.dart' as _i60;
import 'package:placeify_client/src/protocol/vendor_shop_order.dart' as _i61;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i62;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i63;
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
export 'delivery_stage.dart';
export 'greetings/greeting.dart';
export 'notification_preference.dart';
export 'order.dart';
export 'order_delivery_update.dart';
export 'order_item.dart';
export 'order_page.dart';
export 'order_status.dart';
export 'pagination_input.dart';
export 'placeify_exception.dart';
export 'product.dart';
export 'product_page.dart';
export 'product_search_input.dart';
export 'product_status.dart';
export 'refund_request.dart';
export 'refund_request_summary.dart';
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
export 'vendor_document.dart';
export 'vendor_document_type.dart';
export 'vendor_order_line_item.dart';
export 'vendor_order_summary.dart';
export 'vendor_product_stat.dart';
export 'vendor_product_upload_input.dart';
export 'vendor_profile_detail.dart';
export 'vendor_profile_update_input.dart';
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
    if (t == _i13.DeliveryStage) {
      return _i13.DeliveryStage.fromJson(data) as T;
    }
    if (t == _i14.Greeting) {
      return _i14.Greeting.fromJson(data) as T;
    }
    if (t == _i15.NotificationPreference) {
      return _i15.NotificationPreference.fromJson(data) as T;
    }
    if (t == _i16.Order) {
      return _i16.Order.fromJson(data) as T;
    }
    if (t == _i17.OrderDeliveryUpdate) {
      return _i17.OrderDeliveryUpdate.fromJson(data) as T;
    }
    if (t == _i18.OrderItem) {
      return _i18.OrderItem.fromJson(data) as T;
    }
    if (t == _i19.OrderPage) {
      return _i19.OrderPage.fromJson(data) as T;
    }
    if (t == _i20.OrderStatus) {
      return _i20.OrderStatus.fromJson(data) as T;
    }
    if (t == _i21.PaginationInput) {
      return _i21.PaginationInput.fromJson(data) as T;
    }
    if (t == _i22.PlaceifyException) {
      return _i22.PlaceifyException.fromJson(data) as T;
    }
    if (t == _i23.Product) {
      return _i23.Product.fromJson(data) as T;
    }
    if (t == _i24.ProductPage) {
      return _i24.ProductPage.fromJson(data) as T;
    }
    if (t == _i25.ProductSearchInput) {
      return _i25.ProductSearchInput.fromJson(data) as T;
    }
    if (t == _i26.ProductStatus) {
      return _i26.ProductStatus.fromJson(data) as T;
    }
    if (t == _i27.RefundRequest) {
      return _i27.RefundRequest.fromJson(data) as T;
    }
    if (t == _i28.RefundRequestSummary) {
      return _i28.RefundRequestSummary.fromJson(data) as T;
    }
    if (t == _i29.RequestStatus) {
      return _i29.RequestStatus.fromJson(data) as T;
    }
    if (t == _i30.Review) {
      return _i30.Review.fromJson(data) as T;
    }
    if (t == _i31.User) {
      return _i31.User.fromJson(data) as T;
    }
    if (t == _i32.UserAccountStatus) {
      return _i32.UserAccountStatus.fromJson(data) as T;
    }
    if (t == _i33.UserArSessionSummary) {
      return _i33.UserArSessionSummary.fromJson(data) as T;
    }
    if (t == _i34.UserDashboard) {
      return _i34.UserDashboard.fromJson(data) as T;
    }
    if (t == _i35.UserOrderSummary) {
      return _i35.UserOrderSummary.fromJson(data) as T;
    }
    if (t == _i36.UserRole) {
      return _i36.UserRole.fromJson(data) as T;
    }
    if (t == _i37.Vendor) {
      return _i37.Vendor.fromJson(data) as T;
    }
    if (t == _i38.VendorDashboard) {
      return _i38.VendorDashboard.fromJson(data) as T;
    }
    if (t == _i39.VendorDocument) {
      return _i39.VendorDocument.fromJson(data) as T;
    }
    if (t == _i40.VendorDocumentType) {
      return _i40.VendorDocumentType.fromJson(data) as T;
    }
    if (t == _i41.VendorOrderLineItem) {
      return _i41.VendorOrderLineItem.fromJson(data) as T;
    }
    if (t == _i42.VendorOrderSummary) {
      return _i42.VendorOrderSummary.fromJson(data) as T;
    }
    if (t == _i43.VendorProductStat) {
      return _i43.VendorProductStat.fromJson(data) as T;
    }
    if (t == _i44.VendorProductUploadInput) {
      return _i44.VendorProductUploadInput.fromJson(data) as T;
    }
    if (t == _i45.VendorProfileDetail) {
      return _i45.VendorProfileDetail.fromJson(data) as T;
    }
    if (t == _i46.VendorProfileUpdateInput) {
      return _i46.VendorProfileUpdateInput.fromJson(data) as T;
    }
    if (t == _i47.VendorShopOrder) {
      return _i47.VendorShopOrder.fromJson(data) as T;
    }
    if (t == _i48.WishlistItem) {
      return _i48.WishlistItem.fromJson(data) as T;
    }
    if (t == _i49.WishlistPage) {
      return _i49.WishlistPage.fromJson(data) as T;
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
    if (t == _i1.getType<_i13.DeliveryStage?>()) {
      return (data != null ? _i13.DeliveryStage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.Greeting?>()) {
      return (data != null ? _i14.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.NotificationPreference?>()) {
      return (data != null ? _i15.NotificationPreference.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i16.Order?>()) {
      return (data != null ? _i16.Order.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.OrderDeliveryUpdate?>()) {
      return (data != null ? _i17.OrderDeliveryUpdate.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i18.OrderItem?>()) {
      return (data != null ? _i18.OrderItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.OrderPage?>()) {
      return (data != null ? _i19.OrderPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.OrderStatus?>()) {
      return (data != null ? _i20.OrderStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.PaginationInput?>()) {
      return (data != null ? _i21.PaginationInput.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.PlaceifyException?>()) {
      return (data != null ? _i22.PlaceifyException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.Product?>()) {
      return (data != null ? _i23.Product.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.ProductPage?>()) {
      return (data != null ? _i24.ProductPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.ProductSearchInput?>()) {
      return (data != null ? _i25.ProductSearchInput.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i26.ProductStatus?>()) {
      return (data != null ? _i26.ProductStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.RefundRequest?>()) {
      return (data != null ? _i27.RefundRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.RefundRequestSummary?>()) {
      return (data != null ? _i28.RefundRequestSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i29.RequestStatus?>()) {
      return (data != null ? _i29.RequestStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.Review?>()) {
      return (data != null ? _i30.Review.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.User?>()) {
      return (data != null ? _i31.User.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.UserAccountStatus?>()) {
      return (data != null ? _i32.UserAccountStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.UserArSessionSummary?>()) {
      return (data != null ? _i33.UserArSessionSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i34.UserDashboard?>()) {
      return (data != null ? _i34.UserDashboard.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.UserOrderSummary?>()) {
      return (data != null ? _i35.UserOrderSummary.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i36.UserRole?>()) {
      return (data != null ? _i36.UserRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i37.Vendor?>()) {
      return (data != null ? _i37.Vendor.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i38.VendorDashboard?>()) {
      return (data != null ? _i38.VendorDashboard.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i39.VendorDocument?>()) {
      return (data != null ? _i39.VendorDocument.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.VendorDocumentType?>()) {
      return (data != null ? _i40.VendorDocumentType.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i41.VendorOrderLineItem?>()) {
      return (data != null ? _i41.VendorOrderLineItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i42.VendorOrderSummary?>()) {
      return (data != null ? _i42.VendorOrderSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i43.VendorProductStat?>()) {
      return (data != null ? _i43.VendorProductStat.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i44.VendorProductUploadInput?>()) {
      return (data != null
              ? _i44.VendorProductUploadInput.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i45.VendorProfileDetail?>()) {
      return (data != null ? _i45.VendorProfileDetail.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i46.VendorProfileUpdateInput?>()) {
      return (data != null
              ? _i46.VendorProfileUpdateInput.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i47.VendorShopOrder?>()) {
      return (data != null ? _i47.VendorShopOrder.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i48.WishlistItem?>()) {
      return (data != null ? _i48.WishlistItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i49.WishlistPage?>()) {
      return (data != null ? _i49.WishlistPage.fromJson(data) : null) as T;
    }
    if (t == List<_i16.Order>) {
      return (data as List).map((e) => deserialize<_i16.Order>(e)).toList()
          as T;
    }
    if (t == List<_i23.Product>) {
      return (data as List).map((e) => deserialize<_i23.Product>(e)).toList()
          as T;
    }
    if (t == List<_i42.VendorOrderSummary>) {
      return (data as List)
              .map((e) => deserialize<_i42.VendorOrderSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i43.VendorProductStat>) {
      return (data as List)
              .map((e) => deserialize<_i43.VendorProductStat>(e))
              .toList()
          as T;
    }
    if (t == List<_i41.VendorOrderLineItem>) {
      return (data as List)
              .map((e) => deserialize<_i41.VendorOrderLineItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i48.WishlistItem>) {
      return (data as List)
              .map((e) => deserialize<_i48.WishlistItem>(e))
              .toList()
          as T;
    }
    if (t == Set<_i50.UserRole>) {
      return (data as List).map((e) => deserialize<_i50.UserRole>(e)).toSet()
          as T;
    }
    if (t == List<_i51.UserOrderSummary>) {
      return (data as List)
              .map((e) => deserialize<_i51.UserOrderSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i52.UserArSessionSummary>) {
      return (data as List)
              .map((e) => deserialize<_i52.UserArSessionSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i53.Complaint>) {
      return (data as List).map((e) => deserialize<_i53.Complaint>(e)).toList()
          as T;
    }
    if (t == List<_i54.ARSession>) {
      return (data as List).map((e) => deserialize<_i54.ARSession>(e)).toList()
          as T;
    }
    if (t == List<_i55.CartItem>) {
      return (data as List).map((e) => deserialize<_i55.CartItem>(e)).toList()
          as T;
    }
    if (t == List<_i56.OrderDeliveryUpdate>) {
      return (data as List)
              .map((e) => deserialize<_i56.OrderDeliveryUpdate>(e))
              .toList()
          as T;
    }
    if (t == List<_i57.Category>) {
      return (data as List).map((e) => deserialize<_i57.Category>(e)).toList()
          as T;
    }
    if (t == List<_i58.Product>) {
      return (data as List).map((e) => deserialize<_i58.Product>(e)).toList()
          as T;
    }
    if (t == List<_i59.RefundRequestSummary>) {
      return (data as List)
              .map((e) => deserialize<_i59.RefundRequestSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i60.Review>) {
      return (data as List).map((e) => deserialize<_i60.Review>(e)).toList()
          as T;
    }
    if (t == List<_i61.VendorShopOrder>) {
      return (data as List)
              .map((e) => deserialize<_i61.VendorShopOrder>(e))
              .toList()
          as T;
    }
    try {
      return _i62.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i63.Protocol().deserialize<T>(data, t);
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
      _i13.DeliveryStage => 'DeliveryStage',
      _i14.Greeting => 'Greeting',
      _i15.NotificationPreference => 'NotificationPreference',
      _i16.Order => 'Order',
      _i17.OrderDeliveryUpdate => 'OrderDeliveryUpdate',
      _i18.OrderItem => 'OrderItem',
      _i19.OrderPage => 'OrderPage',
      _i20.OrderStatus => 'OrderStatus',
      _i21.PaginationInput => 'PaginationInput',
      _i22.PlaceifyException => 'PlaceifyException',
      _i23.Product => 'Product',
      _i24.ProductPage => 'ProductPage',
      _i25.ProductSearchInput => 'ProductSearchInput',
      _i26.ProductStatus => 'ProductStatus',
      _i27.RefundRequest => 'RefundRequest',
      _i28.RefundRequestSummary => 'RefundRequestSummary',
      _i29.RequestStatus => 'RequestStatus',
      _i30.Review => 'Review',
      _i31.User => 'User',
      _i32.UserAccountStatus => 'UserAccountStatus',
      _i33.UserArSessionSummary => 'UserArSessionSummary',
      _i34.UserDashboard => 'UserDashboard',
      _i35.UserOrderSummary => 'UserOrderSummary',
      _i36.UserRole => 'UserRole',
      _i37.Vendor => 'Vendor',
      _i38.VendorDashboard => 'VendorDashboard',
      _i39.VendorDocument => 'VendorDocument',
      _i40.VendorDocumentType => 'VendorDocumentType',
      _i41.VendorOrderLineItem => 'VendorOrderLineItem',
      _i42.VendorOrderSummary => 'VendorOrderSummary',
      _i43.VendorProductStat => 'VendorProductStat',
      _i44.VendorProductUploadInput => 'VendorProductUploadInput',
      _i45.VendorProfileDetail => 'VendorProfileDetail',
      _i46.VendorProfileUpdateInput => 'VendorProfileUpdateInput',
      _i47.VendorShopOrder => 'VendorShopOrder',
      _i48.WishlistItem => 'WishlistItem',
      _i49.WishlistPage => 'WishlistPage',
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
      case _i13.DeliveryStage():
        return 'DeliveryStage';
      case _i14.Greeting():
        return 'Greeting';
      case _i15.NotificationPreference():
        return 'NotificationPreference';
      case _i16.Order():
        return 'Order';
      case _i17.OrderDeliveryUpdate():
        return 'OrderDeliveryUpdate';
      case _i18.OrderItem():
        return 'OrderItem';
      case _i19.OrderPage():
        return 'OrderPage';
      case _i20.OrderStatus():
        return 'OrderStatus';
      case _i21.PaginationInput():
        return 'PaginationInput';
      case _i22.PlaceifyException():
        return 'PlaceifyException';
      case _i23.Product():
        return 'Product';
      case _i24.ProductPage():
        return 'ProductPage';
      case _i25.ProductSearchInput():
        return 'ProductSearchInput';
      case _i26.ProductStatus():
        return 'ProductStatus';
      case _i27.RefundRequest():
        return 'RefundRequest';
      case _i28.RefundRequestSummary():
        return 'RefundRequestSummary';
      case _i29.RequestStatus():
        return 'RequestStatus';
      case _i30.Review():
        return 'Review';
      case _i31.User():
        return 'User';
      case _i32.UserAccountStatus():
        return 'UserAccountStatus';
      case _i33.UserArSessionSummary():
        return 'UserArSessionSummary';
      case _i34.UserDashboard():
        return 'UserDashboard';
      case _i35.UserOrderSummary():
        return 'UserOrderSummary';
      case _i36.UserRole():
        return 'UserRole';
      case _i37.Vendor():
        return 'Vendor';
      case _i38.VendorDashboard():
        return 'VendorDashboard';
      case _i39.VendorDocument():
        return 'VendorDocument';
      case _i40.VendorDocumentType():
        return 'VendorDocumentType';
      case _i41.VendorOrderLineItem():
        return 'VendorOrderLineItem';
      case _i42.VendorOrderSummary():
        return 'VendorOrderSummary';
      case _i43.VendorProductStat():
        return 'VendorProductStat';
      case _i44.VendorProductUploadInput():
        return 'VendorProductUploadInput';
      case _i45.VendorProfileDetail():
        return 'VendorProfileDetail';
      case _i46.VendorProfileUpdateInput():
        return 'VendorProfileUpdateInput';
      case _i47.VendorShopOrder():
        return 'VendorShopOrder';
      case _i48.WishlistItem():
        return 'WishlistItem';
      case _i49.WishlistPage():
        return 'WishlistPage';
    }
    className = _i62.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    className = _i63.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'DeliveryStage') {
      return deserialize<_i13.DeliveryStage>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i14.Greeting>(data['data']);
    }
    if (dataClassName == 'NotificationPreference') {
      return deserialize<_i15.NotificationPreference>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i16.Order>(data['data']);
    }
    if (dataClassName == 'OrderDeliveryUpdate') {
      return deserialize<_i17.OrderDeliveryUpdate>(data['data']);
    }
    if (dataClassName == 'OrderItem') {
      return deserialize<_i18.OrderItem>(data['data']);
    }
    if (dataClassName == 'OrderPage') {
      return deserialize<_i19.OrderPage>(data['data']);
    }
    if (dataClassName == 'OrderStatus') {
      return deserialize<_i20.OrderStatus>(data['data']);
    }
    if (dataClassName == 'PaginationInput') {
      return deserialize<_i21.PaginationInput>(data['data']);
    }
    if (dataClassName == 'PlaceifyException') {
      return deserialize<_i22.PlaceifyException>(data['data']);
    }
    if (dataClassName == 'Product') {
      return deserialize<_i23.Product>(data['data']);
    }
    if (dataClassName == 'ProductPage') {
      return deserialize<_i24.ProductPage>(data['data']);
    }
    if (dataClassName == 'ProductSearchInput') {
      return deserialize<_i25.ProductSearchInput>(data['data']);
    }
    if (dataClassName == 'ProductStatus') {
      return deserialize<_i26.ProductStatus>(data['data']);
    }
    if (dataClassName == 'RefundRequest') {
      return deserialize<_i27.RefundRequest>(data['data']);
    }
    if (dataClassName == 'RefundRequestSummary') {
      return deserialize<_i28.RefundRequestSummary>(data['data']);
    }
    if (dataClassName == 'RequestStatus') {
      return deserialize<_i29.RequestStatus>(data['data']);
    }
    if (dataClassName == 'Review') {
      return deserialize<_i30.Review>(data['data']);
    }
    if (dataClassName == 'User') {
      return deserialize<_i31.User>(data['data']);
    }
    if (dataClassName == 'UserAccountStatus') {
      return deserialize<_i32.UserAccountStatus>(data['data']);
    }
    if (dataClassName == 'UserArSessionSummary') {
      return deserialize<_i33.UserArSessionSummary>(data['data']);
    }
    if (dataClassName == 'UserDashboard') {
      return deserialize<_i34.UserDashboard>(data['data']);
    }
    if (dataClassName == 'UserOrderSummary') {
      return deserialize<_i35.UserOrderSummary>(data['data']);
    }
    if (dataClassName == 'UserRole') {
      return deserialize<_i36.UserRole>(data['data']);
    }
    if (dataClassName == 'Vendor') {
      return deserialize<_i37.Vendor>(data['data']);
    }
    if (dataClassName == 'VendorDashboard') {
      return deserialize<_i38.VendorDashboard>(data['data']);
    }
    if (dataClassName == 'VendorDocument') {
      return deserialize<_i39.VendorDocument>(data['data']);
    }
    if (dataClassName == 'VendorDocumentType') {
      return deserialize<_i40.VendorDocumentType>(data['data']);
    }
    if (dataClassName == 'VendorOrderLineItem') {
      return deserialize<_i41.VendorOrderLineItem>(data['data']);
    }
    if (dataClassName == 'VendorOrderSummary') {
      return deserialize<_i42.VendorOrderSummary>(data['data']);
    }
    if (dataClassName == 'VendorProductStat') {
      return deserialize<_i43.VendorProductStat>(data['data']);
    }
    if (dataClassName == 'VendorProductUploadInput') {
      return deserialize<_i44.VendorProductUploadInput>(data['data']);
    }
    if (dataClassName == 'VendorProfileDetail') {
      return deserialize<_i45.VendorProfileDetail>(data['data']);
    }
    if (dataClassName == 'VendorProfileUpdateInput') {
      return deserialize<_i46.VendorProfileUpdateInput>(data['data']);
    }
    if (dataClassName == 'VendorShopOrder') {
      return deserialize<_i47.VendorShopOrder>(data['data']);
    }
    if (dataClassName == 'WishlistItem') {
      return deserialize<_i48.WishlistItem>(data['data']);
    }
    if (dataClassName == 'WishlistPage') {
      return deserialize<_i49.WishlistPage>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i62.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i63.Protocol().deserializeByClassName(data);
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
      return _i62.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i63.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
