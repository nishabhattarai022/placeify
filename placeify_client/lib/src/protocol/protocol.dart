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
import 'admin_audit_log_summary.dart' as _i3;
import 'admin_platform_stats.dart' as _i4;
import 'admin_type.dart' as _i5;
import 'ar_session.dart' as _i6;
import 'cart.dart' as _i7;
import 'cart_item.dart' as _i8;
import 'category.dart' as _i9;
import 'checkout_request.dart' as _i10;
import 'checkout_result.dart' as _i11;
import 'complaint.dart' as _i12;
import 'complaint_status.dart' as _i13;
import 'customization_request.dart' as _i14;
import 'delivery_stage.dart' as _i15;
import 'greetings/greeting.dart' as _i16;
import 'notification_preference.dart' as _i17;
import 'order.dart' as _i18;
import 'order_delivery_update.dart' as _i19;
import 'order_item.dart' as _i20;
import 'order_page.dart' as _i21;
import 'order_status.dart' as _i22;
import 'pagination_input.dart' as _i23;
import 'placeify_exception.dart' as _i24;
import 'platform_user_summary.dart' as _i25;
import 'product.dart' as _i26;
import 'product_page.dart' as _i27;
import 'product_search_input.dart' as _i28;
import 'product_status.dart' as _i29;
import 'refund_request.dart' as _i30;
import 'refund_request_summary.dart' as _i31;
import 'request_status.dart' as _i32;
import 'review.dart' as _i33;
import 'shop_listing_summary.dart' as _i34;
import 'user.dart' as _i35;
import 'user_account_status.dart' as _i36;
import 'user_ar_session_summary.dart' as _i37;
import 'user_dashboard.dart' as _i38;
import 'user_order_summary.dart' as _i39;
import 'user_role.dart' as _i40;
import 'vendor.dart' as _i41;
import 'vendor_application_detail.dart' as _i42;
import 'vendor_application_summary.dart' as _i43;
import 'vendor_dashboard.dart' as _i44;
import 'vendor_document.dart' as _i45;
import 'vendor_document_type.dart' as _i46;
import 'vendor_order_line_item.dart' as _i47;
import 'vendor_order_summary.dart' as _i48;
import 'vendor_product_stat.dart' as _i49;
import 'vendor_product_upload_input.dart' as _i50;
import 'vendor_profile_detail.dart' as _i51;
import 'vendor_profile_update_input.dart' as _i52;
import 'vendor_shop_order.dart' as _i53;
import 'wishlist_item.dart' as _i54;
import 'wishlist_page.dart' as _i55;
import 'package:placeify_client/src/protocol/user_role.dart' as _i56;
import 'package:placeify_client/src/protocol/user_order_summary.dart' as _i57;
import 'package:placeify_client/src/protocol/user_ar_session_summary.dart'
    as _i58;
import 'package:placeify_client/src/protocol/complaint.dart' as _i59;
import 'package:placeify_client/src/protocol/platform_user_summary.dart'
    as _i60;
import 'package:placeify_client/src/protocol/vendor_application_summary.dart'
    as _i61;
import 'package:placeify_client/src/protocol/admin_audit_log_summary.dart'
    as _i62;
import 'package:placeify_client/src/protocol/ar_session.dart' as _i63;
import 'package:placeify_client/src/protocol/cart_item.dart' as _i64;
import 'package:placeify_client/src/protocol/order_delivery_update.dart'
    as _i65;
import 'package:placeify_client/src/protocol/category.dart' as _i66;
import 'package:placeify_client/src/protocol/shop_listing_summary.dart' as _i67;
import 'package:placeify_client/src/protocol/product.dart' as _i68;
import 'package:placeify_client/src/protocol/refund_request_summary.dart'
    as _i69;
