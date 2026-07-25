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
import 'admin_action_type.dart' as _i3;
import 'admin_audit_log.dart' as _i4;
import 'admin_audit_log_summary.dart' as _i5;
import 'admin_platform_stats.dart' as _i6;
import 'admin_product_complaint_summary.dart' as _i7;
import 'admin_product_detail.dart' as _i8;
import 'admin_product_list_input.dart' as _i9;
import 'admin_product_summary.dart' as _i10;
import 'admin_product_visibility_filter.dart' as _i11;
import 'admin_refund_request_summary.dart' as _i12;
import 'admin_type.dart' as _i13;
import 'admin_vendor_payout_summary.dart' as _i14;
import 'ar_session.dart' as _i15;
import 'cart.dart' as _i16;
import 'cart_item.dart' as _i17;
import 'category.dart' as _i18;
import 'chat_message.dart' as _i19;
import 'chat_message_page.dart' as _i20;
import 'chat_message_type.dart' as _i21;
import 'checkout_request.dart' as _i22;
import 'checkout_result.dart' as _i23;
import 'complaint.dart' as _i24;
import 'complaint_status.dart' as _i25;
import 'conversation.dart' as _i26;
import 'conversation_page.dart' as _i27;
import 'conversation_summary.dart' as _i28;
import 'customization_request.dart' as _i29;
import 'delivery_stage.dart' as _i30;
import 'email_verification_pending.dart' as _i31;
import 'esewa_refund_status_trigger.dart' as _i32;
import 'greetings/greeting.dart' as _i33;
import 'in_app_notification.dart' as _i34;
import 'in_app_notification_summary.dart' as _i35;
import 'in_app_notification_type.dart' as _i36;
import 'marketplace_highlights.dart' as _i37;
import 'notification_preference.dart' as _i38;
import 'order.dart' as _i39;
import 'order_auto_cancel_trigger.dart' as _i40;
import 'order_delivery_status.dart' as _i41;
import 'order_delivery_update.dart' as _i42;
import 'order_item.dart' as _i43;
import 'order_page.dart' as _i44;
import 'order_payment_status.dart' as _i45;
import 'order_status.dart' as _i46;
import 'order_status_history.dart' as _i47;
import 'order_status_history_type.dart' as _i48;
import 'order_vendor_payment.dart' as _i49;
import 'pagination_input.dart' as _i50;
import 'password_reset_token.dart' as _i51;
import 'payment_method.dart' as _i52;
import 'payment_transaction.dart' as _i53;
import 'payment_transaction_status.dart' as _i54;
import 'payment_update_summary.dart' as _i55;
import 'placeify_exception.dart' as _i56;
import 'platform_user_detail.dart' as _i57;
import 'platform_user_summary.dart' as _i58;
import 'product.dart' as _i59;
import 'product_page.dart' as _i60;
import 'product_search_input.dart' as _i61;
import 'product_status.dart' as _i62;
import 'refund_request.dart' as _i63;
import 'refund_request_summary.dart' as _i64;
import 'request_status.dart' as _i65;
import 'review.dart' as _i66;
import 'shop_listing_summary.dart' as _i67;
import 'user.dart' as _i68;
import 'user_account_status.dart' as _i69;
import 'user_ar_session_summary.dart' as _i70;
import 'user_dashboard.dart' as _i71;
import 'user_order_delivery_event.dart' as _i72;
import 'user_order_detail.dart' as _i73;
import 'user_order_line_item.dart' as _i74;
import 'user_order_payment_event.dart' as _i75;
import 'user_order_payment_summary.dart' as _i76;
import 'user_order_summary.dart' as _i77;
import 'user_role.dart' as _i78;
import 'vendor.dart' as _i79;
import 'vendor_application_detail.dart' as _i80;
import 'vendor_application_summary.dart' as _i81;
import 'vendor_bank_details.dart' as _i82;
import 'vendor_bank_details_input.dart' as _i83;
import 'vendor_dashboard.dart' as _i84;
import 'vendor_document.dart' as _i85;
import 'vendor_document_type.dart' as _i86;
import 'vendor_moderation_result.dart' as _i87;
import 'vendor_notification_summary.dart' as _i88;
import 'vendor_notification_type.dart' as _i89;
import 'vendor_order_line_item.dart' as _i90;
import 'vendor_order_summary.dart' as _i91;
import 'vendor_payments_overview.dart' as _i92;
import 'vendor_payout.dart' as _i93;
import 'vendor_payout_status.dart' as _i94;
import 'vendor_payout_summary.dart' as _i95;
import 'vendor_product_stat.dart' as _i96;
import 'vendor_product_upload_input.dart' as _i97;
import 'vendor_profile_detail.dart' as _i98;
import 'vendor_profile_update_input.dart' as _i99;
import 'vendor_review_summary.dart' as _i100;
import 'vendor_shop_order.dart' as _i101;
import 'wishlist_item.dart' as _i102;
import 'wishlist_page.dart' as _i103;
import 'package:placeify_client/src/protocol/user_role.dart' as _i104;
import 'package:placeify_client/src/protocol/user_order_summary.dart' as _i105;
import 'package:placeify_client/src/protocol/user_order_payment_summary.dart'
    as _i106;
import 'package:placeify_client/src/protocol/user_ar_session_summary.dart'
    as _i107;
import 'package:placeify_client/src/protocol/in_app_notification_summary.dart'
    as _i108;
import 'package:placeify_client/src/protocol/complaint.dart' as _i109;
import 'package:placeify_client/src/protocol/platform_user_summary.dart'
    as _i110;
import 'package:placeify_client/src/protocol/vendor_application_summary.dart'
    as _i111;
import 'package:placeify_client/src/protocol/admin_audit_log_summary.dart'
    as _i112;
import 'package:placeify_client/src/protocol/admin_vendor_payout_summary.dart'
    as _i113;
import 'package:placeify_client/src/protocol/admin_refund_request_summary.dart'
    as _i114;
import 'package:placeify_client/src/protocol/admin_product_summary.dart'
    as _i115;
import 'package:placeify_client/src/protocol/ar_session.dart' as _i116;
import 'package:placeify_client/src/protocol/cart_item.dart' as _i117;
import 'package:placeify_client/src/protocol/order_delivery_update.dart'
    as _i118;
import 'package:placeify_client/src/protocol/payment_update_summary.dart'
    as _i119;
import 'package:placeify_client/src/protocol/category.dart' as _i120;
import 'package:placeify_client/src/protocol/shop_listing_summary.dart'
    as _i121;
import 'package:placeify_client/src/protocol/product.dart' as _i122;
import 'package:placeify_client/src/protocol/refund_request_summary.dart'
    as _i123;
import 'package:placeify_client/src/protocol/review.dart' as _i124;
import 'package:placeify_client/src/protocol/vendor_shop_order.dart' as _i125;
import 'package:placeify_client/src/protocol/vendor_notification_summary.dart'
    as _i126;
import 'package:placeify_client/src/protocol/vendor_review_summary.dart'
    as _i127;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i128;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i129;
