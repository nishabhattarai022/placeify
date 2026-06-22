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
import 'admin_refund_request_summary.dart' as _i5;
import 'admin_type.dart' as _i6;
import 'admin_vendor_payout_summary.dart' as _i7;
import 'ar_session.dart' as _i8;
import 'cart.dart' as _i9;
import 'cart_item.dart' as _i10;
import 'category.dart' as _i11;
import 'checkout_request.dart' as _i12;
import 'checkout_result.dart' as _i13;
import 'complaint.dart' as _i14;
import 'complaint_status.dart' as _i15;
import 'customization_request.dart' as _i16;
import 'delivery_stage.dart' as _i17;
import 'greetings/greeting.dart' as _i18;
import 'notification_preference.dart' as _i19;
import 'order.dart' as _i20;
import 'order_delivery_update.dart' as _i21;
import 'order_item.dart' as _i22;
import 'order_page.dart' as _i23;
import 'order_status.dart' as _i24;
import 'order_vendor_payment.dart' as _i25;
import 'pagination_input.dart' as _i26;
import 'payment_method.dart' as _i27;
import 'payment_transaction.dart' as _i28;
import 'payment_transaction_status.dart' as _i29;
import 'payment_update_summary.dart' as _i30;
import 'placeify_exception.dart' as _i31;
import 'platform_user_summary.dart' as _i32;
import 'product.dart' as _i33;
import 'product_page.dart' as _i34;
import 'product_search_input.dart' as _i35;
import 'product_status.dart' as _i36;
import 'refund_request.dart' as _i37;
import 'refund_request_summary.dart' as _i38;
import 'request_status.dart' as _i39;
import 'review.dart' as _i40;
import 'shop_listing_summary.dart' as _i41;
import 'user.dart' as _i42;
import 'user_account_status.dart' as _i43;
import 'user_ar_session_summary.dart' as _i44;
import 'user_dashboard.dart' as _i45;
import 'user_order_delivery_event.dart' as _i46;
import 'user_order_detail.dart' as _i47;
import 'user_order_line_item.dart' as _i48;
import 'user_order_payment_summary.dart' as _i49;
import 'user_order_summary.dart' as _i50;
import 'user_role.dart' as _i51;
import 'vendor.dart' as _i52;
import 'vendor_application_detail.dart' as _i53;
import 'vendor_application_summary.dart' as _i54;
import 'vendor_dashboard.dart' as _i55;
import 'vendor_document.dart' as _i56;
import 'vendor_document_type.dart' as _i57;
import 'vendor_order_line_item.dart' as _i58;
import 'vendor_order_summary.dart' as _i59;
import 'vendor_payments_overview.dart' as _i60;
import 'vendor_payout.dart' as _i61;
import 'vendor_payout_status.dart' as _i62;
import 'vendor_payout_summary.dart' as _i63;
import 'vendor_product_stat.dart' as _i64;
import 'vendor_product_upload_input.dart' as _i65;
import 'vendor_profile_detail.dart' as _i66;
import 'vendor_profile_update_input.dart' as _i67;
import 'vendor_shop_order.dart' as _i68;
import 'wishlist_item.dart' as _i69;
import 'wishlist_page.dart' as _i70;
import 'package:placeify_client/src/protocol/user_role.dart' as _i71;
import 'package:placeify_client/src/protocol/user_order_summary.dart' as _i72;
import 'package:placeify_client/src/protocol/user_ar_session_summary.dart'
    as _i73;
import 'package:placeify_client/src/protocol/complaint.dart' as _i74;
import 'package:placeify_client/src/protocol/platform_user_summary.dart'
    as _i75;
import 'package:placeify_client/src/protocol/vendor_application_summary.dart'
    as _i76;
import 'package:placeify_client/src/protocol/admin_audit_log_summary.dart'
    as _i77;
import 'package:placeify_client/src/protocol/admin_vendor_payout_summary.dart'
    as _i78;
import 'package:placeify_client/src/protocol/admin_refund_request_summary.dart'
    as _i79;
import 'package:placeify_client/src/protocol/ar_session.dart' as _i80;
import 'package:placeify_client/src/protocol/cart_item.dart' as _i81;
import 'package:placeify_client/src/protocol/order_delivery_update.dart'
    as _i82;
import 'package:placeify_client/src/protocol/payment_update_summary.dart'
    as _i83;
import 'package:placeify_client/src/protocol/category.dart' as _i84;
import 'package:placeify_client/src/protocol/shop_listing_summary.dart' as _i85;
import 'package:placeify_client/src/protocol/product.dart' as _i86;
import 'package:placeify_client/src/protocol/refund_request_summary.dart'
    as _i87;