import 'package:placeify_client/src/protocol/review.dart' as _i70;
import 'package:placeify_client/src/protocol/vendor_shop_order.dart' as _i71;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i72;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i73;
export 'admin.dart';
export 'admin_audit_log_summary.dart';
export 'admin_platform_stats.dart';
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
export 'platform_user_summary.dart';
export 'product.dart';
export 'product_page.dart';
export 'product_search_input.dart';
export 'product_status.dart';
export 'refund_request.dart';
export 'refund_request_summary.dart';
export 'request_status.dart';
export 'review.dart';
export 'shop_listing_summary.dart';
export 'user.dart';
export 'user_account_status.dart';
export 'user_ar_session_summary.dart';
export 'user_dashboard.dart';
export 'user_order_summary.dart';
export 'user_role.dart';
export 'vendor.dart';
export 'vendor_application_detail.dart';
export 'vendor_application_summary.dart';
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
    if (t == _i3.AdminAuditLogSummary) {
      return _i3.AdminAuditLogSummary.fromJson(data) as T;
    }
    if (t == _i4.AdminPlatformStats) {
      return _i4.AdminPlatformStats.fromJson(data) as T;
    }
    if (t == _i5.AdminType) {
      return _i5.AdminType.fromJson(data) as T;
    }
    if (t == _i6.ARSession) {
      return _i6.ARSession.fromJson(data) as T;
    }
    if (t == _i7.Cart) {
      return _i7.Cart.fromJson(data) as T;
    }
    if (t == _i8.CartItem) {
      return _i8.CartItem.fromJson(data) as T;
    }
    if (t == _i9.Category) {
      return _i9.Category.fromJson(data) as T;
    }
    if (t == _i10.CheckoutRequest) {
      return _i10.CheckoutRequest.fromJson(data) as T;
    }
    if (t == _i11.CheckoutResult) {
      return _i11.CheckoutResult.fromJson(data) as T;
    }
    if (t == _i12.Complaint) {
      return _i12.Complaint.fromJson(data) as T;
    }
    if (t == _i13.ComplaintStatus) {
      return _i13.ComplaintStatus.fromJson(data) as T;
    }
    if (t == _i14.CustomizationRequest) {
      return _i14.CustomizationRequest.fromJson(data) as T;
    }
    if (t == _i15.DeliveryStage) {
      return _i15.DeliveryStage.fromJson(data) as T;
    }
    if (t == _i16.Greeting) {
      return _i16.Greeting.fromJson(data) as T;
    }
    if (t == _i17.NotificationPreference) {
      return _i17.NotificationPreference.fromJson(data) as T;
    }
    if (t == _i18.Order) {
      return _i18.Order.fromJson(data) as T;
    }
    if (t == _i19.OrderDeliveryUpdate) {
      return _i19.OrderDeliveryUpdate.fromJson(data) as T;
    }
    if (t == _i20.OrderItem) {
      return _i20.OrderItem.fromJson(data) as T;
    }
    if (t == _i21.OrderPage) {
      return _i21.OrderPage.fromJson(data) as T;
    }
    if (t == _i22.OrderStatus) {
      return _i22.OrderStatus.fromJson(data) as T;
    }
    if (t == _i23.PaginationInput) {
      return _i23.PaginationInput.fromJson(data) as T;
    }
    if (t == _i24.PlaceifyException) {
      return _i24.PlaceifyException.fromJson(data) as T;
    }
    if (t == _i25.PlatformUserSummary) {
      return _i25.PlatformUserSummary.fromJson(data) as T;
    }
    if (t == _i26.Product) {
      return _i26.Product.fromJson(data) as T;
    }
    if (t == _i27.ProductPage) {
      return _i27.ProductPage.fromJson(data) as T;
    }
    if (t == _i28.ProductSearchInput) {
      return _i28.ProductSearchInput.fromJson(data) as T;
    }
    if (t == _i29.ProductStatus) {
      return _i29.ProductStatus.fromJson(data) as T;
    }
    if (t == _i30.RefundRequest) {
      return _i30.RefundRequest.fromJson(data) as T;
    }
    if (t == _i31.RefundRequestSummary) {
      return _i31.RefundRequestSummary.fromJson(data) as T;
    }
    if (t == _i32.RequestStatus) {
      return _i32.RequestStatus.fromJson(data) as T;
    }
    if (t == _i33.Review) {
      return _i33.Review.fromJson(data) as T;
    }
    if (t == _i34.ShopListingSummary) {
      return _i34.ShopListingSummary.fromJson(data) as T;
    }
    if (t == _i35.User) {
      return _i35.User.fromJson(data) as T;
    }
    if (t == _i36.UserAccountStatus) {
      return _i36.UserAccountStatus.fromJson(data) as T;
    }
    if (t == _i37.UserArSessionSummary) {
      return _i37.UserArSessionSummary.fromJson(data) as T;
    }
    if (t == _i38.UserDashboard) {
      return _i38.UserDashboard.fromJson(data) as T;
    }
    if (t == _i39.UserOrderSummary) {
      return _i39.UserOrderSummary.fromJson(data) as T;
    }
    if (t == _i40.UserRole) {
      return _i40.UserRole.fromJson(data) as T;
    }
    if (t == _i41.Vendor) {
      return _i41.Vendor.fromJson(data) as T;
    }
    if (t == _i42.VendorApplicationDetail) {
      return _i42.VendorApplicationDetail.fromJson(data) as T;
    }
    if (t == _i43.VendorApplicationSummary) {
      return _i43.VendorApplicationSummary.fromJson(data) as T;
    }
    if (t == _i44.VendorDashboard) {
      return _i44.VendorDashboard.fromJson(data) as T;
    }
    if (t == _i45.VendorDocument) {
      return _i45.VendorDocument.fromJson(data) as T;
    }
    if (t == _i46.VendorDocumentType) {
      return _i46.VendorDocumentType.fromJson(data) as T;
    }
    if (t == _i47.VendorOrderLineItem) {
      return _i47.VendorOrderLineItem.fromJson(data) as T;
    }
    if (t == _i48.VendorOrderSummary) {
      return _i48.VendorOrderSummary.fromJson(data) as T;
    }
    if (t == _i49.VendorProductStat) {
      return _i49.VendorProductStat.fromJson(data) as T;
    }
    if (t == _i50.VendorProductUploadInput) {
      return _i50.VendorProductUploadInput.fromJson(data) as T;
    }
    if (t == _i51.VendorProfileDetail) {
      return _i51.VendorProfileDetail.fromJson(data) as T;
    }
    if (t == _i52.VendorProfileUpdateInput) {
      return _i52.VendorProfileUpdateInput.fromJson(data) as T;
    }
    if (t == _i53.VendorShopOrder) {
      return _i53.VendorShopOrder.fromJson(data) as T;
    }
    if (t == _i54.WishlistItem) {
      return _i54.WishlistItem.fromJson(data) as T;
    }
    if (t == _i55.WishlistPage) {
      return _i55.WishlistPage.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Admin?>()) {
      return (data != null ? _i2.Admin.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.AdminAuditLogSummary?>()) {
      return (data != null ? _i3.AdminAuditLogSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i4.AdminPlatformStats?>()) {
      return (data != null ? _i4.AdminPlatformStats.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.AdminType?>()) {
      return (data != null ? _i5.AdminType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.ARSession?>()) {
      return (data != null ? _i6.ARSession.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.Cart?>()) {
      return (data != null ? _i7.Cart.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.CartItem?>()) {
      return (data != null ? _i8.CartItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.Category?>()) {
      return (data != null ? _i9.Category.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.CheckoutRequest?>()) {
      return (data != null ? _i10.CheckoutRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.CheckoutResult?>()) {
      return (data != null ? _i11.CheckoutResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.Complaint?>()) {
      return (data != null ? _i12.Complaint.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.ComplaintStatus?>()) {
      return (data != null ? _i13.ComplaintStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.CustomizationRequest?>()) {
      return (data != null ? _i14.CustomizationRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i15.DeliveryStage?>()) {
      return (data != null ? _i15.DeliveryStage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.Greeting?>()) {
      return (data != null ? _i16.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.NotificationPreference?>()) {
      return (data != null ? _i17.NotificationPreference.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i18.Order?>()) {
      return (data != null ? _i18.Order.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.OrderDeliveryUpdate?>()) {
      return (data != null ? _i19.OrderDeliveryUpdate.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i20.OrderItem?>()) {
      return (data != null ? _i20.OrderItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.OrderPage?>()) {
      return (data != null ? _i21.OrderPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.OrderStatus?>()) {
      return (data != null ? _i22.OrderStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.PaginationInput?>()) {
      return (data != null ? _i23.PaginationInput.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.PlaceifyException?>()) {
      return (data != null ? _i24.PlaceifyException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.PlatformUserSummary?>()) {
      return (data != null ? _i25.PlatformUserSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i26.Product?>()) {
      return (data != null ? _i26.Product.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.ProductPage?>()) {
      return (data != null ? _i27.ProductPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.ProductSearchInput?>()) {
      return (data != null ? _i28.ProductSearchInput.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i29.ProductStatus?>()) {
      return (data != null ? _i29.ProductStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.RefundRequest?>()) {
      return (data != null ? _i30.RefundRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.RefundRequestSummary?>()) {
      return (data != null ? _i31.RefundRequestSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i32.RequestStatus?>()) {
      return (data != null ? _i32.RequestStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.Review?>()) {
      return (data != null ? _i33.Review.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.ShopListingSummary?>()) {
      return (data != null ? _i34.ShopListingSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i35.User?>()) {
      return (data != null ? _i35.User.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i36.UserAccountStatus?>()) {
      return (data != null ? _i36.UserAccountStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i37.UserArSessionSummary?>()) {
      return (data != null ? _i37.UserArSessionSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i38.UserDashboard?>()) {
      return (data != null ? _i38.UserDashboard.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i39.UserOrderSummary?>()) {
      return (data != null ? _i39.UserOrderSummary.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.UserRole?>()) {
      return (data != null ? _i40.UserRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i41.Vendor?>()) {
      return (data != null ? _i41.Vendor.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i42.VendorApplicationDetail?>()) {
      return (data != null ? _i42.VendorApplicationDetail.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i43.VendorApplicationSummary?>()) {
      return (data != null
              ? _i43.VendorApplicationSummary.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i44.VendorDashboard?>()) {
      return (data != null ? _i44.VendorDashboard.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i45.VendorDocument?>()) {
      return (data != null ? _i45.VendorDocument.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i46.VendorDocumentType?>()) {
      return (data != null ? _i46.VendorDocumentType.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i47.VendorOrderLineItem?>()) {
      return (data != null ? _i47.VendorOrderLineItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i48.VendorOrderSummary?>()) {
      return (data != null ? _i48.VendorOrderSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i49.VendorProductStat?>()) {
      return (data != null ? _i49.VendorProductStat.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i50.VendorProductUploadInput?>()) {
      return (data != null
              ? _i50.VendorProductUploadInput.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i51.VendorProfileDetail?>()) {
      return (data != null ? _i51.VendorProfileDetail.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i52.VendorProfileUpdateInput?>()) {
      return (data != null
              ? _i52.VendorProfileUpdateInput.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i53.VendorShopOrder?>()) {
      return (data != null ? _i53.VendorShopOrder.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i54.WishlistItem?>()) {
      return (data != null ? _i54.WishlistItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i55.WishlistPage?>()) {
      return (data != null ? _i55.WishlistPage.fromJson(data) : null) as T;
    }
    if (t == List<_i3.AdminAuditLogSummary>) {
      return (data as List)
              .map((e) => deserialize<_i3.AdminAuditLogSummary>(e))
              .toList()
          as T;
    }
    if (t == List<double>) {
      return (data as List).map((e) => deserialize<double>(e)).toList() as T;
    }
    if (t == List<_i43.VendorApplicationSummary>) {
      return (data as List)
              .map((e) => deserialize<_i43.VendorApplicationSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i18.Order>) {
      return (data as List).map((e) => deserialize<_i18.Order>(e)).toList()
          as T;
    }
    if (t == List<_i26.Product>) {
      return (data as List).map((e) => deserialize<_i26.Product>(e)).toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i48.VendorOrderSummary>) {
      return (data as List)
              .map((e) => deserialize<_i48.VendorOrderSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i49.VendorProductStat>) {
      return (data as List)
              .map((e) => deserialize<_i49.VendorProductStat>(e))
              .toList()
          as T;
    }
    if (t == List<_i47.VendorOrderLineItem>) {
      return (data as List)
              .map((e) => deserialize<_i47.VendorOrderLineItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i54.WishlistItem>) {
      return (data as List)
              .map((e) => deserialize<_i54.WishlistItem>(e))
              .toList()
          as T;
    }
    if (t == Set<_i56.UserRole>) {
      return (data as List).map((e) => deserialize<_i56.UserRole>(e)).toSet()
          as T;
    }
    if (t == List<_i57.UserOrderSummary>) {
      return (data as List)
              .map((e) => deserialize<_i57.UserOrderSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i58.UserArSessionSummary>) {
      return (data as List)
              .map((e) => deserialize<_i58.UserArSessionSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i59.Complaint>) {
      return (data as List).map((e) => deserialize<_i59.Complaint>(e)).toList()
          as T;
    }
    if (t == List<_i60.PlatformUserSummary>) {
      return (data as List)
              .map((e) => deserialize<_i60.PlatformUserSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i61.VendorApplicationSummary>) {
      return (data as List)
              .map((e) => deserialize<_i61.VendorApplicationSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i62.AdminAuditLogSummary>) {
      return (data as List)
              .map((e) => deserialize<_i62.AdminAuditLogSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i63.ARSession>) {
      return (data as List).map((e) => deserialize<_i63.ARSession>(e)).toList()
          as T;
    }
    if (t == List<_i64.CartItem>) {
      return (data as List).map((e) => deserialize<_i64.CartItem>(e)).toList()
          as T;
    }
    if (t == List<_i65.OrderDeliveryUpdate>) {
      return (data as List)
              .map((e) => deserialize<_i65.OrderDeliveryUpdate>(e))
              .toList()
          as T;
    }
    if (t == List<_i66.Category>) {
      return (data as List).map((e) => deserialize<_i66.Category>(e)).toList()
          as T;
    }
    if (t == List<_i67.ShopListingSummary>) {
      return (data as List)
              .map((e) => deserialize<_i67.ShopListingSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i68.Product>) {
      return (data as List).map((e) => deserialize<_i68.Product>(e)).toList()
          as T;
    }
    if (t == List<_i69.RefundRequestSummary>) {
      return (data as List)
              .map((e) => deserialize<_i69.RefundRequestSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i70.Review>) {
      return (data as List).map((e) => deserialize<_i70.Review>(e)).toList()
          as T;
    }
    if (t == List<_i71.VendorShopOrder>) {
      return (data as List)
              .map((e) => deserialize<_i71.VendorShopOrder>(e))
              .toList()
          as T;
    }
    try {
      return _i72.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i73.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.Admin => 'Admin',
      _i3.AdminAuditLogSummary => 'AdminAuditLogSummary',
      _i4.AdminPlatformStats => 'AdminPlatformStats',
      _i5.AdminType => 'AdminType',
      _i6.ARSession => 'ARSession',
      _i7.Cart => 'Cart',
      _i8.CartItem => 'CartItem',
      _i9.Category => 'Category',
      _i10.CheckoutRequest => 'CheckoutRequest',
      _i11.CheckoutResult => 'CheckoutResult',
      _i12.Complaint => 'Complaint',
      _i13.ComplaintStatus => 'ComplaintStatus',
      _i14.CustomizationRequest => 'CustomizationRequest',
      _i15.DeliveryStage => 'DeliveryStage',
      _i16.Greeting => 'Greeting',
      _i17.NotificationPreference => 'NotificationPreference',
      _i18.Order => 'Order',
      _i19.OrderDeliveryUpdate => 'OrderDeliveryUpdate',
      _i20.OrderItem => 'OrderItem',
      _i21.OrderPage => 'OrderPage',
      _i22.OrderStatus => 'OrderStatus',
      _i23.PaginationInput => 'PaginationInput',
      _i24.PlaceifyException => 'PlaceifyException',
      _i25.PlatformUserSummary => 'PlatformUserSummary',
      _i26.Product => 'Product',
      _i27.ProductPage => 'ProductPage',
      _i28.ProductSearchInput => 'ProductSearchInput',
      _i29.ProductStatus => 'ProductStatus',
      _i30.RefundRequest => 'RefundRequest',
      _i31.RefundRequestSummary => 'RefundRequestSummary',
      _i32.RequestStatus => 'RequestStatus',
      _i33.Review => 'Review',
      _i34.ShopListingSummary => 'ShopListingSummary',
      _i35.User => 'User',
      _i36.UserAccountStatus => 'UserAccountStatus',
      _i37.UserArSessionSummary => 'UserArSessionSummary',
      _i38.UserDashboard => 'UserDashboard',
      _i39.UserOrderSummary => 'UserOrderSummary',
      _i40.UserRole => 'UserRole',
      _i41.Vendor => 'Vendor',
      _i42.VendorApplicationDetail => 'VendorApplicationDetail',
      _i43.VendorApplicationSummary => 'VendorApplicationSummary',
      _i44.VendorDashboard => 'VendorDashboard',
      _i45.VendorDocument => 'VendorDocument',
      _i46.VendorDocumentType => 'VendorDocumentType',
      _i47.VendorOrderLineItem => 'VendorOrderLineItem',
      _i48.VendorOrderSummary => 'VendorOrderSummary',
      _i49.VendorProductStat => 'VendorProductStat',
      _i50.VendorProductUploadInput => 'VendorProductUploadInput',
      _i51.VendorProfileDetail => 'VendorProfileDetail',
      _i52.VendorProfileUpdateInput => 'VendorProfileUpdateInput',
      _i53.VendorShopOrder => 'VendorShopOrder',
      _i54.WishlistItem => 'WishlistItem',
      _i55.WishlistPage => 'WishlistPage',
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
      case _i3.AdminAuditLogSummary():
        return 'AdminAuditLogSummary';
      case _i4.AdminPlatformStats():
        return 'AdminPlatformStats';
      case _i5.AdminType():
        return 'AdminType';
      case _i6.ARSession():
        return 'ARSession';
      case _i7.Cart():
        return 'Cart';
      case _i8.CartItem():
        return 'CartItem';
      case _i9.Category():
        return 'Category';
      case _i10.CheckoutRequest():
        return 'CheckoutRequest';
      case _i11.CheckoutResult():
        return 'CheckoutResult';
      case _i12.Complaint():
        return 'Complaint';
      case _i13.ComplaintStatus():
        return 'ComplaintStatus';
      case _i14.CustomizationRequest():
        return 'CustomizationRequest';
      case _i15.DeliveryStage():
        return 'DeliveryStage';
      case _i16.Greeting():
        return 'Greeting';
      case _i17.NotificationPreference():
        return 'NotificationPreference';
      case _i18.Order():
        return 'Order';
      case _i19.OrderDeliveryUpdate():
        return 'OrderDeliveryUpdate';
      case _i20.OrderItem():
        return 'OrderItem';
      case _i21.OrderPage():
        return 'OrderPage';
      case _i22.OrderStatus():
        return 'OrderStatus';
      case _i23.PaginationInput():
        return 'PaginationInput';
      case _i24.PlaceifyException():
        return 'PlaceifyException';
      case _i25.PlatformUserSummary():
        return 'PlatformUserSummary';
      case _i26.Product():
        return 'Product';
      case _i27.ProductPage():
        return 'ProductPage';
      case _i28.ProductSearchInput():
        return 'ProductSearchInput';
      case _i29.ProductStatus():
        return 'ProductStatus';
      case _i30.RefundRequest():
        return 'RefundRequest';
      case _i31.RefundRequestSummary():
        return 'RefundRequestSummary';
      case _i32.RequestStatus():
        return 'RequestStatus';
      case _i33.Review():
        return 'Review';
      case _i34.ShopListingSummary():
        return 'ShopListingSummary';
      case _i35.User():
        return 'User';
      case _i36.UserAccountStatus():
        return 'UserAccountStatus';
      case _i37.UserArSessionSummary():
        return 'UserArSessionSummary';
      case _i38.UserDashboard():
        return 'UserDashboard';
      case _i39.UserOrderSummary():
        return 'UserOrderSummary';
      case _i40.UserRole():
        return 'UserRole';
      case _i41.Vendor():
        return 'Vendor';
      case _i42.VendorApplicationDetail():
        return 'VendorApplicationDetail';
      case _i43.VendorApplicationSummary():
        return 'VendorApplicationSummary';
      case _i44.VendorDashboard():
        return 'VendorDashboard';
      case _i45.VendorDocument():
        return 'VendorDocument';
      case _i46.VendorDocumentType():
        return 'VendorDocumentType';
      case _i47.VendorOrderLineItem():
        return 'VendorOrderLineItem';
      case _i48.VendorOrderSummary():
        return 'VendorOrderSummary';
      case _i49.VendorProductStat():
        return 'VendorProductStat';
      case _i50.VendorProductUploadInput():
        return 'VendorProductUploadInput';
      case _i51.VendorProfileDetail():
        return 'VendorProfileDetail';
      case _i52.VendorProfileUpdateInput():
        return 'VendorProfileUpdateInput';
      case _i53.VendorShopOrder():
        return 'VendorShopOrder';
      case _i54.WishlistItem():
        return 'WishlistItem';
      case _i55.WishlistPage():
        return 'WishlistPage';
    }
    className = _i72.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    className = _i73.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'AdminAuditLogSummary') {
      return deserialize<_i3.AdminAuditLogSummary>(data['data']);
    }
    if (dataClassName == 'AdminPlatformStats') {
      return deserialize<_i4.AdminPlatformStats>(data['data']);
    }
    if (dataClassName == 'AdminType') {
      return deserialize<_i5.AdminType>(data['data']);
    }
    if (dataClassName == 'ARSession') {
      return deserialize<_i6.ARSession>(data['data']);
    }
    if (dataClassName == 'Cart') {
      return deserialize<_i7.Cart>(data['data']);
    }
    if (dataClassName == 'CartItem') {
      return deserialize<_i8.CartItem>(data['data']);
    }
    if (dataClassName == 'Category') {
      return deserialize<_i9.Category>(data['data']);
    }
    if (dataClassName == 'CheckoutRequest') {
      return deserialize<_i10.CheckoutRequest>(data['data']);
    }
    if (dataClassName == 'CheckoutResult') {
      return deserialize<_i11.CheckoutResult>(data['data']);
    }
    if (dataClassName == 'Complaint') {
      return deserialize<_i12.Complaint>(data['data']);
    }
    if (dataClassName == 'ComplaintStatus') {
      return deserialize<_i13.ComplaintStatus>(data['data']);
    }
    if (dataClassName == 'CustomizationRequest') {
      return deserialize<_i14.CustomizationRequest>(data['data']);
    }
    if (dataClassName == 'DeliveryStage') {
      return deserialize<_i15.DeliveryStage>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i16.Greeting>(data['data']);
    }
    if (dataClassName == 'NotificationPreference') {
      return deserialize<_i17.NotificationPreference>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i18.Order>(data['data']);
    }
    if (dataClassName == 'OrderDeliveryUpdate') {
      return deserialize<_i19.OrderDeliveryUpdate>(data['data']);
    }
    if (dataClassName == 'OrderItem') {
      return deserialize<_i20.OrderItem>(data['data']);
    }
    if (dataClassName == 'OrderPage') {
      return deserialize<_i21.OrderPage>(data['data']);
    }
    if (dataClassName == 'OrderStatus') {
      return deserialize<_i22.OrderStatus>(data['data']);
    }
    if (dataClassName == 'PaginationInput') {
      return deserialize<_i23.PaginationInput>(data['data']);
    }
    if (dataClassName == 'PlaceifyException') {
      return deserialize<_i24.PlaceifyException>(data['data']);
    }
    if (dataClassName == 'PlatformUserSummary') {
      return deserialize<_i25.PlatformUserSummary>(data['data']);
    }
    if (dataClassName == 'Product') {
      return deserialize<_i26.Product>(data['data']);
    }
    if (dataClassName == 'ProductPage') {
      return deserialize<_i27.ProductPage>(data['data']);
    }
    if (dataClassName == 'ProductSearchInput') {
      return deserialize<_i28.ProductSearchInput>(data['data']);
    }
    if (dataClassName == 'ProductStatus') {
      return deserialize<_i29.ProductStatus>(data['data']);
    }
    if (dataClassName == 'RefundRequest') {
      return deserialize<_i30.RefundRequest>(data['data']);
    }
    if (dataClassName == 'RefundRequestSummary') {
      return deserialize<_i31.RefundRequestSummary>(data['data']);
    }
    if (dataClassName == 'RequestStatus') {
      return deserialize<_i32.RequestStatus>(data['data']);
    }
    if (dataClassName == 'Review') {
      return deserialize<_i33.Review>(data['data']);
    }
    if (dataClassName == 'ShopListingSummary') {
      return deserialize<_i34.ShopListingSummary>(data['data']);
    }
    if (dataClassName == 'User') {
      return deserialize<_i35.User>(data['data']);
    }
    if (dataClassName == 'UserAccountStatus') {
      return deserialize<_i36.UserAccountStatus>(data['data']);
    }
    if (dataClassName == 'UserArSessionSummary') {
      return deserialize<_i37.UserArSessionSummary>(data['data']);
    }
    if (dataClassName == 'UserDashboard') {
      return deserialize<_i38.UserDashboard>(data['data']);
    }
    if (dataClassName == 'UserOrderSummary') {
      return deserialize<_i39.UserOrderSummary>(data['data']);
    }
    if (dataClassName == 'UserRole') {
      return deserialize<_i40.UserRole>(data['data']);
    }
    if (dataClassName == 'Vendor') {
      return deserialize<_i41.Vendor>(data['data']);
    }
    if (dataClassName == 'VendorApplicationDetail') {
      return deserialize<_i42.VendorApplicationDetail>(data['data']);
    }
    if (dataClassName == 'VendorApplicationSummary') {
      return deserialize<_i43.VendorApplicationSummary>(data['data']);
    }
    if (dataClassName == 'VendorDashboard') {
      return deserialize<_i44.VendorDashboard>(data['data']);
    }
    if (dataClassName == 'VendorDocument') {
      return deserialize<_i45.VendorDocument>(data['data']);
    }
    if (dataClassName == 'VendorDocumentType') {
      return deserialize<_i46.VendorDocumentType>(data['data']);
    }
    if (dataClassName == 'VendorOrderLineItem') {
      return deserialize<_i47.VendorOrderLineItem>(data['data']);
    }
    if (dataClassName == 'VendorOrderSummary') {
      return deserialize<_i48.VendorOrderSummary>(data['data']);
    }
    if (dataClassName == 'VendorProductStat') {
      return deserialize<_i49.VendorProductStat>(data['data']);
    }
    if (dataClassName == 'VendorProductUploadInput') {
      return deserialize<_i50.VendorProductUploadInput>(data['data']);
    }
    if (dataClassName == 'VendorProfileDetail') {
      return deserialize<_i51.VendorProfileDetail>(data['data']);
    }
    if (dataClassName == 'VendorProfileUpdateInput') {
      return deserialize<_i52.VendorProfileUpdateInput>(data['data']);
    }
    if (dataClassName == 'VendorShopOrder') {
      return deserialize<_i53.VendorShopOrder>(data['data']);
    }
    if (dataClassName == 'WishlistItem') {
      return deserialize<_i54.WishlistItem>(data['data']);
    }
    if (dataClassName == 'WishlistPage') {
      return deserialize<_i55.WishlistPage>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i72.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i73.Protocol().deserializeByClassName(data);
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
      return _i72.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i73.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