export 'admin.dart';
export 'admin_action_type.dart';
export 'admin_audit_log.dart';
export 'admin_audit_log_summary.dart';
export 'admin_platform_stats.dart';
export 'admin_product_complaint_summary.dart';
export 'admin_product_detail.dart';
export 'admin_product_list_input.dart';
export 'admin_product_summary.dart';
export 'admin_product_visibility_filter.dart';
export 'admin_refund_request_summary.dart';
export 'admin_type.dart';
export 'admin_vendor_payout_summary.dart';
export 'ar_session.dart';
export 'cart.dart';
export 'cart_item.dart';
export 'category.dart';
export 'chat_message.dart';
export 'chat_message_page.dart';
export 'chat_message_type.dart';
export 'checkout_request.dart';
export 'checkout_result.dart';
export 'complaint.dart';
export 'complaint_status.dart';
export 'conversation.dart';
export 'conversation_page.dart';
export 'conversation_summary.dart';
export 'customization_request.dart';
export 'delivery_stage.dart';
export 'email_verification_pending.dart';
export 'esewa_refund_status_trigger.dart';
export 'greetings/greeting.dart';
export 'in_app_notification.dart';
export 'in_app_notification_summary.dart';
export 'in_app_notification_type.dart';
export 'marketplace_highlights.dart';
export 'notification_preference.dart';
export 'order.dart';
export 'order_auto_cancel_trigger.dart';
export 'order_delivery_status.dart';
export 'order_delivery_update.dart';
export 'order_item.dart';
export 'order_page.dart';
export 'order_payment_status.dart';
export 'order_status.dart';
export 'order_status_history.dart';
export 'order_status_history_type.dart';
export 'order_vendor_payment.dart';
export 'pagination_input.dart';
export 'password_reset_token.dart';
export 'payment_method.dart';
export 'payment_transaction.dart';
export 'payment_transaction_status.dart';
export 'payment_update_summary.dart';
export 'placeify_exception.dart';
export 'platform_user_detail.dart';
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
export 'user_order_payment_event.dart';
export 'user_order_payment_summary.dart';
export 'user_order_summary.dart';
export 'user_role.dart';
export 'vendor.dart';
export 'vendor_application_detail.dart';
export 'vendor_application_summary.dart';
export 'vendor_bank_details.dart';
export 'vendor_bank_details_input.dart';
export 'vendor_dashboard.dart';
export 'vendor_document.dart';
export 'vendor_document_type.dart';
export 'vendor_moderation_result.dart';
export 'vendor_notification_summary.dart';
export 'vendor_notification_type.dart';
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
export 'vendor_review_summary.dart';
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
    if (t == _i3.AdminActionType) {
      return _i3.AdminActionType.fromJson(data) as T;
    }
    if (t == _i4.AdminAuditLog) {
      return _i4.AdminAuditLog.fromJson(data) as T;
    }
    if (t == _i5.AdminAuditLogSummary) {
      return _i5.AdminAuditLogSummary.fromJson(data) as T;
    }
    if (t == _i6.AdminPlatformStats) {
      return _i6.AdminPlatformStats.fromJson(data) as T;
    }
    if (t == _i7.AdminProductComplaintSummary) {
      return _i7.AdminProductComplaintSummary.fromJson(data) as T;
    }
    if (t == _i8.AdminProductDetail) {
      return _i8.AdminProductDetail.fromJson(data) as T;
    }
    if (t == _i9.AdminProductListInput) {
      return _i9.AdminProductListInput.fromJson(data) as T;
    }
    if (t == _i10.AdminProductSummary) {
      return _i10.AdminProductSummary.fromJson(data) as T;
    }
    if (t == _i11.AdminProductVisibilityFilter) {
      return _i11.AdminProductVisibilityFilter.fromJson(data) as T;
    }
    if (t == _i12.AdminRefundRequestSummary) {
      return _i12.AdminRefundRequestSummary.fromJson(data) as T;
    }
    if (t == _i13.AdminType) {
      return _i13.AdminType.fromJson(data) as T;
    }
    if (t == _i14.AdminVendorPayoutSummary) {
      return _i14.AdminVendorPayoutSummary.fromJson(data) as T;
    }
    if (t == _i15.ARSession) {
      return _i15.ARSession.fromJson(data) as T;
    }
    if (t == _i16.Cart) {
      return _i16.Cart.fromJson(data) as T;
    }
    if (t == _i17.CartItem) {
      return _i17.CartItem.fromJson(data) as T;
    }
    if (t == _i18.Category) {
      return _i18.Category.fromJson(data) as T;
    }
    if (t == _i19.ChatMessage) {
      return _i19.ChatMessage.fromJson(data) as T;
    }
    if (t == _i20.ChatMessagePage) {
      return _i20.ChatMessagePage.fromJson(data) as T;
    }
    if (t == _i21.ChatMessageType) {
      return _i21.ChatMessageType.fromJson(data) as T;
    }
    if (t == _i22.CheckoutRequest) {
      return _i22.CheckoutRequest.fromJson(data) as T;
    }
    if (t == _i23.CheckoutResult) {
      return _i23.CheckoutResult.fromJson(data) as T;
    }
    if (t == _i24.Complaint) {
      return _i24.Complaint.fromJson(data) as T;
    }
    if (t == _i25.ComplaintStatus) {
      return _i25.ComplaintStatus.fromJson(data) as T;
    }
    if (t == _i26.Conversation) {
      return _i26.Conversation.fromJson(data) as T;
    }
    if (t == _i27.ConversationPage) {
      return _i27.ConversationPage.fromJson(data) as T;
    }
    if (t == _i28.ConversationSummary) {
      return _i28.ConversationSummary.fromJson(data) as T;
    }
    if (t == _i29.CustomizationRequest) {
      return _i29.CustomizationRequest.fromJson(data) as T;
    }
    if (t == _i30.DeliveryStage) {
      return _i30.DeliveryStage.fromJson(data) as T;
    }
    if (t == _i31.EmailVerificationPending) {
      return _i31.EmailVerificationPending.fromJson(data) as T;
    }
    if (t == _i32.EsewaRefundStatusTrigger) {
      return _i32.EsewaRefundStatusTrigger.fromJson(data) as T;
    }
    if (t == _i33.Greeting) {
      return _i33.Greeting.fromJson(data) as T;
    }
    if (t == _i34.InAppNotification) {
      return _i34.InAppNotification.fromJson(data) as T;
    }
    if (t == _i35.InAppNotificationSummary) {
      return _i35.InAppNotificationSummary.fromJson(data) as T;
    }
    if (t == _i36.InAppNotificationType) {
      return _i36.InAppNotificationType.fromJson(data) as T;
    }
    if (t == _i37.MarketplaceHighlights) {
      return _i37.MarketplaceHighlights.fromJson(data) as T;
    }
    if (t == _i38.NotificationPreference) {
      return _i38.NotificationPreference.fromJson(data) as T;
    }
    if (t == _i39.Order) {
      return _i39.Order.fromJson(data) as T;
    }
    if (t == _i40.OrderAutoCancelTrigger) {
      return _i40.OrderAutoCancelTrigger.fromJson(data) as T;
    }
    if (t == _i41.OrderDeliveryStatus) {
      return _i41.OrderDeliveryStatus.fromJson(data) as T;
    }
    if (t == _i42.OrderDeliveryUpdate) {
      return _i42.OrderDeliveryUpdate.fromJson(data) as T;
    }
    if (t == _i43.OrderItem) {
      return _i43.OrderItem.fromJson(data) as T;
    }
    if (t == _i44.OrderPage) {
      return _i44.OrderPage.fromJson(data) as T;
    }
    if (t == _i45.OrderPaymentStatus) {
      return _i45.OrderPaymentStatus.fromJson(data) as T;
    }
    if (t == _i46.OrderStatus) {
      return _i46.OrderStatus.fromJson(data) as T;
    }
    if (t == _i47.OrderStatusHistory) {
      return _i47.OrderStatusHistory.fromJson(data) as T;
    }
    if (t == _i48.OrderStatusHistoryType) {
      return _i48.OrderStatusHistoryType.fromJson(data) as T;
    }
    if (t == _i49.OrderVendorPayment) {
      return _i49.OrderVendorPayment.fromJson(data) as T;
    }
    if (t == _i50.PaginationInput) {
      return _i50.PaginationInput.fromJson(data) as T;
    }
    if (t == _i51.PasswordResetToken) {
      return _i51.PasswordResetToken.fromJson(data) as T;
    }
    if (t == _i52.PaymentMethod) {
      return _i52.PaymentMethod.fromJson(data) as T;
    }
    if (t == _i53.PaymentTransaction) {
      return _i53.PaymentTransaction.fromJson(data) as T;
    }
    if (t == _i54.PaymentTransactionStatus) {
      return _i54.PaymentTransactionStatus.fromJson(data) as T;
    }
    if (t == _i55.PaymentUpdateSummary) {
      return _i55.PaymentUpdateSummary.fromJson(data) as T;
    }
    if (t == _i56.PlaceifyException) {
      return _i56.PlaceifyException.fromJson(data) as T;
    }
    if (t == _i57.PlatformUserDetail) {
      return _i57.PlatformUserDetail.fromJson(data) as T;
    }
    if (t == _i58.PlatformUserSummary) {
      return _i58.PlatformUserSummary.fromJson(data) as T;
    }
    if (t == _i59.Product) {
      return _i59.Product.fromJson(data) as T;
    }
    if (t == _i60.ProductPage) {
      return _i60.ProductPage.fromJson(data) as T;
    }
    if (t == _i61.ProductSearchInput) {
      return _i61.ProductSearchInput.fromJson(data) as T;
    }
    if (t == _i62.ProductStatus) {
      return _i62.ProductStatus.fromJson(data) as T;
    }
    if (t == _i63.RefundRequest) {
      return _i63.RefundRequest.fromJson(data) as T;
    }
    if (t == _i64.RefundRequestSummary) {
      return _i64.RefundRequestSummary.fromJson(data) as T;
    }
    if (t == _i65.RequestStatus) {
      return _i65.RequestStatus.fromJson(data) as T;
    }
    if (t == _i66.Review) {
      return _i66.Review.fromJson(data) as T;
    }
    if (t == _i67.ShopListingSummary) {
      return _i67.ShopListingSummary.fromJson(data) as T;
    }
    if (t == _i68.User) {
      return _i68.User.fromJson(data) as T;
    }
    if (t == _i69.UserAccountStatus) {
      return _i69.UserAccountStatus.fromJson(data) as T;
    }
    if (t == _i70.UserArSessionSummary) {
      return _i70.UserArSessionSummary.fromJson(data) as T;
    }
    if (t == _i71.UserDashboard) {
      return _i71.UserDashboard.fromJson(data) as T;
    }
    if (t == _i72.UserOrderDeliveryEvent) {
      return _i72.UserOrderDeliveryEvent.fromJson(data) as T;
    }
    if (t == _i73.UserOrderDetail) {
      return _i73.UserOrderDetail.fromJson(data) as T;
    }
    if (t == _i74.UserOrderLineItem) {
      return _i74.UserOrderLineItem.fromJson(data) as T;
    }
    if (t == _i75.UserOrderPaymentEvent) {
      return _i75.UserOrderPaymentEvent.fromJson(data) as T;
    }
    if (t == _i76.UserOrderPaymentSummary) {
      return _i76.UserOrderPaymentSummary.fromJson(data) as T;
    }
    if (t == _i77.UserOrderSummary) {
      return _i77.UserOrderSummary.fromJson(data) as T;
    }
    if (t == _i78.UserRole) {
      return _i78.UserRole.fromJson(data) as T;
    }
    if (t == _i79.Vendor) {
      return _i79.Vendor.fromJson(data) as T;
    }
    if (t == _i80.VendorApplicationDetail) {
      return _i80.VendorApplicationDetail.fromJson(data) as T;
    }
    if (t == _i81.VendorApplicationSummary) {
      return _i81.VendorApplicationSummary.fromJson(data) as T;
    }
    if (t == _i82.VendorBankDetails) {
      return _i82.VendorBankDetails.fromJson(data) as T;
    }
    if (t == _i83.VendorBankDetailsInput) {
      return _i83.VendorBankDetailsInput.fromJson(data) as T;
    }
    if (t == _i84.VendorDashboard) {
      return _i84.VendorDashboard.fromJson(data) as T;
    }
    if (t == _i85.VendorDocument) {
      return _i85.VendorDocument.fromJson(data) as T;
    }
    if (t == _i86.VendorDocumentType) {
      return _i86.VendorDocumentType.fromJson(data) as T;
    }
    if (t == _i87.VendorModerationResult) {
      return _i87.VendorModerationResult.fromJson(data) as T;
    }
    if (t == _i88.VendorNotificationSummary) {
      return _i88.VendorNotificationSummary.fromJson(data) as T;
    }
    if (t == _i89.VendorNotificationType) {
      return _i89.VendorNotificationType.fromJson(data) as T;
    }
    if (t == _i90.VendorOrderLineItem) {
      return _i90.VendorOrderLineItem.fromJson(data) as T;
    }
    if (t == _i91.VendorOrderSummary) {
      return _i91.VendorOrderSummary.fromJson(data) as T;
    }
    if (t == _i92.VendorPaymentsOverview) {
      return _i92.VendorPaymentsOverview.fromJson(data) as T;
    }
    if (t == _i93.VendorPayout) {
      return _i93.VendorPayout.fromJson(data) as T;
    }
    if (t == _i94.VendorPayoutStatus) {
      return _i94.VendorPayoutStatus.fromJson(data) as T;
    }
    if (t == _i95.VendorPayoutSummary) {
      return _i95.VendorPayoutSummary.fromJson(data) as T;
    }
    if (t == _i96.VendorProductStat) {
      return _i96.VendorProductStat.fromJson(data) as T;
    }
    if (t == _i97.VendorProductUploadInput) {
      return _i97.VendorProductUploadInput.fromJson(data) as T;
    }
    if (t == _i98.VendorProfileDetail) {
      return _i98.VendorProfileDetail.fromJson(data) as T;
    }
    if (t == _i99.VendorProfileUpdateInput) {
      return _i99.VendorProfileUpdateInput.fromJson(data) as T;
    }
    if (t == _i100.VendorReviewSummary) {
      return _i100.VendorReviewSummary.fromJson(data) as T;
    }
    if (t == _i101.VendorShopOrder) {
      return _i101.VendorShopOrder.fromJson(data) as T;
    }
    if (t == _i102.WishlistItem) {
      return _i102.WishlistItem.fromJson(data) as T;
    }
    if (t == _i103.WishlistPage) {
      return _i103.WishlistPage.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Admin?>()) {
      return (data != null ? _i2.Admin.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.AdminActionType?>()) {
      return (data != null ? _i3.AdminActionType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.AdminAuditLog?>()) {
      return (data != null ? _i4.AdminAuditLog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.AdminAuditLogSummary?>()) {
      return (data != null ? _i5.AdminAuditLogSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i6.AdminPlatformStats?>()) {
      return (data != null ? _i6.AdminPlatformStats.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.AdminProductComplaintSummary?>()) {
      return (data != null
              ? _i7.AdminProductComplaintSummary.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i8.AdminProductDetail?>()) {
      return (data != null ? _i8.AdminProductDetail.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.AdminProductListInput?>()) {
      return (data != null ? _i9.AdminProductListInput.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i10.AdminProductSummary?>()) {
      return (data != null ? _i10.AdminProductSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.AdminProductVisibilityFilter?>()) {
      return (data != null
              ? _i11.AdminProductVisibilityFilter.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i12.AdminRefundRequestSummary?>()) {
      return (data != null
              ? _i12.AdminRefundRequestSummary.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i13.AdminType?>()) {
      return (data != null ? _i13.AdminType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.AdminVendorPayoutSummary?>()) {
      return (data != null
              ? _i14.AdminVendorPayoutSummary.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i15.ARSession?>()) {
      return (data != null ? _i15.ARSession.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.Cart?>()) {
      return (data != null ? _i16.Cart.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.CartItem?>()) {
      return (data != null ? _i17.CartItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.Category?>()) {
      return (data != null ? _i18.Category.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.ChatMessage?>()) {
      return (data != null ? _i19.ChatMessage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.ChatMessagePage?>()) {
      return (data != null ? _i20.ChatMessagePage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.ChatMessageType?>()) {
      return (data != null ? _i21.ChatMessageType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.CheckoutRequest?>()) {
      return (data != null ? _i22.CheckoutRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.CheckoutResult?>()) {
      return (data != null ? _i23.CheckoutResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.Complaint?>()) {
      return (data != null ? _i24.Complaint.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.ComplaintStatus?>()) {
      return (data != null ? _i25.ComplaintStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.Conversation?>()) {
      return (data != null ? _i26.Conversation.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.ConversationPage?>()) {
      return (data != null ? _i27.ConversationPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.ConversationSummary?>()) {
      return (data != null ? _i28.ConversationSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i29.CustomizationRequest?>()) {
      return (data != null ? _i29.CustomizationRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i30.DeliveryStage?>()) {
      return (data != null ? _i30.DeliveryStage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.EmailVerificationPending?>()) {
      return (data != null
              ? _i31.EmailVerificationPending.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i32.EsewaRefundStatusTrigger?>()) {
      return (data != null
              ? _i32.EsewaRefundStatusTrigger.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i33.Greeting?>()) {
      return (data != null ? _i33.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.InAppNotification?>()) {
      return (data != null ? _i34.InAppNotification.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.InAppNotificationSummary?>()) {
      return (data != null
              ? _i35.InAppNotificationSummary.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i36.InAppNotificationType?>()) {
      return (data != null ? _i36.InAppNotificationType.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i37.MarketplaceHighlights?>()) {
      return (data != null ? _i37.MarketplaceHighlights.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i38.NotificationPreference?>()) {
      return (data != null ? _i38.NotificationPreference.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i39.Order?>()) {
      return (data != null ? _i39.Order.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.OrderAutoCancelTrigger?>()) {
      return (data != null ? _i40.OrderAutoCancelTrigger.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i41.OrderDeliveryStatus?>()) {
      return (data != null ? _i41.OrderDeliveryStatus.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i42.OrderDeliveryUpdate?>()) {
      return (data != null ? _i42.OrderDeliveryUpdate.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i43.OrderItem?>()) {
      return (data != null ? _i43.OrderItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i44.OrderPage?>()) {
      return (data != null ? _i44.OrderPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i45.OrderPaymentStatus?>()) {
      return (data != null ? _i45.OrderPaymentStatus.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i46.OrderStatus?>()) {
      return (data != null ? _i46.OrderStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i47.OrderStatusHistory?>()) {
      return (data != null ? _i47.OrderStatusHistory.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i48.OrderStatusHistoryType?>()) {
      return (data != null ? _i48.OrderStatusHistoryType.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i49.OrderVendorPayment?>()) {
      return (data != null ? _i49.OrderVendorPayment.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i50.PaginationInput?>()) {
      return (data != null ? _i50.PaginationInput.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i51.PasswordResetToken?>()) {
      return (data != null ? _i51.PasswordResetToken.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i52.PaymentMethod?>()) {
      return (data != null ? _i52.PaymentMethod.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i53.PaymentTransaction?>()) {
      return (data != null ? _i53.PaymentTransaction.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i54.PaymentTransactionStatus?>()) {
      return (data != null
              ? _i54.PaymentTransactionStatus.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i55.PaymentUpdateSummary?>()) {
      return (data != null ? _i55.PaymentUpdateSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i56.PlaceifyException?>()) {
      return (data != null ? _i56.PlaceifyException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i57.PlatformUserDetail?>()) {
      return (data != null ? _i57.PlatformUserDetail.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i58.PlatformUserSummary?>()) {
      return (data != null ? _i58.PlatformUserSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i59.Product?>()) {
      return (data != null ? _i59.Product.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i60.ProductPage?>()) {
      return (data != null ? _i60.ProductPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i61.ProductSearchInput?>()) {
      return (data != null ? _i61.ProductSearchInput.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i62.ProductStatus?>()) {
      return (data != null ? _i62.ProductStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i63.RefundRequest?>()) {
      return (data != null ? _i63.RefundRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i64.RefundRequestSummary?>()) {
      return (data != null ? _i64.RefundRequestSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i65.RequestStatus?>()) {
      return (data != null ? _i65.RequestStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i66.Review?>()) {
      return (data != null ? _i66.Review.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i67.ShopListingSummary?>()) {
      return (data != null ? _i67.ShopListingSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i68.User?>()) {
      return (data != null ? _i68.User.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i69.UserAccountStatus?>()) {
      return (data != null ? _i69.UserAccountStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i70.UserArSessionSummary?>()) {
      return (data != null ? _i70.UserArSessionSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i71.UserDashboard?>()) {
      return (data != null ? _i71.UserDashboard.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i72.UserOrderDeliveryEvent?>()) {
      return (data != null ? _i72.UserOrderDeliveryEvent.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i73.UserOrderDetail?>()) {
      return (data != null ? _i73.UserOrderDetail.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i74.UserOrderLineItem?>()) {
      return (data != null ? _i74.UserOrderLineItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i75.UserOrderPaymentEvent?>()) {
      return (data != null ? _i75.UserOrderPaymentEvent.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i76.UserOrderPaymentSummary?>()) {
      return (data != null ? _i76.UserOrderPaymentSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i77.UserOrderSummary?>()) {
      return (data != null ? _i77.UserOrderSummary.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i78.UserRole?>()) {
      return (data != null ? _i78.UserRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i79.Vendor?>()) {
      return (data != null ? _i79.Vendor.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i80.VendorApplicationDetail?>()) {
      return (data != null ? _i80.VendorApplicationDetail.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i81.VendorApplicationSummary?>()) {
      return (data != null
              ? _i81.VendorApplicationSummary.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i82.VendorBankDetails?>()) {
      return (data != null ? _i82.VendorBankDetails.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i83.VendorBankDetailsInput?>()) {
      return (data != null ? _i83.VendorBankDetailsInput.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i84.VendorDashboard?>()) {
      return (data != null ? _i84.VendorDashboard.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i85.VendorDocument?>()) {
      return (data != null ? _i85.VendorDocument.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i86.VendorDocumentType?>()) {
      return (data != null ? _i86.VendorDocumentType.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i87.VendorModerationResult?>()) {
      return (data != null ? _i87.VendorModerationResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i88.VendorNotificationSummary?>()) {
      return (data != null
              ? _i88.VendorNotificationSummary.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i89.VendorNotificationType?>()) {
      return (data != null ? _i89.VendorNotificationType.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i90.VendorOrderLineItem?>()) {
      return (data != null ? _i90.VendorOrderLineItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i91.VendorOrderSummary?>()) {
      return (data != null ? _i91.VendorOrderSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i92.VendorPaymentsOverview?>()) {
      return (data != null ? _i92.VendorPaymentsOverview.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i93.VendorPayout?>()) {
      return (data != null ? _i93.VendorPayout.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i94.VendorPayoutStatus?>()) {
      return (data != null ? _i94.VendorPayoutStatus.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i95.VendorPayoutSummary?>()) {
      return (data != null ? _i95.VendorPayoutSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i96.VendorProductStat?>()) {
      return (data != null ? _i96.VendorProductStat.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i97.VendorProductUploadInput?>()) {
      return (data != null
              ? _i97.VendorProductUploadInput.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i98.VendorProfileDetail?>()) {
      return (data != null ? _i98.VendorProfileDetail.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i99.VendorProfileUpdateInput?>()) {
      return (data != null
              ? _i99.VendorProfileUpdateInput.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i100.VendorReviewSummary?>()) {
      return (data != null ? _i100.VendorReviewSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i101.VendorShopOrder?>()) {
      return (data != null ? _i101.VendorShopOrder.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i102.WishlistItem?>()) {
      return (data != null ? _i102.WishlistItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i103.WishlistPage?>()) {
      return (data != null ? _i103.WishlistPage.fromJson(data) : null) as T;
    }
    if (t == List<_i5.AdminAuditLogSummary>) {
      return (data as List)
              .map((e) => deserialize<_i5.AdminAuditLogSummary>(e))
              .toList()
          as T;
    }
    if (t == List<double>) {
      return (data as List).map((e) => deserialize<double>(e)).toList() as T;
    }
    if (t == List<_i81.VendorApplicationSummary>) {
      return (data as List)
              .map((e) => deserialize<_i81.VendorApplicationSummary>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i7.AdminProductComplaintSummary>) {
      return (data as List)
              .map((e) => deserialize<_i7.AdminProductComplaintSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i19.ChatMessage>) {
      return (data as List)
              .map((e) => deserialize<_i19.ChatMessage>(e))
              .toList()
          as T;
    }
    if (t == List<_i28.ConversationSummary>) {
      return (data as List)
              .map((e) => deserialize<_i28.ConversationSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i59.Product>) {
      return (data as List).map((e) => deserialize<_i59.Product>(e)).toList()
          as T;
    }
    if (t == List<_i39.Order>) {
      return (data as List).map((e) => deserialize<_i39.Order>(e)).toList()
          as T;
    }
    if (t == List<_i74.UserOrderLineItem>) {
      return (data as List)
              .map((e) => deserialize<_i74.UserOrderLineItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i72.UserOrderDeliveryEvent>) {
      return (data as List)
              .map((e) => deserialize<_i72.UserOrderDeliveryEvent>(e))
              .toList()
          as T;
    }
    if (t == List<_i75.UserOrderPaymentEvent>) {
      return (data as List)
              .map((e) => deserialize<_i75.UserOrderPaymentEvent>(e))
              .toList()
          as T;
    }
    if (t == List<_i91.VendorOrderSummary>) {
      return (data as List)
              .map((e) => deserialize<_i91.VendorOrderSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i96.VendorProductStat>) {
      return (data as List)
              .map((e) => deserialize<_i96.VendorProductStat>(e))
              .toList()
          as T;
    }
    if (t == List<_i95.VendorPayoutSummary>) {
      return (data as List)
              .map((e) => deserialize<_i95.VendorPayoutSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i55.PaymentUpdateSummary>) {
      return (data as List)
              .map((e) => deserialize<_i55.PaymentUpdateSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i90.VendorOrderLineItem>) {
      return (data as List)
              .map((e) => deserialize<_i90.VendorOrderLineItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i102.WishlistItem>) {
      return (data as List)
              .map((e) => deserialize<_i102.WishlistItem>(e))
              .toList()
          as T;
    }
    if (t == Set<_i104.UserRole>) {
      return (data as List).map((e) => deserialize<_i104.UserRole>(e)).toSet()
          as T;
    }
    if (t == List<_i105.UserOrderSummary>) {
      return (data as List)
              .map((e) => deserialize<_i105.UserOrderSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i106.UserOrderPaymentSummary>) {
      return (data as List)
              .map((e) => deserialize<_i106.UserOrderPaymentSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i107.UserArSessionSummary>) {
      return (data as List)
              .map((e) => deserialize<_i107.UserArSessionSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i108.InAppNotificationSummary>) {
      return (data as List)
              .map((e) => deserialize<_i108.InAppNotificationSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i109.Complaint>) {
      return (data as List).map((e) => deserialize<_i109.Complaint>(e)).toList()
          as T;
    }
    if (t == List<_i110.PlatformUserSummary>) {
      return (data as List)
              .map((e) => deserialize<_i110.PlatformUserSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i111.VendorApplicationSummary>) {
      return (data as List)
              .map((e) => deserialize<_i111.VendorApplicationSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i112.AdminAuditLogSummary>) {
      return (data as List)
              .map((e) => deserialize<_i112.AdminAuditLogSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i113.AdminVendorPayoutSummary>) {
      return (data as List)
              .map((e) => deserialize<_i113.AdminVendorPayoutSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i114.AdminRefundRequestSummary>) {
      return (data as List)
              .map((e) => deserialize<_i114.AdminRefundRequestSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i115.AdminProductSummary>) {
      return (data as List)
              .map((e) => deserialize<_i115.AdminProductSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i116.ARSession>) {
      return (data as List).map((e) => deserialize<_i116.ARSession>(e)).toList()
          as T;
    }
    if (t == List<_i117.CartItem>) {
      return (data as List).map((e) => deserialize<_i117.CartItem>(e)).toList()
          as T;
    }
    if (t == List<_i118.OrderDeliveryUpdate>) {
      return (data as List)
              .map((e) => deserialize<_i118.OrderDeliveryUpdate>(e))
              .toList()
          as T;
    }
    if (t == List<_i119.PaymentUpdateSummary>) {
      return (data as List)
              .map((e) => deserialize<_i119.PaymentUpdateSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i120.Category>) {
      return (data as List).map((e) => deserialize<_i120.Category>(e)).toList()
          as T;
    }
    if (t == List<_i121.ShopListingSummary>) {
      return (data as List)
              .map((e) => deserialize<_i121.ShopListingSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i122.Product>) {
      return (data as List).map((e) => deserialize<_i122.Product>(e)).toList()
          as T;
    }
    if (t == List<_i123.RefundRequestSummary>) {
      return (data as List)
              .map((e) => deserialize<_i123.RefundRequestSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i124.Review>) {
      return (data as List).map((e) => deserialize<_i124.Review>(e)).toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i125.VendorShopOrder>) {
      return (data as List)
              .map((e) => deserialize<_i125.VendorShopOrder>(e))
              .toList()
          as T;
    }
    if (t == List<_i126.VendorNotificationSummary>) {
      return (data as List)
              .map((e) => deserialize<_i126.VendorNotificationSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i127.VendorReviewSummary>) {
      return (data as List)
              .map((e) => deserialize<_i127.VendorReviewSummary>(e))
              .toList()
          as T;
    }
    try {
      return _i128.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i129.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.Admin => 'Admin',
      _i3.AdminActionType => 'AdminActionType',
      _i4.AdminAuditLog => 'AdminAuditLog',
      _i5.AdminAuditLogSummary => 'AdminAuditLogSummary',
      _i6.AdminPlatformStats => 'AdminPlatformStats',
      _i7.AdminProductComplaintSummary => 'AdminProductComplaintSummary',
      _i8.AdminProductDetail => 'AdminProductDetail',
      _i9.AdminProductListInput => 'AdminProductListInput',
      _i10.AdminProductSummary => 'AdminProductSummary',
      _i11.AdminProductVisibilityFilter => 'AdminProductVisibilityFilter',
      _i12.AdminRefundRequestSummary => 'AdminRefundRequestSummary',
      _i13.AdminType => 'AdminType',
      _i14.AdminVendorPayoutSummary => 'AdminVendorPayoutSummary',
      _i15.ARSession => 'ARSession',
      _i16.Cart => 'Cart',
      _i17.CartItem => 'CartItem',
      _i18.Category => 'Category',
      _i19.ChatMessage => 'ChatMessage',
      _i20.ChatMessagePage => 'ChatMessagePage',
      _i21.ChatMessageType => 'ChatMessageType',
      _i22.CheckoutRequest => 'CheckoutRequest',
      _i23.CheckoutResult => 'CheckoutResult',
      _i24.Complaint => 'Complaint',
      _i25.ComplaintStatus => 'ComplaintStatus',
      _i26.Conversation => 'Conversation',
      _i27.ConversationPage => 'ConversationPage',
      _i28.ConversationSummary => 'ConversationSummary',
      _i29.CustomizationRequest => 'CustomizationRequest',
      _i30.DeliveryStage => 'DeliveryStage',
      _i31.EmailVerificationPending => 'EmailVerificationPending',
      _i32.EsewaRefundStatusTrigger => 'EsewaRefundStatusTrigger',
      _i33.Greeting => 'Greeting',
      _i34.InAppNotification => 'InAppNotification',
      _i35.InAppNotificationSummary => 'InAppNotificationSummary',
      _i36.InAppNotificationType => 'InAppNotificationType',
      _i37.MarketplaceHighlights => 'MarketplaceHighlights',
      _i38.NotificationPreference => 'NotificationPreference',
      _i39.Order => 'Order',
      _i40.OrderAutoCancelTrigger => 'OrderAutoCancelTrigger',
      _i41.OrderDeliveryStatus => 'OrderDeliveryStatus',
      _i42.OrderDeliveryUpdate => 'OrderDeliveryUpdate',
      _i43.OrderItem => 'OrderItem',
      _i44.OrderPage => 'OrderPage',
      _i45.OrderPaymentStatus => 'OrderPaymentStatus',
      _i46.OrderStatus => 'OrderStatus',
      _i47.OrderStatusHistory => 'OrderStatusHistory',
      _i48.OrderStatusHistoryType => 'OrderStatusHistoryType',
      _i49.OrderVendorPayment => 'OrderVendorPayment',
      _i50.PaginationInput => 'PaginationInput',
      _i51.PasswordResetToken => 'PasswordResetToken',
      _i52.PaymentMethod => 'PaymentMethod',
      _i53.PaymentTransaction => 'PaymentTransaction',
      _i54.PaymentTransactionStatus => 'PaymentTransactionStatus',
      _i55.PaymentUpdateSummary => 'PaymentUpdateSummary',
      _i56.PlaceifyException => 'PlaceifyException',
      _i57.PlatformUserDetail => 'PlatformUserDetail',
      _i58.PlatformUserSummary => 'PlatformUserSummary',
      _i59.Product => 'Product',
      _i60.ProductPage => 'ProductPage',
      _i61.ProductSearchInput => 'ProductSearchInput',
      _i62.ProductStatus => 'ProductStatus',
      _i63.RefundRequest => 'RefundRequest',
      _i64.RefundRequestSummary => 'RefundRequestSummary',
      _i65.RequestStatus => 'RequestStatus',
      _i66.Review => 'Review',
      _i67.ShopListingSummary => 'ShopListingSummary',
      _i68.User => 'User',
      _i69.UserAccountStatus => 'UserAccountStatus',
      _i70.UserArSessionSummary => 'UserArSessionSummary',
      _i71.UserDashboard => 'UserDashboard',
      _i72.UserOrderDeliveryEvent => 'UserOrderDeliveryEvent',
      _i73.UserOrderDetail => 'UserOrderDetail',
      _i74.UserOrderLineItem => 'UserOrderLineItem',
      _i75.UserOrderPaymentEvent => 'UserOrderPaymentEvent',
      _i76.UserOrderPaymentSummary => 'UserOrderPaymentSummary',
      _i77.UserOrderSummary => 'UserOrderSummary',
      _i78.UserRole => 'UserRole',
      _i79.Vendor => 'Vendor',
      _i80.VendorApplicationDetail => 'VendorApplicationDetail',
      _i81.VendorApplicationSummary => 'VendorApplicationSummary',
      _i82.VendorBankDetails => 'VendorBankDetails',
      _i83.VendorBankDetailsInput => 'VendorBankDetailsInput',
      _i84.VendorDashboard => 'VendorDashboard',
      _i85.VendorDocument => 'VendorDocument',
      _i86.VendorDocumentType => 'VendorDocumentType',
      _i87.VendorModerationResult => 'VendorModerationResult',
      _i88.VendorNotificationSummary => 'VendorNotificationSummary',
      _i89.VendorNotificationType => 'VendorNotificationType',
      _i90.VendorOrderLineItem => 'VendorOrderLineItem',
      _i91.VendorOrderSummary => 'VendorOrderSummary',
      _i92.VendorPaymentsOverview => 'VendorPaymentsOverview',
      _i93.VendorPayout => 'VendorPayout',
      _i94.VendorPayoutStatus => 'VendorPayoutStatus',
      _i95.VendorPayoutSummary => 'VendorPayoutSummary',
      _i96.VendorProductStat => 'VendorProductStat',
      _i97.VendorProductUploadInput => 'VendorProductUploadInput',
      _i98.VendorProfileDetail => 'VendorProfileDetail',
      _i99.VendorProfileUpdateInput => 'VendorProfileUpdateInput',
      _i100.VendorReviewSummary => 'VendorReviewSummary',
      _i101.VendorShopOrder => 'VendorShopOrder',
      _i102.WishlistItem => 'WishlistItem',
      _i103.WishlistPage => 'WishlistPage',
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
      case _i3.AdminActionType():
        return 'AdminActionType';
      case _i4.AdminAuditLog():
        return 'AdminAuditLog';
      case _i5.AdminAuditLogSummary():
        return 'AdminAuditLogSummary';
      case _i6.AdminPlatformStats():
        return 'AdminPlatformStats';
      case _i7.AdminProductComplaintSummary():
        return 'AdminProductComplaintSummary';
      case _i8.AdminProductDetail():
        return 'AdminProductDetail';
      case _i9.AdminProductListInput():
        return 'AdminProductListInput';
      case _i10.AdminProductSummary():
        return 'AdminProductSummary';
      case _i11.AdminProductVisibilityFilter():
        return 'AdminProductVisibilityFilter';
      case _i12.AdminRefundRequestSummary():
        return 'AdminRefundRequestSummary';
      case _i13.AdminType():
        return 'AdminType';
      case _i14.AdminVendorPayoutSummary():
        return 'AdminVendorPayoutSummary';
      case _i15.ARSession():
        return 'ARSession';
      case _i16.Cart():
        return 'Cart';
      case _i17.CartItem():
        return 'CartItem';
      case _i18.Category():
        return 'Category';
      case _i19.ChatMessage():
        return 'ChatMessage';
      case _i20.ChatMessagePage():
        return 'ChatMessagePage';
      case _i21.ChatMessageType():
        return 'ChatMessageType';
      case _i22.CheckoutRequest():
        return 'CheckoutRequest';
      case _i23.CheckoutResult():
        return 'CheckoutResult';
      case _i24.Complaint():
        return 'Complaint';
      case _i25.ComplaintStatus():
        return 'ComplaintStatus';
      case _i26.Conversation():
        return 'Conversation';
      case _i27.ConversationPage():
        return 'ConversationPage';
      case _i28.ConversationSummary():
        return 'ConversationSummary';
      case _i29.CustomizationRequest():
        return 'CustomizationRequest';
      case _i30.DeliveryStage():
        return 'DeliveryStage';
      case _i31.EmailVerificationPending():
        return 'EmailVerificationPending';
      case _i32.EsewaRefundStatusTrigger():
        return 'EsewaRefundStatusTrigger';
      case _i33.Greeting():
        return 'Greeting';
      case _i34.InAppNotification():
        return 'InAppNotification';
      case _i35.InAppNotificationSummary():
        return 'InAppNotificationSummary';
      case _i36.InAppNotificationType():
        return 'InAppNotificationType';
      case _i37.MarketplaceHighlights():
        return 'MarketplaceHighlights';
      case _i38.NotificationPreference():
        return 'NotificationPreference';
      case _i39.Order():
        return 'Order';
      case _i40.OrderAutoCancelTrigger():
        return 'OrderAutoCancelTrigger';
      case _i41.OrderDeliveryStatus():
        return 'OrderDeliveryStatus';
      case _i42.OrderDeliveryUpdate():
        return 'OrderDeliveryUpdate';
      case _i43.OrderItem():
        return 'OrderItem';
      case _i44.OrderPage():
        return 'OrderPage';
      case _i45.OrderPaymentStatus():
        return 'OrderPaymentStatus';
      case _i46.OrderStatus():
        return 'OrderStatus';
      case _i47.OrderStatusHistory():
        return 'OrderStatusHistory';
      case _i48.OrderStatusHistoryType():
        return 'OrderStatusHistoryType';
      case _i49.OrderVendorPayment():
        return 'OrderVendorPayment';
      case _i50.PaginationInput():
        return 'PaginationInput';
      case _i51.PasswordResetToken():
        return 'PasswordResetToken';
      case _i52.PaymentMethod():
        return 'PaymentMethod';
      case _i53.PaymentTransaction():
        return 'PaymentTransaction';
      case _i54.PaymentTransactionStatus():
        return 'PaymentTransactionStatus';
      case _i55.PaymentUpdateSummary():
        return 'PaymentUpdateSummary';
      case _i56.PlaceifyException():
        return 'PlaceifyException';
      case _i57.PlatformUserDetail():
        return 'PlatformUserDetail';
      case _i58.PlatformUserSummary():
        return 'PlatformUserSummary';
      case _i59.Product():
        return 'Product';
      case _i60.ProductPage():
        return 'ProductPage';
      case _i61.ProductSearchInput():
        return 'ProductSearchInput';
      case _i62.ProductStatus():
        return 'ProductStatus';
      case _i63.RefundRequest():
        return 'RefundRequest';
      case _i64.RefundRequestSummary():
        return 'RefundRequestSummary';
      case _i65.RequestStatus():
        return 'RequestStatus';
      case _i66.Review():
        return 'Review';
      case _i67.ShopListingSummary():
        return 'ShopListingSummary';
      case _i68.User():
        return 'User';
      case _i69.UserAccountStatus():
        return 'UserAccountStatus';
      case _i70.UserArSessionSummary():
        return 'UserArSessionSummary';
      case _i71.UserDashboard():
        return 'UserDashboard';
      case _i72.UserOrderDeliveryEvent():
        return 'UserOrderDeliveryEvent';
      case _i73.UserOrderDetail():
        return 'UserOrderDetail';
      case _i74.UserOrderLineItem():
        return 'UserOrderLineItem';
      case _i75.UserOrderPaymentEvent():
        return 'UserOrderPaymentEvent';
      case _i76.UserOrderPaymentSummary():
        return 'UserOrderPaymentSummary';
      case _i77.UserOrderSummary():
        return 'UserOrderSummary';
      case _i78.UserRole():
        return 'UserRole';
      case _i79.Vendor():
        return 'Vendor';
      case _i80.VendorApplicationDetail():
        return 'VendorApplicationDetail';
      case _i81.VendorApplicationSummary():
        return 'VendorApplicationSummary';
      case _i82.VendorBankDetails():
        return 'VendorBankDetails';
      case _i83.VendorBankDetailsInput():
        return 'VendorBankDetailsInput';
      case _i84.VendorDashboard():
        return 'VendorDashboard';
      case _i85.VendorDocument():
        return 'VendorDocument';
      case _i86.VendorDocumentType():
        return 'VendorDocumentType';
      case _i87.VendorModerationResult():
        return 'VendorModerationResult';
      case _i88.VendorNotificationSummary():
        return 'VendorNotificationSummary';
      case _i89.VendorNotificationType():
        return 'VendorNotificationType';
      case _i90.VendorOrderLineItem():
        return 'VendorOrderLineItem';
      case _i91.VendorOrderSummary():
        return 'VendorOrderSummary';
      case _i92.VendorPaymentsOverview():
        return 'VendorPaymentsOverview';
      case _i93.VendorPayout():
        return 'VendorPayout';
      case _i94.VendorPayoutStatus():
        return 'VendorPayoutStatus';
      case _i95.VendorPayoutSummary():
        return 'VendorPayoutSummary';
      case _i96.VendorProductStat():
        return 'VendorProductStat';
      case _i97.VendorProductUploadInput():
        return 'VendorProductUploadInput';
      case _i98.VendorProfileDetail():
        return 'VendorProfileDetail';
      case _i99.VendorProfileUpdateInput():
        return 'VendorProfileUpdateInput';
      case _i100.VendorReviewSummary():
        return 'VendorReviewSummary';
      case _i101.VendorShopOrder():
        return 'VendorShopOrder';
      case _i102.WishlistItem():
        return 'WishlistItem';
      case _i103.WishlistPage():
        return 'WishlistPage';
    }
    className = _i128.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    className = _i129.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'AdminActionType') {
      return deserialize<_i3.AdminActionType>(data['data']);
    }
    if (dataClassName == 'AdminAuditLog') {
      return deserialize<_i4.AdminAuditLog>(data['data']);
    }
    if (dataClassName == 'AdminAuditLogSummary') {
      return deserialize<_i5.AdminAuditLogSummary>(data['data']);
    }
    if (dataClassName == 'AdminPlatformStats') {
      return deserialize<_i6.AdminPlatformStats>(data['data']);
    }
    if (dataClassName == 'AdminProductComplaintSummary') {
      return deserialize<_i7.AdminProductComplaintSummary>(data['data']);
    }
    if (dataClassName == 'AdminProductDetail') {
      return deserialize<_i8.AdminProductDetail>(data['data']);
    }
    if (dataClassName == 'AdminProductListInput') {
      return deserialize<_i9.AdminProductListInput>(data['data']);
    }
    if (dataClassName == 'AdminProductSummary') {
      return deserialize<_i10.AdminProductSummary>(data['data']);
    }
    if (dataClassName == 'AdminProductVisibilityFilter') {
      return deserialize<_i11.AdminProductVisibilityFilter>(data['data']);
    }
    if (dataClassName == 'AdminRefundRequestSummary') {
      return deserialize<_i12.AdminRefundRequestSummary>(data['data']);
    }
    if (dataClassName == 'AdminType') {
      return deserialize<_i13.AdminType>(data['data']);
    }
    if (dataClassName == 'AdminVendorPayoutSummary') {
      return deserialize<_i14.AdminVendorPayoutSummary>(data['data']);
    }
    if (dataClassName == 'ARSession') {
      return deserialize<_i15.ARSession>(data['data']);
    }
    if (dataClassName == 'Cart') {
      return deserialize<_i16.Cart>(data['data']);
    }
    if (dataClassName == 'CartItem') {
      return deserialize<_i17.CartItem>(data['data']);
    }
    if (dataClassName == 'Category') {
      return deserialize<_i18.Category>(data['data']);
    }
    if (dataClassName == 'ChatMessage') {
      return deserialize<_i19.ChatMessage>(data['data']);
    }
    if (dataClassName == 'ChatMessagePage') {
      return deserialize<_i20.ChatMessagePage>(data['data']);
    }
    if (dataClassName == 'ChatMessageType') {
      return deserialize<_i21.ChatMessageType>(data['data']);
    }
    if (dataClassName == 'CheckoutRequest') {
      return deserialize<_i22.CheckoutRequest>(data['data']);
    }
    if (dataClassName == 'CheckoutResult') {
      return deserialize<_i23.CheckoutResult>(data['data']);
    }
    if (dataClassName == 'Complaint') {
      return deserialize<_i24.Complaint>(data['data']);
    }
    if (dataClassName == 'ComplaintStatus') {
      return deserialize<_i25.ComplaintStatus>(data['data']);
    }
    if (dataClassName == 'Conversation') {
      return deserialize<_i26.Conversation>(data['data']);
    }
    if (dataClassName == 'ConversationPage') {
      return deserialize<_i27.ConversationPage>(data['data']);
    }
    if (dataClassName == 'ConversationSummary') {
      return deserialize<_i28.ConversationSummary>(data['data']);
    }
    if (dataClassName == 'CustomizationRequest') {
      return deserialize<_i29.CustomizationRequest>(data['data']);
    }
    if (dataClassName == 'DeliveryStage') {
      return deserialize<_i30.DeliveryStage>(data['data']);
    }
    if (dataClassName == 'EmailVerificationPending') {
      return deserialize<_i31.EmailVerificationPending>(data['data']);
    }
    if (dataClassName == 'EsewaRefundStatusTrigger') {
      return deserialize<_i32.EsewaRefundStatusTrigger>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i33.Greeting>(data['data']);
    }
    if (dataClassName == 'InAppNotification') {
      return deserialize<_i34.InAppNotification>(data['data']);
    }
    if (dataClassName == 'InAppNotificationSummary') {
      return deserialize<_i35.InAppNotificationSummary>(data['data']);
    }
    if (dataClassName == 'InAppNotificationType') {
      return deserialize<_i36.InAppNotificationType>(data['data']);
    }
    if (dataClassName == 'MarketplaceHighlights') {
      return deserialize<_i37.MarketplaceHighlights>(data['data']);
    }
    if (dataClassName == 'NotificationPreference') {
      return deserialize<_i38.NotificationPreference>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i39.Order>(data['data']);
    }
    if (dataClassName == 'OrderAutoCancelTrigger') {
      return deserialize<_i40.OrderAutoCancelTrigger>(data['data']);
    }
    if (dataClassName == 'OrderDeliveryStatus') {
      return deserialize<_i41.OrderDeliveryStatus>(data['data']);
    }
    if (dataClassName == 'OrderDeliveryUpdate') {
      return deserialize<_i42.OrderDeliveryUpdate>(data['data']);
    }
    if (dataClassName == 'OrderItem') {
      return deserialize<_i43.OrderItem>(data['data']);
    }
    if (dataClassName == 'OrderPage') {
      return deserialize<_i44.OrderPage>(data['data']);
    }
    if (dataClassName == 'OrderPaymentStatus') {
      return deserialize<_i45.OrderPaymentStatus>(data['data']);
    }
    if (dataClassName == 'OrderStatus') {
      return deserialize<_i46.OrderStatus>(data['data']);
    }
    if (dataClassName == 'OrderStatusHistory') {
      return deserialize<_i47.OrderStatusHistory>(data['data']);
    }
    if (dataClassName == 'OrderStatusHistoryType') {
      return deserialize<_i48.OrderStatusHistoryType>(data['data']);
    }
    if (dataClassName == 'OrderVendorPayment') {
      return deserialize<_i49.OrderVendorPayment>(data['data']);
    }
    if (dataClassName == 'PaginationInput') {
      return deserialize<_i50.PaginationInput>(data['data']);
    }
    if (dataClassName == 'PasswordResetToken') {
      return deserialize<_i51.PasswordResetToken>(data['data']);
    }
    if (dataClassName == 'PaymentMethod') {
      return deserialize<_i52.PaymentMethod>(data['data']);
    }
    if (dataClassName == 'PaymentTransaction') {
      return deserialize<_i53.PaymentTransaction>(data['data']);
    }
    if (dataClassName == 'PaymentTransactionStatus') {
      return deserialize<_i54.PaymentTransactionStatus>(data['data']);
    }
    if (dataClassName == 'PaymentUpdateSummary') {
      return deserialize<_i55.PaymentUpdateSummary>(data['data']);
    }
    if (dataClassName == 'PlaceifyException') {
      return deserialize<_i56.PlaceifyException>(data['data']);
    }
    if (dataClassName == 'PlatformUserDetail') {
      return deserialize<_i57.PlatformUserDetail>(data['data']);
    }
    if (dataClassName == 'PlatformUserSummary') {
      return deserialize<_i58.PlatformUserSummary>(data['data']);
    }
    if (dataClassName == 'Product') {
      return deserialize<_i59.Product>(data['data']);
    }
    if (dataClassName == 'ProductPage') {
      return deserialize<_i60.ProductPage>(data['data']);
    }
    if (dataClassName == 'ProductSearchInput') {
      return deserialize<_i61.ProductSearchInput>(data['data']);
    }
    if (dataClassName == 'ProductStatus') {
      return deserialize<_i62.ProductStatus>(data['data']);
    }
    if (dataClassName == 'RefundRequest') {
      return deserialize<_i63.RefundRequest>(data['data']);
    }
    if (dataClassName == 'RefundRequestSummary') {
      return deserialize<_i64.RefundRequestSummary>(data['data']);
    }
    if (dataClassName == 'RequestStatus') {
      return deserialize<_i65.RequestStatus>(data['data']);
    }
    if (dataClassName == 'Review') {
      return deserialize<_i66.Review>(data['data']);
    }
    if (dataClassName == 'ShopListingSummary') {
      return deserialize<_i67.ShopListingSummary>(data['data']);
    }
    if (dataClassName == 'User') {
      return deserialize<_i68.User>(data['data']);
    }
    if (dataClassName == 'UserAccountStatus') {
      return deserialize<_i69.UserAccountStatus>(data['data']);
    }
    if (dataClassName == 'UserArSessionSummary') {
      return deserialize<_i70.UserArSessionSummary>(data['data']);
    }
    if (dataClassName == 'UserDashboard') {
      return deserialize<_i71.UserDashboard>(data['data']);
    }
    if (dataClassName == 'UserOrderDeliveryEvent') {
      return deserialize<_i72.UserOrderDeliveryEvent>(data['data']);
    }
    if (dataClassName == 'UserOrderDetail') {
      return deserialize<_i73.UserOrderDetail>(data['data']);
    }
    if (dataClassName == 'UserOrderLineItem') {
      return deserialize<_i74.UserOrderLineItem>(data['data']);
    }
    if (dataClassName == 'UserOrderPaymentEvent') {
      return deserialize<_i75.UserOrderPaymentEvent>(data['data']);
    }
    if (dataClassName == 'UserOrderPaymentSummary') {
      return deserialize<_i76.UserOrderPaymentSummary>(data['data']);
    }
    if (dataClassName == 'UserOrderSummary') {
      return deserialize<_i77.UserOrderSummary>(data['data']);
    }
    if (dataClassName == 'UserRole') {
      return deserialize<_i78.UserRole>(data['data']);
    }
    if (dataClassName == 'Vendor') {
      return deserialize<_i79.Vendor>(data['data']);
    }
    if (dataClassName == 'VendorApplicationDetail') {
      return deserialize<_i80.VendorApplicationDetail>(data['data']);
    }
    if (dataClassName == 'VendorApplicationSummary') {
      return deserialize<_i81.VendorApplicationSummary>(data['data']);
    }
    if (dataClassName == 'VendorBankDetails') {
      return deserialize<_i82.VendorBankDetails>(data['data']);
    }
    if (dataClassName == 'VendorBankDetailsInput') {
      return deserialize<_i83.VendorBankDetailsInput>(data['data']);
    }
    if (dataClassName == 'VendorDashboard') {
      return deserialize<_i84.VendorDashboard>(data['data']);
    }
    if (dataClassName == 'VendorDocument') {
      return deserialize<_i85.VendorDocument>(data['data']);
    }
    if (dataClassName == 'VendorDocumentType') {
      return deserialize<_i86.VendorDocumentType>(data['data']);
    }
    if (dataClassName == 'VendorModerationResult') {
      return deserialize<_i87.VendorModerationResult>(data['data']);
    }
    if (dataClassName == 'VendorNotificationSummary') {
      return deserialize<_i88.VendorNotificationSummary>(data['data']);
    }
    if (dataClassName == 'VendorNotificationType') {
      return deserialize<_i89.VendorNotificationType>(data['data']);
    }
    if (dataClassName == 'VendorOrderLineItem') {
      return deserialize<_i90.VendorOrderLineItem>(data['data']);
    }
    if (dataClassName == 'VendorOrderSummary') {
      return deserialize<_i91.VendorOrderSummary>(data['data']);
    }
    if (dataClassName == 'VendorPaymentsOverview') {
      return deserialize<_i92.VendorPaymentsOverview>(data['data']);
    }
    if (dataClassName == 'VendorPayout') {
      return deserialize<_i93.VendorPayout>(data['data']);
    }
    if (dataClassName == 'VendorPayoutStatus') {
      return deserialize<_i94.VendorPayoutStatus>(data['data']);
    }
    if (dataClassName == 'VendorPayoutSummary') {
      return deserialize<_i95.VendorPayoutSummary>(data['data']);
    }
    if (dataClassName == 'VendorProductStat') {
      return deserialize<_i96.VendorProductStat>(data['data']);
    }
    if (dataClassName == 'VendorProductUploadInput') {
      return deserialize<_i97.VendorProductUploadInput>(data['data']);
    }
    if (dataClassName == 'VendorProfileDetail') {
      return deserialize<_i98.VendorProfileDetail>(data['data']);
    }
    if (dataClassName == 'VendorProfileUpdateInput') {
      return deserialize<_i99.VendorProfileUpdateInput>(data['data']);
    }
    if (dataClassName == 'VendorReviewSummary') {
      return deserialize<_i100.VendorReviewSummary>(data['data']);
    }
    if (dataClassName == 'VendorShopOrder') {
      return deserialize<_i101.VendorShopOrder>(data['data']);
    }
    if (dataClassName == 'WishlistItem') {
      return deserialize<_i102.WishlistItem>(data['data']);
    }
    if (dataClassName == 'WishlistPage') {
      return deserialize<_i103.WishlistPage>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i128.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i129.Protocol().deserializeByClassName(data);
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
      return _i128.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i129.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