import 'package:placeify_client/src/protocol/review.dart' as _i88;
import 'package:placeify_client/src/protocol/vendor_shop_order.dart' as _i89;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i90;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i91;
export 'admin.dart';
export 'admin_audit_log_summary.dart';
export 'admin_platform_stats.dart';
export 'admin_refund_request_summary.dart';
export 'admin_type.dart';
export 'admin_vendor_payout_summary.dart';
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
export 'order_vendor_payment.dart';
export 'pagination_input.dart';
export 'payment_method.dart';
export 'payment_transaction.dart';
export 'payment_transaction_status.dart';
export 'payment_update_summary.dart';
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
export 'user_order_delivery_event.dart';
export 'user_order_detail.dart';
export 'user_order_line_item.dart';
export 'user_order_payment_summary.dart';
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
export 'vendor_payments_overview.dart';
export 'vendor_payout.dart';
export 'vendor_payout_status.dart';
export 'vendor_payout_summary.dart';
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
    if (t == _i5.AdminRefundRequestSummary) {
      return _i5.AdminRefundRequestSummary.fromJson(data) as T;
    }
    if (t == _i6.AdminType) {
      return _i6.AdminType.fromJson(data) as T;
    }
    if (t == _i7.AdminVendorPayoutSummary) {
      return _i7.AdminVendorPayoutSummary.fromJson(data) as T;
    }
    if (t == _i8.ARSession) {
      return _i8.ARSession.fromJson(data) as T;
    }
    if (t == _i9.Cart) {
      return _i9.Cart.fromJson(data) as T;
    }
    if (t == _i10.CartItem) {
      return _i10.CartItem.fromJson(data) as T;
    }
    if (t == _i11.Category) {
      return _i11.Category.fromJson(data) as T;
    }
    if (t == _i12.CheckoutRequest) {
      return _i12.CheckoutRequest.fromJson(data) as T;
    }
    if (t == _i13.CheckoutResult) {
      return _i13.CheckoutResult.fromJson(data) as T;
    }
    if (t == _i14.Complaint) {
      return _i14.Complaint.fromJson(data) as T;
    }
    if (t == _i15.ComplaintStatus) {
      return _i15.ComplaintStatus.fromJson(data) as T;
    }
    if (t == _i16.CustomizationRequest) {
      return _i16.CustomizationRequest.fromJson(data) as T;
    }
    if (t == _i17.DeliveryStage) {
      return _i17.DeliveryStage.fromJson(data) as T;
    }
    if (t == _i18.Greeting) {
      return _i18.Greeting.fromJson(data) as T;
    }
    if (t == _i19.NotificationPreference) {
      return _i19.NotificationPreference.fromJson(data) as T;
    }
    if (t == _i20.Order) {
      return _i20.Order.fromJson(data) as T;
    }
    if (t == _i21.OrderDeliveryUpdate) {
      return _i21.OrderDeliveryUpdate.fromJson(data) as T;
    }
    if (t == _i22.OrderItem) {
      return _i22.OrderItem.fromJson(data) as T;
    }
    if (t == _i23.OrderPage) {
      return _i23.OrderPage.fromJson(data) as T;
    }
    if (t == _i24.OrderStatus) {
      return _i24.OrderStatus.fromJson(data) as T;
    }
    if (t == _i25.OrderVendorPayment) {
      return _i25.OrderVendorPayment.fromJson(data) as T;
    }
    if (t == _i26.PaginationInput) {
      return _i26.PaginationInput.fromJson(data) as T;
    }
    if (t == _i27.PaymentMethod) {
      return _i27.PaymentMethod.fromJson(data) as T;
    }
    if (t == _i28.PaymentTransaction) {
      return _i28.PaymentTransaction.fromJson(data) as T;
    }
    if (t == _i29.PaymentTransactionStatus) {
      return _i29.PaymentTransactionStatus.fromJson(data) as T;
    }
    if (t == _i30.PaymentUpdateSummary) {
      return _i30.PaymentUpdateSummary.fromJson(data) as T;
    }
    if (t == _i31.PlaceifyException) {
      return _i31.PlaceifyException.fromJson(data) as T;
    }
    if (t == _i32.PlatformUserSummary) {
      return _i32.PlatformUserSummary.fromJson(data) as T;
    }
    if (t == _i33.Product) {
      return _i33.Product.fromJson(data) as T;
    }
    if (t == _i34.ProductPage) {
      return _i34.ProductPage.fromJson(data) as T;
    }
    if (t == _i35.ProductSearchInput) {
      return _i35.ProductSearchInput.fromJson(data) as T;
    }
    if (t == _i36.ProductStatus) {
      return _i36.ProductStatus.fromJson(data) as T;
    }
    if (t == _i37.RefundRequest) {
      return _i37.RefundRequest.fromJson(data) as T;
    }
    if (t == _i38.RefundRequestSummary) {
      return _i38.RefundRequestSummary.fromJson(data) as T;
    }
    if (t == _i39.RequestStatus) {
      return _i39.RequestStatus.fromJson(data) as T;
    }
    if (t == _i40.Review) {
      return _i40.Review.fromJson(data) as T;
    }
    if (t == _i41.ShopListingSummary) {
      return _i41.ShopListingSummary.fromJson(data) as T;
    }
    if (t == _i42.User) {
      return _i42.User.fromJson(data) as T;
    }
    if (t == _i43.UserAccountStatus) {
      return _i43.UserAccountStatus.fromJson(data) as T;
    }
    if (t == _i44.UserArSessionSummary) {
      return _i44.UserArSessionSummary.fromJson(data) as T;
    }
    if (t == _i45.UserDashboard) {
      return _i45.UserDashboard.fromJson(data) as T;
    }
    if (t == _i46.UserOrderDeliveryEvent) {
      return _i46.UserOrderDeliveryEvent.fromJson(data) as T;
    }
    if (t == _i47.UserOrderDetail) {
      return _i47.UserOrderDetail.fromJson(data) as T;
    }
    if (t == _i48.UserOrderLineItem) {
      return _i48.UserOrderLineItem.fromJson(data) as T;
    }
    if (t == _i49.UserOrderPaymentSummary) {
      return _i49.UserOrderPaymentSummary.fromJson(data) as T;
    }
    if (t == _i50.UserOrderSummary) {
      return _i50.UserOrderSummary.fromJson(data) as T;
    }
    if (t == _i51.UserRole) {
      return _i51.UserRole.fromJson(data) as T;
    }
    if (t == _i52.Vendor) {
      return _i52.Vendor.fromJson(data) as T;
    }
    if (t == _i53.VendorApplicationDetail) {
      return _i53.VendorApplicationDetail.fromJson(data) as T;
    }
    if (t == _i54.VendorApplicationSummary) {
      return _i54.VendorApplicationSummary.fromJson(data) as T;
    }
    if (t == _i55.VendorDashboard) {
      return _i55.VendorDashboard.fromJson(data) as T;
    }
    if (t == _i56.VendorDocument) {
      return _i56.VendorDocument.fromJson(data) as T;
    }
    if (t == _i57.VendorDocumentType) {
      return _i57.VendorDocumentType.fromJson(data) as T;
    }
    if (t == _i58.VendorOrderLineItem) {
      return _i58.VendorOrderLineItem.fromJson(data) as T;
    }
    if (t == _i59.VendorOrderSummary) {
      return _i59.VendorOrderSummary.fromJson(data) as T;
    }
    if (t == _i60.VendorPaymentsOverview) {
      return _i60.VendorPaymentsOverview.fromJson(data) as T;
    }
    if (t == _i61.VendorPayout) {
      return _i61.VendorPayout.fromJson(data) as T;
    }
    if (t == _i62.VendorPayoutStatus) {
      return _i62.VendorPayoutStatus.fromJson(data) as T;
    }
    if (t == _i63.VendorPayoutSummary) {
      return _i63.VendorPayoutSummary.fromJson(data) as T;
    }
    if (t == _i64.VendorProductStat) {
      return _i64.VendorProductStat.fromJson(data) as T;
    }
    if (t == _i65.VendorProductUploadInput) {
      return _i65.VendorProductUploadInput.fromJson(data) as T;
    }
    if (t == _i66.VendorProfileDetail) {
      return _i66.VendorProfileDetail.fromJson(data) as T;
    }
    if (t == _i67.VendorProfileUpdateInput) {
      return _i67.VendorProfileUpdateInput.fromJson(data) as T;
    }
    if (t == _i68.VendorShopOrder) {
      return _i68.VendorShopOrder.fromJson(data) as T;
    }
    if (t == _i69.WishlistItem) {
      return _i69.WishlistItem.fromJson(data) as T;
    }
    if (t == _i70.WishlistPage) {
      return _i70.WishlistPage.fromJson(data) as T;
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
    if (t == _i1.getType<_i5.AdminRefundRequestSummary?>()) {
      return (data != null
              ? _i5.AdminRefundRequestSummary.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i6.AdminType?>()) {
      return (data != null ? _i6.AdminType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.AdminVendorPayoutSummary?>()) {
      return (data != null ? _i7.AdminVendorPayoutSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i8.ARSession?>()) {
      return (data != null ? _i8.ARSession.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.Cart?>()) {
      return (data != null ? _i9.Cart.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.CartItem?>()) {
      return (data != null ? _i10.CartItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.Category?>()) {
      return (data != null ? _i11.Category.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.CheckoutRequest?>()) {
      return (data != null ? _i12.CheckoutRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.CheckoutResult?>()) {
      return (data != null ? _i13.CheckoutResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.Complaint?>()) {
      return (data != null ? _i14.Complaint.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.ComplaintStatus?>()) {
      return (data != null ? _i15.ComplaintStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.CustomizationRequest?>()) {
      return (data != null ? _i16.CustomizationRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i17.DeliveryStage?>()) {
      return (data != null ? _i17.DeliveryStage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.Greeting?>()) {
      return (data != null ? _i18.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.NotificationPreference?>()) {
      return (data != null ? _i19.NotificationPreference.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i20.Order?>()) {
      return (data != null ? _i20.Order.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.OrderDeliveryUpdate?>()) {
      return (data != null ? _i21.OrderDeliveryUpdate.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i22.OrderItem?>()) {
      return (data != null ? _i22.OrderItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.OrderPage?>()) {
      return (data != null ? _i23.OrderPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.OrderStatus?>()) {
      return (data != null ? _i24.OrderStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.OrderVendorPayment?>()) {
      return (data != null ? _i25.OrderVendorPayment.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i26.PaginationInput?>()) {
      return (data != null ? _i26.PaginationInput.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.PaymentMethod?>()) {
      return (data != null ? _i27.PaymentMethod.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.PaymentTransaction?>()) {
      return (data != null ? _i28.PaymentTransaction.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i29.PaymentTransactionStatus?>()) {
      return (data != null
              ? _i29.PaymentTransactionStatus.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i30.PaymentUpdateSummary?>()) {
      return (data != null ? _i30.PaymentUpdateSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i31.PlaceifyException?>()) {
      return (data != null ? _i31.PlaceifyException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.PlatformUserSummary?>()) {
      return (data != null ? _i32.PlatformUserSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i33.Product?>()) {
      return (data != null ? _i33.Product.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.ProductPage?>()) {
      return (data != null ? _i34.ProductPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.ProductSearchInput?>()) {
      return (data != null ? _i35.ProductSearchInput.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i36.ProductStatus?>()) {
      return (data != null ? _i36.ProductStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i37.RefundRequest?>()) {
      return (data != null ? _i37.RefundRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i38.RefundRequestSummary?>()) {
      return (data != null ? _i38.RefundRequestSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i39.RequestStatus?>()) {
      return (data != null ? _i39.RequestStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.Review?>()) {
      return (data != null ? _i40.Review.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i41.ShopListingSummary?>()) {
      return (data != null ? _i41.ShopListingSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i42.User?>()) {
      return (data != null ? _i42.User.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i43.UserAccountStatus?>()) {
      return (data != null ? _i43.UserAccountStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i44.UserArSessionSummary?>()) {
      return (data != null ? _i44.UserArSessionSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i45.UserDashboard?>()) {
      return (data != null ? _i45.UserDashboard.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i46.UserOrderDeliveryEvent?>()) {
      return (data != null ? _i46.UserOrderDeliveryEvent.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i47.UserOrderDetail?>()) {
      return (data != null ? _i47.UserOrderDetail.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i48.UserOrderLineItem?>()) {
      return (data != null ? _i48.UserOrderLineItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i49.UserOrderPaymentSummary?>()) {
      return (data != null ? _i49.UserOrderPaymentSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i50.UserOrderSummary?>()) {
      return (data != null ? _i50.UserOrderSummary.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i51.UserRole?>()) {
      return (data != null ? _i51.UserRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i52.Vendor?>()) {
      return (data != null ? _i52.Vendor.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i53.VendorApplicationDetail?>()) {
      return (data != null ? _i53.VendorApplicationDetail.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i54.VendorApplicationSummary?>()) {
      return (data != null
              ? _i54.VendorApplicationSummary.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i55.VendorDashboard?>()) {
      return (data != null ? _i55.VendorDashboard.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i56.VendorDocument?>()) {
      return (data != null ? _i56.VendorDocument.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i57.VendorDocumentType?>()) {
      return (data != null ? _i57.VendorDocumentType.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i58.VendorOrderLineItem?>()) {
      return (data != null ? _i58.VendorOrderLineItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i59.VendorOrderSummary?>()) {
      return (data != null ? _i59.VendorOrderSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i60.VendorPaymentsOverview?>()) {
      return (data != null ? _i60.VendorPaymentsOverview.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i61.VendorPayout?>()) {
      return (data != null ? _i61.VendorPayout.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i62.VendorPayoutStatus?>()) {
      return (data != null ? _i62.VendorPayoutStatus.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i63.VendorPayoutSummary?>()) {
      return (data != null ? _i63.VendorPayoutSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i64.VendorProductStat?>()) {
      return (data != null ? _i64.VendorProductStat.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i65.VendorProductUploadInput?>()) {
      return (data != null
              ? _i65.VendorProductUploadInput.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i66.VendorProfileDetail?>()) {
      return (data != null ? _i66.VendorProfileDetail.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i67.VendorProfileUpdateInput?>()) {
      return (data != null
              ? _i67.VendorProfileUpdateInput.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i68.VendorShopOrder?>()) {
      return (data != null ? _i68.VendorShopOrder.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i69.WishlistItem?>()) {
      return (data != null ? _i69.WishlistItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i70.WishlistPage?>()) {
      return (data != null ? _i70.WishlistPage.fromJson(data) : null) as T;
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
    if (t == List<_i54.VendorApplicationSummary>) {
      return (data as List)
              .map((e) => deserialize<_i54.VendorApplicationSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i20.Order>) {
      return (data as List).map((e) => deserialize<_i20.Order>(e)).toList()
          as T;
    }
    if (t == List<_i33.Product>) {
      return (data as List).map((e) => deserialize<_i33.Product>(e)).toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i48.UserOrderLineItem>) {
      return (data as List)
              .map((e) => deserialize<_i48.UserOrderLineItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i46.UserOrderDeliveryEvent>) {
      return (data as List)
              .map((e) => deserialize<_i46.UserOrderDeliveryEvent>(e))
              .toList()
          as T;
    }
    if (t == List<_i59.VendorOrderSummary>) {
      return (data as List)
              .map((e) => deserialize<_i59.VendorOrderSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i64.VendorProductStat>) {
      return (data as List)
              .map((e) => deserialize<_i64.VendorProductStat>(e))
              .toList()
          as T;
    }
    if (t == List<_i63.VendorPayoutSummary>) {
      return (data as List)
              .map((e) => deserialize<_i63.VendorPayoutSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i58.VendorOrderLineItem>) {
      return (data as List)
              .map((e) => deserialize<_i58.VendorOrderLineItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i69.WishlistItem>) {
      return (data as List)
              .map((e) => deserialize<_i69.WishlistItem>(e))
              .toList()
          as T;
    }
    if (t == Set<_i71.UserRole>) {
      return (data as List).map((e) => deserialize<_i71.UserRole>(e)).toSet()
          as T;
    }
    if (t == List<_i72.UserOrderSummary>) {
      return (data as List)
              .map((e) => deserialize<_i72.UserOrderSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i73.UserArSessionSummary>) {
      return (data as List)
              .map((e) => deserialize<_i73.UserArSessionSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i74.Complaint>) {
      return (data as List).map((e) => deserialize<_i74.Complaint>(e)).toList()
          as T;
    }
    if (t == List<_i75.PlatformUserSummary>) {
      return (data as List)
              .map((e) => deserialize<_i75.PlatformUserSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i76.VendorApplicationSummary>) {
      return (data as List)
              .map((e) => deserialize<_i76.VendorApplicationSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i77.AdminAuditLogSummary>) {
      return (data as List)
              .map((e) => deserialize<_i77.AdminAuditLogSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i78.AdminVendorPayoutSummary>) {
      return (data as List)
              .map((e) => deserialize<_i78.AdminVendorPayoutSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i79.AdminRefundRequestSummary>) {
      return (data as List)
              .map((e) => deserialize<_i79.AdminRefundRequestSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i80.ARSession>) {
      return (data as List).map((e) => deserialize<_i80.ARSession>(e)).toList()
          as T;
    }
    if (t == List<_i81.CartItem>) {
      return (data as List).map((e) => deserialize<_i81.CartItem>(e)).toList()
          as T;
    }
    if (t == List<_i82.OrderDeliveryUpdate>) {
      return (data as List)
              .map((e) => deserialize<_i82.OrderDeliveryUpdate>(e))
              .toList()
          as T;
    }
    if (t == List<_i83.PaymentUpdateSummary>) {
      return (data as List)
              .map((e) => deserialize<_i83.PaymentUpdateSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i84.Category>) {
      return (data as List).map((e) => deserialize<_i84.Category>(e)).toList()
          as T;
    }
    if (t == List<_i85.ShopListingSummary>) {
      return (data as List)
              .map((e) => deserialize<_i85.ShopListingSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i86.Product>) {
      return (data as List).map((e) => deserialize<_i86.Product>(e)).toList()
          as T;
    }
    if (t == List<_i87.RefundRequestSummary>) {
      return (data as List)
              .map((e) => deserialize<_i87.RefundRequestSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i88.Review>) {
      return (data as List).map((e) => deserialize<_i88.Review>(e)).toList()
          as T;
    }
    if (t == List<_i89.VendorShopOrder>) {
      return (data as List)
              .map((e) => deserialize<_i89.VendorShopOrder>(e))
              .toList()
          as T;
    }
    try {
      return _i90.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i91.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.Admin => 'Admin',
      _i3.AdminAuditLogSummary => 'AdminAuditLogSummary',
      _i4.AdminPlatformStats => 'AdminPlatformStats',
      _i5.AdminRefundRequestSummary => 'AdminRefundRequestSummary',
      _i6.AdminType => 'AdminType',
      _i7.AdminVendorPayoutSummary => 'AdminVendorPayoutSummary',
      _i8.ARSession => 'ARSession',
      _i9.Cart => 'Cart',
      _i10.CartItem => 'CartItem',
      _i11.Category => 'Category',
      _i12.CheckoutRequest => 'CheckoutRequest',
      _i13.CheckoutResult => 'CheckoutResult',
      _i14.Complaint => 'Complaint',
      _i15.ComplaintStatus => 'ComplaintStatus',
      _i16.CustomizationRequest => 'CustomizationRequest',
      _i17.DeliveryStage => 'DeliveryStage',
      _i18.Greeting => 'Greeting',
      _i19.NotificationPreference => 'NotificationPreference',
      _i20.Order => 'Order',
      _i21.OrderDeliveryUpdate => 'OrderDeliveryUpdate',
      _i22.OrderItem => 'OrderItem',
      _i23.OrderPage => 'OrderPage',
      _i24.OrderStatus => 'OrderStatus',
      _i25.OrderVendorPayment => 'OrderVendorPayment',
      _i26.PaginationInput => 'PaginationInput',
      _i27.PaymentMethod => 'PaymentMethod',
      _i28.PaymentTransaction => 'PaymentTransaction',
      _i29.PaymentTransactionStatus => 'PaymentTransactionStatus',
      _i30.PaymentUpdateSummary => 'PaymentUpdateSummary',
      _i31.PlaceifyException => 'PlaceifyException',
      _i32.PlatformUserSummary => 'PlatformUserSummary',
      _i33.Product => 'Product',
      _i34.ProductPage => 'ProductPage',
      _i35.ProductSearchInput => 'ProductSearchInput',
      _i36.ProductStatus => 'ProductStatus',
      _i37.RefundRequest => 'RefundRequest',
      _i38.RefundRequestSummary => 'RefundRequestSummary',
      _i39.RequestStatus => 'RequestStatus',
      _i40.Review => 'Review',
      _i41.ShopListingSummary => 'ShopListingSummary',
      _i42.User => 'User',
      _i43.UserAccountStatus => 'UserAccountStatus',
      _i44.UserArSessionSummary => 'UserArSessionSummary',
      _i45.UserDashboard => 'UserDashboard',
      _i46.UserOrderDeliveryEvent => 'UserOrderDeliveryEvent',
      _i47.UserOrderDetail => 'UserOrderDetail',
      _i48.UserOrderLineItem => 'UserOrderLineItem',
      _i49.UserOrderPaymentSummary => 'UserOrderPaymentSummary',
      _i50.UserOrderSummary => 'UserOrderSummary',
      _i51.UserRole => 'UserRole',
      _i52.Vendor => 'Vendor',
      _i53.VendorApplicationDetail => 'VendorApplicationDetail',
      _i54.VendorApplicationSummary => 'VendorApplicationSummary',
      _i55.VendorDashboard => 'VendorDashboard',
      _i56.VendorDocument => 'VendorDocument',
      _i57.VendorDocumentType => 'VendorDocumentType',
      _i58.VendorOrderLineItem => 'VendorOrderLineItem',
      _i59.VendorOrderSummary => 'VendorOrderSummary',
      _i60.VendorPaymentsOverview => 'VendorPaymentsOverview',
      _i61.VendorPayout => 'VendorPayout',
      _i62.VendorPayoutStatus => 'VendorPayoutStatus',
      _i63.VendorPayoutSummary => 'VendorPayoutSummary',
      _i64.VendorProductStat => 'VendorProductStat',
      _i65.VendorProductUploadInput => 'VendorProductUploadInput',
      _i66.VendorProfileDetail => 'VendorProfileDetail',
      _i67.VendorProfileUpdateInput => 'VendorProfileUpdateInput',
      _i68.VendorShopOrder => 'VendorShopOrder',
      _i69.WishlistItem => 'WishlistItem',
      _i70.WishlistPage => 'WishlistPage',
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
      case _i5.AdminRefundRequestSummary():
        return 'AdminRefundRequestSummary';
      case _i6.AdminType():
        return 'AdminType';
      case _i7.AdminVendorPayoutSummary():
        return 'AdminVendorPayoutSummary';
      case _i8.ARSession():
        return 'ARSession';
      case _i9.Cart():
        return 'Cart';
      case _i10.CartItem():
        return 'CartItem';
      case _i11.Category():
        return 'Category';
      case _i12.CheckoutRequest():
        return 'CheckoutRequest';
      case _i13.CheckoutResult():
        return 'CheckoutResult';
      case _i14.Complaint():
        return 'Complaint';
      case _i15.ComplaintStatus():
        return 'ComplaintStatus';
      case _i16.CustomizationRequest():
        return 'CustomizationRequest';
      case _i17.DeliveryStage():
        return 'DeliveryStage';
      case _i18.Greeting():
        return 'Greeting';
      case _i19.NotificationPreference():
        return 'NotificationPreference';
      case _i20.Order():
        return 'Order';
      case _i21.OrderDeliveryUpdate():
        return 'OrderDeliveryUpdate';
      case _i22.OrderItem():
        return 'OrderItem';
      case _i23.OrderPage():
        return 'OrderPage';
      case _i24.OrderStatus():
        return 'OrderStatus';
      case _i25.OrderVendorPayment():
        return 'OrderVendorPayment';
      case _i26.PaginationInput():
        return 'PaginationInput';
      case _i27.PaymentMethod():
        return 'PaymentMethod';
      case _i28.PaymentTransaction():
        return 'PaymentTransaction';
      case _i29.PaymentTransactionStatus():
        return 'PaymentTransactionStatus';
      case _i30.PaymentUpdateSummary():
        return 'PaymentUpdateSummary';
      case _i31.PlaceifyException():
        return 'PlaceifyException';
      case _i32.PlatformUserSummary():
        return 'PlatformUserSummary';
      case _i33.Product():
        return 'Product';
      case _i34.ProductPage():
        return 'ProductPage';
      case _i35.ProductSearchInput():
        return 'ProductSearchInput';
      case _i36.ProductStatus():
        return 'ProductStatus';
      case _i37.RefundRequest():
        return 'RefundRequest';
      case _i38.RefundRequestSummary():
        return 'RefundRequestSummary';
      case _i39.RequestStatus():
        return 'RequestStatus';
      case _i40.Review():
        return 'Review';
      case _i41.ShopListingSummary():
        return 'ShopListingSummary';
      case _i42.User():
        return 'User';
      case _i43.UserAccountStatus():
        return 'UserAccountStatus';
      case _i44.UserArSessionSummary():
        return 'UserArSessionSummary';
      case _i45.UserDashboard():
        return 'UserDashboard';
      case _i46.UserOrderDeliveryEvent():
        return 'UserOrderDeliveryEvent';
      case _i47.UserOrderDetail():
        return 'UserOrderDetail';
      case _i48.UserOrderLineItem():
        return 'UserOrderLineItem';
      case _i49.UserOrderPaymentSummary():
        return 'UserOrderPaymentSummary';
      case _i50.UserOrderSummary():
        return 'UserOrderSummary';
      case _i51.UserRole():
        return 'UserRole';
      case _i52.Vendor():
        return 'Vendor';
      case _i53.VendorApplicationDetail():
        return 'VendorApplicationDetail';
      case _i54.VendorApplicationSummary():
        return 'VendorApplicationSummary';
      case _i55.VendorDashboard():
        return 'VendorDashboard';
      case _i56.VendorDocument():
        return 'VendorDocument';
      case _i57.VendorDocumentType():
        return 'VendorDocumentType';
      case _i58.VendorOrderLineItem():
        return 'VendorOrderLineItem';
      case _i59.VendorOrderSummary():
        return 'VendorOrderSummary';
      case _i60.VendorPaymentsOverview():
        return 'VendorPaymentsOverview';
      case _i61.VendorPayout():
        return 'VendorPayout';
      case _i62.VendorPayoutStatus():
        return 'VendorPayoutStatus';
      case _i63.VendorPayoutSummary():
        return 'VendorPayoutSummary';
      case _i64.VendorProductStat():
        return 'VendorProductStat';
      case _i65.VendorProductUploadInput():
        return 'VendorProductUploadInput';
      case _i66.VendorProfileDetail():
        return 'VendorProfileDetail';
      case _i67.VendorProfileUpdateInput():
        return 'VendorProfileUpdateInput';
      case _i68.VendorShopOrder():
        return 'VendorShopOrder';
      case _i69.WishlistItem():
        return 'WishlistItem';
      case _i70.WishlistPage():
        return 'WishlistPage';
    }
    className = _i90.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    className = _i91.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'AdminRefundRequestSummary') {
      return deserialize<_i5.AdminRefundRequestSummary>(data['data']);
    }
    if (dataClassName == 'AdminType') {
      return deserialize<_i6.AdminType>(data['data']);
    }
    if (dataClassName == 'AdminVendorPayoutSummary') {
      return deserialize<_i7.AdminVendorPayoutSummary>(data['data']);
    }
    if (dataClassName == 'ARSession') {
      return deserialize<_i8.ARSession>(data['data']);
    }
    if (dataClassName == 'Cart') {
      return deserialize<_i9.Cart>(data['data']);
    }
    if (dataClassName == 'CartItem') {
      return deserialize<_i10.CartItem>(data['data']);
    }
    if (dataClassName == 'Category') {
      return deserialize<_i11.Category>(data['data']);
    }
    if (dataClassName == 'CheckoutRequest') {
      return deserialize<_i12.CheckoutRequest>(data['data']);
    }
    if (dataClassName == 'CheckoutResult') {
      return deserialize<_i13.CheckoutResult>(data['data']);
    }
    if (dataClassName == 'Complaint') {
      return deserialize<_i14.Complaint>(data['data']);
    }
    if (dataClassName == 'ComplaintStatus') {
      return deserialize<_i15.ComplaintStatus>(data['data']);
    }
    if (dataClassName == 'CustomizationRequest') {
      return deserialize<_i16.CustomizationRequest>(data['data']);
    }
    if (dataClassName == 'DeliveryStage') {
      return deserialize<_i17.DeliveryStage>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i18.Greeting>(data['data']);
    }
    if (dataClassName == 'NotificationPreference') {
      return deserialize<_i19.NotificationPreference>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i20.Order>(data['data']);
    }
    if (dataClassName == 'OrderDeliveryUpdate') {
      return deserialize<_i21.OrderDeliveryUpdate>(data['data']);
    }
    if (dataClassName == 'OrderItem') {
      return deserialize<_i22.OrderItem>(data['data']);
    }
    if (dataClassName == 'OrderPage') {
      return deserialize<_i23.OrderPage>(data['data']);
    }
    if (dataClassName == 'OrderStatus') {
      return deserialize<_i24.OrderStatus>(data['data']);
    }
    if (dataClassName == 'OrderVendorPayment') {
      return deserialize<_i25.OrderVendorPayment>(data['data']);
    }
    if (dataClassName == 'PaginationInput') {
      return deserialize<_i26.PaginationInput>(data['data']);
    }
    if (dataClassName == 'PaymentMethod') {
      return deserialize<_i27.PaymentMethod>(data['data']);
    }
    if (dataClassName == 'PaymentTransaction') {
      return deserialize<_i28.PaymentTransaction>(data['data']);
    }
    if (dataClassName == 'PaymentTransactionStatus') {
      return deserialize<_i29.PaymentTransactionStatus>(data['data']);
    }
    if (dataClassName == 'PaymentUpdateSummary') {
      return deserialize<_i30.PaymentUpdateSummary>(data['data']);
    }
    if (dataClassName == 'PlaceifyException') {
      return deserialize<_i31.PlaceifyException>(data['data']);
    }
    if (dataClassName == 'PlatformUserSummary') {
      return deserialize<_i32.PlatformUserSummary>(data['data']);
    }
    if (dataClassName == 'Product') {
      return deserialize<_i33.Product>(data['data']);
    }
    if (dataClassName == 'ProductPage') {
      return deserialize<_i34.ProductPage>(data['data']);
    }
    if (dataClassName == 'ProductSearchInput') {
      return deserialize<_i35.ProductSearchInput>(data['data']);
    }
    if (dataClassName == 'ProductStatus') {
      return deserialize<_i36.ProductStatus>(data['data']);
    }
    if (dataClassName == 'RefundRequest') {
      return deserialize<_i37.RefundRequest>(data['data']);
    }
    if (dataClassName == 'RefundRequestSummary') {
      return deserialize<_i38.RefundRequestSummary>(data['data']);
    }
    if (dataClassName == 'RequestStatus') {
      return deserialize<_i39.RequestStatus>(data['data']);
    }
    if (dataClassName == 'Review') {
      return deserialize<_i40.Review>(data['data']);
    }
    if (dataClassName == 'ShopListingSummary') {
      return deserialize<_i41.ShopListingSummary>(data['data']);
    }
    if (dataClassName == 'User') {
      return deserialize<_i42.User>(data['data']);
    }
    if (dataClassName == 'UserAccountStatus') {
      return deserialize<_i43.UserAccountStatus>(data['data']);
    }
    if (dataClassName == 'UserArSessionSummary') {
      return deserialize<_i44.UserArSessionSummary>(data['data']);
    }
    if (dataClassName == 'UserDashboard') {
      return deserialize<_i45.UserDashboard>(data['data']);
    }
    if (dataClassName == 'UserOrderDeliveryEvent') {
      return deserialize<_i46.UserOrderDeliveryEvent>(data['data']);
    }
    if (dataClassName == 'UserOrderDetail') {
      return deserialize<_i47.UserOrderDetail>(data['data']);
    }
    if (dataClassName == 'UserOrderLineItem') {
      return deserialize<_i48.UserOrderLineItem>(data['data']);
    }
    if (dataClassName == 'UserOrderPaymentSummary') {
      return deserialize<_i49.UserOrderPaymentSummary>(data['data']);
    }
    if (dataClassName == 'UserOrderSummary') {
      return deserialize<_i50.UserOrderSummary>(data['data']);
    }
    if (dataClassName == 'UserRole') {
      return deserialize<_i51.UserRole>(data['data']);
    }
    if (dataClassName == 'Vendor') {
      return deserialize<_i52.Vendor>(data['data']);
    }
    if (dataClassName == 'VendorApplicationDetail') {
      return deserialize<_i53.VendorApplicationDetail>(data['data']);
    }
    if (dataClassName == 'VendorApplicationSummary') {
      return deserialize<_i54.VendorApplicationSummary>(data['data']);
    }
    if (dataClassName == 'VendorDashboard') {
      return deserialize<_i55.VendorDashboard>(data['data']);
    }
    if (dataClassName == 'VendorDocument') {
      return deserialize<_i56.VendorDocument>(data['data']);
    }
    if (dataClassName == 'VendorDocumentType') {
      return deserialize<_i57.VendorDocumentType>(data['data']);
    }
    if (dataClassName == 'VendorOrderLineItem') {
      return deserialize<_i58.VendorOrderLineItem>(data['data']);
    }
    if (dataClassName == 'VendorOrderSummary') {
      return deserialize<_i59.VendorOrderSummary>(data['data']);
    }
    if (dataClassName == 'VendorPaymentsOverview') {
      return deserialize<_i60.VendorPaymentsOverview>(data['data']);
    }
    if (dataClassName == 'VendorPayout') {
      return deserialize<_i61.VendorPayout>(data['data']);
    }
    if (dataClassName == 'VendorPayoutStatus') {
      return deserialize<_i62.VendorPayoutStatus>(data['data']);
    }
    if (dataClassName == 'VendorPayoutSummary') {
      return deserialize<_i63.VendorPayoutSummary>(data['data']);
    }
    if (dataClassName == 'VendorProductStat') {
      return deserialize<_i64.VendorProductStat>(data['data']);
    }
    if (dataClassName == 'VendorProductUploadInput') {
      return deserialize<_i65.VendorProductUploadInput>(data['data']);
    }
    if (dataClassName == 'VendorProfileDetail') {
      return deserialize<_i66.VendorProfileDetail>(data['data']);
    }
    if (dataClassName == 'VendorProfileUpdateInput') {
      return deserialize<_i67.VendorProfileUpdateInput>(data['data']);
    }
    if (dataClassName == 'VendorShopOrder') {
      return deserialize<_i68.VendorShopOrder>(data['data']);
    }
    if (dataClassName == 'WishlistItem') {
      return deserialize<_i69.WishlistItem>(data['data']);
    }
    if (dataClassName == 'WishlistPage') {
      return deserialize<_i70.WishlistPage>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i90.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i91.Protocol().deserializeByClassName(data);
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
      return _i90.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i91.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
